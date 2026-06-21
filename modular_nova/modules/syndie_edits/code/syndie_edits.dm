//DS-2/Syndicate clothing.

/obj/item/clothing/suit/armor/vest/capcarapace/syndicate
	icon = 'modular_nova/modules/syndie_edits/icons/obj.dmi'
	worn_icon = 'modular_nova/modules/syndie_edits/icons/worn.dmi'
	icon_state = "syndievest"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON


/obj/item/clothing/suit/armor/vest/capcarapace/syndicate/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon)

/obj/item/clothing/suit/armor/vest/capcarapace/syndicate/winter
	name = "辛迪加舰长冬季护甲背心"
	desc = "一件外观险恶却舒适的先进护甲背心，穿在黑色与红色的防火夹克外。据说毛皮来自冰月上的狼。"
	icon = 'modular_nova/modules/syndie_edits/icons/obj.dmi'
	worn_icon = 'modular_nova/modules/syndie_edits/icons/worn.dmi'
	icon_state = "syndievest_winter"
	body_parts_covered = CHEST|GROIN
	cold_protection = CHEST|GROIN|ARMS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	resistance_flags = FIRE_PROOF

/obj/item/clothing/suit/armor/vest/capcarapace/syndicate/winter/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon)

/obj/item/clothing/head/hats/warden/syndicate
	name = "军械长警帽"
	desc = "一顶时尚的警帽，饰有金色徽章，配发给军械长。能保护头部免受冲击。"
	icon = 'modular_nova/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/head.dmi'
	icon_state = "policehelm_syndie"
	dog_fashion = null

/obj/item/clothing/head/helmet/swat/ds
	name = "特警头盔"
	desc = "A robust and spaceworthy helmet with a small cross on it along with 'IP' written across the earpad."
	icon = 'modular_nova/master_files/icons/obj/clothing/head/helmet.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/head/helmet.dmi'
	icon_state = "swat_ds"
	supports_variations_flags = CLOTHING_SNOUTED_VARIATION

/obj/item/clothing/head/beret/sec/syndicate
	name = "禁闭室军官贝雷帽"
	desc = "一顶时尚且具有防护性的贝雷帽，由英特戴恩制药公司在戈尔莱克斯掠夺者的协助下生产和制造。"
	icon_state = "/obj/item/clothing/head/beret/sec/syndicate"
	post_init_icon_state = "beret_badge"
	greyscale_config = /datum/greyscale_config/beret_badge
	greyscale_config_worn = /datum/greyscale_config/beret_badge/worn
	greyscale_colors = "#3F3C40#DB2929"

/obj/item/clothing/mask/gas/syndicate/ds
	name = "巴拉克拉瓦头套"
	desc = "一款精致的巴拉克拉瓦头套，虽然不会掩盖你的声音，但它防火并内置了一个微型呼吸器用于内部供氧。而且非常舒适！"
	icon = 'modular_nova/master_files/icons/obj/clothing/masks.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/mask.dmi'
	icon_state = "balaclava_ds"
	flags_inv = HIDEFACE | HIDEEARS | HIDEFACIALHAIR
	alternate_worn_layer = LOW_FACEMASK_LAYER //This lets it layer below glasses and headsets; yes, that's below hair, but it already has HIDEHAIR

/obj/item/clothing/mask/neck_gaiter/syndicate
	name = "战术颈套"
	desc = "专为希望在保持低调的同时隐藏身份的探员设计。配有一个小型呼吸器，可与内部供氧系统配合使用。"
	unique_death = 'modular_nova/master_files/sound/effects/hacked.ogg'
	icon_state = "/obj/item/clothing/mask/neck_gaiter/syndicate"
	greyscale_colors = "#2c2c2e"

/obj/item/clothing/shoes/combat //TO-DO: Move these overrides out of a syndicate file!
	icon = 'modular_nova/master_files/icons/obj/clothing/shoes.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/feet.dmi'
	icon_state = "combat"

// Remove the override for these subtypes
/obj/item/clothing/gloves/combat/floortile
	icon = 'icons/obj/clothing/gloves.dmi'
	worn_icon = null

/obj/item/clothing/gloves/combat/wizard
	icon = 'icons/obj/clothing/gloves.dmi'
	worn_icon = null

/obj/item/clothing/gloves/tackler/combat/insulated
	icon = 'modular_nova/master_files/icons/obj/clothing/gloves.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/hands.dmi'
	icon_state = "combat"

/obj/item/clothing/gloves/kaza_ruk/combatglovesplus
	icon = 'modular_nova/master_files/icons/obj/clothing/gloves.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/hands.dmi'
	icon_state = "combat"

/obj/item/clothing/gloves/kaza_ruk/combatglovesplus/maa
	name = "军械长作战手套"
	desc = "一副作战手套Plus版，指关节处饰有红色，既彰显了对本职工作的投入，也能隐藏使用后留下的血迹。"
	icon_state = "maagloves"

