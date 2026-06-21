#define ARRIVALS_STATION "arrivals_stationary"
#define ARRIVALS_INTERLINK "arrivals_shuttle"
#define CONSOLE_ANNOUNCE_COOLDOWN 5 SECONDS

/obj/docking_port/mobile/arrivals_nova
	name = "NTV中继站"
	shuttle_id = "arrivals_shuttle"
	dir = WEST
	port_direction = SOUTH

	callTime = 9 SECONDS
	ignitionTime = 5 SECONDS
	rechargeTime = 9 SECONDS

	movement_force = list("KNOCKDOWN" = 3, "THROW" = 0)

	///Our shuttle's control console
	var/obj/machinery/computer/shuttle/arrivals/console
	///How much time are we waiting before returning to interlink. Sets itself automatically from config file
	var/wait_time
	///State variable. True when our shuttle is waiting before autoreturn
	var/waiting = FALSE // would've been better to use shuttle's mode variable, but check() resets it to SHUTTLE_IDLE so it's more sane way to make this fully modular

/obj/docking_port/mobile/arrivals_nova/Initialize(mapload)
	. = ..()
	wait_time = CONFIG_GET(number/arrivals_wait)
	return INITIALIZE_HINT_LATELOAD

/obj/docking_port/mobile/arrivals_nova/LateInitialize()
	console = get_control_console()

/obj/docking_port/mobile/arrivals_nova/check()
	. = ..()

	if(!wait_time) //0 disables autoreturn
		return

	if(mode != SHUTTLE_IDLE)
		return

	if(waiting && !timer)
		SSshuttle.moveShuttle(shuttle_id, ARRIVALS_INTERLINK, TRUE) // times up, we're leaving
		waiting = FALSE

	var/current_dock = getDockedId()
	if (current_dock != ARRIVALS_STATION)
		return

	if(check_occupied())
		if(!waiting)
			return

		timer = 0
		waiting = FALSE

		if(console && console.last_cancel_announce + CONSOLE_ANNOUNCE_COOLDOWN <= world.time)
			console.say("Lifesigns detected onboard, automatic return aborted.")
			console.last_cancel_announce = world.time

		return

	if(timer || waiting)
		return

	setTimer(wait_time)
	waiting = TRUE

	if(console && console.last_depart_announce + CONSOLE_ANNOUNCE_COOLDOWN <= world.time)
		console.say("Commencing automatic return subroutine in [wait_time / 10] seconds.")
		console.last_depart_announce = world.time

/obj/docking_port/mobile/arrivals_nova/getModeStr()
	. = ..()
	return waiting ? "RTN" : .

/**
 ** Checks if our shuttle is occupied by someone alive, and returns `TRUE` if it is, `FALSE` otherwise.
 **/
/obj/docking_port/mobile/arrivals_nova/proc/check_occupied()
	for(var/alive_player in GLOB.alive_player_list)
		if(get_area(alive_player) in shuttle_areas)
			return TRUE

	return FALSE

/obj/machinery/computer/shuttle/arrivals
	name = "抵达穿梭机控制台"
	desc = "用于控制抵达联运送穿梭机的终端。"
	shuttleId = "arrivals_shuttle"
	possible_destinations = "arrivals_stationary;arrivals_shuttle"
	icon = 'modular_nova/modules/advanced_shuttles/icons/computer.dmi'
	icon_state = "computer_frame"
	icon_keyboard = "arrivals_key"
	icon_screen = "arrivals"
	light_color = COLOR_ORANGE_BROWN
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	connectable = FALSE //connecting_computer change: since icon_state is not a typical console, it cannot be connectable.
	no_destination_swap = TRUE

	///[world.time] when console last announced departure
	var/last_depart_announce
	///[world.time] when console last announced canceling shuttle's return
	var/last_cancel_announce

