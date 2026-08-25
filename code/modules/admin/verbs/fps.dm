// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
ADMIN_VERB_VISIBILITY(set_server_fps, ADMIN_VERB_VISIBLITY_FLAG_MAPPING_DEBUG)
ADMIN_VERB(set_server_fps, R_DEBUG, "设置服务器 FPS", "Sets game speed in frames-per-second. Can potentially break the game", ADMIN_CATEGORY_DEBUG)
	var/cfg_fps = CONFIG_GET(number/fps)
	var/new_fps = round(input(user, LANG("datum.26b759edde5d62d6", list(cfg_fps)),LANG("datum.f364b783771a651f", null), world.fps) as num|null)

	if(new_fps <= 0)
		to_chat(user, span_danger(LANG("datum.42da98c4c191af4a", null)), confidential = TRUE)
		return
	if(new_fps > cfg_fps * 1.5)
		if(tgui_alert(user, LANG("datum.fe8ba64008bc119c", list(new_fps, cfg_fps)),LANG("datum.59b208b7aed572a9", null),list("Confirm","ABORT-ABORT-ABORT")) != "Confirm")
			return

	var/msg = "[key_name(user)] has modified world.fps to [new_fps]"
	log_admin(msg, 0)
	message_admins(msg, 0)
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Set Server FPS", "[new_fps]")) // If you are copy-pasting this, ensure the 4th parameter is unique to the new proc!

	CONFIG_SET(number/fps, new_fps)
	world.change_fps(new_fps)
