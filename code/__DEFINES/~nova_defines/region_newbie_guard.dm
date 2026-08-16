/// Trait source used for every restriction the newbie guard applies.
#define NEWBIE_GUARD_TRAIT "newbie_guard"

/*
 * The GeoIP lookup table, committed to the repository and shipped with every deployment.
 *
 * Single source of truth on purpose: the table travels with the code, so every instance
 * runs the same one and it updates the same way everything else does - by updating the
 * repo. There is deliberately no `data/` override; `data/` is gitignored, so a table put
 * there would never reach a deployed server and would only ever produce a silent mismatch
 * between what one machine enforces and what the repo says it enforces.
 *
 * Regenerate with `node tools/geoip/mihomo-geoip.mjs` and commit the result.
 */
#define NEWBIE_GUARD_GEOIP_PATH "modular_nova/modules/region_newbie_guard/data/allowed_regions.json"

/// Admin-approved appeal bypasses, persisted across rounds.
#define NEWBIE_GUARD_BYPASS_PATH "data/newbie_guard_bypass.json"

/// How often the shared survival timer ticks. Progress is counted in whole minutes.
#define NEWBIE_GUARD_TICK (1 MINUTES)

/// A player may only file one appeal per this long, to keep adminhelp readable.
#define NEWBIE_GUARD_APPEAL_COOLDOWN (5 MINUTES)

/// Minimum gap between two "you can't do that" messages, so spam-clicking cannot flood chat.
#define NEWBIE_GUARD_REFUSAL_COOLDOWN (3 SECONDS)

/*
 * Return values of [/datum/component/newbie_guard/proc/get_refusal].
 *
 * The click handler runs on every single click a restricted player makes, so it returns a
 * code rather than a formatted string: building the message (and its two translations) is
 * deferred until we have actually decided to show it.
 */
#define NEWBIE_GUARD_REFUSE_NONE 0
/// The held item is outright forbidden (explosives, rapid construction devices).
#define NEWBIE_GUARD_REFUSE_ITEM 1
/// The target is a piece of high-value infrastructure.
#define NEWBIE_GUARD_REFUSE_TARGET 2
/// A deconstruction tool is being used on machinery or structure.
#define NEWBIE_GUARD_REFUSE_TOOL 3
