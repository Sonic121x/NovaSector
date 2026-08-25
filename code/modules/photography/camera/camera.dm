// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/item/camera
	name = "camera"
	icon = 'icons/obj/art/camera.dmi'
	desc = "A polaroid camera."
	icon_state = "camera"
	base_icon_state = "camera"
	inhand_icon_state = "camera"
	worn_icon_state = "camera"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	light_system = NONE
	light_range = 6
	light_color = COLOR_WHITE
	light_power = FLASH_LIGHT_POWER
	light_on = FALSE
	w_class = WEIGHT_CLASS_SMALL
	obj_flags = CONDUCTS_ELECTRICITY
	slot_flags = ITEM_SLOT_NECK
	custom_materials = list(/datum/material/glass = SMALL_MATERIAL_AMOUNT, /datum/material/iron = SMALL_MATERIAL_AMOUNT * 0.5)
	custom_price = PAYCHECK_CREW * 2

	/// Cooldown before we can take another picture.
	var/cooldown = 6.4 SECONDS
	/// Whether we are currently ready to take a picture.
	var/on = TRUE
	/// Whether we are still processing an image.
	var/blending = FALSE
	/// The maximum amount of pictures we can take before needing new film.
	var/pictures_max = 10
	/// The amount of pictures we can still take before needing new film.
	var/pictures_left = 10
	/// Currently inserted holorecord disk.
	var/obj/item/disk/holodisk/disk
	///Boolean on whether or not the camera will print in monochrome.
	var/print_monochrome = FALSE
	/// Whether we flash upon taking a picture.
	var/flash_enabled = TRUE
	/// Whether we silence our picture taking and zoom adjusting sounds.
	var/silent = FALSE
	/// To what degree ghosts are visible in our pictures.
	var/see_ghosts = CAMERA_NO_GHOSTS
	/// Whether the camera should print pictures immediately when a picture is taken.
	var/print_picture_on_snap = TRUE
	/// Whether we allow setting picture label/desc/scribble when a picture is taken.
	var/can_customise = TRUE
	/// Picture name we default to when none is set manually.
	var/default_picture_name
	///Width of the picture
	var/picture_size_x = 2
	///height of the picture
	var/picture_size_y = 2
	///Internal holder to apply camera light on
	VAR_PRIVATE/atom/movable/light_holder

/// Special type of component so it does not intefer with the modular computer default lighting system if any
/datum/component/overlay_lighting/camera
	dupe_mode = COMPONENT_DUPE_SOURCES

/obj/item/camera/Initialize(mapload)
	. = ..()

	//we do this so if this camera is used as an internal component, the flash will still be visible
	if(flash_enabled)
		var/atom/movable/parent = loc
		light_holder = src
		while(!(isnull(parent) || ismob(parent) || isturf(parent)))
			light_holder = parent
			parent = light_holder.loc
		light_holder.AddComponentFrom(REF(src), /datum/component/overlay_lighting/camera, light_range, light_power, light_color, FALSE, TRUE, FALSE, TRUE)

	AddComponent(/datum/component/shell, list(new /obj/item/circuit_component/camera, new /obj/item/circuit_component/remotecam/polaroid), SHELL_CAPACITY_SMALL)
	register_context()

/obj/item/camera/Destroy(force)
	if(light_holder)
		light_holder.RemoveComponentSource(REF(src), /datum/component/overlay_lighting/camera)
		light_holder = null
	return ..()

/obj/item/camera/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	context[SCREENTIP_CONTEXT_ALT_LMB] = "Adjust Zoom"
	context[SCREENTIP_CONTEXT_CTRL_LMB] = "Change Printer Mode"

	if(istype(held_item, /obj/item/camera_film))
		context[SCREENTIP_CONTEXT_LMB] = "Insert Film"
		return CONTEXTUAL_SCREENTIP_SET

	if(istype(held_item, /obj/item/disk/holodisk))
		context[SCREENTIP_CONTEXT_LMB] = disk ? "Swap Disks" : "Insert Disk"
		return CONTEXTUAL_SCREENTIP_SET

	if((isnull(held_item) || (held_item == src)) && disk)
		context[SCREENTIP_CONTEXT_LMB] = "Eject Disk"
		return CONTEXTUAL_SCREENTIP_SET

	return CONTEXTUAL_SCREENTIP_SET

/obj/item/camera/examine(mob/user)
	. = ..()
	. += span_notice(LANG("obj.54bf8bd7c27b8514", list(pictures_left)))
	. += span_notice(LANG("obj.0cb0bf3769351499", null))
	. += span_notice(LANG("obj.102d70c20fb5df60", null))
	. += span_notice(LANG("obj.a4b44f366f83f0ba", list(EXAMINE_HINT("[APERTURE_TO_METERS(picture_size_x)]x[APERTURE_TO_METERS(picture_size_y)]"))))

	if(isnull(disk))
		. += span_notice(LANG("obj.5d8d1bda0b34ed83", null))
	else
		. += span_notice(LANG("obj.256c289c5c7604c3", list(disk.name)))

