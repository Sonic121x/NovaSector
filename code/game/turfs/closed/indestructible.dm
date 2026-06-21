/turf/closed/indestructible
	name = "墙壁"
	desc = "实际上对常规破坏方法无懈可击。"
	icon = 'icons/turf/walls.dmi'
	explosive_resistance = 50
	rust_resistance = RUST_RESISTANCE_ABSOLUTE
	turf_flags = IS_SOLID | NO_RUST

/turf/closed/indestructible/TerraformTurf(path, new_baseturf, flags, defer_change = FALSE, ignore_air = FALSE)
	return

/turf/closed/indestructible/acid_act(acidpwr, acid_volume, acid_id)
	return FALSE

/turf/closed/indestructible/Melt()
	to_be_destroyed = FALSE
	return src

/turf/closed/indestructible/singularity_act()
	return

/turf/closed/indestructible/oldshuttle
	name = "奇怪的穿梭机墙壁"
	icon = 'icons/turf/shuttleold.dmi'
	icon_state = "block"

/turf/closed/indestructible/weeb
	name = "纸墙"
	desc = "加固的纸墙。有人真的不想让你离开。"
	icon = 'icons/obj/smooth_structures/paperframes.dmi'
	icon_state = "paperframes-0"
	base_icon_state = "paperframes"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_PAPERFRAME
	canSmoothWith = SMOOTH_GROUP_PAPERFRAME
	var/static/mutable_appearance/indestructible_paper = mutable_appearance('icons/obj/smooth_structures/structure_variations.dmi',icon_state = "paper-whole", layer = CLOSED_TURF_LAYER - 0.1)

/turf/closed/indestructible/weeb/Initialize(mapload)
	. = ..()
	update_appearance()

/turf/closed/indestructible/weeb/update_overlays()
	. = ..()
	. += indestructible_paper

/turf/closed/indestructible/sandstone
	name = "砂岩墙"
	desc = "带有砂岩覆层的墙壁。很粗糙。"
	icon = 'icons/turf/walls/sandstone_wall.dmi'
	icon_state = "sandstone_wall-0"
	base_icon_state = "sandstone_wall"
	baseturfs = /turf/closed/indestructible/sandstone
	smoothing_flags = SMOOTH_BITMASK

/turf/closed/indestructible/oldshuttle/corner
	icon_state = "corner"

/turf/closed/indestructible/splashscreen
	name = "Space Station 13"
	desc = null
	baseturfs = /turf/cordon
	icon = 'icons/blanks/blank_title.png'
	icon_state = ""
	pixel_x = 0 // NOVA EDIT - Re-centering the title screen - ORIGINAL: pixel_x = -64
	plane = SPLASHSCREEN_PLANE
	bullet_bounce_sound = null

INITIALIZE_IMMEDIATE(/turf/closed/indestructible/splashscreen)
/* NOVA EDIT REMOVAL
/turf/closed/indestructible/splashscreen/Initialize(mapload)
	. = ..()
	SStitle.splash_turf = src
	if(SStitle.icon)
		icon = SStitle.icon
		handle_generic_titlescreen_sizes()

///helper proc that will center the screen if the icon is changed to a generic width, to make admins have to fudge around with pixel_x less. returns null
/turf/closed/indestructible/splashscreen/proc/handle_generic_titlescreen_sizes()
	var/icon/size_check = icon(SStitle.icon, icon_state)
	var/width = size_check.Width()
	if(width == 480) // 480x480 is nonwidescreen
		pixel_x = 0
	else if(width == 608) // 608x480 is widescreen
		pixel_x = -64
	// NOVA EDIT START - Wider widescreen
	else if(width == 672) // Nova's widescreen is slightly wider than /tg/'s, so we need to accomodate that too.
		pixel_x = -96
	// NOVA EDIT END

/turf/closed/indestructible/splashscreen/vv_edit_var(var_name, var_value)
	. = ..()
	if(.)
		switch(var_name)
			if(NAMEOF(src, icon))
				SStitle.icon = icon
				handle_generic_titlescreen_sizes()

/turf/closed/indestructible/splashscreen/examine()
	desc = pick(strings(SPLASH_FILE, "splashes"))
	return ..()
NOVA EDIT REMOVAL END */

