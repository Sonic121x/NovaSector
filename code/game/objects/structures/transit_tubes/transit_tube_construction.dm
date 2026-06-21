// transit tube construction

// normal transit tubes
/obj/structure/c_transit_tube
	name = "未固定的运输管"
	icon = 'icons/obj/pipes_n_cables/transit_tube.dmi'
	icon_state = "straight"
	desc = "一段未连接的运输管"
	density = FALSE
	layer = LOW_ITEM_LAYER //same as the built tube
	anchored = FALSE
	var/flipped = FALSE
	var/build_type = /obj/structure/transit_tube
	var/flipped_build_type

/obj/structure/c_transit_tube/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/simple_rotation)

/obj/structure/c_transit_tube/proc/can_wrench_in_loc(mob/user)
	var/turf/source_turf = get_turf(loc)
	var/existing_tubes = 0
	for(var/obj/structure/transit_tube/tube in source_turf)
		existing_tubes +=1
		if(existing_tubes >= 2)
			to_chat(user, "[span_warning("You cannot wrench any more transit tubes!")] ")
			return FALSE
	return TRUE

/obj/structure/c_transit_tube/proc/post_rotation(mob/user, degrees)
	if(flipped_build_type && degrees == ROTATION_FLIP)
		setDir(turn(dir, degrees)) //Turn back we don't actually flip
		flipped = !flipped
		var/cur_flip = initial(flipped) ? !flipped : flipped
		if(cur_flip)
			build_type = flipped_build_type
		else
			build_type = initial(build_type)
		icon_state = "[base_icon_state][flipped]"

/obj/structure/c_transit_tube/wrench_act(mob/living/user, obj/item/I)
	..()
	if(!can_wrench_in_loc(user))
		return
	to_chat(user, span_notice("You start attaching \the [src]..."))
	add_fingerprint(user)
	if(I.use_tool(src, user, 2 SECONDS, volume=50, extra_checks=CALLBACK(src, PROC_REF(can_wrench_in_loc), user)))
		to_chat(user, span_notice("You attach \the [src]."))
		var/obj/structure/transit_tube/R = new build_type(loc, dir)
		transfer_fingerprints_to(R)
		qdel(src)
	return TRUE


// transit tube station
/obj/structure/c_transit_tube/station
	name = "未连接的管道过路站"
	icon_state = "closed_station0"
	build_type = /obj/structure/transit_tube/station
	flipped_build_type = /obj/structure/transit_tube/station/flipped
	base_icon_state = "closed_station"

/obj/structure/c_transit_tube/station/flipped
	icon_state = "closed_station1"
	flipped = TRUE
	build_type = /obj/structure/transit_tube/station/flipped
	flipped_build_type = /obj/structure/transit_tube/station


// reverser station, used for the terminus
/obj/structure/c_transit_tube/station/reverse
	name = "未连接的终点管道站"
	icon_state = "closed_terminus0"
	build_type = /obj/structure/transit_tube/station/reverse
	flipped_build_type = /obj/structure/transit_tube/station/reverse/flipped
	base_icon_state = "closed_terminus"

/obj/structure/c_transit_tube/station/reverse/flipped
	icon_state = "closed_terminus1"
	flipped = TRUE
	build_type = /obj/structure/transit_tube/station/reverse/flipped
	flipped_build_type = /obj/structure/transit_tube/station/reverse

//all the dispenser stations

/obj/structure/c_transit_tube/station/dispenser
	icon_state = "open_dispenser0"
	name = "未连接的管道分配站"
	build_type = /obj/structure/transit_tube/station/dispenser
	flipped_build_type = /obj/structure/transit_tube/station/dispenser/flipped
	base_icon_state = "open_dispenser"

/obj/structure/c_transit_tube/station/dispenser/flipped
	icon_state = "open_dispenser1"
	flipped = TRUE
	build_type = /obj/structure/transit_tube/station/dispenser/flipped
	flipped_build_type = /obj/structure/transit_tube/station/dispenser

//and the ones that reverse

/obj/structure/c_transit_tube/station/dispenser/reverse
	name = "未连接的终点管道分发站"
	icon_state = "open_terminusdispenser0"
	build_type = /obj/structure/transit_tube/station/dispenser/reverse
	flipped_build_type = /obj/structure/transit_tube/station/dispenser/reverse/flipped
	base_icon_state = "open_terminusdispenser"

/obj/structure/c_transit_tube/station/dispenser/reverse/flipped
	icon_state = "open_terminusdispenser1"
	flipped = TRUE
	build_type = /obj/structure/transit_tube/station/dispenser/reverse/flipped
	flipped_build_type = /obj/structure/transit_tube/station/dispenser/reverse

//onto some special tube types

/obj/structure/c_transit_tube/crossing
	icon_state = "crossing"
	build_type = /obj/structure/transit_tube/crossing


/obj/structure/c_transit_tube/diagonal
	icon_state = "diagonal"
	build_type = /obj/structure/transit_tube/diagonal

/obj/structure/c_transit_tube/diagonal/crossing
	icon_state = "diagonal_crossing"
	build_type = /obj/structure/transit_tube/diagonal/crossing


/obj/structure/c_transit_tube/curved
	icon_state = "curved0"
	build_type = /obj/structure/transit_tube/curved
	flipped_build_type = /obj/structure/transit_tube/curved/flipped
	base_icon_state = "curved"

/obj/structure/c_transit_tube/curved/flipped
	icon_state = "curved1"
	build_type = /obj/structure/transit_tube/curved/flipped
	flipped_build_type = /obj/structure/transit_tube/curved
	flipped = TRUE


/obj/structure/c_transit_tube/junction
	icon_state = "junction0"
	build_type = /obj/structure/transit_tube/junction
	flipped_build_type = /obj/structure/transit_tube/junction/flipped
	base_icon_state = "junction"


/obj/structure/c_transit_tube/junction/flipped
	icon_state = "junction1"
	flipped = TRUE
	build_type = /obj/structure/transit_tube/junction/flipped
	flipped_build_type = /obj/structure/transit_tube/junction


//transit tube pod
//see station.dm for the logic
/obj/structure/c_transit_tube_pod
	name = "未连接的运输管舱"
	icon = 'icons/obj/pipes_n_cables/transit_tube.dmi'
	icon_state = "pod"
	desc = "看起来能被 <b>拖拽</b> 进一个带进口的运输管里."
	anchored = FALSE
	density = FALSE
