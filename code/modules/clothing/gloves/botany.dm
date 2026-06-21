/obj/item/clothing/gloves/botanic_leather
	name = "植物学家的皮手套"
	desc = "这副皮手套可以抵挡茎刺、倒刺、尖刺和其他有害的植物部位.它们穿起来也很暖和."
	icon_state = "leather"
	inhand_icon_state = null
	greyscale_colors = null
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = NONE
	clothing_traits = list(TRAIT_PLANT_SAFE)
	armor_type = /datum/armor/gloves_botanic_leather

/obj/item/clothing/gloves/botanic_leather/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, -4)

/datum/armor/gloves_botanic_leather
	bio = 50
	fire = 70
	acid = 30
