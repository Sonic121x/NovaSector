GLOBAL_LIST_EMPTY(bunker_passthrough)

ADMIN_VERB(addbunkerbypass, R_ADMIN, "添加恐慌地堡豁免", "Allows a given ckey to connect despite the panic bunker for a given round.", ADMIN_CATEGORY_MAIN)
	if(!CONFIG_GET(flag/sql_enabled))
		to_chat(usr, span_adminnotice(LANG("datum.5bf16f98199b79cc", null)))
		return

	var/ckeytobypass = input(user, LANG("datum.964a82305a0a5ee8", null), LANG("datum.1efabe261593dcfd", null)) as text|null
	if(!ckeytobypass)
		return

	GLOB.bunker_passthrough |= ckey(ckeytobypass)
	GLOB.bunker_passthrough[ckey(ckeytobypass)] = world.realtime
	SSpersistence.save_panic_bunker() //we can do this every time, it's okay
	log_admin("[key_name(usr)] has added [ckeytobypass] to the current round's bunker bypass list.")
	message_admins("[key_name_admin(usr)] has added [ckeytobypass] to the current round's bunker bypass list.")

ADMIN_VERB_CUSTOM_EXIST_CHECK(addbunkerbypass)
	return CONFIG_GET(flag/panic_bunker) && CONFIG_GET(flag/sql_enabled)

ADMIN_VERB(revokebunkerbypass, R_ADMIN, "撤销恐慌地堡豁免", "Revoke's a ckey's permission to bypass the panic bunker for a given round.", ADMIN_CATEGORY_MAIN)
	if(!CONFIG_GET(flag/sql_enabled))
		to_chat(usr, span_adminnotice(LANG("datum.5bf16f98199b79cc", null)))
		return

	var/ckeytobypass = input(user, LANG("datum.ba9615774dde303f", null), LANG("datum.1efabe261593dcfd", null)) as text|null
	if(!ckeytobypass)
		return

	GLOB.bunker_passthrough -= ckey(ckeytobypass)
	SSpersistence.save_panic_bunker()
	log_admin("[key_name(usr)] has removed [ckeytobypass] from the current round's bunker bypass list.")
	message_admins("[key_name_admin(usr)] has removed [ckeytobypass] from the current round's bunker bypass list.")

ADMIN_VERB_CUSTOM_EXIST_CHECK(revokebunkerbypass)
	return CONFIG_GET(flag/panic_bunker) && CONFIG_GET(flag/sql_enabled)

/datum/tgs_chat_command/addbunkerbypass
	name = "whitelist-pb"
	help_text = "【管理员】whitelist-pb <ckey> —— 添加本回合紧急封锁绕过"
	admin_only = TRUE

/datum/tgs_chat_command/addbunkerbypass/Run(datum/tgs_chat_user/sender, params)
	if(!CONFIG_GET(flag/sql_enabled))
		return new /datum/tgs_message_content("❌ **无法添加紧急封锁绕过：** SQL 数据库未启用。")

	var/target_ckey = ckey(params)
	if(!target_ckey)
		return new /datum/tgs_message_content("⚠️ **请输入有效的 ckey。**\n> 用法：`whitelist-pb <ckey>`")

	GLOB.bunker_passthrough |= target_ckey

	GLOB.bunker_passthrough[target_ckey] = world.realtime
	SSpersistence.save_panic_bunker() //we can do this every time, it's okay
	log_admin("[sender.friendly_name] has added [target_ckey] to the current round's bunker bypass list.")
	message_admins("[sender.friendly_name] has added [target_ckey] to the current round's bunker bypass list.")
	return new /datum/tgs_message_content("✅ **紧急封锁绕过添加成功**\n> `[target_ckey]` 本回合可以绕过紧急封锁。")

/datum/controller/subsystem/persistence/proc/load_panic_bunker()
	var/bunker_path = file("data/bunker_passthrough.json")
	if(fexists(bunker_path))
		var/list/json = json_decode(file2text(bunker_path))
		GLOB.bunker_passthrough = json["data"]
		for(var/ckey in GLOB.bunker_passthrough)
			if(daysSince(GLOB.bunker_passthrough[ckey]) >= CONFIG_GET(number/max_bunker_days))
				GLOB.bunker_passthrough -= ckey

/datum/controller/subsystem/persistence/proc/save_panic_bunker()
	var/json_file = file("data/bunker_passthrough.json")
	var/list/file_data = list()
	file_data["data"] = GLOB.bunker_passthrough
	fdel(json_file)
	WRITE_FILE(json_file,json_encode(file_data))

/datum/config_entry/number/max_bunker_days
	default = 7
	min_val = 1
