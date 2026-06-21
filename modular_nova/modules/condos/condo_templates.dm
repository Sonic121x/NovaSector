/*
HEY!!! LISTEN!!!
Due to some fuckery with how these templates work; the bottom left turf of your map HAS to touch the rest AND has to be on the same /area/.
*/

/datum/map_template/condo
	/// Offset from the bottom-left turf of your condo. Said turf MUST touch the rest of your condo due to how these templates are loaded; including in /area/.
	var/landing_zone_x_offset
	var/landing_zone_y_offset

/// Keep these alphabetical.

/datum/map_template/condo/alleyway
	name = "公寓 - 小巷"
	mappath = "modular_nova/modules/condos/_maps/alleyway.dmm"
	landing_zone_x_offset = 2
	landing_zone_y_offset = 5

/datum/map_template/condo/apartment
	name = "公寓 - 单元房"
	mappath = "modular_nova/modules/condos/_maps/apartment.dmm"
	landing_zone_x_offset = 2
	landing_zone_y_offset = 8

/datum/map_template/condo/blueshift_dorms_four
	name = "公寓 - \"蓝移\"风格宿舍"
	mappath = "modular_nova/modules/condos/_maps/blueshift_dormsfour.dmm"
	landing_zone_x_offset = 2
	landing_zone_y_offset = 2

/// Wowee! It's like I'm a real terrorist!
/// This particular one was cooler with wallening window frames and short stairs.. alas. twas not to be
/datum/map_template/condo/dstwo_condo
	name = "公寓 - 原汁原味 DS-2 主题"
	mappath = "modular_nova/modules/condos/_maps/dstwo_condo.dmm"
	landing_zone_x_offset = 7
	landing_zone_y_offset = 2

/datum/map_template/condo/beach_condo
	name = "公寓 - 海滨"
	mappath = "modular_nova/modules/condos/_maps/beach_condo.dmm"
	landing_zone_x_offset = 7
	landing_zone_y_offset = 2

/datum/map_template/condo/gm_condo
	name = "公寓 - 套房"
	mappath = "modular_nova/modules/condos/_maps/gm_condo.dmm"
	landing_zone_x_offset = 4
	landing_zone_y_offset = 2

/// This version's actually slightly different to justify itself; being based off the wallening version.
/datum/map_template/condo/hilberts_hotel
	name = "公寓 - 希尔伯特酒店客房"
	mappath = "modular_nova/modules/condos/_maps/hilbertshotel.dmm"
	landing_zone_x_offset = 2
	landing_zone_y_offset = 12

/datum/map_template/condo/lodge_pool
	name = "公寓 - 旅馆泳池"
	mappath = "modular_nova/modules/condos/_maps/lodge_pool.dmm"
	landing_zone_x_offset = 10
	landing_zone_y_offset = 1

/datum/map_template/condo/manor_hall
	name = "公寓 - 庄园大厅"
	mappath = "modular_nova/modules/condos/_maps/manor_hall.dmm"
	landing_zone_x_offset = 1
	landing_zone_y_offset = 3

/datum/map_template/condo/medieval_bog
	name = "公寓 - 中世纪沼泽"
	mappath = "modular_nova/modules/condos/_maps/medieval_bog.dmm"
	landing_zone_x_offset = 1
	landing_zone_y_offset = 3

/datum/map_template/condo/necropolis
	name = "公寓 - 死灵之城"
	mappath = "modular_nova/modules/condos/_maps/necropolis.dmm"
	landing_zone_x_offset = 2
	landing_zone_y_offset = 11

/datum/map_template/condo/ocean_view
	name = "公寓 - 海景房"
	mappath = "modular_nova/modules/condos/_maps/ocean_view.dmm"
	landing_zone_x_offset = 7
	landing_zone_y_offset = 1

/datum/map_template/condo/ouroboros_dorms_four
	name = "公寓 - \"衔尾蛇\"风格宿舍"
	mappath = "modular_nova/modules/condos/_maps/ouroboros_dormssix.dmm"
	landing_zone_x_offset = 2
	landing_zone_y_offset = 4

