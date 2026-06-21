/obj/item/clothing/gloves/combat
	name = "战斗手套"
	desc = "这双战术手套具有防火和绝缘效果。"
	icon_state = "black"
	greyscale_colors = "#2f2e31"
	siemens_coefficient = 0
	strip_delay = 8 SECONDS
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = NONE
	armor_type = /datum/armor/gloves_combat
	clothing_traits = list(TRAIT_FAST_CUFFING)

/datum/armor/gloves_combat
	bio = 90
	fire = 80
	acid = 50

/obj/item/clothing/gloves/combat/wizard
	name = "附魔手套"
	desc = "这是一双附魔手套，因此，它具有了绝缘和防火的效果。"
	icon_state = "wizard"
	greyscale_colors = null
	inhand_icon_state = null

/obj/item/clothing/gloves/combat/wizard/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, -5) //something something wizard casting

/obj/item/clothing/gloves/combat/floortile
	name = "地砖迷彩手套"
	desc = "是我的错觉，还是地上真的有一副手套？"
	icon_state = "ftc_gloves"
	inhand_icon_state = "greyscale_gloves"

/obj/item/clothing/gloves/combat/floortile/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, -5) //tacticool
