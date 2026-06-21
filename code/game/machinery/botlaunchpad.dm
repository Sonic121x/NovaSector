/obj/machinery/botpad
	name = "机器人平台"
	desc = "由轨道机械平台改装而成的机器人发射平台，需要进行远程连接方可正常工作"
	icon = 'icons/obj/machines/telepad.dmi'
	icon_state = "botpad"
	base_icon_state = "botpad"
	circuit = /obj/item/circuitboard/machine/botpad
	// ID of the console, used for linking up
	var/id = "botlauncher"
	var/obj/item/botpad_remote/connected_remote
	var/datum/weakref/launched_bot // we need this to recall the bot

/obj/machinery/botpad/Destroy()
	if(connected_remote)
		connected_remote.connected_botpad = null
		connected_remote = null
	launched_bot = null
	return ..()

/obj/machinery/botpad/update_icon_state()
	. = ..()
	icon_state = panel_open ? "[base_icon_state]-open" : base_icon_state

/obj/machinery/botpad/screwdriver_act(mob/user, obj/item/tool)
	return default_deconstruction_screwdriver(user, tool)

/obj/machinery/botpad/crowbar_act(mob/user, obj/item/tool)
	return default_deconstruction_crowbar(user, tool)

/obj/machinery/botpad/multitool_act(mob/living/user, obj/item/multitool/tool)
	if(!panel_open)
		return NONE
	var/obj/item/multitool/multitool = tool
	multitool.set_buffer(src)
	balloon_alert(user, "已保存到多功能工具缓冲区")
	return ITEM_INTERACT_SUCCESS

// Checks the turf for a bot and launches it if it's the only mob on the pad.
/obj/machinery/botpad/proc/launch(mob/living/user)
	var/turf/reverse_turf = get_turf(user)
	var/atom/possible_bot
	for(var/mob/living/robot in get_turf(src))
		if(!isbot(robot))
			user.balloon_alert(user, "发射台上有未识别生命形式！")
			return
		if(!isnull(possible_bot))
			user.balloon_alert(user, "发射台上机器人太多！")
			return
		possible_bot = robot  // We don't change the launched_bot var here because we are not sure if there is another bot on the pad.

	if(!use_energy(active_power_usage, force = FALSE))
		balloon_alert(user, "能量不足！")
		return
	launched_bot = WEAKREF(possible_bot)
	podspawn(list(
		"target" = get_turf(src),
		"path" = /obj/structure/closet/supplypod/transport/botpod,
		"style" = /datum/pod_style/seethrough,
		"reverse_dropoff_coords" = list(reverse_turf.x, reverse_turf.y, reverse_turf.z)
	))

/obj/machinery/botpad/proc/recall(mob/living/user)
	var/atom/our_bot = launched_bot?.resolve()
	if(isnull(our_bot))
		user.balloon_alert(user, "没有从该发射台送出的机器人！")
		return
	user.balloon_alert(user, "机器人已送回发射台")
	var/mob/living/basic/bot/basic_bot = our_bot
	basic_bot.summon_bot(src)

/obj/structure/closet/supplypod/transport/botpod
	reverse_option_list = list("Mobs"=TRUE,"Objects"=FALSE,"Anchored"=FALSE,"Underfloor"=FALSE,"Wallmounted"=FALSE,"Floors"=FALSE,"Walls"=FALSE,"Mecha"=FALSE)
	leavingSound = 'sound/vehicles/rocketlaunch.ogg'
