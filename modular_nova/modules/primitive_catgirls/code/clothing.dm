// The naming of every path in this file is going to be awful :smiling_imp:

// Outfit Datum

/datum/outfit/primitive_catgirl
	name = "冰月住民"

	uniform = /obj/item/clothing/under/dress/skirt/primitive_catgirl_body_wraps
	shoes = /obj/item/clothing/shoes/winterboots/ice_boots/primitive_catgirl_boots
	gloves = /obj/item/clothing/gloves/fingerless/primitive_catgirl_armwraps
	suit = /obj/item/clothing/suit/jacket/primitive_catgirl_coat
	neck = /obj/item/clothing/neck/scarf/primitive_catgirl_scarf

	back = /obj/item/forging/reagent_weapon/axe/fake_copper

// Under

/obj/item/clothing/under/dress/skirt/primitive_catgirl_body_wraps
	name = "缠身布"
	desc = "一些相当简单的缠布，用来遮盖你的下半身。"
	worn_icon = 'modular_nova/modules/primitive_catgirls/icons/clothing_greyscale.dmi'
	body_parts_covered = GROIN
	icon = 'icons/map_icons/clothing/under/_under.dmi'
	icon_state = "/obj/item/clothing/under/dress/skirt/primitive_catgirl_body_wraps"
	post_init_icon_state = "wraps"
	greyscale_config = /datum/greyscale_config/primitive_catgirl_wraps
	greyscale_config_worn = /datum/greyscale_config/primitive_catgirl_wraps/worn
	greyscale_colors = "#cec8bf#364660"
	flags_1 = IS_PLAYER_COLORABLE_1
	has_sensor = FALSE

/obj/item/clothing/under/dress/skirt/primitive_catgirl_tailored_dress
	name = "定制连衣裙"
	desc = "一件手工制作的连衣裙，根据穿着者的身体尺寸完美剪裁。"
	worn_icon = 'modular_nova/modules/primitive_catgirls/icons/clothing_greyscale.dmi'
	body_parts_covered = GROIN|CHEST
	icon = 'icons/map_icons/clothing/under/_under.dmi'
	icon_state = "/obj/item/clothing/under/dress/skirt/primitive_catgirl_tailored_dress"
	post_init_icon_state = "tailored_dress"
	greyscale_config = /datum/greyscale_config/primitive_catgirl_tailored_dress
	greyscale_config_worn = /datum/greyscale_config/primitive_catgirl_tailored_dress/worn
	greyscale_colors = "#cec8bf#364660"
	flags_1 = IS_PLAYER_COLORABLE_1
	has_sensor = FALSE

/obj/item/clothing/under/dress/skirt/primitive_catgirl_tunic
	name = "手工束腰外衣"
	desc = "一种简单的服装，从肩部延伸到膝盖上方。这件配有腰带固定。"
	worn_icon = 'modular_nova/modules/primitive_catgirls/icons/clothing_greyscale.dmi'
	body_parts_covered = GROIN|CHEST
	icon = 'icons/map_icons/clothing/under/_under.dmi'
	icon_state = "/obj/item/clothing/under/dress/skirt/primitive_catgirl_tunic"
	post_init_icon_state = "tunic"
	greyscale_config = /datum/greyscale_config/primitive_catgirl_tunic
	greyscale_config_worn = /datum/greyscale_config/primitive_catgirl_tunic/worn
	greyscale_colors = "#cec8bf#faece4#594032"
	flags_1 = IS_PLAYER_COLORABLE_1
	has_sensor = FALSE

// Hands

/obj/item/clothing/gloves/fingerless/primitive_catgirl_armwraps
	name = "臂缠"
	desc = "缠绕手臂的简单布料。"
	worn_icon = 'modular_nova/modules/primitive_catgirls/icons/clothing_greyscale.dmi'
	icon = 'icons/map_icons/clothing/_clothing.dmi'
	icon_state = "/obj/item/clothing/gloves/fingerless/primitive_catgirl_armwraps"
	post_init_icon_state = "armwraps"
	greyscale_config = /datum/greyscale_config/primitive_catgirl_armwraps
	greyscale_config_worn = /datum/greyscale_config/primitive_catgirl_armwraps/worn
	greyscale_colors = "#cec8bf"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/gloves/fingerless/primitive_catgirl_gauntlets
	name = "臂铠"
	desc = "带有覆盖金属保护的简单布质臂缠。"
	worn_icon = 'modular_nova/modules/primitive_catgirls/icons/clothing_greyscale.dmi'
	icon = 'icons/map_icons/clothing/_clothing.dmi'
	icon_state = "/obj/item/clothing/gloves/fingerless/primitive_catgirl_gauntlets"
	post_init_icon_state = "gauntlets"
	greyscale_config = /datum/greyscale_config/primitive_catgirl_gauntlets
	greyscale_config_worn = /datum/greyscale_config/primitive_catgirl_gauntlets/worn
	greyscale_config_inhand_left = null
	greyscale_config_inhand_right = null
	greyscale_colors = "#cec8bf#c55a1d"
	flags_1 = IS_PLAYER_COLORABLE_1

