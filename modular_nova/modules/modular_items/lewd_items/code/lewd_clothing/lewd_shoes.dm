/// Sprite doesn't visually represent the verticality correctly but the description at time of rewrite implied this was the 'intended' item?? idk. just going with it
/obj/item/clothing/shoes/ballet_heels
	name = "芭蕾舞高跟鞋"
	desc = "限制性的及膝高跟鞋。行走起来极其困难。"
	worn_icon = 'modular_nova/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_shoes.dmi'
	greyscale_colors = "#383840"
	icon = 'icons/map_icons/clothing/shoes.dmi'
	icon_state = "/obj/item/clothing/shoes/ballet_heels"
	post_init_icon_state = "balletheels"
	greyscale_config = /datum/greyscale_config/ballet_heel
	greyscale_config_worn = /datum/greyscale_config/ballet_heel/worn
	greyscale_config_worn_digi = /datum/greyscale_config/ballet_heel/worn/digi
	flags_1 = IS_PLAYER_COLORABLE_1
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION

/obj/item/clothing/shoes/ballet_heels/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/squeak, list('modular_nova/master_files/sound/effects/footstep/highheel1.ogg' = 1, 'modular_nova/master_files/sound/effects/footstep/highheel2.ogg' = 1), 70)

/obj/item/clothing/shoes/ballet_heels/domina_heels
	name = "支配者高跟鞋"
	desc = "一双美观悦目的高跟鞋。"
	icon = 'modular_nova/modules/modular_items/lewd_items/icons/obj/lewd_clothing/lewd_shoes.dmi'
	icon_state = "dominaheels"
	greyscale_colors = null
	greyscale_config = null
	greyscale_config_worn = null
	greyscale_config_worn_digi = null
	post_init_icon_state = null

/*
*	LATEX SOCKS
*/

/obj/item/clothing/shoes/latex_socks
	name = "乳胶袜"
	desc = "一双由某种奇特材料制成的、闪亮的分趾袜。"
	w_class = WEIGHT_CLASS_SMALL
	worn_icon = 'modular_nova/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_shoes.dmi'
	greyscale_colors = "#383840"
	icon = 'icons/map_icons/clothing/shoes.dmi'
	icon_state = "/obj/item/clothing/shoes/latex_socks"
	post_init_icon_state = "latex_socks"
	greyscale_config = /datum/greyscale_config/latex_socks
	greyscale_config_worn = /datum/greyscale_config/latex_socks/worn
	greyscale_config_worn_digi = /datum/greyscale_config/latex_socks/worn/digi
	flags_1 = IS_PLAYER_COLORABLE_1
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION
