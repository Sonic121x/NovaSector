/datum/config_entry/flag/enable_relays

/datum/config_entry/keyed_list/relay_option
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_TEXT
	lowercase_key = FALSE
	splitter = ","

GAME_VERB_HIDDEN(/client, connect_to_relay, "Connect to Relay")
	if(!CONFIG_GET(flag/enable_relays))
		to_chat(src, span_danger(LANG("client.e735287b63d06137", null)))
		return

	var/static/list/available_relays
	if(isnull(available_relays))
		available_relays = CONFIG_GET(keyed_list/relay_option)

	if(!length(available_relays))
		to_chat(src, span_danger(LANG("client.dd83f55e5daa8d53", null)))
		return

	var/choice = tgui_input_list(usr, LANG("client.ad08a62ae8a1c599", null), LANG("client.a135c8d5aa9129ca", null), available_relays)
	if(isnull(choice))
		return
	var/address = available_relays[choice]
	if(isnull(address))
		return

	usr << link(address)
	sleep(1 SECONDS)
	winset(usr, null, "command=.quit")