/obj/item/camera/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == disk)
		disk = null

/**
 * Adjusts the zoom of this camera
 * Arguments
 *
 * * desired_x - the x zoom value to use
 * * desired_y - the y zoom value to use
 * * mob/user - the optional user who is taking the photo. Passing the mob will ask for input and ignore the above params
*/
/obj/item/camera/proc/adjust_zoom(desired_x = picture_size_x, desired_y = picture_size_y, mob/user)
	SHOULD_NOT_OVERRIDE(TRUE)

	if(user)
		if(loc != user)
			to_chat(user, span_warning(LANG("obj.df42aeedbe20ad56", null)))
			return FALSE
		desired_x = tgui_input_number(user, LANG("obj.507e9348da020135", null), LANG("obj.83e3de03bec38ef8", null), picture_size_x, CAMERA_PICTURE_SIZE_HARD_LIMIT, 1)
		if(!desired_x || QDELETED(user) || QDELETED(src) || !user.can_perform_action(src, FORBID_TELEKINESIS_REACH|ALLOW_PAI) || loc != user)
			return FALSE
		desired_y = tgui_input_number(user, LANG("obj.2161e974d1461d7f", null), LANG("obj.83e3de03bec38ef8", null), picture_size_y, CAMERA_PICTURE_SIZE_HARD_LIMIT, 1)
		if(!desired_y || QDELETED(user) || QDELETED(src) || !user.can_perform_action(src, FORBID_TELEKINESIS_REACH|ALLOW_PAI) || loc != user)
			return FALSE

	picture_size_x = clamp(desired_x, 1, CAMERA_PICTURE_SIZE_HARD_LIMIT)
	picture_size_y = clamp(desired_y, 1, CAMERA_PICTURE_SIZE_HARD_LIMIT)

	if(user)
		to_chat(user, span_notice(LANG("obj.58b72f200d1f7b6e", list(EXAMINE_HINT("[APERTURE_TO_METERS(picture_size_x)]x[APERTURE_TO_METERS(picture_size_y)]")))))

	return TRUE

/// Resets flash to be used again
/obj/item/camera/proc/cooldown()
	PRIVATE_PROC(TRUE)

	UNTIL(!blending)
	icon_state = base_icon_state
	on = TRUE

/// Turns the light/flash off
/obj/item/camera/proc/flash_end()
	PRIVATE_PROC(TRUE)

	light_holder.set_light_on(FALSE)

/**
 * Turns the flash quickly on and off when picture is taken
 * Arguments
 *
 * * atom/target - the target we are trying to take a photo of
 * * mob/user - the optional user who is taking the photo
*/
/obj/item/camera/proc/on_flash(atom/target, mob/user)
	PROTECTED_PROC(TRUE)
	SHOULD_CALL_PARENT(TRUE)

	on = FALSE
	addtimer(CALLBACK(src, PROC_REF(cooldown)), cooldown)
	icon_state = "[base_icon_state]_off"
	if(flash_enabled)
		light_holder.set_light_on(TRUE)
		addtimer(CALLBACK(src, PROC_REF(flash_end)), FLASH_LIGHT_DURATION, TIMER_OVERRIDE|TIMER_UNIQUE)

/**
 * Steal souls from all mobs captured in the image
 * Arguments
 *
 * * list/victims - list of all mobs captured in the image
*/
/obj/item/camera/proc/steal_souls(list/mob/victims)
	PROTECTED_PROC(TRUE)

	return

/**
 * Attempts to take an image of the target and all its surrounding tiles
 * Returns TRUE if it successfully starts taking a picture.
 * Arguments
 *
 * * atom/target - the target we are trying to take a photo of
 * * mob/user - the optional user who is taking the photo
*/
/obj/item/camera/proc/attempt_picture(atom/target, mob/user)
	SHOULD_NOT_OVERRIDE(TRUE)

	if(!on)
		if(user)
			user.balloon_alert(user, LANG("obj.a9061853897e2ae3", null))
		return FALSE

	if(blending)
		if(user)
			user.balloon_alert(user, LANG("obj.91acb640d5b65a4f", null))
		return FALSE

	blending = TRUE
	INVOKE_ASYNC(src, PROC_REF(capture_image), target, user)
	return TRUE

