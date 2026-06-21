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
		balloon_alert(user, "无法移除集成二极管！")
		return
	return ..()

/obj/item/laser_pointer/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers)
	if(istype(attacking_item, /obj/item/stock_parts/micro_laser) || istype(attacking_item, /obj/item/stack/ore/bluespace_crystal))
		if(!upgradable)
			balloon_alert(user, "无法升级集成部件！")
			return
	return ..()

/obj/item/laser_pointer/examine(mob/user)
	. = ..()
	if(!upgradable)
		. += span_notice("二极管和透镜都是廉价的集成部件。此指示器无法升级。")
