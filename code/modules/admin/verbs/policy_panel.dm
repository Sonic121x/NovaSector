// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
ADMIN_VERB(policy_panel, R_ADMIN, "政策面板", "View all policy the server has set.", ADMIN_CATEGORY_MAIN)
	if(!length(global.config?.policy))
		tgui_alert(usr, LANG("datum.68d417479b926623", null), LANG("datum.d0a5b4c1bdee7f06", null), list("OK"))
		return

	var/datum/policy_panel/tgui = new
	tgui.ui_interact(user.mob)
	BLACKBOX_LOG_ADMIN_VERB("Policy Panel")

// Very simple panel that reports all the policy the server has set.
/datum/policy_panel

/datum/policy_panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Policypanel")
		ui.open()

/datum/policy_panel/ui_state(mob/user)
	return ADMIN_STATE(R_ADMIN)

/datum/policy_panel/ui_close(mob/user)
	qdel(src)

/datum/policy_panel/ui_static_data(mob/user)
	var/list/data = list()
	data["policy"] = global.config.policy
	return data
