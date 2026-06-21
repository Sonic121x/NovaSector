/obj/item/clothing/gloves/ball_mittens
	name = "球形连指手套"
	desc = "一副球形连指手套；用于限制佩戴者的双手并阻止精细运动控制。"
	worn_icon = 'modular_nova/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_gloves.dmi'
	greyscale_colors = "#383840"
	icon = 'icons/map_icons/clothing/_clothing.dmi'
	icon_state = "/obj/item/clothing/gloves/ball_mittens"
	post_init_icon_state = "ball_mittens"
	greyscale_config = /datum/greyscale_config/ball_mittens
	greyscale_config_worn = /datum/greyscale_config/ball_mittens/worn
	flags_1 = IS_PLAYER_COLORABLE_1
	obj_flags_nova = ERP_ITEM
	breakouttime = 1 SECONDS
	resist_cooldown = CLICK_CD_SLOW

/// Reinforce the breakout time on this, if that's your thing
/obj/item/clothing/gloves/ball_mittens/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers)
	. = ..()
	if(.)
		return
	if(!istype(attacking_item, /obj/item/restraints/handcuffs) || !initial(breakouttime))
		return
	to_chat(user, span_notice("你用[attacking_item]加固了[src]上的带子。"))
	name = "加固的[initial(name)]"
	clothing_flags = DANGEROUS_OBJECT
	breakouttime = 100 SECONDS
	qdel(attacking_item)
	return TRUE

/obj/item/clothing/gloves/ball_mittens/examine(mob/user)
	. = ..()
	if(breakouttime == initial(breakouttime))
		. += span_notice("You could probably reinforce it with a pair of [span_bold("handcuffs")]...")

/// Paw mittens; which vary only in looks from ball mittens
/obj/item/clothing/gloves/ball_mittens/paw_mittens
	name = "爪形连指手套"
	desc = "将手压缩在狭小空间内并限制精细运动控制的连指手套。"
	greyscale_colors = "#383840#dc7ef4"
	icon = 'icons/map_icons/clothing/_clothing.dmi'
	icon_state = "/obj/item/clothing/gloves/ball_mittens/paw_mittens"
	post_init_icon_state = "paw_mittens"
	greyscale_config = /datum/greyscale_config/paw_mittens
	greyscale_config_worn = /datum/greyscale_config/paw_mittens/worn


/// Long (Formerly Latex) Gloves
/obj/item/clothing/gloves/long_gloves
	name = "长手套"
	desc = "一直延伸到肩部的光滑手套。"
	w_class = WEIGHT_CLASS_SMALL
	worn_icon = 'modular_nova/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_gloves.dmi'
	greyscale_colors = "#383840"
	icon = 'icons/map_icons/clothing/_clothing.dmi'
	icon_state = "/obj/item/clothing/gloves/long_gloves"
	post_init_icon_state = "long_gloves"
	greyscale_config = /datum/greyscale_config/long_gloves
	greyscale_config_worn = /datum/greyscale_config/long_gloves/worn
	flags_1 = IS_PLAYER_COLORABLE_1
