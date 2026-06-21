/datum/map_template/shuttle/emergency/outpost
	suffix = "outpost"
	prefix = "_maps/shuttles/nova/"
	name = "前哨站空间站紧急穿梭机"
	description = "这款狭长纤细的穿梭机是矩形爱好者的完美选择，以其令人难以置信（有待考证）的安全评级而闻名。"
	admin_notes = "Has airlocks on both sides of the shuttle and will probably ram deltastation's maint wing below medical. Oh well?"
	credit_cost = CARGO_CRATE_VALUE * 4
	occupancy_limit = 45

/*----- Black Market Shuttle Datum + related code -----*/
/datum/map_template/shuttle/ruin/blackmarket_burst
	prefix = "_maps/shuttles/nova/"
	suffix = "blackmarket_burst"
	description = "一种小型货运跳跃货船，深受那些既看重货舱空间又追求速度的走私者欢迎"
	name = "黑市爆裂号"

/obj/machinery/computer/shuttle/caravan/blackmarket_burst
	name = "爆裂号穿梭机控制台"
	desc = "Used to control the affectionately named 'Burst'."
	circuit = /obj/item/circuitboard/computer/blackmarket_burst
	shuttleId = "blackmarket_burst"
	possible_destinations = "blackmarket_burst_custom;blackmarket_burst_home;whiteship_home"

/obj/machinery/computer/camera_advanced/shuttle_docker/blackmarket_burst
	name = "爆裂号导航计算机"
	desc = "Used to designate a precise transit location for the affectionately named 'Burst'."
	shuttleId = "blackmarket_burst"
	lock_override = NONE
	shuttlePortId = "blackmarket_burst_custom"
	jump_to_ports = list("blackmarket_burst_home" = 1, "whiteship_home" = 1)
	view_range = 0
	x_offset = 2
	y_offset = 0

/obj/item/circuitboard/computer/blackmarket_burst
	name = "爆裂号控制台（电脑主板）"
	build_path = /obj/machinery/computer/shuttle/caravan/blackmarket_burst

/obj/item/shuttle_remote/bmd
	name = "爆裂号遥控器"
	shuttle_away_id = "whiteship_home"
	shuttle_home_id = "blackmarket_burst_home"

/*----- End of Black Market Shuttle Code -----*/

/*Interdyne Cargo Shuttle*/
/datum/map_template/shuttle/ruin/interdyne_cargo
	prefix = "_maps/shuttles/nova/"
	suffix = "interdyne_cargo"
	name = "英特戴恩货运穿梭机"

/obj/machinery/computer/shuttle/interdyne_cargo
	name = "英特戴恩货运穿梭机控制台"
	desc = "用于控制英特戴恩货运穿梭机。"
	circuit = /obj/item/circuitboard/computer/interdyne_cargo
	shuttleId = "interdyne_cargo"
	icon_screen = "syndishuttle"
	icon_keyboard = "syndie_key"
	possible_destinations = "interdyne_cargo_home;interdyne_cargo_away;interdyne_cargo_custom;whiteship_home"

/obj/item/circuitboard/computer/interdyne_cargo
	name = "英特戴恩穿梭机控制（电脑主板）"
	build_path = /obj/machinery/computer/shuttle/interdyne_cargo

/obj/item/shuttle_remote/interdyne
	name = "英特戴恩货运穿梭机遥控器"
	shuttle_away_id = "interdyne_cargo_away"
	shuttle_home_id = "interdyne_cargo_home"

/*Interdyne Cargo Shuttle End*/

/obj/machinery/computer/camera_advanced/shuttle_docker/slaver
	name = "舰船导航计算机"
	desc = "用于指定精确的自定义着陆目的地。"
	shuttleId = "slaver_syndie"
	lock_override = NONE
	shuttlePortId = "slaver"
	jump_to_ports = list("whiteship_away" = 1, "whiteship_home" = 1, "whiteship_z4" = 1, "syndicate_ne" = 1, "syndicate_nw" = 1, "syndicate_n" = 1, "syndicate_se" = 1, "syndicate_sw" = 1, "syndicate_s" = 1)
	view_range = 10
	x_offset = 0
	y_offset = 0
	designate_time = 30

