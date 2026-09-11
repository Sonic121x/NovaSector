// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
// License plate printing
/obj/machinery/plate_press
	name = "license plate press"
	desc = "You know, we're making a lot of license plates for a station with literally no cars in it."
	icon = 'icons/obj/machines/prison.dmi'
	icon_state = "offline"
	use_power = IDLE_POWER_USE
	idle_power_usage = BASE_MACHINE_IDLE_CONSUMPTION * 0.02
	active_power_usage = BASE_MACHINE_ACTIVE_CONSUMPTION * 0.05
	/// Reference to currently held license plate.
	var/obj/item/stack/license_plates/empty/current_plate
	/// Is the press currently pressing?
	var/pressing = FALSE

/obj/machinery/plate_press/update_icon_state()
	if(!is_operational)
		icon_state = "offline"
		return ..()
	if(pressing)
		icon_state = "loop"
		return ..()
	if(current_plate)
		icon_state = "online_loaded"
		return ..()
	icon_state = "online"
	return ..()

/obj/machinery/plate_press/Destroy()
	QDEL_NULL(current_plate)
	. = ..()

/obj/machinery/plate_press/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/stack/license_plates/empty))
		return NONE
	if(!is_operational)
		to_chat(user, span_warning(LANG("obj.7fc47c77a4071895", list(src))))
		return ITEM_INTERACT_BLOCKING
	if(current_plate)
		to_chat(user, span_warning(LANG("obj.1e895fc93f92cb4f", list(src))))
		return ITEM_INTERACT_BLOCKING

	var/obj/item/stack/license_plates/empty/plate = tool
	plate.use(1)
	current_plate = new plate.type(src, 1) //Spawn a new single sheet in the machine
	update_appearance()
	post_press(user)
	return ITEM_INTERACT_SUCCESS

/obj/machinery/plate_press/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(!pressing && current_plate)
		work_press(user)

///This proc attempts to create a plate. User cannot move during this process.
/obj/machinery/plate_press/proc/work_press(mob/living/user)

	pressing = TRUE
	update_appearance()
	to_chat(user, span_notice(LANG("obj.26c3d242bfef2955", null)))
	playsound(src, 'sound/machines/kerchunk.ogg', 80)

	if(!do_after(user, 4 SECONDS, target = src))
		pressing = FALSE
		update_appearance()
		return FALSE

	use_energy(active_power_usage)
	to_chat(user, span_notice(LANG("obj.cbe5289d35cacf5f", null)))

	pressing = FALSE
	QDEL_NULL(current_plate)
	update_appearance()

	new /obj/item/stack/license_plates/filled(drop_location())

/// Side effects after successfully pressing a license plate, including granting labor points.
/obj/machinery/plate_press/proc/post_press(mob/living/user)
	if(!user)
		return
	if(!istype(user.get_idcard(TRUE), /obj/item/card/id/advanced/prisoner))
		return // No bonus effects if we're not a prisoner or there's no ID.
	var/obj/item/card/id/advanced/prisoner/prison_id = user.get_idcard(TRUE)
	prison_id.points += PRISON_LABOR_PLATE
	to_chat(user, span_notice(LANG("obj.ed15ebadccb40de9", list(PRISON_LABOR_PLATE))))



//Grown crop recepticle.
/obj/machinery/produceporter
	name = "produceporter"
	desc = "A beaten up, landline teleporter designed to teleport produce back to the service department. This has seen better days."
	icon = 'icons/obj/machines/prison.dmi'
	icon_state = "produceporter_off"
	density =  TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = BASE_MACHINE_IDLE_CONSUMPTION * 0.01
	active_power_usage = BASE_MACHINE_ACTIVE_CONSUMPTION * 0.1
	/// Maximum amount of produce the machine can hold before it has to be either emptied or sent.
	var/max_produce = 10
	/// Current count of held produce
	var/current_produce = 0

/obj/machinery/produceporter/Initialize(mapload)
	. = ..()
	register_context()
	update_appearance()

/obj/machinery/produceporter/update_icon_state()
	if(!is_operational)
		icon_state = "produceporter_off"
		return ..()
	icon_state = "produceporter"
	return ..()

/obj/machinery/produceporter/update_overlays()
	. = ..()
	if(is_operational)
		. += emissive_appearance(icon, "produceporter_emissive", src)

/obj/machinery/produceporter/examine(mob/user)
	. = ..()
	if(current_produce >= max_produce)
		. += span_notice(LANG("obj.7b3a789dd160d77e", list(src)))
	else
		. += span_notice(LANG("obj.0ec197bd5403a58c", list(src)))
	if(!length(GLOB.produce_locations))
		. += span_notice(LANG("obj.4f07e15fff398f83", list(span_boldnotice("produce pads"))))
	else
		. += span_notice(LANG("obj.9a355fd017f93788", list(span_boldnotice("Right Click"))))

