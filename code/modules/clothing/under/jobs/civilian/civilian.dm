//Alphabetical order of civilian jobs.

/obj/item/clothing/under/rank/civilian
	icon = 'icons/obj/clothing/under/civilian.dmi'
	worn_icon = 'icons/mob/clothing/under/civilian.dmi'
	abstract_type = /obj/item/clothing/under/rank/civilian

/obj/item/clothing/under/rank/civilian/purple_bartender
	desc = "它看起来很有风格！"
	name = "紫色酒保制服"
	icon_state = "purplebartender"
	can_adjust = FALSE

/obj/item/clothing/under/rank/civilian/chaplain
	desc = "那是一件黑色连身衣，通常是宗教人士穿的。"
	name = "牧师连身衣"
	icon_state = "chaplain"
	inhand_icon_state = "bl_suit"
	can_adjust = FALSE

/obj/item/clothing/under/rank/civilian/chaplain/skirt
	name = "牧师连身裙"
	desc = "那是一件黑色连身裙，通常是宗教人士穿的。"
	icon_state = "chapblack_skirt"
	inhand_icon_state = "bl_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/civilian/head_of_personnel
	desc = "那些获得了“人事主管”职位的人所穿的光鲜亮丽的制服。"
	name = "人事部长制服"
	icon_state = "hop"
	inhand_icon_state = "b_suit"

/obj/item/clothing/under/rank/civilian/head_of_personnel/skirt
	name = "人事部长裙"
	desc = "那些获得了“人事主管”职位的人所穿的光鲜亮丽的裙子。"
	icon_state = "hop_skirt"
	inhand_icon_state = "b_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/civilian/hydroponics
	desc = "这是一件连身衣，可以防止轻微的植物性伤害。"
	name = "植物学家连身衣"
	icon_state = "hydroponics"
	inhand_icon_state = "g_suit"
	armor_type = /datum/armor/clothing_under/civilian_hydroponics

/datum/armor/clothing_under/civilian_hydroponics
	bio = 50

/obj/item/clothing/under/rank/civilian/hydroponics/skirt
	name = "植物学家连身裙"
	desc = "这是一件连身裙，可以防止轻微的植物性伤害。"
	icon_state = "hydroponics_skirt"
	inhand_icon_state = "g_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/civilian/janitor
	desc = "这是空间站清洁工的制服，它对生物危害有一定的防护能力。"
	name = "清洁工连身衣"
	icon_state = "janitor"
	inhand_icon_state = "janitor"
	armor_type = /datum/armor/clothing_under/civilian_janitor

/datum/armor/clothing_under/civilian_janitor
	bio = 10

/obj/item/clothing/under/rank/civilian/janitor/skirt
	name = "清洁工连身裙"
	desc = "这是空间站清洁工的裙子，它对生物危害有一定的防护能力。"
	icon_state = "janitor_skirt"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/civilian/janitor/maid
	name = "女仆装"
	desc = "一套简单的客房服务女仆制服。"
	icon_state = "janimaid"
	inhand_icon_state = "janimaid"
	body_parts_covered = CHEST|GROIN
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	can_adjust = FALSE
	clothing_flags = parent_type::clothing_flags | CARP_STYLE_FACTOR //weebs are going to lvoe this

/obj/item/clothing/under/rank/civilian/lawyer
	name = "律师套装"
	desc = "时髦的装束。"
	icon = 'icons/obj/clothing/under/suits.dmi'
	worn_icon = 'icons/mob/clothing/under/suits.dmi'
	abstract_type = /obj/item/clothing/under/rank/civilian/lawyer
	can_adjust = FALSE

/obj/item/clothing/under/rank/civilian/lawyer/dye_item(dye_color, dye_key_override)
	if(dye_color == DYE_COSMIC || dye_color == DYE_SYNDICATE)
		if(dying_key == DYE_REGISTRY_JUMPSKIRT)
			return ..(dye_color, DYE_LAWYER_SPECIAL_SKIRT)
		else
			return ..(dye_color, DYE_LAWYER_SPECIAL)
	else
		return ..()

/obj/item/clothing/under/rank/civilian/lawyer/black
	name = "黑色律师套装"
	icon_state = "lawyer_black"
	inhand_icon_state = "lawyer_black"

