// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
// It is a gizmo that flashes a small area

/obj/machinery/flasher
	name = "mounted flash"
	desc = "A wall-mounted flashbulb device."
	icon = 'icons/obj/wallmounts.dmi'
	icon_state = "mflash1"
	base_icon_state = "mflash"
	max_integrity = 250
	integrity_failure = 0.4
	damage_deflection = 10
	///The contained flash. Mostly just handles the bulb burning out & needing placement.
	var/obj/item/assembly/flash/handheld/bulb
	var/id = null
	/// How far this flash reaches. Affects both proximity distance and the actual stun effect.
	var/flash_range = 2 //this is roughly the size of a brig cell.

	/// How strong Paralyze()'d targets are when flashed.
	var/strength = 5 SECONDS

	COOLDOWN_DECLARE(flash_cooldown)
	/// Duration of time between flashes.
	var/flash_cooldown_duration = 15 SECONDS

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/flasher, 26)

/obj/machinery/flasher/Initialize(mapload)
	. = ..()
	if(mapload)
		bulb = new(src)
		find_and_mount_on_atom()

/obj/machinery/flasher/vv_edit_var(vname, vval)
	. = ..()
	if(vname == NAMEOF(src, flash_cooldown_duration) && (COOLDOWN_TIMELEFT(src, flash_cooldown) > flash_cooldown_duration))
		COOLDOWN_START(src, flash_cooldown, flash_cooldown_duration)

/obj/machinery/flasher/connect_to_shuttle(mapload, obj/docking_port/mobile/port, obj/docking_port/stationary/dock)
	id = "[port.shuttle_id]_[id]"

/obj/machinery/flasher/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	if(istype(arrived, /obj/item/assembly/flash/handheld))
		bulb = arrived
	return ..()

/obj/machinery/flasher/Exited(atom/movable/gone, direction)
	if(gone == bulb)
		bulb = null
	return ..()

/obj/machinery/flasher/Destroy()
	QDEL_NULL(bulb)
	return ..()

/obj/machinery/flasher/powered()
	if(!anchored || !bulb)
		return FALSE
	return ..()

/obj/machinery/flasher/update_icon_state()
	icon_state = "[base_icon_state]1[(bulb?.burnt_out || !powered()) ? "-p" : null]"
	return ..()

//Don't want to render prison breaks impossible
/obj/machinery/flasher/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	add_fingerprint(user)

	if (!istype(tool, /obj/item/assembly/flash/handheld))
		return NONE
	if (bulb)
		to_chat(user, span_warning(LANG("obj.d9edcff9b04441dd", list(src))))
		return ITEM_INTERACT_BLOCKING
	if(!user.transferItemToLoc(tool, src))
		return ITEM_INTERACT_BLOCKING
	user.visible_message(span_notice(LANG("obj.64a6a66a59aaec6c", list(user, tool, src))), \
						span_notice(LANG("obj.a0a1d9da7a47a97b", list(tool, src))))
	power_change()
	return ITEM_INTERACT_SUCCESS


/obj/machinery/flasher/wirecutter_act(mob/living/user, obj/item/tool)
	add_fingerprint(user)
	if(!bulb)
		return NONE
	user.visible_message(span_notice(LANG("obj.927df81db34334e1", list(user, src))), span_notice(LANG("obj.0620343f76520938", list(src))))
	if(!tool.use_tool(src, user, 30, volume=50) || !bulb)
		return ITEM_INTERACT_BLOCKING
	user.visible_message(span_notice(LANG("obj.c7b7ccaf80c3189b", list(user, src))), span_notice(LANG("obj.195778e3f5d8fab4", list(src))))
	bulb.forceMove(loc)
	power_change()
	return ITEM_INTERACT_SUCCESS

/obj/machinery/flasher/wrench_act(mob/living/user, obj/item/tool)
	add_fingerprint(user)
	if(bulb)
		to_chat(user, span_warning(LANG("obj.b06b88658e49cebb", list(src))))
		return ITEM_INTERACT_BLOCKING
	to_chat(user, span_notice(LANG("obj.ead0e0f7a2125e3c", null)))
	if(!tool.use_tool(src, user, 40, volume=50))
		return ITEM_INTERACT_BLOCKING
	to_chat(user, span_notice(LANG("obj.4b8870f08640678e", null)))
	deconstruct(TRUE)
	return ITEM_INTERACT_SUCCESS

//Let the AI trigger them directly.
/obj/machinery/flasher/attack_ai()
	if (anchored)
		return flash()

