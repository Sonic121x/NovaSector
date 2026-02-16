/obj/item/bodypart/head/lizard/reptilian
	icon_greyscale = 'modular_z121/icons/mob/sprite_accessory/reptilian/bodyparts.dmi'
	head_flags = HEAD_DEFAULT_FEATURES

/obj/item/bodypart/chest/lizard/reptilian
	icon_greyscale = 'modular_z121/icons/mob/sprite_accessory/reptilian/bodyparts.dmi'

/obj/item/bodypart/arm/left/lizard/reptilian
	icon_greyscale = 'modular_z121/icons/mob/sprite_accessory/reptilian/bodyparts.dmi'

/obj/item/bodypart/arm/right/lizard/reptilian
	icon_greyscale = 'modular_z121/icons/mob/sprite_accessory/reptilian/bodyparts.dmi'

/obj/item/bodypart/leg/left/lizard/reptilian
	icon_greyscale = 'modular_z121/icons/mob/sprite_accessory/reptilian/bodyparts.dmi'
	digitigrade_type = /obj/item/bodypart/leg/left/digitigrade/lizard/reptilian
	footprint_sprite = FOOTPRINT_SPRITE_CLAWS

/obj/item/bodypart/leg/right/lizard/reptilian
	icon_greyscale = 'modular_z121/icons/mob/sprite_accessory/reptilian/bodyparts.dmi'
	digitigrade_type = /obj/item/bodypart/leg/right/digitigrade/lizard/reptilian
	footprint_sprite = FOOTPRINT_SPRITE_CLAWS

/obj/item/bodypart/leg/left/digitigrade/lizard/reptilian
	icon_greyscale = 'modular_z121/icons/mob/sprite_accessory/reptilian/bodyparts.dmi'
	footprint_sprite = FOOTPRINT_SPRITE_CLAWS

/obj/item/bodypart/leg/right/digitigrade/lizard/reptilian
	icon_greyscale = 'modular_z121/icons/mob/sprite_accessory/reptilian/bodyparts.dmi'
	footprint_sprite = FOOTPRINT_SPRITE_CLAWS

//Lizard
/datum/augment_item/limb/head/species/mutant/lizard/reptilian
	name = "reptilian head"
	path = /obj/item/bodypart/head/lizard/reptilian

/datum/augment_item/limb/chest/species/mutant/lizard/reptilian
	name = "reptilian chest"
	path = /obj/item/bodypart/chest/lizard/reptilian

/datum/augment_item/limb/l_arm/species/mutant/lizard/reptilian
	name = "reptilian left arm"
	path = /obj/item/bodypart/arm/left/lizard/reptilian

/datum/augment_item/limb/r_arm/species/mutant/lizard/reptilian
	name = "reptilian right arm"
	path = /obj/item/bodypart/arm/right/lizard/reptilian

/datum/augment_item/limb/l_leg/species/mutant/lizard/reptilian
	name = "reptilian left leg"
	path = /obj/item/bodypart/leg/left/lizard/reptilian

/datum/augment_item/limb/r_leg/species/mutant/lizard/reptilian
	name = "reptilian right leg"
	path = /obj/item/bodypart/leg/right/lizard/reptilian

/datum/sprite_accessory/tails/lizard/reptilian
	icon = 'modular_z121/icons/mob/sprite_accessory/reptilian/bodyparts.dmi'
	recommended_species = list(SPECIES_LIZARD, SPECIES_LIZARD_ASH, SPECIES_MAMMAL, SPECIES_UNATHI, SPECIES_LIZARD_SILVER)
	organ_type = /obj/item/organ/tail/lizard

/datum/sprite_accessory/tails/lizard/reptilian/smooth
	name = "Reptilian Smooth"
	icon_state = "lizard_smooth"
	color_src = USE_MATRIXED_COLORS

/datum/sprite_accessory/snouts/Reptilian
	name = "Reptilian"
	icon = 'modular_z121/icons/mob/sprite_accessory/reptilian/bodyparts.dmi'
	icon_state = "reptilian"

/datum/body_marking/other/reptilian
	name = "Reptilian"
	icon = 'modular_z121/icons/mob/sprite_accessory/reptilian/bodyparts.dmi'
	recommended_species = null
	icon_state = "reptilian"
	default_color = "#555555"
	affected_bodyparts = HEAD | CHEST

	gendered = FALSE