/obj/item/storage/belt/security/webbing/ds
	name = "禁闭室军官战术携行带"
	icon = 'modular_nova/master_files/icons/obj/clothing/belts.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/belt.dmi'
	icon_state = "webbingds"
	worn_icon_state = "webbingds"

/obj/item/storage/belt/security/webbing/ds/setup_reskins()
	return

/obj/item/clothing/suit/armor/bulletproof/old
	desc = "一件III型重型防弹背心，擅长保护穿戴者免受传统抛射武器和一定程度的爆炸伤害。"
	icon = 'icons/obj/clothing/suits/armor.dmi'
	worn_icon = 'icons/mob/clothing/suits/armor.dmi'
	icon_state = "bulletproof"
	body_parts_covered = CHEST //TG's version has no groin/arm padding

/obj/item/clothing/under/syndicate/nova/overalls
	name = "工装连体高领衫"
	desc = "一条时髦的工装裤，内搭高领衫，适用于工程和植物学工作。"
	icon_state = "syndicate_overalls"
	can_adjust = TRUE

/obj/item/clothing/under/syndicate/nova/overalls/skirt
	name = "工装裙式高领衫"
	desc = "一条时髦的工装裤，内搭高领衫，这条是裙子款式，很通风。"
	icon_state = "syndicate_overallskirt"
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	dying_key = DYE_REGISTRY_JUMPSKIRT
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON | CLOTHING_BIG_LEGS_MASK

/obj/item/clothing/head/soft/sec/syndicate
	name = "引擎技术员实用帽"
	desc = "一顶引擎技术员的实用帽，上面有个标签写着'IP-DS-2'。"
	icon = 'modular_nova/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/head.dmi'
	icon_state = "dssoft"
	soft_type = "ds"

//Maid Outfit
/obj/item/clothing/head/costume/maid_headband/syndicate
	name = "战术女仆发带"
	desc = "战术可爱。"
	icon_state = "syndimaid_headband"
	icon = 'modular_nova/master_files/icons/obj/clothing/head/costume.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/head/costume.dmi'
	post_init_icon_state = null
	greyscale_config = null
	greyscale_config_worn = null
	greyscale_colors = "#88242D#591A2A"
	flags_1 = NONE

/obj/item/clothing/gloves/combat/maid
	name = "战斗女仆袖套"
	desc = "These 'tactical' gloves and sleeves are fireproof and electrically insulated. Warm to boot."
	icon_state = "syndimaid_arms"

/obj/item/clothing/under/syndicate/nova/maid
	name = "战术女仆装"
	desc = "A 'tactical' skirtleneck fashioned to the likeness of a maid outfit. Why the Syndicate has these, you'll never know."
	icon_state = "syndimaid"
	armor_type = /datum/armor/clothing_under
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	dying_key = DYE_REGISTRY_JUMPSKIRT
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/syndicate/nova/maid/Initialize(mapload)
	. = ..()
	var/obj/item/clothing/accessory/maidcorset/syndicate/A = new (src)
	attach_accessory(A)

/obj/item/clothing/accessory/maidcorset/syndicate
	name = "辛迪加女仆围裙"
	desc = "实用吗？不。战术吗？也不。可爱吗？绝对是。"
	icon = 'modular_nova/master_files/icons/obj/clothing/accessories.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/accessories.dmi'
	icon_state = "syndimaid_corset"
	minimize_when_attached = FALSE
	attachment_slot = NONE

//Wintercoat & Hood
/obj/item/clothing/suit/hooded/wintercoat/nova/syndicate
	name = "辛迪加冬季大衣"
	desc = "一件带有红色点缀和华丽披肩的阴森黑色大衣，感觉它能承受一击。拉链头看起来像一条三头蛇组成的S形，很吓人。"
	icon_state = "coatsyndie"
	inhand_icon_state = "coatwinter"
	armor_type = /datum/armor/wintercoat_syndicate
	hoodtype = /obj/item/clothing/head/hooded/winterhood/nova/syndicate

/datum/armor/wintercoat_syndicate
	melee = 25
	bullet = 15
	laser = 30
	energy = 40
	bomb = 25
	acid = 45

/obj/item/clothing/suit/hooded/wintercoat/nova/syndicate/Initialize(mapload)
	. = ..()
	allowed += GLOB.security_wintercoat_allowed

/obj/item/clothing/head/hooded/winterhood/nova/syndicate
	desc = "一顶带有装甲衬垫的阴森黑色兜帽。"
	icon_state = "hood_syndie"
	armor_type = /datum/armor/winterhood_syndicate

/datum/armor/winterhood_syndicate
	melee = 25
	bullet = 15
	laser = 30
	energy = 40
	bomb = 25
	acid = 45

//Interdyne Clothing
/obj/item/clothing/under/syndicate/nova/interdyne
	name = "英特戴恩高领衫"
	desc = "一件时尚的白色高领衫，带有一丝英特戴恩绿，搭配炭黑色货运裤很合适。"
	has_sensor = HAS_SENSORS
	armor_type = /datum/armor/clothing_under/syndicate
	icon_state = "ip_turtleneck"
	can_adjust = TRUE
	alt_covers_chest = TRUE
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION | CLOTHING_BIG_LEGS_MASK