/// The joke was originally that it was just flatgrass. Now it's a little more.
/datum/map_template/condo/planar_soil
	name = "公寓 - 位面土壤"
	mappath = "modular_nova/modules/condos/_maps/planar_soil.dmm"
	landing_zone_x_offset = 7
	landing_zone_y_offset = 1

/datum/map_template/condo/serenity_cabin_four
	name = "公寓 - \"宁静\"风格小屋"
	mappath = "modular_nova/modules/condos/_maps/serenity_cabinfour.dmm"
	landing_zone_x_offset = 3
	landing_zone_y_offset = 1

/datum/map_template/condo/snowglobe_dorms_four
	name = "公寓 - \"雪景球\"风格宿舍"
	mappath = "modular_nova/modules/condos/_maps/snowglobe_dormsfour.dmm"
	landing_zone_x_offset = 6
	landing_zone_y_offset = 3

/datum/map_template/condo/snowy_cabin
	name = "Condo - Snowy Cabin"
	mappath = "modular_nova/modules/condos/_maps/snowy_cabin.dmm"
	landing_zone_x_offset = 14
	landing_zone_y_offset = 7

/datum/map_template/condo/station_arrivals
	name = "公寓 - 抵达检查站"
	mappath = "modular_nova/modules/condos/_maps/station_arrivals.dmm"
	landing_zone_x_offset = 2
	landing_zone_y_offset = 2

/datum/map_template/condo/xeno_resin
	name = "公寓 - 异形树脂"
	mappath = "modular_nova/modules/condos/_maps/xeno_resin.dmm"
	landing_zone_x_offset = 2
	landing_zone_y_offset = 1

/datum/map_template/condo/cabin_woods
	name = "公寓 - 林中小屋"
	mappath = "modular_nova/modules/condos/_maps/cabin_woods.dmm"
	landing_zone_x_offset = 2
	landing_zone_y_offset = 1

/datum/map_template/condo/ship_bridge
	name = "公寓 - 飞船舰桥"
	mappath = "modular_nova/modules/condos/_maps/ship_bridge.dmm"
	landing_zone_x_offset = 2
	landing_zone_y_offset = 8

/datum/map_template/condo/public_library
	name = "公寓 - 公共图书馆"
	mappath = "modular_nova/modules/condos/_maps/public_library.dmm"
	landing_zone_x_offset = 7
	landing_zone_y_offset = 1

/datum/map_template/condo/mountainside_apartment
	name = "公寓 - 山间公寓"
	mappath = "modular_nova/modules/condos/_maps/apartment_mountainside.dmm"
	landing_zone_x_offset = 14
	landing_zone_y_offset = 4

/datum/map_template/condo/mountainside_fortuneteller
	name = "公寓 - 占卜师公寓"
	mappath = "modular_nova/modules/condos/_maps/apartment_fortuneteller.dmm"
	landing_zone_x_offset = 5
	landing_zone_y_offset = 8

/datum/map_template/condo/mountainside_skyscraper
	name = "公寓 - 摩天大楼"
	mappath = "modular_nova/modules/condos/_maps/apartment_skyscraper.dmm"
	landing_zone_x_offset = 17
	landing_zone_y_offset = 3

/datum/map_template/condo/mountainside_dragonlair
	name = "公寓 - 龙之巢穴"
	mappath = "modular_nova/modules/condos/_maps/apartment_dragonslair.dmm"
	landing_zone_x_offset = 5
	landing_zone_y_offset = 11

/datum/map_template/condo/deepspace_ship
	name = "公寓 - 深空飞船"
	mappath = "modular_nova/modules/condos/_maps/ship_apartment.dmm"
	landing_zone_x_offset = 9
	landing_zone_y_offset = 2

/datum/map_template/condo/deepspace_pod
	name = "公寓 - 深空舱"
	mappath = "modular_nova/modules/condos/_maps/deepspace_pod.dmm"
	landing_zone_x_offset = 1
	landing_zone_y_offset = 2
