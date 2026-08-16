#!/usr/bin/env node
/**
 * Converts a mihomo / v2ray `geoip.dat` (or a plain CIDR list) into the bucketed lookup
 * table the newbie guard reads at runtime.
 *
 * Usage:
 *   node tools/geoip/mihomo-geoip.mjs --input geoip.dat --country CN
 *   node tools/geoip/mihomo-geoip.mjs --input cn.txt --country CN   # one CIDR per line
 *
 * Why bucketed: BYOND numbers are single-precision floats, so a full 32-bit IPv4 value
 * cannot be stored exactly. Every range is therefore split on its first octet and the
 * remaining 24 bits (max 16777215) are stored, which single precision represents exactly.
 *
 * geoip.dat is protobuf:
 *   GeoIPList { repeated GeoIP entry = 1; }
 *   GeoIP     { string country_code = 1; repeated CIDR cidr = 2; bool inverse_match = 3; }
 *   CIDR      { bytes ip = 1; uint32 prefix = 2; }
 */

import { readFileSync, writeFileSync, mkdirSync } from 'node:fs';
import { basename, dirname } from 'node:path';

// The repo-tracked table, so a fresh checkout ships a working feature. `data/` is
// gitignored, so a table written there would never reach a deployed server.
const DEFAULT_OUTPUT = 'modular_nova/modules/region_newbie_guard/data/allowed_regions.json';

function parseArgs(argv) {
  const args = { country: 'CN', output: DEFAULT_OUTPUT };
  for (let i = 0; i < argv.length; i++) {
    const key = argv[i];
    if (key === '--input' || key === '-i') args.input = argv[++i];
    else if (key === '--country' || key === '-c') args.country = argv[++i].toUpperCase();
    else if (key === '--output' || key === '-o') args.output = argv[++i];
    else if (key === '--help' || key === '-h') args.help = true;
    else throw new Error(`Unknown argument: ${key}`);
  }
  return args;
}

/** Minimal protobuf wire-format reader. Only what the geoip schema needs. */
class Reader {
  constructor(buf) {
    this.buf = buf;
    this.pos = 0;
  }
  get done() {
    return this.pos >= this.buf.length;
  }
  varint() {
    let result = 0;
    let shift = 0;
    for (;;) {
      if (this.pos >= this.buf.length) throw new Error('truncated varint');
      const byte = this.buf[this.pos++];
      result += (byte & 0x7f) * 2 ** shift;
      if ((byte & 0x80) === 0) return result;
      shift += 7;
      if (shift > 63) throw new Error('varint too long');
    }
  }
  /** Returns {field, wire}. */
  tag() {
    const key = this.varint();
    return { field: key >>> 3, wire: key & 0x07 };
  }
  bytes() {
    const len = this.varint();
    const slice = this.buf.subarray(this.pos, this.pos + len);
    if (slice.length !== len) throw new Error('truncated length-delimited field');
    this.pos += len;
    return slice;
  }
  /** Skips a field we do not care about. */
  skip(wire) {
    switch (wire) {
      case 0:
        this.varint();
        break;
      case 1:
        this.pos += 8;
        break;
      case 2:
        this.bytes();
        break;
      case 5:
        this.pos += 4;
        break;
      default:
        throw new Error(`unsupported wire type ${wire}`);
    }
  }
}

function parseCidrMessage(buf) {
  const reader = new Reader(buf);
  let ip = null;
  let prefix = null;
  while (!reader.done) {
    const { field, wire } = reader.tag();
    if (field === 1 && wire === 2) ip = reader.bytes();
    else if (field === 2 && wire === 0) prefix = reader.varint();
    else reader.skip(wire);
  }
  return { ip, prefix };
}

function parseGeoIpEntry(buf) {
  const reader = new Reader(buf);
  let country = null;
  const cidrs = [];
  while (!reader.done) {
    const { field, wire } = reader.tag();
    if (field === 1 && wire === 2) country = Buffer.from(reader.bytes()).toString('utf8');
    else if (field === 2 && wire === 2) cidrs.push(parseCidrMessage(reader.bytes()));
    else reader.skip(wire);
  }
  return { country, cidrs };
}

/** Returns the list of {ip: Uint8Array, prefix} for `country`, or null if absent. */
function parseGeoIpDat(buf, country) {
  const reader = new Reader(buf);
  const available = [];
  while (!reader.done) {
    const { field, wire } = reader.tag();
    if (field === 1 && wire === 2) {
      const entry = parseGeoIpEntry(reader.bytes());
      const code = (entry.country || '').toUpperCase();
      available.push(code);
      if (code === country) return { cidrs: entry.cidrs, available };
    } else {
      reader.skip(wire);
    }
  }
  return { cidrs: null, available };
}

