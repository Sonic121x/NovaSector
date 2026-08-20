/// Assets generated from `/datum/preference` icons
/datum/asset/spritesheet_batched/preferences
	name = "preferences"
	early = TRUE

/datum/asset/spritesheet_batched/preferences/create_spritesheets()
	for (var/preference_key in GLOB.preference_entries_by_key)
		var/datum/preference/choiced/preference = GLOB.preference_entries_by_key[preference_key]
		if (!istype(preference))
			continue

		if (!preference.should_generate_icons)
			continue

		for (var/preference_value in preference.get_choices())
			var/create_icon_of = preference.icon_for(preference_value)

			var/datum/universal_icon/icon

			if (ispath(create_icon_of, /atom))
				var/atom/atom_icon_source = create_icon_of
				icon = get_display_icon_for(atom_icon_source)
			else if (istype(create_icon_of, /datum/universal_icon))
				icon = create_icon_of
			else if (isicon(create_icon_of))
				CRASH("Icon given for preference [preference_key]:[preference_value]. This is not supported anymore, provide a /datum/universal_icon instead.")
			else
				CRASH("[create_icon_of] is an invalid preference value (from [preference_key]:[preference_value]).")
			// There's no cost associated with inserting uni_icons, so just insert them immediately.
			var/spritesheet_key = preference.get_spritesheet_key(preference.serialize(preference_value))
			insert_icon(spritesheet_key, icon)

/// Returns the key that will be used in the spritesheet for a given value.
/datum/preference/proc/get_spritesheet_key(value)
	return "[savefile_key]___[sanitize_css_class_name(value)]"

/// Sends information needed for shared details on individual preferences
/datum/asset/json/preferences
	name = "preferences"

/datum/asset/json/preferences/generate()
	var/list/preference_data = list()

	for (var/middleware_type in subtypesof(/datum/preference_middleware))
		var/datum/preference_middleware/middleware = new middleware_type
		var/data = middleware.get_constant_data()
		if (!isnull(data))
			preference_data[middleware.key] = data

		qdel(middleware)

	for (var/preference_type in GLOB.preference_entries)
		var/datum/preference/preference_entry = GLOB.preference_entries[preference_type]
		var/data = preference_entry.compile_constant_data()
		if (!isnull(data))
			preference_data[preference_entry.savefile_key] = data

	// NOVA EDIT ADDITION START - i18n - 此 asset 是单独 fetch 的静态资源（前端 resolveAsset
	// ('preferences.json')），不经 get_payload，所以 TGUI 负载那条路够不着它。
	// 走**同一套 overlay 机制**：值一律不动（name/choices/department 这些既是显示又是标识符），
	// 只把「英文 → 译文」收进 data["i18n"]，由前端在渲染期查表。
	// 从前这里是一张手写白名单（pref_desc_keys）+ 就地改写，只覆盖 description 一类；overlay 没有
	// 这个限制，且不动数据，所以覆盖面更大、风险更小。
	if(GLOB.i18n_server_locale != DEFAULT_UI_LOCALE)
		var/list/i18n_overlay = list()
		lang_reverse_tree(preference_data, null, i18n_overlay)
		if(length(i18n_overlay))
			preference_data["i18n"] = i18n_overlay
	// NOVA EDIT ADDITION END

	return preference_data
