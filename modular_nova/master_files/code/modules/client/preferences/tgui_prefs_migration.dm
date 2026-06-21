/datum/preferences/proc/migrate_nova(list/nova_data)
	var/ooc_prefs = nova_data["ooc_prefs"]
	if(ooc_prefs)
		write_preference(GLOB.preference_entries[/datum/preference/text/ooc_notes], ooc_prefs)

	to_chat(parent, boxed_message(span_greentext("偏好设置迁移成功！你现在可以安全地使用偏好设置菜单了。")))
	tgui_prefs_migration = TRUE
	nova_data["tgui_prefs_migration"] = tgui_prefs_migration

/datum/preferences/proc/migrate_mentor()
	write_preference(GLOB.preference_entries[/datum/preference/toggle/admin/auto_dementor], FALSE) // Someone thought it was a good idea to make it start at true :)
