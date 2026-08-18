/**
 * Creates a TGUI input list window and returns the user's response.
 *
 * This proc should be used to create alerts that the caller will wait for a response from.
 * Arguments:
 * * user - The user to show the input box to.
 * * message - The content of the input box, shown in the body of the TGUI window.
 * * title - The title of the input box, shown on the top of the TGUI window.
 * * items - The options that can be chosen by the user, each string is assigned a button on the UI.
 * * default - If an option is already preselected on the UI. Current values, etc.
 * * timeout - The timeout of the input box, after which the menu will close and qdel itself. Set to zero for no timeout.
 */
/proc/tgui_input_list(mob/user, message, title = "Select", list/items, default, timeout = 0, ui_state = GLOB.always_state)
	if (!user)
		user = usr
	if(!length(items))
		return null
	if (!istype(user))
		if (istype(user, /client))
			var/client/client = user
			user = client.mob
		else
			return null

	if(isnull(user.client))
		return null

	/// Client does NOT have tgui_input on: Returns regular input
	if(!user.client.prefs.read_preference(/datum/preference/toggle/tgui_input))
		// NOVA EDIT ADDITION START - I18N: 原生 input() 回退分支同样要本地化（否则关掉 tgui 输入的玩家
		// 看到的是英文选项）。做法与 tgui 分支一致：显示串是纯显示，用「显示串 -> 原值」的 assoc 表兜回原值。
		// `input() ... in assoc_list` 的返回值在不同写法下可能是键也可能是值，两种都接住（少一个分支就是
		// 「选了没反应」）。查不到译名的项原样入表，行为与改动前一致。
		if(GLOB.i18n_server_locale != DEFAULT_UI_LOCALE)
			var/list/localized_items = list()
			var/localized_default
			for(var/item in items)
				if(isnull(item))
					continue
				var/label = lang_localize_display_name("[item]")
				if(localized_items[label]) // 两个英文名可能译成同一个中文：后者退回原样，保证不吞选项
					label = "[item]"
				localized_items[label] = item
				if(isnull(localized_default) && !isnull(default) && (item == default || "[item]" == "[default]"))
					localized_default = label
			var/picked = input(user, message, title, localized_default || default) as null|anything in localized_items
			if(isnull(picked))
				return null
			if(istext(picked) && !isnull(localized_items[picked]))
				return localized_items[picked]
			return picked
		// NOVA EDIT ADDITION END
		return input(user, message, title, default) as null|anything in items
	var/datum/tgui_list_input/input = new(user, message, title, items, default, timeout, ui_state)
	if(input.invalid)
		qdel(input)
		return
	input.ui_interact(user)
	input.wait()
	if (input)
		. = input.choice
		qdel(input)

/**
 * # tgui_list_input
 *
 * Datum used for instantiating and using a TGUI-controlled list input that prompts the user with
 * a message and shows a list of selectable options
 */
/datum/tgui_list_input
	/// The title of the TGUI window
	var/title
	/// The textual body of the TGUI window
	var/message
	/// The list of items (responses) provided on the TGUI window
	var/list/items
	/// Buttons (strings specifically) mapped to the actual value (e.g. a mob or a verb)
	var/list/items_map
	/// The button that the user has pressed, null if no selection has been made
	var/choice
	/// The default button to be selected
	var/default
	/// The time at which the tgui_list_input was created, for displaying timeout progress.
	var/start_time
	/// The lifespan of the tgui_list_input, after which the window will close and delete itself.
	var/timeout
	/// Boolean field describing if the tgui_list_input was closed by the user.
	var/closed
	/// The TGUI UI state that will be returned in ui_state(). Default: always_state
	var/datum/ui_state/state
	/// Whether the tgui list input is invalid or not (i.e. due to all list entries being null)
	var/invalid = FALSE

