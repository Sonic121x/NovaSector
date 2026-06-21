/obj/item/clothing/under/rank/centcom
	icon = 'icons/obj/clothing/under/centcom.dmi'
	worn_icon = 'icons/mob/clothing/under/centcom.dmi'
	abstract_type = /obj/item/clothing/under/rank/centcom

/obj/item/clothing/under/rank/centcom/commander
	name = "\improper 中央指挥部指挥官西装"
	desc = "这是一套由中央指挥部最高层级指挥官穿着的宇航服。"
	icon_state = "centcom"
	inhand_icon_state = "dg_suit"

/obj/item/clothing/under/rank/centcom/official
	name = "\improper 中央指挥部官员西装"
	desc = "这是一套由中央指挥部官员穿着的制服，其银色皮带扣能让人一瞥之间便识别出他们的等级。"
	icon_state = "official"
	inhand_icon_state = "dg_suit"

/obj/item/clothing/under/rank/centcom/intern
	name = "\improper 中央指挥部实习生连身衣"
	desc = "这是一件中央指挥部实习生穿着的连身衣。上衣部分采用Polo衫式样设计，便于识别。"
	icon_state = "intern"
	inhand_icon_state = "dg_suit"
	can_adjust = FALSE

/obj/item/clothing/under/rank/centcom/officer
	name = "\improper 中央指挥部高领毛衣套装"
	desc = "一件休闲却又不失精致的绿色高领毛衣，供中央指挥部军官使用。它带有芦荟的清香。"
	icon_state = "officer"
	inhand_icon_state = "dg_suit"
	alt_covers_chest = TRUE

/obj/item/clothing/under/rank/centcom/officer/replica
	name = "\improper 中央指挥部高领毛衣复制品"
	desc = "一件中央指挥部高领毛衣的廉价仿冒品！衣领上还能看到杜克公司的商标。"

/obj/item/clothing/under/rank/centcom/officer_skirt
	name = "\improper 中央指挥部高领毛衣裙"
	desc = "这是中央指挥部高领毛衣的裙装版本，比原版更稀有、更受追捧。"
	icon_state = "officer_skirt"
	inhand_icon_state = "dg_suit"
	alt_covers_chest = TRUE
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	body_parts_covered = CHEST|GROIN|ARMS
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/centcom/officer_skirt/replica
	name = "\improper 裙装版中央指挥部高领毛衣复制品"
	desc = "一件中央指挥部高领毛衣裙装的廉价仿冒品！衣领上还能看到杜克公司的商标。"

/obj/item/clothing/under/rank/centcom/centcom_skirt
	name = "\improper 中央指挥部指挥官连身裙"
	desc = "这是中央指挥部最高级指挥官穿的连身裙。"
	icon_state = "centcom_skirt"
	inhand_icon_state = "dg_suit"
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	body_parts_covered = CHEST|GROIN|ARMS
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/centcom/military
	name = "战术战斗制服"
	desc = "一套由中央指挥部征召兵部队穿着的深色制服。"
	icon_state = "military"
	inhand_icon_state = "bl_suit"
	can_adjust = FALSE
	armor_type = /datum/armor/clothing_under/centcom_military

/datum/armor/clothing_under/centcom_military
	melee = 10
	fire = 50
	acid = 40
	wound = 10

/obj/item/clothing/under/rank/centcom/military/eng
	name = "战术工程制服"
	desc = "一套中央司令部常规军事工程师穿着的深色制服。"
	icon_state = "military_eng"
