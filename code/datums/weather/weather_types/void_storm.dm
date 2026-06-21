/datum/weather/void_storm
	name = "虚空风暴"
	desc = "一种罕见且高度异常的事件，常伴有未知实体撕裂时空连续体。我们建议你开始逃跑。"

	telegraph_duration = 2 SECONDS
	telegraph_overlay = "light_snow"

	weather_message = span_hypnophrase("你感到周围的空气越来越冷……以及虚空的甜美拥抱……")
	weather_overlay = "light_snow"
	weather_color = COLOR_BLACK
	weather_duration_lower = 1 MINUTES
	weather_duration_upper = 2 MINUTES

	use_glow = FALSE

	end_duration = 10 SECONDS

	area_type = /area
	target_trait = ZTRAIT_VOIDSTORM

	weather_flags = (WEATHER_INDOORS | WEATHER_BAROMETER | WEATHER_ENDLESS)
