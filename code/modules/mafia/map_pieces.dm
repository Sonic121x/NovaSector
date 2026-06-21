/obj/effect/landmark/mafia_game_area //locations where mafia will be loaded by the datum
	name = "Mafia Area Spawn"

/obj/effect/landmark/mafia
	name = "Mafia Player Spawn"

/obj/effect/landmark/mafia/town_center
	name = "Mafia Town Center"

//for ghosts/admins
/obj/mafia_game_board
	name = "黑手党游戏板"
	icon = 'icons/obj/mafia.dmi'
	icon_state = "board"
	anchored = TRUE
	var/datum/mafia_controller/MF

/obj/mafia_game_board/attack_ghost(mob/user)
	. = ..()
	if(!MF)
		MF = GLOB.mafia_game
	if(!MF)
		MF = create_mafia_game()
	MF.ui_interact(user)

/datum/map_template/mafia
	should_place_on_top = FALSE
	///The map suffix to put onto the mappath.
	var/map_suffix
	///A brief background tidbit
	var/description = ""
	///What costume will this map force players to start with?
	var/custom_outfit

/datum/map_template/mafia/New(path = null, rename = null, cache = FALSE)
	path = "_maps/minigame/mafia/" + map_suffix
	return ..()

//we only have one map in unit tests for consistency.
#ifdef UNIT_TESTS
/datum/map_template/mafia/unit_test
	name = "黑手党单元测试"
	description = "专为单元测试设计的地图，确保游戏正常运行。"
	map_suffix = "mafia_unit_test.dmm"

#else

/datum/map_template/mafia/summerball
	name = "2020夏日舞会"
	description = "最初的，元老级。2020年夏季舞会正是黑手党模式的起源，用的就是这张地图。"
	map_suffix = "mafia_ball.dmm"

/datum/map_template/mafia/ufo
	name = "外星人母舰"
	description = "闹鬼的幽灵UFO之旅出了岔子，现在要靠我们优秀的镇民和寻求刺激者来干掉那些真正的异形变形者……"
	map_suffix = "mafia_ayylmao.dmm"
	custom_outfit = /datum/outfit/mafia/abductee

/datum/map_template/mafia/spider_clan
	name = "蜘蛛氏族绑架"
	description = "全新改良的蜘蛛氏族绑架事件不再那么无聊，多了很多处决环节。该死的西方文化迷！"
	map_suffix = "mafia_spiderclan.dmm"
	custom_outfit = /datum/outfit/mafia/ninja

/datum/map_template/mafia/gothic
	name = "吸血鬼城堡"
	description = "吸血鬼与变形者在这座阴森的古堡地图中交锋，争夺谁才是更优越的吸血怪物。"
	map_suffix = "mafia_gothic.dmm"
	custom_outfit = /datum/outfit/mafia/gothic

/datum/map_template/mafia/syndicate
	name = "辛迪加非正式站点"
	description = "是的，巨型空间站里度过了非常混乱的一天。辛迪加冲突解决特工能成功吗？"
	map_suffix = "mafia_syndie.dmm"
	custom_outfit = /datum/outfit/mafia/syndie

/datum/map_template/mafia/snowy
	name = "雪镇"
	description = "基于同名冰月地图改造，重制者的工作做得足够出色，以至于衍生出了以此为基础的作品。真酷！"
	map_suffix = "mafia_snow.dmm"
	custom_outfit = /datum/outfit/mafia/snowy

/datum/map_template/mafia/lavaland
	name = "拉瓦兰远足"
	description = "空间站现在根本不知道熔岩地上发生了什么，我们有变色龙……叛徒，而最糟糕的是……还有律师每晚都在妨碍你。"
	map_suffix = "mafia_lavaland.dmm"
	custom_outfit = /datum/outfit/mafia/lavaland

#endif
