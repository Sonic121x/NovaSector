/obj/item/clothing/under/pants
	gender = PLURAL
	body_parts_covered = GROIN|LEGS
	female_sprite_flags = NO_FEMALE_UNIFORM
	can_adjust = TRUE
	custom_price = PAYCHECK_CREW
	icon = 'icons/obj/clothing/under/shorts_pants_shirts.dmi'
	worn_icon = 'icons/mob/clothing/under/shorts_pants_shirts.dmi'
	abstract_type = /obj/item/clothing/under/pants
	species_exception = list(/datum/species/golem)

/obj/item/clothing/under/pants/slacks
	name = "松身裤"
	desc = "一条舒适的松身裤。"
	icon = 'icons/map_icons/clothing/under/_under.dmi'
	icon_state = "/obj/item/clothing/under/pants/slacks"
	post_init_icon_state = "slacks"
	greyscale_config = /datum/greyscale_config/slacks
	greyscale_config_worn = /datum/greyscale_config/slacks/worn
	greyscale_colors = "#575757#3E3E3E#75634F"
	flags_1 = IS_PLAYER_COLORABLE_1
	clothing_flags = parent_type::clothing_flags | CARP_STYLE_FACTOR

/obj/item/clothing/under/pants/jeans
	name = "牛仔裤"
	desc = "一条普通的结实牛仔裤。"
	icon = 'icons/map_icons/clothing/under/_under.dmi'
	icon_state = "/obj/item/clothing/under/pants/jeans"
	post_init_icon_state = "jeans"
	greyscale_config = /datum/greyscale_config/jeans
	greyscale_config_worn = /datum/greyscale_config/jeans/worn
	greyscale_colors = "#787878#723E0E#4D7EAC"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/under/pants/track
	name = "田径裤"
	desc = "一条运动裤，专为运动爱好者设计。"
	icon_state = "trackpants"

/obj/item/clothing/under/pants/camo
	name = "迷彩裤"
	desc = "一条林地迷彩裤。对空间站来说可能不是最佳选择。"
	icon_state = "camopants"
