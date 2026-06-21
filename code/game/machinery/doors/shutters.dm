/obj/machinery/door/poddoor/shutters
	gender = PLURAL
	name = "百叶窗"
	desc = "重型机械百叶窗，带有大气密封，一旦关闭，可保持气密性。"
	icon = 'icons/obj/doors/shutters.dmi'
	layer = SHUTTER_LAYER
	closingLayer = SHUTTER_LAYER
	damage_deflection = 20
	armor_type = /datum/armor/poddoor_shutters
	max_integrity = 100
	recipe_type = /datum/crafting_recipe/shutters
	custom_materials = list(/datum/material/alloy/plasteel = SHEET_MATERIAL_AMOUNT * 5, /datum/material/iron = SMALL_MATERIAL_AMOUNT, /datum/material/glass = SMALL_MATERIAL_AMOUNT)
	animation_sound = 'sound/machines/shutter.ogg'
	show_nav_computer_icon = FALSE

/obj/machinery/door/poddoor/shutters/animation_length(animation)
	switch(animation)
		if(DOOR_OPENING_ANIMATION)
			return 1.388 SECONDS
		if(DOOR_CLOSING_ANIMATION)
			return 1.388 SECONDS

/obj/machinery/door/poddoor/shutters/animation_segment_delay(animation)
	switch(animation)
		if(DOOR_OPENING_PASSABLE)
			return 0.76 SECONDS
		if(DOOR_OPENING_FINISHED)
			return 1.388 SECONDS
		if(DOOR_CLOSING_UNPASSABLE)
			return 0.152 SECONDS
		if(DOOR_CLOSING_FINISHED)
			return 1.388 SECONDS

/obj/machinery/door/poddoor/shutters/preopen
	icon_state = "open"
	density = FALSE
	opacity = FALSE

/obj/machinery/door/poddoor/shutters/preopen/deconstructed
	deconstruction = BLASTDOOR_NEEDS_WIRES
	custom_materials = list(/datum/material/alloy/plasteel = SHEET_MATERIAL_AMOUNT * 5)

/obj/machinery/door/poddoor/shutters/indestructible
	name = "硬化百叶窗"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/machinery/door/poddoor/shutters/indestructible/preopen
	icon_state = "open"
	density = FALSE
	opacity = FALSE

/obj/machinery/door/poddoor/shutters/radiation
	name = "防辐射百叶窗"
	desc = "带有辐射危险标志的铅内衬百叶窗。虽然这不会阻止你受到辐射，尤其是被超物质晶体照射时，但它会阻止辐射传播到很远的地方。"
	icon = 'icons/obj/doors/shutters_radiation.dmi'
	icon_state = "closed"
	rad_insulation = RAD_EXTREME_INSULATION

/obj/machinery/door/poddoor/shutters/radiation/preopen
	icon_state = "open"
	density = FALSE
	opacity = FALSE
	rad_insulation = RAD_NO_INSULATION

/datum/armor/poddoor_shutters
	melee = 20
	bullet = 20
	laser = 20
	energy = 75
	bomb = 25
	fire = 100
	acid = 70

/obj/machinery/door/poddoor/shutters/radiation/open()
	. = ..()
	rad_insulation = RAD_NO_INSULATION

/obj/machinery/door/poddoor/shutters/radiation/close()
	. = ..()
	rad_insulation = RAD_EXTREME_INSULATION

/obj/machinery/door/poddoor/shutters/window
	name = "带窗百叶窗"
	desc = "一种带有厚透明聚碳酸酯窗的百叶窗"
	icon = 'icons/obj/doors/shutters_window.dmi'
	icon_state = "closed"
	opacity = FALSE
	glass = TRUE

/obj/machinery/door/poddoor/shutters/window/preopen
	icon_state = "open"
	density = FALSE

/obj/machinery/door/poddoor/shutters/window/indestructible
	name = "硬化带窗百叶门"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/machinery/door/poddoor/shutters/window/indestructible/preopen
	icon_state = "open"
	density = FALSE
	opacity = FALSE

/obj/machinery/door/poddoor/shutters/syndicate
	icon = 'icons/obj/doors/syndicateshutters.dmi'

/obj/machinery/door/poddoor/shutters/syndicate/preopen
	icon_state = "open"
	density = FALSE
	opacity = FALSE

/obj/machinery/door/poddoor/shutters/syndicate/indestructible
	name = "hardened syndicate shutters"
	resistance_flags = INDESTRUCTIBLE
