#define MODULAR_HANDS_ICON 'modular_nova/master_files/icons/obj/clothing/gloves.dmi'
#define MODULAR_HANDS_WORN_ICON 'modular_nova/master_files/icons/mob/clothing/hands.dmi'

/obj/item/clothing/gloves/color/ffyellow // EXTRA fake, for the loadout
	name = "黄色手套"
	desc = "乍一看这些可能像绝缘手套，但它们实际上只是普通布料。"
	icon_state = "yellow"
	inhand_icon_state = "ygloves"
	siemens_coefficient = 0.5

/obj/item/clothing/gloves/evening
	name = "晚宴手套"
	desc = "用于华贵服饰的薄而优雅的手套。这是一种毫不含蓄地表明你无需用手进行繁重工作的方式。"
	worn_icon = MODULAR_HANDS_WORN_ICON
	strip_delay = 4 SECONDS
	equip_delay_other = 2 SECONDS
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	icon = 'icons/map_icons/clothing/_clothing.dmi'
	icon_state = "/obj/item/clothing/gloves/evening"
	post_init_icon_state = "evening"
	greyscale_config = /datum/greyscale_config/evening_gloves
	greyscale_config_worn = /datum/greyscale_config/evening_gloves/worn
	greyscale_colors = "#FFFFFF"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/gloves/designer
	name = "设计师手套"
	desc = "一副花哨的及上臂设计师手套。适合那些过着奢侈生活，和/或有不良消费习惯的人。"
	worn_icon = MODULAR_HANDS_WORN_ICON
	strip_delay = 4 SECONDS
	equip_delay_other = 2 SECONDS
	icon = 'icons/map_icons/clothing/_clothing.dmi'
	icon_state = "/obj/item/clothing/gloves/designer"
	post_init_icon_state = "designer"
	greyscale_config = /datum/greyscale_config/designer_gloves
	greyscale_config_worn = /datum/greyscale_config/designer_gloves/worn
	greyscale_colors = "#2F2E31"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/gloves/military
	name = "军用战术手套"
	desc = "为军事人员制作的战术手套，它们很薄，便于操作大多数枪械。"
	icon_state = "military_gloves"
	icon = MODULAR_HANDS_ICON
	worn_icon = MODULAR_HANDS_WORN_ICON
	siemens_coefficient = 0.4
	strip_delay = 60
	equip_delay_other = 60
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = NONE

/obj/item/clothing/gloves/bracer/wraps
	name = "布质臂缠"
	desc = "布质护腕，颜色完全由佩戴者选择。"
	inhand_icon_state = "greyscale_gloves"
	icon = 'icons/map_icons/clothing/_clothing.dmi'
	icon_state = "/obj/item/clothing/gloves/bracer/wraps"
	post_init_icon_state = "arm_wraps"
	greyscale_config = /datum/greyscale_config/armwraps
	greyscale_config_worn = /datum/greyscale_config/armwraps/worn
	greyscale_colors = "#FFFFFF"
	flags_1 = IS_PLAYER_COLORABLE_1
	armor_type = /datum/armor/none

/obj/item/clothing/gloves
	worn_icon_teshari = TESHARI_HANDS_ICON

/obj/item/clothing/gloves/maid_arm_covers
	name = "女仆臂套"
	desc = "为你量身打造。"
	icon = 'icons/map_icons/clothing/_clothing.dmi'
	icon_state = "/obj/item/clothing/gloves/maid_arm_covers"
	post_init_icon_state = "maid_arm_covers"
	greyscale_config = /datum/greyscale_config/maid_arm_covers
	greyscale_config_worn = /datum/greyscale_config/maid_arm_covers/worn
	greyscale_config_inhand_left = null
	greyscale_config_inhand_right = null
	greyscale_colors = "#7b9ab5#edf9ff"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/gloves/pink_clown
	name = "粉色小丑手套"
	desc = "一副染成亮丽糖果粉色的手套，袖口处饰有彩虹般五彩斑斓的条纹。"
	icon = 'modular_nova/master_files/icons/obj/clothing/gloves.dmi'
	worn_icon =  'modular_nova/master_files/icons/mob/clothing/hands.dmi'
	icon_state = "pink_clown_gloves"

/obj/item/clothing/gloves/recolorable
	name = "gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon = 'icons/map_icons/clothing/_clothing.dmi'
	icon_state = "/obj/item/clothing/gloves/recolorable"
	post_init_icon_state = "gloves"
	greyscale_config = /datum/greyscale_config/recolorable_gloves
	greyscale_config_worn = /datum/greyscale_config/recolorable_gloves/worn
	greyscale_colors = "#252525"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/gloves/recolorable/fingerless
	name = "fingerless gloves"
	desc = "A pair of gloves. These ones are fingerless."
	icon_state = "/obj/item/clothing/gloves/recolorable/fingerless"
	post_init_icon_state = "gloves_fingerless"
	greyscale_config = /datum/greyscale_config/recolorable_gloves/fingerless
	greyscale_config_worn = /datum/greyscale_config/recolorable_gloves/fingerless/worn
	clothing_traits = list(TRAIT_FINGERPRINT_PASSTHROUGH)

/obj/item/clothing/gloves/recolorable/long
	name = "long gloves"
	desc = "A pair of gloves. These ones have extra long cuffs."
	icon_state = "/obj/item/clothing/gloves/recolorable/long"
	post_init_icon_state = "gloves_long"
	greyscale_config = /datum/greyscale_config/recolorable_gloves/long
	greyscale_config_worn = /datum/greyscale_config/recolorable_gloves/long/worn

/obj/item/clothing/gloves/recolorable/fingerless/long
	name = "long fingerless gloves"
	desc = "A pair of gloves. These ones are fingerless, and have extra long cuffs."
	icon_state = "/obj/item/clothing/gloves/recolorable/fingerless/long"
	post_init_icon_state = "gloves_fingerless_long"
	greyscale_config = /datum/greyscale_config/recolorable_gloves/fingerless_long
	greyscale_config_worn = /datum/greyscale_config/recolorable_gloves/fingerless_long/worn

#undef MODULAR_HANDS_ICON
#undef MODULAR_HANDS_WORN_ICON
