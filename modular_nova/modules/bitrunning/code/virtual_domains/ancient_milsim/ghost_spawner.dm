/obj/effect/mob_spawn/ghost_role/human/virtual_domain/ancient_milsim
	name = "延迟加载的资产"
	desc = "一个轮廓模糊的类军人形，全身覆盖着静态纹理。它在编译上遇到了一些问题，给它点时间。"
	prompt_name = "一名奇怪的复合体特工"
	icon = 'icons/effects/effects.dmi'
	icon_state = "static"
	outfit = /datum/outfit/cin_soldier_player
	you_are_text = "你是一个守卫模拟战斗域出口的智能NPC。"
	flavour_text = "你是一个被载入域中的智能NPC，目的是通过战斗或冗长的对话等方式，以某种方式减缓比特奔跑参赛者的进度。"
	important_text = "Play fair. Humans are the only allowed species."
	restricted_species = list(/datum/species/human)
	allow_custom_character = GHOSTROLE_TAKE_PREFS_APPEARANCE

/obj/effect/mob_spawn/ghost_role/human/virtual_domain/ancient_milsim/proc/apply_codename(mob/living/carbon/human/spawned_human)
	var/callsign = pick(GLOB.callsigns_nri)
	var/number = pick(GLOB.phonetic_alphabet_numbers)
	spawned_human.fully_replace_character_name(null, "[callsign] [number]")

/obj/effect/mob_spawn/ghost_role/human/virtual_domain/ancient_milsim/special(mob/living/carbon/human/spawned_human, mob/mob_possessor, apply_prefs)
	. = ..()
	spawned_human.grant_language(/datum/language/spinwarder, source = LANGUAGE_SPAWNER)

/obj/effect/mob_spawn/ghost_role/human/virtual_domain/ancient_milsim/post_transfer_prefs(mob/living/carbon/human/spawned_human)
	. = ..()
	apply_codename(spawned_human)
