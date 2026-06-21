// Verb to toggle restart notifications
/client/verb/notify_restart()
	set category = "OOC"
	set name = "Notify Restart"
	set desc = "Notifies you on Discord when the server restarts."

	// Safety checks
	if(!CONFIG_GET(flag/sql_enabled))
		to_chat(src, span_warning("此功能需要SQL后端正在运行。"))
		return

	if(!SSdiscord) // SS is still starting
		to_chat(src, span_notice("服务器仍在启动中。请稍后再尝试关联您的账户。"))
		return

	if(!SSdiscord.enabled)
		to_chat(src, span_warning("此功能要求服务器运行在TGS工具包上。"))
		return

	var/stored_id = SSdiscord.lookup_id(usr.ckey)
	if(!stored_id) // Account is not linked
		to_chat(src, span_warning("这需要您使用“关联Discord账户”动词来关联您的Discord账户。"))
		return

	var/stored_mention = "<@[stored_id]>"
	for(var/member in SSdiscord.notify_members) // If they are in the list, take them out
		if(member == stored_mention)
			SSdiscord.notify_members -= stored_mention 
			to_chat(src, span_notice("服务器重启时将不再通知您。"))
			return // This is necassary so it doesnt get added again, as it relies on the for loop being unsuccessful to tell us if they are in the list or not

	// If we got here, they arent in the list. Chuck 'em in!
	to_chat(src, span_notice("服务器重启时将会通知您。"))
	SSdiscord.notify_members += "[stored_mention]" 
