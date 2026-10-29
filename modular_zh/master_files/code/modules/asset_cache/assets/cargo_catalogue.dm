// ZH EDIT ADDITION - I18N
// The cargo catalogue is a separately fetched JSON asset, so it never goes through get_payload and the
// payload overlay. Collect the translations here the same way, leaving every value canonical English.
/datum/asset/json/cargo_catalogue/generate()
	. = ..()
	if(GLOB.i18n_server_locale == DEFAULT_UI_LOCALE)
		return
	var/list/i18n_overlay = list()
	lang_reverse_tree(., null, i18n_overlay)
	// Group names reach the UI as keys of the window data's groups list, which the payload overlay
	// treats as identifiers. They're display only (tabs and headers), so register them here.
	var/list/group_names = list()
	for(var/pack_id, pack_data in SSshuttle.supply_packs)
		var/datum/supply_pack/pack = pack_data
		if(istext(pack.group))
			group_names |= pack.group
	lang_reverse_tree(group_names, null, i18n_overlay)
	if(length(i18n_overlay))
		.["i18n"] = i18n_overlay
