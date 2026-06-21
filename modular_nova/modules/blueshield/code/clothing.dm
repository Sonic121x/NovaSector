//Blueshield

//Uniform items are in command.dm

/obj/item/radio/headset/headset_bs
	name = "\proper 蓝盾的耳机"
	icon = 'modular_nova/modules/blueshield/icons/radio.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/ears.dmi'
	icon_state = "bshield_headset"
	worn_icon_state = "bshield_headset"
	keyslot = /obj/item/encryptionkey/heads/blueshield
	keyslot2 = /obj/item/encryptionkey/headset_cent

/obj/item/radio/headset/headset_bs/alt
	icon_state = "bshield_headset_alt"
	worn_icon_state = "bshield_headset_alt"

/obj/item/radio/headset/headset_bs/alt/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/wearertargeting/earprotection, list(ITEM_SLOT_EARS))

/obj/item/clothing/head/helmet/space/plasmaman/blueshield
	name = "蓝盾环境防护服头盔"
	desc = "为认证蓝盾设计的等离子人防护头盔，其保护头部的工作不应包括自燃……大多数时候。"
	icon = 'modular_nova/master_files/icons/obj/clothing/head/plasmaman_hats.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/head/plasmaman_head.dmi'
	icon_state = "bs_envirohelm"

/obj/item/clothing/under/plasmaman/blueshield
	name = "蓝盾环境防护服"
	desc = "为认证蓝盾设计的等离子人防护服，提供有限的额外保护。"
	icon = 'modular_nova/master_files/icons/obj/clothing/under/plasmaman.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/under/plasmaman.dmi'
	icon_state = "bs_envirosuit"
	armor_type = /datum/armor/clothing_under/under_plasmaman_blueshield
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE

/datum/armor/clothing_under/under_plasmaman_blueshield
	melee = 10
	bio = 100
	fire = 95
	acid = 95

/obj/item/clothing/head/beret/blueshield
	name = "蓝盾的贝雷帽"
	desc = "一顶由杜拉线制成的蓝色贝雷帽，配有真金徽章，表明其主人是蓝盾中尉。它似乎填充了纳米凯夫拉，使其比标准强化贝雷帽更坚韧。"
	icon_state = "/obj/item/clothing/head/beret/blueshield"
	post_init_icon_state = "beret_badge_police"
	greyscale_config = /datum/greyscale_config/beret_badge
	greyscale_config_worn = /datum/greyscale_config/beret_badge/worn
	greyscale_colors = "#3A4E7D#DEB63D"
	armor_type = /datum/armor/cosmetic_sec
	supports_variations_flags = CLOTHING_SNOUTED_VARIATION_NO_NEW_ICON

/obj/item/clothing/head/soft/blueshield
	name = "蓝盾的帽子"
	desc = "一顶由杜拉线制成的海军蓝棒球帽，配有真金徽章，表明其主人是蓝盾中尉。它似乎填充了纳米凯夫拉，使其比标准帽子更坚韧。"
	icon_state = "blueshieldsoft"
	soft_type = "blueshield"
	inhand_icon_state = "greyscale_softcap"
	armor_type = /datum/armor/cosmetic_sec
	supports_variations_flags = CLOTHING_SNOUTED_VARIATION_NO_NEW_ICON

/obj/item/clothing/head/beret/blueshield/navy
	name = "海军蓝盾贝雷帽"
	desc = "一顶由杜拉纤维制成的海军蓝色贝雷帽，配有银色徽章，表明其佩戴者为蓝盾中尉。它似乎填充了纳米凯夫拉材料，使其比标准强化贝雷帽更坚韧。"
	icon_state = "/obj/item/clothing/head/beret/blueshield/navy"
	greyscale_colors = "#3C485A#BBBBBB"

