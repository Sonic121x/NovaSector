/obj/item/circuitboard/machine/rodstopper
	name = "Rodstopper"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/rodstopper
	req_components = list(
		/datum/stock_part/matter_bin = 1,
		/obj/item/stack/sheet/plasteel = 1,
	)

/obj/machinery/rodstopper
	name = "rodstopper"
	desc = "An advanced machine which can halt immovable rods."
	icon = 'modular_nova/modules/rod-stopper/icons/rodstopper.dmi'
	icon_state = "rodstopper"
	density = TRUE
	use_power = NO_POWER_USE
	circuit = /obj/item/circuitboard/machine/rodstopper
	layer = BELOW_OBJ_LAYER

/obj/machinery/rodstopper/examine(mob/user)
	. = ..()
	. += span_warning(LANG("obj.c3cd73d1bfe53bcf", null))

/obj/machinery/rodstopper/Initialize(mapload)
	. = ..()
	warn_area()

/obj/machinery/rodstopper/proc/warn_area()
	playsound(src, 'sound/announcer/alarm/bloblarm.ogg', 100)
	say(LANG("obj.eb8ed86449a84175", null))
	addtimer(CALLBACK(src, PROC_REF(warn_area)), 15 SECONDS, TIMER_OVERRIDE|TIMER_UNIQUE) // the sound is 7 seconds, however.
