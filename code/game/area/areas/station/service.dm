/area/station/service
	airlock_wires = /datum/wires/airlock/service
	tacmap_color = TACMAP_AREA_SERVICE

/*
* Bar/Kitchen Areas
*/

/area/station/service/cafeteria
	name = "\improper 自助餐厅"
	icon_state = "cafeteria"

/area/station/service/minibar
	name = "\improper 迷你酒吧"
	icon_state = "minibar"

/area/station/service/kitchen
	name = "\improper 厨房"
	icon_state = "kitchen"

/area/station/service/kitchen/coldroom
	name = "\improper 厨房冷藏室"
	icon_state = "kitchen_cold"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/station/service/kitchen/diner
	name = "\improper 小餐馆"
	icon_state = "diner"

/area/station/service/kitchen/kitchen_backroom
	name = "\improper 厨房后室"
	icon_state = "kitchen_backroom"

/area/station/service/bar
	name = "\improper 酒吧"
	icon_state = "bar"
	mood_bonus = 5
	mood_message = "I love being in the bar!"
	mood_trait = TRAIT_EXTROVERT
	airlock_wires = /datum/wires/airlock/service
	sound_environment = SOUND_AREA_WOODFLOOR

/area/station/service/bar/Initialize(mapload)
	. = ..()
	GLOB.bar_areas += src

/area/station/service/bar/atrium
	name = "\improper 中庭"
	icon_state = "bar"
	sound_environment = SOUND_AREA_WOODFLOOR

/area/station/service/bar/backroom
	name = "\improper 酒吧后室"
	icon_state = "bar_backroom"

/*
* Entertainment/Library Areas
*/

/area/station/service/theater
	name = "\improper 剧院"
	icon_state = "theatre"
	sound_environment = SOUND_AREA_WOODFLOOR

/area/station/service/theater_dressing
	name = "\improper 剧院化妆间"
	icon_state = "theatre_dressing"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/station/service/greenroom
	name = "\improper 休息室"
	icon_state = "theatre_green"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/station/service/library
	name = "\improper 图书馆"
	icon_state = "library"
	mood_bonus = 5
	mood_message = "I love being in the library!"
	mood_trait = TRAIT_INTROVERT
	area_flags = CULT_PERMITTED | BLOBS_ALLOWED
	sound_environment = SOUND_AREA_LARGE_SOFTFLOOR

/area/station/service/library/garden
	name = "\improper 图书馆花园"
	icon_state = "library_garden"

/area/station/service/library/lounge
	name = "\improper 图书馆休息厅"
	icon_state = "library_lounge"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/station/service/library/artgallery
	name = "\improper 艺术画廊"
	icon_state = "library_gallery"

/area/station/service/library/private
	name = "\improper 图书馆私人研究室"
	icon_state = "library_gallery_private"

/area/station/service/library/upper
	name = "\improper 图书馆上层"
	icon_state = "library"

/area/station/service/library/printer
	name = "\improper 图书馆打印室"
	icon_state = "library"

/*
* Chapel/Pubby Monestary Areas
*/

/area/station/service/chapel
	name = "\improper 教堂"
	icon_state = "chapel"
	mood_bonus = 4
	mood_message = "Being in the chapel brings me peace."
	mood_trait = TRAIT_SPIRITUAL
	ambience_index = AMBIENCE_HOLY
	flags_1 = NONE
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/station/service/chapel/monastery
	name = "\improper 修道院"

/area/station/service/chapel/office
	name = "\improper 教堂办公室"
	icon_state = "chapeloffice"

/area/station/service/chapel/asteroid
	name = "\improper 教堂小行星"
	icon_state = "explored"
	sound_environment = SOUND_AREA_ASTEROID

/area/station/service/chapel/asteroid/monastery
	name = "\improper 修道院小行星"

/area/station/service/chapel/dock
	name = "\improper 教堂码头"
	icon_state = "construction"

/area/station/service/chapel/storage
	name = "\improper 教堂储藏室"
	icon_state = "chapelstorage"

/area/station/service/chapel/funeral
	name = "\improper 教堂殡仪室"
	icon_state = "chapelfuneral"

/area/station/service/hydroponics/garden/monastery
	name = "\improper 修道院花园"
	icon_state = "hydro"

/*
* Hydroponics/Garden Areas
*/

/area/station/service/hydroponics
	name = "水培室"
	icon_state = "hydro"
	airlock_wires = /datum/wires/airlock/service
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/station/service/hydroponics/upper
	name = "上层水培室"
	icon_state = "hydro"

/area/station/service/hydroponics/garden
	name = "花园"
	icon_state = "garden"

/*
* Misc/Unsorted Rooms
*/

/area/station/service/lawoffice
	name = "\improper 律师事务所"
	icon_state = "law"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/station/service/janitor
	name = "\improper 保洁储物间"
	icon_state = "janitor"
	area_flags = CULT_PERMITTED | BLOBS_ALLOWED
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/station/service/barber
	name = "\improper 理发店"
	icon_state = "barber"

/area/station/service/boutique
	name = "\improper 精品店"
	icon_state = "boutique"

/*
* Abandoned Rooms
*/

/area/station/service/hydroponics/garden/abandoned
	name = "\improper 废弃花园"
	icon_state = "abandoned_garden"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	tacmap_color = TACMAP_AREA_MAINTENANCE

/area/station/service/kitchen/abandoned
	name = "\improper 废弃厨房"
	icon_state = "abandoned_kitchen"
	tacmap_color = TACMAP_AREA_MAINTENANCE

/area/station/service/electronic_marketing_den
	name = "\improper 电子营销窝点"
	icon_state = "abandoned_marketing_den"
	tacmap_color = TACMAP_AREA_MAINTENANCE

/area/station/service/abandoned_gambling_den
	name = "\improper 废弃赌场窝点"
	icon_state = "abandoned_gambling_den"
	tacmap_color = TACMAP_AREA_MAINTENANCE

/area/station/service/abandoned_gambling_den/gaming
	name = "\improper 废弃游戏窝点"
	icon_state = "abandoned_gaming_den"
	tacmap_color = TACMAP_AREA_MAINTENANCE

/area/station/service/theater/abandoned
	name = "\improper 废弃剧院"
	icon_state = "abandoned_theatre"
	tacmap_color = TACMAP_AREA_MAINTENANCE

/area/station/service/library/abandoned
	name = "\improper 废弃图书馆"
	icon_state = "abandoned_library"
	tacmap_color = TACMAP_AREA_MAINTENANCE
