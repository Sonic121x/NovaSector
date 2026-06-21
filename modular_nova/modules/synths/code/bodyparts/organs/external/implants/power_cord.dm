/obj/item/organ/cyberimp/arm/toolkit/power_cord
	name = "充电植入体"
	desc = "一根内置电源线。如果你靠电力运行，它会很有用。否则就没多大用处。"
	items_to_create = list(/obj/item/synth_powercord)
	zone = "l_arm"
	cannot_confiscate = TRUE

/obj/item/organ/cyberimp/arm/toolkit/power_cord/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF || !IS_ROBOTIC_ORGAN(src))
		return
	var/effect_chance = 0
	switch(severity)
		if(EMP_LIGHT)
			effect_chance = 22.5
		if(EMP_HEAVY)
			effect_chance = 45
	if(prob(effect_chance) && owner)
		owner.visible_message(
			span_danger("[owner]的充电植入体迸出火花，噼啪作响！"),
			span_warning("你的充电植入体短路了，让你抽搐起来！")
		)
		if(active_item)
			Retract()
		owner.adjust_stutter(severity == EMP_LIGHT ? 4 SECONDS : 8 SECONDS)
		owner.set_jitter_if_lower(severity == EMP_LIGHT ? 6 SECONDS : 12 SECONDS)
		do_sparks(3, TRUE, owner)
		SEND_SIGNAL(owner, COMSIG_LIVING_MINOR_SHOCK)

/obj/item/synth_powercord
	name = "电源线"
	desc = "一根内置电源线。如果你靠电力运行，它会很有用。否则就没多大用处。"
	icon = 'icons/obj/stack_objects.dmi'
	icon_state = "wire1"
	///Object basetypes which the powercord is allowed to connect to.
	var/static/list/synth_charge_whitelist = typecacheof(list(
		/obj/item/stock_parts/power_store,
		/obj/machinery/power/apc,
	))

// Attempt to charge from an object by using them on the power cord.
/obj/item/synth_powercord/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!can_power_draw(tool, user))
		return NONE
	try_power_draw(tool, user)
	return ITEM_INTERACT_SUCCESS

// Attempt to charge from an object by using the power cord on them.
/obj/item/synth_powercord/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!can_power_draw(interacting_with, user))
		return NONE
	try_power_draw(interacting_with, user)
	return ITEM_INTERACT_SUCCESS

/// Returns TRUE or FALSE depending on if the target object can be used as a power source.
/obj/item/synth_powercord/proc/can_power_draw(obj/target, mob/user)
	return ishuman(user) && is_type_in_typecache(target, synth_charge_whitelist)

/// Attempts to start using an object as a power source.
/// Checks the user's internal powercell to see if it exists.
/obj/item/synth_powercord/proc/try_power_draw(obj/target, mob/living/carbon/human/user)
	// Only robotic species can use this
	if(!(user.mob_biotypes & MOB_ROBOTIC))
		to_chat(user, span_warning("你插入了[target]，但什么都没发生！看来你没有可供充电的内部电池。"))
		return

	/// The current user's nutrition level in joules.
	var/nutrition_level_joules = user.nutrition * SYNTH_JOULES_PER_NUTRITION
	user.changeNext_move(CLICK_CD_MELEE)

	var/obj/item/organ/stomach/synth/synth_cell = user.get_organ_slot(ORGAN_SLOT_STOMACH)
	if(QDELETED(synth_cell) || !istype(synth_cell))
		to_chat(user, span_warning("你插入了[target]，但什么都没发生！看来你没有可供充电的内部电池。"))
		return

	if(nutrition_level_joules > SYNTH_CHARGE_ALMOST_FULL)
		user.balloon_alert(user, "电池已充满！")
		return

	user.visible_message(span_notice("[user]将电源连接器插入[target]。"), span_notice("你开始从[target]汲取电力。"))
	do_power_draw(target, user)

	if(QDELETED(target))
		return

	user.visible_message(span_notice("[user]从[target]拔下插头。"), span_notice("你从[target]拔下插头。"))

/**
 * Runs a loop to charge a synth cell (stomach) from a power cell or APC.
 * Displays chat messages to the user and nearby observers.
 *
 * Stops when:
 * - The user's internal cell is full.
 * - The cell has less than the minimum charge.
 * - The user moves, or anything else that can happen to interrupt a do_after.
 *
 * Arguments:
 * * target - The power cell or APC to drain.
 * * user - The human mob draining the power cell.
 */
/obj/item/synth_powercord/proc/do_power_draw(obj/target, mob/living/carbon/human/user)
	// Draw power from an APC if one was given.
	var/obj/machinery/power/apc/target_apc
	if(istype(target, /obj/machinery/power/apc))
		target_apc = target

	var/obj/item/stock_parts/power_store/target_cell = target_apc ? target_apc.cell : target
	var/minimum_cell_charge = target_apc ? SYNTH_APC_MINIMUM_PERCENT : 0

	if(!target_cell || target_cell.percent() < minimum_cell_charge)
		user.balloon_alert(user, "APC电量低！")
		return
	var/wait = SSmachines.wait / (1 SECONDS)
	var/energy_needed
	while(TRUE)
		// Check if the charge level of the cell is below the minimum.
		// Prevents synths from overloading the cell.
		if(target_cell.percent() < minimum_cell_charge)
			user.balloon_alert(user, "APC电量低！")
			break

		// Attempt to drain charge from the cell.
		if(!do_after(user, wait SECONDS, target))
			break

		// Check if the user is nearly fully charged.
		// Ensures minimum draw is always lower than this margin.
		var/nutrition_level_joules = user.nutrition * SYNTH_JOULES_PER_NUTRITION
		energy_needed = SYNTH_CHARGE_MAX - nutrition_level_joules

		// Calculate how much to draw from the cell this cycle.
		var/current_draw = min(energy_needed, SYNTH_CHARGE_RATE * wait)

		var/energy_delivered = target_cell.use(current_draw, force = TRUE)
		target_cell.update_appearance()
		if(!energy_delivered)
			// The cell could be sabotaged, which causes it to explode and qdelete.
			if(QDELETED(target_cell))
				return
			user.balloon_alert(user, "[target_apc ? "APC" : "Cell"]已空！")
			break

		// If charging was successful, then increase user nutrition and emit sparks.
		var/nutrition_gained = energy_delivered / SYNTH_JOULES_PER_NUTRITION
		user.nutrition = min(user.nutrition + nutrition_gained, NUTRITION_LEVEL_FULL)
		do_sparks(1, FALSE, target_cell.loc)
		if(user.nutrition > NUTRITION_LEVEL_ALMOST_FULL)
			user.balloon_alert(user, "已充满")
			break

/datum/design/synth_charger
	name = "充电线植入体"
	desc = "仅供合成人使用的内部电源线。需要连接到合成燃料单元才能工作。"
	id = "synth_charger"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 4 SECONDS
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/organ/cyberimp/arm/toolkit/power_cord
	category = list(
		RND_SUBCATEGORY_MECHFAB_ANDROID + RND_SUBCATEGORY_MECHFAB_ANDROID_ORGANS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE
