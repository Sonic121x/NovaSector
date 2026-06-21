
//roles found on away missions, if you can remember to put them here.

//undead that protect a zlevel

/obj/effect/mob_spawn/ghost_role/human/skeleton
	name = "骸骨"
	icon = 'icons/effects/blood.dmi'
	icon_state = "remains"
	mob_name = "skeleton"
	prompt_name = "一个骷髅守卫"
	mob_species = /datum/species/skeleton
	you_are_text = "未知的力量让你的骸骨重新获得了生命！"
	flavour_text = "行走于这凡世，恐吓所有胆敢挡你路的活人冒险者。"
	spawner_job_path = /datum/job/skeleton

/obj/effect/mob_spawn/ghost_role/human/skeleton/special(mob/living/new_spawn, mob/mob_possessor, apply_prefs)
	. = ..()
	to_chat(new_spawn, "<b>你内心深处有一种可怕的、令人作呕的感觉，如果你离开这片区域，你与这个世界的联系就会断裂……你被复活是为了保护什么东西吗？</b>")
	new_spawn.AddComponent(/datum/component/stationstuck, PUNISHMENT_MURDER, "You experience a feeling like a stressed twine being pulled until it snaps. Then, merciful nothing.")

/obj/effect/mob_spawn/ghost_role/human/zombie
	name = "腐烂的尸体"
	icon = 'icons/effects/blood.dmi'
	icon_state = "remains"
	mob_name = "zombie"
	prompt_name = "一个亡灵守卫"
	mob_species = /datum/species/zombie
	spawner_job_path = /datum/job/zombie
	you_are_text = "未知的力量让你腐烂的遗体复活了！"
	flavour_text = "行走于这凡世，恐吓所有胆敢挡你路的活人冒险者。"

/obj/effect/mob_spawn/ghost_role/human/zombie/special(mob/living/new_spawn, mob/mob_possessor, apply_prefs)
	. = ..()
	to_chat(new_spawn, "<b>你内心深处有一种可怕的、令人作呕的感觉，如果你离开这片区域，你与这个世界的联系就会断裂……你被复活是为了保护什么东西吗？</b>")
	new_spawn.AddComponent(/datum/component/stationstuck, PUNISHMENT_MURDER, "You experience a feeling like a stressed twine being pulled until it snaps. Then, merciful nothing.")
