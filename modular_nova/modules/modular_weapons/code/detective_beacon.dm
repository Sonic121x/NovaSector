// Detective weapon beacon with alternative choice: knuckleduster

/obj/item/choice_beacon/detective
	name = "侦探装备信标"
	desc = "一种单次使用的信标，用于为调查任务提供替代副武器。请仅在您的办公室内呼叫！"
	icon_state = "sec_beacon"
	inhand_icon_state = "electronic"
	icon = 'modular_nova/modules/modular_items/icons/remote.dmi'
	company_source = "Nanotrasen Rapid Equipment Deployment Division"
	company_message = span_bold("补给舱即将抵达，请稍候。")

/obj/item/choice_beacon/detective/generate_display_names()
	var/static/list/selectable_types = list(
		"Knuckleduster" = /obj/item/melee/knuckleduster,
		"Police Baton" = /obj/item/melee/baton
	)
	return selectable_types