/**
 * Renders an image of the target and all its surrounding tiles
 * Arguments passed from attempt_picture()
*/
/obj/item/camera/proc/capture_image(atom/target, mob/user)
	PRIVATE_PROC(TRUE)
	//Checking if we can target
	var/turf/target_turf = get_turf(target)
	var/view_size = user?.client?.view || world.view
	if(isnull(target_turf))
		blending = FALSE
		return
	if(isAI(user))
		if(!SScameras.is_visible_by_cameras(target_turf))
			blending = FALSE
			return
	else if(!(target_turf in view(view_size, user)))
		blending = FALSE
		return

	//These vars will be reused later on
	var/size_x = picture_size_x - 1
	var/size_y = picture_size_y - 1
	var/list/viewlist = getviewsize(view_size)
	var/view_range = max(viewlist[1], viewlist[2]) + max(size_x, size_y)
	var/viewer = get_turf(user?.client?.eye || user)
	var/list/seen = get_hear_turfs(view_range, viewer)
	if(!(target_turf in seen))
		blending = FALSE
		return

	//taking the actual picture
	on_flash(target, user)
	var/list/mobs_spotted = list()
	var/list/dead_spotted = list()
	var/list/turfs = list()
	var/list/mobs = list()
	var/blueprints = FALSE
	var/width = APERTURE_TO_METERS(picture_size_x)
	var/height = APERTURE_TO_METERS(picture_size_y)
	///list of human names taken on picture
	var/list/names = list()
	var/cameranet_user = isAI(user) || istype(viewer, /mob/eye/camera)
	var/datum/turf_reservation/clone_area = SSmapping.request_turf_block_reservation(width, height, 1)
	for(var/turf/seen_placeholder as anything in CORNER_BLOCK_OFFSET(target_turf, width, height, -size_x, -size_y))
		if(isnull(seen_placeholder))
			continue
		if(cameranet_user && !SScameras.is_visible_by_cameras(seen_placeholder))
			continue
		if(!cameranet_user && !(seen_placeholder in seen))
			continue

		//Multi-z photography
		var/turf/target_placeholder = seen_placeholder
		while(!isnull(target_placeholder))
			turfs += target_placeholder
			for(var/mob/mob_there in target_placeholder)
				mobs += mob_there
			if(locate(/obj/item/blueprints) in target_placeholder)
				blueprints = TRUE

			if(isopenspaceturf(target_placeholder) || istype(target_placeholder, /turf/open/floor/glass))
				target_placeholder = GET_TURF_BELOW(target_placeholder)
			else
				break

	// do this before picture is taken so we can reveal revenants for the photo
	steal_souls(mobs)

	var/list/desc = list("This is a photo of an area of [width] meters by [height] meters.")
	for(var/mob/mob as anything in mobs)
		mobs_spotted += mob
		if(mob.stat == DEAD)
			dead_spotted += mob
		var/info = mob.get_photo_description(src)
		if(!isnull(info))
			desc += info

	var/icon/get_icon = camera_get_icon(turfs, target_turf, clone_area)
	get_icon.Blend("#000", ICON_UNDERLAY)
	qdel(clone_area)
	for(var/mob/living/carbon/human/person in mobs)
		if(person.obscured_slots & HIDEFACE)
			continue
		names += "[person.name]"

	var/datum/picture/picture = new(
		"picture",
		desc.Join("<br>"),
		mobs_spotted,
		dead_spotted,
		names,
		get_icon,
		null,
		width * ICON_SIZE_X,
		height * ICON_SIZE_Y,
		blueprints,
		can_see_ghosts = see_ghosts,
	)
	after_picture(user, picture)
	SEND_SIGNAL(src, COMSIG_CAMERA_IMAGE_CAPTURED, target, user, picture)
	blending = FALSE

/**
 * Action to take after the picture is taken
 *
 * Arguments
 *
 * * mob/user - the user who took the picture
 * * datum/picture/picture - the picture taken
*/
/obj/item/camera/proc/after_picture(mob/user, datum/picture/picture)
	PROTECTED_PROC(TRUE)

	if(silent)
		user.playsound_local(get_turf(src), SFX_POLAROID, 35, TRUE)
	else
		playsound(loc, SFX_POLAROID, 75, TRUE, -3)

	if(print_picture_on_snap)
		printpicture(user, picture)

