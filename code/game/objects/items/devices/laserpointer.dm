// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/item/laser_pointer
	name = "laser pointer"
	desc = "Don't shine it in your eyes!"
	icon = 'icons/obj/service/bureaucracy.dmi'
	icon_state = "pointer"
	inhand_icon_state = "pen"
	worn_icon_state = "pen"
	obj_flags = CONDUCTS_ELECTRICITY
	item_flags = NOBLUDGEON
	slot_flags = ITEM_SLOT_BELT
	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 5, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 5)
	w_class = WEIGHT_CLASS_SMALL
	///Currently stored blulespace crystal, if any. Required to use the pointer through walls
	var/obj/item/stack/ore/bluespace_crystal/crystal_lens
	///Currently stored micro-laser diode
	var/obj/item/stock_parts/micro_laser/diode
	///Chance that the pointer dot will trigger a reaction from a mob/object
	var/effectchance = 30
	///Currently available battery charge of the laser pointer
	var/energy = 10
	///Maximum possible battery charge of the laser. Draining the battery puts the pointer in a recharge state, preventing use, which ends upon full recharge
	var/max_energy = 10
	///Maximum use range
	var/max_range = 7
	///Icon for the laser, affects both the laser dot and the laser pointer itself, as it shines a laser on the item itself
	var/pointer_icon_state = null
	///Whether the pointer is currently in a full recharge state. Triggered upon fully draining the battery
	var/recharge_locked = FALSE
	///Whether the pointer is currently recharging or not
	var/recharging = FALSE

/obj/item/laser_pointer/red
	pointer_icon_state = "red_laser"

/obj/item/laser_pointer/green
	pointer_icon_state = "green_laser"

/obj/item/laser_pointer/blue
	pointer_icon_state = "blue_laser"

/obj/item/laser_pointer/purple
	pointer_icon_state = "purple_laser"

/obj/item/laser_pointer/Initialize(mapload)
	. = ..()
	diode = new(src)
	if(!pointer_icon_state)
		pointer_icon_state = pick("red_laser", "green_laser", "blue_laser", "purple_laser")

/obj/item/laser_pointer/Destroy(force)
	QDEL_NULL(crystal_lens)
	QDEL_NULL(diode)
	return ..()

/obj/item/laser_pointer/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == crystal_lens)
		crystal_lens = null
	if(gone == diode)
		diode = null

/obj/item/laser_pointer/upgraded/Initialize(mapload)
	. = ..()
	diode = new /obj/item/stock_parts/micro_laser/ultra

/obj/item/laser_pointer/infinite_range
	name = "infinite laser pointer"
	desc = "Used to shine in the eyes of Cyborgs who need a bit of a push, this works through camera consoles."
	max_range = INFINITY

/obj/item/laser_pointer/infinite_range/Initialize(mapload)
	. = ..()
	diode = new /obj/item/stock_parts/micro_laser/quadultra

/obj/item/laser_pointer/screwdriver_act(mob/living/user, obj/item/tool)
	if(diode)
		tool.play_tool_sound(src)
		balloon_alert(user, LANG("obj.540a04af", null))
		diode.forceMove(drop_location())
		diode = null
		return TRUE

/obj/item/laser_pointer/tool_act(mob/living/user, obj/item/tool, list/modifiers)
	if(isnull(crystal_lens))
		return ..()
	if(tool_behaviour != TOOL_WIRECUTTER && tool_behaviour != TOOL_HEMOSTAT)
		return ..()
	tool.play_tool_sound(src)
	balloon_alert(user, LANG("obj.3cc7f257", null))
	crystal_lens.forceMove(drop_location())
	crystal_lens = null
	return ITEM_INTERACT_SUCCESS

