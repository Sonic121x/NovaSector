// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/machinery/netpod/crowbar_act(mob/living/user, obj/item/tool)
	if(user.combat_mode)
		attack_hand(user)
		return ITEM_INTERACT_SUCCESS

	return default_pry_open(user, tool, deconstruct_on_fail = TRUE)

/obj/machinery/netpod/screwdriver_act(mob/living/user, obj/item/tool)
	if(occupant)
		balloon_alert(user, LANG("obj.d2232fc97a3a2f66", null))
		return ITEM_INTERACT_SUCCESS

	if(state_open)
		balloon_alert(user, LANG("obj.1bd34d987bac1db7", null))
		return ITEM_INTERACT_SUCCESS

	return default_deconstruction_screwdriver(user, tool)
