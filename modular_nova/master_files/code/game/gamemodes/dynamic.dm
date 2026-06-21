// A lite version of the intercept, which only sends a paper with goals and a trait report (or a lack thereof)
/datum/communciations_controller/proc/send_trait_report(greenshift)
	. = "<b><i>Central Command Status Summary</i></b><hr>"

	var/dynamic_report = SSdynamic.get_advisory_report()
	if(isnull(greenshift)) // if we're not forced to be greenshift or not - check if we are an actual greenshift
		greenshift = SSdynamic.current_tier.tier == 0 && dynamic_report == /datum/dynamic_tier/greenshift::advisory_report
	SSstation.generate_station_goals(greenshift ? INFINITY : CONFIG_GET(number/station_goal_budget))

	if(!length(SSstation.get_station_goals()))
		. = "<hr><b>No assigned goals.</b><BR>"
	else
		var/list/texts = list("<hr><b>Special Orders for [station_name()]:</b><BR>")
		for(var/datum/station_goal/station_goal as anything in SSstation.get_station_goals())
			station_goal.on_report()
			texts += station_goal.get_report()

		. += texts.Join("<hr>")
	if(!SSstation.station_traits.len)
		. = "<hr><b>No identified shift divergencies.</b><BR>"
	else
		var/list/trait_list_strings = list()
		for(var/datum/station_trait/station_trait as anything in SSstation.station_traits)
			if(!station_trait.show_in_report)
				continue
			trait_list_strings += "[station_trait.get_report()]<BR>"
		if(trait_list_strings.len > 0)
			. += "<hr><b>Identified shift divergencies:</b><BR>" + trait_list_strings.Join()

	. += "<hr>This concludes your shift-start evaluation. Have a secure shift!<hr>\
	<p style=\"color: grey; text-align: justify;\">This label certifies an Intern has reviewed the above before sending. This document is the property of Nanotrasen Corporation.</p>"

	print_command_report(., "中央司令部状态摘要", announce = FALSE)
	priority_announce("你好，[station_name()]的船员们。我们的实习生已完成班次开始时的分歧性与目标评估，报告已发送至你们的通讯控制台。祝班次安全！", "偏差报告", SSstation.announcer.get_rand_report_sound())
