// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md

//roles found on away missions, if you can remember to put them here.

//undead that protect a zlevel

/obj/effect/mob_spawn/ghost_role/human/skeleton
	name = "skeletal remains"
	icon = 'icons/effects/blood.dmi'
	icon_state = "remains"
	mob_name = "skeleton"
	prompt_name = "a skeletal guardian"
	mob_species = /datum/species/skeleton
	you_are_text = "By unknown powers, your skeletal remains have been reanimated!"
	flavour_text = "Walk this mortal plane and terrorize all living adventurers who dare cross your path."
	spawner_job_path = /datum/job/skeleton

/obj/effect/mob_spawn/ghost_role/human/skeleton/special(mob/living/new_spawn, mob/mob_possessor, apply_prefs)
	. = ..()
	to_chat(new_spawn, LANG("obj.8ad7fdc7ca930e32", null))
	new_spawn.AddComponent(/datum/component/stationstuck, PUNISHMENT_MURDER, "You experience a feeling like a stressed twine being pulled until it snaps. Then, merciful nothing.")

/obj/effect/mob_spawn/ghost_role/human/zombie
	name = "rotting corpse"
	icon = 'icons/effects/blood.dmi'
	icon_state = "remains"
	mob_name = "zombie"
	prompt_name = "an undead guardian"
	mob_species = /datum/species/zombie
	spawner_job_path = /datum/job/zombie
	you_are_text = "By unknown powers, your rotting remains have been resurrected!"
	flavour_text = "Walk this mortal plane and terrorize all living adventurers who dare cross your path."

/obj/effect/mob_spawn/ghost_role/human/zombie/special(mob/living/new_spawn, mob/mob_possessor, apply_prefs)
	. = ..()
	to_chat(new_spawn, LANG("obj.8ad7fdc7ca930e32", null))
	new_spawn.AddComponent(/datum/component/stationstuck, PUNISHMENT_MURDER, "You experience a feeling like a stressed twine being pulled until it snaps. Then, merciful nothing.")
