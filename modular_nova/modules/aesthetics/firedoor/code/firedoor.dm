/obj/machinery/door/firedoor
	name = "紧急防火闸"
	desc = "紧急气密防火闸，能够封堵破损区域。这个防火闸带有玻璃面板。它有一个可以用手直接打开的机制。"
	icon = 'modular_nova/modules/aesthetics/firedoor/icons/firedoor_glass.dmi'
	var/door_open_sound = 'modular_nova/modules/aesthetics/firedoor/sound/firedoor_open.ogg'
	var/door_close_sound = 'modular_nova/modules/aesthetics/firedoor/sound/firedoor_open.ogg'

/obj/machinery/door/firedoor/update_overlays()
	. = ..()
	if(istype(src, /obj/machinery/door/firedoor/border_only))
		return
	if(density) // if the door is closed, add the bottom blinking overlay -- and only if it's closed
		. += mutable_appearance(icon, "firelock_alarm_type_bottom")
		. += emissive_appearance(icon, "firelock_alarm_type_bottom", src, alpha = src.alpha)

/obj/machinery/door/firedoor/open()
	playsound(loc, door_open_sound, 100, TRUE)
	return ..()

/obj/machinery/door/firedoor/close()
	playsound(loc, door_close_sound, 100, TRUE)
	return ..()

/obj/machinery/door/firedoor/heavy
	name = "重型紧急防火闸"
	desc = "紧急气密防火闸，能够封堵破损区域。它有一个可以用手直接打开的机制。"
	icon = 'modular_nova/modules/aesthetics/firedoor/icons/firedoor.dmi'

/obj/effect/spawner/structure/window/reinforced/no_firelock
	spawn_list = list(/obj/structure/grille, /obj/structure/window/reinforced/fulltile)

/obj/machinery/door/firedoor/closed
	alarm_type = FIRELOCK_ALARM_TYPE_GENERIC
