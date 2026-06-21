/obj/item/clothing/under/greyscale
	icon = 'modular_nova/master_files/icons/obj/clothing/under/shorts_pants_shirts.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/under/shorts_pants_shirts.dmi'
	worn_icon_digi = 'modular_nova/master_files/icons/mob/clothing/under/shorts_pants_shirts_digi.dmi'
	// Defaults to FALSE for this type because greyscale items are less commonly adjustable
	can_adjust = FALSE

/*
*	This file is for things that are recolorable and/or mix-and-match. Things like Jeans, T-Shirts, Skirts.
*	Basically the hope is that items here will reuse component icons that already exist in the .dmis where possible.
*
*	(Do not put items here that are too specific. These should generally be generic, customizable uniforms.)
*	These will likely fit in the CASUALWEAR loadout category.
*/

/obj/item/clothing/under/greyscale/turtleneck
	name = "高领衫配长裤"
	desc = "一件相当舒适的高领衫搭配长裤。真是结实的线头啊。"
	icon = 'icons/map_icons/clothing/under/_under.dmi'
	icon_state = "/obj/item/clothing/under/greyscale/turtleneck"
	post_init_icon_state = "turtleneck"
	greyscale_config = /datum/greyscale_config/turtlenecks
	greyscale_config_worn = /datum/greyscale_config/turtlenecks/worn
	greyscale_config_worn_digi = /datum/greyscale_config/turtlenecks/worn/digi
	greyscale_colors = "#787878#252525"
	can_adjust = TRUE
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/under/greyscale/turtleneck/skirt
	name = "高领衫配短裙"
	desc = "一件相当舒适的高领衫搭配短裙。可以称之为裙领衫。"
	icon_state = "/obj/item/clothing/under/greyscale/turtleneck/skirt"
	post_init_icon_state = "skirtleneck"
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	body_parts_covered = CHEST|GROIN
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON | CLOTHING_BIG_LEGS_MASK
	gets_cropped_on_taurs = FALSE

/obj/item/clothing/under/greyscale/gorkas
	name = "戈尔卡连体服"
	desc = "一件还算舒适的戈尔卡，和普通连体服一样舒适，但设计更独特。"
	icon = 'icons/map_icons/clothing/under/_under.dmi'
	icon_state = "/obj/item/clothing/under/greyscale/gorkas"
	post_init_icon_state = "gags_gorka"
	greyscale_config = /datum/greyscale_config/gorkas
	greyscale_config_worn = /datum/greyscale_config/gorkas/worn
	greyscale_config_worn_digi = /datum/greyscale_config/gorkas/worn/digi
	greyscale_colors = "#787878#252525"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/under/greyscale/overalls
	name = "高领衫配背带裤"
	desc = "穿在高领衫外面的背带裤。这种组合提供了舒适和覆盖……或者，至少是覆盖。"
	icon = 'icons/map_icons/clothing/under/_under.dmi'
	icon_state = "/obj/item/clothing/under/greyscale/overalls"
	post_init_icon_state = "overalls"
	greyscale_config = /datum/greyscale_config/sus_overalls
	greyscale_config_worn = /datum/greyscale_config/sus_overalls/worn
	greyscale_config_worn_digi = /datum/greyscale_config/sus_overalls/worn/digi
	greyscale_colors = "#787878#252525#CCCED1"
	flags_1 = IS_PLAYER_COLORABLE_1
	can_adjust = TRUE

/obj/item/clothing/under/greyscale/overalls/skirt
	name = "高领衫配背带裙"
	desc = "穿在高领衫外面的背带裙。这种组合提供了舒适和覆盖……或者，至少——不，等等，这个其实两样都没提供。"
	icon_state = "/obj/item/clothing/under/greyscale/overalls/skirt"
	post_init_icon_state = "overalls_skirt"
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	body_parts_covered = CHEST|GROIN
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON | CLOTHING_BIG_LEGS_MASK
	gets_cropped_on_taurs = FALSE

/obj/item/clothing/under/greyscale/playsuit
	name = "连衣裤"
	desc = "为了对游戏的热爱。"
	icon = 'icons/map_icons/clothing/under/_under.dmi'
	icon_state = "/obj/item/clothing/under/greyscale/playsuit"
	post_init_icon_state = "playsuit"
	greyscale_config = /datum/greyscale_config/playsuit
	greyscale_config_worn = /datum/greyscale_config/playsuit/worn
	greyscale_config_worn_digi = /datum/greyscale_config/playsuit/worn/digi
	greyscale_colors = "#787878#252525#CCCED1#787878"
	flags_1 = IS_PLAYER_COLORABLE_1
	can_adjust = FALSE
