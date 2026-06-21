/obj/item/clothing/suit/mothcoat
	name = "蛾人飞行服"
	desc = "This peculiar utility harness is a common sight among the moth fleet's crews due to its ability to fasten the wings to the body without impacting mobility inside cramped ship interiors. It looks somewhat crude yet it's surprisingly comfortable."
	icon = 'icons/map_icons/clothing/suit/_suit.dmi'
	icon_state = "/obj/item/clothing/suit/mothcoat"
	post_init_icon_state = "mothcoat"
	greyscale_config = /datum/greyscale_config/mothcoat
	greyscale_config_worn = /datum/greyscale_config/mothcoat/worn
	greyscale_colors = "#eaeaea"
	flags_1 = IS_PLAYER_COLORABLE_1
	flags_inv = HIDEMUTWINGS
	body_parts_covered = CHEST
	allowed = list(/obj/item/tank/internals/emergency_oxygen, /obj/item/flashlight/lantern) //lamp

/obj/item/clothing/suit/mothcoat/original
	desc = "一件来自飞蛾舰队的老式飞行服。既是飞蛾族生存主义和适应态度的完美象征，也是一个苦涩的提醒：随着家园星球的丧失和舰队的建立，他们珍爱的翅膀成为一种必须背负的负担，注定永不能再飞翔。"
	icon_state = "/obj/item/clothing/suit/mothcoat/original"
	greyscale_colors = "#dfa409"

/obj/item/clothing/suit/mothcoat/original/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, -5)
	create_storage(storage_type = /datum/storage/pockets)

/obj/item/clothing/suit/mothcoat/winter
	name = "飞蛾棉袄"
	desc = "一件保暖的厚衣服，保护珍贵的翅膀不受恶劣天气的影响，也常用于庆祝活动。摸起来比看上去重多了。"
	icon = 'icons/map_icons/clothing/suit/_suit.dmi'
	icon_state = "/obj/item/clothing/suit/mothcoat/winter"
	post_init_icon_state = "mothcoat_winter"
	greyscale_config = /datum/greyscale_config/mothcoat_winter
	greyscale_config_worn = /datum/greyscale_config/mothcoat_winter/worn
	greyscale_colors = "#557979#795e55"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	cold_protection = CHEST|GROIN|ARMS|LEGS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
