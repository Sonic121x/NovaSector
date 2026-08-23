// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/buildmode_mode/copy
	key = "copy"
	var/atom/movable/stored = null

/datum/buildmode_mode/copy/Destroy()
	stored = null
	return ..()

/datum/buildmode_mode/copy/show_help(client/builder)
	to_chat(builder, span_purple(boxed_message(
		LANG("datum.5ce85dc5e3eb6394", list(span_bold("Spawn a copy of selected target"), span_bold("Select target to copy")))))
	)

/datum/buildmode_mode/copy/handle_click(client/c, params, obj/object)
	var/list/modifiers = params2list(params)

	if(LAZYACCESS(modifiers, LEFT_CLICK))
		var/turf/T = get_turf(object)
		if(stored)
			duplicate_object(stored, spawning_location = T)
			log_admin("Build Mode: [key_name(c)] copied [stored] to [AREACOORD(object)]")
	else if(LAZYACCESS(modifiers, RIGHT_CLICK))
		if(ismovable(object)) // No copying turfs for now.
			to_chat(c, span_notice(LANG("datum.a7d095fea9f639ae", list(object))))
			stored = object
