/**
 * CYBERSUN SIM
 */
/datum/lazy_template/deathmatch/cybersun_sim
	map_dir = "_maps/nova/lazy_templates/deathmatch"
	name = "赛博阳光训练模拟器"
	max_players = 4
	allowed_loadouts = list(/datum/outfit/deathmatch_loadout/cybersun_sim)
	map_name = "cybersun_sim"
	key = "cybersun_sim"

/**
 * DEEPSPACE
 */
/datum/lazy_template/deathmatch/deep_space
	name = "深空"
	desc = "A deep-space cargo shipping station has fallen under attack by both a Syndicate boarding party and an Azulean pirate raid."
	allowed_loadouts = list(/datum/outfit/deathmatch_loadout/cargo_spaceman, /datum/outfit/deathmatch_loadout/azulean, /datum/outfit/deathmatch_loadout/syndicate_spaceman, /datum/outfit/deathmatch_loadout/spacetider)
