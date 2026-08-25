// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/item/clothing/under
	name = "under"
	icon = 'icons/obj/clothing/under/default.dmi'
	worn_icon = 'icons/mob/clothing/under/default.dmi'
	lefthand_file = 'icons/mob/inhands/clothing/suits_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/clothing/suits_righthand.dmi'
	abstract_type = /obj/item/clothing/under
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	slot_flags = ITEM_SLOT_ICLOTHING
	interaction_flags_click = NEED_DEXTERITY|ALLOW_RESTING
	armor_type = /datum/armor/clothing_under
	supports_variations_flags = CLOTHING_DIGITIGRADE_MASK
	bodyshapes_with_variations = BODYSHAPE_DIGITIGRADE
	equip_sound = 'sound/items/equip/jumpsuit_equip.ogg'
	drop_sound = 'sound/items/handling/cloth/cloth_drop1.ogg'
	pickup_sound = 'sound/items/handling/cloth/cloth_pickup1.ogg'
	limb_integrity = 30

	/// Has this undersuit been freshly laundered and, as such, imparts a mood bonus for wearing
	var/freshly_laundered = FALSE

	// Alt style handling
	/// Can this suit be adjustd up or down to an alt style
	var/can_adjust = TRUE
	/// If adjusted what style are we currently using?
	var/adjusted = NORMAL_STYLE
	/// For adjusted/rolled-down jumpsuits. FALSE = exposes chest and arms, TRUE = exposes arms only
	var/alt_covers_chest = FALSE
	/// The variable containing the flags for how the woman uniform cropping is supposed to interact with the sprite.
	var/female_sprite_flags = FEMALE_UNIFORM_FULL

	// Sensor handling
	/// Does this undersuit have suit sensors in general
	var/has_sensor = HAS_SENSORS
	/// Does this undersuit spawn with a random sensor value
	var/random_sensor = TRUE
	/// What is the active sensor mode of this udnersuit
	var/sensor_mode = SENSOR_OFF

	// Accessory handling (Can be componentized eventually)
	/// The max number of accessories we can have on this suit.
	var/max_number_of_accessories = 5
	/// A list of all accessories attached to us.
	var/list/obj/item/clothing/accessory/attached_accessories

/datum/armor/clothing_under
	bio = 10
	wound = 5

/obj/item/clothing/under/Initialize(mapload)
	. = ..()
	if(random_sensor)
		//make the sensor mode favor higher levels, except coords.
		set_sensor_mode(pick(SENSOR_VITALS, SENSOR_VITALS, SENSOR_VITALS, SENSOR_LIVING, SENSOR_LIVING, SENSOR_COORDS, SENSOR_COORDS, SENSOR_OFF))
	//ensure we add or remove relevant clothing traits based on base sensor status and mode
	update_wearer_status()

	register_context()
	AddElement(/datum/element/update_icon_updates_onmob, flags = ITEM_SLOT_ICLOTHING|ITEM_SLOT_OCLOTHING|ITEM_SLOT_NECK, body = TRUE)

/obj/item/clothing/under/on_craft_completion(list/components, datum/crafting_recipe/current_recipe, atom/crafter)
	. = ..()
	var/obj/item/clothing/under/any_original = locate() in components
	if(!any_original)
		set_has_sensor(NO_SENSORS)
		return
	set_has_sensor(any_original.has_sensor)
	set_sensor_mode(any_original.sensor_mode)

/obj/item/clothing/under/used_in_craft(atom/result, datum/crafting_recipe/current_recipe)
	. = ..()
	dump_attachments()

/obj/item/clothing/under/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	. = ..()

	var/changed = FALSE

	if(has_sensor == HAS_SENSORS && (isnull(held_item) || held_item == src))
		context[SCREENTIP_CONTEXT_RMB] = "Toggle suit sensors"
		context[SCREENTIP_CONTEXT_CTRL_LMB] = "Set suit sensors to tracking"
		changed = TRUE

	if(istype(held_item, /obj/item/clothing/accessory) && length(attached_accessories) < max_number_of_accessories)
		context[SCREENTIP_CONTEXT_LMB] = "Attach accessory"
		changed = TRUE

	if(LAZYLEN(attached_accessories))
		context[SCREENTIP_CONTEXT_ALT_RMB] = "Remove accessory"
		changed = TRUE

	if(has_sensor == BROKEN_SENSORS && istype(held_item, /obj/item/stack/cable_coil))
		context[SCREENTIP_CONTEXT_LMB] = "Repair suit sensors"
		changed = TRUE

	if(has_sensor == NO_SENSORS)
		if(istype(held_item, /obj/item/suit_sensor))
			context[SCREENTIP_CONTEXT_LMB] = "Install suit sensors"
			changed = TRUE
	else if(held_item?.tool_behaviour == TOOL_WIRECUTTER)
		context[SCREENTIP_CONTEXT_LMB] = "Cut suit sensors"
		changed = TRUE

	if(can_adjust && adjusted != DIGITIGRADE_STYLE)
		context[SCREENTIP_CONTEXT_ALT_LMB] =  "Wear [adjusted == ALT_STYLE ? "normally" : "casually"]"
		changed = TRUE

	return changed ? CONTEXTUAL_SCREENTIP_SET : .

