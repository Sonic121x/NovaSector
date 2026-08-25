/atom/movable/screen/alert/status_effect/vulnerable_to_damage
	name = "Vulnerable To Damage"
	desc = "You will take more damage than normal while your body recovers from mending itself!"
	icon_state = "terrified"

/datum/status_effect/vulnerable_to_damage
	id = "vulnerable_to_damage"
	duration = 5 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/vulnerable_to_damage
	remove_on_fullheal = TRUE
	/// The percentage damage modifier we give the mob we're applied to
	var/damage_resistance_subtraction = 50
	/// How much extra bleeding the mob is given
	var/bleed_modifier_addition = 1

/datum/status_effect/vulnerable_to_damage/on_apply()
	to_chat(owner, span_userdanger(LANG("datum.688fc6df2582c36c", null)))
	var/mob/living/carbon/human/carbon_owner = owner
	carbon_owner.physiology.damage_resistance -= damage_resistance_subtraction
	carbon_owner.physiology.bleed_mod += bleed_modifier_addition
	return ..()

/datum/status_effect/vulnerable_to_damage/on_remove()
	to_chat(owner, span_notice(LANG("datum.9a20382d953632c2", null)))
	var/mob/living/carbon/human/carbon_recoverer = owner
	carbon_recoverer.physiology.damage_resistance += damage_resistance_subtraction
	carbon_recoverer.physiology.bleed_mod -= bleed_modifier_addition
	return ..()
