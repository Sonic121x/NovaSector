// ZH EDIT ADDITION - I18N
// The techweb catalogue is a separately fetched JSON asset, so it never goes through get_payload and the
// payload overlay. Collect the translations here the same way, leaving every value canonical English.
/datum/asset/json/techweb_catalogue/generate()
	. = ..()
	if(GLOB.i18n_server_locale == DEFAULT_UI_LOCALE)
		return
	var/list/i18n_overlay = list()
	lang_reverse_tree(., null, i18n_overlay)
	if(length(i18n_overlay))
		.["i18n"] = i18n_overlay
