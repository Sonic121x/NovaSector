// Mask skins
/datum/atom_skin/joy_mask
	abstract_type = /datum/atom_skin/joy_mask
	change_base_icon_state = TRUE

/datum/atom_skin/joy_mask/joy
	preview_name = "Joy"
	new_icon_state = "joy"

/datum/atom_skin/joy_mask/flushed
	preview_name = "Flushed"
	new_icon_state = "flushed"

/datum/atom_skin/joy_mask/pensive
	preview_name = "Pensive"
	new_icon_state = "pensive"

/datum/atom_skin/joy_mask/angry
	preview_name = "Angry"
	new_icon_state = "angry"

/datum/atom_skin/joy_mask/pleading
	preview_name = "Pleading"
	new_icon_state = "pleading"

/obj/item/clothing/mask/joy
	name = "情绪面具"
	desc = "用这个精致的剪影来表达你的快乐或隐藏你的悲伤。"
	icon_state = "joy"
	base_icon_state = "joy"
	clothing_flags = MASKINTERNALS
	flags_inv = HIDESNOUT

/obj/item/clothing/mask/joy/setup_reskins()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/joy_mask, infinite = TRUE)

/obj/item/clothing/mask/mummy
	name = "木乃伊面具"
	desc = "古老的绷带。"
	icon_state = "mummy_mask"
	inhand_icon_state = null
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT

/obj/item/clothing/mask/scarecrow
	name = "口罩"
	desc = "一个带有眼孔的麻布袋。"
	icon_state = "scarecrow_sack"
	inhand_icon_state = null
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT

/obj/item/clothing/mask/kitsune
	name = "狐面"
	desc = "以太阳系第三区风格制作的瓷面具。被涂绘成狐狸的样子。"
	inhand_icon_state = null
	w_class = WEIGHT_CLASS_SMALL
	adjusted_flags = ITEM_SLOT_HEAD
	flags_inv = HIDEFACE|HIDEFACIALHAIR
	custom_price = PAYCHECK_CREW
	greyscale_colors = "#EEEEEE#AA0000"
	icon = 'icons/map_icons/clothing/mask.dmi'
	icon_state = "/obj/item/clothing/mask/kitsune"
	post_init_icon_state = "kitsune"
	greyscale_config = /datum/greyscale_config/kitsune
	greyscale_config_worn = /datum/greyscale_config/kitsune/worn
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/mask/kitsune/examine(mob/user)
	. = ..()
	if(up)
		. += "Use in-hand to wear as a mask!"
		return
	else
		. += "Use in-hand to wear as a hat!"

/obj/item/clothing/mask/kitsune/attack_self(mob/user)
	adjust_visor(user)
	alternate_worn_layer = up ? ABOVE_BODY_FRONT_HEAD_LAYER : null
	flags_inv = up ? NONE : (HIDEFACE|HIDEFACIALHAIR)

/obj/item/clothing/mask/rebellion
	name = "反抗面具"
	desc = "通常由叛乱分子在起义期间使用的面具。它覆盖整个面部，让你无法被识别。"
	inhand_icon_state = null
	w_class = WEIGHT_CLASS_SMALL
	flags_inv = HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
	custom_price = PAYCHECK_CREW
	visor_flags = MASKINTERNALS
	greyscale_colors = COLOR_VERY_LIGHT_GRAY
	alternate_worn_layer = BENEATH_HAIR_LAYER
	icon = 'icons/map_icons/clothing/mask.dmi'
	icon_state = "/obj/item/clothing/mask/rebellion"
	post_init_icon_state = "rebellion_mask"
	greyscale_config = /datum/greyscale_config/rebellion_mask
	greyscale_config_worn = /datum/greyscale_config/rebellion_mask/worn
	flags_1 = IS_PLAYER_COLORABLE_1
	custom_materials = list(/datum/material/plastic = SHEET_MATERIAL_AMOUNT)
