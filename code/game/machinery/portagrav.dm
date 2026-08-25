// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/machinery/power/portagrav
	anchored = FALSE
	density = TRUE
	interaction_flags_machine = INTERACT_MACHINE_ALLOW_SILICON
	icon = 'icons/obj/machines/gravity_generator.dmi'
	icon_state = "portagrav"
	base_icon_state = "portagrav"
	name = "Portable Gravity Unit"
	desc = "Generates gravity around itself. Powered by wire or cell. Must be anchored before use."
	max_integrity = 250
	circuit = /obj/item/circuitboard/machine/portagrav
	armor_type = /datum/armor/portable_gravity
	interaction_flags_click = ALLOW_SILICON_REACH
	//We don't use area power
	use_power = NO_POWER_USE
	///The cell we spawn with
	var/obj/item/stock_parts/power_store/cell/cell = /obj/item/stock_parts/power_store/cell/high
	///Is the machine on?
	var/on = FALSE
	/// do we use power from wire instead
	var/wire_mode = FALSE
	/// our gravity field
	var/datum/proximity_monitor/advanced/gravity/subtle_effect/gravity_field
	/// strength of our gravity
	var/grav_strength = STANDARD_GRAVITY
	/// gravity range
	var/range = 4
	/// max gravity range
	var/max_range = 6
	/// draw per range
	var/draw_per_range = BASE_MACHINE_ACTIVE_CONSUMPTION

/datum/armor/portable_gravity
	fire = 100
	melee = 10
	bomb = 40

/obj/machinery/power/portagrav/Initialize(mapload)
	. = ..()
	if(ispath(cell))
		cell = new cell(src)
	if(anchored && wire_mode)
		connect_to_network()

	AddElement( \
		/datum/element/contextual_screentip_bare_hands, \
		rmb_text = "Toggle power", \
	)

	var/static/list/tool_behaviors = list(
		TOOL_WRENCH = list(
			SCREENTIP_CONTEXT_LMB = "Anchor",
		),
	)
	AddElement(/datum/element/contextual_screentip_tools, tool_behaviors)

/obj/machinery/power/portagrav/Destroy()
	. = ..()
	cell = null

/obj/machinery/power/portagrav/update_overlays()
	. = ..()
	if(anchored)
		. += "portagrav_anchors"
	if(on)
		. += "portagrav_lights"
		. += "activated"

/obj/machinery/power/portagrav/examine(mob/user)
	. = ..()
	. += LANG("obj.62eee539c1582dc1", list(on ? "on" : "off"))
	. += LANG("obj.6860392aba59f705", list(!isnull(cell) ? "[round(cell.percent(), 1)]%" : "NO CELL"))
	. += LANG("obj.421c7a183b45329f", list(anchored ? "" : " not"))
	if(in_range(user, src) || isobserver(user))
		. += span_notice(LANG("obj.a322e9c4d26091f5", list(on ? "off" : "on")))

/obj/machinery/power/portagrav/RefreshParts()
	. = ..()
	var/power_usage = initial(draw_per_range)
	for(var/datum/stock_part/micro_laser/laser in component_parts)
		power_usage -= BASE_MACHINE_ACTIVE_CONSUMPTION / 10 * (laser.tier - 1)
	draw_per_range = power_usage
	var/new_range = 4
	for(var/datum/stock_part/capacitor/capacitor in component_parts)
		new_range += capacitor.tier
	max_range = new_range
	update_field()

/obj/machinery/power/portagrav/update_icon_state()
	. = ..()
	icon_state = panel_open ? "[base_icon_state]_o" : base_icon_state

/obj/machinery/power/portagrav/screwdriver_act(mob/living/user, obj/item/tool)
	return default_deconstruction_screwdriver(user, tool)

/obj/machinery/power/portagrav/crowbar_act(mob/living/user, obj/item/tool)
	return default_deconstruction_crowbar(user, tool)

/obj/machinery/power/portagrav/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/stock_parts/power_store/cell))
		return NONE
	if(!panel_open)
		balloon_alert(user, LANG("obj.6901e1513948708e", null))
		return ITEM_INTERACT_BLOCKING
	if(cell)
		balloon_alert(user, LANG("obj.62f73cd529e01ae3", null))
		return ITEM_INTERACT_BLOCKING
	if(!user.transferItemToLoc(tool, src))
		return ITEM_INTERACT_FAILURE
	cell = tool
	return ITEM_INTERACT_SUCCESS

/obj/machinery/power/portagrav/should_have_node()
	return anchored

/obj/machinery/power/portagrav/connect_to_network()
	if(!anchored)
		return FALSE
	. = ..()

