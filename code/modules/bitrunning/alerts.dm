/atom/movable/screen/alert/bitrunning
	name = "通用比特运行警报"
	icon_state = "template"
	timeout = 10 SECONDS

/atom/movable/screen/alert/bitrunning/qserver_domain_complete
	name = "域已完成"
	desc = "域已完成。激活以退出。"
	timeout = 20 SECONDS
	clickable_glow = TRUE

/atom/movable/screen/alert/bitrunning/qserver_domain_complete/Click(location, control, params)
	. = ..()
	if(!.)
		return

	var/mob/living/living_owner = owner
	if(!isliving(living_owner))
		return

	if(tgui_alert(living_owner, "安全断开连接？", "服务器消息", list("Exit", "Remain"), 10 SECONDS) == "Exit")
		SEND_SIGNAL(living_owner, COMSIG_BITRUNNER_ALERT_SEVER)

