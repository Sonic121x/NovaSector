// ZH EDIT ADDITION START - I18N - Localize Discord admin command results without changing permission checks
/proc/nova_tgs_localize_ahelp_result(result)
	if(!istext(result))
		return result

	// 保险：这些是**生产侧的英文标识符**（ahelp 过程的返回值），本 proc 的职责就是拿英文比对再译成中文。
	// 但它们同时也在 en 目录里（nova-i18n lint 的「标识符耦合」告警），万一将来生产侧被 LANG 化 /
	// 被某层反查成中文，下面的 switch 会静默全 miss、命令结果直接漏出原文。lang_unreverse_text 把
	// 中文兜回英文键；已是英文时原样返回，en locale 下更是 no-op。
	result = lang_unreverse_text(result)

	switch(result)
		if("Message Successful")
			return "✅ **消息发送成功。**"
		if("None")
			return "ℹ️ **该玩家没有历史工单。**"
		if("Error: No client")
			return "❌ **发送失败：** 目标玩家当前不在线。"
		if("Error: No message")
			return "❌ **发送失败：** 消息内容为空。"
		if("Error: Ticket could not be found")
			return "❌ **操作失败：** 找不到对应工单。"

	result = replacetext(result, "Usage: ticket <close|resolve|icissue|reject|reopen \[ticket #\]|list>", "用法：`ticket <close|resolve|icissue|reject|reopen \[工单号\]|list>`")
	result = replacetext(result, "Ticket #", "工单 #")
	result = replacetext(result, " successfully closed", " 已成功关闭")
	result = replacetext(result, " successfully resolved", " 已成功解决")
	result = replacetext(result, " successfully marked as IC issue", " 已标记为 IC 问题")
	result = replacetext(result, " successfully rejected", " 已成功驳回")
	result = replacetext(result, " successfully reopened", " 已重新打开")
	result = replacetext(result, " already has ticket ", " 已有未结工单 ")
	result = replacetext(result, "No/Invalid ticket id specified.", "未提供有效的工单号。")
	result = replacetext(result, " belongs to ", " 属于 ")
	result = replacetext(result, " not found", " 不存在")
	result = replacetext(result, "Active: ", "处理中：")
	result = replacetext(result, "Error: ", "❌ **操作失败：** ")
	return result

/proc/nova_tgs_localize_namecheck_result(result)
	result = lang_unreverse_text(result) // 同上：反查成中文时兜回英文键，否则下面的比较会 miss
	if(result == "Search Failed")
		return "❌ **未找到匹配的玩家。**"
	result = replacetext(result, "Name: ", "名称：")
	result = replacetext(result, " Key: ", "　Key：")
	result = replacetext(result, " Ckey: ", "　Ckey：")
	result = replacetext(result, "(Antag)", "（反派）")
	return "## 🔎 玩家查询结果\n> [result]"

/proc/nova_tgs_localize_adminwho_result(result)
	result = replacetext(result, "Admins: ", "")
	result = replacetext(result, "(Stealth)", "（隐身）")
	result = replacetext(result, "(AFK)", "（离开）")
	if(!length(trim(result)))
		return "## 👮 在线管理员\n> 当前没有在线管理员。"
	return "## 👮 在线管理员\n> [result]"

/proc/nova_tgs_name_list(list/names)
	return length(names) ? names.Join("、") : "无"
// ZH EDIT ADDITION END

/// Reload admins tgs chat command. Intentionally not validated.
/datum/tgs_chat_command/reload_admins
	name = "reload_admins"
	help_text = "【管理员】强制重新加载管理员列表" // ZH EDIT CHANGE - I18N - ORIGINAL: "Forces the server to reload admins."
	admin_only = TRUE

/datum/tgs_chat_command/reload_admins/Run(datum/tgs_chat_user/sender, params)
	ReloadAsync()
	log_admin("[sender.friendly_name] reloaded admins via chat command.")
	message_admins("[sender.friendly_name] reloaded admins via chat command.")
	return new /datum/tgs_message_content("✅ **管理员列表已重新加载。**") // ZH EDIT CHANGE - I18N - ORIGINAL: "Admins reloaded."

/datum/tgs_chat_command/reload_admins/proc/ReloadAsync()
	set waitfor = FALSE
	load_admins()

/// subtype tgs chat command with validated admin ranks. Only supports discord.
/datum/tgs_chat_command/validated
	ignore_type = /datum/tgs_chat_command/validated
	admin_only = TRUE
	var/required_rights = 0 //! validate discord userid is linked to a game admin with these flags.


/// called by tgs
/datum/tgs_chat_command/validated/Run(datum/tgs_chat_user/sender, params)
	if (!CONFIG_GET(flag/secure_chat_commands) || CONFIG_GET(flag/admin_legacy_system) || !SSdbcore.Connect())
		return Validated_Run(sender, params)

	var/discord_id = SSdiscord.get_discord_id_from_mention(sender.mention) || sender.id
	if (!discord_id)
		return new /datum/tgs_message_content("❌ **身份验证失败**\n> 无法获取你的 Discord ID。") // ZH EDIT CHANGE - I18N - ORIGINAL: "Error: Unknown error trying to get your discord id."

	var/datum/admins/linked_admin
	var/admin_ckey = ckey(SSdiscord.lookup_ckey(discord_id))

	if (admin_ckey)
		linked_admin = GLOB.admin_datums[admin_ckey] || GLOB.deadmins[admin_ckey]
	else
		return new /datum/tgs_message_content("❌ **身份验证失败**\n> 该 Discord 账号尚未绑定游戏 ckey。") // ZH EDIT CHANGE - I18N - ORIGINAL: "Error: Could not find a linked ckey for your discord id."

	if (!linked_admin)
		return new /datum/tgs_message_content("❌ **身份验证失败**\n> 已绑定的 ckey `[admin_ckey]` 不在管理员列表中。若信息刚刚变更，请尝试 `reload_admins`。") // ZH EDIT CHANGE - I18N - ORIGINAL: linked ckey not found

	if (!linked_admin.check_for_rights(required_rights))
		return new /datum/tgs_message_content("⛔ **权限不足**\n> ckey `[admin_ckey]` 缺少所需权限标志：`[rights2text(required_rights," ")]`") // ZH EDIT CHANGE - I18N - ORIGINAL: insufficient rights

	return Validated_Run(sender, params)


/// Called if the sender passes validation checks or if those checks are disabled.
/datum/tgs_chat_command/validated/proc/Validated_Run(datum/tgs_chat_user/sender, params)
	RETURN_TYPE(/datum/tgs_message_content)
	CRASH("[type] has no implementation for Validated_Run()")

/datum/tgs_chat_command/validated/ahelp
	name = "ahelp"
	help_text = "【管理员】向玩家发送消息或管理管理员工单" // ZH EDIT CHANGE - I18N - ORIGINAL: ahelp syntax
	admin_only = TRUE
	required_rights = R_ADMIN

/datum/tgs_chat_command/validated/ahelp/Validated_Run(datum/tgs_chat_user/sender, params)
	var/list/all_params = splittext(params, " ")
	if(all_params.len < 2)
		return new /datum/tgs_message_content("⚠️ **参数不足**\n> 用法：`ahelp <ckey|工单号> <消息|ticket 操作>`") // ZH EDIT CHANGE - I18N - ORIGINAL: "Insufficient parameters"
	var/target = all_params[1]
	all_params.Cut(1, 2)
	var/id = text2num(target)
	if(id != null)
		var/datum/admin_help/AH = GLOB.ahelp_tickets.TicketByID(id)
		if(AH)
			target = AH.initiator_ckey
		else
			return new /datum/tgs_message_content("❌ **找不到工单 #[id]。**") // ZH EDIT CHANGE - I18N - ORIGINAL: "Ticket #[id] not found!"
	return new /datum/tgs_message_content(nova_tgs_localize_ahelp_result(TgsPm(target, all_params.Join(" "), sender.friendly_name))) // ZH EDIT CHANGE - I18N - ORIGINAL: raw TgsPm result

/datum/tgs_chat_command/validated/namecheck
	name = "namecheck"
	help_text = "【管理员】查询指定玩家的名称、Key、ckey 与反派状态" // ZH EDIT CHANGE - I18N - ORIGINAL: "Returns info on the specified target"
	admin_only = TRUE
	required_rights = R_ADMIN

