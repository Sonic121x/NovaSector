/datum/species/ethereal/on_species_gain(mob/living/carbon/human/new_ethereal, datum/species/old_species, pref_load, regenerate_icons)
	. = ..()
	var/datum/action/sing_tones/sing_action = new
	sing_action.Grant(new_ethereal)

/datum/species/ethereal/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "bolt",
			SPECIES_PERK_NAME = LANG("datum.565fa59846a46368", null),
			SPECIES_PERK_DESC = LANG("datum.4f7bc8f907771db5", null),
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "lightbulb",
			SPECIES_PERK_NAME = LANG("datum.795ea640d1ef6a1c", null),
			SPECIES_PERK_DESC = LANG("datum.efb60e737af43a32", null),
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "music",
			SPECIES_PERK_NAME = LANG("datum.276735f4e767a7ca", null),
			SPECIES_PERK_DESC = LANG("datum.c2b7252e34fa4e20", null),
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
			SPECIES_PERK_ICON = "gem",
			SPECIES_PERK_NAME = LANG("datum.5cd3b29322cadb9d", null),
			SPECIES_PERK_DESC = LANG("datum.d15bf4a440b74f31", null),
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
			SPECIES_PERK_ICON = "fist-raised",
			SPECIES_PERK_NAME = LANG("datum.35f196932b495c75", null),
			SPECIES_PERK_DESC = LANG("datum.734d0fe9f6f2d895", null),
		),
	)

	return to_add
