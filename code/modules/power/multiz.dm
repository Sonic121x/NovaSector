/obj/structure/cable/multilayer/multiz //This bridges powernets betwen Z levels
	name = "多Z层电缆集线器"
	desc = "一种具有弹性的、超导性质的绝缘多层环，用于重型多层电能传输。"
	icon = 'icons/obj/pipes_n_cables/structures.dmi'
	icon_state = "cablerelay-on"
	cable_layer = CABLE_LAYER_1|CABLE_LAYER_2|CABLE_LAYER_3

/obj/structure/cable/multilayer/multiz/get_cable_connections(powernetless_only)
	. = ..()
	var/turf/T = get_turf(src)
	. += locate(/obj/structure/cable/multilayer/multiz) in (GET_TURF_BELOW(T))
	. += locate(/obj/structure/cable/multilayer/multiz) in (GET_TURF_ABOVE(T))

/obj/structure/cable/multilayer/multiz/examine(mob/user)
	. = ..()
	var/turf/T = get_turf(src)
	. += span_notice("[locate(/obj/structure/cable/multilayer/multiz) in (GET_TURF_BELOW(T)) ? "Detected" : "Undetected"] 上方枢纽。")
	. += span_notice("[locate(/obj/structure/cable/multilayer/multiz) in (GET_TURF_ABOVE(T)) ? "Detected" : "Undetected"] 下方枢纽。")
