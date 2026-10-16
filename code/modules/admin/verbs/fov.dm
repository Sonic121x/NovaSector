// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
ADMIN_VERB(toggle_fov, R_ADMIN|R_DEBUG, "启用/禁用视野", "Toggle FOV globally.", ADMIN_CATEGORY_DEBUG)
	var/on_off = CONFIG_GET(flag/native_fov)

	message_admins("[key_name_admin(user)] has [on_off ? "disabled" : "enabled"] the Native Field of View configuration..")
	log_admin("[key_name(user)] has [on_off ? "disabled" : "enabled"] the Native Field of View configuration.")
	CONFIG_SET(flag/native_fov, !on_off)

	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggled Field of View", "[on_off ? "Enabled" : "Disabled"]"))

	for(var/mob/living/mob in GLOB.player_list)
		mob.update_fov()
