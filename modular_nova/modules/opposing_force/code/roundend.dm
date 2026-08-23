/datum/controller/subsystem/ticker/proc/opfor_report()
	var/list/result = list()

	result += LANG("datum.1f1da9efa9294c35", null)

	if(!SSopposing_force.approved_applications.len)
		result += span_red(LANG("datum.a51e5a331e14f930", null))
	else
		for(var/datum/opposing_force/opfor in SSopposing_force.approved_applications)
			result += opfor.roundend_report()

	return "<div class='panel stationborder'>[result.Join()]</div>"
