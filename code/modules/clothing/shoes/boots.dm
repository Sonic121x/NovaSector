/obj/item/clothing/shoes/combat //basic syndicate combat boots for nuke ops and mob corpses
	name = "战斗靴"
	desc = "高速，低阻力作战靴。"
	icon_state = "jackboots"
	inhand_icon_state = "jackboots"
	supports_variations_flags = CLOTHING_DIGITIGRADE_MASK
	body_parts_covered = FEET|LEGS
	armor_type = /datum/armor/shoes_combat
	strip_delay = 4 SECONDS
	resistance_flags = NONE
	lace_time = 12 SECONDS

/datum/armor/shoes_combat
	melee = 25
	bullet = 25
	laser = 25
	energy = 25
	bomb = 50
	bio = 90
	fire = 70
	acid = 50

/obj/item/clothing/shoes/combat/Initialize(mapload)
	. = ..()
	create_storage(storage_type = /datum/storage/pockets/shoes)
	AddElement(/datum/element/ignites_matches)

/obj/item/clothing/shoes/combat/swat //overpowered boots for death squads
	name = "\improper 特警靴"
	desc = "高速，无阻力的战斗靴。"
	clothing_traits = list(TRAIT_NO_SLIP_WATER)
	armor_type = /datum/armor/combat_swat

/datum/armor/combat_swat
	melee = 40
	bullet = 30
	laser = 25
	energy = 25
	bomb = 50
	bio = 100
	fire = 90
	acid = 50

/obj/item/clothing/shoes/jackboots
	name = "长筒靴"
	desc = "纳米传讯发放的安保战斗靴，适用于各种战斗场景和战斗情况.无时不刻，枕戈待旦."
	icon_state = "jackboots"
	inhand_icon_state = "jackboots"
	supports_variations_flags = CLOTHING_DIGITIGRADE_MASK
	strip_delay = 3 SECONDS
	equip_delay_other = 5 SECONDS
	resistance_flags = NONE
	armor_type = /datum/armor/shoes_jackboots
	fastening_type = SHOES_SLIPON
	body_parts_covered = FEET|LEGS

/datum/armor/shoes_jackboots
	bio = 90

/obj/item/clothing/shoes/jackboots/Initialize(mapload)
	. = ..()
	create_storage(storage_type = /datum/storage/pockets/shoes)
	AddElement(/datum/element/ignites_matches)

/obj/item/clothing/shoes/jackboots/fast
	slowdown = -1

/obj/item/clothing/shoes/jackboots/sec
	icon_state = "jackboots_sec"

/obj/item/clothing/shoes/jackboots/floortile
	name = "地砖迷彩军靴"
	desc = "是我的错觉吗，地上怎么有双军靴？"
	icon_state = "ftc_boots"
	inhand_icon_state = null
	supports_variations_flags = NONE

/obj/item/clothing/shoes/jackboots/floortile/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, -5) //tacticool

/obj/item/clothing/shoes/winterboots
	name = "冬靴"
	desc = "Boots lined with 'synthetic' animal fur."
	icon_state = "winterboots"
	inhand_icon_state = null
	supports_variations_flags = CLOTHING_DIGITIGRADE_MASK
	armor_type = /datum/armor/shoes_winterboots
	cold_protection = FEET|LEGS
	min_cold_protection_temperature = SHOES_MIN_TEMP_PROTECT
	heat_protection = FEET|LEGS
	max_heat_protection_temperature = SHOES_MAX_TEMP_PROTECT
	lace_time = 8 SECONDS

/datum/armor/shoes_winterboots
	bio = 80

/obj/item/clothing/shoes/winterboots/Initialize(mapload)
	. = ..()
	create_storage(storage_type = /datum/storage/pockets/shoes)
	AddElement(/datum/element/ignites_matches)

/obj/item/clothing/shoes/winterboots/ice_boots
	name = "冰靴"
	desc = "一双冬靴，底部带有特殊的抓地设计，用于防止在冰冻表面滑倒."
	icon_state = "iceboots"
	inhand_icon_state = null
	clothing_traits = list(TRAIT_NO_SLIP_ICE, TRAIT_NO_SLIP_SLIDE, TRAIT_NO_SNOWPRINTS)

// A pair of ice boots intended for general crew EVA use - see EVA winter coat for comparison.
/obj/item/clothing/shoes/winterboots/ice_boots/eva
	name = "\proper 恒温登山靴"
	desc = "一双厚重的靴子，其底部配有防滑纹路，以便在严寒环境中行走时能保持脚部垂直。"
	icon_state = "iceboots_eva"
	w_class = WEIGHT_CLASS_BULKY
	slowdown = 0.25
	armor_type = /datum/armor/ice_boots_eva
	strip_delay = 4 SECONDS
	equip_delay_other = 4 SECONDS
	clothing_flags = parent_type::clothing_flags | THICKMATERIAL
	body_parts_covered = FEET|LEGS
	resistance_flags = NONE

/datum/armor/ice_boots_eva
	melee = 10
	laser = 10
	energy = 10
	bio = 50
	fire = 50
	acid = 10

/obj/item/clothing/shoes/workboots
	name = "工作靴"
	desc = "纳米传讯公司为特别注意职业形象的蓝领阶层提供了工程系带工作靴。"
	icon_state = "workboots"
	inhand_icon_state = "jackboots"
	armor_type = /datum/armor/shoes_workboots
	supports_variations_flags = CLOTHING_DIGITIGRADE_MASK
	strip_delay = 2 SECONDS
	equip_delay_other = 4 SECONDS
	lace_time = 8 SECONDS

/datum/armor/shoes_workboots
	bio = 80

/obj/item/clothing/shoes/workboots/Initialize(mapload)
	. = ..()
	create_storage(storage_type = /datum/storage/pockets/shoes)
	AddElement(/datum/element/ignites_matches)

/obj/item/clothing/shoes/workboots/mining
	name = "采矿靴"
	desc = "防砸钢头采矿靴，适用于在危险环境中进行采矿作业，非常有助于保护脚趾不被压伤。"
	icon_state = "explorer"
	resistance_flags = FIRE_PROOF

/obj/item/clothing/shoes/workboots/black
	name = "战术工作靴"
	desc = "系带工作靴，保护普通灰领工人免受从碎玻璃到掉落钢笔等各种危险的踩踏伤害。"
	icon_state = "workboots_black"

/obj/item/clothing/shoes/russian
	name = "俄式靴子"
	desc = "这鞋很舒服。"
	icon_state = "rus_shoes"
	inhand_icon_state = null
	lace_time = 8 SECONDS
	supports_variations_flags = CLOTHING_DIGITIGRADE_MASK

/obj/item/clothing/shoes/russian/Initialize(mapload)
	. = ..()
	create_storage(storage_type = /datum/storage/pockets/shoes)
	AddElement(/datum/element/ignites_matches)

/obj/item/clothing/shoes/discoshoes
	name = "绿蜥蜴皮鞋"
	desc = "随着岁月的流逝，它们可能已经失去了一些光泽，但这些绿色的蜥蜴皮鞋依然合脚。"
	icon_state = "lizardskin_shoes"
	inhand_icon_state = null

/obj/item/clothing/shoes/jackboots/kim
	name = "航空轰炸手靴子"
	desc = "一双干净利落的靴子，适合长时间工作。"
	icon_state = "aerostatic_boots"
	inhand_icon_state = null

/obj/item/clothing/shoes/pirate
	name = "海盗靴"
	desc = "哟嚯。"
	icon_state = "pirateboots"
	inhand_icon_state = null

/obj/item/clothing/shoes/pirate/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, -4)

/obj/item/clothing/shoes/pirate/armored
	armor_type = /datum/armor/shoes_pirate
	strip_delay = 4 SECONDS
	resistance_flags = NONE
	lace_time = 12 SECONDS
	body_parts_covered = FEET|LEGS

/datum/armor/shoes_pirate
	melee = 25
	bullet = 25
	laser = 25
	energy = 25
	bomb = 50
	bio = 90
	fire = 70
	acid = 50
