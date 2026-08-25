/obj/vehicle/sealed/mob_try_enter(mob/rider)
	if(!istype(rider))
		return FALSE
	if(HAS_TRAIT(rider, TRAIT_OVERSIZED))
		to_chat(rider, span_warning(LANG("obj.313f0031a1f3e683", null)))
		return FALSE

	return ..()
