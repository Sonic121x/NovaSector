//Darude sandstorm starts playing
/datum/weather/sand_storm
	name = "严重沙尘暴"
	desc = "一场吞噬区域的严重沙尘暴，对无防护者造成剧烈伤害。"

	telegraph_message = span_danger("你看到地平线上升起一片沙尘云。这可不妙……")
	telegraph_duration = 30 SECONDS
	telegraph_overlay = "dust_med"
	telegraph_sound = 'sound/effects/siren.ogg'

	weather_message = span_userdanger("<i>灼热的沙子和狂风拍打着你！快进到室内！</i>")
	weather_duration_lower = 1 MINUTES
	weather_duration_upper = 2 MINUTES
	weather_overlay = "dust_high"

	end_message = span_bolddanger("呼啸的风卷走了最后的沙尘，恢复为平常的低语。现在应该可以安全外出了。")
	end_duration = 30 SECONDS
	end_overlay = "dust_med"

	area_type = /area
	target_trait = ZTRAIT_SANDSTORM
	immunity_type = TRAIT_SANDSTORM_IMMUNE
	probability = 90

	weather_flags = (WEATHER_MOBS | WEATHER_BAROMETER)

/datum/weather/sand_storm/get_playlist_ref()
	return GLOB.sand_storm_sounds

/datum/weather/sand_storm/telegraph()
	GLOB.sand_storm_sounds.Cut()
	for(var/area/impacted_area as anything in impacted_areas)
		GLOB.sand_storm_sounds[impacted_area] = /datum/looping_sound/weak_outside_ashstorm
	return ..()

/datum/weather/sand_storm/start()
	GLOB.sand_storm_sounds.Cut()
	for(var/area/impacted_area as anything in impacted_areas)
		GLOB.sand_storm_sounds[impacted_area] = /datum/looping_sound/active_outside_ashstorm
	return ..()

/datum/weather/sand_storm/wind_down()
	GLOB.sand_storm_sounds.Cut()
	for(var/area/impacted_area as anything in impacted_areas)
		GLOB.sand_storm_sounds[impacted_area] = /datum/looping_sound/weak_outside_ashstorm
	return ..()

/datum/weather/sand_storm/weather_act_mob(mob/living/victim)
	victim.adjust_brute_loss(5, required_bodytype = BODYTYPE_ORGANIC)
	return ..()

/datum/weather/sand_storm/harmless
	name = "沙落"
	desc = "一场经过的沙尘暴给该区域覆盖上了一层沙子。"

	telegraph_message = span_danger("风开始增强，从地面卷起沙子……")
	telegraph_overlay = "dust_low"
	telegraph_sound = null

	weather_message = span_notice("轻柔的沙子像怪异的雪花般在你周围飘落。风暴似乎已经过去了……")
	weather_overlay = "dust_med"

	end_message = span_notice("沙落减缓，停止。台地上你的脚下又多了一层沙子。")
	end_overlay = "dust_low"

	probability = 10
	weather_flags = parent_type::weather_flags & ~WEATHER_MOBS
