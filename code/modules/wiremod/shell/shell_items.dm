/**
 * # Shell Item
 *
 * Printed out by protolathes. Screwdriver to complete the shell.
 */
/obj/item/shell
	name = "组件"
	desc = "一种可以通过使用螺丝刀来完成组装的外壳组件。"
	icon = 'icons/obj/science/circuits.dmi'
	abstract_type = /obj/item/shell
	var/shell_to_spawn
	var/screw_delay = 3 SECONDS

/obj/item/shell/screwdriver_act(mob/living/user, obj/item/tool)
	user.visible_message(span_notice("[user] 开始完成 [src]。"), span_notice("你开始完成 [src]。"))
	tool.play_tool_sound(src)
	if(!do_after(user, screw_delay, src))
		return
	user.visible_message(span_notice("[user] 完成了 [src]。"), span_notice("你完成了 [src]。"))

	var/turf/drop_loc = drop_location()

	qdel(src)
	if(drop_loc)
		new shell_to_spawn(drop_loc)

	return TRUE

/obj/item/shell/bot
	name = "机器人组件"
	icon_state = "setup_medium_box-open"
	shell_to_spawn = /obj/structure/bot

/obj/item/shell/money_bot
	name = "货币机器人组装"
	icon_state = "setup_large-open"
	shell_to_spawn = /obj/structure/money_bot

/obj/item/shell/drone
	name = "无人机组件"
	icon_state = "setup_medium_med-open"
	shell_to_spawn = /mob/living/circuit_drone
	w_class = WEIGHT_CLASS_SMALL

/obj/item/shell/server
	name = "服务器组件"
	icon_state = "setup_stationary-open"
	shell_to_spawn = /obj/structure/server
	screw_delay = 10 SECONDS

/obj/item/shell/airlock
	name = "电路气闸组件"
	icon = 'icons/obj/doors/airlocks/station/public.dmi'
	icon_state = "construction"
	shell_to_spawn = /obj/machinery/door/airlock/shell
	screw_delay = 10 SECONDS
	w_class = WEIGHT_CLASS_BULKY

/obj/item/shell/dispenser
	name = "电路分配器组件"
	icon_state = "setup_drone_arms-open"
	shell_to_spawn = /obj/structure/dispenser_bot

/obj/item/shell/bci
	name = "脑机接口组件"
	icon_state = "bci-open"
	shell_to_spawn = /obj/item/organ/cyberimp/bci
	w_class = WEIGHT_CLASS_TINY

/obj/item/shell/scanner_gate
	name = "扫描门组件"
	icon = 'icons/obj/machines/scangate.dmi'
	icon_state = "scangate_black_open"
	shell_to_spawn = /obj/structure/scanner_gate_shell
