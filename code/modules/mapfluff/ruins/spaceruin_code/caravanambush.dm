//caravan ambush

/obj/item/wrench/caravan
	icon_state = "wrench_caravan"
	desc = "一种新型扳手的设计原型，据称红色的设计方案让它工作速度更快。"
	name = "实验性扳手"
	icon_angle = -90
	toolspeed = 0.3

/obj/item/screwdriver/caravan
	icon = 'icons/obj/tools.dmi'
	icon_state = "screwdriver_caravan"
	post_init_icon_state = null
	desc = "一种新型螺丝刀的设计原型，据称红色的设计方案让它工作速度更快。"
	name = "实验性螺丝刀"
	toolspeed = 0.3
	random_color = FALSE
	greyscale_config = null
	greyscale_colors = null

/obj/item/wirecutters/caravan
	icon = 'icons/obj/tools.dmi'
	icon_state = "cutters_caravan"
	desc = "一种新型剪线钳的设计原型，据称红色的设计方案让它工作速度更快。"
	name = "实验性剪线钳"
	worn_icon_state = "cutters"
	toolspeed = 0.3
	random_color = FALSE
	greyscale_config = null
	greyscale_colors = null

/obj/item/crowbar/red/caravan
	icon_state = "crowbar_caravan"
	desc = "一种新型撬棍的设计原型，据称红色的设计方案让它工作速度更快。"
	name = "实验性撬棍"
	toolspeed = 0.3

/obj/machinery/computer/shuttle/caravan

/obj/item/circuitboard/computer/caravan
	build_path = /obj/machinery/computer/shuttle/caravan

/obj/item/circuitboard/computer/caravan/trade1
	build_path = /obj/machinery/computer/shuttle/caravan/trade1

/obj/item/circuitboard/computer/caravan/pirate
	build_path = /obj/machinery/computer/shuttle/caravan/pirate

/obj/item/circuitboard/computer/caravan/syndicate1
	build_path = /obj/machinery/computer/shuttle/caravan/syndicate1

/obj/item/circuitboard/computer/caravan/syndicate2
	build_path = /obj/machinery/computer/shuttle/caravan/syndicate2

/obj/item/circuitboard/computer/caravan/syndicate3
	build_path = /obj/machinery/computer/shuttle/caravan/syndicate3

/obj/machinery/computer/shuttle/caravan/trade1
	name = "小型货运穿梭机控制台"
	desc = "用来控制小货船。"
	circuit = /obj/item/circuitboard/computer/caravan/trade1
	shuttleId = "caravantrade1"
	possible_destinations = "whiteship_away;whiteship_home;whiteship_z4;whiteship_lavaland;caravantrade1_custom;caravantrade1_ambush"

/obj/machinery/computer/camera_advanced/shuttle_docker/caravan/Initialize(mapload)
	. = ..()
	GLOB.jam_on_wardec += src

/obj/machinery/computer/camera_advanced/shuttle_docker/caravan/Destroy()
	GLOB.jam_on_wardec -= src
	return ..()

/obj/machinery/computer/camera_advanced/shuttle_docker/caravan/trade1
	name = "小型货船导航计算机。"
	desc = "用于指定小型货船的精确航行地点。"
	shuttleId = "caravantrade1"
	lock_override = NONE
	shuttlePortId = "caravantrade1_custom"
	jump_to_ports = list("whiteship_away" = 1, "whiteship_home" = 1, "whiteship_z4" = 1, "caravantrade1_ambush" = 1)
	view_range = 6.5
	x_offset = -5
	y_offset = -5
	designate_time = 100

/obj/machinery/computer/shuttle/caravan/pirate
	name = "海盗穿梭快艇控制台"
	desc = "用来控制海盗快艇。"
	icon_screen = "syndishuttle"
	icon_keyboard = "syndie_key"
	light_color = COLOR_SOFT_RED
	circuit = /obj/item/circuitboard/computer/caravan/pirate
	shuttleId = "caravanpirate"
	possible_destinations = "caravanpirate_custom;caravanpirate_ambush"

