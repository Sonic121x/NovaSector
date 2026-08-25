// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/atom/movable/screen/alert/bitrunning
	name = "Generic Bitrunning Alert"
	icon_state = "template"
	timeout = 10 SECONDS

/atom/movable/screen/alert/bitrunning/qserver_domain_complete
	name = "Domain Completed"
	desc = "The domain is completed. Activate to exit."
	timeout = 20 SECONDS
	clickable_glow = TRUE

/atom/movable/screen/alert/bitrunning/qserver_domain_complete/Click(location, control, params)
	. = ..()
	if(!.)
		return

	var/mob/living/living_owner = owner
	if(!isliving(living_owner))
		return

	if(tgui_alert(living_owner, LANG("atom.302b9eb97f90ed84", null), LANG("atom.968e21bfe86f12b8", null), list("Exit", "Remain"), 10 SECONDS) == "Exit")
		SEND_SIGNAL(living_owner, COMSIG_BITRUNNER_ALERT_SEVER)

