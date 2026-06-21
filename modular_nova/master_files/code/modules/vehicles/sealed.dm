/obj/vehicle/sealed/mob_try_enter(mob/rider)
	if(!istype(rider))
		return FALSE
	if(HAS_TRAIT(rider, TRAIT_OVERSIZED))
		to_chat(rider, span_warning("你体型太大了，进不去！"))
		return FALSE

	return ..()
