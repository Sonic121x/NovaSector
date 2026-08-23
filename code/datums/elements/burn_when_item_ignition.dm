// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/**
 * This item will be set on fire if a mob clicks on it with something that can ignite objects,
 * OR if a mob clicks it on something else that can ignite objects.
 */
/datum/element/burn_on_item_ignition
	element_flags = ELEMENT_BESPOKE
	argument_hash_start_idx = 2
	/// If TRUE clumsy people can't burn themselves
	var/bypass_clumsy = FALSE

/datum/element/burn_on_item_ignition/Attach(datum/target, bypass_clumsy = FALSE)
	. = ..()
	src.bypass_clumsy = bypass_clumsy
	RegisterSignal(target, COMSIG_ATOM_ITEM_INTERACTION, PROC_REF(try_burn))
	RegisterSignal(target, COMSIG_ITEM_INTERACTING_WITH_ATOM, PROC_REF(try_hold_burn))

/datum/element/burn_on_item_ignition/Detach(datum/target)
	. = ..()
	UnregisterSignal(target, COMSIG_ATOM_ITEM_INTERACTION)
	UnregisterSignal(target, COMSIG_ITEM_INTERACTING_WITH_ATOM)

/datum/element/burn_on_item_ignition/proc/try_burn(atom/source, mob/living/user, obj/item/tool, list/modifiers)
	SIGNAL_HANDLER

	//can't be put on fire!
	if((source.resistance_flags & FIRE_PROOF) || !(source.resistance_flags & FLAMMABLE))
		return NONE
	//already on fire!
	if(source.resistance_flags & ON_FIRE)
		return NONE

	var/ignition_message = tool.ignition_effect(source, user)
	if(!ignition_message)
		return NONE
	if(!bypass_clumsy && HAS_TRAIT(user, TRAIT_CLUMSY) && prob(10) && source.Adjacent(user))
		if(user.is_holding(tool)) //checking if they're holding it in case TK is involved
			user.dropItemToGround(tool)
		var/firestacks = tool.get_temperature() / 200
		user.adjust_fire_stacks(clamp(firestacks, 1, 10))
		user.apply_damage(clamp(firestacks, 4, 12), BURN, user.get_active_hand(), attacking_item = tool)
		user.ignite_mob()
		if(user.on_fire)
			user.visible_message(
				span_warning(LANG("datum.6ef9bfb7349da901", list(user, user.p_them()))),
				span_userdanger(LANG("datum.72ea9a2753009426", list(src))),
				visible_message_flags = ALWAYS_SHOW_SELF_MESSAGE,
			)
		else
			user.visible_message(
				span_warning(LANG("datum.1be980e180100fec", list(user, user.p_them()))),
				span_userdanger(LANG("datum.439e95039214c37b", list(src))),
				visible_message_flags = ALWAYS_SHOW_SELF_MESSAGE,
			)
		return ITEM_INTERACT_SUCCESS

	if(user.is_holding(source)) //no TK shit here.
		user.dropItemToGround(source)
		source.add_fingerprint(user)
	user.visible_message(ignition_message)
	source.fire_act(tool.get_temperature())
	SEND_SIGNAL(source, COMSIG_ATOM_IGNITED_BY_ITEM, user, tool)
	return ITEM_INTERACT_SUCCESS

// Represents holding a paper over a cigarette like a badass
/datum/element/burn_on_item_ignition/proc/try_hold_burn(obj/item/source, mob/living/user, atom/interacting_with, list/modifiers)
	SIGNAL_HANDLER

	return try_burn(interacting_with, user, source, modifiers)