/turf/closed/indestructible/reinforced
	name = "强化墙壁"
	desc = "一大块用于分隔房间的强化金属。实际上对常规破坏方法无懈可击。"
	icon = 'icons/turf/walls/reinforced_wall.dmi'
	icon_state = "reinforced_wall-0"
	base_icon_state = "reinforced_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_WALLS + SMOOTH_GROUP_CLOSED_TURFS
	canSmoothWith = SMOOTH_GROUP_WALLS

/turf/closed/indestructible/reinforced/titanium
	name = "强化钛合金仿制墙壁"
	desc = "一大块用于分隔房间的强化金属。当然，为了降低成本，这只是一层模仿钛合金的优质喷漆。实际上对常规破坏方法无懈可击。"
	icon = 'icons/turf/walls/shuttle_wall.dmi'
	icon_state = "shuttle_wall-0"
	base_icon_state = "shuttle_wall"

/turf/closed/indestructible/reinforced/titanium/nodiagonal
	icon_state = "shuttle_wall-15"
	smoothing_flags = SMOOTH_BITMASK

/turf/closed/indestructible/riveted
	icon = 'icons/turf/walls/riveted.dmi'
	icon_state = "riveted-0"
	base_icon_state = "riveted"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_CLOSED_TURFS
	canSmoothWith = SMOOTH_GROUP_CLOSED_TURFS

/turf/closed/indestructible/syndicate
	icon = 'icons/turf/walls/plastitanium_wall.dmi'
	icon_state = "plastitanium_wall-0"
	base_icon_state = "plastitanium_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_WALLS + SMOOTH_GROUP_CLOSED_TURFS + SMOOTH_GROUP_SYNDICATE_WALLS
	canSmoothWith = SMOOTH_GROUP_SHUTTLE_PARTS + SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_PLASTITANIUM_WALLS + SMOOTH_GROUP_SYNDICATE_WALLS

/turf/closed/indestructible/riveted/uranium
	icon = 'icons/turf/walls/uranium_wall.dmi'
	icon_state = "uranium_wall-0"
	base_icon_state = "uranium_wall"
	smoothing_flags = SMOOTH_BITMASK

/turf/closed/indestructible/riveted/plastinum
	name = "铂金墙"
	desc = "一堵由等离子体-铂合金制成的奢华墙壁。对常规破坏方法几乎完全免疫。"
	icon = 'icons/turf/walls/plastinum_wall.dmi'
	icon_state = "plastinum_wall-0"
	base_icon_state = "plastinum_wall"
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_DIAGONAL_CORNERS
	smoothing_groups = SMOOTH_GROUP_WALLS + SMOOTH_GROUP_CLOSED_TURFS + SMOOTH_GROUP_PLASTINUM_WALLS
	canSmoothWith = SMOOTH_GROUP_PLASTINUM_WALLS

/turf/closed/indestructible/riveted/plastinum/nodiagonal
	icon = MAP_SWITCH('icons/turf/walls/plastinum_wall.dmi', 'icons/turf/walls/misc_wall.dmi')
	icon_state = MAP_SWITCH("plastinum_wall-0", "plastinum_nd")
	smoothing_flags = SMOOTH_BITMASK

/turf/closed/indestructible/wood
	icon = 'icons/turf/walls/wood_wall.dmi'
	icon_state = "wood_wall-0"
	base_icon_state = "wood_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_WOOD_WALLS + SMOOTH_GROUP_WALLS + SMOOTH_GROUP_CLOSED_TURFS
	canSmoothWith = SMOOTH_GROUP_WOOD_WALLS


/turf/closed/indestructible/alien
	name = "异形墙壁"
	desc = "一堵覆有异形合金板的墙壁。"
	icon = 'icons/turf/walls/abductor_wall.dmi'
	icon_state = "abductor_wall-0"
	base_icon_state = "abductor_wall"
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_DIAGONAL_CORNERS
	smoothing_groups = SMOOTH_GROUP_ABDUCTOR_WALLS + SMOOTH_GROUP_WALLS + SMOOTH_GROUP_CLOSED_TURFS
	canSmoothWith = SMOOTH_GROUP_ABDUCTOR_WALLS

/turf/closed/indestructible/alien/nodiagonal
	icon_state = "abductor_wall-15"
	smoothing_flags = SMOOTH_BITMASK

