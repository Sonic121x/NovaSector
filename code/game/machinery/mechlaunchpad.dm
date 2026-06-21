/obj/machinery/mechpad
	name = "轨道机械发射台"
	desc = "一块用于承受轨道坠落冲击的重型板。通过某种先进的蓝空技术，这块板似乎能够发送和接收机甲。需要连接到控制台才能运行。"
	icon = 'icons/obj/machines/telepad.dmi'
	icon_state = "mechpad"
	base_icon_state = "mechpad"
	circuit = /obj/item/circuitboard/machine/mechpad
	///ID of the console, used for linking up
	var/id = "roboticsmining"
	///Name of the mechpad in a mechpad console
	var/display_name = "Orbital Pad"
	///Can we carry mobs or just mechs?
	var/mech_only = FALSE

/obj/machinery/mechpad/Initialize(mapload)
	. = ..()
	display_name = "Orbital Pad - [get_area_name(src)]"

/obj/machinery/mechpad/examine(mob/user)
	. = ..()
	. += span_notice("在面板打开的情况下使用多重工具将 id 保存到缓冲区。")
	. += span_notice("打开面板后使用钢丝钳来[mech_only ? "cut" : "mend"]生命形态限制线。")

/obj/machinery/mechpad/update_icon_state()
	. = ..()
	icon_state = panel_open ? "[base_icon_state]-open" : base_icon_state

/obj/machinery/mechpad/screwdriver_act(mob/user, obj/item/tool)
	return default_deconstruction_screwdriver(user, tool)

/obj/machinery/mechpad/crowbar_act(mob/user, obj/item/tool)
	return default_deconstruction_crowbar(user, tool)

/obj/machinery/mechpad/multitool_act(mob/living/user, obj/item/multitool/multitool)
	if(!panel_open)
		return NONE

	multitool.set_buffer(src)
	balloon_alert(user, "已保存到多功能工具缓冲区")
	return ITEM_INTERACT_SUCCESS

/obj/machinery/mechpad/wirecutter_act(mob/living/user, obj/item/tool)
	if(!panel_open)
		return NONE
	mech_only = !mech_only
	to_chat(user, span_notice("你[mech_only ? "mend" : "cut"]生命形态限制线。"))
	return ITEM_INTERACT_SUCCESS

/**
 * Spawns a special supply pod whitelisted to only accept mechs and have its drop off location be another mechpad
 * Arguments:
 * * where - where the supply pod will land after grabbing the mech
 */
/obj/machinery/mechpad/proc/launch(obj/machinery/mechpad/where)
	var/turf/reverse_turf = get_turf(where)
	podspawn(list(
		"target" = get_turf(src),
		"path" = /obj/structure/closet/supplypod/mechpod,
		"style" = /datum/pod_style/seethrough,
		"reverse_dropoff_coords" = list(reverse_turf.x, reverse_turf.y, reverse_turf.z)
	))
	use_energy(active_power_usage)

/obj/structure/closet/supplypod/mechpod
	style = /datum/pod_style/seethrough
	explosionSize = list(0,0,0,0)
	reversing = TRUE
	reverse_option_list = list("Mobs"=FALSE,"Objects"=FALSE,"Anchored"=FALSE,"Underfloor"=FALSE,"Wallmounted"=FALSE,"Floors"=FALSE,"Walls"=FALSE,"Mecha"=TRUE)
	delays = list(POD_TRANSIT = 0, POD_FALLING = 0, POD_OPENING = 0, POD_LEAVING = 0)
	reverse_delays = list(POD_TRANSIT = 30, POD_FALLING = 10, POD_OPENING = 0, POD_LEAVING = 0)
	custom_rev_delay = TRUE
	effectQuiet = TRUE
	effectStealth = TRUE
	leavingSound = 'sound/vehicles/rocketlaunch.ogg'
	close_sound = null
	pod_flags = FIRST_SOUNDS

/obj/structure/closet/supplypod/mechpod/handleReturnAfterDeparting(atom/movable/holder = src)
	effectGib = TRUE
	return ..()
