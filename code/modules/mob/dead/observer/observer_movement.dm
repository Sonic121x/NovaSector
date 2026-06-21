/mob/dead/observer/down()
	if(zMove(DOWN, z_move_flags = ZMOVE_FEEDBACK))
		to_chat(src, span_notice("你向下移动。"))

/mob/dead/observer/up()
	if(zMove(UP, z_move_flags = ZMOVE_FEEDBACK))
		to_chat(src, span_notice("你向上移动。"))

/mob/dead/observer/can_z_move(direction, turf/start, turf/destination, z_move_flags = NONE, mob/living/rider)
	z_move_flags |= ZMOVE_IGNORE_OBSTACLES  //observers do not respect these FLOORS you speak so much of.
	return ..()