/obj/machinery/flasher/proc/flash()
	if (!powered() || !bulb)
		return

	if (bulb.burnt_out || !COOLDOWN_FINISHED(src, flash_cooldown))
		return

	if(!bulb.flash_recharge(30)) //Bulb can burn out if it's used too often too fast
		power_change()
		return

	playsound(src, 'sound/items/weapons/flash.ogg', 100, TRUE)
	flick("[base_icon_state]_flash", src)
	flash_lighting_fx()

	COOLDOWN_START(src, flash_cooldown, flash_cooldown_duration)
	use_energy(1 KILO JOULES)

	var/flashed = FALSE
	for(var/mob/living/living_mob in viewers(src, null))
		if (get_dist(src, living_mob) > flash_range)
			continue

		if(bulb.flash_mob(living_mob, confusion_duration = strength * 1.5, extra_log =  "by [src]"))
			living_mob.Paralyze(strength)
			flashed = TRUE

	if(flashed)
		bulb.times_used++

	return TRUE

/obj/machinery/flasher/emp_act(severity)
	. = ..()
	if(!(machine_stat & (BROKEN|NOPOWER)) && !(. & EMP_PROTECT_SELF))
		if(bulb && prob(75/severity))
			flash()
			bulb.burn_out()
			power_change()

/obj/machinery/flasher/atom_break(damage_flag)
	. = ..()
	if(. && bulb)
		bulb.burn_out()
		power_change()

/obj/machinery/flasher/on_deconstruction(disassembled)
	if(bulb)
		bulb.forceMove(loc)
	if(disassembled)
		var/obj/item/wallframe/flasher/flasher_obj = new(get_turf(src))
		transfer_fingerprints_to(flasher_obj)
		flasher_obj.id = id
		playsound(loc, 'sound/items/deconstruct.ogg', 50, TRUE)
	else
		new /obj/item/stack/sheet/iron (loc, 2)

/obj/machinery/flasher/portable //Portable version of the flasher. Only flashes when anchored
	name = "portable flasher"
	desc = "A portable flashing device. Wrench to activate and deactivate. Cannot detect slow movements."
	icon = 'icons/obj/machines/sec.dmi'
	icon_state = "pflash1-p"
	base_icon_state = "pflash"
	strength = 4 SECONDS
	anchored = FALSE
	density = TRUE
	///Proximity monitor associated with this atom, needed for proximity checks.
	var/datum/proximity_monitor/proximity_monitor

/obj/machinery/flasher/portable/Initialize(mapload)
	. = ..()
	proximity_monitor = new(src, 0)

/obj/machinery/flasher/portable/find_and_mount_on_atom(mark_for_late_init, late_init)
	return //its meant to be carried and mobile

/obj/machinery/flasher/portable/HasProximity(atom/movable/proximity_check_mob)
	if(!COOLDOWN_FINISHED(src, flash_cooldown))
		return

	if(!isliving(proximity_check_mob))
		return

	var/mob/living/proximity_living = proximity_check_mob
	if (proximity_living.move_intent != MOVE_INTENT_WALK && anchored)
		flash()

/obj/machinery/flasher/portable/vv_edit_var(vname, vval)
	. = ..()
	if(vname == NAMEOF(src, flash_range))
		proximity_monitor?.set_range(flash_range)

/obj/machinery/flasher/portable/wrench_act(mob/living/user, obj/item/tool)
	tool.play_tool_sound(src, 100)
	if (!anchored && !isinspace())
		to_chat(user, span_notice(LANG("obj.99e806e93720df10", list(src))))
		add_overlay("[base_icon_state]-s")
		set_anchored(TRUE)
		power_change()
		proximity_monitor.set_range(flash_range)
		return ITEM_INTERACT_SUCCESS

	to_chat(user, span_notice(LANG("obj.37738ee6a9b0be8f", list(src))))
	cut_overlays()
	set_anchored(FALSE)
	power_change()
	proximity_monitor.set_range(0)
	return ITEM_INTERACT_SUCCESS

/obj/item/wallframe/flasher
	name = "mounted flash frame"
	desc = "Used for building wall-mounted flashers."
	icon = 'icons/obj/wallmounts.dmi'
	icon_state = "mflash_frame"
	result_path = /obj/machinery/flasher
	var/id = null
	pixel_shift = 28

/obj/item/wallframe/flasher/examine(mob/user)
	. = ..()
	. += span_notice(LANG("obj.7150d501b36712cd", list(id)))

/obj/item/wallframe/flasher/after_attach(obj/attached_to)
	..()
	var/obj/machinery/flasher/flasher_obj = attached_to
	flasher_obj.id = id
