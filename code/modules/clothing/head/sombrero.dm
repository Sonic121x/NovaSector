/obj/item/clothing/head/costume/sombrero
	name = "宽边帽"
	desc = "你简直能感受到这场庆典的氛围了。"
	icon = 'icons/obj/clothing/head/sombrero.dmi'
	icon_state = "sombrero"
	inhand_icon_state = "sombrero"
	flags_inv = HIDEHAIR

	dog_fashion = /datum/dog_fashion/head/sombrero

/obj/item/clothing/head/costume/sombrero/green
	name = "绿色宽边帽"
	desc = "优雅如一支舞动的仙人掌。"
	icon = 'icons/map_icons/clothing/head/_head.dmi'
	icon_state = "/obj/item/clothing/head/costume/sombrero/green"
	post_init_icon_state = "sombrero"
	flags_inv = HIDEHAIR|HIDEFACE|HIDEEARS
	dog_fashion = null
	greyscale_config = /datum/greyscale_config/sombrero
	greyscale_config_worn = /datum/greyscale_config/sombrero/worn
	greyscale_config_inhand_left = /datum/greyscale_config/sombrero/lefthand
	greyscale_config_inhand_right = /datum/greyscale_config/sombrero/righthand
	greyscale_colors = "#13d968#ffffff"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/head/costume/sombrero/shamebrero
	name = "羞耻帽"
	desc = "一旦戴上，就再也摘不下来了。"
	icon = 'icons/map_icons/clothing/head/_head.dmi'
	icon_state = "/obj/item/clothing/head/costume/sombrero/shamebrero"
	post_init_icon_state = "shamebrero"
	dog_fashion = null
	greyscale_config = /datum/greyscale_config/sombrero
	greyscale_config_worn = /datum/greyscale_config/sombrero/worn
	greyscale_config_inhand_left = /datum/greyscale_config/sombrero/lefthand
	greyscale_config_inhand_right = /datum/greyscale_config/sombrero/righthand
	greyscale_colors = "#d565d3#f8db18"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/head/costume/sombrero/shamebrero/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, SHAMEBRERO_TRAIT)
