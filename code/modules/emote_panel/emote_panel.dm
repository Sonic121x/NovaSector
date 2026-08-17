// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/emote_panel
	var/list/blacklisted_emotes = list("me", "help")

/datum/emote_panel/ui_static_data(mob/user)
	var/list/data = list()

	var/list/emotes = list()
	var/list/keys = list()

	for(var/key in GLOB.emote_list)
		for(var/datum/emote/emote in GLOB.emote_list[key])
			if(emote.key in keys)
				continue
			if(emote.key in blacklisted_emotes)
				continue
			if(emote.can_run_emote(user, status_check = FALSE, intentional = FALSE))
				keys += emote.key
				emotes += list(list(
					"key" = emote.key,
					"name" = lang_localize_display_name(emote.name), // NOVA EDIT - I18N: 纯显示，act 走同条负载的 emote_key。ORIGINAL: "name" = emote.name,
					"hands" = emote.hands_use_check,
					"visible" = emote.emote_type & EMOTE_VISIBLE,
					"audible" = emote.emote_type & EMOTE_AUDIBLE,
					"sound" = !isnull(emote.get_sound(user)),
					"use_params" = emote.message_param,
				))

	data["emotes"] = emotes

	return data

/datum/emote_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if("play_emote")
			var/emote_key = params["emote_key"]
			if(isnull(emote_key) || !GLOB.emote_list[emote_key])
				return
			var/use_params = params["use_params"]
			var/datum/emote/emote = GLOB.emote_list[emote_key][1]
			var/emote_param
			if(emote.message_param && use_params)
				emote_param = tgui_input_text(ui.user, LANG("datum.47682473", null), emote.message_param, max_length = MAX_MESSAGE_LEN)
			ui.user.emote(emote_key, message = emote_param, intentional = TRUE)
		if("preview_sound")
			var/emote_key = params["emote_key"]
			if(isnull(emote_key) || !GLOB.emote_list[emote_key])
				return
			var/datum/emote/emote = GLOB.emote_list[emote_key][1]
			var/emote_sound = get_sfx(emote.get_sound(ui.user))
			if(!emote_sound)
				to_chat(ui.user, span_warning(LANG("datum.5bfca82f", list(emote.name))), type = MESSAGE_TYPE_INFO)
				return
			SEND_SOUND(ui.user, sound(emote_sound, volume = 75))
			to_chat(ui.user, span_warning(LANG("datum.db3d4a00", list(emote.name))), type = MESSAGE_TYPE_INFO)

/datum/emote_panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "EmotePanel")
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/emote_panel/ui_state(mob/user)
	return GLOB.always_state
