// Accessories that mostly or entirely cover a shirt.
/obj/item/clothing/accessory/waistcoat
	name = "马甲"
	desc = "为了某些优雅而致命的乐趣。"
	icon = 'icons/map_icons/clothing/accessory.dmi'
	icon_state = "/obj/item/clothing/accessory/waistcoat"
	post_init_icon_state = "waistcoat"
	inhand_icon_state = "wcoat"
	lefthand_file = 'icons/mob/inhands/clothing/suits_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/clothing/suits_righthand.dmi'
	minimize_when_attached = FALSE
	attachment_slot = NONE
	greyscale_config = /datum/greyscale_config/waistcoat
	greyscale_config_worn = /datum/greyscale_config/waistcoat/worn
	greyscale_colors = "#414344"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/accessory/sweatervest
	name = "sweater vest"
	desc = "When you're exceptionally you."
	icon = 'icons/map_icons/clothing/accessory.dmi'
	icon_state = "/obj/item/clothing/accessory/sweatervest"
	post_init_icon_state = "sweatervest"
	inhand_icon_state = "svest"
	lefthand_file = 'icons/mob/inhands/clothing/suits_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/clothing/suits_righthand.dmi'
	minimize_when_attached = FALSE
	attachment_slot = NONE
	greyscale_config = /datum/greyscale_config/sweatervest
	greyscale_config_worn = /datum/greyscale_config/sweatervest/worn
	greyscale_colors = "#A52F29"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/accessory/vest_sheriff
	name = "警长马甲"
	desc = "现在你只需要挑选你最喜欢的副手了。"
	icon_state = "vest_sheriff"
	lefthand_file = 'icons/mob/inhands/clothing/suits_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/clothing/suits_righthand.dmi'
	inhand_icon_state = "vest_sheriff"
	minimize_when_attached = TRUE
	attachment_slot = NONE

/obj/item/clothing/accessory/maidapron
	name = "女仆围裙"
	desc = "女仆装最好的部分。"
	icon_state = "maidapron"
	inhand_icon_state = "maidapron"
	lefthand_file = 'icons/mob/inhands/clothing/suits_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/clothing/suits_righthand.dmi'
	minimize_when_attached = FALSE
	attachment_slot = NONE