/obj/item/clothing/under/rank/civilian/lawyer/black/skirt
	name = "黑色律师套裙"
	icon_state = "lawyer_black_skirt"
	inhand_icon_state = "lawyer_black"
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/civilian/lawyer/beige
	name = "好律师西装"
	desc = "一套俗气的西装，非常适合那些为犯罪辩护的律师！"
	icon_state = "good_suit"
	inhand_icon_state = "good_suit"

/obj/item/clothing/under/rank/civilian/lawyer/beige/skirt
	name = "好律师西装裙"
	desc = "一套俗气的西装裙，非常适合那些为犯罪辩护的律师！"
	icon_state = "good_suit_skirt"
	inhand_icon_state = "good_suit"
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/civilian/lawyer/red
	name = "红色律师套装"
	icon_state = "lawyer_red"
	inhand_icon_state = "lawyer_red"

/obj/item/clothing/under/rank/civilian/lawyer/red/skirt
	name = "红色律师套裙"
	icon_state = "lawyer_red_skirt"
	inhand_icon_state = "lawyer_red"
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/civilian/lawyer/blue
	name = "蓝色律师套装"
	icon_state = "lawyer_blue"
	inhand_icon_state = "lawyer_blue"

/obj/item/clothing/under/rank/civilian/lawyer/blue/skirt
	name = "蓝色律师套裙"
	icon_state = "lawyer_blue_skirt"
	inhand_icon_state = "lawyer_blue"
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/civilian/lawyer/bluesuit
	name = "蓝色纽扣衬衫西装"
	worn_icon = 'icons/mob/clothing/under/shorts_pants_shirts.dmi'
	icon = 'icons/map_icons/clothing/under/_under.dmi'
	icon_state = "/obj/item/clothing/under/rank/civilian/lawyer/bluesuit"
	post_init_icon_state = "buttondown_slacks"
	greyscale_config = /datum/greyscale_config/buttondown_slacks
	greyscale_config_worn = /datum/greyscale_config/buttondown_slacks/worn
	greyscale_colors = "#EEEEEE#CBDBFC#17171B#2B65A8"
	can_adjust = TRUE
	alt_covers_chest = TRUE

/obj/item/clothing/under/rank/civilian/lawyer/bluesuit/skirt
	name = "蓝色纽扣衬衫西装裙"
	icon = 'icons/map_icons/clothing/under/_under.dmi'
	icon_state = "/obj/item/clothing/under/rank/civilian/lawyer/bluesuit/skirt"
	post_init_icon_state = "buttondown_skirt"
	greyscale_config = /datum/greyscale_config/buttondown_skirt
	greyscale_config_worn = /datum/greyscale_config/buttondown_skirt/worn
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/civilian/lawyer/purpsuit
	name = "紫色套装"
	icon_state = "lawyer_purp"
	inhand_icon_state = "p_suit"
	female_sprite_flags = NO_FEMALE_UNIFORM
	can_adjust = TRUE
	alt_covers_chest = TRUE

/obj/item/clothing/under/rank/civilian/lawyer/purpsuit/skirt
	name = "紫色套裙"
	icon_state = "lawyer_purp_skirt"
	inhand_icon_state = "p_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/civilian/lawyer/galaxy
	icon = 'icons/obj/clothing/under/lawyer_galaxy.dmi'
	worn_icon = 'icons/mob/clothing/under/lawyer_galaxy.dmi'
	can_adjust = FALSE
	name = "蓝银河西装"
	icon_state = "lawyer_galaxy_blue"
	inhand_icon_state = "b_suit"

/obj/item/clothing/under/rank/civilian/lawyer/galaxy/skirt
	name = "蓝色银河西装裙"
	icon_state = "lawyer_galaxy_blue_skirt"
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/civilian/lawyer/galaxy/red
	name = "红银河西装"
	icon_state = "lawyer_galaxy_red"
	inhand_icon_state = "r_suit"

/obj/item/clothing/under/rank/civilian/lawyer/galaxy/red/skirt
	name = "红色银河西装裙"
	icon_state = "lawyer_galaxy_red_skirt"
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/civilian/cookjorts
	name = "烧烤短裤"
	desc = "因为你的人生追求中，重要的一点无非就是做点好吃的。"
	icon_state = "cookjorts"
	inhand_icon_state = "cookjorts"
	can_adjust = FALSE
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