function parsePlainList(text) {
  const cidrs = [];
  for (const rawLine of text.split(/\r?\n/)) {
    const line = rawLine.split('#')[0].trim();
    if (!line) continue;
    const match = /^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})(?:\/(\d{1,2}))?$/.exec(line);
    if (!match) continue;
    const octets = match.slice(1, 5).map(Number);
    if (octets.some((value) => value > 255)) continue;
    const prefix = match[5] === undefined ? 32 : Number(match[5]);
    if (prefix > 32) continue;
    cidrs.push({ ip: Uint8Array.from(octets), prefix });
  }
  return cidrs;
}

/** {ip, prefix} -> [startInclusive, endInclusive] as plain 32-bit numbers. */
function cidrToRange({ ip, prefix }) {
  if (!ip || ip.length !== 4) return null; // IPv6 or malformed; the guard is IPv4-only.
  const effectivePrefix = prefix === null || prefix === undefined ? 32 : prefix;
  if (effectivePrefix < 0 || effectivePrefix > 32) return null;
  const base = ip[0] * 2 ** 24 + ip[1] * 2 ** 16 + ip[2] * 2 ** 8 + ip[3];
  const size = 2 ** (32 - effectivePrefix);
  const start = Math.floor(base / size) * size;
  return [start, start + size - 1];
}

function mergeRanges(ranges) {
  ranges.sort((a, b) => a[0] - b[0] || a[1] - b[1]);
  const merged = [];
  for (const [start, end] of ranges) {
    const last = merged[merged.length - 1];
    // `start <= last[1] + 1` also fuses ranges that merely touch, keeping the table small.
    if (last && start <= last[1] + 1) {
      if (end > last[1]) last[1] = end;
    } else {
      merged.push([start, end]);
    }
  }
  return merged;
}

/** Splits merged 32-bit ranges into per-first-octet buckets of 24-bit bounds. */
function bucketise(ranges) {
  const buckets = {};
  for (const [start, end] of ranges) {
    let cursor = start;
    while (cursor <= end) {
      const octet = Math.floor(cursor / 2 ** 24);
      const octetEnd = (octet + 1) * 2 ** 24 - 1;
      const sliceEnd = Math.min(end, octetEnd);
      const key = String(octet);
      if (!buckets[key]) buckets[key] = [];
      buckets[key].push(cursor - octet * 2 ** 24, sliceEnd - octet * 2 ** 24);
      cursor = sliceEnd + 1;
    }
  }
  return buckets;
}

function main() {
  const args = parseArgs(process.argv.slice(2));

  if (args.help || !args.input) {
    console.log(
      [
        'Usage: node tools/geoip/mihomo-geoip.mjs --input <geoip.dat|list.txt> [--country CN] [--output PATH]',
        '',
        `  --country  Country code to extract (default CN)`,
        `  --output   Where to write the table (default ${DEFAULT_OUTPUT})`,
        '',
        'Accepts a mihomo/v2ray geoip.dat, or a plain text file with one CIDR per line.',
      ].join('\n'),
    );
    process.exit(args.help ? 0 : 1);
  }

  const raw = readFileSync(args.input);
  let cidrs;

  const looksLikeText = raw.subarray(0, 512).every((byte) => byte === 9 || byte === 10 || byte === 13 || (byte >= 32 && byte < 127));
  if (looksLikeText) {
    cidrs = parsePlainList(raw.toString('utf8'));
    if (!cidrs.length) {
      console.error(`No usable CIDR lines found in ${args.input}.`);
      process.exit(1);
    }
  } else {
    const { cidrs: found, available } = parseGeoIpDat(raw, args.country);
    if (!found) {
      const preview = [...new Set(available)].sort().slice(0, 40).join(', ');
      console.error(`Country ${args.country} not present in ${args.input}.`);
      console.error(`Available codes include: ${preview}${available.length > 40 ? ', ...' : ''}`);
      process.exit(1);
    }
    cidrs = found;
  }

  const ranges = [];
  let skipped = 0;
  for (const cidr of cidrs) {
    const range = cidrToRange(cidr);
    if (range) ranges.push(range);
    else skipped++;
  }

  if (!ranges.length) {
    console.error('No IPv4 ranges produced; refusing to write an empty table.');
    process.exit(1);
  }

  const merged = mergeRanges(ranges);
  const buckets = bucketise(merged);

  const bucketedCount = Object.values(buckets).reduce((sum, list) => sum + list.length / 2, 0);
  const table = {
    meta: {
      country: args.country,
      // Basename only: the full path is machine-specific and this file is committed.
      source: basename(args.input),
      generated: new Date().toISOString().slice(0, 19).replace('T', ' '),
      ranges: bucketedCount,
    },
    buckets,
  };

  mkdirSync(dirname(args.output), { recursive: true });
  writeFileSync(args.output, JSON.stringify(table));

  console.log(`Wrote ${args.output}`);
  console.log(`  country       ${args.country}`);
  console.log(`  input CIDRs   ${cidrs.length}${skipped ? ` (${skipped} non-IPv4 skipped)` : ''}`);
  console.log(`  merged ranges ${merged.length}`);
  console.log(`  bucketed rows ${bucketedCount} across ${Object.keys(buckets).length} first-octet buckets`);
}

main();