/obj/machinery/computer/shuttle/slaver
	name = "舰船旅行终端"
	desc = "用于将舰船移动到预设目的地或由导航计算机标记出的自定义目的地的控制台。"
	icon_screen = "syndishuttle"
	icon_keyboard = "syndie_key"
	light_color = COLOR_SOFT_RED
	req_access = list(ACCESS_SYNDICATE)
	shuttleId = "slaver_syndie"
	possible_destinations = "syndicate_ne;syndicate_nw;syndicate_n;syndicate_se;syndicate_sw;syndicate_s"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF

/obj/machinery/computer/shuttle/slaver/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/tool_blocker, TOOL_SCREWDRIVER)
	AddElement(/datum/element/tool_blocker, TOOL_CROWBAR)

/datum/map_template/shuttle/slaver_ship
	port_id = "slaver ship"
	prefix = "_maps/shuttles/nova/"
	port_id = "slaver"
	suffix = "syndie"
	name = "奴隶贩子舰船"
	who_can_purchase = null

/obj/effect/mob_spawn/ghost_role/human/guild
	name = "私掠奴隶贩子"
	prompt_name = "一位私掠奴隶贩子"
	you_are_text = "你来到这里是为了绑架有价值的俘虏，将他们卖为奴隶。"
	flavour_text = "You're part of a privateer crew that sometimes takes contracts from the illusive Guild, which offers bounties and contracts to independent crews. Raiding colonies of the many less technologically advanced species in the area is much easier than this. You've been told that your mission is to capture as many valuable hostages from the station as possible. Your anonymous employer insists on the importance of humiliating SolFed by snatching those under their protection from right under their noses."
	important_text = ""

/obj/effect/mob_spawn/ghost_role/human/guild/slaver
	name = "私掠奴隶贩子"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper_s"
	outfit = /datum/outfit/guild/slaver

/obj/effect/mob_spawn/ghost_role/human/guild/slaver/captain
	name = "私掠奴隶贩子舰长"
	you_are_text = "你领导着一支专注于绑架人质的小队。"
	flavour_text = "You're the captain of a privateer crew that sometimes takes contracts from the illusive Guild, which offers bounties and contracts to independent crews, like yours! Lead your crew to infiltrate the station and capture hostages and hold them till the station's emergency shuttle leaves. The higher ranking the hostages, the more you'll get paid out. You're free to (and encouraged to) beat and humiliate, but not kill. Your anonymous employer wants your victims as their personel slaves. They mentioned something about propaganda? Ah, who knows with the Guild... All sorts of types posts these bounties."
	important_text = "担任此角色时，你需要进行大量的角色扮演并有效地领导。"
	outfit = /datum/outfit/guild/slaver/captain

/obj/item/radio/headset/guild
	keyslot = new /obj/item/encryptionkey/headset_syndicate/guild

/obj/item/radio/headset/guild/command
	command = TRUE

/datum/outfit/guild
	name = "公会默认装备"

/datum/outfit/guild/slaver
	name = "私掠奴隶贩子"
	head = /obj/item/clothing/head/helmet/alt
	suit = /obj/item/clothing/suit/armor/bulletproof
	uniform = /obj/item/clothing/under/syndicate/combat
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	ears = /obj/item/radio/headset/guild
	glasses = /obj/item/clothing/glasses/hud/security/chameleon
	back = /obj/item/storage/backpack
	implants = list(/obj/item/implant/weapons_auth)
	belt = /obj/item/storage/belt/military
	r_pocket = /obj/item/storage/pouch/ammo
	l_pocket = /obj/item/gun/energy/e_gun/mini
	id = /obj/item/card/id/advanced/chameleon
	id_trim = /datum/id_trim/chameleon/operative
	skillchips = list(/obj/item/skillchip/job/engineer)
	backpack_contents = list(
		/obj/item/storage/box/survival/engineer/radio,
		/obj/item/melee/baton/telescopic,
		/obj/item/storage/toolbox/guncase/nova/pistol/trappiste_small_case/wespe,
		/obj/item/grenade/c4,
		/obj/item/grenade/smokebomb
	)

