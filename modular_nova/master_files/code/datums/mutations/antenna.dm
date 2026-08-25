/datum/action/cooldown/spell/pointed/mindread/cast(mob/living/cast_on)
	if(HAS_TRAIT(cast_on, TRAIT_PSIONIC_DAMPENER))
		to_chat(owner, span_warning(LANG("datum.d5208656bad5a7a0", list(cast_on))))
		return
	return ..()
