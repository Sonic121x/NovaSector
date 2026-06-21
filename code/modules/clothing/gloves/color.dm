/obj/item/clothing/gloves/color/black
	desc = "这双手套具有防火能力。"
	name = "黑手套"
	icon_state = "black"
	greyscale_colors = "#2f2e31"
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = NONE
	cut_type = /obj/item/clothing/gloves/fingerless

/obj/item/clothing/gloves/color/black/Initialize(mapload)
	. = ..()
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/radio_containing/radiogloves)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/clothing/gloves/color/black/security
	name = "安保手套"
	desc = "这些安保手套配有微芯片，能帮助使用者快速制服嫌疑人。"
	icon_state = "sec"
	clothing_traits = list(TRAIT_FAST_CUFFING)

/obj/item/clothing/gloves/color/black/security/blu
	icon_state = "sec_blu"

/obj/item/clothing/gloves/fingerless
	name = "无指手套"
	desc = "为辛勤工作者准备的普通黑色无指尖手套。"
	icon_state = "fingerless"
	greyscale_colors = "#2f2e31"
	strip_delay = 4 SECONDS
	equip_delay_other = 2 SECONDS
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	custom_price = PAYCHECK_CREW * 1.5
	undyeable = TRUE
	clothing_traits = list(TRAIT_FINGERPRINT_PASSTHROUGH)

/obj/item/clothing/gloves/fingerless/Initialize(mapload)
	. = ..()
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/gripperoffbrand)
	AddElement(/datum/element/adjust_fishing_difficulty, -4)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/clothing/gloves/color/orange
	name = "橙色手套"
	desc = "这只是一双手套而已，不管怎么看，都没什么特别之处。"
	icon_state = "orange"
	greyscale_colors = COLOR_CRAYON_ORANGE

/obj/item/clothing/gloves/color/red
	name = "红手套"
	desc = "这只是一双手套而已，不管怎么看，都没什么特别之处。"
	icon_state = "red"
	greyscale_colors = COLOR_CRAYON_RED

/obj/item/clothing/gloves/color/red/insulated
	name = "绝缘手套"
	desc = "这双手套具有绝缘效果。"
	siemens_coefficient = 0
	armor_type = /datum/armor/red_insulated
	resistance_flags = NONE

/datum/armor/red_insulated
	bio = 50

/obj/item/clothing/gloves/color/rainbow
	name = "彩虹手套"
	desc = "这只是一双手套而已，不管怎么看，都没什么特别之处。"
	icon_state = "rainbow"
	inhand_icon_state = "rainbow_gloves"
	greyscale_colors = null

/obj/item/clothing/gloves/color/blue
	name = "蓝色手套"
	desc = "这只是一双手套而已，不管怎么看，都没什么特别之处。"
	icon_state = "blue"
	greyscale_colors = COLOR_CRAYON_BLUE

/obj/item/clothing/gloves/color/purple
	name = "紫色手套"
	desc = "这只是一双手套而已，不管怎么看，都没什么特别之处。"
	icon_state = "purple"
	greyscale_colors = "#cc33ff"

/obj/item/clothing/gloves/color/green
	name = "绿色手套"
	desc = "这只是一双手套而已，不管怎么看，都没什么特别之处。"
	icon_state = "green"
	greyscale_colors = COLOR_CRAYON_GREEN

/obj/item/clothing/gloves/color/grey
	name = "灰色手套"
	desc = "这只是一双手套而已，不管怎么看，都没什么特别之处。"
	icon_state = "gray"
	greyscale_colors = "#999999"

// Grey gloves intended to be paired with winter coats (specifically EVA winter coats)
/obj/item/clothing/gloves/color/grey/protects_cold
	name = "\proper 恒温手套"
	desc = "一双厚实的灰色手套，可保护穿戴者不被冻伤。"
	w_class = WEIGHT_CLASS_NORMAL
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	resistance_flags = NONE
	clothing_flags = parent_type::clothing_flags | THICKMATERIAL

/obj/item/clothing/gloves/color/light_brown
	name = "浅棕色手套"
	desc = "这只是一双手套而已，不管怎么看，都没什么特别之处。"
	icon_state = "lightbrown"
	greyscale_colors = "#c09f72"

/obj/item/clothing/gloves/color/brown
	name = "棕色手套"
	desc = "这只是一双手套而已，不管怎么看，都没什么特别之处。"
	icon_state = "brown"
	greyscale_colors = "#83613d"

/obj/item/clothing/gloves/color/white
	name = "白色手套"
	desc = "看起来相当有档次。"
	icon_state = "white"
	greyscale_colors = COLOR_WHITE
	custom_price = PAYCHECK_CREW
