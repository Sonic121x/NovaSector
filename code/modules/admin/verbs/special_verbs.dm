// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
// Admin Verbs in this file are special and cannot use the AVD system for some reason or another.

GAME_VERB_PROC(/client, show_verbs, "管理员命令 - 显示", ADMIN_CATEGORY_MAIN)

	UNASSIGN_GAME_VERB(src, /client, show_verbs)
	add_admin_verbs()

	to_chat(src, span_interface(LANG("client.11524bf074c11bed", null)), confidential = TRUE)
	BLACKBOX_LOG_ADMIN_VERB("Show Adminverbs")

GAME_VERB_PROC_DESC(/client, readmin, "恢复管理员权限", "Regain your admin powers.", "Admin")

	var/datum/admins/A = GLOB.deadmins[ckey]

	if(!A)
		A = GLOB.admin_datums[ckey]
		if (!A)
			var/msg = " is trying to readmin but they have no deadmin entry"
			message_admins("[key_name_admin(src)][msg]")
			log_admin_private("[key_name(src)][msg]")
			return

	A.associate(src)

	if (!holder)
		return //This can happen if an admin attempts to vv themself into somebody elses's deadmin datum by getting ref via brute force

	to_chat(src, span_interface(LANG("client.04bfdba78db6cc54", null)), confidential = TRUE)
	message_admins("[src] re-adminned themselves.")
	log_admin("[src] re-adminned themselves.")
	BLACKBOX_LOG_ADMIN_VERB("Readmin")

GAME_VERB_PROC(/client, admin_2fa_verify, "验证管理员", "Admin")

	var/datum/admins/admin = GLOB.admin_datums[ckey]
	admin?.associate(src)
