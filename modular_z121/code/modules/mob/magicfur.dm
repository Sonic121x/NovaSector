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
	ai_controller = /datum/ai_controller/basic_controller/magicfur

	var/static/list/pet_commands = list(
		/datum/pet_command/idle,
		/datum/pet_command/free,
		/datum/pet_command/move,
		/datum/pet_command/follow,
	)
/datum/emote/magicfur
	mob_type_allowed_typecache = /mob/living/basic/pet/magicfur
	mob_type_blacklist_typecache = list()

/datum/emote/magicfur/merowr
	key = "merowr"
	key_third_person = "merowrs"
	message = "merowrs"
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE
	vary = TRUE
	sound = "modular_nova/modules/emotes/sound/voice/merowr.ogg"

/mob/living/basic/pet/magicfur/Initialize(mapload)
	. = ..()

	AddElement(/datum/element/dextrous, can_throw = TRUE)
	AddElement(/datum/element/pet_bonus, "merowr", /datum/mood_event/pet_animal)
	var/static/list/food_types = list(
		/obj/item/food/grown/holymelon,
	)
	AddComponent(/datum/component/tameable, food_types = food_types, tame_chance = 50, bonus_tame_chance = 50, unique = FALSE)
	AddComponent(/datum/component/basic_inhands, y_offset = -6)
	AddComponent(/datum/component/personal_crafting)
	AddComponent(/datum/component/obeys_commands, pet_commands)
	RegisterSignal(src, COMSIG_MOB_ATE, PROC_REF(eat_food))
	RegisterSignal(src, COMSIG_ANIMAL_PET, PROC_REF(on_pet))
	add_traits(list(TRAIT_ADVANCEDTOOLUSER, TRAIT_CAN_STRIP, TRAIT_LITERATE), INNATE_TRAIT)

	var/datum/atom_hud/medical_sensor = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
	medical_sensor.show_to(src)

//	喂食反应
/mob/living/basic/pet/magicfur/proc/eat_food(atom/source, obj/item/food, mob/living/attacker)
	SIGNAL_HANDLER
	visible_message(
		span_notice("[src]舔了舔爪爪"),
		span_notice("你舔了舔爪爪，[food]太好吃了！"),
	)
	new /obj/effect/temp_visual/heart(src.loc)
	src.spin(spintime = 2 SECONDS, speed = 1)

//	抚摸反应
/mob/living/basic/pet/magicfur/proc/on_pet(mob/living/basic/source, mob/living/petter, modifiers)
	SIGNAL_HANDLER
	src.spin(spintime = 1 SECONDS, speed = 1)

//	驯服反应
/mob/living/basic/pet/magicfur/tamed(mob/living/tamer, atom/food)
	visible_message(span_notice("[src]和[tamer]成为了朋友，并用爪爪在[tamer]身上留下了友谊印记"))

//	禁止使用远程武器
/mob/living/basic/pet/magicfur/can_use_guns(obj/item/gun/weapon)
	to_chat(src, span_warning("你认为，你不应该使用它！"))
	return FALSE

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

//	魔法兽AI
/datum/ai_controller/basic_controller/magicfur
	blackboard = list(
		BB_VISION_RANGE = 10,
		BB_PET_TARGETING_STRATEGY = /datum/targeting_strategy/basic,
		BB_INTERACTIONS_WITH_OWNER = list(
			"蹭一蹭",
			"用尾巴挑逗",
			"俏皮的靠在",
			"轻咬"
		),
	)
	ai_movement = /datum/ai_movement/basic_avoidance
	idle_behavior = /datum/idle_behavior/idle_random_walk
	planning_subtrees = list(
		/datum/ai_planning_subtree/random_speech/magicfur,
		/datum/ai_planning_subtree/pet_planning,
		/datum/ai_planning_subtree/find_and_hunt_target/play_with_owner
	)

/datum/ai_planning_subtree/random_speech/magicfur
	speech_chance = 4
	speak = list("Aw~","嗷呜~")
	emote_hear = list("绒毛细腻的摩擦声")
	emote_see = list("悠闲的伸懒腰","低头看向地板","搭理自己毛发")

