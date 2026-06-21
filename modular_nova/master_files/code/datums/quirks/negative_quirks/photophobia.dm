/datum/quirk/photophobia
	desc = "出于某种原因，明亮的光线让你感到不适和心烦。你的眼睛总体上对光线也更敏感。这与夜视能力有独特的交互作用。"
	/// how much of a flash_protect deficit the quirk inflicts
	var/severity = 1

/datum/quirk/photophobia/add_unique(client/client_source)
	var/sensitivity = client_source?.prefs.read_preference(/datum/preference/choiced/photophobia_severity)
	switch (sensitivity)
		if ("Hypersensitive")
			severity = 2
		if ("Sensitive")
			severity = 1
	var/obj/item/organ/eyes/holder_eyes = quirk_holder.get_organ_slot(ORGAN_SLOT_EYES)
	restore_eyes(holder_eyes) // add_unique() happens after add() so we need to jank reset this to ensure sensitivity is properly applied at roundstart
	check_eyes(holder_eyes)

/datum/quirk_constant_data/photophobia
	associated_typepath = /datum/quirk/photophobia
	customization_options = list(/datum/preference/choiced/photophobia_severity)

/datum/preference/choiced/photophobia_severity
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "photophobia_severity"
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/choiced/photophobia_severity/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	return /datum/quirk/photophobia::name in preferences.all_quirks

/datum/preference/choiced/photophobia_severity/init_possible_values()
	var/list/values = list("Sensitive", "Hypersensitive")
	return values

/datum/preference/choiced/photophobia_severity/apply_to_human(mob/living/carbon/human/target, value)
	return

