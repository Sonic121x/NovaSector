/obj/machinery/teleport
	name = "传送器"
	icon = 'icons/obj/machines/teleporter.dmi'
	density = TRUE

/obj/machinery/teleport/hub
	name = "传送机枢纽"
	desc = "它是传送机的枢纽。"
	icon_state = "tele0"
	base_icon_state = "tele"
	circuit = /obj/item/circuitboard/machine/teleporter_hub
	var/accuracy = 0
	var/obj/machinery/teleport/station/power_station
	var/calibrated = FALSE//Calibration prevents mutation

/obj/machinery/teleport/hub/Initialize(mapload)
	. = ..()
	link_power_station()

/obj/machinery/teleport/hub/Destroy()
	if (power_station)
		power_station.teleporter_hub = null
		power_station = null
	return ..()

/obj/machinery/teleport/hub/RefreshParts()
	. = ..()
	var/A = 0
	for(var/datum/stock_part/matter_bin/matter_bin in component_parts)
		A += matter_bin.tier
	accuracy = A

/obj/machinery/teleport/hub/examine(mob/user)
	. = ..()
	if(in_range(user, src) || isobserver(user))
		. += span_notice("状态显示屏显示：成功率为<b>[70 + (accuracy * 10)]%</b>。")

/obj/machinery/teleport/hub/proc/link_power_station()
	if(power_station)
		return
	for(var/direction in GLOB.cardinals)
		power_station = locate(/obj/machinery/teleport/station, get_step(src, direction))
		if(power_station)
			power_station.link_console_and_hub()
			break
	return power_station

/obj/machinery/teleport/hub/Bumped(atom/movable/AM)
	if(is_centcom_level(z))
		to_chat(AM, span_warning("你不能在这里使用这个！"))
		return
	if(is_ready())
		teleport(AM)

/obj/machinery/teleport/hub/screwdriver_act(mob/living/user, obj/item/tool)
	return default_deconstruction_screwdriver(user, tool)

/obj/machinery/teleport/hub/crowbar_act(mob/living/user, obj/item/tool)
	return default_deconstruction_crowbar(user, tool)

/obj/machinery/teleport/hub/on_set_panel_open(old_value)
	if(panel_open && power_station?.engaged)
		power_station.engaged = FALSE
		update_appearance()

