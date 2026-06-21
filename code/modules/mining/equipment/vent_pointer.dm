/obj/item/pinpointer/vent
	name = "通风口定位器"
	desc = "一种手持追踪设备。它能定位并指向附近的通风口。不过有点不可靠。"
	icon_state = "pinpointer_vent"
	minimum_range = 8 //gotta use them eyes
	close_range = 12
	medium_range = 20

/obj/item/pinpointer/vent/scan_for_target()
	var/closest_dist = INFINITY

	for(var/obj/structure/ore_vent/vent in SSore_generation.possible_vents)
		if(vent.discovered || vent.tapped)
			continue
		if(vent.z != loc.z)
			continue

		var/target_dist = get_dist(src, vent)
		if(target_dist < closest_dist)
			closest_dist = target_dist
			target = vent