/obj/item/clothing/under/worn_overlays(mutable_appearance/standing, isinhands = FALSE, icon_file, bodyshape = NONE)
	. = ..()
	if(isinhands)
		return
	if(damaged_clothes)
		. += mutable_appearance('icons/effects/item_damage.dmi', "damageduniform")
	. += get_accessory_overlays()

/obj/item/clothing/under/separate_worn_overlays(mutable_appearance/standing, mutable_appearance/draw_target, isinhands = FALSE, icon_file, bodyshape = NONE)
	. = ..()
	if (isinhands)
		return
	var/blood_overlay = get_blood_overlay("uniform", bodyshape)
	if (blood_overlay)
		. += blood_overlay

/obj/item/clothing/under/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/stack/cable_coil))
		if(!repair_sensors(user))
			return ITEM_INTERACT_BLOCKING
		var/obj/item/stack/cable_coil/cabling = tool
		cabling.use(1)
		cabling.visible_message(span_notice(LANG("obj.547ee95cb8d5368f", list(user, src, cabling))))
		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/clothing/accessory))
		return attach_accessory(tool, user) ? ITEM_INTERACT_SUCCESS : ITEM_INTERACT_BLOCKING

	if(istype(tool, /obj/item/suit_sensor))
		if(has_sensor != NO_SENSORS)
			balloon_alert(user, LANG("obj.f822c56b17d215ea", null))
			return ITEM_INTERACT_BLOCKING
		balloon_alert(user, LANG("obj.c646dd3e171d54ab", null))
		if(!do_after(user, 5 SECONDS, target = src))
			return ITEM_INTERACT_BLOCKING
		var/obj/item/suit_sensor/sensor = tool
		if(sensor.broken)
			set_has_sensor(BROKEN_SENSORS)
		else
			set_has_sensor(HAS_SENSORS)
			set_sensor_mode(sensor.sensor_mode)
		qdel(tool)
		balloon_alert(user, LANG("obj.efa03e7a0b7101c6", null))
		playsound(source = src, soundin = 'sound/effects/sparks/sparks4.ogg', vol = 50, vary = TRUE, extrarange = SHORT_RANGE_SOUND_EXTRARANGE, ignore_walls = FALSE)
		return ITEM_INTERACT_SUCCESS

	return ..()

/obj/item/clothing/under/wirecutter_act(mob/living/user, obj/item/tool)
	if(has_sensor == NO_SENSORS)
		balloon_alert(user, LANG("obj.b576791e4be20167", null))
		return ITEM_INTERACT_BLOCKING
	balloon_alert(user, LANG("obj.17ea51bcba379277", null))
	if(!do_after(user, 5 SECONDS, target = src))
		return ITEM_INTERACT_BLOCKING
	var/obj/item/suit_sensor/sensor = new (drop_location())
	if(sensor.IsReachableBy(user))
		user.put_in_hands(sensor)
	if(has_sensor == BROKEN_SENSORS)
		sensor.broken = TRUE
	else
		sensor.set_mode(sensor_mode)
	set_has_sensor(NO_SENSORS)
	return ITEM_INTERACT_SUCCESS

