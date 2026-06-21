//Credit to Beestation for the original anesthetic machine code: https://github.com/BeeStation/BeeStation-Hornet/pull/3753

/obj/machinery/anesthetic_machine
	name = "便携式麻醉剂罐支架"
	desc = "一个带轮子的支架，类似于静脉输液架，可以容纳一个麻醉剂罐和一个防毒面具。"
	icon = 'modular_nova/modules/medical/icons/obj/machinery.dmi'
	icon_state = "breath_machine"
	anchored = FALSE
	mouse_drag_pointer = MOUSE_ACTIVE_POINTER
	use_power = NO_POWER_USE
	/// The mask attached to the anesthetic machine
	var/obj/item/clothing/mask/breath/anesthetic/attached_mask
	/// the tank attached to the anesthetic machine, by default it does not come with one.
	var/obj/item/tank/attached_tank = null
	/// Is the attached mask currently out?
	var/mask_out = FALSE

/obj/machinery/anesthetic_machine/examine(mob/user)
	. = ..()

	. += "<b>Right-clicking</b> with a wrench will deconstruct the stand, if there is no tank attached."
	if(mask_out)
		. += "<b>Click</b> on the stand to retract the mask, if the mask is currently out"
	if(attached_tank)
		. += "<b>Alt + Click</b> to remove [attached_tank]."

/obj/machinery/anesthetic_machine/Initialize(mapload)
	. = ..()
	attached_mask = new /obj/item/clothing/mask/breath/anesthetic(src)
	update_icon()

/obj/machinery/anesthetic_machine/wrench_act_secondary(mob/living/user, obj/item/tool)
	if(user.combat_mode)
		return ..()

	if(mask_out)
		to_chat(user, span_warning("[src] 上目前连接着某人！"))
		return TRUE

	if(attached_tank)
		to_chat(user, span_warning("必须先从 [src] 上取下 [attached_tank]！"))
		return TRUE

	new /obj/item/anesthetic_machine_kit(get_turf(src))
	tool.play_tool_sound(user)
	to_chat(user, span_notice("你拆解了 [src]。"))
	qdel(src)
	return TRUE

/obj/machinery/anesthetic_machine/update_icon()
	. = ..()

	cut_overlays()

	if(attached_tank)
		add_overlay("tank_on")

	if(mask_out)
		add_overlay("mask_off")
		return
	add_overlay("mask_on")

/obj/machinery/anesthetic_machine/attack_hand(mob/living/user)
	. = ..()
	if(!retract_mask())
		return FALSE
	visible_message(span_notice("[user] 将 [attached_mask] 收回到 [src] 中。"))

/obj/machinery/anesthetic_machine/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers)
	if(!istype(attacking_item, /obj/item/tank))
		return ..()

	if(attached_tank) // If there is an attached tank, remove it and drop it on the floor
		attached_tank.forceMove(loc)

	attacking_item.forceMove(src) // Put new tank in, set it as attached tank
	visible_message(span_notice("[user] 将 [attacking_item] 插入 [src]。"))
	attached_tank = attacking_item
	update_icon()

/obj/machinery/anesthetic_machine/click_alt(mob/user)
	if(!attached_tank)
		return CLICK_ACTION_BLOCKING

	attached_tank.forceMove(loc)
	to_chat(user, span_notice("你取下了 [attached_tank]。"))
	attached_tank = null
	update_icon()
	if(mask_out)
		retract_mask()
	return CLICK_ACTION_SUCCESS

///Retracts the attached_mask back into the machine
/obj/machinery/anesthetic_machine/proc/retract_mask()
	if(!mask_out)
		return FALSE

	if(iscarbon(attached_mask.loc)) // If mask is on a mob
		var/mob/living/carbon/attached_mob = attached_mask.loc
		// Close external air tank
		if (attached_mob.external)
			attached_mob.close_externals()
		attached_mob.transferItemToLoc(attached_mask, src, TRUE)
	else
		attached_mask.forceMove(src)

	mask_out = FALSE
	update_icon()
	return TRUE

