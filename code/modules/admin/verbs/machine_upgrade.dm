// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
ADMIN_VERB_ONLY_CONTEXT_MENU(machine_upgrade, R_DEBUG, "调整组件评级", obj/machinery/machine)
	if(!ismachinery(machine))
		return
	var/new_rating = tgui_input_number(user, "", LANG("datum.c202dd0a", null))
	if(new_rating && machine.component_parts)
		for(var/obj/item/stock_parts/P in machine.component_parts)
			P.rating = new_rating
		machine.RefreshParts()
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Machine Upgrade", "[new_rating]")) // If you are copy-pasting this, ensure the 4th parameter is unique to the new proc!
