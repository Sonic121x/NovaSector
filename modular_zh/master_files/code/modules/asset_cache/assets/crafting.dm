// ZH EDIT ADDITION - I18N
// Crafting and cooking recipes are a separately fetched JSON asset, so they never go through get_payload and
// the payload overlay. Collect the translations here the same way, leaving every value canonical English
// (categories and atom names are compared and looked up by the UI).
/datum/asset/json/crafting_recipes/generate()
	. = ..()
	if(GLOB.i18n_server_locale == DEFAULT_UI_LOCALE)
		return
	var/list/i18n_overlay = list()
	lang_reverse_tree(., null, i18n_overlay)
	if(length(i18n_overlay))
		.["i18n"] = i18n_overlay