// Suit

/obj/item/clothing/suit/jacket/primitive_catgirl_coat
	name = "原始毛皮大衣"
	desc = "一大块动物毛皮，内部填充了毛皮，很可能来自同一只动物。"
	worn_icon = 'modular_nova/modules/primitive_catgirls/icons/clothing_greyscale.dmi'
	body_parts_covered = CHEST
	cold_protection = CHEST
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	icon = 'icons/map_icons/clothing/suit/_suit.dmi'
	icon_state = "/obj/item/clothing/suit/jacket/primitive_catgirl_coat"
	post_init_icon_state = "coat"
	greyscale_config = /datum/greyscale_config/primitive_catgirl_coat
	greyscale_config_worn = /datum/greyscale_config/primitive_catgirl_coat/worn
	greyscale_colors = "#594032#cec8bf"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/suit/apron/chef/colorable_apron/primitive_catgirl_leather
	icon_state = "/obj/item/clothing/suit/apron/chef/colorable_apron/primitive_catgirl_leather"
	greyscale_colors = "#594032"

// Shoes

/obj/item/clothing/shoes/winterboots/ice_boots/primitive_catgirl_boots
	name = "原始徒步靴"
	desc = "一双厚重的靴子，内衬毛皮，鞋底经过特殊设计，可防止在冰面上打滑。"
	worn_icon = 'modular_nova/modules/primitive_catgirls/icons/clothing_greyscale.dmi'
	icon = 'icons/map_icons/clothing/shoes.dmi'
	icon_state = "/obj/item/clothing/shoes/winterboots/ice_boots/primitive_catgirl_boots"
	post_init_icon_state = "boots"
	greyscale_config = /datum/greyscale_config/primitive_catgirl_boots
	greyscale_config_worn = /datum/greyscale_config/primitive_catgirl_boots/worn
	greyscale_colors = "#594032#cec8bf"
	flags_1 = IS_PLAYER_COLORABLE_1

// Neck

/obj/item/clothing/neck/scarf/primitive_catgirl_scarf
	icon_state = "/obj/item/clothing/neck/scarf/primitive_catgirl_scarf"
	greyscale_colors = "#cec8bf#cec8bf"

/obj/item/clothing/neck/large_scarf/primitive_catgirl_off_white
	icon_state = "/obj/item/clothing/neck/large_scarf/primitive_catgirl_off_white"
	greyscale_colors = "#cec8bf#cec8bf"

/obj/item/clothing/neck/infinity_scarf/primitive_catgirl_blue
	icon_state = "/obj/item/clothing/neck/infinity_scarf/primitive_catgirl_blue"
	greyscale_colors = "#364660"

/obj/item/clothing/neck/mantle/recolorable/primitive_catgirl_off_white
	icon_state = "/obj/item/clothing/neck/mantle/recolorable/primitive_catgirl_off_white"
	greyscale_colors = "#cec8bf"

/obj/item/clothing/neck/ranger_poncho/primitive_catgirl_leather
	icon_state = "/obj/item/clothing/neck/ranger_poncho/primitive_catgirl_leather"
	greyscale_colors = "#594032#594032"

// Masks

/obj/item/clothing/mask/neck_gaiter/primitive_catgirl_gaiter
	icon_state = "/obj/item/clothing/mask/neck_gaiter/primitive_catgirl_gaiter"
	greyscale_colors = "#364660"

// Head

/obj/item/clothing/head/standalone_hood/primitive_catgirl_colors
	icon_state = "/obj/item/clothing/head/standalone_hood/primitive_catgirl_colors"
	greyscale_colors = "#594032#364660"

/obj/item/clothing/head/primitive_catgirl_ferroniere
	name = "额饰"
	desc = "一种环绕佩戴者前额的头带，中央悬挂着一颗小宝石。"
	worn_icon = 'modular_nova/modules/primitive_catgirls/icons/clothing_greyscale.dmi'
	icon = 'icons/map_icons/clothing/head/_head.dmi'
	icon_state = "/obj/item/clothing/head/primitive_catgirl_ferroniere"
	post_init_icon_state = "ferroniere"
	greyscale_config = /datum/greyscale_config/primitive_catgirl_ferroniere
	greyscale_config_worn = /datum/greyscale_config/primitive_catgirl_ferroniere/worn
	greyscale_colors = "#f1f6ff#364660"
	w_class = WEIGHT_CLASS_TINY
	flags_1 = IS_PLAYER_COLORABLE_1

// Misc Items

/obj/item/forging/reagent_weapon/axe/fake_copper
	custom_materials = list(/datum/material/copporcitite = SHEET_MATERIAL_AMOUNT)
