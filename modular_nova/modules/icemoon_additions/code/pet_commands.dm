/datum/component/obeys_commands/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_ATOM_EXAMINE_MORE, PROC_REF(on_examine_more))

/datum/component/obeys_commands/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, COMSIG_ATOM_EXAMINE_MORE)

/datum/component/obeys_commands/on_examine(mob/living/source, mob/user, list/examine_list)
	. = ..()
	examine_list += span_italics("你可以相邻时按住Alt键点击[source.p_them()]来查看可用命令。")
	examine_list += span_italics("你也可以仔细检查[source.p_them()]以查看[source.p_their()]的伤势。许多同伴可以用缝合线或药膏治愈！")

/datum/component/obeys_commands/proc/on_examine_more(mob/living/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	if (IS_DEAD_OR_INCAP(source))
		return
	if (!(user in source.ai_controller?.blackboard[BB_FRIENDS_LIST]))
		return

	if (source.health < source.maxHealth*0.2)
		examine_list += span_bolddanger("[source.p_They()]看[source.p_s()]起来伤势严重。")
	else if (source.health < source.maxHealth*0.5)
		examine_list += span_danger("[source.p_They()]看[source.p_s()]起来伤势中等。")
	else if (source.health < source.maxHealth*0.8)
		examine_list += span_warning("[source.p_They()]看[source.p_s()]起来伤势轻微。")
	else
		examine_list += span_notice("[source.p_They()]看[source.p_s()]起来状况良好。")
