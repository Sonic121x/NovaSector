ADMIN_VERB_VISIBILITY(set_server_fps, ADMIN_VERB_VISIBLITY_FLAG_MAPPING_DEBUG)
ADMIN_VERB(set_server_fps, R_DEBUG, "Set Server FPS", "Sets game speed in frames-per-second. Can potentially break the game", ADMIN_CATEGORY_DEBUG)
	var/cfg_fps = CONFIG_GET(number/fps)
	var/new_fps = round(input(user, "设置游戏帧率。可能会破坏游戏（默认：[cfg_fps]）","FPS", world.fps) as num|null)

	if(new_fps <= 0)
		to_chat(user, span_danger("错误：set_server_fps()：无效的 world.fps 值。未进行任何更改。"), confidential = TRUE)
		return
	if(new_fps > cfg_fps * 1.5)
		if(tgui_alert(user, "您正在将帧率设置为一个高值：\n\t[new_fps] 帧每秒\n\tconfig.fps = [cfg_fps]","警告！",list("Confirm","ABORT-ABORT-ABORT")) != "Confirm")
			return

	var/msg = "[key_name(user)] has modified world.fps to [new_fps]"
	log_admin(msg, 0)
	message_admins(msg, 0)
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Set Server FPS", "[new_fps]")) // If you are copy-pasting this, ensure the 4th parameter is unique to the new proc!

	CONFIG_SET(number/fps, new_fps)
	world.change_fps(new_fps)
