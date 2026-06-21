ADMIN_VERB(toggle_bsa, R_ADMIN, "Toggle BSA Control", "Toggles the BSA control lock on and off.", ADMIN_CATEGORY_FUN)
	GLOB.bsa_unlock = !GLOB.bsa_unlock
	minor_announce("蓝空火炮射击协议已被[GLOB.bsa_unlock? "unlocked" : "locked"]", "武器系统更新：")

	message_admins("[ADMIN_LOOKUPFLW(usr)] [GLOB.bsa_unlock? "unlocked" : "locked"] BSA firing protocols.")
	log_admin("[key_name(user)] [GLOB.bsa_unlock? "unlocked" : "locked"] BSA firing protocols.")
