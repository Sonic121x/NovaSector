
/obj/effect/mob_spawn/ghost_role/human/fugitive
	spawner_job_path = /datum/job/fugitive_hunter
	prompt_name = "给我写点该死的提示名称！"
	you_are_text = "给我写点该死的身份描述文本！"
	flavour_text = "给我写点该死的背景故事文本！" //the flavor text will be the backstory argument called on the antagonist's greet, see hunter.dm for details
	show_flavor = FALSE
	var/back_story = "error"
	allow_custom_character = GHOSTROLE_TAKE_PREFS_APPEARANCE

/obj/effect/mob_spawn/ghost_role/human/fugitive/special(mob/living/carbon/human/spawned_human, mob/mob_possessor, apply_prefs)
	. = ..()
	var/datum/antagonist/fugitive_hunter/fughunter = new
	fughunter.backstory = back_story
	spawned_human.mind.add_antag_datum(fughunter)
	fughunter.greet()
	message_admins("[ADMIN_LOOKUPFLW(spawned_human)] has been made into a Fugitive Hunter by an event.")
	spawned_human.log_message("was spawned as a Fugitive Hunter by an event.", LOG_GAME)

/obj/effect/mob_spawn/ghost_role/human/fugitive/spacepol
	name = "警察舱"
	desc = "一种小型睡眠舱，通常用于让人在任务简报前进入睡眠状态。"
	prompt_name = "一名太空警察"
	you_are_text = "我是太空警察的一员！"
	flavour_text = "正义已至。我们必须抓住潜伏在那座空间站上的逃犯！"
	back_story = HUNTER_PACK_COPS
	outfit = /datum/outfit/spacepol
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"

/obj/effect/mob_spawn/ghost_role/human/fugitive/russian
	name = "俄罗斯舱"
	desc = "一种小型的便携式睡袋，通常用于让长途旅行变得稍微舒适一些。"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	faction = list(FACTION_RUSSIAN)
	prompt_name = "一名太空俄罗斯人"
	you_are_text = "哎，该死的。我是个太空俄罗斯走私犯！"
	flavour_text = "We were mid-flight when our cargo was beamed off our ship! Must be on station somewhere? \
		We must \"legally\" reaquire it by any means necessary - is our property, after all!"
	back_story = HUNTER_PACK_RUSSIAN
	outfit = /datum/outfit/russian_hunter

/obj/effect/mob_spawn/ghost_role/human/fugitive/russian/leader
	name = "俄罗斯指挥官舱"
	you_are_text = "哎，该死的。我是太空俄罗斯走私团伙的头目！"
	outfit = /datum/outfit/russian_hunter/leader

/obj/effect/mob_spawn/ghost_role/human/fugitive/bounty
	name = "赏金猎人舱"
	prompt_name = "一名赏金猎人"
	you_are_text = "我是个赏金猎人。"
	flavour_text = "我们接到了一份关于几个逃犯的新悬赏，死活不论。"
	back_story = HUNTER_PACK_BOUNTY
	desc = "一种小型的便携式睡袋，通常用于让长途旅行变得稍微舒适一些。"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"

/obj/effect/mob_spawn/ghost_role/human/fugitive/bounty/Destroy()
	var/obj/structure/fluff/empty_sleeper/S = new(drop_location())
	S.setDir(dir)
	return ..()

/obj/effect/mob_spawn/ghost_role/human/fugitive/bounty/armor
	outfit = /datum/outfit/bountyarmor

/obj/effect/mob_spawn/ghost_role/human/fugitive/bounty/hook
	outfit = /datum/outfit/bountyhook

/obj/effect/mob_spawn/ghost_role/human/fugitive/bounty/synth
	outfit = /datum/outfit/bountysynth

/obj/effect/mob_spawn/ghost_role/human/fugitive/psyker
	name = "精神充能器"
	desc = "一种经过改造的低温睡眠舱，旨在保持乘员思维敏锐。不管它是怎么运作的……"
	icon_state = "psykerpod"
	prompt_name = "一名灵能者"
	you_are_text = "啊哈哈哈！我是一名灵能者希卡里！"
	flavour_text = "Man, waking up from a gorenap always BLOWS. Finding dealers in this sector of space is always difficult, but \
		we've received an offer that might set us up for life! Kidnap some fugitives and get FREE GORE!"
	back_story = HUNTER_PACK_PSYKER
	outfit = /datum/outfit/psyker

/obj/effect/mob_spawn/ghost_role/human/fugitive/psyker/captain
	prompt_name = "一名灵能者舰长"
	back_story = HUNTER_PACK_PSYKER
	outfit = /datum/outfit/psyker/captain

/obj/effect/mob_spawn/ghost_role/human/fugitive/psyker/seer
	name = "低温休眠舱"
	desc = "一个肮脏、维护不善，但仍属普通的低温休眠舱。"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	prompt_name = "一名灵能者先知"
	you_are_text = "呃，我是灵能者先知。"
	flavour_text = "Oh great, the fortunte-tellers want my help with something again. They picked me up while I was space-hitchhiking, said they would take me anywhere \
		if I assisted them with my 'flesh-gaze'. They're a bunch of freaks, but at least they leave me be after I'm done helping them..."
	back_story = HUNTER_PACK_PSYKER
	outfit = /datum/outfit/psyker_seer

/obj/effect/mob_spawn/ghost_role/human/fugitive/mi13
	name = "绝密舱体"
	desc = "你的权限等级不足以知晓此舱体内含物或其用途。"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper_s"
	prompt_name = "一名MI13特工"
	you_are_text = "我是MI13派来的特工。"
	flavour_text = "Your mission is to infiltrate the space around SS13 and capture the fugitives on board, dead or alive. Your shuttle has been disguised as an ordinary food truck to help you remain undetected. \
		This is a stealth mission in enemy territory. Reinforcements will not be sent to save you. Microbombs have been implanted in case of capture. Do not disappoint."
	back_story = HUNTER_PACK_MI13
	outfit = /datum/outfit/mi13_hunter

/obj/effect/mob_spawn/ghost_role/human/fugitive/mi13/chef
	outfit = /datum/outfit/mi13_hunter/chef
