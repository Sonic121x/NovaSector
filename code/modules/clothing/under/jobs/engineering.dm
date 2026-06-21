//Contains: Engineering department jumpsuits

/obj/item/clothing/under/rank/engineering
	icon = 'icons/obj/clothing/under/engineering.dmi'
	worn_icon = 'icons/mob/clothing/under/engineering.dmi'
	abstract_type = /obj/item/clothing/under/rank/engineering
	armor_type = /datum/armor/clothing_under/rank_engineering
	resistance_flags = NONE

/datum/armor/clothing_under/rank_engineering
	fire = 60
	acid = 20

/obj/item/clothing/under/rank/engineering/chief_engineer
	desc = "这是一件高能见度连身衣，专为那些疯狂到能获得\\“总工程师\\”头衔的工程师准备。采用防火材料制成。"
	name = "工程部长连身衣"
	icon_state = "chiefengineer"
	inhand_icon_state = "gy_suit"
	armor_type = /datum/armor/clothing_under/engineering_chief_engineer

/datum/armor/clothing_under/engineering_chief_engineer
	fire = 80
	acid = 40

/obj/item/clothing/under/rank/engineering/chief_engineer/skirt
	name = "工程部长连身裙"
	desc = "这是一件高能见度连身裙，专为那些疯狂到能获得\\“首席工程师\\”头衔的工程师准备。采用防火材料制成。"
	icon_state = "chief_skirt"
	inhand_icon_state = "gy_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/engineering/chief_engineer/turtleneck
	name = "总工程师高领毛衣"
	desc = "一件黄色高领毛衣和白色卡其裤，适合拥有卓越时尚品位的总工程师。"
	icon_state = "ceturtle"
	inhand_icon_state = "y_suit"
	can_adjust = TRUE
	alt_covers_chest = TRUE
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY

/obj/item/clothing/under/rank/engineering/chief_engineer/turtleneck/skirt
	name = "总工程师高领毛衣裙"
	desc = "一件黄色高领毛衣和白色卡其裙，适合拥有卓越时尚品位的总工程师。"
	icon_state = "ceturtle_skirt"
	inhand_icon_state = "y_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/engineering/atmospheric_technician
	desc = "这是大气技术人员穿的连身衣。由耐火材料制成。"
	name = "大气技术员连身衣"
	icon_state = "atmos"
	inhand_icon_state = "atmos_suit"

/obj/item/clothing/under/rank/engineering/atmospheric_technician/skirt
	name = "大气技术员连身裙"
	desc = "这是大气技术人员穿的连身裙。由耐火材料制成。"
	icon_state = "atmos_skirt"
	inhand_icon_state = "atmos_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/engineering/engineer
	desc = "这是一件橙色的高能见度连身衣，由工程师穿着。采用防火材料制成。"
	name = "工程师连身衣"
	icon_state = "engine"
	inhand_icon_state = "engi_suit"

/obj/item/clothing/under/rank/engineering/engineer/hazard
	name = "工程师工作连身衣"
	desc = "高可视性连身衣。由耐火材料制成。"
	icon_state = "hazard"
	inhand_icon_state = "syndicate-orange"
	alt_covers_chest = TRUE

/obj/item/clothing/under/rank/engineering/engineer/skirt
	name = "工程师连身裙"
	desc = "这是一件橙色的高能见度连身裙，供工程师穿着，采用防火材料制成。"
	icon_state = "engine_skirt"
	inhand_icon_state = "engi_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
