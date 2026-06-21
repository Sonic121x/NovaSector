// Lavaland Ruins
// NOTICE: /unpowered means you never get power. Thanks Fikou!

// ASH WALKER MACHINES FIX
/area/ruin/unpowered/ash_walkers
	always_unpowered = FALSE
	power_equip = TRUE

// Interdyne planetary base

/area/ruin/interdyne_planetary_base // used as parent type and for turret control
	name = "英特戴恩制药旋臂星区基地"
	icon = 'icons/area/areas_centcom.dmi'
	icon_state = "syndie-control"
	ambience_index = AMBIENCE_DANGER
	ambient_buzz = 'sound/ambience/lavaland/magma.ogg'
	area_flags = BLOBS_ALLOWED

/area/ruin/interdyne_planetary_base/cargo
	name = "英特戴恩货运舱"
	icon = 'icons/area/areas_station.dmi'
	icon_state = "mining"

/area/ruin/interdyne_planetary_base/cargo/deck
	name = "英特戴恩甲板军官办公室"
	icon_state = "qm_office"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/ruin/interdyne_planetary_base/cargo/ware
	name = "英特戴恩仓库"
	icon_state = "cargo_warehouse"

/area/ruin/interdyne_planetary_base/cargo/obs
	name = "英特戴恩观测中心"
	icon = 'icons/area/areas_centcom.dmi'
	icon_state = "observatory"
	ambience_index = AMBIENCE_DANGER

/area/ruin/interdyne_planetary_base/cargo/obs/Initialize(mapload)
	if(!ambientsounds)
		var/list/temp_ambientsounds = GLOB.ambience_assoc[ambience_index]
		ambientsounds = temp_ambientsounds.Copy()
		ambientsounds += list(
			'modular_nova/modules/random_ship_event/random_ships/heliostatic_inspectors/sounds/morse.ogg',
			'sound/ambience/engineering/ambitech.ogg',
			'sound/ambience/misc/signal.ogg',
			'modular_nova/modules/random_ship_event/random_ships/heliostatic_inspectors/sounds/morse.ogg',
		)
	return ..()

/area/ruin/interdyne_planetary_base/main
	name = "英特戴恩主厅"
	icon = 'icons/area/areas_station.dmi'
	icon_state = "hall"

/area/ruin/interdyne_planetary_base/main/vault
	name = "英特戴恩金库"
	icon = 'icons/area/areas_centcom.dmi'
	icon_state = "syndie-control"

/area/ruin/interdyne_planetary_base/main/dorms
	name = "英特戴恩宿舍区"
	icon_state = "crew_quarters"

/area/ruin/interdyne_planetary_base/main/dorms/lib
	name = "英特戴恩图书馆"
	icon_state = "library"
	mood_bonus = 5
	mood_message = "I love being in the base's library!"
	mood_trait = TRAIT_INTROVERT
	sound_environment = SOUND_AREA_WOODFLOOR

/area/ruin/interdyne_planetary_base/med
	name = "英特戴恩医疗翼"
	icon = 'icons/area/areas_station.dmi'
	icon_state = "medbay"
	ambience_index = AMBIENCE_MEDICAL

/area/ruin/interdyne_planetary_base/med/pharm
	name = "英特戴恩药房"
	icon_state = "pharmacy"

/area/ruin/interdyne_planetary_base/med/viro
	name = "英特戴恩病毒学实验室"
	icon_state = "virology"
	ambience_index = AMBIENCE_VIROLOGY

/area/ruin/interdyne_planetary_base/med/morgue
	name = "英特戴恩停尸房"
	icon_state = "morgue"
	ambience_index = AMBIENCE_SPOOKY
	ambientsounds = list('sound/ambience/icemoon/ambiicemelody4.ogg') // creepy, but a bit wistful
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/ruin/interdyne_planetary_base/science
	name = "英特戴恩科研翼"
	icon = 'icons/area/areas_station.dmi'
	icon_state = "science"

/area/ruin/interdyne_planetary_base/science/xeno
	name = "英特戴恩异种生物学实验室"
	icon_state = "xenobio"

/area/ruin/interdyne_planetary_base/serv
	name = "英特戴恩服务翼"
	icon = 'icons/area/areas_station.dmi'
	icon_state = "hall_service"

/area/ruin/interdyne_planetary_base/serv/rstrm
	name = "英特戴恩无性别洗手间"
	icon_state = "toilet"

/area/ruin/interdyne_planetary_base/serv/bar
	name = "英特戴恩酒吧"
	icon_state = "bar"
	mood_bonus = 5
	mood_message = "I love being in the base's bar!"
	mood_trait = TRAIT_EXTROVERT

/area/ruin/interdyne_planetary_base/serv/kitchen
	name = "英特戴恩厨房"
	icon_state = "kitchen"

/area/ruin/interdyne_planetary_base/serv/hydr
	name = "英特戴恩水培室"
	icon_state = "hydro"

/area/ruin/interdyne_planetary_base/eng
	name = "英特戴恩工程部"
	icon = 'icons/area/areas_station.dmi'
	icon_state = "maint_electrical" // given interdyne's powerplant is rtg's, thought this looked good on the frontend for mappers
	ambient_buzz = 'modular_nova/modules/random_ship_event/random_ships/heliostatic_inspectors/sounds/gear_loop.ogg'

/area/ruin/interdyne_planetary_base/eng/Initialize(mapload)
	if(!ambientsounds)
		var/list/temp_ambientsounds = GLOB.ambience_assoc[ambience_index]
		ambientsounds = temp_ambientsounds.Copy()
		ambientsounds += list(
			'sound/items/geiger/low1.ogg',
			'sound/items/geiger/low2.ogg',
		)
	return ..()

/area/ruin/interdyne_planetary_base/eng/disp
	name = "英特戴恩废弃物处理"
	icon_state = "disposal"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

//The prefab colonist homestead. Dependent on the colony_fabricator module.
/area/ruin/colonist_homestead
	name = "殖民者家园"
