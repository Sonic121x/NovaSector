/obj/item/reagent_containers/cup/primitive_centrifuge
	name = "原始离心机"
	desc = "一个小杯子，允许人缓慢地分离出他们不想要的液体。"
	icon = 'modular_nova/modules/ashwalkers/icons/misc_tools.dmi'
	icon_state = "primitive_centrifuge"
	material_flags = MATERIAL_EFFECTS | MATERIAL_ADD_PREFIX | MATERIAL_COLOR

/obj/item/reagent_containers/cup/primitive_centrifuge/examine()
	. = ..()
	. += span_notice("<b>Ctrl + 点击</b> 选择要移除的化学物质。")
	. += span_notice("<b>Ctrl + Shift + 点击</b> 选择要保留的化学物质，其余将被移除。")

/obj/item/reagent_containers/cup/primitive_centrifuge/item_ctrl_click(mob/user)
	if(!length(reagents.reagent_list))
		return CLICK_ACTION_BLOCKING

	var/datum/user_input = tgui_input_list(user, "选择要移除的化学物质。", "移除选择", reagents.reagent_list)

	if(isnull(user_input))
		balloon_alert(user, "未选择！")
		return CLICK_ACTION_BLOCKING

	user.balloon_alert_to_viewers("spinning [src]...")
	var/skill_modifier = user.mind?.get_skill_modifier(/datum/skill/primitive, SKILL_SPEED_MODIFIER)
	if(!do_after(user, 5 SECONDS * skill_modifier, target = src))
		user.balloon_alert_to_viewers("stopped spinning [src]")
		return CLICK_ACTION_BLOCKING

	reagents.del_reagent(user_input.type)
	balloon_alert(user, "从[src]移除了试剂")
	user.mind?.adjust_experience(/datum/skill/primitive, 2)
	return CLICK_ACTION_SUCCESS

/obj/item/reagent_containers/cup/primitive_centrifuge/click_ctrl_shift(mob/user)
	if(!length(reagents.reagent_list))
		return

	var/datum/user_input = tgui_input_list(user, "选择要保留的化学品，其余将被移除。", "保留选择", reagents.reagent_list)

	if(isnull(user_input))
		balloon_alert(user, "未选择！")
		return

	user.balloon_alert_to_viewers("spinning [src]...")
	var/skill_modifier = user.mind?.get_skill_modifier(/datum/skill/primitive, SKILL_SPEED_MODIFIER)
	if(!do_after(user, 5 SECONDS * skill_modifier, target = src))
		user.balloon_alert_to_viewers("stopped spinning [src]")
		return

	for(var/datum/reagent/remove_reagent in reagents.reagent_list)
		if(!istype(remove_reagent, user_input.type))
			reagents.del_reagent(remove_reagent.type)

	balloon_alert(user, "从[src]移除了试剂")
	user.mind?.adjust_experience(/datum/skill/primitive, 2)
