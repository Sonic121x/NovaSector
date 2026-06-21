/obj/item/clothing/suit/hooded/seva
	name = "SEVA防护服"
	desc = "一件用于探索高温环境的防火服。其设计不允许使用歌利亚板进行升级。"
	icon = 'modular_nova/master_files/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/suit.dmi'
	worn_icon_muzzled = 'modular_nova/master_files/icons/mob/clothing/suit_digi.dmi'
	worn_icon_teshari = 'modular_nova/master_files/icons/mob/clothing/species/teshari/suit.dmi'
	icon_state = "seva"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	flags_inv = HIDEJUMPSUIT|HIDETAIL
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	w_class = WEIGHT_CLASS_BULKY
	max_heat_protection_temperature = ARMOR_MAX_TEMP_PROTECT
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	hoodtype = /obj/item/clothing/head/hooded/seva
	armor_type = /datum/armor/hooded_seva
	resistance_flags = FIRE_PROOF
	transparent_protection = HIDEJUMPSUIT

/obj/item/clothing/suit/hooded/seva/Initialize(mapload)
	. = ..()
	allowed = GLOB.mining_suit_allowed

/datum/armor/hooded_seva
	melee = 20
	bullet = 10
	laser = 10
	energy = 10
	bomb = 30
	bio = 50
	fire = 100
	acid = 50
	wound = 10

/obj/item/clothing/head/hooded/seva
	name = "SEVA头罩"
	desc = "一个用于探索高温环境的防火头罩。其设计不允许使用歌利亚板进行升级。"
	icon = 'modular_nova/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/head.dmi'
	worn_icon_muzzled = 'modular_nova/master_files/icons/mob/clothing/head_muzzled.dmi'
	worn_icon_teshari = 'modular_nova/master_files/icons/mob/clothing/species/teshari/head.dmi'
	icon_state = "seva"
	body_parts_covered = HEAD
	flags_inv = HIDEHAIR|HIDEFACE|HIDEEARS|HIDESNOUT
	cold_protection = HEAD
	heat_protection = HEAD
	max_heat_protection_temperature = ARMOR_MAX_TEMP_PROTECT
	clothing_traits = list(TRAIT_ASHSTORM_IMMUNE)
	armor_type = /datum/armor/hooded_seva
	resistance_flags = FIRE_PROOF
	supports_variations_flags = CLOTHING_SNOUTED_VARIATION //I can't find the snout sprite so I'm just gonna force it to do this

/obj/item/clothing/mask/gas/seva
	name = "SEVA面罩"
	desc = "一种可连接外部供气系统的全覆盖式面罩。专为配合SEVA防护服使用而设计。"
	icon = 'modular_nova/master_files/icons/obj/clothing/masks.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/mask.dmi'
	worn_icon_teshari = 'modular_nova/master_files/icons/mob/clothing/species/teshari/mask.dmi'
	icon_state = "seva"
	dirt_state = "gas_wide_dirt"
	resistance_flags = FIRE_PROOF
	flags_inv = HIDEFACIALHAIR|HIDEFACE|HIDEEYES|HIDEEARS|HIDEHAIR|HIDESNOUT
