/obj/item/bitrunning_host_monitor
	name = "主机监视器"

	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 2)
	desc = "一种复杂的电子设备，用于分析主机与化身之间的连接健康状况。"
	obj_flags = CONDUCTS_ELECTRICITY
	icon = 'icons/obj/devices/scanner.dmi'
	icon_state = "host_monitor"
	inhand_icon_state = "electronic"
	item_flags = NOBLUDGEON
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	slot_flags = ITEM_SLOT_BELT
	throw_range = 7
	throw_speed = 3
	throwforce = 3
	w_class = WEIGHT_CLASS_TINY
	worn_icon_state = "electronic"

/obj/item/bitrunning_host_monitor/attack_self(mob/user, modifiers)
	. = ..()

	var/datum/component/avatar_connection/connection = user.GetComponent(/datum/component/avatar_connection)
	if(isnull(connection))
		balloon_alert(user, "数据无法识别")
		return

	var/mob/living/pilot = connection.old_body_ref?.resolve()
	if(isnull(pilot))
		balloon_alert(user, "主机无法识别")
		return

	to_chat(user, span_notice("当前主机健康状况：[pilot.health / pilot.maxHealth * 100]%"))
