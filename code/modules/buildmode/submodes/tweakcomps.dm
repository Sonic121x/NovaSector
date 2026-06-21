/datum/buildmode_mode/tweakcomps
	key = "tweakcomps"
	/// This variable is responsible for the rating of the components themselves. Literally tiers of components, where 1 is standard, 4 is bluespace.
	var/rating = null

/datum/buildmode_mode/tweakcomps/show_help(client/builder)
	to_chat(builder, span_purple(boxed_message(
		"[span_bold("Choose the rating of the components")] -> Right Mouse Button on buildmode button\n\
		[span_bold("Sets the chosen rating of the components on the machinery")] -> Left Mouse Button on machinery"))
	)

/datum/buildmode_mode/tweakcomps/change_settings(client/target_client)
	var/rating_to_choose = input(target_client, "输入评级数字", "数字", "1")
	rating_to_choose = text2num(rating_to_choose)
	if(!isnum(rating_to_choose))
		tgui_alert(target_client, "请输入一个数字。")
		return

	rating = rating_to_choose

/datum/buildmode_mode/tweakcomps/handle_click(client/target_client, params, obj/machinery/object)
	if(!ismachinery(object))
		to_chat(target_client, span_warning("这不是机器！"))
		return

	if(!object.component_parts)
		to_chat(target_client, span_warning("这台机器没有组件！"))
		return

	for(var/obj/item/stock_parts/P in object.component_parts)
		P.rating = rating
	object.RefreshParts()

	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Machine Upgrade", "[rating]")) // If you are copy-pasting this, ensure the 4th parameter is unique to the new proc!
