/obj/item/clothing/under/ethereal_tunic
	name = "电气人束腰衣"
	desc = "一件简单的无袖外衣，套在内衣外面，它在黑暗中发光！"
	icon = 'icons/map_icons/clothing/under/_under.dmi'
	worn_icon = 'icons/mob/clothing/under/ethereal.dmi'
	icon_state = "/obj/item/clothing/under/ethereal_tunic"
	post_init_icon_state = "eth_tunic"
	greyscale_colors = "#4e7cc7"
	greyscale_config = /datum/greyscale_config/eth_tunic
	greyscale_config_worn = /datum/greyscale_config/eth_tunic/worn
	flags_1 = IS_PLAYER_COLORABLE_1
	can_adjust = FALSE

/obj/item/clothing/under/ethereal_tunic/Initialize(mapload)
	. = ..()
	update_icon(UPDATE_OVERLAYS)

/obj/item/clothing/under/ethereal_tunic/worn_overlays(mutable_appearance/standing, isinhands, icon_file)
	. = ..()
	if(!isinhands)
		. += emissive_appearance('icons/mob/clothing/under/ethereal.dmi', "eth_tunic_emissive", offset_spokesman = src, alpha = src.alpha)

/obj/item/clothing/under/ethereal_tunic/update_overlays()
	. = ..()
	. += emissive_appearance('icons/obj/clothing/under/ethereal.dmi', "eth_tunic_emissive", offset_spokesman = src, alpha = src.alpha)

/obj/item/clothing/under/ethereal_tunic/trailwarden
	name = "防滑油布束腰衣"
	desc = "农民和朝圣者通常会发现在斯普劳特的泥土和生物发光植物群中跋涉中而沾上污渍，最终人们习惯于特意为衣服染色，以重现这种效果。"
	icon_state = "/obj/item/clothing/under/ethereal_tunic/trailwarden"
	greyscale_colors = "#32a87d"

/obj/item/clothing/under/ethereal_tunic/trailwarden/equipped(mob/living/user, slot)
	. = ..()
	if(isethereal(user) && (slot & ITEM_SLOT_ICLOTHING))
		var/mob/living/carbon/human/ethereal = user
		to_chat(ethereal, span_notice("[src] 在你穿上它时轻轻颤动了一下。"))
		set_greyscale(ethereal.dna.species.fixed_mut_color)
		ethereal.update_worn_undersuit()
