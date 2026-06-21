/**********************Mine areas**************************/
/area/mine
	icon = 'icons/area/areas_station.dmi'
	icon_state = "mining"
	default_gravity = STANDARD_GRAVITY
	area_flags = VALID_TERRITORY | CULT_PERMITTED
	area_flags_mapping = UNIQUE_AREA | FLORA_ALLOWED
	ambient_buzz = 'sound/ambience/lavaland/magma.ogg'

/area/mine/lobby
	name = "采矿站"
	icon_state = "mining_lobby"

/area/mine/storage
	name = "采矿站生产存储区"
	icon_state = "mining_storage"

/area/mine/storage/public
	name = "采矿站公共存储区"
	icon_state = "mining_storage"

/area/mine/lobby/raptor
	name = "纳米特拉森迅猛龙农场"
	icon_state = "mining_storage"

/area/mine/production
	name = "采矿站生产区"
	icon_state = "mining_production"

/area/mine/abandoned
	name = "废弃采矿站"

/area/mine/living_quarters
	name = "采矿站生活区"
	icon_state = "mining_living"

/area/mine/eva
	name = "采矿站舱外活动区"
	icon_state = "mining_eva"

/area/mine/eva/lower
	name = "采矿站下层舱外活动区"
	icon_state = "mining_eva"

/area/mine/maintenance
	name = "采矿站维护区"

/area/mine/maintenance/production
	name = "采矿站生产维护区"

/area/mine/maintenance/living
	name = "采矿站生活区维护区"

/area/mine/maintenance/living/north
	name = "采矿站生活区北部维护区"

/area/mine/maintenance/living/south
	name = "采矿站生活区南部维护区"

/area/mine/maintenance/public
	name = "采矿站公共维护区"

/area/mine/maintenance/public/north
	name = "采矿站公共北部维护区"

/area/mine/maintenance/public/south
	name = "采矿站公共南部维护区"

/area/mine/maintenance/service
	name = "采矿站服务维护区"

/area/mine/maintenance/service/disposals
	name = "采矿站废弃物处理区"

/area/mine/maintenance/service/comms
	name = "采矿站通信区"

/area/mine/maintenance/labor
	name = "劳改营维护区"

/area/mine/cafeteria
	name = "采矿站食堂"
	icon_state = "mining_cafe"

/area/mine/cafeteria/labor
	name = "劳改营食堂"
	icon_state = "mining_labor_cafe"

/area/mine/hydroponics
	name = "采矿站水培区"
	icon_state = "mining_hydro"

/area/mine/medical
	name = "采矿站紧急医疗舱"

/area/mine/mechbay
	name = "采矿站机甲舱"
	icon_state = "mechbay"

/area/mine/lounge
	name = "采矿站公共休息室"
	icon_state = "mining_lounge"

/area/mine/laborcamp
	name = "劳改营"
	icon_state = "mining_labor"

/area/mine/laborcamp/quarters
	name = "劳改营宿舍"
	icon_state = "mining_labor_quarters"

/area/mine/laborcamp/production
	name = "劳改营生产区"
	icon_state = "mining_labor_production"

/area/mine/laborcamp/security
	name = "劳改营安保区"
	icon_state = "labor_camp_security"
	ambience_index = AMBIENCE_DANGER

/area/mine/laborcamp/security/maintenance
	name = "劳改营安保维护区"
	icon_state = "labor_camp_security"
	ambience_index = AMBIENCE_DANGER




/**********************Lavaland Areas**************************/

/area/lavaland
	icon = 'icons/area/areas_station.dmi'
	icon_state = "mining"
	default_gravity = STANDARD_GRAVITY
	flags_1 = NONE
	area_flags = VALID_TERRITORY | FLORA_ALLOWED
	sound_environment = SOUND_AREA_LAVALAND
	ambient_buzz = 'sound/ambience/lavaland/magma.ogg'
	allow_shuttle_docking = TRUE
	map_generator = /datum/map_generator/cave_generator/lavaland
	use_mapgen = FALSE

/area/lavaland/surface
	name = "熔岩地"
	icon_state = "explored"
	always_unpowered = TRUE
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	requires_power = TRUE
	ambience_index = AMBIENCE_MINING
	area_flags = VALID_TERRITORY

/area/lavaland/underground
	name = "熔岩地洞穴"
	icon_state = "unexplored"
	always_unpowered = TRUE
	requires_power = TRUE
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	ambience_index = AMBIENCE_MINING

/area/lavaland/surface/outdoors
	name = "熔岩地荒原"
	outdoors = TRUE

/area/lavaland/surface/outdoors/unexplored //monsters and ruins spawn here
	icon_state = "unexplored"
	area_flags = VALID_TERRITORY
	area_flags_mapping = UNIQUE_AREA | CAVES_ALLOWED | FLORA_ALLOWED | MOB_SPAWN_ALLOWED
	use_mapgen = TRUE

/area/lavaland/surface/outdoors/unexplored/danger //megafauna will also spawn here
	icon_state = "danger"
	area_flags = VALID_TERRITORY
	area_flags_mapping = parent_type::area_flags_mapping | MEGAFAUNA_SPAWN_ALLOWED

/// Same thing as parent, but uses a different map generator for the icemoon ruin that needs it.
/area/lavaland/surface/outdoors/unexplored/danger/no_ruins
	map_generator = /datum/map_generator/cave_generator/lavaland/ruin_version

/area/lavaland/surface/outdoors/explored
	name = "熔岩地劳改营"
	area_flags = VALID_TERRITORY

/**********************Ice Moon Areas**************************/

