/obj/item/organ/tongue/synth
	name = "合成发声盒"
	desc = "一个功能齐全的合成舌头，包裹在柔软的硅胶中。特点包括高分辨率发声和味觉感受器。"
	icon = 'modular_nova/modules/organs/icons/cyber_tongue.dmi'
	icon_state = "cybertongue"
	say_mod = "beeps"
	attack_verb_continuous = list("beeps", "boops")
	attack_verb_simple = list("beep", "boop")
	modifies_speech = TRUE
	taste_sensitivity = 25 // not as good as an organic tongue
	liked_foodtypes = NONE
	disliked_foodtypes = NONE
	maxHealth = 100 //RoboTongue!
	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_TONGUE
	organ_flags = ORGAN_ROBOTIC | ORGAN_SYNTHETIC_FROM_SPECIES

/obj/item/organ/tongue/synth/can_speak_language(language)
	return TRUE

/obj/item/organ/tongue/synth/handle_speech(datum/source, list/speech_args)
	speech_args[SPEECH_SPANS] |= SPAN_ROBOT

/datum/design/synth_tongue
	name = "合成舌头"
	desc = "一个功能齐全的合成舌头，包裹在柔软的硅胶中。特点包括高分辨率发声和味觉感受器。"
	id = "synth_tongue"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 4 SECONDS
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/organ/tongue/synth
	category = list(
		RND_SUBCATEGORY_MECHFAB_ANDROID + RND_SUBCATEGORY_MECHFAB_ANDROID_ORGANS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE
