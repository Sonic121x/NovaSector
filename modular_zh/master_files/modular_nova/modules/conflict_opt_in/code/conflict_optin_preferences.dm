/// The level names are display-only (the values are numbers), so they are translated here, where the
/// preferences menu gets them. The same words translate the examine line through `_state_words.json`.
/datum/preference/choiced/conflict_opt_in_status/compile_constant_data()
	var/list/data = ..()
	var/list/display_names = data[CHOICED_PREFERENCE_DISPLAY_NAMES]
	if(islist(display_names) && GLOB.i18n_server_locale != DEFAULT_UI_LOCALE)
		var/list/localized = list()
		for(var/level in display_names)
			localized[level] = lang_localize_arg(display_names[level])
		data[CHOICED_PREFERENCE_DISPLAY_NAMES] = localized
	return data
