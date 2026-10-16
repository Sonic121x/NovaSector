// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/datum/controller/subsystem/ticker/proc/opfor_report()
	var/list/result = list()

	result += LANG("datum.1f1da9efa9294c35", null)

	if(!SSopposing_force.approved_applications.len)
		result += span_red(LANG("datum.a51e5a331e14f930", null))
	else
		for(var/datum/opposing_force/opfor in SSopposing_force.approved_applications)
			result += opfor.roundend_report()

	return "<div class='panel stationborder'>[result.Join()]</div>"
