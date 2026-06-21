/obj/item/bodypart/arm/left/ghetto
	name = "左木桩手臂"
	desc = "一根粗削的木桩取代了本应是前臂的位置。它简单而坚固，显然是匆忙用随手可得的材料制成的。尽管外观粗糙，但足以完成工作。"
	icon = 'icons/mob/human/species/ghetto.dmi'
	icon_static = 'icons/mob/human/species/ghetto.dmi'
	limb_id = BODYPART_ID_PEG
	icon_state = "peg_l_arm"
	bodytype = BODYTYPE_PEG
	should_draw_greyscale = FALSE
	attack_verb_simple = list("bashed", "slashed")
	unarmed_damage_low = 3
	unarmed_damage_high = 9
	unarmed_effectiveness = 5
	brute_modifier = 1.2
	burn_modifier = 1.5
	bodypart_traits = list(TRAIT_CHUNKYFINGERS)
	disabling_threshold_percentage = 1
	bodypart_flags = BODYPART_UNHUSKABLE
	biological_state = (BIO_WOOD|BIO_JOINTED)
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 2)
	butcher_replacement = null

/obj/item/bodypart/arm/left/ghetto/Initialize(mapload, ...)
	. = ..()
	ADD_TRAIT(src, TRAIT_EASY_ATTACH, INNATE_TRAIT)

/obj/item/bodypart/arm/right/ghetto
	name = "右木桩手臂"
	desc = "一根粗削的木桩取代了前臂应有的位置。它简单而坚固，显然是匆忙间用随手可得的材料制成的。尽管外观粗糙，但能派上用场。"
	icon = 'icons/mob/human/species/ghetto.dmi'
	icon_static = 'icons/mob/human/species/ghetto.dmi'
	limb_id = BODYPART_ID_PEG
	icon_state = "peg_r_arm"
	bodytype = BODYTYPE_PEG
	should_draw_greyscale = FALSE
	attack_verb_simple = list("bashed", "slashed")
	unarmed_damage_low = 3
	unarmed_damage_high = 9
	unarmed_effectiveness = 5
	brute_modifier = 1.2
	burn_modifier = 1.5
	bodypart_traits = list(TRAIT_CHUNKYFINGERS)
	disabling_threshold_percentage = 1
	bodypart_flags = BODYPART_UNHUSKABLE
	biological_state = (BIO_WOOD|BIO_JOINTED)
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 2)
	butcher_replacement = null

/obj/item/bodypart/arm/right/ghetto/Initialize(mapload, ...)
	. = ..()
	ADD_TRAIT(src, TRAIT_EASY_ATTACH, INNATE_TRAIT)

/obj/item/bodypart/leg/left/ghetto
	name = "左木腿"
	desc = "Fashioned from what looks suspiciously like a table leg, this peg leg brings a whole new meaning to 'dining on the go.' It's a bit wobbly and creaks ominously with every step, but at least you can claim to have the most well-balanced diet on the seven seas."
	icon = 'icons/mob/human/species/ghetto.dmi'
	icon_static = 'icons/mob/human/species/ghetto.dmi'
	limb_id = BODYPART_ID_PEG
	icon_state = "peg_l_leg"
	bodytype = BODYTYPE_PEG
	should_draw_greyscale = FALSE
	unarmed_damage_low = 2
	unarmed_damage_high = 5
	unarmed_effectiveness = 10
	brute_modifier = 1.2
	burn_modifier = 1.5
	disabling_threshold_percentage = 1
	bodypart_flags = BODYPART_UNHUSKABLE
	biological_state = (BIO_WOOD|BIO_JOINTED)
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 2)
	butcher_replacement = null

/obj/item/bodypart/leg/left/ghetto/Initialize(mapload, ...)
	. = ..()
	ADD_TRAIT(src, TRAIT_EASY_ATTACH, INNATE_TRAIT)

/obj/item/bodypart/leg/right/ghetto
	name = "右木腿"
	desc = "Fashioned from what looks suspiciously like a table leg, this peg leg brings a whole new meaning to 'dining on the go.' It's a bit wobbly and creaks ominously with every step, but at least you can claim to have the most well-balanced diet on the seven seas."
	icon = 'icons/mob/human/species/ghetto.dmi'
	icon_static = 'icons/mob/human/species/ghetto.dmi'
	limb_id = BODYPART_ID_PEG
	icon_state = "peg_r_leg"
	bodytype = BODYTYPE_PEG
	should_draw_greyscale = FALSE
	unarmed_damage_low = 2
	unarmed_damage_high = 5
	unarmed_effectiveness = 10
	brute_modifier = 1.2
	burn_modifier = 1.5
	disabling_threshold_percentage = 1
	bodypart_flags = BODYPART_UNHUSKABLE
	biological_state = (BIO_WOOD|BIO_JOINTED)
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 2)
	butcher_replacement = null

/obj/item/bodypart/leg/right/ghetto/Initialize(mapload, ...)
	. = ..()
	ADD_TRAIT(src, TRAIT_EASY_ATTACH, INNATE_TRAIT)