/turf/closed/indestructible/cult
	name = "符文金属墙"
	desc = "一堵刻有无法辨识符号的冰冷金属墙。凝视它们会让你的脑袋阵阵作痛。对常规破坏方法几乎完全免疫。"
	icon = 'icons/turf/walls/cult_wall.dmi'
	icon_state = "cult_wall-0"
	base_icon_state = "cult_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_WALLS + SMOOTH_GROUP_CLOSED_TURFS
	canSmoothWith = SMOOTH_GROUP_WALLS


/turf/closed/indestructible/abductor
	icon_state = "alien1"

/turf/closed/indestructible/opshuttle
	icon_state = "wall3"


/turf/closed/indestructible/fakeglass
	name = "窗户"
	icon = MAP_SWITCH('icons/obj/smooth_structures/reinforced_window.dmi', 'icons/obj/smooth_structures/structure_variations.dmi')
	icon_state = MAP_SWITCH("reinforced_window-0", "fake_window")
	base_icon_state = "reinforced_window"
	opacity = FALSE
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_WINDOW_FULLTILE
	canSmoothWith = SMOOTH_GROUP_WINDOW_FULLTILE

/turf/closed/indestructible/fakeglass/Initialize(mapload)
	. = ..()
	underlays += mutable_appearance('icons/obj/structures.dmi', "grille", layer - 0.01, src) //add a grille underlay
	underlays += mutable_appearance('icons/turf/floors.dmi', "plating", layer - 0.02, src) //add the plating underlay, below the grille

/turf/closed/indestructible/opsglass
	name = "窗户"
	icon = 'icons/obj/smooth_structures/plastitanium_window.dmi'
	icon_state = "plastitanium_window-0"
	base_icon_state = "plastitanium_window"
	opacity = FALSE
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_SHUTTLE_PARTS + SMOOTH_GROUP_WINDOW_FULLTILE_PLASTITANIUM
	canSmoothWith = SMOOTH_GROUP_WINDOW_FULLTILE_PLASTITANIUM

/turf/closed/indestructible/opsglass/Initialize(mapload)
	. = ..()
	underlays += mutable_appearance('icons/obj/structures.dmi', "grille", layer - 0.01, src)
	underlays += mutable_appearance('icons/turf/floors.dmi', "plating", layer - 0.02, src)

/turf/closed/indestructible/fakedoor
	name = "气闸门"
	icon = 'icons/obj/doors/airlocks/centcom/centcom.dmi'
	icon_state = "fake_door"

/turf/closed/indestructible/fakedoor/maintenance
	icon = 'icons/obj/doors/airlocks/hatch/maintenance.dmi'

/turf/closed/indestructible/fakedoor/glass_airlock
	icon = 'icons/obj/doors/airlocks/external/external.dmi'
	opacity = FALSE

/turf/closed/indestructible/fakedoor/engineering
	icon = 'icons/obj/doors/airlocks/station/engineering.dmi'

/turf/closed/indestructible/rock
	name = "致密岩石"
	desc = "一块密度极高的岩石，大多数采矿工具或炸药都无法将其破坏。"
	icon = 'icons/turf/mining.dmi'
	icon_state = "rock"

/turf/closed/indestructible/rock/snow
	name = "山体"
	desc = "一块密度极高的岩石，表面覆盖着数个世纪积累的冰雪。"
	icon = 'icons/turf/walls.dmi'
	icon_state = "snowrock"
	bullet_sizzle = TRUE
	bullet_bounce_sound = null

/turf/closed/indestructible/rock/snow/ice
	name = "冰封岩石"
	desc = "由多年严寒锻造而成的、密度极高的冰岩复合体。"
	icon = 'icons/turf/walls.dmi'
	icon_state = "icerock"

/turf/closed/indestructible/rock/snow/ice/ore
	icon = 'icons/turf/walls/icerock_wall.dmi'
	icon_state = "icerock_wall-0"
	base_icon_state = "icerock_wall"
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_BORDER
	canSmoothWith = SMOOTH_GROUP_CLOSED_TURFS
	pixel_x = -4
	pixel_y = -4

/turf/closed/indestructible/paper
	name = "厚纸墙"
	desc = "一堵由无法穿透的纸张层层叠成的墙壁。"
	icon = 'icons/turf/walls.dmi'
	icon_state = "paperwall"

/turf/closed/indestructible/necropolis
	name = "死城墙壁"
	desc = "一堵看似无法穿透的墙壁。"
	icon = 'icons/turf/walls.dmi'
	icon_state = "necro"
	explosive_resistance = 50
	baseturfs = /turf/closed/indestructible/necropolis