/datum/outfit/guild/slaver/captain
	name = "私掠奴隶贩子舰长"
	head = /obj/item/clothing/head/helmet/alt
	suit = /obj/item/clothing/suit/armor/bulletproof
	uniform = /obj/item/clothing/under/syndicate/combat
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	ears = /obj/item/radio/headset/guild/command
	glasses = /obj/item/clothing/glasses/thermal/syndi
	back = /obj/item/storage/backpack
	implants = list(/obj/item/implant/weapons_auth)
	belt = /obj/item/storage/belt/military
	r_pocket = /obj/item/storage/pouch/ammo
	l_pocket = /obj/item/gun/energy/e_gun/mini
	id = /obj/item/card/id/advanced/chameleon
	id_trim = /datum/id_trim/chameleon/operative
	skillchips = list(/obj/item/skillchip/job/engineer)
	backpack_contents = list(
		/obj/item/storage/box/survival/engineer/radio,
		/obj/item/melee/baton/telescopic,
		/obj/item/storage/toolbox/guncase/nova/pistol/trappiste_small_case/skild,
		/obj/item/megaphone/command,
	)

/*----- Tarkon Shuttle Datum + related code -----*/
/datum/map_template/shuttle/ruin/tarkon_driver
	prefix = "_maps/shuttles/nova/"
	suffix = "tarkon_driver"
	name = "塔康钻探驱动器"

/obj/machinery/computer/shuttle/tarkon_driver
	name = "塔康驱动器控制台"
	desc = "用于控制塔康驱动器。"
	circuit = /obj/item/circuitboard/computer/tarkon_driver
	shuttleId = "tarkon_driver"
	possible_destinations = "tarkon_driver_custom;port_tarkon;whiteship_home"

/obj/machinery/computer/camera_advanced/shuttle_docker/tarkon_driver
	name = "塔康驱动器导航计算机"
	desc = "塔康驱动器的导航控制台。一个损坏的“启动钻头”按钮似乎正以黄色微弱闪烁。"
	shuttleId = "tarkon_driver"
	lock_override = NONE
	shuttlePortId = "tarkon_driver_custom"
	jump_to_ports = list("port_tarkon" = 1, "whiteship_home" = 1)
	view_range = 0

/obj/item/circuitboard/computer/tarkon_driver
	name = "塔康驱动器控制台（电脑主板）"
	build_path = /obj/machinery/computer/shuttle/tarkon_driver

/obj/item/shuttle_remote/tarkon
	name = "塔康驱动器遥控器"
	shuttle_away_id = "whiteship_home"
	shuttle_home_id = "port_tarkon"

/*----- End of Tarkon Shuttle Code -----*/

/*----- SerenityStation Shuttle Code -----*/
/datum/map_template/shuttle/planetary
	port_id = "planetary"
	who_can_purchase = null

/datum/map_template/shuttle/planetary/planetary_ferry
	prefix = "_maps/shuttles/nova/"
	suffix = "planetary_ferry"
	name = "行星摆渡船"

/obj/machinery/computer/shuttle/planetary_ferry
	name = "行星摆渡船控制台"
	desc = "用于控制摆渡船离开行星。"
	circuit = /obj/item/circuitboard/computer/planetary_ferry
	shuttleId = "planetary_ferry"
	possible_destinations = "planetary_dock;orbital_dock"

/obj/item/circuitboard/computer/planetary_ferry
	name = "行星摆渡控制台（电脑主板）"
	build_path = /obj/machinery/computer/shuttle/planetary_ferry

/*----- End of SerenityStation Shuttle Code -----*/

/*----- SOLFED VESSEL Shuttle Code -----*/
/datum/map_template/shuttle/ert/solfed
	prefix = "_maps/shuttles/nova/"
	suffix = "solfed_general_shuttle"
	name = "EAS(I)-6224 运输穿梭机"

/obj/machinery/computer/shuttle/solfed
	name = "\improper EAS(I)-6224 控制台"
	desc = "用于控制 EAS(I)-6224。"
	circuit = /obj/item/circuitboard/computer/solfed
	shuttleId = "solfed_general_shuttle"
	possible_destinations = "solfed_general_custom;solfed_general_home;whiteship_home;syndicate_nw"
	req_access = list(ACCESS_CENT_GENERAL)

/obj/machinery/computer/camera_advanced/shuttle_docker/solfed
	name = "\improper EAS(I)-6224 导航电脑"
	desc = "EAS(I)-6224 的导航控制台。"
	shuttleId = "solfed_general_shuttle"
	lock_override = CAMERA_LOCK_STATION
	shuttlePortId = "solfed_general_custom"
	jump_to_ports = list( "whiteship_home" = 1, "syndicate_nw" = 1, )
	view_range = 12
	zlink_range = 1
	move_up_action = /datum/action/innate/camera_multiz_up
	move_down_action = /datum/action/innate/camera_multiz_down

