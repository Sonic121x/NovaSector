/obj/item/clothing/gloves/butchering
	name = "屠宰手套"
	desc = "这些手套使用户可以精确而轻松地撕裂身体。"
	icon_state = "black"
	greyscale_colors = "#2f2e31"
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT

/obj/item/clothing/gloves/butchering/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/butchering/wearable, \
	speed = 0.5 SECONDS, \
	effectiveness = 125, \
	bonus_modifier = 0, \
	butcher_sound = null, \
	disabled = TRUE, \
	can_be_blunt = TRUE, \
	)
