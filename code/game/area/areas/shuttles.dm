
//These are shuttle areas; all subtypes are only used as teleportation markers, they have no actual function beyond that.
//Multi area shuttles are a thing now, use subtypes! ~ninjanomnom

/area/shuttle
	name = "穿梭机"
	requires_power = FALSE
	static_lighting = TRUE
	default_gravity = STANDARD_GRAVITY
	always_unpowered = FALSE
	// Loading the same shuttle map at a different time will produce distinct area instances.
	area_flags = NONE
	area_flags_mapping = NONE
	icon = 'icons/area/areas_station.dmi'
	icon_state = "shuttle"
	flags_1 = CAN_BE_DIRTY_1
	area_limited_icon_smoothing = /area/shuttle
	sound_environment = SOUND_ENVIRONMENT_ROOM


/area/shuttle/place_on_top_react(list/new_baseturfs, turf/added_layer, flags)
	. = ..()
	if(ispath(added_layer, /turf/open/floor/plating))
		new_baseturfs.Add(/turf/baseturf_skipover/shuttle)
		. |= CHANGETURF_GENERATE_SHUTTLE_CEILING
	else if(ispath(new_baseturfs[1], /turf/open/floor/plating))
		new_baseturfs.Insert(1, /turf/baseturf_skipover/shuttle)
		. |= CHANGETURF_GENERATE_SHUTTLE_CEILING

////////////////////////////Custom Shuttles////////////////////////////

/area/shuttle/custom
	requires_power = TRUE

////////////////////////////Multi-area shuttles//////////////////////////////

////////////////////////////Syndicate infiltrator////////////////////////////

/area/shuttle/syndicate
	name = "辛迪加渗透者号"
	ambience_index = AMBIENCE_DANGER
	area_limited_icon_smoothing = /area/shuttle/syndicate

/area/shuttle/syndicate/bridge
	name = "辛迪加渗透者号控制室"

/area/shuttle/syndicate/medical
	name = "辛迪加渗透者号医疗舱"

/area/shuttle/syndicate/armory
	name = "辛迪加渗透者号军械库"

/area/shuttle/syndicate/eva
	name = "辛迪加渗透者号舱外活动区"

/area/shuttle/syndicate/hallway
	name = "辛迪加渗透者号走廊"

/area/shuttle/syndicate/engineering
	name = "辛迪加渗透者号工程部"

/area/shuttle/syndicate/airlock
	name = "辛迪加渗透者气闸"

////////////////////////////Pirate Shuttle////////////////////////////

/area/shuttle/pirate
	name = "海盗穿梭机"
	requires_power = TRUE

/area/shuttle/pirate/flying_dutchman
	name = "飞翔的荷兰人号"
	requires_power = FALSE

////////////////////////////Bounty Hunter Shuttles////////////////////////////

/area/shuttle/hunter
	name = "猎人穿梭机"

/area/shuttle/hunter/russian
	name = "俄罗斯货运船"
	requires_power = TRUE

/area/shuttle/hunter/mi13_foodtruck
	name = "完全普通的餐车"
	requires_power = TRUE
	ambience_index = AMBIENCE_DANGER

////////////////////////////White Ship////////////////////////////

/area/shuttle/abandoned
	name = "废弃飞船"
	requires_power = TRUE
	area_limited_icon_smoothing = /area/shuttle/abandoned

/area/shuttle/abandoned/bridge
	name = "废弃飞船舰桥"

/area/shuttle/abandoned/engine
	name = "废弃飞船引擎室"

/area/shuttle/abandoned/bar
	name = "废弃飞船酒吧"

/area/shuttle/abandoned/crew
	name = "废弃飞船船员宿舍"

/area/shuttle/abandoned/cargo
	name = "废弃飞船货舱"

/area/shuttle/abandoned/medbay
	name = "废弃飞船医疗舱"

/area/shuttle/abandoned/pod
	name = "废弃飞船逃生舱"

////////////////////////////Single-area shuttles////////////////////////////
/area/shuttle/transit
	name = "超空间"
	desc = "Weeeeee"
	static_lighting = FALSE
	base_lighting_alpha = 255

/area/shuttle/arrival
	name = "抵达穿梭机"
	area_flags_mapping = UNIQUE_AREA // SSjob refers to this area for latejoiners

/area/shuttle/arrival/on_joining_game(mob/living/boarder)
	if(SSshuttle.arrivals?.mode == SHUTTLE_CALL)
		var/atom/movable/screen/splash/Spl = new(null, null, boarder.client, TRUE)
		Spl.fade(TRUE)
		boarder.playsound_local(get_turf(boarder), 'sound/announcer/ApproachingTG.ogg', 25)
	boarder.update_parallax_teleport()

/area/shuttle/pod_1
	name = "逃生舱一号"

/area/shuttle/pod_2
	name = "逃生舱二号"

/area/shuttle/pod_3
	name = "逃生舱三号"

/area/shuttle/pod_4
	name = "逃生舱四号"

/area/shuttle/mining
	name = "采矿穿梭机"

/area/shuttle/mining/large
	name = "采矿穿梭机"
	requires_power = TRUE

/area/shuttle/labor
	name = "劳改营穿梭机"

/area/shuttle/supply
	name = "NLV 康赛恩号" //NOVA EDIT CHANGE
	area_flags = NOTELEPORT

