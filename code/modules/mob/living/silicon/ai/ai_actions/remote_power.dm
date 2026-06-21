/datum/ai_module/power_apc
	name = "远程供能"
	description = "从远处远程为一个APC供电"
	one_purchase = TRUE
	power_type = /datum/action/innate/ai/ranged/power_apc
	unlock_text = span_notice("远程APC供能系统已上线。")

/datum/action/innate/ai/ranged/power_apc
	name = "远程为APC供能"
	desc = "用于远程为一个APC供能。"
	button_icon = 'icons/obj/machines/wallmounts.dmi'
	button_icon_state = "apc0"
	ranged_mousepointer = 'icons/effects/mouse_pointers/supplypod_target.dmi'
	enable_text = span_notice("你准备好为你看到的任何APC供能。")
	disable_text = span_notice("你停止专注于为APC供能。")

/datum/action/innate/ai/ranged/power_apc/do_ability(mob/living/clicker, atom/clicked_on)

	if (!isAI(clicker))
		return FALSE
	var/mob/living/silicon/ai/ai_clicker = clicker

	if(clicker.incapacitated)
		unset_ranged_ability(clicker)
		return FALSE

	if(!isapc(clicked_on))
		clicked_on.balloon_alert(ai_clicker, "不是APC！")
		return FALSE

	if(ai_clicker.battery - 50 <= 0)
		to_chat(ai_clicker, span_warning("你没有足够的电池来为一个APC充电！"))
		return FALSE

	var/obj/machinery/power/apc/apc = clicked_on
	var/obj/item/stock_parts/power_store/cell = apc.get_cell()
	cell.give(STANDARD_BATTERY_CHARGE)
	ai_clicker.battery -= 50



