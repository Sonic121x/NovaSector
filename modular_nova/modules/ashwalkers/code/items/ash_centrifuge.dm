/obj/item/reagent_containers/cup/primitive_centrifuge
	name = "primitive centrifuge"
	desc = "A small cup that allows a person to slowly spin out liquids they do not desire."
	icon = 'modular_nova/modules/ashwalkers/icons/misc_tools.dmi'
	icon_state = "primitive_centrifuge"
	material_flags = MATERIAL_EFFECTS | MATERIAL_ADD_PREFIX | MATERIAL_COLOR

/obj/item/reagent_containers/cup/primitive_centrifuge/examine()
	. = ..()
	. += span_notice(LANG("obj.90f418765c927d9e", null))
	. += span_notice(LANG("obj.3c494ff413f418e9", null))

/obj/item/reagent_containers/cup/primitive_centrifuge/item_ctrl_click(mob/user)
	if(!length(reagents.reagent_list))
		return CLICK_ACTION_BLOCKING

	var/datum/user_input = tgui_input_list(user, LANG("obj.0a9964b3c6fbe2c1", null), LANG("obj.a932fd8a271a373d", null), reagents.reagent_list)

	if(isnull(user_input))
		balloon_alert(user, LANG("obj.72281623be840217", null))
		return CLICK_ACTION_BLOCKING

	user.balloon_alert_to_viewers(LANG("obj.8f40aab1117f227a", list(src)))
	var/skill_modifier = user.mind?.get_skill_modifier(/datum/skill/primitive, SKILL_SPEED_MODIFIER)
	if(!do_after(user, 5 SECONDS * skill_modifier, target = src))
		user.balloon_alert_to_viewers(LANG("obj.0b54d29b59e8554b", list(src)))
		return CLICK_ACTION_BLOCKING

	reagents.del_reagent(user_input.type)
	balloon_alert(user, LANG("obj.f454cbd10741cb89", list(src)))
	user.mind?.adjust_experience(/datum/skill/primitive, 2)
	return CLICK_ACTION_SUCCESS

/obj/item/reagent_containers/cup/primitive_centrifuge/click_ctrl_shift(mob/user)
	if(!length(reagents.reagent_list))
		return

	var/datum/user_input = tgui_input_list(user, LANG("obj.00ce1a55b839c5de", null), LANG("obj.c9c324697ffa4b3c", null), reagents.reagent_list)

	if(isnull(user_input))
		balloon_alert(user, LANG("obj.72281623be840217", null))
		return

	user.balloon_alert_to_viewers(LANG("obj.8f40aab1117f227a", list(src)))
	var/skill_modifier = user.mind?.get_skill_modifier(/datum/skill/primitive, SKILL_SPEED_MODIFIER)
	if(!do_after(user, 5 SECONDS * skill_modifier, target = src))
		user.balloon_alert_to_viewers(LANG("obj.0b54d29b59e8554b", list(src)))
		return

	for(var/datum/reagent/remove_reagent in reagents.reagent_list)
		if(!istype(remove_reagent, user_input.type))
			reagents.del_reagent(remove_reagent.type)

	balloon_alert(user, LANG("obj.54df0461be423f42", list(src)))
	user.mind?.adjust_experience(/datum/skill/primitive, 2)