/obj/machinery/anesthetic_machine/mouse_drop_dragged(mob/living/carbon/over, mob/user, src_location, over_location, params)
	. = ..()
	if(!istype(over))
		return

	if((!Adjacent(over)) || !(user.Adjacent(over)))
		return FALSE

	if(!attached_tank || mask_out)
		to_chat(user, span_warning("[mask_out ? "The machine is already in use!" : "The machine has no attached tank!"]"))
		return FALSE

	// if we somehow lost the mask, let's just make a brand new one. the wonders of technology!
	if(QDELETED(attached_mask))
		attached_mask = new /obj/item/clothing/mask/breath/anesthetic(src)
		update_icon()

	user.visible_message(span_warning("[user] 试图将 [attached_mask] 连接到 [over]。"), span_notice("你试图将 [attached_mask] 连接到 [over]。"))
	if(!do_after(user, 5 SECONDS, over))
		return
	if(!over.equip_to_appropriate_slot(attached_mask))
		to_chat(user, span_warning("你无法将 [attached_mask] 连接到 [over]！"))
		return

	user.visible_message(span_warning("[user] 将 [attached_mask] 连接到 [over]。"), span_notice("你将 [attached_mask] 连接到 [over]。"))

	// Open the tank externally
	over.open_internals(attached_tank, is_external = TRUE)
	mask_out = TRUE
	START_PROCESSING(SSmachines, src)
	update_icon()

/obj/machinery/anesthetic_machine/process()
	if(!mask_out) // If not on someone, stop processing
		return PROCESS_KILL

	var/mob/living/carbon/carbon_target = attached_mask.loc
	if(get_dist(src, get_turf(attached_mask)) > 1) // If too far away, detach
		to_chat(carbon_target, span_warning("[attached_mask] 从你脸上被扯掉了！"))
		retract_mask()
		return PROCESS_KILL

	// Attempt to restart airflow if it was temporarily interrupted after mask adjustment.
	if(attached_tank && istype(carbon_target) && !carbon_target.external && !attached_mask.up)
		carbon_target.open_internals(attached_tank, is_external = TRUE)

/obj/machinery/anesthetic_machine/Destroy()
	if(mask_out)
		retract_mask()

	if(attached_tank)
		attached_tank.forceMove(loc)
		attached_tank = null

	QDEL_NULL(attached_mask)
	return ..()

/// This a special version of the breath mask used for the anesthetic machine.
/obj/item/clothing/mask/breath/anesthetic
	/// What machine is the mask currently attached to?
	var/datum/weakref/attached_machine

/obj/item/clothing/mask/breath/anesthetic/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, ABSTRACT_ITEM_TRAIT)

	// Make sure we are not spawning outside of a machine
	if(istype(loc, /obj/machinery/anesthetic_machine))
		attached_machine = WEAKREF(loc)

	var/obj/machinery/anesthetic_machine/our_machine
	if(attached_machine)
		our_machine = attached_machine.resolve()

	if(!our_machine)
		attached_machine = null
		if(mapload)
			stack_trace("Abstract, undroppable item [name] spawned at ([loc]) at [AREACOORD(src)] in \the [get_area(src)]. \
				Please remove it. This item should only ever be created by the anesthetic machine.")
		return INITIALIZE_HINT_QDEL

/obj/item/clothing/mask/breath/anesthetic/Destroy()
	attached_machine = null
	return ..()

/obj/item/clothing/mask/breath/anesthetic/dropped(mob/user)
	. = ..()

	if(isnull(attached_machine))
		return

	var/obj/machinery/anesthetic_machine/our_machine = attached_machine.resolve()
	// no machine, then delete it
	if(!our_machine)
		attached_machine = null
		qdel(src)
		return

	if(loc != our_machine) //If it isn't in the machine, then it retracts when dropped
		to_chat(user, span_notice("[src] 缩回了 [our_machine]。"))
		our_machine.retract_mask()

/obj/item/clothing/mask/breath/anesthetic/adjust_visor(mob/living/carbon/user)
	. = ..()
	// Air only goes through the mask, so temporarily pause airflow if mask is getting adjusted.
	// Since the mask is NODROP, the only possible user is the wearer
	var/mob/living/carbon/carbon_target = loc
	if(up && carbon_target.external)
		carbon_target.close_externals()

/// A boxed version of the Anesthetic Machine. This is what is printed from the medical prolathe.
/obj/item/anesthetic_machine_kit
	name = "麻醉支架零件套件"
	desc = "包含组装便携式麻醉支架所需的所有零件。在手中使用以进行组装。"
	w_class = WEIGHT_CLASS_BULKY
	icon = 'icons/obj/storage/box.dmi'
	icon_state = "plasticbox"

/obj/item/anesthetic_machine_kit/attack_self(mob/user)
	new /obj/machinery/anesthetic_machine(user.loc)

	playsound(get_turf(user), 'sound/items/weapons/circsawhit.ogg', 50, TRUE)
	qdel(src)
