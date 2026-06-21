/datum/admins/proc/stickyban(action,data)
	if(!check_rights(R_BAN))
		return
	switch (action)
		if ("show")
			stickyban_show()
		if ("add")
			var/list/ban = list()
			var/ckey
			ban["admin"] = usr.ckey
			ban["type"] = list("sticky")
			ban["reason"] = "(InGameBan)([usr.key])" //this will be displayed in dd only

			if (data["ckey"])
				ckey = ckey(data["ckey"])
			else
				ckey = input(usr,"Ckey","Ckey","") as text|null
				if (!ckey)
					return
				ckey = ckey(ckey)
			ban["ckey"] = ckey

			if (get_stickyban_from_ckey(ckey))
				to_chat(usr, span_adminnotice("错误：无法添加粘性封禁：用户当前已有粘性封禁"), confidential = TRUE)
				return

			if (data["reason"])
				ban["message"] = data["reason"]
			else
				var/reason = input(usr,"Reason","Reason","Ban Evasion") as text|null
				if (!reason)
					return
				ban["message"] = "[reason]"

			if(SSdbcore.Connect())
				var/datum/db_query/query_create_stickyban = SSdbcore.NewQuery({"
					INSERT INTO [format_table_name("stickyban")] (ckey, reason, banning_admin)
					VALUES (:ckey, :message, :banning_admin)
				"}, list("ckey" = ckey, "message" = ban["message"], "banning_admin" = usr.ckey))
				if (query_create_stickyban.warn_execute())
					ban["fromdb"] = TRUE
				qdel(query_create_stickyban)

			world.SetConfig("ban",ckey,list2stickyban(ban))
			ban = stickyban2list(list2stickyban(ban))
			ban["matches_this_round"] = list()
			ban["existing_user_matches_this_round"] = list()
			ban["admin_matches_this_round"] = list()
			ban["pending_matches_this_round"] = list()
			SSstickyban.cache[ckey] = ban

			log_admin_private("[key_name(usr)] has stickybanned [ckey].\nReason: [ban["message"]]")
			message_admins(span_adminnotice("[key_name_admin(usr)] has stickybanned [ckey].\nReason: [ban["message"]]"))

		if ("remove")
			if (!data["ckey"])
				return
			var/ckey = data["ckey"]

			var/ban = get_stickyban_from_ckey(ckey)
			if (!ban)
				to_chat(usr, span_adminnotice("错误：未找到[ckey]的粘性封禁！"), confidential = TRUE)
				return
			if (tgui_alert(usr,"你确定要移除对 [ckey] 的粘性封禁吗？","确定吗",list("Yes","No")) == "No")
				return
			if (!get_stickyban_from_ckey(ckey))
				to_chat(usr, span_adminnotice("错误：封禁已消失。"), confidential = TRUE)
				return
			world.SetConfig("ban",ckey, null)
			SSstickyban.cache -= ckey

			if (SSdbcore.Connect())
				SSdbcore.QuerySelect(list(
					SSdbcore.NewQuery("DELETE FROM [format_table_name("stickyban")] WHERE ckey = :ckey", list("ckey" = ckey)),
					SSdbcore.NewQuery("DELETE FROM [format_table_name("stickyban_matched_ckey")] WHERE stickyban = :ckey", list("ckey" = ckey)),
					SSdbcore.NewQuery("DELETE FROM [format_table_name("stickyban_matched_cid")] WHERE stickyban = :ckey", list("ckey" = ckey)),
					SSdbcore.NewQuery("DELETE FROM [format_table_name("stickyban_matched_ip")] WHERE stickyban = :ckey", list("ckey" = ckey))
				), warn = TRUE, qdel = TRUE)


			log_admin_private("[key_name(usr)] removed [ckey]'s stickyban")
			message_admins(span_adminnotice("[key_name_admin(usr)]移除了[ckey]的粘性封禁"))

		if ("remove_alt")
			if (!data["ckey"])
				return
			var/ckey = data["ckey"]
			if (!data["alt"])
				return
			var/alt = ckey(data["alt"])
			var/ban = get_stickyban_from_ckey(ckey)
			if (!ban)
				to_chat(usr, span_adminnotice("错误：未找到[ckey]的粘性封禁！"), confidential = TRUE)
				return

			var/key = LAZYACCESS(ban["keys"], alt)
			if (!key)
				to_chat(usr, span_adminnotice("错误：[alt]未关联到[ckey]的粘性封禁！"), confidential = TRUE)
				return

			if (tgui_alert(usr,"Are you sure you want to disassociate [alt] from [ckey]'s sticky ban? \nNote: Nothing stops byond from re-linking them, Use \[E] to exempt them","确定吗",list("Yes","No")) == "No")
				return

			//we have to do this again incase something changes
			ban = get_stickyban_from_ckey(ckey)
			if (!ban)
				to_chat(usr, span_adminnotice("错误：封禁已消失。"), confidential = TRUE)
				return

			key = LAZYACCESS(ban["keys"], alt)

			if (!key)
				to_chat(usr, span_adminnotice("错误：[alt] 到 [ckey] 的粘性封禁链接已消失。"), confidential = TRUE)
				return

			LAZYREMOVE(ban["keys"], alt)
			world.SetConfig("ban",ckey,list2stickyban(ban))

			SSstickyban.cache[ckey] = ban

			if (SSdbcore.Connect())
				var/datum/db_query/query_remove_stickyban_alt = SSdbcore.NewQuery(
					"DELETE FROM [format_table_name("stickyban_matched_ckey")] WHERE stickyban = :ckey AND matched_ckey = :alt",
					list("ckey" = ckey, "alt" = alt)
				)
				query_remove_stickyban_alt.warn_execute()
				QDEL_NULL(query_remove_stickyban_alt)

			log_admin_private("[key_name(usr)] has disassociated [alt] from [ckey]'s sticky ban")
			message_admins(span_adminnotice("[key_name_admin(usr)] 已将 [alt] 从 [ckey] 的粘性封禁中解除关联"))

		if ("edit")
			if (!data["ckey"])
				return
			var/ckey = data["ckey"]
			var/ban = get_stickyban_from_ckey(ckey)
			if (!ban)
				to_chat(usr, span_adminnotice("错误：未找到[ckey]的粘性封禁！"), confidential = TRUE)
				return
			var/oldreason = ban["message"]
			var/reason = input(usr,"原因","原因","[ban["message"]]") as text|null
			if (!reason || reason == oldreason)
				return
			//we have to do this again incase something changed while we waited for input
			ban = get_stickyban_from_ckey(ckey)
			if (!ban)
				to_chat(usr, span_adminnotice("错误：封禁已消失。"), confidential = TRUE)
				return
			ban["message"] = "[reason]"

			world.SetConfig("ban",ckey,list2stickyban(ban))

			SSstickyban.cache[ckey] = ban

			if (SSdbcore.Connect())
				var/datum/db_query/query_edit_stickyban = SSdbcore.NewQuery(
					"UPDATE [format_table_name("stickyban")] SET reason = :reason WHERE ckey = :ckey",
					list("reason" = reason, "ckey" = ckey)
				)
				query_edit_stickyban.warn_execute()
				QDEL_NULL(query_edit_stickyban)

			log_admin_private("[key_name(usr)] has edited [ckey]'s sticky ban reason from [oldreason] to [reason]")
			message_admins(span_adminnotice("[key_name_admin(usr)] 已将 [ckey] 的粘性封禁原因从 [oldreason] 编辑为 [reason]"))

		if ("exempt")
			if (!data["ckey"])
				return
			var/ckey = data["ckey"]
			if (!data["alt"])
				return
			var/alt = ckey(data["alt"])
			var/ban = get_stickyban_from_ckey(ckey)
			if (!ban)
				to_chat(usr, span_adminnotice("错误：未找到[ckey]的粘性封禁！"), confidential = TRUE)
				return

			var/key = LAZYACCESS(ban["keys"], alt)
			if (!key)
				to_chat(usr, span_adminnotice("错误：[alt]未关联到[ckey]的粘性封禁！"), confidential = TRUE)
				return

			if (tgui_alert(usr,"你确定要将 [alt] 从 [ckey] 的粘性封禁中豁免吗？","你确定吗",list("Yes","No")) == "No")
				return

			//we have to do this again incase something changes
			ban = get_stickyban_from_ckey(ckey)
			if (!ban)
				to_chat(usr, span_adminnotice("错误：封禁已消失。"), confidential = TRUE)
				return

			key = LAZYACCESS(ban["keys"], alt)

			if (!key)
				to_chat(usr, span_adminnotice("错误：[alt] 到 [ckey] 的粘性封禁链接已消失。"), confidential = TRUE)
				return
			LAZYREMOVE(ban["keys"], alt)
			key["exempt"] = TRUE
			LAZYSET(ban["whitelist"], alt, key)

			world.SetConfig("ban",ckey,list2stickyban(ban))

			SSstickyban.cache[ckey] = ban

			if (SSdbcore.Connect())
				var/datum/db_query/query_exempt_stickyban_alt = SSdbcore.NewQuery(
					"UPDATE [format_table_name("stickyban_matched_ckey")] SET exempt = 1 WHERE stickyban = :ckey AND matched_ckey = :alt",
					list("ckey" = ckey, "alt" = alt)
				)
				query_exempt_stickyban_alt.warn_execute()
				QDEL_NULL(query_exempt_stickyban_alt)

			log_admin_private("[key_name(usr)] has exempted [alt] from [ckey]'s sticky ban")
			message_admins(span_adminnotice("[key_name_admin(usr)] 已将 [alt] 从 [ckey] 的粘性封禁中豁免"))

		if ("unexempt")
			if (!data["ckey"])
				return
			var/ckey = data["ckey"]
			if (!data["alt"])
				return
			var/alt = ckey(data["alt"])
			var/ban = get_stickyban_from_ckey(ckey)
			if (!ban)
				to_chat(usr, span_adminnotice("错误：未找到[ckey]的粘性封禁！"), confidential = TRUE)
				return

			var/key = LAZYACCESS(ban["whitelist"], alt)
			if (!key)
				to_chat(usr, span_adminnotice("错误：[alt] 并未被豁免于 [ckey] 的粘性封禁！"), confidential = TRUE)
				return

			if (tgui_alert(usr,"你确定要取消 [alt] 在 [ckey] 的粘性封禁中的豁免吗？","你确定吗",list("Yes","No")) == "No")
				return

			//we have to do this again incase something changes
			ban = get_stickyban_from_ckey(ckey)
			if (!ban)
				to_chat(usr, span_adminnotice("错误：封禁已消失。"), confidential = TRUE)
				return

			key = LAZYACCESS(ban["whitelist"], alt)
			if (!key)
				to_chat(usr, span_adminnotice("错误：[alt] 对 [ckey] 的粘性封禁的豁免已消失。"), confidential = TRUE)
				return

			LAZYREMOVE(ban["whitelist"], alt)
			key["exempt"] = FALSE
			LAZYSET(ban["keys"], alt, key)

			world.SetConfig("ban",ckey,list2stickyban(ban))

			SSstickyban.cache[ckey] = ban

			if (SSdbcore.Connect())
				var/datum/db_query/query_unexempt_stickyban_alt = SSdbcore.NewQuery(
					"UPDATE [format_table_name("stickyban_matched_ckey")] SET exempt = 0 WHERE stickyban = :ckey AND matched_ckey = :alt",
					list("ckey" = ckey, "alt" = alt)
				)
				query_unexempt_stickyban_alt.warn_execute()
				QDEL_NULL(query_unexempt_stickyban_alt)

			log_admin_private("[key_name(usr)] has unexempted [alt] from [ckey]'s sticky ban")
			message_admins(span_adminnotice("[key_name_admin(usr)] 已取消 [alt] 对 [ckey] 的粘性封禁的豁免"))

		if ("timeout")
			if (!data["ckey"])
				return
			if (!SSdbcore.Connect())
				to_chat(usr, span_adminnotice("无数据库连接！"), confidential = TRUE)
				return

			var/ckey = data["ckey"]

			if (tgui_alert(usr,"你确定要将 [ckey] 的粘性封禁暂停，直到下一轮（或解除）吗？","你确定吗",list("Yes","No")) == "No")
				return
			var/ban = get_stickyban_from_ckey(ckey)
			if (!ban)
				to_chat(usr, span_adminnotice("错误：未找到[ckey]的粘性封禁！"), confidential = TRUE)
				return

			ban["timeout"] = TRUE

			world.SetConfig("ban", ckey, null)

			var/cachedban = SSstickyban.cache[ckey]
			if (cachedban)
				cachedban["timeout"] = TRUE

			log_admin_private("[key_name(usr)] has put [ckey]'s sticky ban on timeout.")
			message_admins(span_adminnotice("[key_name_admin(usr)] 已将 [ckey] 的粘性封禁置于超时状态。"))

		if ("untimeout")
			if (!data["ckey"])
				return
			if (!SSdbcore.Connect())
				to_chat(usr, span_adminnotice("无数据库连接！"), confidential = TRUE)
				return
			var/ckey = data["ckey"]

			if (tgui_alert(usr,"你确定要解除 [ckey] 的粘性封禁暂停吗？","你确定吗",list("Yes","No")) == "No")
				return

			var/ban = get_stickyban_from_ckey(ckey)
			var/cachedban = SSstickyban.cache[ckey]
			if (cachedban)
				cachedban["timeout"] = FALSE
			if (!ban)
				if (!cachedban)
					to_chat(usr, span_adminnotice("错误：未找到[ckey]的粘性封禁！"), confidential = TRUE)
					return
				ban = cachedban

			ban["timeout"] = FALSE

			world.SetConfig("ban",ckey,list2stickyban(ban))

			log_admin_private("[key_name(usr)] has taken [ckey]'s sticky ban off of timeout.")
			message_admins(span_adminnotice("[key_name_admin(usr)] 已将 [ckey] 的粘性封禁解除超时状态。"))


		if ("revert")
			if (!data["ckey"])
				return
			var/ckey = data["ckey"]
			if (tgui_alert(usr,"你确定要将 [ckey] 的粘性封禁恢复到本轮开始（或上次编辑）时的状态吗？","你确定吗",list("Yes","No")) == "No")
				return
			var/ban = get_stickyban_from_ckey(ckey)
			if (!ban)
				to_chat(usr, span_adminnotice("错误：未找到[ckey]的粘性封禁！"), confidential = TRUE)
				return
			var/cached_ban = SSstickyban.cache[ckey]
			if (!cached_ban)
				to_chat(usr, span_adminnotice("错误：未找到 [ckey] 的缓存粘性封禁记录！"), confidential = TRUE)
			world.SetConfig("ban",ckey,null)

			log_admin_private("[key_name(usr)] has reverted [ckey]'s sticky ban to its state at round start.")
			message_admins(span_adminnotice("[key_name_admin(usr)] 已将 [ckey] 的粘性封禁恢复至回合开始时的状态。"))
			//revert is mostly used when shit goes rouge, so we have to set it to null
			// and wait a byond tick before assigning it to ensure byond clears its shit.
			sleep(world.tick_lag)
			world.SetConfig("ban",ckey,list2stickyban(cached_ban))


/datum/admins/proc/stickyban_gethtml(ckey)
	var/ban = get_stickyban_from_ckey(ckey)
	if (!ban)
		return
	var/timeout
	if (SSdbcore.Connect())
		timeout = "<a href='byond://?_src_=holder;[HrefToken()];stickyban=[(ban["timeout"] ? "untimeout" : "timeout")]&ckey=[ckey]'>\[[(ban["timeout"] ? "untimeout" : "timeout" )]\]</a>"
	else
		timeout = "<a href='byond://?_src_=holder;[HrefToken()];stickyban=revert&ckey=[ckey]'>\[revert\]</a>"
	. = list({"
		<a href='byond://?_src_=holder;[HrefToken()];stickyban=remove&ckey=[ckey]'>\[-\]</a>
		[timeout]
		<b>[ckey]</b>
		<br />"
		[ban["message"]] <b><a href='byond://?_src_=holder;[HrefToken()];stickyban=edit&ckey=[ckey]'>\[Edit\]</a></b><br />
	"})
	if (ban["admin"])
		. += "[ban["admin"]]<br />"
	else
		. += "LEGACY<br />"
	. += "Caught keys<br />\n<ol>"
	for (var/key in ban["keys"])
		if (ckey(key) == ckey)
			continue
		. += "<li><a href='byond://?_src_=holder;[HrefToken()];stickyban=remove_alt&ckey=[ckey]&alt=[ckey(key)]'>\[-\]</a>[key]<a href='byond://?_src_=holder;[HrefToken()];stickyban=exempt&ckey=[ckey]&alt=[ckey(key)]'>\[E\]</a></li>"

	for (var/key in ban["whitelist"])
		if (ckey(key) == ckey)
			continue
		. += "<li><a href='byond://?_src_=holder;[HrefToken()];stickyban=remove_alt&ckey=[ckey]&alt=[ckey(key)]'>\[-\]</a>[key]<a href='byond://?_src_=holder;[HrefToken()];stickyban=unexempt&ckey=[ckey]&alt=[ckey(key)]'>\[UE\]</a></li>"

	. += "</ol>\n"

/datum/admins/proc/stickyban_show()
	if(!check_rights(R_BAN))
		return
	var/list/bans = sticky_banned_ckeys()
	var/list/banhtml = list()
	for(var/key in bans)
		var/ckey = ckey(key)
		banhtml += "<br /><hr />\n"
		banhtml += stickyban_gethtml(ckey)

	var/html = {"
	<head>
		<title>Sticky Bans</title>
	</head>
	<body>
		<h2>All Sticky Bans:</h2> <a href='byond://?_src_=holder;[HrefToken()];stickyban=add'>\[+\]</a><br>
		[banhtml.Join("")]
	</body>
	"}
	usr << browse(html,"window=stickybans;size=700x400")

/proc/sticky_banned_ckeys()
	if (SSdbcore.Connect() || length(SSstickyban.dbcache))
		if (SSstickyban.dbcacheexpire < world.time)
			SSstickyban.Populatedbcache()
		if (SSstickyban.dbcacheexpire)
			return SSstickyban.dbcache.Copy()

	return sort_list(world.GetConfig("ban"))


/proc/get_stickyban_from_ckey(ckey)
	. = list()
	if (!ckey)
		return null
	if (SSdbcore.Connect() || length(SSstickyban.dbcache))
		if (SSstickyban.dbcacheexpire < world.time)
			SSstickyban.Populatedbcache()
		if (SSstickyban.dbcacheexpire)
			. = SSstickyban.dbcache[ckey]
			//reset the cache incase its a newer ban (but only if we didn't update the cache recently)
			if (!. && SSstickyban.dbcacheexpire != world.time+STICKYBAN_DB_CACHE_TIME)
				SSstickyban.dbcacheexpire = 1
				SSstickyban.Populatedbcache()
				. = SSstickyban.dbcache[ckey]
			if (.)
				var/list/cachedban = SSstickyban.cache["[ckey]"]
				if (cachedban)
					.["timeout"] = cachedban["timeout"]

				.["fromdb"] = TRUE
			return

	. = stickyban2list(world.GetConfig("ban", ckey)) || stickyban2list(world.GetConfig("ban", ckey(ckey))) || list()

	if (!length(.))
		return null

/proc/stickyban2list(ban, strictdb = TRUE)
	if (!ban)
		return null
	. = params2list(ban)
	if (.["keys"])
		var/keys = splittext(.["keys"], ",")
		var/ckeys = list()
		for (var/key in keys)
			var/ckey = ckey(key)
			ckeys[ckey] = ckey //to make searching faster.
		.["keys"] = ckeys
	if (.["whitelist"])
		var/keys = splittext(.["whitelist"], ",")
		var/ckeys = list()
		for (var/key in keys)
			var/ckey = ckey(key)
			ckeys[ckey] = ckey //to make searching faster.
		.["whitelist"] = ckeys
	.["type"] = splittext(.["type"], ",")
	.["IP"] = splittext(.["IP"], ",")
	.["computer_id"] = splittext(.["computer_id"], ",")
	. -= "fromdb"


/proc/list2stickyban(list/ban)
	if (!ban || !islist(ban))
		return null
	. = ban.Copy()
	if (.["keys"])
		.["keys"] = jointext(.["keys"], ",")
	if (.["IP"])
		.["IP"] = jointext(.["IP"], ",")
	if (.["computer_id"])
		.["computer_id"] = jointext(.["computer_id"], ",")
	if (.["whitelist"])
		.["whitelist"] = jointext(.["whitelist"], ",")
	if (.["type"])
		.["type"] = jointext(.["type"], ",")

	. -= "reverting"
	. -= "matches_this_round"
	. -= "existing_user_matches_this_round"
	. -= "admin_matches_this_round"
	. -= "pending_matches_this_round"


	. = list2params(.)

ADMIN_VERB(panel_sticky_ban, R_BAN, "Sticky Ban Panel", "List and manage sticky bans.", ADMIN_CATEGORY_MAIN)
	user.holder.stickyban_show()
