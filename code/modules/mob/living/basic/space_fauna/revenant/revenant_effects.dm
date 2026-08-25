// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/// Parent type for all unique revenant status effects
/datum/status_effect/revenant
	id = STATUS_EFFECT_ID_ABSTRACT
	processing_speed = STATUS_EFFECT_PRIORITY
	alert_type = null

/datum/status_effect/revenant/on_creation(mob/living/new_owner, duration)
	if(isnum(duration))
		src.duration = duration
	return ..()

/datum/status_effect/revenant/revealed
	id = "revenant_revealed"

/datum/status_effect/revenant/revealed/on_apply()
	. = ..()
	if(!.)
		return FALSE
	owner.orbiting?.end_orbit(src)

	ADD_TRAIT(owner, TRAIT_REVENANT_REVEALED, TRAIT_STATUS_EFFECT(id))
	owner.SetInvisibility(INVISIBILITY_NONE, id=type, priority=INVISIBILITY_PRIORITY_BASIC_ANTI_INVISIBILITY)
	owner.incorporeal_move = FALSE
	owner.update_appearance(UPDATE_ICON)
	owner.update_mob_action_buttons()

/datum/status_effect/revenant/revealed/on_remove()
	REMOVE_TRAIT(owner, TRAIT_REVENANT_REVEALED, TRAIT_STATUS_EFFECT(id))

	owner.incorporeal_move = HAS_TRAIT(owner, TRAIT_REVENANT_REVEALED) ? FALSE : INCORPOREAL_MOVE_JAUNT // NOVA EDIT CHANGE - ORIGINAL: owner.incorporeal_move = INCORPOREAL_MOVE_JAUNT
	owner.RemoveInvisibility(type)
	owner.update_appearance(UPDATE_ICON)
	owner.update_mob_action_buttons()
	return ..()

/datum/status_effect/revenant/inhibited
	id = "revenant_inhibited"

/datum/status_effect/revenant/inhibited/on_apply()
	. = ..()
	if(!.)
		return FALSE
	owner.orbiting?.end_orbit(src)

	ADD_TRAIT(owner, TRAIT_REVENANT_INHIBITED, TRAIT_STATUS_EFFECT(id))
	owner.update_appearance(UPDATE_ICON)

	owner.balloon_alert(owner, LANG("datum.427546a3bd2d8dcb", null))

/datum/status_effect/revenant/inhibited/on_remove()
	REMOVE_TRAIT(owner, TRAIT_REVENANT_INHIBITED, TRAIT_STATUS_EFFECT(id))
	owner.update_appearance(UPDATE_ICON)

	owner.balloon_alert(owner, LANG("datum.976d8a029a8b11d8", null))
	return ..()

/datum/status_effect/incapacitating/paralyzed/revenant
	id = "revenant_paralyzed"

/datum/status_effect/incapacitating/paralyzed/revenant/on_apply()
	. = ..()
	if(!.)
		return FALSE
	owner.orbiting?.end_orbit(src)

	ADD_TRAIT(owner, TRAIT_NO_TRANSFORM, TRAIT_STATUS_EFFECT(id))
	owner.balloon_alert(owner, LANG("datum.b5c8ce04aa8e539a", null))
	owner.update_mob_action_buttons()
	owner.update_appearance(UPDATE_ICON)

/datum/status_effect/incapacitating/paralyzed/revenant/on_remove()
	REMOVE_TRAIT(owner, TRAIT_NO_TRANSFORM, TRAIT_STATUS_EFFECT(id))
	owner.update_mob_action_buttons()
	owner.balloon_alert(owner, LANG("datum.5c6dddd7f0d0e932", null))

	return ..()
