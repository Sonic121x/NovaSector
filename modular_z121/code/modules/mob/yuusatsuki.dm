/mob/living/basic/pet/yuusatsuki
	name = "yuusatsuki"
	desc = "可爱小鸡,她身上穿着的衣服似乎是临时改合身的"
	gender = FEMALE
	icon = 'modular_z121/icons/mob/pets.dmi'
	icon_state = "yuusatsuki_jumpsuit"
	icon_living = "yuusatsuki_jumpsuit"
	icon_dead = "yuusatsuki_dead"
	can_be_held = FALSE
	see_in_dark = 6
	pass_flags = PASSTABLE
	mob_size = MOB_SIZE_SMALL
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	minimum_survivable_temperature = NPC_DEFAULT_MIN_TEMP
	maximum_survivable_temperature = NPC_DEFAULT_MAX_TEMP
	maxHealth = 100
	health = 100
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
	gold_core_spawnable = NO_SPAWN
	attack_vis_effect = ATTACK_EFFECT_SLASH
	obj_damage = 0

/mob/living/basic/pet/yuusatsuki/Initialize(mapload)
	. = ..()
	add_traits(list(TRAIT_CAN_STRIP), ROUNDSTART_TRAIT)
	AddElement(/datum/element/pet_bonus)
	AddElement(/datum/element/dextrous)
	AddElement(/datum/element/footstep, FOOTSTEP_MOB_CLAW)
	AddComponent(/datum/component/personal_crafting)
	AddComponent(/datum/component/basic_inhands, y_offset = -1)

/mob/living/basic/pet/yuusatsuki/gib()
	return