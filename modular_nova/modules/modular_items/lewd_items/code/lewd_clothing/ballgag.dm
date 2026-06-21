/obj/item/clothing/mask/muzzle/ballgag
	name = "口球"
	desc = "阻止佩戴者说话。"
	worn_icon = 'modular_nova/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_masks.dmi'
	worn_icon_muzzled = 'modular_nova/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_masks_muzzled.dmi'
	greyscale_colors = "#383840#dc7ef4"
	icon = 'icons/map_icons/clothing/mask.dmi'
	icon_state = "/obj/item/clothing/mask/muzzle/ballgag"
	post_init_icon_state = "ballgag"
	greyscale_config = /datum/greyscale_config/ball_gag
	greyscale_config_worn = /datum/greyscale_config/ball_gag/worn
	greyscale_config_worn_muzzled = /datum/greyscale_config/dorms_mask/worn/muzzled
	flags_1 = IS_PLAYER_COLORABLE_1
	w_class = WEIGHT_CLASS_SMALL
	flags_cover = MASKCOVERSMOUTH
	obj_flags_nova = ERP_ITEM

/datum/atom_skin/ballgag
	abstract_type = /datum/atom_skin/ballgag
	greyscale_item_path = /obj/item/clothing/mask/muzzle/ballgag/choking

/datum/atom_skin/ballgag/small
	preview_name = "Small"
	new_icon_state = "chokegag_small"

/datum/atom_skin/ballgag/medium
	preview_name = "Medium"
	new_icon_state = "chokegag_medium"

/datum/atom_skin/ballgag/large
	preview_name = "Large"
	new_icon_state = "chokegag_large"

/obj/item/clothing/mask/muzzle/ballgag/choking
	name = "阴茎口球"
	desc = "阻止佩戴者说话，同时使呼吸更加困难。"
	worn_icon_state = "ballgag"
	icon = 'icons/map_icons/clothing/mask.dmi'
	icon_state = "/obj/item/clothing/mask/muzzle/ballgag/choking"
	post_init_icon_state = "chokegag_small"
	greyscale_config = /datum/greyscale_config/ball_gag/choke_gag

/obj/item/clothing/mask/muzzle/ballgag/choking/setup_reskins()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/ballgag, infinite = TRUE)

/obj/item/clothing/mask/muzzle/ring
	name = "环形口塞"
	desc = "一种似乎设计用来保持嘴巴张开的嘴部束缚物。"
	icon = 'modular_nova/modules/modular_items/lewd_items/icons/obj/lewd_clothing/lewd_masks.dmi'
	worn_icon = 'modular_nova/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_masks.dmi'
	worn_icon_muzzled = 'modular_nova/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_masks_muzzled.dmi'
	icon_state = "ringgag"
	obj_flags_nova = ERP_ITEM
