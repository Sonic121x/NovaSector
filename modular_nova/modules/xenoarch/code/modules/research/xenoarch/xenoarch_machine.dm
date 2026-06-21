// Researcher, Scanner, Recoverer, and Digger

/obj/machinery/xenoarch
	icon = 'modular_nova/modules/xenoarch/icons/xenoarch_machines.dmi'
	density = TRUE
	layer = BELOW_OBJ_LAYER
	use_power = IDLE_POWER_USE
	idle_power_usage = 100
	pass_flags = PASSTABLE
	/// the item that holds everything
	var/obj/item/storage_unit
	///how long between each process
	var/process_speed = 10 SECONDS
	COOLDOWN_DECLARE(process_delay)

/obj/machinery/xenoarch/Initialize(mapload)
	. = ..()
	storage_unit = new /obj/item(src)

/obj/machinery/xenoarch/Destroy()
	QDEL_NULL(storage_unit)
	return ..()

/obj/machinery/xenoarch/RefreshParts()
	. = ..()
	var/efficiency = -2 //to allow t1 parts to not change the base speed
	for(var/datum/stock_part/stockpart in component_parts)
		efficiency += stockpart.tier

	process_speed = initial(process_speed) - (efficiency)

/obj/machinery/xenoarch/process()
	if(machine_stat & (NOPOWER|BROKEN) || !anchored)
		COOLDOWN_RESET(src, process_delay) //if you are broken or no power (or not anchored), you aren't allowed to progress!
		return

	if(!COOLDOWN_FINISHED(src, process_delay))
		return

	COOLDOWN_START(src, process_delay, process_speed)
	xenoarch_process()

/obj/machinery/xenoarch/proc/xenoarch_process()
	return

/obj/machinery/xenoarch/wrench_act(mob/living/user, obj/item/tool)
	. = ..()

	if(default_unfasten_wrench(user, tool))
		return ITEM_INTERACT_SUCCESS

/obj/machinery/xenoarch/screwdriver_act(mob/living/user, obj/item/tool)
	. = ..()

	toggle_panel_open()
	to_chat(user, span_notice("你[panel_open ? "open":"close"]了[src]的维护区面板。"))
	tool.play_tool_sound(src)
	return ITEM_INTERACT_SUCCESS

/obj/machinery/xenoarch/crowbar_act(mob/living/user, obj/item/tool)
	. = ..()

	return default_deconstruction_crowbar(user, tool)

/obj/machinery/xenoarch/researcher
	name = "异星考古研究员"
	desc = "一台用于将奇异岩石、无用遗物和破损物品压缩成更大文物的机器。"
	icon_state = "researcher"
	circuit = /obj/item/circuitboard/machine/xenoarch_machine/xenoarch_researcher
	/// the amount of research that is currently done
	var/current_research = 0
	/// the max amount of value we can have
	var/max_research = 300
	/// the value of each accepted item
	var/list/accepted_types = list(
		/obj/item/xenoarch/strange_rock = 10,
		/obj/item/xenoarch/broken_item = 15,
	)

/obj/machinery/xenoarch/researcher/examine(mob/user)
	. = ..()

	. += span_notice("<br>可用研究点数：[current_research]/[max_research]。")
	. += span_notice("左键点击插入物品或取出所有奇异岩石。右键点击使用研究点数。")

/obj/machinery/xenoarch/researcher/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers)
	if(istype(attacking_item, /obj/item/storage/bag/xenoarch))
		for(var/obj/strange_rocks in attacking_item.contents)
			strange_rocks.forceMove(storage_unit)

		balloon_alert(user, "岩石已插入！")
		return

	if(is_type_in_list(attacking_item, accepted_types))
		attacking_item.forceMove(storage_unit)
		balloon_alert(user, "物品已插入！")
		return

	return ..()

/obj/machinery/xenoarch/researcher/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	var/choice = tgui_input_list(user, "要从[src]中移除岩石吗？", "岩石移除", list("Yes", "No"))
	if(choice != "Yes")
		return
	var/turf/src_turf = get_turf(src)
	for(var/obj/item/removed_item in storage_unit.contents)
		removed_item.forceMove(src_turf)

	balloon_alert(user, "物品已移除！")