/obj/machinery/produceporter/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/food/grown))
		return NONE
	if(current_produce >= max_produce)
		balloon_alert(user, LANG("obj.90a5a035c89c7be5", null))
		return ITEM_INTERACT_FAILURE
	tool.forceMove(src)
	playsound(src, 'sound/items/handling/component_drop.ogg', 30)
	update_produce()
	balloon_alert(user, LANG("obj.c8f458b739b077c0", list(current_produce, max_produce)))
	return ITEM_INTERACT_SUCCESS

/obj/machinery/produceporter/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(!is_operational)
		balloon_alert(user, LANG("obj.756c153c1fbe91d8", null))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(!current_produce)
		balloon_alert(user, LANG("obj.71cea10d578fedde", null))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(!length(GLOB.produce_locations))
		balloon_alert(user, LANG("obj.986c7f2c3e692ba9", null))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	flick("produceporter_active", src)
	use_energy(active_power_usage)
	playsound(src, 'sound/items/weapons/emitter2.ogg', 50)
	var/points = 0
	var/produce_count = 0
	for(var/obj/item/food/grown/produce in contents)
		var/atom/dropoff = pick(GLOB.produce_locations)
		do_teleport(produce, dropoff.drop_location(), 0, asoundout = 'sound/machines/woosh.ogg')
		points += (produce.seed?.potency > 50 ? (PRISON_LABOR_CROPS * 2) : PRISON_LABOR_CROPS)
		produce_count ++
	balloon_alert_to_viewers(LANG("obj.6d42a611a38b5f53", null))
	post_delivery(user, points, produce_count)
	update_produce()
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/machinery/produceporter/ShiftClick(mob/user)
	. = ..()
	for(var/obj/item/food/grown/crops in contents)
		crops.forceMove(drop_location())
	visible_message(LANG("obj.567b925ccadcba18", list(src)))

/obj/machinery/produceporter/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()
	if(is_operational && current_produce > 0)
		context[SCREENTIP_CONTEXT_RMB] = "Send Produce"
	if(istype(held_item, /obj/item/food/grown))
		context[SCREENTIP_CONTEXT_LMB] = "Deposit Produce"
	return CONTEXTUAL_SCREENTIP_SET

/obj/machinery/produceporter/wrench_act(mob/living/user, obj/item/tool)
	. = ITEM_INTERACT_BLOCKING
	if(default_unfasten_wrench(user, tool, time = 1.5 SECONDS) == SUCCESSFUL_UNFASTEN)
		update_appearance(UPDATE_ICON_STATE)
		return ITEM_INTERACT_SUCCESS

/obj/machinery/produceporter/proc/update_produce()
	current_produce = 0
	for(var/obj/item/food/grown/crops in contents)
		if(current_produce > max_produce)
			return
		current_produce++
	return current_produce

/obj/machinery/produceporter/proc/post_delivery(mob/living/user, labor_points, produce_count)
	if(!user || !labor_points || !produce_count)
		return
	var/obj/item/card/id/id_card = user.get_idcard(TRUE)
	if(!istype(id_card, /obj/item/card/id/advanced/prisoner))
		return // No bonus effects if we're not a prisoner or there's no ID.
	var/obj/item/card/id/advanced/prisoner/prison_id = id_card
	prison_id.points += labor_points
	to_chat(user, span_notice(LANG("obj.5544b5e43f2b7cdb", list(labor_points))))

	aas_config_announce(/datum/aas_config_entry/gulag_produce, list(
		"LOCATION" = get_area_name(src),
		"COUNT" = produce_count
	), src, list(RADIO_CHANNEL_SUPPLY))

/datum/aas_config_entry/gulag_produce
	name = "Service Alert: Produce from Gulag Sent!"
	announcement_lines_map = list(
		"Message" = "A shipment of produce (%COUNT items) has been sent to %LOCATION from the Gulag.")
	vars_and_tooltips_map = list(
		"LOCATION" = "will be replaced with the location of the produce delivery.",
		"COUNT" = "Will be replaced with the quantity of produce received"
	)

GLOBAL_LIST_EMPTY(produce_locations)

/obj/item/producepad
	name = "produce pad"
	desc = "This lightweight contraption acts as a beacon for produceporters, teleporting freshly grown food to this location."
	icon = 'icons/obj/machines/prison.dmi'
	icon_state = "producepad"
	w_class = WEIGHT_CLASS_SMALL
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 3)

/obj/item/producepad/Initialize(mapload)
	. = ..()
	GLOB.produce_locations += src

/obj/item/producepad/Destroy(force)
	GLOB.produce_locations -= src
	return ..()
