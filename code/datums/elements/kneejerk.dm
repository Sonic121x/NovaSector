/// An element which enables certain items to tap people on their knees to measure brain health
/datum/element/kneejerk

/datum/element/kneejerk/Attach(datum/target)
	. = ..()

	if (!isitem(target))
		return ELEMENT_INCOMPATIBLE

	RegisterSignal(target, COMSIG_ITEM_ATTACK, PROC_REF(on_item_attack))

/datum/element/kneejerk/Detach(datum/source, ...)
	. = ..()

	UnregisterSignal(source, COMSIG_ITEM_ATTACK)

/datum/element/kneejerk/proc/on_item_attack(datum/source, mob/living/target, mob/living/user, list/modifiers)
	SIGNAL_HANDLER

	if((user.zone_selected == BODY_ZONE_L_LEG || user.zone_selected == BODY_ZONE_R_LEG) && LAZYACCESS(modifiers, RIGHT_CLICK) && target.buckled)
		tap_knee(source, target, user)

		return COMPONENT_SKIP_ATTACK

/datum/element/kneejerk/proc/tap_knee(obj/item/item, mob/living/target, mob/living/user)
	var/selected_zone = user.zone_selected
	var/obj/item/bodypart/leg/right = target.get_bodypart(BODY_ZONE_R_LEG)
	var/obj/item/bodypart/leg/left = target.get_bodypart(BODY_ZONE_L_LEG)
	var/obj/item/organ/brain/target_brain = target.get_organ_slot(ORGAN_SLOT_BRAIN)

	if(!ishuman(target))
		return

	if((selected_zone == BODY_ZONE_R_LEG) && !right)
		return
	if((selected_zone == BODY_ZONE_L_LEG) && !left)
		return

	user.do_attack_animation(target)
	target.visible_message(span_warning("[user] 用[item]轻轻敲了敲[target]的膝盖。"), \
		span_userdanger("[user] 用[item]敲了敲你的膝盖。"))

	if(target.stat == DEAD) //dead men have no reflexes!
		return

	if(!target_brain)
		return

	var/target_brain_damage = target_brain.damage

	if(target_brain_damage < BRAIN_DAMAGE_MILD) //a healthy brain produces a normal reaction
		playsound(target, 'sound/items/weapons/punchmiss.ogg', 25, TRUE, -1)
		target.visible_message(span_danger("[target]的腿猛地踢了出去！"), \
			span_danger("你的腿猛地踢了出去！"))

	else if(target_brain_damage < BRAIN_DAMAGE_SEVERE) //a mildly damaged brain produces a delayed reaction
		playsound(target, 'sound/items/weapons/punchmiss.ogg', 15, TRUE, -1)
		target.visible_message(span_danger("片刻之后，[target]的腿猛地踢了出去！"), \
			span_danger("片刻之后，你的腿猛地踢了出去！"))

	else if(target_brain_damage < BRAIN_DAMAGE_DEATH) //a severely damaged brain produces a delayed + weaker reaction
		playsound(target, 'sound/items/weapons/punchmiss.ogg', 5, TRUE, -1)
		target.visible_message(span_danger("片刻之后，[target]的腿无力地踢了一下！"), \
			span_danger("片刻之后，你的腿无力地踢了一下！"))

	return
