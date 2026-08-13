/datum/quirk/death_consequences
	name = DEATH_CONSEQUENCES_QUIRK_NAME
	desc = "Every time you die, your body suffers long-term damage that can't easily be repaired."
	medical_record_text = DEATH_CONSEQUENCES_QUIRK_DESC
	icon = FA_ICON_DNA
	value = 0 // due to its high customization, you can make it really inconsequential

/datum/quirk_constant_data/death_consequences
	associated_typepath = /datum/quirk/death_consequences

/datum/quirk_constant_data/death_consequences/New()
	customization_options = (subtypesof(/datum/preference/numeric/death_consequences) + subtypesof(/datum/preference/toggle/death_consequences))

	return ..()

/datum/quirk/death_consequences/add(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.gain_trauma(/datum/brain_trauma/severe/death_consequences, TRAUMA_RESILIENCE_ABSOLUTE)
	var/datum/brain_trauma/severe/death_consequences/added_trauma = human_holder.get_death_consequences_trauma()
	if (!isnull(added_trauma))
		added_trauma.update_variables(client_source)

	to_chat(human_holder, span_danger(LANG("datum.75e124ab", list(src))))

/datum/quirk/death_consequences/remove()
	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.cure_trauma_type(/datum/brain_trauma/severe/death_consequences, TRAUMA_RESILIENCE_ABSOLUTE)

/// Adjusts the mob's linked death consequences trauma (see get_death_consequences_trauma())'s degradation by increment.
GAME_VERB(/mob, adjust_degradation, "调整死亡衰减", "IC")
	VERB_ARG(increment, VERB_ARG_TYPE_NUM, VERB_ARG_SOURCE_INPUT)
	if (isnull(mind))
		to_chat(usr, span_warning(LANG("mob.e1a30946", null)))
		return

	var/datum/brain_trauma/severe/death_consequences/linked_trauma = get_death_consequences_trauma()
	var/mob/living/carbon/trauma_holder = linked_trauma?.owner
	if (isnull(linked_trauma) || isnull(trauma_holder) || trauma_holder != mind.current) // sanity
		to_chat(usr, span_warning(LANG("mob.41a67073", null)))
		return

	if (!isnum(increment))
		to_chat(usr, span_warning(LANG("mob.c72df482", null)))
		return

	if (linked_trauma.permakill_if_at_max_degradation && ((linked_trauma.current_degradation + increment) >= linked_trauma.max_degradation))
		if (tgui_alert(usr, LANG("mob.badd68ff", null), LANG("mob.91bcab30", null), list("Yes", "No"), timeout = 7 SECONDS) != "Yes")
			return

	linked_trauma.adjust_degradation(increment)
	to_chat(usr, span_notice(LANG("mob.073eda80", null)))

/// Calls update_variables() on this mob's linked death consequences trauma. See that proc for further info.
GAME_VERB(/mob, refresh_death_consequences, "刷新死亡后果变量", "IC")
	if (isnull(mind))
		to_chat(usr, span_warning(LANG("mob.e1a30946", null)))
		return

	var/datum/brain_trauma/severe/death_consequences/linked_trauma = get_death_consequences_trauma()
	var/mob/living/carbon/trauma_holder = linked_trauma?.owner
	if (isnull(linked_trauma) || isnull(trauma_holder) || trauma_holder != mind.current) // sanity
		to_chat(usr, span_warning(LANG("mob.41a67073", null)))
		return

	linked_trauma.update_variables(client)
	to_chat(usr, span_notice(LANG("mob.9bf902e1", null)))

/// Searches mind.current for a death_consequences trauma. Allows this proc to be used on both ghosts and living beings to find their linked trauma.
/mob/proc/get_death_consequences_trauma()
	RETURN_TYPE(/datum/brain_trauma/severe/death_consequences)

	if (isnull(mind))
		return

	if (iscarbon(mind.current))
		var/mob/living/carbon/carbon_body = mind.current
		for (var/datum/brain_trauma/trauma as anything in carbon_body.get_traumas())
			if (istype(trauma, /datum/brain_trauma/severe/death_consequences))
				return trauma
	// else, return null
