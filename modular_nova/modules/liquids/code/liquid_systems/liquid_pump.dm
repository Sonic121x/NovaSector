//Right now it's a structure that works off of magic, as it'd require an internal power source for what its supposed to do
/obj/structure/liquid_pump
	name = "便携式液体泵"
	desc = "一款工业级泵，能够抽取或喷出液体。需要先固定才能工作。具有有限容量的内部存储空间。"
	icon = 'modular_nova/modules/liquids/icons/obj/structures/liquid_pump.dmi'
	icon_state = "liquid_pump"
	density = TRUE
	max_integrity = 500
	anchored = FALSE
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	interaction_flags_click = NEED_DEXTERITY
	/// How many reagents at maximum can it hold
	var/max_volume = 10000
	/// Whether spewing reagents out, instead of siphoning them
	var/spewing_mode = FALSE
	/// Whether it's turned on and processing
	var/turned_on = FALSE
	/// How fast does the pump work, in percentages relative to the volume we're working with
	var/pump_speed_percentage = 0.4
	/// How fast does the pump work, in flat values. Flat values on top of percentages to help processing
	var/pump_speed_flat = 20

/obj/structure/liquid_pump/wrench_act(mob/living/user, obj/item/I)
	. = ..()
	default_unfasten_wrench(user, I, 40)
	if(!anchored && turned_on)
		toggle_working()
	return TRUE

/obj/structure/liquid_pump/attack_hand(mob/user)
	if(!anchored)
		to_chat(user, span_warning("[src]需要先固定！"))
		return
	to_chat(user, span_notice("你将[src] [turned_on ? "off" : "on"]了。"))
	toggle_working()

/obj/structure/liquid_pump/click_alt(mob/living/user)
	to_chat(user, span_notice("你将[src]的喷出模式[spewing_mode ? "off" : "on"]了。"))
	spewing_mode = !spewing_mode
	update_icon()
	return CLICK_ACTION_SUCCESS

/obj/structure/liquid_pump/examine(mob/user)
	. = ..()
	. += span_notice("它的锚定螺栓[anchored ? "down and secured" : "up"]。")
	. += span_notice("它目前处于[turned_on ? "ON" : "OFF"]状态。")
	. += span_notice("它当前模式设置为[spewing_mode ? "SPEWING" : "SIPHONING"]。(Alt+点击切换)")
	. += span_notice("压力表显示[reagents.total_volume]/[reagents.maximum_volume]。")

/obj/structure/liquid_pump/process()
	if(!isturf(loc))
		return
	var/turf/T = loc
	if(spewing_mode)
		if(!reagents.total_volume)
			return
		var/datum/reagents/tempr = new(10000)
		reagents.trans_to(tempr, (reagents.total_volume * pump_speed_percentage) + pump_speed_flat, no_react = TRUE)
		T.add_liquid_from_reagents(tempr)
		qdel(tempr)
	else
		if(!T.liquids)
			return
		var/free_space = reagents.maximum_volume - reagents.total_volume
		if(!free_space)
			return
		var/target_siphon_amt = (T.liquids.total_reagents * pump_speed_percentage) + pump_speed_flat
		if(target_siphon_amt > free_space)
			target_siphon_amt = free_space
		var/datum/reagents/tempr = T.liquids.take_reagents_flat(target_siphon_amt)
		tempr.trans_to(reagents, tempr.total_volume)
		qdel(tempr)
	return

/obj/structure/liquid_pump/update_icon()
	. = ..()
	if(turned_on)
		if(spewing_mode)
			icon_state = "[initial(icon_state)]_spewing"
		else
			icon_state = "[initial(icon_state)]_siphoning"
	else
		icon_state = "[initial(icon_state)]"

/obj/structure/liquid_pump/proc/toggle_working()
	if(turned_on)
		STOP_PROCESSING(SSobj, src)
	else
		START_PROCESSING(SSobj, src)
	turned_on = !turned_on
	update_icon()

/obj/structure/liquid_pump/Initialize(mapload)
	. = ..()
	create_reagents(max_volume)

/obj/structure/liquid_pump/Destroy()
	if(turned_on)
		STOP_PROCESSING(SSobj, src)
	qdel(reagents)
	return ..()
