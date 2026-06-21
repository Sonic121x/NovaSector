///Map templates used for bluespace survival capsules.
/datum/map_template/shelter
	has_ceiling = TRUE
	ceiling_turf = /turf/open/floor/engine/hull
	ceiling_baseturfs = list(/turf/open/floor/plating)
	///The id of the shelter template in the relative list from the mapping subsystem
	var/shelter_id
	///The description of the shelter, shown when examining survival capsule.
	var/description
	///If turf in the affected turfs is in this list, the survival capsule cannot be deployed.
	var/list/blacklisted_turfs
	///Areas where the capsule cannot be deployed.
	var/list/banned_areas
	///If any object in this list is found in the affected turfs, the capsule cannot deploy.
	var/list/banned_objects = list()

/datum/map_template/shelter/New()
	. = ..()
	blacklisted_turfs = typecacheof(/turf/closed)
	banned_areas = typecacheof(list(/area/shuttle, /area/station/holodeck))

/datum/map_template/shelter/proc/check_deploy(turf/deploy_location, obj/item/survivalcapsule/capsule, ignore_flags = NONE)
	var/affected = get_affected_turfs(deploy_location, centered=TRUE)
	for(var/turf/turf in affected)
		var/area/area = get_area(turf)
		if(is_type_in_typecache(area, banned_areas))
			return SHELTER_DEPLOY_BAD_AREA

		if(is_type_in_typecache(turf, blacklisted_turfs))
			return SHELTER_DEPLOY_BAD_TURFS

		for(var/obj/object in turf)
			if(!(ignore_flags & CAPSULE_IGNORE_ANCHORED_OBJECTS) && object.density && object.anchored)
				return SHELTER_DEPLOY_ANCHORED_OBJECTS
			if(!(ignore_flags & CAPSULE_IGNORE_BANNED_OBJECTS) && is_type_in_typecache(object, banned_objects))
				return SHELTER_DEPLOY_BANNED_OBJECTS

	// Check if the shelter sticks out of map borders
	var/shelter_origin_x = deploy_location.x - round(width/2)
	if(shelter_origin_x <= 1 || shelter_origin_x+width > world.maxx)
		return SHELTER_DEPLOY_OUTSIDE_MAP
	var/shelter_origin_y = deploy_location.y - round(height/2)
	if(shelter_origin_y <= 1 || shelter_origin_y+height > world.maxy)
		return SHELTER_DEPLOY_OUTSIDE_MAP

	return SHELTER_DEPLOY_ALLOWED

/datum/map_template/shelter/alpha
	name = "避难所α"
	shelter_id = "shelter_alpha"
	description = "A cosy self-contained pressurized shelter, with \
		built-in navigation, entertainment, medical facilities and a \
		sleeping area! Order now, and we'll throw in a TINY FAN, \
		absolutely free!"
	mappath = "_maps/templates/shelter_1.dmm"

/datum/map_template/shelter/alpha/New()
	. = ..()
	blacklisted_turfs -= typesof(/turf/closed/mineral)
	banned_objects = typecacheof(/obj/structure/stone_tile)

/datum/map_template/shelter/beta
	name = "避难所β"
	shelter_id = "shelter_beta"
	description = "An extremely luxurious shelter, containing all \
		the amenities of home, including carpeted floors, hot and cold \
		running water, a gourmet three course meal, cooking facilities, \
		and a deluxe companion to keep you from getting lonely during \
		an ash storm."
	mappath = "_maps/templates/shelter_2.dmm"

/datum/map_template/shelter/beta/New()
	. = ..()
	blacklisted_turfs -= typesof(/turf/closed/mineral)
	banned_objects = typecacheof(/obj/structure/stone_tile)

/datum/map_template/shelter/charlie
	name = "避难所查理"
	shelter_id = "shelter_charlie"
	description = "A luxury elite bar which holds an entire bar \
		along with two vending machines, tables, and a restroom that \
		also has a sink. This isn't a survival capsule and so you can \
		expect that this won't save you if you're bleeding out to \
		death."
	mappath = "_maps/templates/shelter_3.dmm"

/datum/map_template/shelter/charlie/New()
	. = ..()
	blacklisted_turfs -= typesof(/turf/closed/mineral)
	banned_objects = typecacheof(/obj/structure/stone_tile)

