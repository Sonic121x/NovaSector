/*
 * Offline GeoIP lookup for the newbie guard.
 *
 * BYOND numbers are single-precision floats, so a whole IPv4 address (up to 4294967295)
 * cannot be held exactly. The generator therefore buckets every range by its first octet
 * and stores the remaining 24 bits (max 16777215, which is exactly representable).
 * Ranges that straddle an octet boundary are split by the generator, so a bucket is always
 * a flat, sorted, non-overlapping list of `low, high, low, high, ...`.
 */

/// Assoc list of "first octet" -> flat sorted list of 24-bit range bounds.
GLOBAL_LIST_EMPTY(newbie_guard_geo_buckets)
/// Set once we have attempted a load, successful or not.
GLOBAL_VAR_INIT(newbie_guard_geo_loaded, FALSE)
/// Number of ranges in the loaded table. Zero means the table is unusable.
GLOBAL_VAR_INIT(newbie_guard_geo_ranges, 0)
/// Human readable description of where the table came from, for the admin verbs.
GLOBAL_VAR_INIT(newbie_guard_geo_source, "未加载")

/**
 * Loads the generated GeoIP table into memory.
 *
 * Returns the number of ranges loaded. Zero means no usable table, in which case the
 * guard fails open and never restricts anybody on region grounds.
 */
/proc/newbie_guard_load_geoip(force = FALSE)
	if(GLOB.newbie_guard_geo_loaded && !force)
		return GLOB.newbie_guard_geo_ranges

	GLOB.newbie_guard_geo_loaded = TRUE
	GLOB.newbie_guard_geo_buckets = list()
	GLOB.newbie_guard_geo_ranges = 0
	GLOB.newbie_guard_geo_source = "未加载"

	var/table_file = file(NEWBIE_GUARD_GEOIP_PATH)
	if(!fexists(table_file))
		GLOB.newbie_guard_geo_source = "缺失（[NEWBIE_GUARD_GEOIP_PATH] 未随仓库部署？）"
		return 0

	var/list/decoded
	try
		decoded = json_decode(file2text(table_file))
	catch
		GLOB.newbie_guard_geo_source = "解析失败（[NEWBIE_GUARD_GEOIP_PATH] 不是合法 JSON）"
		return 0

	if(!islist(decoded) || !islist(decoded["buckets"]))
		GLOB.newbie_guard_geo_source = "格式错误（[NEWBIE_GUARD_GEOIP_PATH] 缺少 buckets 字段）"
		return 0

	var/list/buckets = decoded["buckets"]
	var/total = 0
	for(var/octet_key in buckets)
		var/list/bounds = buckets[octet_key]
		if(!islist(bounds) || !length(bounds) || (length(bounds) % 2))
			continue
		GLOB.newbie_guard_geo_buckets[octet_key] = bounds
		total += length(bounds) / 2

	GLOB.newbie_guard_geo_ranges = total
	if(!total)
		GLOB.newbie_guard_geo_source = "表为空（[NEWBIE_GUARD_GEOIP_PATH]）"
		return 0

	var/list/meta = islist(decoded["meta"]) ? decoded["meta"] : list()
	GLOB.newbie_guard_geo_source = "[meta["country"] || "?"] / [total] 段 / 生成于 [meta["generated"] || "未知时间"]"
	return total

/**
 * Drops the table from memory.
 *
 * A full country table is on the order of ten thousand ranges; there is no reason to keep
 * that resident for the rest of the shift once an admin has switched the guard off.
 */
/proc/newbie_guard_unload_geoip()
	GLOB.newbie_guard_geo_buckets = list()
	GLOB.newbie_guard_geo_loaded = FALSE
	GLOB.newbie_guard_geo_ranges = 0
	GLOB.newbie_guard_geo_source = "未加载"

/**
 * TRUE if `address` falls inside the loaded region table.
 *
 * Fails open on every uncertainty: no table, unparseable address, loopback and private
 * ranges all count as in-region. A guard that silently restricts everyone because a data
 * file went missing is far worse than one that restricts nobody.
 */
/proc/newbie_guard_address_in_region(address)
	if(!GLOB.newbie_guard_geo_loaded)
		newbie_guard_load_geoip()
	if(!GLOB.newbie_guard_geo_ranges)
		return TRUE
	if(!istext(address) || !length(address))
		return TRUE

	var/list/octets = splittext(address, ".")
	if(length(octets) != 4)
		return TRUE // Not dotted-quad IPv4 (local client, IPv6, whatever) - do not guess.

	var/list/parsed = list()
	for(var/piece in octets)
		var/value = text2num(piece)
		if(isnull(value) || value < 0 || value > 255 || value != round(value))
			return TRUE
		parsed += value

	// Loopback and RFC1918 are always treated as in-region: hosting box, LAN testing, admins.
	if(parsed[1] == 127 || parsed[1] == 10)
		return TRUE
	if(parsed[1] == 192 && parsed[2] == 168)
		return TRUE
	if(parsed[1] == 172 && parsed[2] >= 16 && parsed[2] <= 31)
		return TRUE

	var/list/bounds = GLOB.newbie_guard_geo_buckets["[parsed[1]]"]
	if(!length(bounds))
		return FALSE

	var/key = (parsed[2] * 65536) + (parsed[3] * 256) + parsed[4]
	var/low = 1
	var/high = length(bounds) / 2
	while(low <= high)
		var/mid = round((low + high) / 2)
		var/range_low = bounds[(mid * 2) - 1]
		var/range_high = bounds[mid * 2]
		if(key < range_low)
			high = mid - 1
		else if(key > range_high)
			low = mid + 1
		else
			return TRUE
	return FALSE