/obj/item/storage/backpack/blueshield
	name = "蓝盾背包"
	desc = "一款颁发给纳米传讯最优秀员工的坚固背包。"
	icon = 'modular_nova/master_files/icons/obj/clothing/backpacks.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/back.dmi'
	lefthand_file = 'modular_nova/master_files/icons/mob/inhands/clothing/backpack_lefthand.dmi'
	righthand_file = 'modular_nova/master_files/icons/mob/inhands/clothing/backpack_righthand.dmi'
	icon_state = "backpack_blueshield"
	inhand_icon_state = "backpack_blueshield"

/obj/item/storage/backpack/satchel/blueshield
	name = "蓝盾挎包"
	desc = "一款颁发给纳米传讯最优秀员工的坚固挎包。"
	icon = 'modular_nova/master_files/icons/obj/clothing/backpacks.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/back.dmi'
	lefthand_file = 'modular_nova/master_files/icons/mob/inhands/clothing/backpack_lefthand.dmi'
	righthand_file = 'modular_nova/master_files/icons/mob/inhands/clothing/backpack_righthand.dmi'
	icon_state = "satchel_blueshield"
	inhand_icon_state = "satchel_blueshield"

/obj/item/storage/backpack/duffelbag/blueshield
	name = "蓝盾行李袋"
	desc = "一款颁发给纳米传讯最优秀员工的坚固行李袋。"
	icon = 'modular_nova/master_files/icons/obj/clothing/backpacks.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/back.dmi'
	lefthand_file = 'modular_nova/master_files/icons/mob/inhands/clothing/backpack_lefthand.dmi'
	righthand_file = 'modular_nova/master_files/icons/mob/inhands/clothing/backpack_righthand.dmi'
	icon_state = "duffel_blueshield"
	inhand_icon_state = "duffel_blueshield"

//blueshield armor

/datum/atom_skin/blueshield_jacket
	abstract_type = /datum/atom_skin/blueshield_jacket

/datum/atom_skin/blueshield_jacket/slim
	preview_name = "Slim"
	new_icon_state = "blueshieldarmor"

/datum/atom_skin/blueshield_jacket/marine
	preview_name = "Marine"
	new_icon_state = "bs_marine"

/datum/atom_skin/blueshield_jacket/bulky
	preview_name = "Bulky"
	new_icon_state = "vest_black"

/obj/item/clothing/suit/armor/vest/blueshield
	icon = 'modular_nova/master_files/icons/obj/clothing/suits/armor.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/suits/armor.dmi'
	name = "蓝盾护甲"
	desc = "一件紧身凯夫拉内衬背心，胸前有一枚蓝色徽章。"
	icon_state = "blueshieldarmor"
	body_parts_covered = CHEST

/obj/item/clothing/suit/armor/vest/blueshield/setup_reskins()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/blueshield_jacket)

/obj/item/clothing/suit/armor/vest/blueshield/jacket
	name = "蓝盾夹克"
	desc = "一件昂贵的凯夫拉内衬夹克，胸前有一枚金色徽章，背部印有“NT”字样。尽管看起来厚重，但重量却出奇地轻。"
	icon_state = "blueshield"
	body_parts_covered = CHEST|ARMS

/obj/item/clothing/suit/armor/vest/blueshield/jacket/setup_reskins()
	return

/obj/item/clothing/suit/hooded/wintercoat/nova/blueshield
	name = "蓝盾冬季大衣"
	icon_state = "coatblueshield"
	desc = "一件舒适的凯夫拉内衬大衣，带有蓝色点缀，适合让蓝盾保持防护与温暖。"
	hoodtype = /obj/item/clothing/head/hooded/winterhood/nova/blueshield
	allowed = list(/obj/item/melee/baton/security/loaded)
	armor_type = /datum/armor/suit_armor

/obj/item/clothing/suit/hooded/wintercoat/nova/blueshield/Initialize(mapload)
	. = ..()
	allowed += GLOB.security_vest_allowed

/obj/item/clothing/head/hooded/winterhood/nova/blueshield
	icon_state = "hood_blueshield"
	desc = "一顶舒适的凯夫拉内衬兜帽，与舒适的凯夫拉内衬大衣相配。"
	armor_type = /datum/armor/suit_armor
