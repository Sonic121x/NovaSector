// LOADOUT ITEM DATUMS FOR THE EYES SLOT

/datum/loadout_item/glasses/pre_equip_item(datum/outfit/outfit, datum/outfit/outfit_important_for_life, mob/living/carbon/human/equipper, visuals_only = FALSE)
	if(initial(outfit_important_for_life.glasses))
		.. ()
		return TRUE

/datum/loadout_item/glasses/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE, override_items = LOADOUT_OVERRIDE_BACKPACK)
	if(override_items == LOADOUT_OVERRIDE_BACKPACK && !visuals_only)
		if(outfit.glasses)
			LAZYADD(outfit.backpack_contents, outfit.glasses)
		outfit.glasses = item_path
	else
		outfit.glasses = item_path

/datum/loadout_item/glasses/post_equip_item(datum/preferences/preference_source, mob/living/carbon/human/equipper)
	var/obj/item/clothing/glasses/equipped_glasses = locate(item_path) in equipper.get_equipped_items()
	if (!equipped_glasses)
		return
	if(equipped_glasses.tint)
		equipper.update_tint()
	if(equipped_glasses.vision_flags \
		|| equipped_glasses.invis_override \
		|| equipped_glasses.invis_view \
		|| !isnull(equipped_glasses.color_cutoffs))
		equipper.update_sight()

/*
*	ITEMS BELOW HERE
*/
/datum/loadout_item/glasses/nightmare
	name = "Nightmare Goggles"
	item_path = /obj/item/clothing/glasses/nightmare_vision

/datum/loadout_item/glasses/welding_goggles
	name = "Welding Goggles"
	item_path = /obj/item/clothing/glasses/welding
	blacklisted_roles = list(JOB_PRISONER)

/datum/loadout_item/glasses/biker
	name = "机车护目镜"
	item_path = /obj/item/clothing/glasses/biker

/datum/loadout_item/glasses/retinal_projector
	name = "民用视网膜投影仪"
	item_path = /obj/item/clothing/glasses/hud/ar/projector

/datum/loadout_item/glasses/aviator_fake
	name = "仿制飞行员墨镜"
	item_path = /obj/item/clothing/glasses/fake_sunglasses/aviator

/datum/loadout_item/glasses/geist_glasses
	name = "幽魂凝视镜"
	item_path = /obj/item/clothing/glasses/geist_gazers

/datum/loadout_item/glasses/osi
	name = "OSI眼镜"
	item_path = /obj/item/clothing/glasses/osi

/datum/loadout_item/glasses/phantom
	name = "幻影眼镜"
	item_path = /obj/item/clothing/glasses/phantom

/datum/loadout_item/glasses/psych_glasses
	name = "精神眼镜"
	item_path = /obj/item/clothing/glasses/psych

/*
 *	PRESCRIPTION GLASSES
 */

/datum/loadout_item/glasses/regular
	//"Glasses"
	group = "Prescription"

/datum/loadout_item/glasses/kim
	name = "双筒望远镜式眼镜"
	group = "Prescription"

/datum/loadout_item/glasses/circle_glasses
	//"Circle Glasses"
	group = "Prescription"

/datum/loadout_item/glasses/hipster_glasses
	//"Hipster Glasses"
	group = "Prescription"

/datum/loadout_item/glasses/jamjar_glasses
	//"Jamjar Glasses"
	group = "Prescription"

/datum/loadout_item/glasses/better
	name = "现代眼镜"
	item_path = /obj/item/clothing/glasses/regular/modern
	reskin_datum = /datum/atom_skin/modern_glasses
	group = "Prescription"

/datum/loadout_item/glasses/thin
	name = "细框眼镜"
	item_path = /obj/item/clothing/glasses/regular/thin
	group = "Prescription"

/*
*	Eyepatches/Blindfolds
*/

/datum/loadout_item/glasses/white_eyepatch
	name = "眼罩（白色）"
	item_path = /obj/item/clothing/glasses/eyepatch/white

/datum/loadout_item/glasses/medical_eyepatch
	name = "眼罩 - 医疗"
	item_path = /obj/item/clothing/glasses/eyepatch/medical

/datum/loadout_item/glasses/eyewrap
	name = "眼罩 - 缠绕式"
	item_path = /obj/item/clothing/glasses/eyepatch/wrap

/datum/loadout_item/glasses/blindfold
	name = "眼罩"
	item_path = /obj/item/clothing/glasses/blindfold

/datum/loadout_item/glasses/blindfold/color
	name = "眼罩 - 致盲人员"
	item_path = /obj/item/clothing/glasses/blindfold/color

