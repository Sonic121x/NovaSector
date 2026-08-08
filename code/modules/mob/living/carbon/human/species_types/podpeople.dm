// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/species/pod
	// A mutation caused by a human being ressurected in a revival pod. These regain health in light, and begin to wither in darkness.
	name = "\improper Podperson"
	plural_form = "Podpeople"
	id = SPECIES_PODPERSON
	inherent_traits = list(
		TRAIT_MUTANT_COLORS,
		TRAIT_PLANT_SAFE,
		TRAIT_REQUIRED_ADV_HEALTH_SCANNER,
	)
	mutant_organs = list(
		/obj/item/organ/pod_hair = "None",
	)
	inherent_biotypes = MOB_ORGANIC | MOB_HUMANOID | MOB_PLANT
	inherent_factions = list(FACTION_PLANTS, FACTION_VINES)

	heatmod = 1.5
	payday_modifier = 1.0
	meat = /obj/item/food/meat/slab/human/mutant/plant
	exotic_bloodtype = BLOOD_TYPE_H2O
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | RACE_SWAP | ERT_SPAWN | SLIME_EXTRACT
	species_language_holder = /datum/language_holder/plant

	mutantappendix = /obj/item/organ/appendix/pod
	mutantbrain = /obj/item/organ/brain/pod
	mutantears = /obj/item/organ/ears/pod
	mutanteyes = /obj/item/organ/eyes/pod
	mutantheart = /obj/item/organ/heart/pod
	mutantliver = /obj/item/organ/liver/pod
	mutantlungs = /obj/item/organ/lungs/pod
	mutantstomach = /obj/item/organ/stomach/pod
	mutanttongue = /obj/item/organ/tongue/pod

	bodypart_overrides = list(
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/pod,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/pod,
		BODY_ZONE_HEAD = /obj/item/bodypart/head/pod,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/pod,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/pod,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/pod,
	)

/datum/species/pod/prepare_human_for_preview(mob/living/carbon/human/human)
	human.dna.features[FEATURE_MUTANT_COLOR] = "#886600"
	human.dna.features[FEATURE_POD_HAIR] = "Rose"
	human.update_body(is_creating = TRUE)

/datum/species/pod/get_physical_attributes()
	return "Podpeople are in many ways the inverse of shadows, healing in light and starving with the dark. \
		Their bodies are like tinder and easy to char."

/datum/species/pod/get_species_description()
	return "Podpeople are largely peaceful plant based lifeforms, resembling a humanoid figure made of leaves, flowers, and vines."

/datum/species/pod/get_species_lore()
	return list(
		"Not much is known about the origins of the Podpeople. \
		Many assume them to be the result of a long forgotten botanical experiment, slowly mutating for years on years until they became the beings they are today. \
		Ever since they were uncovered long ago, their kind have been found on board stations and planets across the galaxy, \
		often working in hydroponics bays, kitchens, or science departments, working with plants and other botanical lifeforms.",
	)

/datum/species/pod/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
		SPECIES_PERK_ICON = "lightbulb",
		SPECIES_PERK_NAME = LANG("datum.6510b188", null),
		SPECIES_PERK_DESC = LANG("datum.87c94bb3", null)
	))

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = "biohazard",
		SPECIES_PERK_NAME = LANG("datum.2b40f90f", null),
		SPECIES_PERK_DESC = LANG("datum.084b9148", null)
	))

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = "briefcase-medical",
		SPECIES_PERK_NAME = LANG("datum.9193e046", null),
		SPECIES_PERK_DESC = LANG("datum.b9477286", null)
	))

	return to_add