/obj/machinery/teleport/hub/proc/teleport(atom/movable/M as mob|obj, turf/T)
	var/obj/machinery/computer/teleporter/com = power_station.teleporter_console
	if (QDELETED(com))
		return
	var/atom/target
	if(com.target_ref)
		target = com.target_ref.resolve()
	if (!target)
		com.target_ref = null
		visible_message(span_alert("无法验证坐标锁定。请重新建立坐标矩阵。"))
		return
	if(!ismovable(M))
		return
	var/turf/start_turf = get_turf(M)
	if(!do_teleport(M, target, channel = TELEPORT_CHANNEL_BLUESPACE))
		return
	playsound(loc, SFX_PORTAL_ENTER, 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	use_energy(active_power_usage)
	new /obj/effect/temp_visual/portal_animation(start_turf, src, M)
	if(!calibrated && ishuman(M) && prob(30 - ((accuracy) * 10))) //oh dear a problem
		var/mob/living/carbon/human/human = M
		/* - NOVA EDIT REMOVAL START
		if(!(human.mob_biotypes & (MOB_ROBOTIC|MOB_MINERAL|MOB_UNDEAD|MOB_SPIRIT)))
			var/datum/species/species_to_transform = /datum/species/fly
			if(check_holidays(MOTH_WEEK))
				species_to_transform = /datum/species/moth
			if(human.dna && human.dna.species.id != initial(species_to_transform.id))
				to_chat(M, span_hear("You hear a buzzing in your ears."))
				human.set_species(species_to_transform)
				human.log_message("was turned into a [initial(species_to_transform.name)] through [src].", LOG_GAME)
		*/ //NOVA EDIT REMOVAL END
		// NOVA EDIT ADDITION START
		if(!HAS_TRAIT(human, TRAIT_NODISMEMBER))
			to_chat(human, span_danger("传送时，你的肢体失去了分子凝聚力！"))
			var/list/bodyparts_dismember = list()
			var/rad_mod = 0
			for(var/obj/item/bodypart/BP in human.bodyparts)
				if(BP.body_zone == BODY_ZONE_CHEST || BP.body_zone== BODY_ZONE_HEAD)
					continue
				bodyparts_dismember.Add(BP)
			for(var/i in 1 to 2) //Removing two bodyparts.
				var/obj/item/bodypart/BP = pick(bodyparts_dismember)
				if(!istype(BP))
					rad_mod += 300 //Bad snowflake, take more rads!
					break
				bodyparts_dismember.Remove(BP) //GC optimisation
				human.log_message("lost a [initial(BP.name)] to the [src].", LOG_GAME)
				BP.dismember()
				qdel(BP)
		//NOVA EDIT ADDITION END
	calibrated = FALSE

/obj/machinery/teleport/hub/update_icon_state()
	icon_state = "[base_icon_state][panel_open ? "-o" : (is_ready() ? 1 : 0)]"
	return ..()

/obj/machinery/teleport/hub/proc/is_ready()
	. = !panel_open && !(machine_stat & (BROKEN|NOPOWER)) && power_station && power_station.engaged && !(power_station.machine_stat & (BROKEN|NOPOWER))

/obj/machinery/teleport/hub/syndicate/Initialize(mapload)
	. = ..()
	LAZYADD(component_parts, GLOB.stock_part_datums[/datum/stock_part/matter_bin/tier3])
	RefreshParts()

/obj/machinery/teleport/station
	name = "传送站"
	desc = "蓝空传送机的电源控制站。用于切换电源，并可以测试发射以防止故障。"
	icon_state = "controller"
	base_icon_state = "controller"
	circuit = /obj/item/circuitboard/machine/teleporter_station
	var/engaged = FALSE
	var/obj/machinery/computer/teleporter/teleporter_console
	var/obj/machinery/teleport/hub/teleporter_hub
	var/list/linked_stations = list()
	var/efficiency = 0

/obj/machinery/teleport/station/Initialize(mapload)
	. = ..()
	link_console_and_hub()

/obj/machinery/teleport/station/RefreshParts()
	. = ..()
	var/E
	for(var/datum/stock_part/capacitor/C in component_parts)
		E += C.tier
	efficiency = E - 1

/obj/machinery/teleport/station/examine(mob/user)
	. = ..()
	if(!panel_open)
		. += span_notice("面板被<i>螺丝</i>固定，挡住了连接装置和接线面板。")
	else
		. += span_notice("<i>连接</i>装置现在可以用多功能工具<i>扫描</i>了。")
	if(in_range(user, src) || isobserver(user))
		. += span_notice("状态显示屏显示：此站点可连接到<b>[efficiency]</b>个其他站点。")

/obj/machinery/teleport/station/proc/link_console_and_hub()
	for(var/direction in GLOB.cardinals)
		teleporter_hub = locate(/obj/machinery/teleport/hub, get_step(src, direction))
		if(teleporter_hub)
			teleporter_hub.link_power_station()
			break
	for(var/direction in GLOB.cardinals)
		teleporter_console = locate(/obj/machinery/computer/teleporter, get_step(src, direction))
		if(teleporter_console)
			teleporter_console.link_power_station()
			break
	return teleporter_hub && teleporter_console


/obj/machinery/teleport/station/Destroy()
	if(teleporter_hub)
		teleporter_hub.power_station = null
		teleporter_hub.update_appearance()
		teleporter_hub = null
	if (teleporter_console)
		teleporter_console.power_station = null
		teleporter_console = null
	return ..()

/obj/machinery/teleport/station/multitool_act(mob/living/user, obj/item/multitool/tool)
	. = NONE

	if(panel_open)
		tool.set_buffer(src)
		balloon_alert(user, "已保存到多功能工具缓冲区")
		return ITEM_INTERACT_SUCCESS

	if(!istype(tool.buffer, /obj/machinery/teleport/station) || tool.buffer == src)
		return ITEM_INTERACT_BLOCKING

	if(linked_stations.len < efficiency)
		linked_stations.Add(tool.buffer)
		tool.set_buffer(null)
		balloon_alert(user, "数据已从缓冲区上传")
		return ITEM_INTERACT_SUCCESS

/obj/machinery/teleport/station/screwdriver_act(mob/living/user, obj/item/tool)
	return default_deconstruction_screwdriver(user, tool)

/obj/machinery/teleport/station/crowbar_act(mob/living/user, obj/item/tool)
	return default_deconstruction_crowbar(user, tool)

/obj/machinery/teleport/station/interact(mob/user)
	toggle(user)

/obj/machinery/teleport/station/proc/toggle(mob/user)
	if(machine_stat & (BROKEN|NOPOWER) || !teleporter_hub || !teleporter_console )
		return
	if (teleporter_console.target_ref?.resolve())
		if(teleporter_hub.panel_open || teleporter_hub.machine_stat & (BROKEN|NOPOWER))
			to_chat(user, span_alert("传送枢纽没有响应."))
		else
			engaged = !engaged
			use_energy(active_power_usage)
			to_chat(user, span_notice("传送器[engaged ? "" : "dis"]开连接！"))
	else
		teleporter_console.target_ref = null
		to_chat(user, span_alert("未检测到目标。"))
		engaged = FALSE
	teleporter_hub.update_appearance()
	add_fingerprint(user)

/obj/machinery/teleport/station/power_change()
	. = ..()
	if(teleporter_hub)
		teleporter_hub.update_appearance()

/obj/machinery/teleport/station/update_icon_state()
	if(panel_open)
		icon_state = "[base_icon_state]-o"
		return ..()
	if(machine_stat & (BROKEN|NOPOWER))
		icon_state = "[base_icon_state]-p"
		return ..()
	if(teleporter_console?.calibrating)
		icon_state = "[base_icon_state]-c"
		return ..()
	icon_state = base_icon_state
	return ..()
