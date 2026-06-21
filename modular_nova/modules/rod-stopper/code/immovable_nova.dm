/obj/effect/immovablerod/Bump(atom/clong)
	var/should_self_destroy = FALSE
	if(istype(clong, /obj/machinery/rodstopper))
		should_self_destroy = TRUE
	. = ..()
	if(should_self_destroy)
		visible_message(span_boldwarning("这根杆子撕裂了杆止器，发出撕裂现实的尖啸！"))
		playsound(src.loc,'sound/effects/supermatter.ogg', 200, TRUE)
		visible_message(span_boldwarning("你有五秒钟时间离开，否则将面临局部现实坍缩！"))
		var/obj/reality_tear/tear = new(src.loc)
		tear.start_disaster()
		qdel(src)
