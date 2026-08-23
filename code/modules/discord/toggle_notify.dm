// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
// Verb to toggle restart notifications
GAME_VERB_DESC(/client, notify_restart, "通知重启", "Notifies you on Discord when the server restarts.", "OOC")

	// Safety checks
	if(!CONFIG_GET(flag/sql_enabled))
		to_chat(src, span_warning(LANG("client.8256b1598a7aac59", null)))
		return

	if(!SSdiscord) // SS is still starting
		to_chat(src, span_notice(LANG("client.81e9f40ef488754d", null)))
		return

	if(!SSdiscord.enabled)
		to_chat(src, span_warning(LANG("client.a9d4495d46ef226b", null)))
		return

	var/stored_id = SSdiscord.lookup_id(usr.ckey)
	if(!stored_id) // Account is not linked
		to_chat(src, span_warning(LANG("client.a2b9f347f0a446b2", null)))
		return

	var/stored_mention = "<@[stored_id]>"
	for(var/member in SSdiscord.notify_members) // If they are in the list, take them out
		if(member == stored_mention)
			SSdiscord.notify_members -= stored_mention 
			to_chat(src, span_notice(LANG("client.7e168064d09be1f8", null)))
			return // This is necassary so it doesnt get added again, as it relies on the for loop being unsuccessful to tell us if they are in the list or not

	// If we got here, they arent in the list. Chuck 'em in!
	to_chat(src, span_notice(LANG("client.7996482f71a419cf", null)))
	SSdiscord.notify_members += "[stored_mention]" 
