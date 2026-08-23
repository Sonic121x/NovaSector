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
	to_chat(user, span_notice(LANG("obj.79c0c90b4e57b4c7", list(panel_open ? "open":"close", src))))
	tool.play_tool_sound(src)
	return ITEM_INTERACT_SUCCESS

/obj/machinery/xenoarch/crowbar_act(mob/living/user, obj/item/tool)
	. = ..()

	return default_deconstruction_crowbar(user, tool)

/obj/machinery/xenoarch/researcher
	name = "xenoarch researcher"
	desc = "A machine that is used to condense strange rocks, useless relics, and broken objects into bigger artifacts."
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

	. += span_notice(LANG("obj.29b2ab933cc527c3", list(current_research, max_research)))
	. += span_notice(LANG("obj.118b084dbe254099", null))

/obj/machinery/xenoarch/researcher/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/storage/bag/xenoarch))
		for(var/obj/strange_rocks in tool.contents)
			strange_rocks.forceMove(storage_unit)

		balloon_alert(user, LANG("obj.a8aaa85e459297d4", null))
		return ITEM_INTERACT_SUCCESS

	if(is_type_in_list(tool, accepted_types))
		tool.forceMove(storage_unit)
		balloon_alert(user, LANG("obj.cfd83b9e8f147a91", null))
		return ITEM_INTERACT_SUCCESS

	return ..()

/obj/machinery/xenoarch/researcher/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	var/choice = tgui_input_list(user, LANG("obj.b097b2e9b05a449d", list(src)), LANG("obj.0dc643ee0c0f0e3d", null), list("Yes", "No"))
	if(choice != "Yes")
		return
	var/turf/src_turf = get_turf(src)
	for(var/obj/item/removed_item in storage_unit.contents)
		removed_item.forceMove(src_turf)

	balloon_alert(user, LANG("obj.be8e985068e19d76", null))

/obj/machinery/xenoarch/researcher/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	var/turf/src_turf = get_turf(src)
	var/choice = tgui_input_list(user, LANG("obj.ca9d41494d12237e", null), LANG("obj.96c1a202948d1607", null), list("Lavaland Chest (100)", "Anomalous Crystal (100)", "Bepis Tech (60)"))
	if(!choice)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	switch(choice)
		if("Lavaland Chest (100)")
			if(current_research < 100)
				balloon_alert(user, LANG("obj.8aef966b7b73778d", null))
				return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

			current_research -= 100
			new /obj/structure/closet/crate/necropolis/tendril(src_turf)
			new /obj/item/skeleton_key(src_turf)

		if("Anomalous Crystal (100)")
			if(current_research < 100)
				balloon_alert(user, LANG("obj.8aef966b7b73778d", null))
				return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

			current_research -= 100
			var/list/choices = subtypesof(/obj/machinery/anomalous_crystal) - /obj/machinery/anomalous_crystal/theme_warp
			var/random_crystal = pick(choices)
			new random_crystal(src_turf)

		if("Bepis Tech (60)")
			if(current_research < 60)
				balloon_alert(user, LANG("obj.8aef966b7b73778d", null))
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
	name = "xenoarch scanner"
	desc = "A machine that is used to scan strange rocks, making it easier to extract the item inside."
	icon_state = "scanner"
	circuit = /obj/item/circuitboard/machine/xenoarch_machine/xenoarch_scanner

/obj/machinery/xenoarch/scanner/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/storage/bag/xenoarch))
		for(var/obj/item/xenoarch/strange_rock/chosen_rocks in tool.contents)
			chosen_rocks.get_scanned(TRUE)

		balloon_alert(user, LANG("obj.d4915572f139d893", null))
		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/xenoarch/strange_rock))
		var/obj/item/xenoarch/strange_rock/chosen_rock = tool
		if(chosen_rock.get_scanned(TRUE))
			balloon_alert(user, LANG("obj.d4915572f139d893", null))
			return ITEM_INTERACT_SUCCESS

		to_chat(user, span_warning(LANG("obj.d83c8e94c1d4b53f", list(chosen_rock))))
		return ITEM_INTERACT_BLOCKING

	return ..()

/obj/machinery/xenoarch/digger
	name = "xenoarch digger"
	desc = "A machine that is used to slowly uncover items within strange rocks."
	icon_state = "digger"
	circuit = /obj/item/circuitboard/machine/xenoarch_machine/xenoarch_digger

/obj/machinery/xenoarch/digger/examine(mob/user)
	. = ..()
	. += span_notice(LANG("obj.1ef54c60e0dda6c7", list(src)))

/obj/machinery/xenoarch/digger/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/storage/bag/xenoarch))
		for(var/obj/strange_rocks in tool.contents)
			strange_rocks.forceMove(storage_unit)
		balloon_alert(user, LANG("obj.a8aaa85e459297d4", null))
		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/xenoarch/strange_rock))
		tool.forceMove(storage_unit)
		balloon_alert(user, LANG("obj.f107278f48dbdc8f", null))
		return ITEM_INTERACT_SUCCESS

	return ITEM_INTERACT_BLOCKING

/obj/machinery/xenoarch/digger/attack_hand(mob/living/user, list/modifiers)
	var/choice = tgui_input_list(user, LANG("obj.b097b2e9b05a449d", list(src)), LANG("obj.0dc643ee0c0f0e3d", null), list("Yes", "No"))
	if(choice != "Yes")
		return

	var/turf/src_turf = get_turf(src)
	for(var/obj/item/removed_item in storage_unit.contents)
		removed_item.forceMove(src_turf)

	balloon_alert(user, LANG("obj.be8e985068e19d76", null))

/obj/machinery/xenoarch/digger/xenoarch_process()
	var/turf/src_turf = get_turf(src)
	if(length(storage_unit.contents) <= 0)
		return

	var/obj/item/xenoarch/strange_rock/first_item = storage_unit.contents[1]
	new first_item.hidden_item(src_turf)
	qdel(first_item)
