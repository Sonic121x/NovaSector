/*
/ Synthetic Species Limbs.
/ Modularizes the Synth limbs off of the /robot/ limb side to no longer interfere with augments.
/ Ensure Augment list does not populate these, they will not be balanced for indidivual limb gain.
*/


/// Damage to LIMB modifier defines
#define SYNTH_BRUTE_MODIFIER 1.0
#define SYNTH_BURN_MODIFIER 1.0

/// Exmaine text for Synth limb damage
#define SYNTH_LIGHT_BRUTE_MSG "marred"
#define SYNTH_MEDIUM_BRUTE_MSG "dented"
#define SYNTH_HEAVY_BRUTE_MSG "falling apart"

#define SYNTH_LIGHT_BURN_MSG "scorched"
#define SYNTH_MEDIUM_BURN_MSG "charred"
#define SYNTH_HEAVY_BURN_MSG "smoldering"

// Synth bois!
/obj/item/bodypart/head/synth
	name = "仿生人头"
	desc = "一个仿生人头部标准基座，内部装有各种摄像头和传感器，并有一个可选的正电子接口插槽。"
	inhand_icon_state = "buildpipe"
	icon_static = BODYPART_ICON_IPC
	icon = BODYPART_ICON_IPC
	limb_id = SPECIES_SYNTH
	obj_flags = CONDUCTS_ELECTRICITY
	icon_state = "synth_head"
	is_dimorphic = FALSE
	should_draw_greyscale = TRUE
	icon_greyscale = BODYPART_ICON_IPC
	bodytype = BODYTYPE_ROBOTIC | BODYTYPE_SYNTHETIC
	bodyshape = BODYSHAPE_HUMANOID
	change_exempt_flags = NONE
	dmg_overlay_type = "robotic"

	brute_modifier = SYNTH_BRUTE_MODIFIER
	burn_modifier = SYNTH_BURN_MODIFIER

	light_brute_msg = SYNTH_LIGHT_BRUTE_MSG
	medium_brute_msg = SYNTH_MEDIUM_BRUTE_MSG
	heavy_brute_msg = SYNTH_HEAVY_BRUTE_MSG

	light_burn_msg = SYNTH_LIGHT_BURN_MSG
	medium_burn_msg = SYNTH_MEDIUM_BURN_MSG
	heavy_burn_msg = SYNTH_HEAVY_BURN_MSG

	biological_state = (BIO_ROBOTIC)

	damage_examines = list(
		BRUTE = ROBOTIC_BRUTE_EXAMINE_TEXT,
		BURN = ROBOTIC_BURN_EXAMINE_TEXT,
	)

	bodypart_flags = BODYPART_UNHUSKABLE
	head_flags = HEAD_HAIR|HEAD_FACIAL_HAIR|HEAD_LIPS|HEAD_EYESPRITES|HEAD_EYECOLOR|HEAD_EYEHOLES // All the default flags minus HEAD_DEBRAIN