/obj/item/laser_pointer/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/stock_parts/micro_laser))
		if(diode)
			balloon_alert(user, LANG("obj.f6b014fc", null))
			return ITEM_INTERACT_BLOCKING
		var/obj/item/stock_parts/attack_diode = tool
		if(crystal_lens && attack_diode.rating < 3) //only tier 3 and up are small enough to fit
			to_chat(user, span_warning(LANG("obj.2a58b15f", list(tool.name, crystal_lens.name))))
			playsound(src, 'sound/machines/airlock/airlock_alien_prying.ogg', 20)
			if(!do_after(user, 2 SECONDS, src))
				return ITEM_INTERACT_BLOCKING
			var/atom/atom_to_teleport = pick(user, tool)
			if(atom_to_teleport == user)
				to_chat(user, span_warning(LANG("obj.63122a79", list(tool.name, crystal_lens.name))))
				user.drop_all_held_items()
			else if(atom_to_teleport == tool)
				tool.forceMove(drop_location())
				to_chat(user, span_warning(LANG("obj.8c66fb60", list(tool.name, crystal_lens.name, tool.name))))
			do_teleport(atom_to_teleport, get_turf(src), crystal_lens.blink_range, asoundin = 'sound/effects/phasein.ogg', channel = TELEPORT_CHANNEL_BLUESPACE)
			qdel(crystal_lens)
			return ITEM_INTERACT_SUCCESS
		if(!user.transferItemToLoc(tool, src))
			return ITEM_INTERACT_BLOCKING
		playsound(src, 'sound/items/tools/screwdriver.ogg', 30)
		diode = tool
		balloon_alert(user, LANG("obj.ddc17aca", list(diode.name)))
		//we have a diode now, try starting a charge sequence in case the pointer was charging when we took out the diode
		recharging = TRUE
		START_PROCESSING(SSobj, src)
		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/stack/ore/bluespace_crystal))
		if(crystal_lens)
			balloon_alert(user, LANG("obj.a9a84fa7", null))
			return ITEM_INTERACT_BLOCKING
		//the crystal stack we're trying to install a crystal from
		var/obj/item/stack/ore/bluespace_crystal/crystal_stack = tool
		if(diode && diode.rating < 3) //only lasers of tier 3 and up can house a lens
			to_chat(user, span_warning(LANG("obj.c201306e", list(crystal_stack.name))))
			playsound(src, 'sound/machines/airlock/airlock_alien_prying.ogg', 20)
			if(!do_after(user, 2 SECONDS, src))
				return ITEM_INTERACT_BLOCKING
			var/atom/atom_to_teleport = pick(user, src)
			if(atom_to_teleport == user)
				to_chat(user, span_warning(LANG("obj.54dc680f", list(crystal_stack.name))))
				user.drop_all_held_items()
			else if(atom_to_teleport == src)
				forceMove(drop_location())
				to_chat(user, span_warning(LANG("obj.8be0c990", list(crystal_stack.name, src))))
			do_teleport(atom_to_teleport, get_turf(src), crystal_stack.blink_range, asoundin = 'sound/effects/phasein.ogg', channel = TELEPORT_CHANNEL_BLUESPACE)
			crystal_stack.use_tool(src, user, amount = 1) //use only one if we were installing from a stack of crystals
			return ITEM_INTERACT_SUCCESS
		//the single crystal that we actually install
		var/obj/item/stack/ore/bluespace_crystal/single_crystal = crystal_stack.split_stack(1)
		if(isnull(single_crystal))
			return ITEM_INTERACT_BLOCKING
		single_crystal.forceMove(src)
		crystal_lens = single_crystal
		playsound(src, 'sound/items/tools/screwdriver2.ogg', 30)
		balloon_alert(user, LANG("obj.ddc17aca", list(crystal_lens.name)))
		to_chat(user, span_notice(LANG("obj.71d1e6f9", list(crystal_lens.name, src))))
		return ITEM_INTERACT_SUCCESS

	return NONE

/obj/item/laser_pointer/examine(mob/user)
	. = ..()
	if(in_range(user, src) || isobserver(user))
		if(isnull(diode))
			. += span_notice(LANG("obj.9ef6aa29", null))
		else
			. += span_notice(LANG("obj.f599396e", list(diode.rating)))
		. += span_notice(LANG("obj.eacd34d8", list(recharge_locked ? " it is currently recharging to full, and" : "", energy * 10)))
		if(crystal_lens)
			. += span_notice(LANG("obj.aa422979", list(crystal_lens.name)))
		else if(diode) //hint at the ability to modify the pointer with a crystal only if we have a diode
			. += span_notice(LANG("obj.e0861086", null))

/obj/item/laser_pointer/examine_more(mob/user)
	. = ..()
	if(!isnull(crystal_lens) || isnull(diode))
		return
	switch(diode.rating)
		if(1)
			. += LANG("obj.9ed0fe28", list(diode.name))
		if(2)
			. += LANG("obj.5c980240", list(diode.name))
		if(3 to 4)
			. += LANG("obj.3b48a208", list(diode.name))

/obj/item/laser_pointer/ranged_interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	laser_act(interacting_with, user, modifiers)
	return ITEM_INTERACT_BLOCKING

