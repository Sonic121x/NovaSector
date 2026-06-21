
//space pirates from the pirate event.

/obj/effect/mob_spawn/ghost_role/human/pirate
	name = "太空海盗休眠舱"
	desc = "一个散发着淡淡朗姆酒味的低温睡眠舱。"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	prompt_name = "一名太空海盗"
	outfit = /datum/outfit/pirate/space
	anchored = TRUE
	density = FALSE
	show_flavor = FALSE //Flavour only exists for spawners menu
	you_are_text = "你是一名太空海盗。"
	flavour_text = "空间站拒绝支付你们的保护费。保护好你们的船，从空间站榨取信用点，并突袭它以掠夺更多战利品。"
	spawner_job_path = /datum/job/space_pirate
	allow_custom_character = GHOSTROLE_TAKE_PREFS_APPEARANCE
	///Rank of the pirate on the ship, it's used in generating pirate names!
	var/rank = "Deserter"
	///Path of the structure we spawn after creating a pirate.
	var/fluff_spawn = /obj/structure/showcase/machinery/oldpod/used

	//obviously, these pirate name vars are only used if you don't override `generate_pirate_name()`
	///json key to pirate names, the first part ("Comet" in "Cometfish")
	var/name_beginnings = "generic_beginnings"
	///json key to pirate names, the last part ("fish" in "Cometfish")
	var/name_endings = "generic_endings"

/obj/effect/mob_spawn/ghost_role/human/pirate/special(mob/living/spawned_mob, mob/mob_possessor, apply_prefs)
	. = ..()
	spawned_mob.fully_replace_character_name(spawned_mob.real_name, generate_pirate_name(spawned_mob.gender))
	spawned_mob.mind.add_antag_datum(/datum/antagonist/pirate)

/obj/effect/mob_spawn/ghost_role/human/pirate/proc/generate_pirate_name(spawn_gender)
	var/beggings = strings(PIRATE_NAMES_FILE, name_beginnings)
	var/endings = strings(PIRATE_NAMES_FILE, name_endings)
	return "[rank ? rank + " " : ""][pick(beggings)][pick(endings)]"

/obj/effect/mob_spawn/ghost_role/human/pirate/create(mob/mob_possessor, newname, apply_prefs)
	if(fluff_spawn)
		new fluff_spawn(drop_location())
	return ..()

/obj/effect/mob_spawn/ghost_role/human/pirate/captain
	rank = "Renegade Leader"
	outfit = /datum/outfit/pirate/space/captain

/obj/effect/mob_spawn/ghost_role/human/pirate/gunner
	rank = "Rogue"

/obj/effect/mob_spawn/ghost_role/human/pirate/skeleton
	name = "海盗遗骸"
	desc = "一些无生命的骨头。它们给人的感觉像是随时都可能活过来！"
	density = FALSE
	icon = 'icons/effects/blood.dmi'
	icon_state = "remains"
	prompt_name = "一名骷髅海盗"
	mob_species = /datum/species/skeleton
	outfit = /datum/outfit/pirate
	rank = "Mate"
	fluff_spawn = null
	allow_custom_character = NONE

/obj/effect/mob_spawn/ghost_role/human/pirate/skeleton/captain
	rank = "Captain"
	outfit = /datum/outfit/pirate/captain/skeleton

/obj/effect/mob_spawn/ghost_role/human/pirate/skeleton/gunner
	rank = "Gunner"

/obj/effect/mob_spawn/ghost_role/human/pirate/silverscale
	name = "雅致的睡眠舱"
	desc = "很舒适。不过你感觉你不应该在这里……"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	prompt_name = "一名银鳞海盗"
	mob_species = /datum/species/lizard/silverscale
	outfit = /datum/outfit/pirate/silverscale
	rank = "High-born"
	allow_custom_character = NONE

/obj/effect/mob_spawn/ghost_role/human/pirate/silverscale/generate_pirate_name(spawn_gender)
	var/first_name
	switch(spawn_gender)
		if(MALE)
			first_name = pick(GLOB.lizard_names_male)
		if(FEMALE)
			first_name = pick(GLOB.lizard_names_female)
		else
			first_name = pick(GLOB.lizard_names_male + GLOB.lizard_names_female)

	return "[rank] [first_name]-Silverscale"

/obj/effect/mob_spawn/ghost_role/human/pirate/silverscale/captain
	rank = "Old-guard"
	outfit = /datum/outfit/pirate/silverscale/captain

/obj/effect/mob_spawn/ghost_role/human/pirate/silverscale/gunner
	rank = "Top-drawer"

/obj/effect/mob_spawn/ghost_role/human/pirate/interdyne
	name = "\improper Interdyne 睡眠舱"
	desc = "一个异常干净的低温睡眠舱。你甚至能在舱壁上看到自己的倒影！"
	density = FALSE
	you_are_text = "你曾是一名英特戴恩药剂师，如今转行成了太空海盗。"
	flavour_text = "The station has refused to fund your research, so you will 'convince' them to donate to your charitable cause."
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	prompt_name = "一名前英特戴恩雇员"
	outfit = /datum/outfit/pirate/interdyne
	rank = "Pharmacist"

/obj/effect/mob_spawn/ghost_role/human/pirate/interdyne/generate_pirate_name(spawn_gender)
	var/first_name
	switch(spawn_gender)
		if(MALE)
			first_name = pick(GLOB.first_names_male)
		if(FEMALE)
			first_name = pick(GLOB.first_names_female)
		else
			first_name = pick(GLOB.first_names)

	return "[rank] [first_name]"

