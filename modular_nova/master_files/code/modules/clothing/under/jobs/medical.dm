/obj/item/clothing/under/rank/medical
	worn_icon_digi = 'modular_nova/master_files/icons/mob/clothing/under/medical_digi.dmi'

/obj/item/clothing/under/rank/medical/doctor/nurse
	can_adjust = FALSE
	icon = 'modular_nova/master_files/icons/obj/clothing/under/medical.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/under/medical.dmi'
	worn_icon_digi = 'modular_nova/master_files/icons/mob/clothing/under/medical_digi.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION
	alternate_worn_layer = ABOVE_SHOES_LAYER

/obj/item/clothing/under/rank/medical/doctor/nurse/seriouser
	can_adjust = FALSE
	icon_state = "nursesuit_alt"
	icon = 'modular_nova/master_files/icons/obj/clothing/under/medical.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/under/medical.dmi'
	worn_icon_digi = 'modular_nova/master_files/icons/mob/clothing/under/medical_digi.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION
	alternate_worn_layer = ABOVE_SHOES_LAYER

/obj/item/clothing/under/rank/medical/doctor/nova
	icon = 'modular_nova/master_files/icons/obj/clothing/under/medical.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/under/medical.dmi'

/obj/item/clothing/under/syndicate/scrubs
	worn_icon_digi = 'modular_nova/master_files/icons/mob/clothing/under/medical_digi.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION

/obj/item/clothing/under/rank/medical/scrubs/nova
	icon = 'modular_nova/master_files/icons/obj/clothing/under/medical.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/under/medical.dmi'
	icon_state = "scrubswhite" // Because for some reason TG's scrubs dont have an icon on their basetype
	desc = "它由一种特殊纤维制成，能提供对生物危害的轻微防护。这件似乎是原版刷手服。"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION

/obj/item/clothing/under/rank/medical/chemist/nova
	icon = 'modular_nova/master_files/icons/obj/clothing/under/medical.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/under/medical.dmi'

// Add a 'medical/virologist/nova' here if you make Virologist uniforms

/obj/item/clothing/under/rank/medical/paramedic/nova
	icon = 'modular_nova/master_files/icons/obj/clothing/under/medical.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/under/medical.dmi'

/obj/item/clothing/under/rank/medical/chief_medical_officer/nova
	icon = 'modular_nova/master_files/icons/obj/clothing/under/medical.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/under/medical.dmi'

/*
*	DOCTOR
*/

/obj/item/clothing/under/rank/medical/doctor/nova/utility
	name = "医疗勤务制服"
	desc = "医疗医生穿着的勤务制服。"
	icon_state = "util_med"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION | CLOTHING_BIG_LEGS_MASK
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	alt_covers_chest = TRUE

/obj/item/clothing/under/rank/medical/doctor/nova/utility/syndicate
	armor_type = /datum/armor/clothing_under/utility_syndicate
	has_sensor = NO_SENSORS

/*
*	SCRUBS
*/

/obj/item/clothing/under/rank/medical/scrubs/nova/red
	desc = "它由一种特殊纤维制成，能提供对生物危害的轻微防护。这件是深红色的。"
	icon_state = "scrubsred"

/obj/item/clothing/under/rank/medical/scrubs/nova/white
	desc = "它由一种特殊纤维制成，能提供对生物危害的轻微防护。这件是奶油白色的。"
	icon_state = "scrubswhite"

/*
*	CHEMIST
*/

/obj/item/clothing/under/rank/medical/chemist/nova/formal
	name = "药剂师的正装连体服"
	desc = "一件左对齐纽扣的白色衬衫，带有橙色条纹，内衬有防化学泄漏的保护层。"
	icon_state = "pharmacologist"

/obj/item/clothing/under/rank/medical/chemist/nova/formal/skirt
	name = "药剂师的正装连体裙"
	icon_state = "pharmacologist_skirt"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON | CLOTHING_BIG_LEGS_MASK
	gets_cropped_on_taurs = FALSE

/obj/item/clothing/under/rank/medical/chemist/skirt
	gets_cropped_on_taurs = FALSE

/*
*	PARAMEDIC
*/

/obj/item/clothing/under/rank/medical/paramedic/nova/light
	name = "轻型护理员制服"
	desc = "典型护理员制服的明亮变体，由能提供对生物危害轻微防护的特殊纤维制成，这件移除了反光条。"
	icon_state = "paramedic_light"

/obj/item/clothing/under/rank/medical/paramedic/nova/light/skirt
	name = "轻型护理员裙"
	desc = "典型护理员制服的明亮变体，由能提供对生物危害轻微防护的特殊纤维制成，这件将裤腿换成了裙子。"
	icon_state = "paramedic_light_skirt"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON | CLOTHING_BIG_LEGS_MASK
	gets_cropped_on_taurs = FALSE

/*
*	CHIEF MEDICAL OFFICER
*/

/obj/item/clothing/under/imperial/cmo
	desc = "一件青绿色、无菌的海军制服，配有表示医疗部队军官的军衔徽章。无法抵御爆能枪火力。"
	name = "首席医疗官的海军连体服"
	icon_state = "/obj/item/clothing/under/imperial/cmo"
	greyscale_colors = "#5EB8B8#5EB8B8#5EB8B8#373741#FFFFFF#2979cd#bc2626"
	flags_1 = NONE

/obj/item/clothing/under/imperialskirt/cmo
	desc = "一件青绿色、无菌的海军裙装，配有表示医疗部队军官的军衔徽章。无法抵御爆能枪火力。"
	name = "首席医疗官的海军裙装"
	icon_state = "/obj/item/clothing/under/imperialskirt/cmo"
	greyscale_colors = "#5EB8B8#5EB8B8#373741#FFFFFF#2979cd#bc2626"
	flags_1 = NONE