/datum/design/synth_head
	name = "仿生人头基座"
	id = "synth_head"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 4 SECONDS
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 1.25,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/bodypart/head/synth
	category = list(
		RND_SUBCATEGORY_MECHFAB_ANDROID + RND_SUBCATEGORY_MECHFAB_ANDROID_CHASSIS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/// Synth Chest, custom EMP effects go here to avoid stacking multiple. If they're alive they'll always have this, the rest go to organs.
// Restrict to Synths only to avoid Mind related issues
/obj/item/bodypart/chest/synth
	name = "仿生人躯干"
	desc = "为仿生人设计的、高度定制的机器人躯干，其中心的装甲核心容纳着它们的逻辑核心。"
	inhand_icon_state = "buildpipe"
	icon_static = BODYPART_ICON_IPC
	icon = BODYPART_ICON_IPC
	limb_id = SPECIES_SYNTH
	obj_flags = CONDUCTS_ELECTRICITY
	icon_state = "synth_chest"
	is_dimorphic = FALSE
	icon_greyscale = BODYPART_ICON_IPC
	should_draw_greyscale = TRUE
	bodytype = BODYTYPE_ROBOTIC | BODYTYPE_SYNTHETIC
	bodyshape = BODYSHAPE_HUMANOID
	change_exempt_flags = NONE
	dmg_overlay_type = "robotic"

	brute_modifier = SYNTH_BRUTE_MODIFIER
	burn_modifier = SYNTH_BURN_MODIFIER

	light_brute_msg = SYNTH_LIGHT_BRUTE_MSG
	medium_brute_msg = SYNTH_MEDIUM_BRUTE_MSG
	heavy_brute_msg = SYNTH_HEAVY_BRUTE_MSG

	light_burn_msg = SYNTH_LIGHT_BURN_MSG
	medium_burn_msg = SYNTH_MEDIUM_BURN_MSG
	heavy_burn_msg = SYNTH_HEAVY_BURN_MSG

	biological_state = (BIO_ROBOTIC)

	damage_examines = list(
		BRUTE = ROBOTIC_BRUTE_EXAMINE_TEXT,
		BURN = ROBOTIC_BURN_EXAMINE_TEXT
	)
	bodypart_flags = BODYPART_UNHUSKABLE

	wing_types = list(
		/obj/item/organ/wings/functional/robotic,
	)

/datum/design/synth_chest
	name = "仿生人躯干基座"
	id = "synth_chest"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 4 SECONDS
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 3.25,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/bodypart/chest/synth
	category = list(
		RND_SUBCATEGORY_MECHFAB_ANDROID + RND_SUBCATEGORY_MECHFAB_ANDROID_CHASSIS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/obj/item/bodypart/chest/synth/proc/check_limbs()
	SIGNAL_HANDLER

	var/all_robotic = TRUE
	for(var/obj/item/bodypart/part in owner.bodyparts)
		all_robotic = all_robotic && IS_ROBOTIC_LIMB(part)

	if(all_robotic)
		owner.add_traits(list(
			TRAIT_RESISTLOWPRESSURE,
			TRAIT_RESISTHIGHPRESSURE,
		))
	else
		owner.remove_traits(list(
			TRAIT_RESISTLOWPRESSURE,
			TRAIT_RESISTHIGHPRESSURE,
		))

/// Add: Slowdown, Confusion - Think Watchers Gaze flash
/obj/item/bodypart/chest/synth/emp_effect(severity, protection)
	. = ..()
	if(!. || isnull(owner))
		return

	switch(severity)
		if(EMP_HEAVY)
			owner.set_jitter_if_lower(SYNTH_BAD_EFFECT_DURATION * SYNTH_HEAVY_EMP_MULTIPLIER)
			owner.set_dizzy_if_lower(SYNTH_BAD_EFFECT_DURATION * SYNTH_HEAVY_EMP_MULTIPLIER)
			owner.set_derpspeech_if_lower(SYNTH_BAD_EFFECT_DURATION * SYNTH_HEAVY_EMP_MULTIPLIER)
			owner.set_confusion_if_lower(SYNTH_BAD_EFFECT_DURATION * 0.5)

		if(EMP_LIGHT)
			owner.set_jitter_if_lower(SYNTH_BAD_EFFECT_DURATION)
			owner.set_dizzy_if_lower(SYNTH_BAD_EFFECT_DURATION)
			owner.set_derpspeech_if_lower(SYNTH_BAD_EFFECT_DURATION)
			owner.set_confusion_if_lower(SYNTH_BAD_EFFECT_DURATION * 0.25)


/obj/item/bodypart/arm/left/synth
	name = "仿生人左臂"
	desc = "为仿生人设计的定制肢体，其可定制程度取决于你的钱包。"
	limb_id = SPECIES_SYNTH
	attack_verb_simple = list("slapped", "punched")
	inhand_icon_state = "buildpipe"
	icon_static = BODYPART_ICON_IPC
	icon = BODYPART_ICON_IPC
	obj_flags = CONDUCTS_ELECTRICITY
	icon_state = "synth_l_arm"
	is_dimorphic = FALSE
	icon_greyscale = BODYPART_ICON_IPC
	should_draw_greyscale = TRUE
	bodytype = BODYTYPE_ROBOTIC | BODYTYPE_SYNTHETIC
	bodyshape = BODYSHAPE_HUMANOID
	change_exempt_flags = NONE
	dmg_overlay_type = "robotic"

	brute_modifier = SYNTH_BRUTE_MODIFIER
	burn_modifier = SYNTH_BURN_MODIFIER

	light_brute_msg = SYNTH_LIGHT_BRUTE_MSG
	medium_brute_msg = SYNTH_MEDIUM_BRUTE_MSG
	heavy_brute_msg = SYNTH_HEAVY_BRUTE_MSG

	light_burn_msg = SYNTH_LIGHT_BURN_MSG
	medium_burn_msg = SYNTH_MEDIUM_BURN_MSG
	heavy_burn_msg = SYNTH_HEAVY_BURN_MSG

	biological_state = (BIO_ROBOTIC|BIO_JOINTED)

	damage_examines = list(
		BRUTE = ROBOTIC_BRUTE_EXAMINE_TEXT,
		BURN = ROBOTIC_BURN_EXAMINE_TEXT,
	)
	disabling_threshold_percentage = 1
	bodypart_flags = BODYPART_UNHUSKABLE

/datum/design/synth_l_arm
	name = "仿生人左臂基座"
	id = "synth_l_arm"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 4 SECONDS
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/bodypart/arm/left/synth
	category = list(
		RND_SUBCATEGORY_MECHFAB_ANDROID + RND_SUBCATEGORY_MECHFAB_ANDROID_CHASSIS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/obj/item/bodypart/arm/right/synth
	name = "仿生人右臂"
	desc = "为仿生人设计的定制肢体，其可定制程度取决于你的钱包。"
	attack_verb_simple = list("slapped", "punched")
	inhand_icon_state = "buildpipe"
	icon_static = BODYPART_ICON_IPC
	icon = BODYPART_ICON_IPC
	limb_id = SPECIES_SYNTH
	obj_flags = CONDUCTS_ELECTRICITY
	icon_state = "synth_r_arm"
	is_dimorphic = FALSE
	icon_greyscale = BODYPART_ICON_IPC
	should_draw_greyscale = TRUE
	bodytype = BODYTYPE_ROBOTIC | BODYTYPE_SYNTHETIC
	bodyshape = BODYSHAPE_HUMANOID
	change_exempt_flags = NONE
	dmg_overlay_type = "robotic"

	brute_modifier = SYNTH_BRUTE_MODIFIER
	burn_modifier = SYNTH_BURN_MODIFIER

	disabling_threshold_percentage = 1

	light_brute_msg = SYNTH_LIGHT_BRUTE_MSG
	medium_brute_msg = SYNTH_MEDIUM_BRUTE_MSG
	heavy_brute_msg = SYNTH_HEAVY_BRUTE_MSG

	light_burn_msg = SYNTH_LIGHT_BURN_MSG
	medium_burn_msg = SYNTH_MEDIUM_BURN_MSG
	heavy_burn_msg = SYNTH_HEAVY_BURN_MSG

	biological_state = (BIO_ROBOTIC|BIO_JOINTED)

	damage_examines = list(
		BRUTE = ROBOTIC_BRUTE_EXAMINE_TEXT,
		BURN = ROBOTIC_BURN_EXAMINE_TEXT,
	)
	bodypart_flags = BODYPART_UNHUSKABLE

/datum/design/synth_r_arm
	name = "仿生人右臂基座"
	id = "synth_r_arm"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 4 SECONDS
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/bodypart/arm/right/synth
	category = list(
		RND_SUBCATEGORY_MECHFAB_ANDROID + RND_SUBCATEGORY_MECHFAB_ANDROID_CHASSIS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/obj/item/bodypart/leg/left/synth
	name = "仿生人左腿"
	desc = "为仿生人设计的定制腿部，其可定制程度取决于你的钱包。"
	attack_verb_simple = list("kicked", "stomped")
	inhand_icon_state = "buildpipe"
	icon_static = BODYPART_ICON_IPC
	icon = BODYPART_ICON_IPC
	limb_id = SPECIES_SYNTH
	obj_flags = CONDUCTS_ELECTRICITY
	icon_state = "synth_l_leg"
	is_dimorphic = FALSE
	icon_greyscale = BODYPART_ICON_IPC
	should_draw_greyscale = TRUE
	digitigrade_type = /obj/item/bodypart/leg/left/synth/digitigrade
	bodytype = BODYTYPE_ROBOTIC | BODYTYPE_SYNTHETIC
	bodyshape = BODYSHAPE_HUMANOID
	change_exempt_flags = NONE
	dmg_overlay_type = "robotic"

	brute_modifier = SYNTH_BRUTE_MODIFIER
	burn_modifier = SYNTH_BURN_MODIFIER

	disabling_threshold_percentage = 1

	light_brute_msg = SYNTH_LIGHT_BRUTE_MSG
	medium_brute_msg = SYNTH_MEDIUM_BRUTE_MSG
	heavy_brute_msg = SYNTH_HEAVY_BRUTE_MSG

	light_burn_msg = SYNTH_LIGHT_BURN_MSG
	medium_burn_msg = SYNTH_MEDIUM_BURN_MSG
	heavy_burn_msg = SYNTH_HEAVY_BURN_MSG

	biological_state = (BIO_ROBOTIC|BIO_JOINTED)

	damage_examines = list(
		BRUTE = ROBOTIC_BRUTE_EXAMINE_TEXT,
		BURN = ROBOTIC_BURN_EXAMINE_TEXT,
	)
	bodypart_flags = BODYPART_UNHUSKABLE

/datum/design/synth_l_leg
	name = "仿生人跖行左腿基座"
	id = "synth_l_leg"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 4 SECONDS
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 3,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT * 2,
	)
	build_path = /obj/item/bodypart/leg/left/synth
	category = list(
		RND_SUBCATEGORY_MECHFAB_ANDROID + RND_SUBCATEGORY_MECHFAB_ANDROID_CHASSIS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/obj/item/bodypart/leg/right/synth
	name = "仿生人右腿"
	desc = "为仿生人设计的定制腿部，其可定制程度取决于你的钱包。"
	attack_verb_simple = list("kicked", "stomped")
	inhand_icon_state = "buildpipe"
	icon_static = BODYPART_ICON_IPC
	icon = BODYPART_ICON_IPC
	limb_id = SPECIES_SYNTH
	obj_flags = CONDUCTS_ELECTRICITY
	icon_state = "synth_r_leg"
	is_dimorphic = FALSE
	icon_greyscale = BODYPART_ICON_IPC
	should_draw_greyscale = TRUE
	digitigrade_type = /obj/item/bodypart/leg/right/synth/digitigrade
	bodytype = BODYTYPE_ROBOTIC | BODYTYPE_SYNTHETIC
	bodyshape = BODYSHAPE_HUMANOID
	change_exempt_flags = NONE
	dmg_overlay_type = "robotic"

	brute_modifier = SYNTH_BRUTE_MODIFIER
	burn_modifier = SYNTH_BURN_MODIFIER

	disabling_threshold_percentage = 1

	light_brute_msg = SYNTH_LIGHT_BRUTE_MSG
	medium_brute_msg = SYNTH_MEDIUM_BRUTE_MSG
	heavy_brute_msg = SYNTH_HEAVY_BRUTE_MSG

	light_burn_msg = SYNTH_LIGHT_BURN_MSG
	medium_burn_msg = SYNTH_MEDIUM_BURN_MSG
	heavy_burn_msg = SYNTH_HEAVY_BURN_MSG

	biological_state = (BIO_ROBOTIC|BIO_JOINTED)

	damage_examines = list(
		BRUTE = ROBOTIC_BRUTE_EXAMINE_TEXT,
		BURN = ROBOTIC_BURN_EXAMINE_TEXT,
	)
	bodypart_flags = BODYPART_UNHUSKABLE

/datum/design/synth_r_leg
	name = "仿生人跖行右腿基座"
	id = "synth_r_leg"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 4 SECONDS
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 3,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT * 2,
	)
	build_path = /obj/item/bodypart/leg/right/synth
	category = list(
		RND_SUBCATEGORY_MECHFAB_ANDROID + RND_SUBCATEGORY_MECHFAB_ANDROID_CHASSIS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/obj/item/bodypart/leg/left/synth/digitigrade
	icon_greyscale = BODYPART_ICON_SYNTHLIZARD
	limb_id = "synthliz"
	bodyshape = parent_type::bodyshape | BODYSHAPE_DIGITIGRADE

/datum/design/synth_l_d_leg
	name = "仿生人趾行左腿基座"
	id = "synth_l_d_leg"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 4 SECONDS
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 3,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT * 2,
	)
	build_path = /obj/item/bodypart/leg/left/synth/digitigrade
	category = list(
		RND_SUBCATEGORY_MECHFAB_ANDROID + RND_SUBCATEGORY_MECHFAB_ANDROID_CHASSIS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/obj/item/bodypart/leg/right/synth/digitigrade
	icon_greyscale = BODYPART_ICON_SYNTHLIZARD
	limb_id = "synthliz"
	bodyshape = parent_type::bodyshape | BODYSHAPE_DIGITIGRADE

/datum/design/synth_r_d_leg
	name = "仿生人趾行右腿基座"
	id = "synth_r_d_leg"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 4 SECONDS
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 3,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT * 2,
	)
	build_path = /obj/item/bodypart/leg/right/synth/digitigrade
	category = list(
		RND_SUBCATEGORY_MECHFAB_ANDROID + RND_SUBCATEGORY_MECHFAB_ANDROID_CHASSIS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

#undef SYNTH_BRUTE_MODIFIER
#undef SYNTH_BURN_MODIFIER

#undef SYNTH_LIGHT_BRUTE_MSG
#undef SYNTH_MEDIUM_BRUTE_MSG
#undef SYNTH_HEAVY_BRUTE_MSG

#undef SYNTH_LIGHT_BURN_MSG
#undef SYNTH_MEDIUM_BURN_MSG
#undef SYNTH_HEAVY_BURN_MSG
