/obj/structure/wargame_hologram
	name = "损坏的全息战争游戏标记"
	desc = "你感觉这东西本该告诉你些什么，但全息影像肯定坏了。"
	icon = 'modular_nova/modules/wargame_projectors/icons/projectors_and_holograms.dmi'
	icon_state = "broke"
	anchored = TRUE
	density = FALSE
	max_integrity = 1
	obj_flags = UNIQUE_RENAME
	/// What object created this projection? Can be null as a projector isn't required for this to exist
	var/obj/item/wargame_projector/projector

/obj/structure/wargame_hologram/Initialize(mapload, source_projector)
	. = ..()
	if(source_projector)
		projector = source_projector
		LAZYADD(projector.projections, src)

/obj/structure/wargame_hologram/Destroy()
	if(projector)
		LAZYREMOVE(projector.projections, src)
		projector = null
	return ..()

/obj/structure/wargame_hologram/update_overlays()
	. = ..()
	. += emissive_appearance(icon, icon_state, src)

/*
Projections for 'moving vessels' in order from smallest to largest representation
*/

/obj/structure/wargame_hologram/strike_craft
	name = "打击机标记"
	desc = "纳米传讯战争游戏标准中，用于表示某种单一打击机的标识。"
	icon_state = "strikesingle"

/obj/structure/wargame_hologram/strike_craft/wing
	name = "打击机中队标记"
	desc = "纳米传讯战争游戏标准中，用于表示某种打击机中队的标识。"
	icon_state = "strikewing"

/obj/structure/wargame_hologram/ship_marker
	name = "小型舰船标记"
	desc = "NT兵棋推演标准中较小尺寸舰船的表示，通常用于护卫舰级别的舰船。"
	icon_state = "smallship"

/obj/structure/wargame_hologram/ship_marker/medium
	name = "中型舰船标记"
	desc = "NT兵棋推演标准中平均尺寸舰船的表示，通常用于驱逐舰级别的舰船。"
	icon_state = "mediumship"

/obj/structure/wargame_hologram/ship_marker/large
	name = "大型舰船标记"
	desc = "NT兵棋推演标准中较大尺寸舰船的表示，通常用于巡洋舰级别的舰船。"
	icon_state = "bigship"

/obj/structure/wargame_hologram/ship_marker/large/alternate
	name = "替代大型舰船标记"
	desc = "NT兵棋推演中较大尺寸舰船的替代表示，通常用于特殊舰船，如航空母舰。"
	icon_state = "bigship_alternate"

/obj/structure/wargame_hologram/unidentified
	name = "未识别接触标记"
	desc = "NT兵棋推演标准中用于表示尚未识别的接触。"
	icon_state = "unidentified"

/*
Projections for misc stuff, like stations, scout probes, or incoming missiles
*/

/obj/structure/wargame_hologram/missile_warning
	name = "飞行中导弹标记"
	desc = "NT兵棋推演标准中用于表示正在飞向目标的导弹或鱼雷。"
	icon_state = "missile"

/obj/structure/wargame_hologram/probe
	name = "探测器标记"
	desc = "NT兵棋推演标准中用于表示探测器尺寸的舰船或结构。"
	icon_state = "probe"

/obj/structure/wargame_hologram/stationary_structure
	name = "空间站标记"
	desc = "NT兵棋推演标准中用于表示各种尺寸的空间站。"
	icon_state = "station"

/obj/structure/wargame_hologram/stationary_structure/platform
	name = "平台标记"
	desc = "NT兵棋推演标准中用于表示各种尺寸的平台，无论是否武装。"
	icon_state = "platform"

/*
Projections for space 'terrain' like asteroids and dust clouds
*/

/obj/structure/wargame_hologram/dust
	name = "星尘场标记"
	desc = "NT兵棋推演标准中用于表示一大片星尘云。"
	icon_state = "dustcloud"

/obj/structure/wargame_hologram/asteroid
	name = "小型小行星标记"
	desc = "纳米传讯兵棋推演标准中，用于表示中小型小行星的标识。"
	icon_state = "asteroidsmall"

/obj/structure/wargame_hologram/asteroid/large
	name = "大型小行星标记"
	desc = "纳米传讯兵棋推演标准中，用于表示中大型小行星的标识。"
	icon_state = "asteroidlarge"

/obj/structure/wargame_hologram/asteroid/cluster
	name = "小行星群标记"
	desc = "纳米传讯兵棋推演标准中，用于表示小型小行星群的标识。"
	icon_state = "asteroidcluster"

/obj/structure/wargame_hologram/planet
	name = "行星体标记"
	desc = "纳米传讯兵棋推演标准中，用于表示各种尺寸行星体的标识。"
	icon_state = "planet"