/turf/closed/indestructible/necropolis/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	underlay_appearance.icon = 'icons/turf/floors.dmi'
	underlay_appearance.icon_state = "necro1"
	return TRUE

/turf/closed/indestructible/iron
	name = "坚不可摧的铁墙"
	desc = "一堵覆有坚固铁板的墙壁。"
	icon = 'icons/turf/walls/iron_wall.dmi'
	icon_state = "iron_wall-0"
	base_icon_state = "iron_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_IRON_WALLS + SMOOTH_GROUP_WALLS + SMOOTH_GROUP_CLOSED_TURFS
	canSmoothWith = SMOOTH_GROUP_IRON_WALLS
	opacity = FALSE

/turf/closed/indestructible/riveted/boss
	name = "死城之墙"
	desc = "一面厚重、看似坚不可摧的石墙。"
	icon = 'icons/turf/walls/boss_wall.dmi'
	icon_state = "boss_wall-0"
	base_icon_state = "boss_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_CLOSED_TURFS + SMOOTH_GROUP_BOSS_WALLS
	canSmoothWith = SMOOTH_GROUP_BOSS_WALLS
	explosive_resistance = 50
	baseturfs = /turf/closed/indestructible/riveted/boss

/turf/closed/indestructible/riveted/boss/wasteland
	baseturfs = /turf/open/misc/asteroid/basalt/wasteland

/turf/closed/indestructible/riveted/boss/see_through
	opacity = FALSE

/turf/closed/indestructible/riveted/boss/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	underlay_appearance.icon = 'icons/turf/floors.dmi'
	underlay_appearance.icon_state = "basalt"
	return TRUE

/turf/closed/indestructible/riveted/hierophant
	name = "符文墙"
	desc = "一面由奇异石头构成的墙，其侧面的符文正以某种节奏脉动着。"
	icon = 'icons/turf/walls/hierophant_wall.dmi'
	icon_state = "hierophant_wall-0"
	base_icon_state = "hierophant_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_HIERO_WALL
	canSmoothWith = SMOOTH_GROUP_HIERO_WALL

/turf/closed/indestructible/riveted/hierophant/set_smoothed_icon_state(new_junction)
	. = ..()
	update_appearance(UPDATE_OVERLAYS)

/turf/closed/indestructible/riveted/hierophant/update_overlays()
	. = ..()
	. += emissive_appearance('icons/turf/walls/hierophant_wall_e.dmi', icon_state, src)

/turf/closed/indestructible/resin
	name = "树脂墙"
	icon = 'icons/obj/smooth_structures/alien/resin_wall.dmi'
	icon_state = "resin_wall-0"
	base_icon_state = "resin_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_ALIEN_WALLS + SMOOTH_GROUP_ALIEN_RESIN
	canSmoothWith = SMOOTH_GROUP_ALIEN_WALLS

/turf/closed/indestructible/resin/membrane
	name = "树脂薄膜"
	icon = 'icons/obj/smooth_structures/alien/resin_membrane.dmi'
	icon_state = "resin_membrane-0"
	base_icon_state = "resin_membrane"
	opacity = FALSE
	smoothing_groups = SMOOTH_GROUP_ALIEN_WALLS + SMOOTH_GROUP_ALIEN_RESIN
	canSmoothWith = SMOOTH_GROUP_ALIEN_WALLS

/turf/closed/indestructible/resin/membrane/Initialize(mapload)
	. = ..()
	underlays += mutable_appearance('icons/turf/floors.dmi', "engine", layer - 0.01, src) // add the reinforced floor underneath

/turf/closed/indestructible/grille
	name = "格栅"
	icon = 'icons/obj/structures.dmi'
	icon_state = "grille"
	base_icon_state = "grille"

/turf/closed/indestructible/grille/Initialize(mapload)
	. = ..()
	underlays += mutable_appearance('icons/turf/floors.dmi', "plating", layer - 0.01, src)

/turf/closed/indestructible/meat
	name = "致密肉墙"
	desc = "一大块致密、紧实的肉块。常规的破坏方法对其基本无效。"
	icon = 'icons/turf/walls/meat_wall.dmi'
	icon_state = "meat_wall-0"
	base_icon_state = "meat_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_WALLS
	canSmoothWith = SMOOTH_GROUP_WALLS
