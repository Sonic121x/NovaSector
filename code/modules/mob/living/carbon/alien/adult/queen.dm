/mob/living/carbon/alien/adult/royal
	//Common stuffs for Praetorian and Queen
	icon = 'icons/mob/nonhuman-player/alienqueen.dmi'
	status_flags = 0
	pixel_x = -16
	base_pixel_x = -16
	maptext_height = 64
	maptext_width = 64
	bubble_icon = "alienroyal"
	mob_size = MOB_SIZE_LARGE
	layer = LARGE_MOB_LAYER //above most mobs, but below speechbubbles
	pressure_resistance = 200 //Because big, stompy xenos should not be blown around like paper.
	butcher_results = list(/obj/item/food/meat/slab/xeno = 20, /obj/item/stack/sheet/animalhide/xeno = 3)

	var/alt_inhands_file = 'icons/mob/nonhuman-player/alienqueen.dmi'

/mob/living/carbon/alien/adult/royal/Initialize(mapload)
	. = ..()
	// as a wise man once wrote: "pull over that ass too fat"
	REMOVE_TRAIT(src, TRAIT_VENTCRAWLER_ALWAYS, INNATE_TRAIT)
	// that'd be a too cheeky shield bashing strat
	ADD_TRAIT(src, TRAIT_BRAWLING_KNOCKDOWN_BLOCKED, INNATE_TRAIT)
	// Lets you spin without falling over
	ADD_TRAIT(src, TRAIT_STRENGTH, INNATE_TRAIT)
	AddComponent(/datum/component/seethrough_mob)

/mob/living/carbon/alien/adult/royal/on_lying_down(new_lying_angle)
	. = ..()
	layer = LYING_MOB_LAYER

/mob/living/carbon/alien/adult/royal/on_standing_up(new_lying_angle)
	. = ..()
	layer = initial(layer)

/mob/living/carbon/alien/adult/royal/can_inject(mob/user, target_zone, injection_flags)
	return FALSE

/mob/living/carbon/alien/adult/royal/get_fire_overlay(stacks, on_fire)
	var/fire_key = "royal_fire"

	if(!GLOB.fire_appearances[fire_key])
		var/mutable_appearance/fire = mutable_appearance(
			'icons/mob/effects/onfire.dmi',
			"generic_fire",
			ABOVE_ALL_MOB_LAYER,
			appearance_flags = RESET_COLOR|KEEP_APART|PIXEL_SCALE,
		)
		fire.pixel_x = 16
		fire.pixel_y = 8
		fire.transform = fire.transform.Scale(2, 2)
		GLOB.fire_appearances[fire_key] = fire

	return GLOB.fire_appearances[fire_key]

/mob/living/carbon/alien/adult/royal/queen
	name = "异形女王"
	caste = "q"
	maxHealth = 500
	health = 500
	icon_state = "alienq"
	melee_damage_lower = 50
	melee_damage_upper = 50
	alien_speed = 2

	default_organ_types_by_slot = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain/alien,
		ORGAN_SLOT_XENO_HIVENODE = /obj/item/organ/alien/hivenode,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/alien,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/alien,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver/alien,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach/alien,
		ORGAN_SLOT_XENO_PLASMAVESSEL = /obj/item/organ/alien/plasmavessel/large/queen,
		ORGAN_SLOT_XENO_RESINSPINNER = /obj/item/organ/alien/resinspinner,
		ORGAN_SLOT_XENO_ACIDGLAND = /obj/item/organ/alien/acid,
		ORGAN_SLOT_XENO_NEUROTOXINGLAND = /obj/item/organ/alien/neurotoxin,
		ORGAN_SLOT_XENO_EGGSAC = /obj/item/organ/alien/eggsac,
		ORGAN_SLOT_EXTERNAL_TAIL = /obj/item/organ/tail/xeno_queen,
	)

/mob/living/carbon/alien/adult/royal/queen/Initialize(mapload)
	var/static/list/innate_actions = list(
		/datum/action/cooldown/alien/promote,
	)
	grant_actions_by_list(innate_actions)
	add_movespeed_mod_immunities(type, /datum/movespeed_modifier/tail_dragger)
	return ..()

/mob/living/carbon/alien/adult/royal/queen/set_name()
	if(get_alien_type(/mob/living/carbon/alien/adult/royal/queen, ignored = src))
		name = "异形公主"
	return ..()

