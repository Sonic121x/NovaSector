/obj/machinery/quantumpad
	name = "量子板"
	desc = "用于将物体传送到其他量子板的蓝空量子连接传送盘。"
	icon = 'icons/obj/machines/telepad.dmi'
	icon_state = "qpad-idle"
	base_icon_state = "qpad"
	active_power_usage = BASE_MACHINE_ACTIVE_CONSUMPTION * 10
	obj_flags = CAN_BE_HIT | UNIQUE_RENAME
	circuit = /obj/item/circuitboard/machine/quantumpad
	var/teleport_cooldown = 400 //30 seconds base due to base parts
	var/teleport_speed = 50
	var/last_teleport //to handle the cooldown
	var/teleporting = FALSE //if it's in the process of teleporting
	var/power_efficiency = 1
	var/obj/machinery/quantumpad/linked_pad

	//mapping
	var/static/list/mapped_quantum_pads = list()
	var/map_pad_id = "" as text //what's my name
	var/map_pad_link_id = "" as text //who's my friend

/obj/machinery/quantumpad/Initialize(mapload)
	. = ..()
	if(map_pad_id)
		mapped_quantum_pads[map_pad_id] = src

	AddComponent(/datum/component/usb_port, typecacheof(list(/obj/item/circuit_component/quantumpad), only_root_path = TRUE))

/obj/machinery/quantumpad/Destroy()
	mapped_quantum_pads -= map_pad_id
	return ..()

/obj/machinery/quantumpad/examine(mob/user)
	. = ..()
	. += span_notice("它现在 [ linked_pad ? "currently" : "not"] 连接到另一个量子垫。")
	if(!panel_open)
		. += span_notice("面板已被<i>拧紧</i>，阻挡了连接装置。")
	else
		. += span_notice("The <i>linking</i> device is now able to be <i>scanned<i> with a multitool.")

/obj/machinery/quantumpad/RefreshParts()
	. = ..()
	var/E = 0
	for(var/datum/stock_part/capacitor/capacitor in component_parts)
		E += capacitor.tier
	power_efficiency = E
	E = 0
	for(var/datum/stock_part/servo/servo in component_parts)
		E += servo.tier
	teleport_speed = initial(teleport_speed)
	teleport_speed -= (E*10)
	teleport_cooldown = initial(teleport_cooldown)
	teleport_cooldown -= (E * 100)

/obj/machinery/quantumpad/multitool_act(mob/living/user, obj/item/multitool/multi_tool)
	if(panel_open)
		multi_tool.set_buffer(src)
		balloon_alert(user, "已保存到多功能工具缓冲区")
		to_chat(user, span_notice("你将数据保存到[multi_tool]的缓冲区。现在可以将其保存到面板已关闭的传送垫上。"))
		return ITEM_INTERACT_SUCCESS

	if(istype(multi_tool.buffer, /obj/machinery/quantumpad))
		if(multi_tool.buffer == src)
			balloon_alert(user, "无法连接到自身！")
			return ITEM_INTERACT_BLOCKING
		linked_pad = multi_tool.buffer
		balloon_alert(user, "数据已从缓冲区上传")
		return ITEM_INTERACT_SUCCESS

	balloon_alert(user, "未找到量子传送垫数据！")
	return NONE

/obj/machinery/quantumpad/screwdriver_act(mob/living/user, obj/item/tool)
	return default_deconstruction_screwdriver(user, tool)

/obj/machinery/quantumpad/crowbar_act(mob/living/user, obj/item/tool)
	return default_deconstruction_crowbar(user, tool)

/obj/machinery/quantumpad/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/quantum_keycard))
		var/obj/item/quantum_keycard/card = tool
		if(card.qpad)
			to_chat(user, span_notice("You insert [card] into [src]'s card slot, activating it."))
			interact(user, card.qpad)
			return ITEM_INTERACT_SUCCESS
		to_chat(user, span_notice("You insert [card] into [src]'s card slot, initiating the link procedure."))
		if(!do_after(user, 4 SECONDS, target = src))
			return ITEM_INTERACT_BLOCKING
		to_chat(user, span_notice("You complete the link between [card] and [src]."))
		card.set_pad(src)
		return ITEM_INTERACT_SUCCESS

	return NONE

/obj/machinery/quantumpad/update_icon_state()
	. = ..()
	if(machine_stat & (BROKEN|NOPOWER) || state_open)
		icon_state = "[base_icon_state]-idle-open"
	else
		icon_state = "[base_icon_state]-idle"

/obj/machinery/quantumpad/interact(mob/user, obj/machinery/quantumpad/target_pad = linked_pad)
	if(QDELETED(target_pad))
		if(map_pad_link_id && initMappedLink())
			target_pad = linked_pad
		else
			to_chat(user, span_warning("目标台无法定位！"))
			return
	//NOVA EDIT ADDITION
	var/turf/my_turf = get_turf(src)
	if(is_away_level(my_turf.z))
		to_chat(user, "<span class='warning'>[src] cannot be used here!</span>")
		return
	//NOVA EDIT END

	if(world.time < last_teleport + teleport_cooldown)
		to_chat(user, span_warning("[src] 正在充能,请稍等 [DisplayTimeText(last_teleport + teleport_cooldown - world.time)]."))
		return

	if(teleporting)
		to_chat(user, span_warning("[src] 正在充能,请稍等."))
		return

	if(target_pad.teleporting)
		to_chat(user, span_warning("目标pad繁忙。请稍等."))
		return

	if(target_pad.machine_stat & NOPOWER)
		to_chat(user, span_warning("目标pad对ping没有响应。"))
		return
	add_fingerprint(user)
	doteleport(user, target_pad)

/obj/machinery/quantumpad/proc/sparks()
	do_sparks(5, TRUE, src, spark_type = /datum/effect_system/basic/spark_spread/quantum)

