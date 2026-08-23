// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/buildmode_mode/smite
	key = "smite"
	var/datum/smite/selected_smite

/datum/buildmode_mode/smite/Destroy()
	selected_smite = null
	return ..()

/datum/buildmode_mode/smite/show_help(client/builder)
	to_chat(builder, span_purple(boxed_message(
		LANG("datum.4c8a32dd852b35ec", list(span_bold("Select smite to use"), span_bold("Smite the mob")))))
	)

/datum/buildmode_mode/smite/change_settings(client/user)
	var/punishment = input(user, LANG("datum.60db9e8f61895d17", null), LANG("datum.9d9602b111c1f0e3", null)) as null|anything in GLOB.smites
	var/smite_path = GLOB.smites[punishment]
	var/datum/smite/picking_smite = new smite_path
	var/configuration_success = picking_smite.configure(user)
	if (configuration_success == FALSE)
		return
	selected_smite = picking_smite

/datum/buildmode_mode/smite/handle_click(client/user, params, object)
	var/list/modifiers = params2list(params)

	if (!check_rights(R_ADMIN | R_FUN))
		return

	if (!LAZYACCESS(modifiers, LEFT_CLICK))
		return

	if (!isliving(object))
		return

	if (selected_smite == null)
		to_chat(user, span_notice(LANG("datum.a1431690b6651361", null)))
		return

	selected_smite.do_effect(user, object)
