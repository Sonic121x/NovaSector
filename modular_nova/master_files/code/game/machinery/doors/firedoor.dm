/obj/machinery/door/firedoor/click_alt(mob/user)
	try_manual_override(user)
	return CLICK_ACTION_SUCCESS

/obj/machinery/door/firedoor/examine(mob/user)
	. = ..()
	. += span_notice("Alt-点击此门以使用手动覆盖。")

/obj/machinery/door/proc/try_manual_override(mob/user)
	if(density && !welded && !operating)
		balloon_alert(user, "正在打开...")
		if(do_after(user, 5 SECONDS, target = src))
			try_to_crowbar(null, user)
			return TRUE
	return FALSE

// Uncomment this override to disable the auto-close feature of firedoors.
/*
/obj/machinery/door/firedoor/try_to_crowbar(obj/item/used_object, mob/user)
	if(welded || operating)
		balloon_alert(user, "opening failed!")
		return

	if(density)
		open()
	else
		close()
*/

/obj/machinery/door/firedoor/heavy/closed
	icon_state = "door_closed"
	density = TRUE
	alarm_type = FIRELOCK_ALARM_TYPE_GENERIC

/obj/machinery/door/firedoor/solid
	name = "实体应急百叶窗"
	desc = "应急气密百叶窗，能够封闭破损区域。它有一个可以用手打开的机制。"
	icon = 'modular_nova/modules/aesthetics/firedoor/icons/firedoor.dmi'
	glass = FALSE

/obj/machinery/door/firedoor/solid/closed
	icon_state = "door_closed"
	density = TRUE
	opacity = TRUE
	alarm_type = FIRELOCK_ALARM_TYPE_GENERIC

