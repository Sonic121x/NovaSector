//DO NOT ADD TO THIS FILE UNLESS THE SITUATION IS DIRE
//MISC FILES = UNSORTED FILES. EVEN TG HATES THIS ONE.

/obj/item/clothing/under/misc
	worn_icon_digi = 'modular_nova/master_files/icons/mob/clothing/under/misc_digi.dmi'

/obj/item/clothing/under/misc/nova
	icon = 'modular_nova/master_files/icons/obj/clothing/under/misc.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/under/misc.dmi'
	can_adjust = FALSE

/*
	Do we even bother sorting these? We don't want to use the file, it's for emergencies and in-betweens.
	Just... don't lose your stuff.
*/

/obj/item/clothing/under/misc/nova/gear_harness
	name = "装备背带"
	desc = "一种简单、不显眼的背带，用于替代连体服。"
	icon_state = "gear_harness"
	body_parts_covered = NONE
	attachment_slot_override = CHEST
	can_adjust = FALSE
	slot_flags = ITEM_SLOT_ICLOTHING | ITEM_SLOT_OCLOTHING
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/misc/nova/gear_harness/suit // Functionally the same, this is just so the loadout system allows you to pick either one

/obj/item/clothing/under/misc/nova/gear_harness/Initialize(mapload)
	. = ..()
	allowed += GLOB.colonist_suit_allowed

/obj/item/clothing/under/misc/nova/gear_harness/eve
	name = "树叶集"
	desc = "三片树叶，设计用于遮盖穿着者的乳头和生殖器。如此骄傲的敌人，必先寻找弱者。"
	icon_state = "eve"
	body_parts_covered = CHEST|GROIN

/obj/item/clothing/under/misc/nova/gear_harness/adam
	name = "树叶"
	desc = "一片树叶，设计用于遮盖穿着者的生殖器。勿寻诱惑。"
	icon_state = "adam"
	body_parts_covered = GROIN
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY

/obj/item/clothing/under/misc/nova/taccas
	name = "战术休闲制服"
	desc = "一件白色背心搭配一条货运裤。适合需要携带各种啤酒的时候。"
	icon_state = "tac_s"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION | CLOTHING_BIG_LEGS_MASK

/obj/item/clothing/under/misc/nova/mechanic
	name = "技工连体裤"
	desc = "一条老式的棕色连体裤，配有各种口袋和腰带环。"
	icon_state = "mechanic"

/obj/item/clothing/under/misc/nova/utility
	name = "通用勤务制服"
	desc = "平民级别船员穿着的勤务制服。"
	icon_state = "utility"
	body_parts_covered = CHEST|ARMS|GROIN|LEGS
	can_adjust = FALSE

/obj/item/clothing/under/misc/nova/utility/syndicate
	armor_type = /datum/armor/clothing_under/utility_syndicate
	has_sensor = NO_SENSORS

/datum/armor/clothing_under/utility_syndicate
	melee = 10
	fire = 50
	acid = 40