/**
 * Print the picture tkane on film
 *
 * Arguments
 *
 * * mob/user - the user who took the picture
 * * datum/picture/picture - the picture taken
*/
/obj/item/camera/proc/printpicture(mob/user, datum/picture/picture)
	SHOULD_NOT_OVERRIDE(TRUE)

	var/obj/item/photo/new_photo
	if(user)
		if(!pictures_left)
			to_chat(user, span_warning(LANG("obj.858446e3852d81a1", null)))
			return

		new_photo = new(src, picture)

		to_chat(user, span_notice(LANG("obj.528b828628dd83d8", list(pictures_left))))

		var/name_customized = FALSE
		if(can_customise)
			var/customise = tgui_alert(user, LANG("obj.dd7d7cb0c32e02fc", null), LANG("obj.61e3a16f20d83e5c", null), list("Yes", "No"))
			if(customise == "Yes")
				var/name1 = tgui_input_text(user, LANG("obj.438188aa7d21d473", null), LANG("obj.e81360eaaea292c0", null), max_length = 32)
				var/desc1 = tgui_input_text(user, LANG("obj.4bdb2db7053671ec", null), LANG("obj.495197c1be2f241d", null), max_length = 128)
				var/caption = tgui_input_text(user, LANG("obj.25ccccebe2eb49e5", null), LANG("obj.bc4266636e4892be", null), max_length = 256)
				if(name1)
					picture.picture_name = name1
					name_customized = TRUE
				if(desc1)
					picture.picture_desc = "[desc1] - [picture.picture_desc]"
				if(caption)
					picture.caption = caption
		if(!name_customized && default_picture_name)
			picture.picture_name = default_picture_name

	else if(isliving(loc))
		var/mob/living/holder = loc

		if(!pictures_left)
			to_chat(holder, span_warning(LANG("obj.858446e3852d81a1", null)))
			return

		new_photo = new(get_turf(src), picture)

		to_chat(holder, span_notice(LANG("obj.528b828628dd83d8", list(pictures_left))))

	new_photo.set_picture(picture, TRUE, TRUE)
	if(CONFIG_GET(flag/picture_logging_camera))
		picture.log_to_file()

	pictures_left--

	user.put_in_hands(new_photo)

/obj/item/camera/attack_self(mob/user)
	if(isnull(disk))
		return
	playsound(src, 'sound/machines/card_slide.ogg', 50)
	user.put_in_hands(disk)
	disk = null

/obj/item/camera/attack(mob/living/carbon/human/M, mob/user)
	return

/obj/item/camera/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/camera_film))
		if(pictures_left)
			balloon_alert(user, LANG("obj.95dd4470b0297c1e", null))
			return ITEM_INTERACT_BLOCKING
		if(!user.temporarilyRemoveItemFromInventory(tool))
			return ITEM_INTERACT_BLOCKING
		playsound(src, 'sound/machines/click.ogg', 50, TRUE)
		qdel(tool)
		pictures_left = pictures_max
		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/disk/holodisk))
		if(!user.transferItemToLoc(tool, src))
			balloon_alert(user, LANG("obj.c7cbf2eb61d75d5b", null))
			return TRUE
		if(disk)
			user.put_in_hands(disk)
			balloon_alert(user, LANG("obj.6fefc5af0b0d0233", null))
		else
			balloon_alert(user, LANG("obj.8c1b1c9813930aa6", null))
		playsound(src, 'sound/machines/card_slide.ogg', 50)
		disk = tool
		return ITEM_INTERACT_SUCCESS

/obj/item/camera/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(HAS_TRAIT(interacting_with, TRAIT_COMBAT_MODE_SKIP_INTERACTION))
		return NONE
	return ranged_interact_with_atom(interacting_with, user, modifiers)

/obj/item/camera/ranged_interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(disk)
		if(!ismob(interacting_with))
			to_chat(user, span_warning(LANG("obj.8f2ab71df7f5f878", null)))
			return ITEM_INTERACT_BLOCKING
		if(disk.record)
			QDEL_NULL(disk.record)

		disk.record = new
		var/mob/recorded_mob = interacting_with
		disk.record.caller_name = recorded_mob.name
		disk.record.set_caller_image(recorded_mob)

	attempt_picture(interacting_with, user)
	return ITEM_INTERACT_SUCCESS

/obj/item/camera/click_alt(mob/user)
	if(!adjust_zoom(user = user))
		return CLICK_ACTION_BLOCKING
	if(silent) // Don't out your silent cameras
		user.playsound_local(get_turf(src), 'sound/machines/click.ogg', 50, TRUE)
	else
		playsound(src, 'sound/machines/click.ogg', 50, TRUE)
	return CLICK_ACTION_SUCCESS

/obj/item/camera/item_ctrl_click(mob/user)
	print_monochrome = !print_monochrome
	user.balloon_alert(user, LANG("obj.94bde98cb30861b8", list(print_monochrome ? "monochrome" : "in color")))
	if(silent) // Don't out your silent cameras
		user.playsound_local(get_turf(src), 'sound/machines/click.ogg', 50, TRUE)
	else
		playsound(src, 'sound/machines/click.ogg', 50, TRUE)
	return CLICK_ACTION_SUCCESS
