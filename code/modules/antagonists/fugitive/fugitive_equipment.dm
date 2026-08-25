// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/item/implant/camouflage
	name = "experimental camouflage implant"
	desc = "Allows its owner to blend in with their surroundings. Cool!"
	actions_types = list(/datum/action/item_action/camouflage)

/obj/item/implant/camouflage/emp_act(severity)
	. = ..()

	if(prob(15 * severity))
		visible_message(span_warning(LANG("obj.08a49fe6b510e579", null)), blind_message = span_hear(LANG("obj.e05f9532d0137e10", null)))
		for(var/datum/action/item_action/camouflage/cloaking_ability in actions)
			cloaking_ability.remove_cloaking()

/datum/action/item_action/camouflage
	name = "Activate Camouflage"
	desc = "Activate your camouflage implant, and blend into your surroundings..."
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "deploy_box"
	/// The alpha we move to when activating this action.
	var/camouflage_alpha = 35
	/// Are we currently cloaking ourself?
	var/cloaking = FALSE

/datum/action/item_action/camouflage/Remove(mob/living/remove_from)
	if(owner)
		remove_cloaking()

	return ..()

/datum/action/item_action/camouflage/do_effect(trigger_flags)
	. = ..()
	if(!.)
		return

	if(cloaking)
		remove_cloaking()
	else
		owner.alpha = camouflage_alpha
		to_chat(owner, span_notice(LANG("datum.6f31e526019aa7c2", null)))
		cloaking = TRUE

/**
 * Returns the owner's alpha value to its initial value,
 *
 * Disables cloaking and flashes sparks. Used when toggling the ability, as well as to
 * make sure the action properly resets its owner when removed.
 */

/datum/action/item_action/camouflage/proc/remove_cloaking()
	do_sparks(2, FALSE, owner)
	owner.alpha = initial(owner.alpha)
	to_chat(owner, span_notice(LANG("datum.cfddf70080998e1e", null)))
	cloaking = FALSE

/obj/item/reagent_containers/hypospray/medipen/invisibility
	name = "invisibility autoinjector"
	desc = "An autoinjector containing a stabilized Saturn-X compound. Produced for use in tactical stealth operations, by operatives who were presumably comfortable with nudity."
	icon_state = "invispen"
	base_icon_state = "invispen"
	volume = 20 //By my estimate this will last you about 10-ish mintues
	amount_per_transfer_from_this = 20
	list_reagents = list(/datum/reagent/drug/saturnx/stable = 20)
	label_examine = FALSE
