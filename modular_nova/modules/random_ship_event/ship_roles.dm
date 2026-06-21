//ship crew from the random ship event.

/obj/effect/mob_spawn/ghost_role/human/ship_crew
	name = "飞船船员休眠舱"
	desc = "一个供飞船船员使用的低温休眠舱。"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	prompt_name = "一名舰船船员"
	outfit = /datum/outfit/ship_crew
	anchored = TRUE
	density = FALSE
	show_flavor = FALSE //Flavour only exists for spawners menu
	you_are_text = "你是一艘舰船的船员。"
	flavour_text = "你是一艘舰船船员的一部分。遵循舰长的命令并完成你的任务。"
	spawner_job_path = /datum/job/ship_crew
	///Rank of the crew member on the ship, it's used in generating names!
	var/rank = "Crewman"
	///Path of the structure we spawn after creating a crew member.
	var/fluff_spawn = /obj/structure/showcase/machinery/oldpod/used

	//obviously, these name vars are only used if you don't override `generate_crew_name()`
	///json key to crew names, the first part ("Comet" in "Cometfish")
	var/name_beginnings = "generic_beginnings"
	///json key to crew names, the last part ("fish" in "Cometfish")
	var/name_endings = "generic_endings"

/obj/effect/mob_spawn/ghost_role/human/ship_crew/special(mob/living/spawned_mob, mob/mob_possessor, apply_prefs)
	. = ..()
	spawned_mob.fully_replace_character_name(spawned_mob.real_name, generate_crew_name(spawned_mob.gender))
	spawned_mob.mind.add_antag_datum(/datum/antagonist/ship_crew)

/obj/effect/mob_spawn/ghost_role/human/ship_crew/proc/generate_crew_name(spawn_gender)
	var/beggings = strings(PIRATE_NAMES_FILE, name_beginnings)
	var/endings = strings(PIRATE_NAMES_FILE, name_endings)
	return "[rank ? rank + " " : ""][pick(beggings)][pick(endings)]"

/obj/effect/mob_spawn/ghost_role/human/ship_crew/create(mob/mob_possessor, newname, apply_prefs)
	if(fluff_spawn)
		new fluff_spawn(drop_location())
	return ..()

/obj/effect/mob_spawn/ghost_role/human/ship_crew/captain
	rank = "Captain"
	outfit = /datum/outfit/ship_crew/captain

/obj/effect/mob_spawn/ghost_role/human/ship_crew/engineer
	rank = "Engineer"
	outfit = /datum/outfit/ship_crew

/obj/effect/mob_spawn/ghost_role/human/ship_crew/gunner
	rank = "Gunner"

/obj/effect/mob_spawn/ghost_role/human/ship_crew/rogue_trader
	name = "浪迹商人休眠舱"
	desc = "一个散发着淡淡朗姆酒味的低温休眠舱。"
	prompt_name = "一名不法商人"
	outfit = /datum/outfit/ship_crew/rogue_trader
	you_are_text = "你是一名不法商人。"
	flavour_text = "你是一名寻求利润的不法商人。与空间站交易，或用武力夺取你所需之物。"

/obj/effect/mob_spawn/ghost_role/human/ship_crew/rogue_trader/captain
	rank = "Trader Captain"
	outfit = /datum/outfit/ship_crew/rogue_trader

/obj/effect/mob_spawn/ghost_role/human/ship_crew/rogue_trader/crew
	rank = "Trader"