/obj/item/clothing/under/attack_hand_secondary(mob/user, params)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return

	toggle()
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/clothing/under/attack_self_secondary(mob/user, modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return

	toggle()
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/clothing/under/update_clothes_damaged_state(damaged_state = CLOTHING_DAMAGED)
	. = ..()
	if(damaged_state == CLOTHING_SHREDDED && has_sensor > NO_SENSORS)
		break_sensors()
	else if(damaged_state == CLOTHING_PRISTINE && has_sensor == BROKEN_SENSORS)
		repair_sensors()
	update_appearance()

/obj/item/clothing/under/visual_equipped(mob/user, slot)
	. = ..()
	if(adjusted == ALT_STYLE)
		adjust_to_normal()

	/* NOVA EDIT REMOVAL - This breaks jumpsuit adjustment. Plus, we don't support it.
	if((supports_variations_flags & CLOTHING_DIGITIGRADE_VARIATION) && ishuman(user))
		var/mob/living/carbon/human/wearer = user
		if(wearer.bodyshape & BODYSHAPE_DIGITIGRADE)
			adjusted = DIGITIGRADE_STYLE
			update_appearance()
		*/ // NOVA EDIT END

/obj/item/clothing/under/generate_digitigrade_icons(icon/base_icon, greyscale_colors)
	var/icon/legs = icon(SSgreyscale.GetColoredIconByType(/datum/greyscale_config/digitigrade, greyscale_colors), "jumpsuit_worn")
	return replace_icon_legs(base_icon, legs)

/obj/item/clothing/under/machine_wash()
	. = ..()
	if(stubborn_stains)
		return

	var/fresh_mood = AddComponent( \
		/datum/component/onwear_mood, \
		saved_event_type = /datum/mood_event/fresh_laundry, \
	)
	QDEL_IN(fresh_mood, 2 MINUTES)

/obj/item/clothing/under/equipped(mob/living/user, slot)
	..()
	if(slot & ITEM_SLOT_ICLOTHING)
		if(freshly_laundered)
			freshly_laundered = FALSE
			user.add_mood_event("fresh_laundry", /datum/mood_event/fresh_laundry)
		update_wearer_status()

/obj/item/clothing/under/dropped(mob/living/user)
	. = ..()
	if(user.get_item_by_slot(ITEM_SLOT_ICLOTHING) == src)
		GLOB.suit_sensors_list -= user

// Start suit sensor handling

/// Change the suit sensor state to broken and update the mob's status on the global sensor list
/obj/item/clothing/under/proc/break_sensors()
	if(has_sensor == BROKEN_SENSORS || has_sensor == NO_SENSORS)
		return

	visible_message(span_warning(LANG("obj.ad98f318bcf6be24", list(src))), blind_message = span_warning(LANG("obj.3b20ae447d7bdd56", list(src))), vision_distance = COMBAT_MESSAGE_RANGE)
	set_has_sensor(BROKEN_SENSORS)
	set_sensor_mode(SENSOR_LIVING) // NOVA EDIT ADDITION
	sensor_malfunction()

/**
 * Repair the suit sensors and update the mob's status on the global sensor list.
 * Can be called either through player action such as repairing with coil, or as part of a general fixing proc
 */
/obj/item/clothing/under/proc/repair_sensors(mob/user)
	if(has_sensor != BROKEN_SENSORS)
		if(user)
			balloon_alert(user, LANG("obj.58a9238361c77676", list(has_sensor == NO_SENSORS ? "missing" : "not broken")))
		return FALSE

	playsound(source = src, soundin = 'sound/effects/sparks/sparks4.ogg', vol = 100, vary = TRUE, extrarange = SHORT_RANGE_SOUND_EXTRARANGE, ignore_walls = FALSE)
	set_has_sensor(HAS_SENSORS)
	return TRUE

/// If the item is being worn, a gentle reminder every 3-5 minutes that the sensors are broken
/obj/item/clothing/under/proc/sensor_malfunction()
	if(!QDELETED(src) && has_sensor == BROKEN_SENSORS && ishuman(loc))
		do_sparks(number = 2, cardinal_only = FALSE, source = src)
		addtimer(CALLBACK(src, PROC_REF(sensor_malfunction)), rand(BROKEN_SPARKS_MIN, BROKEN_SPARKS_MAX * 0.5), TIMER_UNIQUE | TIMER_NO_HASH_WAIT)

/// Changes whether the suit sensor has a sensor, or if it's broken, etc. and handles updating mob status if applicable
/obj/item/clothing/under/proc/set_has_sensor(new_has_sensor)
	if(new_has_sensor == has_sensor)
		return FALSE
	if(new_has_sensor < BROKEN_SENSORS || new_has_sensor > LOCKED_SENSORS)
		stack_trace("Invalid has_sensor value [new_has_sensor] passed to set_has_sensor()")
		return FALSE
	has_sensor = new_has_sensor
	update_wearer_status()
	return TRUE

/// Changes the active sensor mode of the suit and handles updating mob status if applicable
/obj/item/clothing/under/proc/set_sensor_mode(new_sensor_mode)
	if(new_sensor_mode == sensor_mode)
		return FALSE
	if(new_sensor_mode < SENSOR_OFF || new_sensor_mode > SENSOR_COORDS)
		stack_trace("Invalid sensor_mode value [new_sensor_mode] passed to set_sensor_mode()")
		return FALSE
	sensor_mode = new_sensor_mode
	update_wearer_status()
	return TRUE

/// Updates the sensor status and any mobs status if applicable
/obj/item/clothing/under/proc/update_wearer_status()
	if(has_sensor <= NO_SENSORS || sensor_mode <= SENSOR_VITALS)
		detach_clothing_traits(TRAIT_BASIC_HEALTH_HUD_VISIBLE)
	else
		attach_clothing_traits(TRAIT_BASIC_HEALTH_HUD_VISIBLE)

	if(!ishuman(loc) || isdummy(loc))
		return

	var/mob/living/carbon/human/wearer = loc
	if(wearer.get_item_by_slot(ITEM_SLOT_ICLOTHING) != src)
		return

	if(has_sensor >= HAS_SENSORS && sensor_mode >= SENSOR_LIVING)
		GLOB.suit_sensors_list |= wearer
	else
		GLOB.suit_sensors_list -= wearer

	wearer.med_hud_set_status()

/obj/item/clothing/under/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	if(has_sensor == NO_SENSORS || has_sensor == BROKEN_SENSORS)
		return

	if(severity <= EMP_HEAVY)
		break_sensors()
		return

	set_sensor_mode(clamp(sensor_mode + pick(-1,1), SENSOR_OFF, SENSOR_COORDS)) // NOVA EDIT CHANGE ORIGINAL: set_sensor_mode(pick(SENSOR_OFF, SENSOR_OFF, SENSOR_OFF, SENSOR_LIVING, SENSOR_LIVING, SENSOR_VITALS, SENSOR_VITALS, SENSOR_COORDS))
	playsound(source = src, soundin = 'sound/effects/sparks/sparks3.ogg', vol = 75, vary = TRUE, extrarange = SHORT_RANGE_SOUND_EXTRARANGE, ignore_walls = FALSE)
	visible_message(span_warning(LANG("obj.617a679794f5110c", list(src))), blind_message = span_warning(LANG("obj.3b20ae447d7bdd56", list(src))), vision_distance = COMBAT_MESSAGE_RANGE)

/**
 * Called by medical scanners a simple summary of the status
 *
 * Arguments:
 * * silent: If TRUE, will return blank if everything is fine
 */
/obj/item/clothing/under/proc/get_sensor_text(silent = TRUE)
	if(has_sensor == BROKEN_SENSORS)
		return "<font color='#ffcc33'>Non-Functional: Repair with cable coil</font>"

	if(silent)
		return ""

	switch(has_sensor)
		if(NO_SENSORS)
			return "Not Present"

		if(LOCKED_SENSORS)
			return "Functional, Locked"

		if(HAS_SENSORS)
			return "Functional"

// End suit sensor handling

/// Attach the passed accessory to the clothing item
/obj/item/clothing/under/proc/attach_accessory(obj/item/clothing/accessory/accessory, mob/living/user, attach_message = TRUE)
	if(!istype(accessory))
		return
	if(!accessory.can_attach_accessory(src, user))
		return
	if(user && !user.temporarilyRemoveItemFromInventory(accessory))
		return
	if(!accessory.try_attach(src, user))
		return

	// Allow for accessories to react to the acccessory list now
	accessory.attach(src)

	if(user && attach_message)
		balloon_alert(user, LANG("obj.f671f64ddc25df5b", null))

	update_appearance()
	return TRUE

/// Removes (pops) the topmost accessory from the accessories list and puts it in the user's hands if supplied
/obj/item/clothing/under/proc/pop_accessory(mob/living/user, attach_message = TRUE)
	var/obj/item/clothing/accessory/popped_accessory = attached_accessories[1]
	remove_accessory(popped_accessory)

	if(!user)
		return

	user.put_in_hands(popped_accessory)
	if(attach_message)
		popped_accessory.balloon_alert(user, LANG("obj.de016798ffbde66d", null))

/// Removes the passed accesory from our accessories list
/obj/item/clothing/under/proc/remove_accessory(obj/item/clothing/accessory/removed, update = TRUE)
	// Remove it from the list before detaching
	LAZYREMOVE(attached_accessories, removed)
	removed.detach(src, update)
	update_appearance()

/// Get a list of all accessory overlays
/obj/item/clothing/under/proc/get_accessory_overlays()
	. = list()
	for(var/obj/item/clothing/accessory/accessory as anything in attached_accessories)
		. += accessory.generate_accessory_overlay(src)

/obj/item/clothing/under/Exited(atom/movable/gone, direction)
	. = ..()
	// If one of our accessories was moved out, handle it
	if(gone in attached_accessories)
		remove_accessory(gone)

/// Helper to remove all attachments to the passed location
/obj/item/clothing/under/proc/dump_attachments(atom/drop_to = drop_location())
	for(var/obj/item/clothing/accessory/worn_accessory as anything in attached_accessories)
		remove_accessory(worn_accessory, update = FALSE)
		worn_accessory.forceMove(drop_to)

	if (ishuman(loc))
		var/mob/living/carbon/human/wearer = loc
		wearer.update_clothing(slot_flags)

/obj/item/clothing/under/atom_destruction(damage_flag)
	dump_attachments()
	return ..()

/obj/item/clothing/under/Destroy()
	QDEL_LAZYLIST(attached_accessories)
	return ..()

/obj/item/clothing/under/examine(mob/user)
	. = ..()
	if(can_adjust)
		. += LANG("obj.617841c5cf17830a", list(src, adjusted == ALT_STYLE ? "normally" : "casually"))
	if(has_sensor == BROKEN_SENSORS)
		. += span_warning(LANG("obj.56fd7bc0673639d3", null))
	else if(has_sensor > NO_SENSORS)
		switch(sensor_mode)
			if(SENSOR_OFF)
				. += LANG("obj.cb8daeb75ff356ff", null)
			if(SENSOR_LIVING)
				. += LANG("obj.22584281869c6507", null)
			if(SENSOR_VITALS)
				. += LANG("obj.522375251afd0118", null)
			if(SENSOR_COORDS)
				. += LANG("obj.7b9f0004396c5784", null)
	else
		. += span_tooltip(lang_reverse_text("You can always get new suit sensors to install from a lathe."), lang_reverse_text("It isn't equipped with medical sensors.")) // NOVA EDIT - I18N: span_tooltip args reversed (codemod mangles both args into one key)

	if(LAZYLEN(attached_accessories))
		var/list/accessories = list_accessories_with_icon(user)
		. += LANG("obj.da83e7bd90e50978", list(lang_english_list(accessories)))
		. += LANG("obj.fa3a64e1bdacd14f", list(attached_accessories[1]))

/// Helper to list out all accessories with an icon besides it, for use in examine
/obj/item/clothing/under/proc/list_accessories_with_icon(mob/user)
	var/list/all_accessories = list()
	for(var/obj/item/clothing/accessory/attached as anything in attached_accessories)
		all_accessories += attached.examine_title(user)

	return all_accessories

GAME_VERB_SRC(/obj/item/clothing/under, toggle, usr, "调整制服传感器", null)
	var/mob/user_mob = usr
	if(!can_toggle_sensors(user_mob))
		return

	var/current_mode_text = GLOB.suit_sensor_mode_to_defines[sensor_mode + 1]
	var/new_mode = tgui_input_list(user_mob, LANG("obj.24e97e1ed4448163", null), LANG("obj.e765235b4209b8dc", null), GLOB.suit_sensor_mode_to_defines, current_mode_text)
	if(isnull(new_mode))
		return
	if(!can_toggle_sensors(user_mob))
		return

	set_sensor_mode(GLOB.suit_sensor_mode_to_defines[new_mode])
	if (loc == user_mob)
		switch(sensor_mode)
			if(SENSOR_OFF)
				to_chat(user_mob, span_notice(LANG("obj.37ff0635604a673e", null)))
			if(SENSOR_LIVING)
				to_chat(user_mob, span_notice(LANG("obj.4d6371abc309820c", null)))
			if(SENSOR_VITALS)
				to_chat(user_mob, span_notice(LANG("obj.67d31d55fb3a9411", null)))
			if(SENSOR_COORDS)
				to_chat(user_mob, span_notice(LANG("obj.0339532693cede07", null)))

/obj/item/clothing/under/item_ctrl_click(mob/user)
	if(!can_toggle_sensors(user))
		return CLICK_ACTION_BLOCKING

	set_sensor_mode(SENSOR_COORDS)
	balloon_alert(user, LANG("obj.0d33f56854e3bbca", null))
	return CLICK_ACTION_SUCCESS

/// Checks if the toggler is allowed to toggle suit sensors currently
/obj/item/clothing/under/proc/can_toggle_sensors(mob/toggler)
	if(!can_use(toggler) || toggler.stat == DEAD) //make sure they didn't hold the window open.
		return FALSE
	if(get_dist(toggler, src) > 1)
		balloon_alert(toggler, LANG("obj.f5e75781e8f1dc46", null))
		return FALSE

	switch(has_sensor)
		if(LOCKED_SENSORS)
			balloon_alert(toggler, LANG("obj.cf083aaf071f0450", null))
			return FALSE
		if(BROKEN_SENSORS)
			balloon_alert(toggler, LANG("obj.e4cf865ac0b23446", null))
			return FALSE
		if(NO_SENSORS)
			balloon_alert(toggler, LANG("obj.ab31e8ccf0ee00ec", null))
			return FALSE

	return TRUE

/obj/item/clothing/under/click_alt(mob/user)
	if(!can_adjust)
		balloon_alert(user, LANG("obj.7c1df17eaa6f2713", null))
		return CLICK_ACTION_BLOCKING
	if(!can_use(user))
		return NONE
	rolldown()
	return CLICK_ACTION_SUCCESS

/obj/item/clothing/under/click_alt_secondary(mob/user)
	if(!LAZYLEN(attached_accessories))
		balloon_alert(user, LANG("obj.f9e59eb460dbdfc8", null))
		return
	pop_accessory(user)

GAME_VERB_SRC(/obj/item/clothing/under, jumpsuit_adjust, usr, "调整连体服样式", null)

	if(!can_adjust)
		balloon_alert(usr, LANG("obj.7c1df17eaa6f2713", null))
		return
	if(!can_use(usr))
		return
	rolldown()

/obj/item/clothing/under/proc/rolldown()
	if(toggle_jumpsuit_adjust())
		to_chat(usr, span_notice(LANG("obj.df390365e3227901", null)))
	else
		to_chat(usr, span_notice(LANG("obj.8e1ff3acec5ffb06", null)))

	update_appearance()

/// Helper to toggle the jumpsuit style, if possible
/// Returns the new state
/obj/item/clothing/under/proc/toggle_jumpsuit_adjust()
	switch(adjusted)
		if(DIGITIGRADE_STYLE)
			return

		if(NORMAL_STYLE)
			adjust_to_alt()

		if(ALT_STYLE)
			adjust_to_normal()

	SEND_SIGNAL(src, COMSIG_CLOTHING_UNDER_ADJUSTED)
	return adjusted

/// Helper to reset to normal jumpsuit state
/obj/item/clothing/under/proc/adjust_to_normal()
	adjusted = NORMAL_STYLE
	female_sprite_flags = initial(female_sprite_flags)
	if(!alt_covers_chest)
		body_parts_covered |= CHEST
		body_parts_covered |= ARMS
	if(LAZYLEN(damage_by_parts))
		// ugly check to make sure we don't reenable protection on a disabled part
		for(var/zone in list(BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))
			if(damage_by_parts[zone] > limb_integrity)
				body_parts_covered &= body_zone2cover_flags(zone)

/// Helper to adjust to alt jumpsuit state
/obj/item/clothing/under/proc/adjust_to_alt()
	adjusted = ALT_STYLE
	if(!(female_sprite_flags & FEMALE_UNIFORM_TOP_ONLY))
		female_sprite_flags = NO_FEMALE_UNIFORM
	if(!alt_covers_chest) // for the special snowflake suits that expose the chest when adjusted (and also the arms, realistically)
		body_parts_covered &= ~CHEST
		body_parts_covered &= ~ARMS

/obj/item/clothing/under/can_use(mob/user)
	if(ismob(user) && !user.can_perform_action(src, NEED_DEXTERITY|NEED_HANDS|ALLOW_RESTING))
		return FALSE
	return ..()

/obj/item/clothing/under/rank
	abstract_type = /obj/item/clothing/under/rank
	dying_key = DYE_REGISTRY_UNDER
