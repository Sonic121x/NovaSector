/obj/item/implant/camouflage
	name = "实验性伪装植入物"
	desc = "允许其所有者融入周围环境。酷！"
	actions_types = list(/datum/action/item_action/camouflage)

/obj/item/implant/camouflage/emp_act(severity)
	. = ..()

	if(prob(15 * severity))
		visible_message(span_warning("你植入物内的隐形系统开始过载！"), blind_message = span_hear("你听到嘶嘶声和火花爆裂声。"))
		for(var/datum/action/item_action/camouflage/cloaking_ability in actions)
			cloaking_ability.remove_cloaking()

/datum/action/item_action/camouflage
	name = "激活伪装"
	desc = "激活你的伪装植入物，融入周围环境……"
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
		to_chat(owner, span_notice("你激活了伪装，融入周围环境……"))
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
	to_chat(owner, span_notice("你关闭了伪装，再次变得可见。"))
	cloaking = FALSE

/obj/item/reagent_containers/hypospray/medipen/invisibility
	name = "隐形自动注射器"
	desc = "一种含有稳定土星-X化合物的自动注射器。为战术隐形行动生产，供那些大概对裸体感到自在的特工使用。"
	icon_state = "invispen"
	base_icon_state = "invispen"
	volume = 20 //By my estimate this will last you about 10-ish mintues
	amount_per_transfer_from_this = 20
	list_reagents = list(/datum/reagent/drug/saturnx/stable = 20)
	label_examine = FALSE