/datum/loadout_item/glasses/fakeblindfold
	name = "眼罩 - 伪装"
	item_path = /obj/item/clothing/glasses/trickblindfold

/datum/loadout_item/glasses/obsoleteblindfold
	name = "眼罩 - 过时HUD"
	item_path = /obj/item/clothing/glasses/trickblindfold/obsolete

/*
 *	JOB-LOCKED
*/

//Diagnostic
/datum/loadout_item/glasses/robopatch
	name = "诊断HUD - 眼罩式"
	item_path = /obj/item/clothing/glasses/hud/eyepatch/diagnostic
	restricted_roles = list(ALL_JOBS_SCI)
	group = "Job-Locked"

/datum/loadout_item/glasses/diaghud_glasses
	name = "诊断HUD - 处方镜"
	item_path = /obj/item/clothing/glasses/hud/diagnostic/prescription
	restricted_roles = list(ALL_JOBS_SCI)
	group = "Job-Locked"

/datum/loadout_item/glasses/prescription_aviator_diagnostic
	name = "诊断HUD - 处方太阳镜"
	item_path = /obj/item/clothing/glasses/hud/ar/aviator/diagnostic/prescription
	restricted_roles = list(ALL_JOBS_SCI)
	group = "Job-Locked"

/datum/loadout_item/glasses/aviator_diagnostic
	name = "诊断HUD - 太阳镜"
	item_path = /obj/item/clothing/glasses/hud/ar/aviator/diagnostic
	restricted_roles = list(ALL_JOBS_SCI)
	group = "Job-Locked"

/datum/loadout_item/glasses/retinal_projector_diagnostic
	name = "诊断HUD - 视网膜投影仪"
	item_path = /obj/item/clothing/glasses/hud/ar/projector/diagnostic
	restricted_roles = list(ALL_JOBS_SCI)
	group = "Job-Locked"

//Medical
/datum/loadout_item/glasses/medicpatch
	name = "医疗HUD - 眼罩式"
	item_path = /obj/item/clothing/glasses/hud/eyepatch/med
	restricted_roles = list(ALL_JOBS_MED)
	group = "Job-Locked"

/datum/loadout_item/glasses/medhud_glasses
	name = "医疗HUD - 处方镜"
	item_path = /obj/item/clothing/glasses/hud/health/prescription
	restricted_roles = list(ALL_JOBS_MED)
	group = "Job-Locked"

/datum/loadout_item/glasses/prescription_aviator_health
	name = "医疗HUD - 处方太阳镜"
	item_path = /obj/item/clothing/glasses/hud/ar/aviator/health/prescription
	restricted_roles = list(ALL_JOBS_MED)
	group = "Job-Locked"

/datum/loadout_item/glasses/aviator_health
	name = "医疗HUD - 太阳镜"
	item_path = /obj/item/clothing/glasses/hud/ar/aviator/health
	restricted_roles = list(ALL_JOBS_MED)
	group = "Job-Locked"

/datum/loadout_item/glasses/retinal_projector_health
	name = "医疗HUD - 视网膜投影仪"
	item_path = /obj/item/clothing/glasses/hud/ar/projector/health
	restricted_roles = list(ALL_JOBS_MED)
	group = "Job-Locked"

//Meson
/datum/loadout_item/glasses/mesonpatch
	name = "透视HUD - 眼罩"
	item_path = /obj/item/clothing/glasses/hud/eyepatch/meson
	restricted_roles = list(ALL_JOBS_CARGO, ALL_JOBS_ENGI)
	group = "Job-Locked"

/datum/loadout_item/glasses/meson_prescription
	name = "透视HUD - 处方镜"
	item_path = /obj/item/clothing/glasses/meson/prescription
	restricted_roles = list(ALL_JOBS_CARGO, ALL_JOBS_ENGI)
	reskin_datum = /datum/atom_skin/meson
	group = "Job-Locked"

/datum/loadout_item/glasses/prescription_aviator_meson
	name = "透视HUD - 处方太阳镜"
	item_path = /obj/item/clothing/glasses/hud/ar/aviator/meson/prescription
	restricted_roles = list(ALL_JOBS_CARGO, ALL_JOBS_ENGI)
	group = "Job-Locked"

/datum/loadout_item/glasses/aviator_meson
	name = "透视HUD - 太阳镜"
	item_path = /obj/item/clothing/glasses/hud/ar/aviator/meson
	restricted_roles = list(ALL_JOBS_CARGO, ALL_JOBS_ENGI)
	group = "Job-Locked"

