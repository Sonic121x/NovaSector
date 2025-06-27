/mob/living/basic/pet/magicfur
	name = "魔法兽"
	desc = "一只充满魔法的毛茸茸小家伙，在觉醒灵智之后，可以做大部分人类能做的事"
	gender = NEUTER
	icon = 'modular_z121/icons/mob/pets.dmi'
	held_lh = 'modular_z121/icons/mob/pets_held_lh.dmi'
	held_rh = 'modular_z121/icons/mob/pets_held_rh.dmi'
	icon_state = "magic_fur_fox"
	icon_living = "magic_fur_fox"
	icon_dead = "magic_fur_fox_dead"
	held_state = "magic_fur_fox"
	can_be_held = TRUE
	see_in_dark = 6
	pass_flags = PASSTABLE
	mob_size = MOB_SIZE_SMALL
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	minimum_survivable_temperature = NPC_DEFAULT_MIN_TEMP
	maximum_survivable_temperature = NPC_DEFAULT_MAX_TEMP
	maxHealth = 50
	health = 50
	melee_damage_lower = 0
	melee_damage_upper = 0
	unsuitable_atmos_damage = 0.3
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	response_harm_continuous = "kicks"
	response_harm_simple = "kick"
	mobility_flags = MOBILITY_FLAGS_REST_CAPABLE_DEFAULT
	//collar_type = "cat"
	attack_verb_continuous = "slap"
	attack_verb_simple = "slap"
	attack_sound = 'sound/effects/blob/attackblob.ogg'
	attack_vis_effect = ATTACK_EFFECT_CLAW
	gold_core_spawnable = FRIENDLY_SPAWN
	attack_vis_effect = ATTACK_EFFECT_SLASH
	obj_damage = 0

/datum/emote/magicfur
	mob_type_allowed_typecache = /mob/living/basic/pet/magicfur
	mob_type_blacklist_typecache = list()

/datum/emote/magicfur/merowr
	key = "merowr"
	key_third_person = "merowrs"
	message = "merowrs."
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE
	vary = TRUE
	sound = "modular_nova/modules/emotes/sound/voice/merowr.ogg"

/mob/living/basic/pet/magicfur/Initialize(mapload)
	. = ..()

	AddElement(/datum/element/dextrous, can_throw = TRUE)
	AddElement(/datum/element/pet_bonus, "merowr", /datum/mood_event/pet_animal)
	AddComponent(/datum/component/basic_inhands, y_offset = -6)
	AddComponent(/datum/component/personal_crafting)
	add_traits(list(TRAIT_ADVANCEDTOOLUSER, TRAIT_CAN_STRIP, TRAIT_LITERATE), INNATE_TRAIT)

	var/datum/atom_hud/medical_sensor = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
	medical_sensor.show_to(src)

//禁止发射带伤害的远程武器
/mob/living/basic/pet/magicfur/can_use_guns(obj/item/gun/weapon)
	if (weapon.chambered == null)
		return TRUE
	var/obj/item/ammo_casing/ammo = weapon.chambered
	var/obj/projectile/bullet = ammo.projectile_type
	if(bullet.damage > 0)
		to_chat(src, span_warning("你觉得自己不应该把充满杀意的子弹射出去！"))
		return FALSE
	if(istype(weapon, /obj/item/gun/ballistic))
		var/obj/item/gun/ballistic/ballistic_gun = weapon
		if(ballistic_gun.magazine)
			var/obj/item/ammo_box/magazine/mag = ballistic_gun.magazine
			for(var/obj/item/ammo_casing/casing in mag.stored_ammo)
				if(!casing.loaded_projectile)
					continue

				var/obj/projectile/mag_bullet = casing.loaded_projectile
				if(mag_bullet.damage > 0)
					to_chat(src, span_warning("你感觉到这把枪的弹匣里有很危险的弹药！"))
					return FALSE
				continue
	return TRUE

/mob/living/basic/pet/magicfur/white
	name = "白魔法兽"
	icon_state = "magic_fur_white"
	icon_living = "magic_fur_white"
	icon_dead = "magic_fur_white_dead"
	held_state = "magic_fur_white"

/mob/living/basic/pet/magicfur/black
	name = "黑魔法兽"
	icon_state = "magic_fur_black"
	icon_living = "magic_fur_black"
	icon_dead = "magic_fur_black_dead"
	held_state = "magic_fur_black"

/mob/living/basic/pet/magicfur/pink
	name = "粉魔法兽"
	icon_state = "magic_fur_pink"
	icon_living = "magic_fur_pink"
	icon_dead = "magic_fur_pink_dead"
	held_state = "magic_fur_pink"

/mob/living/basic/pet/magicfur/miku
	name = "魔法兽miku"
	icon_state = "magic_fur_miku"
	icon_living = "magic_fur_miku"
	icon_dead = "magic_fur_miku_dead"
	held_state = "magic_fur_miku"
