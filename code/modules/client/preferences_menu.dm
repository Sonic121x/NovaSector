// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
GAME_VERB_DESC(/client, open_character_preferences, "打开角色偏好设置", "Open Character Preferences", "OOC")

	if(!prefs)
		return
	prefs.current_window = PREFERENCE_TAB_CHARACTER_PREFERENCES
	prefs.update_static_data(usr)
	prefs.ui_interact(usr)

GAME_VERB_DESC(/client, open_game_preferences, "打开游戏偏好设置", "Open Game Preferences", "OOC")

	if(!prefs)
		return
	prefs.current_window = PREFERENCE_TAB_GAME_PREFERENCES
	prefs.update_static_data(usr)
	prefs.ui_interact(usr)

