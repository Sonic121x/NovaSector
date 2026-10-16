// ZH EDIT ADDITION START - I18N - Shared Discord display helpers
/proc/nova_tgs_connect_address()
	var/connect_address = CONFIG_GET(string/public_address) || CONFIG_GET(string/server)
	if(!connect_address)
		connect_address = world.internet_address ? "[world.internet_address]:[world.port]" : "r7.ctymc.cn:[world.port]"
	if(findtext(connect_address, "byond://") != 1)
		connect_address = "byond://[connect_address]"
	return connect_address

/proc/nova_tgs_map_name()
	var/map_name = SSmapping.current_map.map_name
	var/localized_map_name = lang_reverse_text(map_name)
	return localized_map_name != map_name ? "[localized_map_name]（[map_name]）" : map_name

/// Discord 消息里的服务器显示名：取 config SERVERNAME，未设则回落 "NovaSector"。
/// 这两处原本硬编码 "NovaSector"，是下游（天关13 等）每次同步都要改回自己服名、
/// 因而每次都冲突的点 —— 改成读 config 后下游本地 diff 归零。
/proc/nova_tgs_server_name()
	return CONFIG_GET(string/servername) || "NovaSector"
// ZH EDIT ADDITION END

/datum/tgs_chat_command/tgscheck
	name = "check"
	help_text = "查看服务器人数、地图、回合状态与连接地址" // ZH EDIT CHANGE - I18N - ORIGINAL: "Gets the playercount, gamemode, and address of the server"

/datum/tgs_chat_command/tgscheck/Run(datum/tgs_chat_user/sender, params)
	// ZH EDIT REMOVAL - I18N - ORIGINAL: return new /datum/tgs_message_content("[GLOB.round_id ? "Round #[GLOB.round_id]: " : ""][GLOB.clients.len] players on [SSmapping.current_map.map_name]; Round [SSticker.HasRoundStarted() ? (SSticker.IsRoundInProgress() ? "Active" : "Finishing") : "Starting"] -- [server ? server : "[world.internet_address]:[world.port]"]")
	// ZH EDIT ADDITION START - I18N - Localized Discord embed status card
	var/round_status = "准备中"
	var/embed_colour = "#F1C40F"
	if(SSticker.HasRoundStarted())
		if(SSticker.IsRoundInProgress())
			round_status = "进行中"
			embed_colour = "#2ECC71"
		else
			round_status = "即将结束"
			embed_colour = "#E67E22"

	var/datum/tgs_chat_embed/field/player_field = new("在线玩家", "[GLOB.clients.len] 人")
	player_field.is_inline = TRUE
	var/datum/tgs_chat_embed/field/map_field = new("当前地图", nova_tgs_map_name())
	map_field.is_inline = TRUE
	var/datum/tgs_chat_embed/field/address_field = new("连接地址", nova_tgs_connect_address())

	var/datum/tgs_chat_embed/structure/status_embed = new
	status_embed.title = GLOB.round_id ? "第 [GLOB.round_id] 局 · [round_status]" : "服务器状态 · [round_status]"
	status_embed.colour = embed_colour
	status_embed.fields = list(player_field, map_field, address_field)

	var/datum/tgs_message_content/response = new("📡 [nova_tgs_server_name()]")
	response.embed = status_embed
	return response
	// ZH EDIT ADDITION END

/datum/tgs_chat_command/gameversion
	name = "gameversion"
	help_text = "查看 BYOND、编译版本、代码提交与测试合并信息" // ZH EDIT CHANGE - I18N - ORIGINAL: "Gets the version details from the show-server-revision verb, basically"

/datum/tgs_chat_command/gameversion/Run(datum/tgs_chat_user/sender, params)
	var/list/msg = list("## 🧩 [nova_tgs_server_name()] 版本信息\n") // ZH EDIT CHANGE - I18N - ORIGINAL: list("")
	msg += "> ⚙️ **BYOND 运行版本：** [world.byond_version].[world.byond_build]\n> 🛠️ **DreamMaker 编译版本：** [DM_VERSION].[DM_BUILD]\n" // ZH EDIT CHANGE - I18N - ORIGINAL: "BYOND Server Version: ..."

	if (!GLOB.revdata)
		msg += "> ⚠️ **代码版本：** 未找到提交信息。" // ZH EDIT CHANGE - I18N - ORIGINAL: "No revision information found."
	else
		msg += "> 📦 **当前提交：** `[copytext_char(GLOB.revdata.commit, 1, 9)]`" // ZH EDIT CHANGE - I18N - ORIGINAL: "Revision ..."
		if (GLOB.revdata.date)
			msg += "（编译于 [GLOB.revdata.date]）" // ZH EDIT CHANGE - I18N - ORIGINAL: " compiled on ..."

		if(GLOB.revdata.originmastercommit)
			msg += "\n> 🌐 **上游提交：** <[CONFIG_GET(string/githuburl)]/commit/[GLOB.revdata.originmastercommit]>" // ZH EDIT CHANGE - I18N - ORIGINAL: ", from origin commit: ..."

		if(GLOB.revdata.testmerge.len)
			msg += "\n> 🧪 **测试合并：**\n" // ZH EDIT CHANGE - I18N - ORIGINAL: "\n"
			for(var/datum/tgs_revision_information/test_merge/PR as anything in GLOB.revdata.testmerge)
				msg += "> • PR #[PR.number] · `[copytext_char(PR.head_commit, 1, 9)]` · [PR.title]\n" // ZH EDIT CHANGE - I18N - ORIGINAL: "PR #..."
				if (PR.url)
					msg += ">   <[PR.url]>\n" // ZH EDIT CHANGE - I18N - ORIGINAL: "<[PR.url]>\n"
	return new /datum/tgs_message_content(msg.Join(""))

// Notify
/datum/tgs_chat_command/notify
	name = "notify"
	help_text = "订阅或取消订阅下一回合开始提醒" // ZH EDIT CHANGE - I18N - ORIGINAL: "Pings the invoker when the round ends"

/datum/tgs_chat_command/notify/Run(datum/tgs_chat_user/sender, params)
	if(!CONFIG_GET(str_list/channel_announce_new_game))
		return new /datum/tgs_message_content("⚠️ **回合通知当前未启用。**") // ZH EDIT CHANGE - I18N - ORIGINAL: "Notifcations are currently disabled"

	for(var/member in SSdiscord.notify_members) // If they are in the list, take them out
		if(member == sender.mention)
			SSdiscord.notify_members -= sender.mention
			return new /datum/tgs_message_content("🔕 **已取消订阅**\n> 服务器进入下一回合时将不再提醒你。") // ZH EDIT CHANGE - I18N - ORIGINAL: "You will no longer be notified when the server restarts"

	// If we got here, they arent in the list. Chuck 'em in!
	SSdiscord.notify_members += sender.mention
	return new /datum/tgs_message_content("🔔 **订阅成功**\n> 服务器进入下一回合时会提醒你。") // ZH EDIT CHANGE - I18N - ORIGINAL: "You will now be notified when the server restarts"
