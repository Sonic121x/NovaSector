// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
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
	target.visible_message(span_warning(LANG("datum.a9b2eccec04b0069", list(user, target, item))), \
		span_userdanger(LANG("datum.9acbe40df87cab83", list(user, item))))

	if(target.stat == DEAD) //dead men have no reflexes!
		return

	if(!target_brain)
		return

	var/target_brain_damage = target_brain.damage

	if(target_brain_damage < BRAIN_DAMAGE_MILD) //a healthy brain produces a normal reaction
		playsound(target, 'sound/items/weapons/punchmiss.ogg', 25, TRUE, -1)
		target.visible_message(span_danger(LANG("datum.8c8d6499e72c5b77", list(target))), \
			span_danger(LANG("datum.239ebc7ef0aecb62", null)))

	else if(target_brain_damage < BRAIN_DAMAGE_SEVERE) //a mildly damaged brain produces a delayed reaction
		playsound(target, 'sound/items/weapons/punchmiss.ogg', 15, TRUE, -1)
		target.visible_message(span_danger(LANG("datum.b4c589e1afc7f9f7", list(target))), \
			span_danger(LANG("datum.507534963bc50e0e", null)))

	else if(target_brain_damage < BRAIN_DAMAGE_DEATH) //a severely damaged brain produces a delayed + weaker reaction
		playsound(target, 'sound/items/weapons/punchmiss.ogg', 5, TRUE, -1)
		target.visible_message(span_danger(LANG("datum.244a9edc3089ebf7", list(target))), \
			span_danger(LANG("datum.443cf2b2d1d527ff", null)))

	return