/obj/machinery/computer/shuttle/arrivals/recall
	name = "抵达穿梭机召回终端"
	desc = "如果你的朋友把你落下了，就用这个。"
	possible_destinations = "arrivals_stationary;arrivals_shuttle"

/*
 *	MAP TEMPLATES
 */

/datum/map_template/shuttle/ferry/nova
	name = "NAV Monarch号（摆渡船）"
	prefix = "_maps/shuttles/nova/"
	port_id = "ferry"
	suffix = "nova"
	who_can_purchase = null

/datum/map_template/shuttle/cargo/nova
	name = "补给穿梭机（货运）"
	prefix = "_maps/shuttles/nova/"
	port_id = "cargo"
	suffix = "nova"

/datum/map_template/shuttle/cargo/nova/delta
	name = "补给穿梭机（德尔塔）"
	prefix = "_maps/shuttles/nova/"
	suffix = "nova_delta"	//I hate this. Delta station is one tile different docking-wise, which fucks it ALL up unless we either a) change the map (this would be nonmodular and also press the engine against disposals) or b) this (actually easy, just dumb)

/datum/map_template/shuttle/whiteship/blueshift
	name = "SFS 克里斯蒂安号"
	description = "一艘似乎遭到某种外星生物袭击的大型护卫舰。如果清理并修复，它将是一笔真正的资产。"
	prefix = "_maps/shuttles/nova/"
	port_id = "whiteship"
	suffix = "blueshift"

/datum/map_template/shuttle/cargo/nova/ouroboros
	name = "补给穿梭机（衔尾蛇号）"
	suffix = "ouroboros"

/datum/map_template/shuttle/whiteship/ouroboros
	name = "JN 猎舟号"
	description = "一艘旨在作为移动咖啡馆的小型 Jim Nortons 穿梭机。船上没有敌对生物，但有多个 Jim Nortons 员工的尸体。"
	prefix = "_maps/shuttles/nova/"
	port_id = "whiteship"
	suffix = "ouroboros"

/datum/map_template/shuttle/arrivals_nova
	name = "NTV 中继站（抵达）"
	prefix = "_maps/shuttles/nova/"
	port_id = "arrivals"
	suffix = "nova"
	who_can_purchase = null

/datum/map_template/shuttle/emergency/default
	name = "标准应急穿梭机"
	description = "纳米传讯的标准紧急穿梭机。"
	occupancy_limit = 60
	prefix = "_maps/shuttles/nova/"
	suffix = "nova"

/datum/map_template/shuttle/labour/nova
	name = "NMC 苦工号（劳工）"
	prefix = "_maps/shuttles/nova/"
	suffix = "nova"

/obj/docking_port/stationary/laborcamp_home
	roundstart_template = /datum/map_template/shuttle/labour/nova

/obj/docking_port/stationary/laborcamp_home/kilo
	roundstart_template = /datum/map_template/shuttle/labour/nova

/datum/map_template/shuttle/mining_common/nova
	name = "NMC 奇美拉号（采矿）"
	prefix = "_maps/shuttles/nova/"
	suffix = "nova"

/obj/docking_port/stationary/mining_home/common
	roundstart_template = /datum/map_template/shuttle/mining_common/nova

/obj/docking_port/stationary/mining_home/common/kilo
	roundstart_template = /datum/map_template/shuttle/mining_common/nova

/datum/map_template/shuttle/mining/nova
	name = "NMC 凤凰号（采矿）"
	prefix = "_maps/shuttles/nova/"
	suffix = "nova"

/obj/docking_port/stationary/mining_home
	roundstart_template = /datum/map_template/shuttle/mining/nova

/datum/map_template/shuttle/mining/nova/large
	name = "NMC 蝎尾狮号（采矿）"
	prefix = "_maps/shuttles/nova/"
	suffix = "nova_large"

#undef ARRIVALS_STATION
#undef ARRIVALS_INTERLINK
#undef CONSOLE_ANNOUNCE_COOLDOWN