/area/shuttle/escape
	name = "紧急穿梭机"
	area_flags = CULT_PERMITTED
	area_limited_icon_smoothing = /area/shuttle/escape
	flags_1 = CAN_BE_DIRTY_1

/area/shuttle/escape/backup
	name = "备用紧急穿梭机"

/area/shuttle/escape/brig
	name = "逃生穿梭机禁闭舱"
	icon_state = "shuttlered"

/area/shuttle/escape/luxury
	name = "豪华紧急穿梭机"
	area_flags = NOTELEPORT

/area/shuttle/escape/simulation
	name = "中世纪实境模拟穹顶"
	icon_state = "shuttlectf"
	area_flags = NOTELEPORT
	static_lighting = FALSE
	base_lighting_alpha = 255

/area/shuttle/escape/arena
	name = "竞技场"
	area_flags = NOTELEPORT

/area/shuttle/escape/meteor
	name = "\proper 一台绑着引擎的陨石"
	luminosity = NONE

/area/shuttle/escape/engine
	name = "逃生穿梭机引擎"

/area/shuttle/transport
	name = "运输穿梭机"

/area/shuttle/assault_pod
	name = "钢铁之雨"

/area/shuttle/sbc_starfury
	name = "SBC 星际狂怒号"

/area/shuttle/sbc_fighter1
	name = "SBC 战斗机 1"

/area/shuttle/sbc_fighter2
	name = "SBC 战斗机 2"

/area/shuttle/sbc_fighter3
	name = "SBC 战斗机 3"

/area/shuttle/sbc_corvette
	name = "SBC 护卫舰"

/area/shuttle/syndicate_scout
	name = "辛迪加侦察舰"

/area/shuttle/ruin
	name = "废弃穿梭机"

/// Special shuttles made for the Caravan Ambush ruin.
/area/shuttle/ruin/caravan
	requires_power = TRUE
	name = "废弃商队穿梭机"

/area/shuttle/ruin/caravan/syndicate1
	name = "辛迪加战斗机"

/area/shuttle/ruin/caravan/syndicate2
	name = "辛迪加战斗机"

/area/shuttle/ruin/caravan/syndicate3
	name = "辛迪加空降舰"

/area/shuttle/ruin/caravan/pirate
	name = "海盗快艇"

/area/shuttle/ruin/caravan/freighter1
	name = "小型货船"

/area/shuttle/ruin/caravan/freighter2
	name = "微型货船"

/area/shuttle/ruin/caravan/freighter3
	name = "微型货船"

// ----------- Cyborg Mothership

/area/shuttle/ruin/cyborg_mothership
	name = "赛博格母舰"
	requires_power = TRUE
	area_limited_icon_smoothing = /area/shuttle/ruin/cyborg_mothership

// ----------- Arena Shuttle
/area/shuttle/shuttle_arena
	name = "竞技场"
	default_gravity = STANDARD_GRAVITY
	requires_power = FALSE

/obj/effect/forcefield/arena_shuttle
	name = "传送门"
	initial_duration = 0
	var/list/warp_points = list()

/obj/effect/forcefield/arena_shuttle/Initialize(mapload)
	. = ..()
	for(var/obj/effect/landmark/shuttle_arena_safe/exit in GLOB.landmarks_list)
		warp_points += exit

/obj/effect/forcefield/arena_shuttle/Bumped(atom/movable/AM)
	if(!isliving(AM))
		return

	var/mob/living/L = AM
	if(L.pulling && istype(L.pulling, /obj/item/bodypart/head))
		to_chat(L, span_notice("你的祭品被容纳了. 你现在可以通过."), confidential = TRUE)
		qdel(L.pulling)
		var/turf/LA = get_turf(pick(warp_points))
		L.forceMove(LA)
		L.remove_status_effect(/datum/status_effect/hallucination)
		to_chat(L, "<span class='reallybig redtext'>战斗胜利。你的嗜血欲望逐渐消退。</span>", confidential = TRUE)
		for(var/obj/item/chainsaw/doomslayer/chainsaw in L)
			qdel(chainsaw)
		var/obj/item/skeleton_key/key = new(L)
		L.put_in_hands(key)
	else
		to_chat(L, span_warning("你还没有资格通过. 将一个断头放至屏障以被允许通过冠军之厅."), confidential = TRUE)

/obj/effect/landmark/shuttle_arena_safe
	name = "hall of champions"
	desc = "献给胜利者。"

/obj/effect/landmark/shuttle_arena_entrance
	name = "\proper the arena"
	desc = "一片岩浆遍布的战场。"

/obj/effect/forcefield/arena_shuttle_entrance
	name = "传送门"
	initial_duration = 0
	var/list/warp_points = list()

/obj/effect/forcefield/arena_shuttle_entrance/Bumped(atom/movable/AM)
	if(!isliving(AM))
		return

	if(!warp_points.len)
		for(var/obj/effect/landmark/shuttle_arena_entrance/S in GLOB.landmarks_list)
			warp_points |= S

	var/obj/effect/landmark/LA = pick(warp_points)
	var/mob/living/M = AM
	M.forceMove(get_turf(LA))
	to_chat(M, "<span class='reallybig redtext'>你被困在致命的竞技场中！要逃脱，你需要将一颗斩下的头颅拖到逃生传送门。</span>", confidential = TRUE)
	M.apply_status_effect(/datum/status_effect/mayhem)
