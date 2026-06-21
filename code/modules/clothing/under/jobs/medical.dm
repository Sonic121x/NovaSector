/obj/item/clothing/under/rank/medical
	icon = 'icons/obj/clothing/under/medical.dmi'
	worn_icon = 'icons/mob/clothing/under/medical.dmi'
	abstract_type = /obj/item/clothing/under/rank/medical
	armor_type = /datum/armor/clothing_under/rank_medical

/datum/armor/clothing_under/rank_medical
	bio = 50

/obj/item/clothing/under/rank/medical/doctor
	desc = "它由特殊纤维制成，能提供针对生物危害的基础防护。其胸口的十字标志表明穿戴者是受过专业训练的医疗人员。"
	name = "医生连身衣"
	icon_state = "medical"
	inhand_icon_state = "w_suit"

/obj/item/clothing/under/rank/medical/doctor/skirt
	name = "医生连身裙"
	desc = "It's made of a special fiber that provides minor protection against biohazards. It has a cross on the chest denoting that the wearer is trained medical personnel."
	icon_state = "medical_skirt"
	inhand_icon_state = "w_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/medical/chief_medical_officer
	desc = "这是那些具有“首席医疗官”资格的人才能穿的连身衣。它提供了轻微的生物保护。"
	name = "首席医疗官连身衣"
	icon_state = "cmo"
	inhand_icon_state = "w_suit"

/obj/item/clothing/under/rank/medical/chief_medical_officer/skirt
	name = "首席医疗官连身裙"
	desc = "这是那些具有“首席医疗官”资格的人才能穿的连身裙。它提供了轻微的生物保护。"
	icon_state = "cmo_skirt"
	inhand_icon_state = "w_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/medical/chief_medical_officer/scrubs
	name = "首席医疗官手术服"
	desc = "一套独特的白与绿松石色手术服，授予那些追求专业临床形象的首席医疗官。"
	icon_state = "scrubscmo"
	inhand_icon_state = "w_suit"

/obj/item/clothing/under/rank/medical/chief_medical_officer/scrubs/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, -3) //FISH DOCTOR?!

/obj/item/clothing/under/rank/medical/chief_medical_officer/turtleneck
	name = "首席医疗官高领毛衣"
	desc = "一套浅蓝色高领毛衣与棕褐色卡其裤的组合，专为拥有卓越品味的首席医疗官准备。"
	icon_state = "cmoturtle"
	inhand_icon_state = "b_suit"
	can_adjust = TRUE
	alt_covers_chest = TRUE
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY

/obj/item/clothing/under/rank/medical/chief_medical_officer/turtleneck/skirt
	name = "首席医疗官高领毛衣裙"
	desc = "一套浅蓝色高领毛衣与棕褐色卡其裙的组合，专为拥有卓越品味的首席医疗官准备。"
	icon_state = "cmoturtle_skirt"
	inhand_icon_state = "b_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/medical/virologist
	desc = "该防护服由特殊纤维制成，能提供针对生物危害的特殊防护，并印有病毒学家职级条纹。"
	name = "病毒学家连身衣"
	icon_state = "virology"
	inhand_icon_state = "w_suit"

/obj/item/clothing/under/rank/medical/virologist/skirt
	name = "病毒学家连身裙"
	desc = "It's made of a special fiber that gives special protection against biohazards. It has a virologist rank stripe on it."
	icon_state = "virologywhite_skirt"
	inhand_icon_state = "w_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/medical/scrubs
	name = "医疗手术服"

/obj/item/clothing/under/rank/medical/scrubs/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, -3) //FISH DOCTOR?!

/obj/item/clothing/under/rank/medical/scrubs/blue
	desc = "它是由一种特殊的纤维制成的，可以对生物危害提供轻微的保护。这件是淡蓝色的。"
	icon_state = "scrubsblue"

/obj/item/clothing/under/rank/medical/scrubs/green
	desc = "它是由一种特殊的纤维制成的，可以对生物危害提供轻微的保护。这件是深绿色的。"
	icon_state = "scrubsgreen"

/obj/item/clothing/under/rank/medical/scrubs/purple
	desc = "它是由一种特殊的纤维制成的，可以对生物危害提供轻微的保护。这件是深紫色的。"
	icon_state = "scrubswine"

/obj/item/clothing/under/rank/medical/coroner
	desc = "它由一种特殊纤维制成，能提供对生物危害的轻微防护。胸前有一个横置的白色十字，表明穿着者是受过训练的验尸官。"
	name = "验尸官连体服"
	icon_state = "coroner"
	inhand_icon_state = "w_suit"

/obj/item/clothing/under/rank/medical/coroner/skirt
	name = "验尸官连体裙"
	desc = "它由特殊纤维制成，能提供微弱的生物危害防护。胸前有一个横置的白色十字标志，表明穿着者是受过训练的验尸官。"
	icon_state = "coroner_skirt"
	inhand_icon_state = "w_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/medical/scrubs/coroner
	name = "验尸官手术服"
	desc = "It's made of a special fiber that provides minor protection against biohazards. This one is as dark as an emo's poetry."
	icon_state = "scrubsblack"

/obj/item/clothing/under/rank/medical/chemist
	desc = "该防护服由特殊纤维制成，能提供针对生物危害的特殊防护，并印有化学家职级条纹。"
	name = "化学家连身衣"
	icon_state = "chemistry"
	inhand_icon_state = "w_suit"
	armor_type = /datum/armor/clothing_under/medical_chemist

/datum/armor/clothing_under/medical_chemist
	fire = 50
	acid = 65

/obj/item/clothing/under/rank/medical/chemist/skirt
	name = "化学家连身裙"
	desc = "It's made of a special fiber that gives special protection against biohazards. It has a chemist rank stripe on it."
	icon_state = "chemistrywhite_skirt"
	inhand_icon_state = "w_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/medical/paramedic
	desc = "它由特殊纤维制成，能提供针对生物危害的基础防护。其胸口的深蓝色十字标志表明穿戴者是受过专业训练的急救员。"
	name = "急救员连身衣"
	icon_state = "paramedic"
	inhand_icon_state = "w_suit"

/obj/item/clothing/under/rank/medical/paramedic/skirt
	name = "急救员连身裙"
	desc = "It's made of a special fiber that provides minor protection against biohazards. It has a dark blue cross on the chest denoting that the wearer is a trained paramedic."
	icon_state = "paramedic_skirt"
	inhand_icon_state = "w_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/medical/doctor/nurse
	desc = "这是一个连身衣，在医疗部门中通常由护理人员穿着。"
	name = "护士服"
	icon_state = "nursesuit"
	inhand_icon_state = "w_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	female_sprite_flags = NO_FEMALE_UNIFORM
	can_adjust = FALSE