/obj/effect/mob_spawn/ghost_role/human/pirate/interdyne/senior
	rank = "Pharmacist Director"
	outfit = /datum/outfit/pirate/interdyne/captain

/obj/effect/mob_spawn/ghost_role/human/pirate/interdyne/junior
	rank = "Pharmacist"

/obj/effect/mob_spawn/ghost_role/human/pirate/grey
	name = "\improper 助理睡眠舱"
	desc = "一个非常肮脏的低温睡眠舱。你都不确定它还能不能用。"
	density = FALSE
	you_are_text = "你曾是纳米传讯的一名助手，直到一场失控的骚乱。如今你在太空中游荡，劫掠遇到的每一艘船！"
	flavour_text = "没有什么是一个工具箱敲脑袋敲到出血解决不了的，或者在这种情况下，是敲到出钱。把一切都抢光！"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	prompt_name = "一名失控的助手"
	outfit = /datum/outfit/pirate/grey
	rank = "Tider"

/obj/effect/mob_spawn/ghost_role/human/pirate/grey/shitter
	rank = "Tidemaster"

/obj/effect/mob_spawn/ghost_role/human/pirate/irs
	name = "\improper 太空IRS睡眠舱"
	desc = "一个异常干净的低温睡眠舱。你甚至能在舱壁上看到自己的倒影！"
	density = FALSE
	you_are_text = "你是一名为太空国税局工作的特工"
	flavour_text = "即便在扩张宇宙的广袤之中，也无人能逃过收税员！无论你只是一个纪律严明的专业海盗团伙，还是来自当地政权的真正特工。无论如何，你都要榨干空间站的收入！通过和平手段或其他方式..."
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	prompt_name = "太空国税局的一名特工"
	outfit = /datum/outfit/pirate/irs
	fluff_spawn = null // dirs are fucked and I don't have the energy to deal with it
	rank = "Agent"

/obj/effect/mob_spawn/ghost_role/human/pirate/irs/generate_pirate_name(spawn_gender)
	var/first_name
	switch(spawn_gender)
		if(MALE)
			first_name = pick(GLOB.first_names_male)
		if(FEMALE)
			first_name = pick(GLOB.first_names_female)
		else
			first_name = pick(GLOB.first_names)

	return "[rank] [first_name]"


/obj/effect/mob_spawn/ghost_role/human/pirate/irs/auditor
	rank = "Head Auditor"
	outfit = /datum/outfit/pirate/irs/auditor

/obj/effect/mob_spawn/ghost_role/human/pirate/lustrous
	name = "光泽水晶"
	desc = "一块囚禁着变异以太体的水晶，散发着不祥的光芒。"
	density = FALSE
	you_are_text = "你曾是骄傲的虚灵族，如今只剩下对珍贵蓝空晶体的渴望。"
	flavour_text = "空间站拒绝给你蓝空晶体，那第五维度的甜美珍馐。向大地开战吧！"
	icon = 'icons/mob/effects/ethereal_crystal.dmi'
	icon_state = "ethereal_crystal"
	fluff_spawn = null
	prompt_name = "一个晶洞居民"
	mob_species = /datum/species/ethereal/lustrous
	outfit = /datum/outfit/pirate/lustrous
	rank = "Scintillant"
	allow_custom_character = NONE

/obj/effect/mob_spawn/ghost_role/human/pirate/lustrous/captain
	rank = "Radiant"
	outfit = /datum/outfit/pirate/lustrous/captain

/obj/effect/mob_spawn/ghost_role/human/pirate/lustrous/gunner
	rank = "Coruscant"

/obj/effect/mob_spawn/ghost_role/human/pirate/medieval
	name = "\improper 临时睡眠舱"
	desc = "一个戳了几个洞的裹尸袋，目前被当作睡袋使用。里面似乎有人在睡觉。"
	density = FALSE
	you_are_text = "你曾是个无名小卒，直到你得到了一把剑和晋升的机会。如果你努力一把，就能成就一番事业！"
	flavour_text = "一边袭击一些蠢货，一边进行血腥运动和暴力？多划算的买卖。团结起来，掠夺一切！"
	icon = 'icons/obj/medical/bodybag.dmi'
	icon_state = "bodybag"
	fluff_spawn = null
	prompt_name = "一个中世纪的好战分子"
	outfit = /datum/outfit/pirate/medieval
	rank = "Footsoldier"

/obj/effect/mob_spawn/ghost_role/human/pirate/medieval/special(mob/living/carbon/spawned_mob, mob/mob_possessor, apply_prefs)
	. = ..()
	if(rank == "Footsoldier")
		spawned_mob.add_traits(list(TRAIT_NOGUNS, TRAIT_TOSS_GUN_HARD), INNATE_TRAIT)
		spawned_mob.AddComponent(/datum/component/unbreakable)
		var/datum/action/cooldown/mob_cooldown/dash/dodge = new(spawned_mob)
		dodge.Grant(spawned_mob)

/obj/effect/mob_spawn/ghost_role/human/pirate/medieval/warlord
	rank = "Warlord"
	outfit = /datum/outfit/pirate/medieval/warlord

/obj/effect/mob_spawn/ghost_role/human/pirate/medieval/warlord/special(mob/living/carbon/spawned_mob, mob/mob_possessor, apply_prefs)
	. = ..()
	spawned_mob.dna.add_mutation(/datum/mutation/hulk/superhuman, MUTATION_SOURCE_GHOST_ROLE)
	spawned_mob.dna.add_mutation(/datum/mutation/gigantism, MUTATION_SOURCE_GHOST_ROLE)