/datum/loadout_item/glasses/retinal_projector_meson
	name = "透视HUD - 视网膜投影仪"
	item_path = /obj/item/clothing/glasses/hud/ar/projector/meson
	restricted_roles = list(ALL_JOBS_CARGO, ALL_JOBS_ENGI)
	group = "Job-Locked"

//Science
/datum/loadout_item/glasses/scipatch
	name = "科研HUD - 眼罩"
	item_path = /obj/item/clothing/glasses/hud/eyepatch/sci
	restricted_roles = list(ALL_JOBS_SCI, JOB_CHEMIST, JOB_VIROLOGIST)
	group = "Job-Locked"

/datum/loadout_item/glasses/science_glasses
	name = "科研HUD - 处方镜"
	item_path = /obj/item/clothing/glasses/science/prescription
	restricted_roles = list(ALL_JOBS_SCI, JOB_CHEMIST, JOB_VIROLOGIST)
	group = "Job-Locked"

/datum/loadout_item/glasses/prescription_aviator_science
	name = "科研HUD - 处方太阳镜"
	item_path = /obj/item/clothing/glasses/hud/ar/aviator/science/prescription
	restricted_roles = list(ALL_JOBS_SCI, JOB_CHEMIST, JOB_VIROLOGIST)
	group = "Job-Locked"

/datum/loadout_item/glasses/aviator_science
	name = "科研HUD - 太阳镜"
	item_path = /obj/item/clothing/glasses/hud/ar/aviator/science
	restricted_roles = list(ALL_JOBS_SCI, JOB_CHEMIST, JOB_VIROLOGIST)
	group = "Job-Locked"

/datum/loadout_item/glasses/retinal_projector_science
	name = "科研HUD - 视网膜投影仪"
	item_path = /obj/item/clothing/glasses/hud/ar/projector/science
	restricted_roles = list(ALL_JOBS_SCI, JOB_CHEMIST, JOB_VIROLOGIST)
	group = "Job-Locked"

//Security
/datum/loadout_item/glasses/sechud
	name = "安保HUD"
	item_path = /obj/item/clothing/glasses/hud/security
	restricted_roles = list(ALL_JOBS_DEPTGUARD, ALL_JOBS_SEC)
	group = "Job-Locked"

/datum/loadout_item/glasses/secpatch
	name = "安保HUD - 眼罩"
	item_path = /obj/item/clothing/glasses/hud/security/sunglasses/eyepatch
	restricted_roles = list(ALL_JOBS_DEPTGUARD, ALL_JOBS_SEC)
	group = "Job-Locked"

/datum/loadout_item/glasses/sechud_glasses
	name = "安保HUD - 处方镜"
	item_path = /obj/item/clothing/glasses/hud/security/prescription
	restricted_roles = list(ALL_JOBS_DEPTGUARD, ALL_JOBS_SEC)
	group = "Job-Locked"

/datum/loadout_item/glasses/prescription_aviator_security
	name = "安保HUD - 处方太阳镜"
	item_path = /obj/item/clothing/glasses/hud/ar/aviator/security/prescription
	restricted_roles = list(ALL_JOBS_DEPTGUARD, ALL_JOBS_SEC)
	group = "Job-Locked"

/datum/loadout_item/glasses/aviator_security
	name = "安保HUD - 太阳镜"
	item_path = /obj/item/clothing/glasses/hud/ar/aviator/security
	restricted_roles = list(ALL_JOBS_DEPTGUARD, ALL_JOBS_SEC)
	group = "Job-Locked"

/datum/loadout_item/glasses/sechud_sunglasses_blue
	name = "安保HUD - 太阳镜（蓝色）"
	item_path = /obj/item/clothing/glasses/hud/security/sunglasses/blue
	restricted_roles = list(ALL_JOBS_DEPTGUARD, ALL_JOBS_SEC)
	group = "Job-Locked"

/datum/loadout_item/glasses/retinal_projector_security
	name = "安保HUD - 视网膜投影仪"
	item_path = /obj/item/clothing/glasses/hud/ar/projector/security
	restricted_roles = list(ALL_JOBS_DEPTGUARD, ALL_JOBS_SEC)
	group = "Job-Locked"

/*
 *	DONATOR
 */

/datum/loadout_item/glasses/donator
	abstract_type = /datum/loadout_item/glasses/donator
	donator_only = TRUE

/datum/loadout_item/glasses/donator/fake_sunglasses
	name = "假太阳镜"
	item_path = /obj/item/clothing/glasses/fake_sunglasses
