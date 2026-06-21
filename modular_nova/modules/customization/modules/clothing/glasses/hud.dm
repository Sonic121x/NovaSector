/obj/item/clothing/glasses/hud/eyepatch
	name = "HUD眼罩"
	desc = "一种设计用于直接与视神经接口的HUD。这个是坏的。"
	icon = 'modular_nova/master_files/icons/obj/clothing/glasses.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/eyes.dmi'
	icon_state = "hudpatch"
	base_icon_state = "hudpatch"
	inhand_icon_state = null
	abstract_type = /obj/item/clothing/glasses/hud/eyepatch
	actions_types = list(
		/datum/action/item_action/toggle_wearable_hud,
		/datum/action/item_action/flip,
	)
	custom_materials = list(/datum/material/glass = SMALL_MATERIAL_AMOUNT * 3, /datum/material/iron = SMALL_MATERIAL_AMOUNT * 0.5)
	var/flipped = FALSE

/*
All this is copied  eyepatch toggle/tint code from
code\modules\clothing\glasses\_glasses.dm so HUD eyepatches function with
scarred eye.
*/
/obj/item/clothing/glasses/hud/eyepatch/attack_self(mob/user)
	. = ..()
	flip_eyepatch()

/obj/item/clothing/glasses/hud/eyepatch/proc/flip_eyepatch()
	flipped = !flipped
	icon_state = flipped ? "[base_icon_state]_flipped" : base_icon_state
	if (!ismob(loc))
		return
	var/mob/user = loc
	user.update_worn_glasses()
	if (!ishuman(user))
		return
	var/mob/living/carbon/human/human_user = user
	if (human_user.get_eye_scars() & (flipped ? RIGHT_EYE_SCAR : LEFT_EYE_SCAR))
		tint = INFINITY
	else
		tint = initial(tint)
	human_user.update_tint()

/obj/item/clothing/glasses/hud/eyepatch/equipped(mob/living/user, slot)
	if (!ishuman(user))
		return ..()
	var/mob/living/carbon/human/human_user = user
	// lol lmao
	if (human_user.get_eye_scars() & (flipped ? RIGHT_EYE_SCAR : LEFT_EYE_SCAR))
		tint = INFINITY
	else
		tint = initial(tint)
	return ..()

/obj/item/clothing/glasses/hud/eyepatch/dropped(mob/living/user)
	. = ..()
	tint = initial(tint)

/*
End of the copy-paste.
*/

/obj/item/clothing/glasses/hud/security/sunglasses/eyepatch // TG item, but we have a recipe for it and they don't
	custom_materials = list(/datum/material/glass = SMALL_MATERIAL_AMOUNT * 3, /datum/material/iron = SMALL_MATERIAL_AMOUNT * 0.5)

/obj/item/clothing/glasses/hud/eyepatch/med
	name = "医疗HUD眼罩"
	desc = "一种设计用于直接与视神经接口的HUD。这个会扫描视野内的人形生物，并提供关于其健康状况的准确数据。"
	icon_state = "medpatch"
	base_icon_state = "medpatch"
	clothing_traits = list(TRAIT_MEDICAL_HUD)
	glass_colour_type = /datum/client_colour/glass_colour/lightblue


/obj/item/clothing/glasses/hud/eyepatch/meson
	name = "介子扫描HUD眼罩"
	desc = "一种设计用于直接与视神经接口的HUD。这一款能够无视光照条件，显示墙壁后方的基本结构和地形布局。"
	icon_state = "mesonpatch"
	base_icon_state = "mesonpatch"
	clothing_traits = list(TRAIT_MADNESS_IMMUNE)
	vision_flags = SEE_TURFS
	color_cutoffs = list(5, 15, 5)
	lighting_cutoff = LIGHTING_CUTOFF_MEDIUM
	glass_colour_type = /datum/client_colour/glass_colour/lightgreen
	actions_types = list(/datum/action/item_action/flip)

/obj/item/clothing/glasses/hud/eyepatch/diagnostic
	name = "诊断HUD眼罩"
	desc = "一种设计用于直接与视神经接口的HUD。这一款用于分析机器人和外骨骼的完整性与状态。"
	icon_state = "robopatch"
	base_icon_state = "robopatch"
	clothing_traits = list(TRAIT_DIAGNOSTIC_HUD)
	glass_colour_type = /datum/client_colour/glass_colour/lightorange

/obj/item/clothing/glasses/hud/eyepatch/sci
	name = "科研HUD眼罩"
	desc = "一种设计用于直接与视神经接口的HUD。这一款配备了用于扫描物品和试剂的分析仪。"
	icon_state = "scipatch"
	base_icon_state = "scipatch"
	clothing_traits = list(TRAIT_REAGENT_SCANNER, TRAIT_RESEARCH_SCANNER)
	actions_types = list(/datum/action/item_action/flip)

/// BLINDFOLD HUD (Used with NIF upgrade)///
/obj/item/clothing/glasses/trickblindfold/obsolete
	name = "过时的假眼罩"
	desc = "一个华丽的假眼罩，没有任何电子元件。据信最初是由一支致力于保护人类的昔日军事力量的成员佩戴的。"
	icon = 'modular_nova/master_files/icons/obj/clothing/glasses.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/eyes.dmi'
	icon_state = "obsoletefold"
	base_icon_state = "obsoletefold"
