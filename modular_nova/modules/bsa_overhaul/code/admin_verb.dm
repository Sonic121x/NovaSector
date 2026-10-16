// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
ADMIN_VERB(toggle_bsa, R_ADMIN, "切换 BSA 控制", "Toggles the BSA control lock on and off.", ADMIN_CATEGORY_FUN)
	GLOB.bsa_unlock = !GLOB.bsa_unlock
	minor_announce(LANG("datum.01026de0fd73ae28", list(GLOB.bsa_unlock? "unlocked" : "locked")), "Weapons Systems Update:")

	message_admins("[ADMIN_LOOKUPFLW(usr)] [GLOB.bsa_unlock? "unlocked" : "locked"] BSA firing protocols.")
	log_admin("[key_name(user)] [GLOB.bsa_unlock? "unlocked" : "locked"] BSA firing protocols.")
