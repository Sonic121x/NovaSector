/**
 * An armblade that instantly snuffs out lights
 */
/obj/item/light_eater
	name = "噬光者" //as opposed to heavy eater
	icon = 'icons/obj/weapons/nightmare_items.dmi'
	icon_state = "light_eater"
	inhand_icon_state = "light_eater"
	icon_angle = 180
	force = 25
	armour_penetration = 35
	lefthand_file = 'icons/mob/inhands/antag/nightmare_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/antag/nightmare_righthand.dmi'
	item_flags = ABSTRACT | DROPDEL
	resistance_flags = INDESTRUCTIBLE | ACID_PROOF | FIRE_PROOF | LAVA_PROOF | UNACIDABLE
	w_class = WEIGHT_CLASS_HUGE
	sharpness = SHARP_EDGED
	tool_behaviour = TOOL_MINING
	hitsound = 'sound/items/weapons/bladeslice.ogg'
	wound_bonus = -30
	exposed_wound_bonus = 20
	///If this is true, our next hit will be critcal, temporarily stunning our target
	var/has_crit = FALSE
	///The timer which controls our next crit
	var/crit_timer

/obj/item/light_eater/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, HAND_REPLACEMENT_TRAIT)
	AddComponent(/datum/component/butchering, \
	speed = 8 SECONDS, \
	effectiveness = 70, \
	)
	AddComponent(/datum/component/light_eater)

/obj/item/light_eater/equipped(mob/user, slot, initial = FALSE)
	. = ..()
	if(!user?.mind?.has_antag_datum(/datum/antagonist/nightmare))
		return
	RegisterSignal(user, COMSIG_MOB_ENTER_JAUNT, PROC_REF(prepare_crit_timer))
	RegisterSignal(user, COMSIG_MOB_AFTER_EXIT_JAUNT, PROC_REF(stop_crit_timer))

/obj/item/light_eater/dropped(mob/user, silent = FALSE)
	. = ..()
	if(!user?.mind?.has_antag_datum(/datum/antagonist/nightmare))
		return
	UnregisterSignal(user, COMSIG_MOB_ENTER_JAUNT)
	UnregisterSignal(user, COMSIG_MOB_AFTER_EXIT_JAUNT)
	remove_crit()

/obj/item/light_eater/attack(mob/living/target, mob/living/user, list/modifiers, list/attack_modifiers)
	. = ..()
	if(!has_crit)
		return
	playsound(target, 'sound/effects/wounds/crackandbleed.ogg', 100, TRUE)
	if(target.stat == DEAD)
		user.visible_message(span_warning("[user]用[src]刺穿了[target]！"), span_warning("你用[src]刺穿了[target]，这没什么实际效果，但让你感觉好了一点。"))
	else if(!HAS_TRAIT(target, TRAIT_HULK) && (iscarbon(target) || issilicon(target)))
		user.visible_message(span_boldwarning("[user]用[src]刺穿了[target]，使其动弹不得！"), span_userdanger("你用[src]刺穿了[target]，使其动弹不得！"))
		target.Paralyze(issilicon(target) ? 2 SECONDS : 1 SECONDS)
	else
		user.visible_message(span_boldwarning("[user]用[src]刺穿了[target]，将其撕裂！"), span_userdanger("你用[src]刺穿了[target]，将其撕裂！"))
		target.apply_damage(damage = force, forced = TRUE)
	remove_crit()

/obj/item/light_eater/proc/prepare_crit_timer()
	crit_timer = addtimer(CALLBACK(src, PROC_REF(add_crit)), 7 SECONDS, TIMER_DELETE_ME | TIMER_STOPPABLE)

/obj/item/light_eater/proc/stop_crit_timer()
	deltimer(crit_timer)

/obj/item/light_eater/proc/add_crit()
	if(has_crit)
		return
	has_crit = TRUE
	add_filter("crit_glow", 3, list("type" = "outline", "color" = COLOR_CARP_RIFT_RED, "size" = 5))
	if(ismob(loc))
		loc.balloon_alert(loc, "暴击准备就绪")

/obj/item/light_eater/proc/remove_crit()
	if(!has_crit)
		return
	has_crit = FALSE
	remove_filter("crit_glow")
	stop_crit_timer()