/obj/item/circuitboard/computer/solfed
	name = "EAS(I)-6224 控制台（电脑主板）"
	build_path = /obj/machinery/computer/shuttle/solfed

/obj/item/gps/computer/space/solfed
	name = "\improper 太阳联邦 GPS 应答器"
	icon = 'modular_nova/modules/mapping/icons/machinery/gps_computer_x32.dmi'	//needs its own file for pixel size ;-;
	gpstag = "*SF - EAS(I)-6224"
	pixel_y = 0

/*----- End of SOLFED VESSEL Shuttle Code -----*/

/*----- SOLFED INFANTRY VESSEL Shuttle Code -----*/
/datum/map_template/shuttle/ert/solfed/armory
	prefix = "_maps/shuttles/nova/"
	suffix = "solfed_armory_shuttle"
	name = "EAS(I)-2271 运输穿梭机"

/obj/machinery/computer/shuttle/solfed/armory
	name = "\improper EAS(I)-2271 控制台"
	desc = "用于控制 EAS(I)-2271。"
	circuit = /obj/item/circuitboard/computer/solfed/armory
	shuttleId = "solfed_armory_shuttle"
	possible_destinations = "solfed_armory_custom;whiteship_home"

/obj/machinery/computer/camera_advanced/shuttle_docker/solfed/armory
	name = "\improper EAS(I)-2271 导航电脑"
	desc = "EAS(I)-2271 的导航控制台。"
	shuttleId = "solfed_armory_shuttle"
	shuttlePortId = "solfed_armory_custom"

/obj/item/circuitboard/computer/solfed/armory
	name = "EAS(I)-2271 控制台（电脑主板）"
	build_path = /obj/machinery/computer/shuttle/solfed/armory

/obj/item/gps/computer/space/solfed/armory
	gpstag = "*SF - EAS(I)-2271"
/*----- End of SOLFED INFANTRY VESSEL Shuttle Code -----*/

/*----- SOLFED HOSPITAL VESSEL Shuttle Code -----*/
/datum/map_template/shuttle/ert/solfed/medical
	prefix = "_maps/shuttles/nova/"
	suffix = "solfed_medical_shuttle"
	name = "EAS(H)-1457 医疗运输穿梭机"

/obj/machinery/computer/shuttle/solfed/medical
	name = "\improper EAS(H)-1457 控制台"
	desc = "用于控制 EAS(H)-1457。"
	circuit = /obj/item/circuitboard/computer/solfed/medical
	shuttleId = "solfed_medical_shuttle"
	possible_destinations = "solfed_medical_shuttle_custom;whiteship_home"

/obj/machinery/computer/camera_advanced/shuttle_docker/solfed/medical
	name = "\improper EAS(H)-1457 导航电脑"
	desc = "EAS(H)-1457 的导航控制台。"
	shuttleId = "solfed_medical_shuttle"
	shuttlePortId = "solfed_medical_shuttle_custom"

/obj/item/circuitboard/computer/solfed/medical
	name = "EAS(H)-1457 控制台（电脑主板）"
	build_path = /obj/machinery/computer/shuttle/solfed/medical

/obj/item/gps/computer/space/solfed/medical
	gpstag = "*SF - EAS(H)-1457"
/*----- End of SOLFED HOSPITAL VESSEL Shuttle Code -----*/

/*----- SOLFED HOSPITAL ASSAULT Shuttle Code -----*/
/datum/map_template/shuttle/ert/solfed/assault
	prefix = "_maps/shuttles/nova/"
	suffix = "solfed_assault_shuttle"
	name = "EAS(L)-9921 突击运输穿梭机"

/obj/machinery/computer/shuttle/solfed/assault
	name = "\improper EAS(L)-9921 控制台"
	desc = "用于控制 EAS(L)-9921。"
	circuit = /obj/item/circuitboard/computer/solfed/assault
	shuttleId = "solfed_assault_shuttle"
	possible_destinations = "solfed_assault_shuttle_custom;whiteship_home"

/obj/machinery/computer/camera_advanced/shuttle_docker/solfed/assault
	name = "\improper EAS(L)-9921 导航计算机"
	desc = "EAS(L)-9921 的导航控制台。"
	shuttleId = "solfed_assault_shuttle"
	shuttlePortId = "solfed_assault_shuttle_custom"

