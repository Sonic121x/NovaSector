// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
///The item representing suit sensors when removed from a suit or dress (obj/item/clothing/under)
/obj/item/suit_sensor
	name = "suit sensor"
	desc = "That thingamabob medbay keeps telling you to set to 'Tracking Beacon'. It needs to be attached to a worn suit or dress to work."
	icon = 'icons/obj/devices/tracker.dmi'
	icon_state = "suit_sensor"
	base_icon_state = "suit_sensor"
	obj_flags = CONDUCTS_ELECTRICITY
	w_class = WEIGHT_CLASS_TINY
	custom_materials = list(/datum/material/iron= SMALL_MATERIAL_AMOUNT, /datum/material/glass= SMALL_MATERIAL_AMOUNT)
	drop_sound = 'sound/items/handling/component_drop.ogg'
	pickup_sound = 'sound/items/handling/component_pickup.ogg'
	throwforce = 2
	throw_speed = 3
	throw_range = 7
	///The current sensor mode, inherited from the clothing it's cut from. Can also be changed when using it in hand.
	var/sensor_mode = SENSOR_OFF
	///Suit sensors are busted when struck by a heavy electromagnetic pulse.
	var/broken = FALSE

/obj/item/suit_sensor/examine(mob/user)
	. = ..()
	if(broken)
		. += span_warning(LANG("obj.5a08cd79cd067472", list(EXAMINE_HINT("cable"))))
	else
		. += span_notice(LANG("obj.f2a7ea1dce6b5e3b", list(GLOB.suit_sensor_mode_to_defines.Find(sensor_mode + 1))))

/obj/item/suit_sensor/update_overlays()
	. = ..()
	if(broken)
		return
	switch(sensor_mode)
		if(SENSOR_LIVING)
			. += "suit_sensor_binary"
		if(SENSOR_VITALS)
			. += "suit_sensor_vitals"
		if(SENSOR_COORDS)
			. += "suit_sensor_tracking"

/obj/item/suit_sensor/proc/set_mode(new_mode)
	if(sensor_mode == new_mode)
		return FALSE
	sensor_mode = new_mode
	update_appearance(UPDATE_OVERLAYS)
	return TRUE

/obj/item/suit_sensor/attack_self(mob/living/user)
	. = ..()
	if(!(user.mobility_flags & MOBILITY_USE) || !IsReachableBy(user))
		return FALSE
	if(broken)
		balloon_alert(user, LANG("obj.7cef697c0848a147", null))
		return
	var/current_mode_text = GLOB.suit_sensor_mode_to_defines[sensor_mode + 1]
	var/new_mode = tgui_input_list(user, LANG("obj.24e97e1ed4448163", null), LANG("obj.e765235b4209b8dc", null), GLOB.suit_sensor_mode_to_defines, current_mode_text)
	if(isnull(new_mode) || broken|| !(user.mobility_flags & MOBILITY_USE) || !IsReachableBy(user))
		user.balloon_alert(user, LANG("obj.c179342d3ab04191", null))
		return
	set_mode(GLOB.suit_sensor_mode_to_defines[new_mode])
	balloon_alert(user, LANG("obj.ec931decda3bae7c", list(LOWER_TEXT(new_mode))))

/obj/item/suit_sensor/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF || broken)
		return

	if(severity <= EMP_HEAVY)
		broken = TRUE
	else
		set_mode(pick(SENSOR_OFF, SENSOR_OFF, SENSOR_OFF, SENSOR_LIVING, SENSOR_LIVING, SENSOR_VITALS, SENSOR_VITALS, SENSOR_COORDS))
	playsound(source = src, soundin = 'sound/effects/sparks/sparks3.ogg', vol = 75, vary = TRUE, extrarange = SHORT_RANGE_SOUND_EXTRARANGE, ignore_walls = FALSE)

/obj/item/suit_sensor/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/stack/cable_coil))
		return ..()
	if(!broken)
		balloon_alert(user, LANG("obj.a34e1117baf48dad", null))
		return ITEM_INTERACT_BLOCKING
	var/obj/item/stack/cable_coil/cabling = tool
	cabling.use(1)
	balloon_alert(user, LANG("obj.239fa63dbfde1e8f", null))
	broken = FALSE
	update_appearance(UPDATE_OVERLAYS)
	return ITEM_INTERACT_SUCCESS