/datum/map_template/shelter/toilet
	name = "紧急救援庇护所"
	shelter_id = "shelter_toilet"
	description = "A stripped-down emergency shelter focused on providing \
		only the most essential amenities to unfortunate employees who find \
		themselves in need far from home."
	mappath = "_maps/templates/shelter_t.dmm"

/datum/map_template/shelter/toilet/New()
	. = ..()
	blacklisted_turfs -= typesof(/turf/closed/mineral)
	banned_objects = typecacheof(/obj/structure/stone_tile)

///Not exactly mining shelters, but they make use of survival capsules code.
/datum/map_template/shelter/fishing
	name = "淡水泉"
	shelter_id = "fishing_default"
	description = "一个可以钓到几种淡水鱼的泉眼，包括金鱼、鲶鱼和梭子鱼。"
	mappath = "_maps/templates/fishing_freshwater.dmm"
	has_ceiling = FALSE
	///The icon shown in the radial menu
	var/radial_icon = "river"
	/**
	 * If FALSE, the capsule needs to be emagged for this template to be selectable.
	 * its usage will also be logged, and admins warned if used indoors.
	 */
	var/safe = TRUE

/datum/map_template/shelter/fishing/New()
	. = ..()
	blacklisted_turfs -= typesof(/turf/closed/mineral)
	blacklisted_turfs += typecacheof(/turf/open/openspace)
	// Stop the capsule from being used around pipes and cables (if not emagged) cuz it'd look bad and a bit disruptive.
	banned_objects = typecacheof(list(
		/obj/structure/disposalpipe,
		/obj/machinery/atmospherics/pipe,
		/obj/structure/cable,
		/obj/structure/transit_tube,
	))

/datum/map_template/shelter/fishing/beach
	name = "咸水泉"
	shelter_id = "fishing_beach"
	mappath = "_maps/templates/fishing_saltwater.dmm"
	description = "一个可以钓到几种咸水鱼的泉眼，包括小丑鱼、河豚和刺鳐。"
	radial_icon = "seaboat"

/datum/map_template/shelter/fishing/tizira
	name = "提兹兰泉"
	shelter_id = "fishing_tizira"
	mappath = "_maps/templates/fishing_tizira.dmm"
	description = "一个可以钓到几种原产于蜥蜴人母星提兹拉的鱼的泉眼。"
	radial_icon = "planet"

/datum/map_template/shelter/fishing/hot_spring
	name = "温泉"
	shelter_id = "fishing_hot_spring"
	mappath = "_maps/templates/fishing_hot_spring.dmm"
	description = "一个温泉。作为钓鱼点的功能有限，但至少你可以享受一个放松的沐浴。"
	radial_icon = "onsen"

/datum/map_template/shelter/fishing/ice
	name = "冰钓点"
	shelter_id = "fishing_ice"
	mappath = "_maps/templates/fishing_ice.dmm"
	description = "一个被雪包围的、已经挖好的小冰洞。你可以在这里钓到鲑鱼和北极红点鲑。"
	radial_icon = "ice"

/datum/map_template/shelter/fishing/lava
	name = "熔岩钓点"
	shelter_id = "fishing_lava"
	mappath = "_maps/templates/fishing_lava.dmm"
	description = "一小片2x2的不适合生物存活的熔岩水坑。你可以在这里钓到熔岩环，也许还能找到一个宝箱。"
	radial_icon = "lava"
	safe = FALSE

/datum/map_template/shelter/fishing/plasma
	name = "等离子钓点"
	shelter_id = "fishing_plasma"
	mappath = "_maps/templates/fishing_plasma.dmm"
	description = "一小片2x2的不适合生物生存的等离子体水洼。你可以在这里钓到熔岩环鱼和北极蟹。"
	radial_icon = "plasma"
	safe = FALSE

/datum/map_template/shelter/fishing/depths
	name = "深海钓点"
	shelter_id = "fishing_depths"
	mappath = "_maps/templates/fishing_depths.dmm"
	description = "一个3x3的深水池，水深到足以让人涉水而过时感到疲惫。你可以在这里钓到海洋鱼类。"
	radial_icon = "depths"
	safe = FALSE