/obj/item/laser_pointer/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(HAS_TRAIT(interacting_with, TRAIT_COMBAT_MODE_SKIP_INTERACTION))
		return NONE
	return ranged_interact_with_atom(interacting_with, user, modifiers)

///Handles shining the clicked atom,
/obj/item/laser_pointer/proc/laser_act(atom/target, mob/living/user, list/modifiers)
	if(isnull(diode))
		to_chat(user, span_notice(LANG("obj.45bb2b42", list(src, target))))
		return
	if(!ISADVANCEDTOOLUSER(user))
		to_chat(user, span_warning(LANG("obj.e8ba50af", null)))
		return
	if(HAS_TRAIT(user, TRAIT_CHUNKYFINGERS))
		to_chat(user, span_warning(LANG("obj.56e539bb", null)))
		return

	if(max_range != INFINITY)
		if(!IN_GIVEN_RANGE(target, user, max_range))
			to_chat(user, span_warning(LANG("obj.4b15eda2", list(target))))
			return
		if(!(user in (view(max_range, target)))) //check if we are visible from the target's PoV
			if(isnull(crystal_lens))
				to_chat(user, span_warning(LANG("obj.8e7ecb26", list(src))))
				return
			if(!((user.sight & SEE_OBJS) || (user.sight & SEE_MOBS))) //only let it work if we have xray or thermals. mesons don't count because they are easier to get.
				to_chat(user, span_notice(LANG("obj.7208ccd3", null)))
				return

	add_fingerprint(user)

	//nothing happens if the battery has been drained and has not fully recharged yet
	if(recharge_locked)
		to_chat(user, span_notice(LANG("obj.106ee956", list(src, target))))
		return

	//The message we send to the user upon using the pointer
	var/outmsg
	//The turf of the target we clicked on
	var/turf/targloc = get_turf(target)

	//human/alien mobs: if we aim for the eyes, chance to flash the target
	if(iscarbon(target))
		var/mob/living/carbon/target_humanoid = target
		if(target_humanoid.stat == DEAD)
			outmsg = span_notice("You point [src] at [target_humanoid], but [target_humanoid.p_they()] appear[target_humanoid.p_s()] to be dead!")
		else if(user.zone_selected == BODY_ZONE_PRECISE_EYES)
			//Intensity of the laser dot to pass to flash_act
			var/severity = pick(0, 1, 2)
			var/always_fail = FALSE
			if(istype(target_humanoid.get_item_by_slot(ITEM_SLOT_EYES), /obj/item/clothing/glasses/eyepatch) && prob(50))
				always_fail = TRUE

			//chance to actually hit the eyes depends on internal component
			if(prob(effectchance * diode.rating) && !always_fail && target_humanoid.flash_act(severity))
				outmsg = span_notice("You blind [target_humanoid] by shining [src] in [target_humanoid.p_their()] eyes.")
				log_combat(user, target_humanoid, "blinded with a laser pointer", src)
			else
				outmsg = span_warning("You fail to blind [target_humanoid] by shining [src] at [target_humanoid.p_their()] eyes!")
				log_combat(user, target_humanoid, "attempted to blind with a laser pointer", src)

	//borgs: chance to flash and paralyse the target
	else if(iscyborg(target))
		var/mob/living/silicon/target_sillycone = target
		//chance to actually hit the eyes depends on internal component
		if(target_sillycone.stat == DEAD)
			outmsg = span_notice("You point [src] at [target_sillycone], but [target_sillycone.p_they()] appear[target_sillycone.p_s()] to be non-functioning.")
		if(prob(effectchance * diode.rating) && target_sillycone.flash_act(affect_silicon = TRUE))
			target_sillycone.set_temp_blindness_if_lower(5 SECONDS)
			to_chat(target_sillycone, span_danger(LANG("obj.3eb4dac4", null)))
			outmsg = span_notice("You overload [target_sillycone] by shining [src] at [target_sillycone.p_their()] sensors.")
			log_combat(user, target_sillycone, "shone in the sensors", src)
		else
			outmsg = span_warning("You fail to overload [target_sillycone] by shining [src] at [target_sillycone.p_their()] sensors!")
			log_combat(user, target_sillycone, "attempted to shine in the sensors", src)

	//cameras: chance to EMP the camera
	else if(istype(target, /obj/machinery/camera))
		var/obj/machinery/camera/target_camera = target
		if(!target_camera.camera_enabled && !target_camera.emped)
			outmsg = span_notice("You point [src] at [target_camera], but it seems to be disabled.")
		else if(prob(effectchance * diode.rating))
			target_camera.emp_act(EMP_HEAVY)
			outmsg = span_notice("You hit the lens of [target_camera] with [src], temporarily disabling the camera!")
			log_combat(user, target_camera, "EMPed", src)
		else
			outmsg = span_warning("You miss the lens of [target_camera] with [src]!")

	//catpeople: make any felinid near the target to face the target, chance for felinids to pounce at the light, stepping to the target
	for(var/mob/living/carbon/human/target_felinid in view(1, targloc))
		if(!isfeline(target_felinid) || target_felinid.stat == DEAD || target_felinid.is_blind() || target_felinid.incapacitated) // NOVA EDIT CHANGE - FELINE TRAITS - ORIGINAL: if(!isfelinID(target_felinid) || target_felinid.stat == DEAD || target_felinid.is_blind() || target_felinid.incapacitated)
			continue
		if(target_felinid.body_position == STANDING_UP)
			target_felinid.setDir(get_dir(target_felinid, targloc)) // kitty always looks at the light
			//NOVA EDIT REMOVAL BEGIN (removes forced felinid movement from laserpointers, also fixes the longstanding windoor negation glitch)
			/* if(prob(effectchance * diode.rating))
				target_felinid.visible_message(span_warning("[target_felinid] makes a grab for the light!"), span_userdanger("LIGHT!"))
				target_felinid.Move(targloc, get_dir(target_felinid, targloc))
				log_combat(user, target_felinid, "moved with a laser pointer", src)
			else
			NOVA EDIT REMOVAL END */
			target_felinid.visible_message(span_notice(LANG("obj.89766f76", list(target_felinid))), span_warning(LANG("obj.958edba3", null))) //NOVA EDIT CHANGE : indent this block if re-enabling above
		else
			target_felinid.visible_message(span_notice(LANG("obj.22e5e7c7", list(target_felinid))), span_warning(LANG("obj.dda3d809", null)))
	//The pointer is shining, change its sprite to show
	icon_state = "pointer_[pointer_icon_state]"

	//setup pointer blip
	var/mutable_appearance/laser = mutable_appearance('icons/obj/weapons/guns/projectiles.dmi', pointer_icon_state)
	if(modifiers)
		if(LAZYACCESS(modifiers, ICON_X))
			laser.pixel_w = (text2num(LAZYACCESS(modifiers, ICON_X)) - 16)
		if(LAZYACCESS(modifiers, ICON_Y))
			laser.pixel_z = (text2num(LAZYACCESS(modifiers, ICON_Y)) - 16)
	else
		laser.pixel_w = target.pixel_w + rand(-5,5)
		laser.pixel_z = target.pixel_z + rand(-5,5)

	if(outmsg)
		user.visible_message(span_danger(LANG("obj.59c3217a", list(user, src, target))), outmsg) //NOVA EDIT CHANGE - ORIGINAL: to_chat(user, outmsg)
	else
		user.visible_message(span_notice(LANG("obj.8a67c495", list(user, src, target))), span_notice(LANG("obj.e0067749", list(src, target)))) //NOVA EDIT CHANGE - ORIGINAL: to_chat(user, span_info("You point [src] at [target]."))

	//we have successfully shone our pointer, reduce our battery depending on whether we have an extra lens or not
	energy -= crystal_lens ? 2 : 1
	if(energy <= max_energy) //normal recharge, does not stop us from using the pointer
		if(!recharging)
			recharging = TRUE
			START_PROCESSING(SSobj, src)
		if(energy <= 0) //battery is completely dry, recharge the pointer to full then let us use it again
			to_chat(user, span_warning(LANG("obj.551ebbba", list(src))))
			recharge_locked = TRUE

	//flash a pointer blip at the target
	target.flick_overlay_view(laser, 1 SECONDS)
	//reset pointer sprite
	icon_state = "pointer"

/obj/item/laser_pointer/process(seconds_per_tick)
	if(isnull(diode))
		recharging = FALSE
		return PROCESS_KILL
	if(SPT_PROB(10 + diode.rating * 10, seconds_per_tick)) //+10% chance per diode tier to recharge one use per process
		energy += 1
		if(energy >= max_energy)
			energy = max_energy
			recharging = FALSE
			recharge_locked = FALSE
			return ..()
