/datum/loadout_item/inhand/pet/lanhongqiu
	name = "蓝红球"
	item_path = /obj/item/clothing/head/mob_holder/pet/donator/lanhongqiu
	//ckeywhitelist = list("lanhongqiu")

/obj/item/lanhongqiucore
	name = "蓝红球的核心"
	desc = "你怎么敢的！这可不是在杀史莱姆，你杀死了一个和你一样有思想感情的生物！"
	icon = 'modular_z121/icons/mob/pets.dmi'
	icon_state = "lanhongqiu_core"

/mob/living/basic/pet/lanhongqiu
	name = "蓝红球"
	desc = "克罗托生物，也许别人会认为是史莱姆的变种，实际是他们已经在当地建立了一个庞大的世界国家。别惹他！这是世界共和国的公民！"
	gender = MALE
	icon = 'modular_z121/icons/mob/pets.dmi'
	//held_lh = 'modular_z121/icons/mob/pets_held_lh.dmi'
	//held_rh = 'modular_z121/icons/mob/pets_held_rh.dmi'
	icon_state = "lanhongqiu"
	icon_living = "lanhongqiu"
	icon_dead = "lanhongqiu_dead"
	held_state = "lanhongqiu"
	can_be_held = TRUE
	pass_flags = PASSTABLE
	mob_size = MOB_SIZE_SMALL
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	minimum_survivable_temperature = NPC_DEFAULT_MIN_TEMP
	maximum_survivable_temperature = NPC_DEFAULT_MAX_TEMP
	butcher_results = list(/obj/item/lanhongqiucore = 1)
	unsuitable_atmos_damage = 0.5
	mobility_flags = MOBILITY_FLAGS_REST_CAPABLE_DEFAULT
	obj_damage = 0

/obj/item/clothing/head/mob_holder/pet/donator/lanhongqiu
	name = "蓝红球"
	desc = "克罗托生物，也许别人会认为是史莱姆的变种，实际是他们已经在当地建立了一个庞大的世界国家。别惹他！这是世界共和国的公民！"
	icon = 'modular_z121/icons/mob/pets.dmi'
	icon_state = "lanhongqiu"

	starting_pet = /mob/living/basic/pet/lanhongqiu