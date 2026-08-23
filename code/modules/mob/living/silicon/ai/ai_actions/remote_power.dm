// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/ai_module/power_apc
	name = "Remote Power"
	description = "remotely powers an APC from a distance"
	one_purchase = TRUE
	power_type = /datum/action/innate/ai/ranged/power_apc
	unlock_text = span_notice("Remote APC power systems online.")

/datum/action/innate/ai/ranged/power_apc
	name = "remotely power APC"
	desc = "Use to remotely power an APC."
	button_icon = 'icons/obj/machines/wallmounts.dmi'
	button_icon_state = "apc0"
	ranged_mousepointer = 'icons/effects/mouse_pointers/supplypod_target.dmi'
	enable_text = span_notice("You prepare to power any APC you see.")
	disable_text = span_notice("You stop focusing on powering APCs.")

/datum/action/innate/ai/ranged/power_apc/do_ability(mob/living/clicker, atom/clicked_on)

	if (!isAI(clicker))
		return FALSE
	var/mob/living/silicon/ai/ai_clicker = clicker

	if(clicker.incapacitated)
		unset_ranged_ability(clicker)
		return FALSE

	if(!isapc(clicked_on))
		clicked_on.balloon_alert(ai_clicker, LANG("datum.dcf12c3d0394bfbf", null))
		return FALSE

	if(ai_clicker.battery - 50 <= 0)
		to_chat(ai_clicker, span_warning(LANG("datum.8b96acf7dd025d7e", null)))
		return FALSE

	var/obj/machinery/power/apc/apc = clicked_on
	var/obj/item/stock_parts/power_store/cell = apc.get_cell()
	cell.give(STANDARD_BATTERY_CHARGE)
	ai_clicker.battery -= 50



