// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/buildmode_mode/tweakcomps
	key = "tweakcomps"
	/// This variable is responsible for the rating of the components themselves. Literally tiers of components, where 1 is standard, 4 is bluespace.
	var/rating = null

/datum/buildmode_mode/tweakcomps/show_help(client/builder)
	to_chat(builder, span_purple(boxed_message(
		LANG("datum.adb29bd14e63698f", list(span_bold("Choose the rating of the components"), span_bold("Sets the chosen rating of the components on the machinery")))))
	)

/datum/buildmode_mode/tweakcomps/change_settings(client/target_client)
	var/rating_to_choose = input(target_client, LANG("datum.de0322598a21cb6b", null), LANG("datum.cc8ce72b190068e3", null), "1")
	rating_to_choose = text2num(rating_to_choose)
	if(!isnum(rating_to_choose))
		tgui_alert(target_client, LANG("datum.575f43b664ae35ad", null))
		return

	rating = rating_to_choose

/datum/buildmode_mode/tweakcomps/handle_click(client/target_client, params, obj/machinery/object)
	if(!ismachinery(object))
		to_chat(target_client, span_warning(LANG("datum.f5a2227ef4764331", null)))
		return

	if(!object.component_parts)
		to_chat(target_client, span_warning(LANG("datum.54f320e1ad19b9fc", null)))
		return

	for(var/obj/item/stock_parts/P in object.component_parts)
		P.rating = rating
	object.RefreshParts()

	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Machine Upgrade", "[rating]")) // If you are copy-pasting this, ensure the 4th parameter is unique to the new proc!