/obj/machinery/quantumpad/attack_ghost(mob/dead/observer/ghost)
	. = ..()
	if(.)
		return
	if(!linked_pad && map_pad_link_id)
		initMappedLink()
	if(linked_pad)
		ghost.forceMove(get_turf(linked_pad))

/obj/machinery/quantumpad/proc/doteleport(mob/user = null, obj/machinery/quantumpad/target_pad = linked_pad)
	if(!target_pad)
		return
	playsound(get_turf(src), 'sound/items/weapons/flash.ogg', 25, TRUE)
	teleporting = TRUE

	addtimer(CALLBACK(src, PROC_REF(teleport_contents), user, target_pad), teleport_speed)

/obj/machinery/quantumpad/proc/teleport_contents(mob/user, obj/machinery/quantumpad/target_pad)
	teleporting = FALSE
	if(machine_stat & NOPOWER)
		if(user)
			to_chat(user, span_warning("[src] 没有能源!"))
		return
	if(QDELETED(target_pad) || target_pad.machine_stat & NOPOWER)
		if(user)
			to_chat(user, span_warning("链接pad对ping没有响应。传送中止."))
		return

	last_teleport = world.time

	// use a lot of power
	use_energy(active_power_usage / power_efficiency)
	sparks()
	target_pad.sparks()

	flick("[base_icon_state]-beam", src)
	playsound(get_turf(src), 'sound/items/weapons/emitter2.ogg', 25, TRUE)
	flick("[target_pad.base_icon_state]-beam", target_pad)
	playsound(get_turf(target_pad), 'sound/items/weapons/emitter2.ogg', 25, TRUE)
	for(var/atom/movable/ROI in get_turf(src))
		if(QDELETED(ROI))
			continue //sleeps in CHECK_TICK

		// if is anchored, don't let through
		if(ROI.anchored)
			continue

		if(isliving(ROI))
			var/mob/living/living_subject = ROI
			//only TP living mobs buckled to non anchored items
			if(living_subject.buckled && living_subject.buckled.anchored)
				continue

		do_teleport(ROI, get_turf(target_pad), no_effects = TRUE, channel = TELEPORT_CHANNEL_QUANTUM)
		CHECK_TICK

/obj/machinery/quantumpad/proc/initMappedLink()
	. = FALSE
	var/obj/machinery/quantumpad/link = mapped_quantum_pads[map_pad_link_id]
	if(link)
		linked_pad = link
		. = TRUE

/obj/item/paper/guides/quantumpad
	name = "给笨比用的量子盘"
	default_raw_text = "<center><b>量子传送垫傻瓜指南</b></center><br><br><center>你是否讨厌使用双腿，甚至<i>步行</i>去某个地方的概念？那么，有了量子传送垫(tm)，对心肺功能的恐惧再也不会阻止你去任何地方了！<br><br><c><b>如何设置你的量子传送垫(tm)</b></center><br><br>1.拧开你想要连接的量子传送垫(tm)。<br>2.使用你的多功能工具缓存你想要连接的量子传送垫(tm)的缓冲区。<br>3.将多功能工具应用到第二个量子传送垫(tm)，将其连接到第一个量子传送垫(tm)。<br><br><center>如果你仔细遵循了这些说明，你的量子传送垫(tm)现在应该已经正确连接，可以在空间站内实现近乎瞬间的移动！请注意，这在技术上是一种单向传送，所以如果你希望能在两者之间往返，你需要对第二个传送垫和第一个传送垫执行相同的过程。</center>"

/obj/item/circuit_component/quantumpad
	display_name = "Quantum Pad"
	desc = "用于将物体传送到其他量子板的蓝空量子连接传送盘。"
	circuit_flags = CIRCUIT_FLAG_INPUT_SIGNAL

	var/datum/port/input/target_pad
	var/datum/port/output/failed

	var/obj/machinery/quantumpad/attached_pad

/obj/item/circuit_component/quantumpad/populate_ports()
	target_pad = add_input_port("Target Pad", PORT_TYPE_ATOM)
	failed = add_output_port("On Fail", PORT_TYPE_SIGNAL)

/obj/item/circuit_component/quantumpad/register_usb_parent(atom/movable/shell)
	. = ..()
	if(istype(shell, /obj/machinery/quantumpad))
		attached_pad = shell

/obj/item/circuit_component/quantumpad/unregister_usb_parent(atom/movable/shell)
	attached_pad = null
	return ..()

/obj/item/circuit_component/quantumpad/input_received(datum/port/input/port)
	if(!attached_pad)
		return

	var/obj/machinery/quantumpad/targeted_pad = target_pad.value

	if((!attached_pad.linked_pad || QDELETED(attached_pad.linked_pad)) && !(targeted_pad && istype(targeted_pad)))
		failed.set_output(COMPONENT_SIGNAL)
		return

	if(world.time < attached_pad.last_teleport + attached_pad.teleport_cooldown)
		failed.set_output(COMPONENT_SIGNAL)
		return

	if(targeted_pad && istype(targeted_pad))
		if(attached_pad.teleporting || targeted_pad.teleporting)
			failed.set_output(COMPONENT_SIGNAL)
			return

		if(targeted_pad.machine_stat & NOPOWER)
			failed.set_output(COMPONENT_SIGNAL)
			return
		attached_pad.doteleport(target_pad = targeted_pad)
	else
		if(attached_pad.teleporting || attached_pad.linked_pad.teleporting)
			failed.set_output(COMPONENT_SIGNAL)
			return

		if(attached_pad.linked_pad.machine_stat & NOPOWER)
			failed.set_output(COMPONENT_SIGNAL)
			return
		attached_pad.doteleport(target_pad = attached_pad.linked_pad)
