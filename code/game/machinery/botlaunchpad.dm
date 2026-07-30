// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/machinery/botpad
	name = "Bot pad"
	desc = "A lighter version of the orbital mech pad modified to launch bots. Requires linking to a remote to function."
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
	balloon_alert(user, LANG("obj.84afb909", null))
	return ITEM_INTERACT_SUCCESS

// Checks the turf for a bot and launches it if it's the only mob on the pad.
/obj/machinery/botpad/proc/launch(mob/living/user)
	var/turf/reverse_turf = get_turf(user)
	var/atom/possible_bot
	for(var/mob/living/robot in get_turf(src))
		if(!isbot(robot))
			user.balloon_alert(user, LANG("obj.5f208fb8", null))
			return
		if(!isnull(possible_bot))
			user.balloon_alert(user, LANG("obj.e7f89750", null))
			return
		possible_bot = robot  // We don't change the launched_bot var here because we are not sure if there is another bot on the pad.

	if(!use_energy(active_power_usage, force = FALSE))
		balloon_alert(user, LANG("obj.204cf586", null))
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
		user.balloon_alert(user, LANG("obj.81676f69", null))
		return
	user.balloon_alert(user, LANG("obj.342d35a1", null))
	var/mob/living/basic/bot/basic_bot = our_bot
	basic_bot.summon_bot(src)

/obj/structure/closet/supplypod/transport/botpod
	reverse_option_list = list("Mobs"=TRUE,"Objects"=FALSE,"Anchored"=FALSE,"Underfloor"=FALSE,"Wallmounted"=FALSE,"Floors"=FALSE,"Walls"=FALSE,"Mecha"=FALSE)
	leavingSound = 'sound/vehicles/rocketlaunch.ogg'
