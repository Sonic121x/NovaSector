/obj/effect/immovablerod/Bump(atom/clong)
	var/should_self_destroy = FALSE
	if(istype(clong, /obj/machinery/rodstopper))
		should_self_destroy = TRUE
	. = ..()
	if(should_self_destroy)
		visible_message(span_boldwarning(LANG("obj.cfc5fc1d72ec9792", null)))
		playsound(src.loc,'sound/effects/supermatter.ogg', 200, TRUE)
		visible_message(span_boldwarning(LANG("obj.f51ced3a03fa7e64", null)))
		var/obj/reality_tear/tear = new(src.loc)
		tear.start_disaster()
		qdel(src)