/obj/item/circuitboard/computer/solfed/assault
	name = "EAS(L)-9921 控制台（计算机主板）"
	build_path = /obj/machinery/computer/shuttle/solfed/assault

/obj/item/gps/computer/space/solfed/assault
	gpstag = "*SF - EAS(L)-9921"
/*----- End of SOLFED ASSAULT VESSEL Shuttle Code -----*/

/*----- SOLFED OFFICIALS VESSEL Shuttle Code -----*/
/datum/map_template/shuttle/ert/solfed/official
	prefix = "_maps/shuttles/nova/"
	suffix = "solfed_official_shuttle"
	name = "SFTS-3329 运输穿梭机"

/obj/machinery/computer/shuttle/solfed/official
	name = "\improper SFTS-3329 控制台"
	desc = "用于控制 SFTS-3329。"
	circuit = /obj/item/circuitboard/computer/solfed/official
	shuttleId = "solfed_official_shuttle"
	possible_destinations = "solfed_official_custom;whiteship_home"

/obj/machinery/computer/camera_advanced/shuttle_docker/solfed/official
	name = "\improper SFTS-3329 导航计算机"
	desc = "SFTS-3329 的导航控制台。"
	shuttleId = "solfed_official_shuttle"
	shuttlePortId = "solfed_official_custom"

/obj/item/circuitboard/computer/solfed/official
	name = "SFTS-3329 控制台（计算机主板）"
	build_path = /obj/machinery/computer/shuttle/solfed/official

/obj/item/gps/computer/space/solfed/official
	gpstag = "*SF - SFTS-3329"
/*----- End of OFFICIALS HOSPITAL VESSEL Shuttle Code -----*/

/*----- SOLFED FANCY VESSEL Shuttle Code -----*/
/datum/map_template/shuttle/ert/solfed/fancy
	prefix = "_maps/shuttles/nova/"
	suffix = "solfed_fancy_shuttle"
	name = "SFTS-1221 运输穿梭机。"

/obj/machinery/computer/shuttle/solfed/fancy
	name = "\improper SFTS-1221 控制台"
	desc = "用于控制 SFTS-1221。"
	circuit = /obj/item/circuitboard/computer/solfed/fancy
	shuttleId = "solfed_fancy_shuttle"
	possible_destinations = "solfed_fancy_shuttle_custom;whiteship_home"

/obj/machinery/computer/camera_advanced/shuttle_docker/solfed/fancy
	name = "\improper SFTS-1221 导航计算机"
	desc = "SFTS-1221 的导航控制台。"
	shuttleId = "solfed_fancy_shuttle"
	shuttlePortId = "solfed_fancy_shuttle_custom"

/obj/item/circuitboard/computer/solfed/fancy
	name = "SFTS-1221 控制台（计算机主板）"
	build_path = /obj/machinery/computer/shuttle/solfed/fancy

/obj/item/gps/computer/space/solfed/fancy
	gpstag = "*SF - SFTS-1221"
/*----- End of FANCY VESSEL Shuttle Code -----*/

/*----- SOLFED ENGINEERING VESSEL Shuttle Code -----*/
/datum/map_template/shuttle/ert/solfed/engineer
	prefix = "_maps/shuttles/nova/"
	suffix = "solfed_engineer_shuttle"
	name = "EAS(E)-3921 运输穿梭机。"

/obj/machinery/computer/shuttle/solfed/engineer
	name = "\improper EAS(E)-3921 控制台"
	desc = "用于控制EAS(E)-3921"
	circuit = /obj/item/circuitboard/computer/solfed/engineer
	shuttleId = "solfed_engineer_shuttle"
	possible_destinations = "solfed_engineer_shuttle_custom;whiteship_home"

/obj/machinery/computer/camera_advanced/shuttle_docker/solfed/engineer
	name = "\improper EAS(E)-3921导航计算机"
	desc = "EAS(E)-3921的导航控制台。"
	shuttleId = "solfed_engineer_shuttle"
	shuttlePortId = "solfed_engineer_shuttle_custom"

/obj/item/circuitboard/computer/solfed/engineer
	name = "EAS(E)-3921驾驶员控制台（电脑主板）"
	build_path = /obj/machinery/computer/shuttle/solfed/engineer

/obj/item/gps/computer/space/solfed/engineer
	gpstag = "*SF - EAS(E)-3921"
/*----- End of ENGINEERING VESSEL Shuttle Code -----*/