/obj/machinery/computer/camera_advanced/shuttle_docker/caravan/pirate
	name = "海盗船导航计算机"
	desc = "用来为海盗快艇指定一个精确的抵达地点"
	icon_screen = "syndishuttle"
	icon_keyboard = "syndie_key"
	shuttleId = "caravanpirate"
	lock_override = NONE
	shuttlePortId = "caravanpirate_custom"
	jump_to_ports = list("caravanpirate_ambush" = 1)
	view_range = 6.5
	x_offset = 3
	y_offset = -6

/obj/machinery/computer/shuttle/caravan/syndicate1
	name = "辛迪加战斗机控制台"
	desc = "用于控制辛迪加战战斗机。"
	icon_screen = "syndishuttle"
	icon_keyboard = "syndie_key"
	light_color = COLOR_SOFT_RED
	req_access = list(ACCESS_SYNDICATE)
	circuit = /obj/item/circuitboard/computer/caravan/syndicate1
	shuttleId = "caravansyndicate1"
	possible_destinations = "caravansyndicate1_custom;caravansyndicate1_ambush;caravansyndicate1_listeningpost"

/obj/machinery/computer/camera_advanced/shuttle_docker/caravan/syndicate1
	name = "辛迪加战斗机导航电脑"
	desc = "用于指定辛迪加战斗机的精确中转地点。"
	icon_screen = "syndishuttle"
	icon_keyboard = "syndie_key"
	shuttleId = "caravansyndicate1"
	lock_override = NONE
	shuttlePortId = "caravansyndicate1_custom"
	jump_to_ports = list("caravansyndicate1_ambush" = 1, "caravansyndicate1_listeningpost" = 1)
	view_range = 0
	x_offset = 2
	y_offset = 0

/obj/machinery/computer/shuttle/caravan/syndicate2
	name = "辛迪加战斗机控制台"
	desc = "用于控制辛迪加战战斗机。"
	icon_screen = "syndishuttle"
	icon_keyboard = "syndie_key"
	req_access = list(ACCESS_SYNDICATE)
	light_color = COLOR_SOFT_RED
	circuit = /obj/item/circuitboard/computer/caravan/syndicate2
	shuttleId = "caravansyndicate2"
	possible_destinations = "caravansyndicate2_custom;caravansyndicate2_ambush;caravansyndicate1_listeningpost"

/obj/machinery/computer/camera_advanced/shuttle_docker/caravan/syndicate2
	name = "辛迪加战斗机导航电脑"
	desc = "用于指定辛迪加战斗机的精确中转地点。"
	icon_screen = "syndishuttle"
	icon_keyboard = "syndie_key"
	shuttleId = "caravansyndicate2"
	lock_override = NONE
	shuttlePortId = "caravansyndicate2_custom"
	jump_to_ports = list("caravansyndicate2_ambush" = 1, "caravansyndicate1_listeningpost" = 1)
	view_range = 0
	x_offset = 0
	y_offset = 2

/obj/machinery/computer/shuttle/caravan/syndicate3
	name = "辛迪加降落艇控制台"
	desc = "用于控制辛迪加降落艇"
	icon_screen = "syndishuttle"
	icon_keyboard = "syndie_key"
	req_access = list(ACCESS_SYNDICATE)
	light_color = COLOR_SOFT_RED
	circuit = /obj/item/circuitboard/computer/caravan/syndicate3
	shuttleId = "caravansyndicate3"
	possible_destinations = "caravansyndicate3_custom;caravansyndicate3_ambush;caravansyndicate3_listeningpost"

/obj/machinery/computer/camera_advanced/shuttle_docker/caravan/syndicate3
	name = "辛迪加降落艇导航电脑"
	desc = "用于指定辛迪加降落艇的精确中转地点。"
	icon_screen = "syndishuttle"
	icon_keyboard = "syndie_key"
	shuttleId = "caravansyndicate3"
	lock_override = NONE
	shuttlePortId = "caravansyndicate3_custom"
	jump_to_ports = list("caravansyndicate3_ambush" = 1, "caravansyndicate3_listeningpost" = 1)
	view_range = 2.5
	x_offset = -1
	y_offset = -3