/datum/tgui_list_input/New(mob/user, message, title, list/items, default, timeout, ui_state)
	src.title = title
	src.message = message
	src.items = list()
	src.items_map = list()
	src.default = default
	src.state = ui_state
	var/list/repeat_items = list()
	// Gets rid of illegal characters
	// NOVA EDIT CHANGE - I18N - ORIGINAL upper bound was \u8000, which stripped every CJK ideograph above it
	// (舰 U+8230, 近 U+8FD1, 调 U+8C03 …; CJK Unified Ideographs span U+4E00-U+9FFF) -> every list-input option
	// with such a char silently lost it ("最近的下行通道"->"最的下行通道"). Extend to \uffff to keep all BMP/CJK.
	var/static/regex/whitelistedWords = regex(@{"([^\u0020-\uffff]+)"})
	// NOVA EDIT ADDITION START - I18N: 选项文本是**纯显示**——回传的 entry 只用来在 items_map 里取回原值，
	// 所以把显示串整串反查（含单词名，走精确反查不经 AC），items_map 用同一个显示串作键，往返仍然对得上。
	// `items` 在 P1 的 payload_skip_keys 里（值兼回传标识符），故此处是唯一的本地化点。
	// 注意 default 也要跟着换成显示形态，否则前端按 init_value 预选会落空。
	var/localized_default
	// NOVA EDIT ADDITION END
	for(var/i in items)
		if(!i)
			continue
		var/string_key = whitelistedWords.Replace("[i]", "")
		// NOVA EDIT ADDITION START - I18N
		var/original_key = string_key
		string_key = lang_localize_display_name(string_key) // locale==en 时 no-op
		// NOVA EDIT ADDITION END
		//avoids duplicated keys E.g: when areas have the same name
		string_key = avoid_assoc_duplicate_keys(string_key, repeat_items)
		src.items += string_key
		src.items_map[string_key] = i
		// NOVA EDIT ADDITION START - I18N: 去重在本地化之后跑（两个英文名可能译成同一个中文），
		// 所以 default 的显示形态只能在这里回收。
		if(isnull(localized_default) && !isnull(default) && (i == default || original_key == "[default]"))
			localized_default = string_key
		// NOVA EDIT ADDITION END
	// NOVA EDIT ADDITION START - I18N
	if(!isnull(localized_default))
		src.default = localized_default
	// NOVA EDIT ADDITION END

	if(length(src.items) == 0)
		invalid = TRUE
	if (timeout)
		src.timeout = timeout
		start_time = world.time
		QDEL_IN(src, timeout)

/datum/tgui_list_input/Destroy(force)
	SStgui.close_uis(src)
	state = null
	items?.Cut()
	items_map?.Cut()
	return ..()

/**
 * Waits for a user's response to the tgui_list_input's prompt before returning. Returns early if
 * the window was closed by the user.
 */
/datum/tgui_list_input/proc/wait()
	while (!choice && !closed)
		stoplag(1)

/datum/tgui_list_input/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ListInputWindow")
		ui.open()

/datum/tgui_list_input/ui_close(mob/user)
	. = ..()
	closed = TRUE

/datum/tgui_list_input/ui_state(mob/user)
	return state

/datum/tgui_list_input/ui_static_data(mob/user)
	var/list/data = list()
	data["init_value"] = default || items[1]
	data["items"] = items
	data["large_buttons"] = user.client.prefs.read_preference(/datum/preference/toggle/tgui_input_large)
	data["message"] = message
	data["swapped_buttons"] = user.client.prefs.read_preference(/datum/preference/toggle/tgui_input_swapped)
	data["title"] = title
	return data

/datum/tgui_list_input/ui_data(mob/user)
	var/list/data = list()
	if(timeout)
		data["timeout"] = clamp((timeout - (world.time - start_time) - 1 SECONDS) / (timeout - 1 SECONDS), 0, 1)
	return data

/datum/tgui_list_input/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if (.)
		return
	switch(action)
		if("submit")
			if (!(params["entry"] in items))
				return
			set_choice(items_map[params["entry"]])
			closed = TRUE
			SStgui.close_uis(src)
			return TRUE
		if("cancel")
			closed = TRUE
			SStgui.close_uis(src)
			return TRUE

/datum/tgui_list_input/proc/set_choice(choice)
	src.choice = choice