/obj/machinery/power/portagrav/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	if(on)
		balloon_alert(user, LANG("obj.19a396d6413f5298", null))
		return
	default_unfasten_wrench(user, tool)
	if(anchored && wire_mode)
		connect_to_network()
	else
		disconnect_from_network()
	update_appearance()
	return ITEM_INTERACT_SUCCESS

/obj/machinery/power/portagrav/get_cell()
	return cell

/obj/machinery/power/portagrav/attack_hand(mob/living/carbon/user, list/modifiers)
	. = ..()
	if(!panel_open || isnull(cell) || !istype(user) || user.combat_mode)
		return
	if(user.put_in_hands(cell))
		cell = null

/obj/machinery/power/portagrav/attack_hand_secondary(mob/user, list/modifiers)
	if(!can_interact(user))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	toggle_on(user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/machinery/power/portagrav/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(obj_flags & EMAGGED)
		return FALSE
	obj_flags |= EMAGGED
	visible_message(span_warning(LANG("obj.b7523a488c133b30", list(src))))
	if(user)
		balloon_alert(user, LANG("obj.6ece93b7fb5b998b", null))
		user.log_message("emagged [src].", LOG_ATTACK)
	playsound(src, SFX_SPARKS, 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	return TRUE

/obj/machinery/power/portagrav/proc/toggle_on(mob/user)
	if(on)
		turn_off(user)
	else
		turn_on(user)

/obj/machinery/power/portagrav/proc/turn_on(mob/user)
	if(!anchored)
		if(!isnull(user))
			balloon_alert(user, LANG("obj.e0a7c3cede561161", null))
		return FALSE
	if((!wire_mode && cell?.charge < draw_per_range * range) || (wire_mode && surplus() < draw_per_range * range))
		if(!isnull(user))
			balloon_alert(user, LANG("obj.7005f2d2db44de44", null))
		return FALSE
	if(!isnull(user))
		balloon_alert(user, LANG("obj.9fae209bc47e34ea", null))
	on = TRUE
	START_PROCESSING(SSmachines, src)
	gravity_field = new(src, range = src.range, gravity = grav_strength)
	update_appearance()

/obj/machinery/power/portagrav/proc/turn_off(mob/user)
	on = FALSE
	if(!isnull(user))
		balloon_alert(user, LANG("obj.49613fe46788cb6a", null))
	STOP_PROCESSING(SSmachines, src)
	QDEL_NULL(gravity_field)
	update_appearance()

/obj/machinery/power/portagrav/process(seconds_per_tick)
	if(!on || !anchored)
		return PROCESS_KILL
	if(wire_mode)
		if(powernet && surplus() >= draw_per_range * range)
			add_load(draw_per_range * range)
		else
			turn_off()
	else
		if(!cell?.use(draw_per_range * range))
			turn_off()

/obj/machinery/power/portagrav/proc/update_field()
	if(isnull(gravity_field))
		return
	gravity_field.set_range(range)
	gravity_field.gravity_value = grav_strength
	gravity_field.recalculate_field(full_recalc = TRUE)

/obj/machinery/power/portagrav/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Portagrav", name)
		ui.open()

/obj/machinery/power/portagrav/ui_data(mob/user)
	. = list()
	if(!isnull(cell))
		.["percentage"] = (cell.charge / cell.maxcharge) * 100
	.["gravity"] = grav_strength
	.["range"] = range
	.["maxrange"] = max_range
	.["on"] = on
	.["wiremode"] = wire_mode
	.["draw"] = display_power(draw_per_range * range)

/obj/machinery/power/portagrav/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	playsound(src, 'sound/machines/terminal/terminal_button07.ogg', 45, TRUE)
	switch(action)
		if("adjust_grav")
			var/adjustment = text2num(params["adjustment"])
			if(isnull(adjustment))
				return
			var/bonus = (obj_flags & EMAGGED) ? 2 : 0
			// REPLACE 0 with NEGATIVE_GRAVITY ONCE NEGATIVE GRAVITY IS SOMETHING ACTUALLY FUNCTIONAL
			var/result = clamp(grav_strength + adjustment, 0, GRAVITY_DAMAGE_THRESHOLD - 1 + bonus)
			if(result == grav_strength)
				return
			grav_strength = result
			update_field()
			return TRUE
		if("toggle_power")
			toggle_on(usr)
			return TRUE
		if("toggle_wire")
			wire_mode = !wire_mode
			if(wire_mode && anchored)
				connect_to_network()
			else
				disconnect_from_network()
			return TRUE
		if("adjust_range")
			var/adjustment = text2num(params["adjustment"])
			if(isnull(adjustment))
				return
			var/result = clamp(range + adjustment, 0, max_range)
			if(result == range)
				return
			range = result
			update_field()
			return TRUE

/obj/machinery/power/portagrav/anchored
	anchored = TRUE
