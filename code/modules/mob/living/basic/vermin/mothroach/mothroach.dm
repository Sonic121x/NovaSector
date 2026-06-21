/mob/living/basic/mothroach
	name = "蛾螂"
	desc = "这是多次尝试将蛾族人与蟑螂进行基因混合后产生的可爱副产品。"
	icon_state = "mothroach"
	icon_living = "mothroach"
	icon_dead = "mothroach_dead"
	held_state = "mothroach"
	held_lh = 'icons/mob/inhands/animal_item_lefthand.dmi'
	held_rh = 'icons/mob/inhands/animal_item_righthand.dmi'
	head_icon = 'icons/mob/clothing/head/pets_head.dmi'
	butcher_results = list(/obj/item/food/meat/slab/mothroach = 3, /obj/item/stack/sheet/animalhide/mothroach = 1)
	mob_biotypes = MOB_ORGANIC|MOB_BUG
	mob_size = MOB_SIZE_SMALL
	mobility_flags = MOBILITY_FLAGS_REST_CAPABLE_DEFAULT
	health = 25
	maxHealth = 25
	speed = 1.25
	gold_core_spawnable = FRIENDLY_SPAWN
	can_be_held = TRUE
	worn_slot_flags = ITEM_SLOT_HEAD

	verb_say = "扑腾着说"
	verb_ask = "好奇地扑腾着"
	verb_exclaim = "大声扑腾"
	verb_yell = "大声扑腾"
	response_disarm_continuous = "shoos"
	response_disarm_simple = "shoo"
	response_harm_continuous = "hits"
	response_harm_simple = "hit"
	response_help_continuous = "pats"
	response_help_simple = "pat"

	faction = list(FACTION_NEUTRAL)

	ai_controller = /datum/ai_controller/basic_controller/mothroach
	///list of pet commands we follow
	var/static/list/pet_commands = list(
		/datum/pet_command/idle,
		/datum/pet_command/free,
		/datum/pet_command/follow/start_active,
		/datum/pet_command/perform_trick_sequence,
		// NOVA EDIT ADDITION START
		/datum/pet_command/good_boy,
		/datum/pet_command/fetch,
		/datum/pet_command/play_dead,
		// NOVA EDIT ADDITION END
	)

/datum/emote/mothroach
	abstract_type = /datum/emote/mothroach
	mob_type_allowed_typecache = /mob/living/basic/mothroach
	mob_type_blacklist_typecache = list()

/datum/emote/mothroach/squeaks
	key = "squeaks"
	key_third_person = "squeaks"
	message = "squeaks!"
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE

/mob/living/basic/mothroach/Initialize(mapload)
	. = ..()
	var/static/list/food_types = list(/obj/item/clothing)
	AddElement(/datum/element/basic_eating, food_types = food_types)
	AddComponent(/datum/component/obeys_commands, pet_commands)
	ai_controller.set_blackboard_key(BB_BASIC_FOODS, typecacheof(food_types))
	AddElement(/datum/element/ai_retaliate)
	AddElement(/datum/element/pet_bonus, "squeak")
	add_verb(src, /mob/living/proc/toggle_resting)
	ADD_TRAIT(src, TRAIT_VENTCRAWLER_ALWAYS, INNATE_TRAIT)

/mob/living/basic/mothroach/toggle_resting()
	. = ..()
	if(stat == DEAD)
		return
	if (resting)
		icon_state = "[icon_living]_rest"
	else
		icon_state = "[icon_living]"
	regenerate_icons()

/mob/living/basic/mothroach/attack_hand(mob/living/carbon/human/user, list/modifiers)
	. = ..()
	if(src.stat == DEAD)
		return
	else
		playsound(loc, 'sound/mobs/humanoids/moth/scream_moth.ogg', 50, TRUE)

/mob/living/basic/mothroach/attackby(obj/item/attacking_item, mob/living/user, list/modifiers, list/attack_modifiers)
	. = ..()
	if(src.stat == DEAD)
		return
	else
		playsound(loc, 'sound/mobs/humanoids/moth/scream_moth.ogg', 50, TRUE)

/mob/living/basic/mothroach/bar
	name = "蛾蟑酒保"
	desc = "一只正在提供饮品的蛾蟑。看它忙活的样子。"
	icon_state = "barroach"
	icon_living = "barroach"
	icon_dead = "barroach_dead"
