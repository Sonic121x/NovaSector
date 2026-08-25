/obj/item/laser_pointer
	//Whether the laser pointer is capable of receiving upgrades
	var/upgradable = TRUE

/obj/item/laser_pointer/limited
	//limited laser pointers cannot receive upgrades, mostly used in loadout
	upgradable = FALSE

/obj/item/laser_pointer/limited/red
	pointer_icon_state = "red_laser"

/obj/item/laser_pointer/limited/green
	pointer_icon_state = "green_laser"

/obj/item/laser_pointer/limited/blue
	pointer_icon_state = "blue_laser"

/obj/item/laser_pointer/limited/purple
	pointer_icon_state = "purple_laser"

/obj/item/laser_pointer/screwdriver_act(mob/living/user, obj/item/tool)
	if(!upgradable)
		balloon_alert(user, LANG("obj.0c1764f567365537", null))
		return
	return ..()

/obj/item/laser_pointer/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/stock_parts/micro_laser) || istype(tool, /obj/item/stack/ore/bluespace_crystal))
		if(!upgradable)
			balloon_alert(user, LANG("obj.e0b58e884b740f09", null))
			return ITEM_INTERACT_BLOCKING
	return ..()

/obj/item/laser_pointer/examine(mob/user)
	. = ..()
	if(!upgradable)
		. += span_notice(LANG("obj.54abf7892e2eb466", null))
