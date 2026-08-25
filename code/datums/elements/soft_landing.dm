// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/**
 * ## soft landing element!
 *
 * Non bespoke element (1 in existence) that makes objs provide a soft landing when you fall on them!
 */
/datum/element/soft_landing
	element_flags = ELEMENT_DETACH_ON_HOST_DESTROY // Detach for turfs

/datum/element/soft_landing/Attach(datum/target)
	. = ..()
	if(!isatom(target))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_ATOM_INTERCEPT_Z_FALL, PROC_REF(intercept_z_fall))

/datum/element/soft_landing/Detach(datum/target)
	. = ..()
	UnregisterSignal(target, COMSIG_ATOM_INTERCEPT_Z_FALL)

///signal called by the stat of the target changing
/datum/element/soft_landing/proc/intercept_z_fall(atom/soft_object, falling_movables, levels)
	SIGNAL_HANDLER

	var/turf/falling_spot = get_turf(soft_object)

	if(locate(/obj/structure/stairs) in falling_spot)
		return FALL_INTERCEPTED | FALL_NO_MESSAGE

	for(var/mob/living/falling_victim in falling_movables)
		if(soft_object == falling_victim)
			to_chat(falling_victim, span_notice(LANG("datum.58da6a04a5c7da53", null)))
		else
			to_chat(falling_victim, span_notice(LANG("datum.421ff1c180818cb5", list(soft_object))))
	return FALL_INTERCEPTED | FALL_NO_MESSAGE
