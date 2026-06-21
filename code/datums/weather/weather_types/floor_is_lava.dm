//Causes fire damage to anyone not standing on a dense object.
/datum/weather/floor_is_lava
	name = "地板是熔岩"
	desc = "地面变成了出奇凉爽的熔岩，对地板上的任何东西造成轻微伤害。"

	telegraph_message = span_warning("你感觉脚下的地面正在变热。热浪使空气扭曲。")
	telegraph_duration = 15 SECONDS

	weather_message = span_userdanger("地板是熔岩！快站到什么东西上面去！")
	weather_duration_lower = 30 SECONDS
	weather_duration_upper = 1 MINUTES
	weather_overlay = "lava"

	end_message = span_danger("地面冷却并恢复了原状。")
	end_duration = 0 SECONDS

	area_type = /area
	protected_areas = list(/area/space)
	target_trait = ZTRAIT_STATION

	overlay_layer = ABOVE_OPEN_TURF_LAYER //Covers floors only
	overlay_planes = list(FLOOR_PLANE)
	immunity_type = TRAIT_LAVA_IMMUNE
	/// We don't draw on walls, so this ends up lookin weird
	/// Can't really use like, the emissive system here because I am not about to make
	/// all walls block emissive
	use_glow = FALSE
	weather_flags = (WEATHER_MOBS | WEATHER_INDOORS)


/datum/weather/floor_is_lava/can_weather_act_mob(mob/living/mob_to_check)
	if(!mob_to_check.client) //Only sentient people are going along with it!
		return FALSE
	. = ..()
	if(!. || issilicon(mob_to_check) || istype(mob_to_check.buckled, /obj/structure/bed))
		return FALSE
	var/turf/mob_turf = get_turf(mob_to_check)
	if(mob_turf.density) //Walls are not floors.
		return FALSE
	for(var/obj/structure/structure_to_check in mob_turf)
		if(structure_to_check.density)
			return FALSE
	if(mob_to_check.movement_type & MOVETYPES_NOT_TOUCHING_GROUND)
		return FALSE

/datum/weather/floor_is_lava/weather_act_mob(mob/living/victim)
	victim.adjust_fire_loss(3)
	return ..()