/obj/item/clothing/under/syndicate/nova/interdyne/miner
	name = "英特戴恩连体服"
	desc = "一件带有加固纤维的黑绿色英特戴恩制药连体服。"
	armor_type = /datum/armor/clothing_under/cargo_miner
	icon_state = "ip_miner"
	can_adjust = TRUE
	alt_covers_chest = FALSE

/obj/item/clothing/under/syndicate/nova/interdyne/deckofficer
	name = "甲板军官连体服"
	desc = "一套黑绿相间的Interdyne制药公司制服，配有金色皮带扣。"
	armor_type = /datum/armor/clothing_under/syndicate
	icon_state = "ip_deckofficer"
	can_adjust = TRUE
	alt_covers_chest = FALSE

/obj/item/clothing/head/beret/medical/nova/interdyne
	name = "Interdyne贝雷帽"
	desc = "一顶白绿相间的贝雷帽，象征着佩戴者对Interdyne制药公司的忠诚。"
	icon_state = "/obj/item/clothing/head/beret/medical/nova/interdyne"
	greyscale_colors = "#FFFFFF#198019"

/obj/item/clothing/head/hats/syndicate/interdyne_deckofficer_black
	name = "黑色甲板军官帽"
	desc = "一顶黑色的军官帽，要求佩戴者严守纪律。"
	icon_state = "ip_officercap_black"
	armor_type = /datum/armor/sec_navywarden
	icon = 'modular_nova/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/head.dmi'

/obj/item/clothing/head/hats/syndicate/interdyne_deckofficer_white
	name = "白色甲板军官帽"
	desc = "一顶白色的军官帽，要求佩戴者严守纪律。"
	icon_state = "ip_officercap_white"
	armor_type = /datum/armor/sec_navywarden
	icon = 'modular_nova/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/head.dmi'

/obj/item/clothing/head/bio_hood/interdyne
	name = "Interdyne生化防护头盔"
	desc = "一款Interdyne制药公司的生化防护头盔，旨在保护穿戴者免受生物危害物质的侵害。"
	icon_state = "ip_biosuit_head"
	icon = 'modular_nova/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/head.dmi'

/obj/item/clothing/suit/bio_suit/interdyne
	name = "Interdyne生化防护服"
	desc = "一款Interdyne制药公司的生化防护服，旨在保护穿戴者免受生物危害物质的侵害。它比典型的生化防护服更轻便。"
	icon_state = "ip_biosuit"
	icon = 'modular_nova/master_files/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/suit.dmi'
	slowdown = 0.3
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/suit/armor/hos/deckofficer
	name = "甲板军官斗篷"
	desc = "一件带有绿色装饰的装甲战壕斗篷，由Interdyne公司的高级职员穿着。"
	icon_state = "ip_officercloak"
	icon = 'modular_nova/master_files/icons/obj/clothing/suits/armor.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/suits/armor.dmi'
	worn_icon_teshari = 'modular_nova/master_files/icons/mob/clothing/species/teshari/suit.dmi'

/obj/item/clothing/suit/armor/hos/deckofficer/setup_reskins()
	return

/obj/item/clothing/suit/toggle/labcoat/nova/interdyne_labcoat/black
	name = "Interdyne黑色实验袍"
	desc = "一件黑色实验袍，饰有Interdyne标志性的绿色。"
	icon_state = "ip_labcoatblack"
	worn_icon_teshari = 'modular_nova/master_files/icons/mob/clothing/species/teshari/suit.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/suit/toggle/labcoat/nova/interdyne_labcoat/white
	name = "Interdyne白色实验袍"
	desc = "一件白色实验袍，饰有Interdyne标志性的绿色。"
	icon_state = "ip_labcoatwhite"
	worn_icon_teshari = 'modular_nova/master_files/icons/mob/clothing/species/teshari/suit.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON


/obj/item/clothing/suit/syndicate/interdyne_jacket
	name = "Interdyne夹克"
	desc = "一件绿色的高能见度夹克，带有Interdyne公司的配色。"
	icon_state = "ip_armorlabcoat"
	icon = 'modular_nova/master_files/icons/obj/clothing/suits/labcoat.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/suits/labcoat.dmi'
	armor_type = /datum/armor/wintercoat_syndicate
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/suit/toggle/labcoat/nova/fancy/rd/deckofficer
	icon_state = "/obj/item/clothing/suit/toggle/labcoat/nova/fancy/rd/deckofficer"
	greyscale_colors = "#FFFFFF#4F8F56"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/suit/hooded/wintercoat/medical/viro/interdyne
	name = "因特戴恩冬季大衣"
	desc = "一件带有因特戴恩配色、毛茸茸的冬季大衣，配有装甲纤维。"
	armor_type = /datum/armor/wintercoat_syndicate
//Interdyne Clothing End