/datum/tgs_chat_command/validated/namecheck/Validated_Run(datum/tgs_chat_user/sender, params)
	params = trim(params)
	if(!params)
		return new /datum/tgs_message_content("⚠️ **参数不足**\n> 用法：`namecheck <玩家名称|ckey>`") // ZH EDIT CHANGE - I18N - ORIGINAL: "Insufficient parameters"
	log_admin("Chat Name Check: [sender.friendly_name] on [params]")
	message_admins("Name checking [params] from [sender.friendly_name]")
	return new /datum/tgs_message_content(nova_tgs_localize_namecheck_result(keywords_lookup(params, 1))) // ZH EDIT CHANGE - I18N - ORIGINAL: raw keywords_lookup result

/datum/tgs_chat_command/validated/adminwho
	name = "adminwho"
	help_text = "【管理员】列出当前在线管理员" // ZH EDIT CHANGE - I18N - ORIGINAL: "Lists administrators currently on the server"
	admin_only = TRUE
	required_rights = 0

/datum/tgs_chat_command/validated/adminwho/Validated_Run(datum/tgs_chat_user/sender, params)
	return new /datum/tgs_message_content(nova_tgs_localize_adminwho_result(tgsadminwho())) // ZH EDIT CHANGE - I18N - ORIGINAL: raw tgsadminwho result

/datum/tgs_chat_command/validated/sdql
	name = "sdql"
	help_text = "【管理员】执行 SDQL 查询" // ZH EDIT CHANGE - I18N - ORIGINAL: "Runs an SDQL query"
	admin_only = TRUE
	required_rights = R_DEBUG

/datum/tgs_chat_command/validated/sdql/Validated_Run(datum/tgs_chat_user/sender, params)
	var/list/results = HandleUserlessSDQL(sender.friendly_name, params)
	if(!results)
		return new /datum/tgs_message_content("ℹ️ **查询完成，但没有返回结果。**") // ZH EDIT CHANGE - I18N - ORIGINAL: "Query produced no output"
	var/list/text_res = results.Copy(1, 3)
	var/list/refs = results.len > 3 ? results.Copy(4) : null
	return new /datum/tgs_message_content("## 🗄️ SDQL 查询结果\n```\n[text_res.Join("\n")]\n```[refs ? "\n**引用：** `[refs.Join(" ")]`" : ""]") // ZH EDIT CHANGE - I18N - ORIGINAL: raw query output

/datum/tgs_chat_command/validated/tgsstatus
	name = "status"
	help_text = "【管理员】查看管理员、玩家与回合状态" // ZH EDIT CHANGE - I18N - ORIGINAL: server status description
	admin_only = TRUE
	required_rights = R_ADMIN

/datum/tgs_chat_command/validated/tgsstatus/Validated_Run(datum/tgs_chat_user/sender, params)
	var/list/adm = get_admin_counts()
	var/list/allmins = adm["total"]
	// ZH EDIT REMOVAL - I18N - ORIGINAL: English one-line status output
	// ZH EDIT ADDITION START - I18N - Localized Discord admin status card
	var/round_status = SSticker.HasRoundStarted() ? (SSticker.IsRoundInProgress() ? "🟢 进行中" : "🟠 正在结束") : "🟡 准备中"
	var/status = "## 🛡️ NovaSector 管理状态\n"
	status += "> 👮 **管理员总数：** [allmins.len]\n"
	status += "> • 在线：[nova_tgs_name_list(adm["present"])]\n"
	status += "> • 离开：[nova_tgs_name_list(adm["afk"])]\n"
	status += "> • 隐身：[nova_tgs_name_list(adm["stealth"])]\n"
	status += "> • 无有效权限：[nova_tgs_name_list(adm["noflags"])]\n"
	status += "> 👥 **玩家总数：** [GLOB.clients.len]（活跃 [get_active_player_count(FALSE, TRUE, FALSE)]）\n"
	status += "> [round_status] **回合状态**"
	// ZH EDIT ADDITION END
	return new /datum/tgs_message_content(status)
