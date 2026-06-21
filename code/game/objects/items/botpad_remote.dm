/obj/item/botpad_remote
	name = "机器人平台控制器"
	desc = "使用此设备控制连接的机器人平台。"
	desc_controls = "Left-click for launch, right-click for recall."
	icon = 'icons/obj/devices/remote.dmi'
	icon_state = "botpad_controller"
	w_class = WEIGHT_CLASS_SMALL
	// ID of the remote, used for linking up
	var/id = "botlauncher"
	var/obj/machinery/botpad/connected_botpad

/obj/item/botpad_remote/Destroy()
	if(connected_botpad)
		connected_botpad.connected_remote = null
		connected_botpad = null
	return ..()

/obj/item/botpad_remote/attack_self(mob/living/user)
	playsound(src, SFX_TERMINAL_TYPE, 25, FALSE)
	try_launch(user)
	return

/obj/item/botpad_remote/attack_self_secondary(mob/living/user)
	playsound(src, SFX_TERMINAL_TYPE, 25, FALSE)
	if(connected_botpad)
		connected_botpad.recall(user)
		return
	user?.balloon_alert(user, "没有连接的发射台！")
	return

/obj/item/botpad_remote/multitool_act(mob/living/user, obj/item/multitool/multitool)
	. = NONE
	if(!istype(multitool.buffer, /obj/machinery/botpad))
		return

	var/obj/machinery/botpad/buffered_remote = multitool.buffer
	if(buffered_remote == connected_botpad)
		to_chat(user, span_warning("控制器无法连接到它自己的机器人平台！"))
		return ITEM_INTERACT_BLOCKING

	if(!connected_botpad && istype(buffered_remote, /obj/machinery/botpad))
		connected_botpad = buffered_remote
		connected_botpad.connected_remote = src
		connected_botpad.id = id
		multitool.set_buffer(null)
		to_chat(user, span_notice("You connect the controller to the pad with data from \the [multitool]'s buffer."))
		return ITEM_INTERACT_SUCCESS

/obj/item/botpad_remote/proc/try_launch(mob/living/user)
	if(!connected_botpad)
		user?.balloon_alert(user, "没有连接的发射台！")
		return
	if(connected_botpad.panel_open)
		user?.balloon_alert(user, "关闭面板！")
		return
	if(!(locate(/mob/living) in get_turf(connected_botpad)))
		user?.balloon_alert(user, "发射台上未检测到机器人！")
		return
	connected_botpad.launch(user)