/area/icemoon
	icon = 'icons/area/areas_station.dmi'
	icon_state = "mining"
	default_gravity = STANDARD_GRAVITY
	flags_1 = NONE
	area_flags_mapping = UNIQUE_AREA | FLORA_ALLOWED
	ambience_index = AMBIENCE_ICEMOON
	sound_environment = SOUND_AREA_ICEMOON
	ambient_buzz = 'sound/ambience/lavaland/magma.ogg'
	allow_shuttle_docking = TRUE
	skip_minimap_rendering = TRUE

/area/icemoon/surface
	name = "冰月"
	icon_state = "explored"
	always_unpowered = TRUE
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	requires_power = TRUE

/area/icemoon/surface/outdoors // parent that defines if something is on the exterior of the station.
	name = "冰月荒原"
	outdoors = TRUE

/area/icemoon/surface/outdoors/Initialize(mapload)
	if(HAS_TRAIT(SSstation, STATION_TRAIT_BRIGHT_DAY))
		base_lighting_alpha = 145
	return ..()

/// this is the area you use for stuff to not spawn, but if you still want weather.
/area/icemoon/surface/outdoors/nospawn

/area/icemoon/surface/outdoors/less_spawns
	icon_state = "less_spawns"

/area/icemoon/surface/outdoors/less_spawns/New()
	. = ..()
	// this area SOMETIMES does map generation. Often it doesn't at all
	// so it SHOULD NOT be used with the genturf turf type, as it is not always replaced
	if(HAS_TRAIT(SSstation, STATION_TRAIT_FORESTED))
		map_generator = /datum/map_generator/cave_generator/icemoon/surface/forested
		// flip this on, the generator has already disabled dangerous fauna
		area_flags_mapping = MOB_SPAWN_ALLOWED | FLORA_ALLOWED

/area/icemoon/surface/outdoors/always_forested
	icon_state = "forest"
	map_generator = /datum/map_generator/cave_generator/icemoon/surface/forested
	area_flags_mapping = MOB_SPAWN_ALLOWED | FLORA_ALLOWED | CAVES_ALLOWED

/area/icemoon/surface/outdoors/rocky
	icon_state = "rocky"
	map_generator = /datum/map_generator/cave_generator/icemoon/surface/rocky
	area_flags_mapping = MOB_SPAWN_ALLOWED | FLORA_ALLOWED | CAVES_ALLOWED

/area/icemoon/surface/outdoors/noteleport // for places like the cursed spring water
	area_flags_mapping = parent_type::area_flags_mapping | NOTELEPORT

/area/icemoon/surface/outdoors/noruins // when you want random generation without the chance of getting ruins
	icon_state = "noruins"
	area_flags_mapping = parent_type::area_flags_mapping | MOB_SPAWN_ALLOWED | CAVES_ALLOWED
	map_generator = /datum/map_generator/cave_generator/icemoon/surface/noruins

/area/icemoon/surface/outdoors/labor_camp
	name = "冰月劳改营"
	area_flags_mapping = /area::area_flags_mapping

/area/icemoon/surface/outdoors/unexplored //monsters and ruins spawn here
	icon_state = "unexplored"
	area_flags_mapping = parent_type::area_flags_mapping | MOB_SPAWN_ALLOWED | CAVES_ALLOWED

/area/icemoon/surface/outdoors/unexplored/rivers // rivers spawn here
	icon_state = "danger"
	map_generator = /datum/map_generator/cave_generator/icemoon/surface

/area/icemoon/surface/outdoors/unexplored/rivers/New()
	. = ..()
	if(HAS_TRAIT(SSstation, STATION_TRAIT_FORESTED))
		map_generator = /datum/map_generator/cave_generator/icemoon/surface/forested
		area_flags_mapping |= MOB_SPAWN_ALLOWED //flip this on, the generator has already disabled dangerous fauna

/area/icemoon/surface/outdoors/unexplored/rivers/no_monsters
	area_flags_mapping = /area/icemoon/::area_flags_mapping | CAVES_ALLOWED

/area/icemoon/underground
	name = "冰月洞穴"
	outdoors = TRUE
	always_unpowered = TRUE
	requires_power = TRUE
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE

/area/icemoon/underground/unexplored // mobs and megafauna and ruins spawn here
	name = "冰月洞穴"
	icon_state = "unexplored"
	area_flags_mapping = CAVES_ALLOWED | FLORA_ALLOWED | MOB_SPAWN_ALLOWED | MEGAFAUNA_SPAWN_ALLOWED

/area/icemoon/underground/unexplored/no_rivers
	icon_state = "norivers"
	area_flags_mapping = CAVES_ALLOWED | FLORA_ALLOWED // same rules as "shoreline" turfs since we might need this to pull double-duty
	map_generator = /datum/map_generator/cave_generator/icemoon

/area/icemoon/underground/unexplored/rivers // rivers spawn here
	icon_state = "danger"
	map_generator = /datum/map_generator/cave_generator/icemoon

/area/icemoon/underground/unexplored/rivers/deep
	map_generator = /datum/map_generator/cave_generator/icemoon/deep

/area/icemoon/underground/unexplored/rivers/deep/shoreline //use this for when you don't want mobs to spawn in certain areas in the "deep" portions. Think adjacent to rivers or station structures.
	icon_state = "shore"
	area_flags_mapping = /area/icemoon/::area_flags_mapping | CAVES_ALLOWED

/area/icemoon/underground/explored // ruins can't spawn here
	name = "冰月地下"
	area_flags_mapping = /area::area_flags_mapping

/area/icemoon/underground/explored/graveyard
	name = "墓地"
	area_flags_mapping = /area::area_flags_mapping
	ambience_index = AMBIENCE_SPOOKY
	icon = 'icons/area/areas_station.dmi'
	icon_state = "graveyard"

/area/icemoon/underground/explored/graveyard/chapel
	name = "教堂墓地"