//Queen verbs
/datum/action/cooldown/alien/make_structure/lay_egg
	name = "产卵"
	desc = "产下一枚卵，以孵化抱脸虫来感染猎物。"
	button_icon_state = "alien_egg"
	plasma_cost = 75
	made_structure_type = /obj/structure/alien/egg

/datum/action/cooldown/alien/make_structure/lay_egg/Activate(atom/target)
	. = ..()
	owner.visible_message(span_alertalien("[owner] 产下了一颗卵！"))

//Button to let queen choose her praetorian.
/datum/action/cooldown/alien/promote
	name = "创造皇家寄生虫"
	desc = "产出一个皇家寄生虫，授予你的一个子嗣成为禁卫军的荣耀。"
	button_icon_state = "alien_queen_promote"
	/// The promotion only takes plasma when completed, not on activation.
	var/promotion_plasma_cost = 500

/datum/action/cooldown/alien/promote/New(Target)
	. = ..()
	//not free
	if(promotion_plasma_cost != 0)
		name = "[initial(name)] ([promotion_plasma_cost]P)"

/datum/action/cooldown/alien/promote/IsAvailable(feedback = FALSE)
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/carbon/carbon_owner = owner
	if(carbon_owner.getPlasma() < promotion_plasma_cost)
		return FALSE

	if(get_alien_type(/mob/living/carbon/alien/adult/royal/praetorian))
		return FALSE

	return TRUE

/datum/action/cooldown/alien/promote/Activate(atom/target)
	var/obj/item/queen_promotion/existing_promotion = locate() in owner.held_items
	if(existing_promotion)
		to_chat(owner, span_noticealien("你丢弃了[existing_promotion]。"))
		owner.temporarilyRemoveItemFromInventory(existing_promotion)
		qdel(existing_promotion)
		return TRUE

	if(!owner.get_empty_held_indexes())
		to_chat(owner, span_warning("你必须空出一只手才能准备寄生虫。"))
		return FALSE

	var/obj/item/queen_promotion/new_promotion = new(owner.loc)
	if(!owner.put_in_hands(new_promotion, del_on_fail = TRUE))
		to_chat(owner, span_noticealien("你未能准备好一个寄生虫。"))
		return FALSE

	to_chat(owner, span_noticealien("使用[new_promotion]在你的一个子嗣身上，将她晋升为禁卫！"))
	return TRUE

/obj/item/queen_promotion
	name = "\improper 皇家寄生体"
	desc = "将此注射剂注入你的一名成年子嗣体内，将她晋升为禁卫！"
	icon_state = "alien_medal"
	item_flags = NOBLUDGEON | ABSTRACT | DROPDEL
	icon = 'icons/mob/nonhuman-player/alien.dmi'

/obj/item/queen_promotion/attack(mob/living/to_promote, mob/living/carbon/alien/adult/queen)
	. = ..()
	if(.)
		return

	var/datum/action/cooldown/alien/promote/promotion = locate() in queen.actions
	if(!promotion)
		CRASH("[type] was created and handled by a mob ([queen]) that didn't have a promotion action associated.")

	if(!isalienadult(to_promote) || isalienroyal(to_promote))
		to_chat(queen, span_noticealien("你只能对你的成年、非皇族子嗣使用这个！"))
		return

	if(!promotion.IsAvailable())
		to_chat(queen, span_noticealien("你现在无法晋升幼体！"))
		return

	if(to_promote.stat != CONSCIOUS || !to_promote.mind || !to_promote.key)
		return

	queen.adjustPlasma(-promotion.promotion_plasma_cost)

	to_chat(queen, span_noticealien("你已将[to_promote]晋升为禁卫！"))
	to_promote.visible_message(
		span_alertalien("[to_promote] 开始膨胀、扭曲和变形！"),
		span_noticealien("女王已授予你晋升为禁卫军！"),
	)

	var/mob/living/carbon/alien/lucky_winner = to_promote
	var/mob/living/carbon/alien/adult/royal/praetorian/new_prae = new(lucky_winner.loc)
	lucky_winner.alien_evolve(new_prae)
	qdel(src)
	return TRUE

/obj/item/queen_promotion/attack_self(mob/user)
	to_chat(user, span_noticealien("你丢弃了[src]。"))
	qdel(src)

/obj/item/queen_promotion/dropped(mob/user, silent)
	if(!silent)
		to_chat(user, span_noticealien("你丢弃了[src]。"))
	return ..()