/obj/machinery/xenoarch/researcher/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	var/turf/src_turf = get_turf(src)
	var/choice = tgui_input_list(user, "选择你想要哪种奖励！", "奖励选择", list("Lavaland Chest (100)", "Anomalous Crystal (100)", "Bepis Tech (60)"))
	if(!choice)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	switch(choice)
		if("Lavaland Chest (100)")
			if(current_research < 100)
				balloon_alert(user, "研究点数不足！")
				return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

			current_research -= 100
			new /obj/structure/closet/crate/necropolis/tendril(src_turf)
			new /obj/item/skeleton_key(src_turf)

		if("Anomalous Crystal (100)")
			if(current_research < 100)
				balloon_alert(user, "研究点数不足！")
				return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

			current_research -= 100
			var/list/choices = subtypesof(/obj/machinery/anomalous_crystal) - /obj/machinery/anomalous_crystal/theme_warp
			var/random_crystal = pick(choices)
			new random_crystal(src_turf)

		if("Bepis Tech (60)")
			if(current_research < 60)
				balloon_alert(user, "研究点数不足！")
				return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

			current_research -= 60
			new /obj/item/disk/design_disk/bepis/remove_tech(src_turf)

	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/machinery/xenoarch/researcher/xenoarch_process()
	if(length(storage_unit.contents) <= 0)
		return

	if(current_research >= max_research)
		return

	var/obj/item/first_item = storage_unit.contents[1]
	var/reward_attempt = accepted_types[first_item.type]
	current_research = min(current_research + reward_attempt, 300)
	qdel(first_item)

/obj/machinery/xenoarch/scanner
	name = "异星考古扫描仪"
	desc = "一台用于扫描奇异岩石的机器，使其内部的物品更容易被提取出来。"
	icon_state = "scanner"
	circuit = /obj/item/circuitboard/machine/xenoarch_machine/xenoarch_scanner

/obj/machinery/xenoarch/scanner/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers)
	if(istype(attacking_item, /obj/item/storage/bag/xenoarch))
		for(var/obj/item/xenoarch/strange_rock/chosen_rocks in attacking_item.contents)
			chosen_rocks.get_scanned(TRUE)

		balloon_alert(user, "扫描完成！")
		return

	if(istype(attacking_item, /obj/item/xenoarch/strange_rock))
		var/obj/item/xenoarch/strange_rock/chosen_rock = attacking_item
		if(chosen_rock.get_scanned(TRUE))
			balloon_alert(user, "扫描完成！")
			return

		to_chat(user, span_warning("[chosen_rock] 无法被扫描，或许它已经被扫描过了？"))
		return

	return ..()

/obj/machinery/xenoarch/digger
	name = "异星考古挖掘机"
	desc = "一台用于缓慢发掘奇异岩石内部物品的机器。"
	icon_state = "digger"
	circuit = /obj/item/circuitboard/machine/xenoarch_machine/xenoarch_digger

/obj/machinery/xenoarch/digger/examine(mob/user)
	. = ..()
	. += span_notice("<br>左键点击以移除 [src] 内的所有物品。")

/obj/machinery/xenoarch/digger/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers)
	if(istype(attacking_item, /obj/item/storage/bag/xenoarch))
		for(var/obj/strange_rocks in attacking_item.contents)
			strange_rocks.forceMove(storage_unit)
		balloon_alert(user, "岩石已插入！")
		return

	if(istype(attacking_item, /obj/item/xenoarch/strange_rock))
		attacking_item.forceMove(storage_unit)
		balloon_alert(user, "岩石已插入！")
		return

/obj/machinery/xenoarch/digger/attack_hand(mob/living/user, list/modifiers)
	var/choice = tgui_input_list(user, "从[src]中移除岩石？", "岩石移除", list("Yes", "No"))
	if(choice != "Yes")
		return

	var/turf/src_turf = get_turf(src)
	for(var/obj/item/removed_item in storage_unit.contents)
		removed_item.forceMove(src_turf)

	balloon_alert(user, "物品已移除！")

/obj/machinery/xenoarch/digger/xenoarch_process()
	var/turf/src_turf = get_turf(src)
	if(length(storage_unit.contents) <= 0)
		return

	var/obj/item/xenoarch/strange_rock/first_item = storage_unit.contents[1]
	new first_item.hidden_item(src_turf)
	qdel(first_item)
