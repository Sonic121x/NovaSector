/datum/bounty/item/ds2_engie/emitter
	name = "发射器"
	description = "赛博阳光公司想要一个发射器，用来制造反舰炮。他们发誓这玩意儿会比听起来更酷。"
	reward = CARGO_CRATE_VALUE * 5
	wanted_types = list(/obj/machinery/power/emitter = TRUE)

/datum/bounty/item/ds2_engie/hydro_tray
	name = "水培托盘"
	description = "DS-11的水培托盘出了点事故。介意送个新的过来吗？"
	reward = CARGO_CRATE_VALUE * 4
	wanted_types = list(/obj/machinery/hydroponics/constructable = TRUE)

/datum/bounty/item/ds2_engie/cyborg_charger
	name = "充能站"
	description = "9号集结区的一台充电站出了事故，他们需要送一台新的过去。"
	reward = CARGO_CRATE_VALUE * 5
	wanted_types = list(/obj/machinery/recharge_station = TRUE)

/datum/bounty/item/ds2_engie/smes_unit
	name = "电力储存单元"
	description = "我们需要储存更多电力。给我们弄一台SMES单元。"
	reward = CARGO_CRATE_VALUE * 6
	wanted_types = list(/obj/machinery/power/smes = TRUE)

/datum/bounty/item/ds2_engie/pacman
	name = "P.A.C.M.A.N.发电机"
	description = "我们的备用发电机保险丝烧断了，急需一台新的P.A.C.M.A.N.。"
	reward = CARGO_CRATE_VALUE * 5
	wanted_types = list(/obj/machinery/power/port_gen/pacman = TRUE)

/datum/bounty/item/ds2_engie/field_gen
	name = "力场发生器"
	description = "我们的一台防护力场发生器的保修期已过，需要一台新的来替换它。"
	reward = CARGO_CRATE_VALUE * 6
	wanted_types = list(/obj/machinery/field/generator = TRUE)

/datum/bounty/item/ds2_engie/tesla_coil
	name = "特斯拉线圈"
	description = "我们的电费太高了，给我们弄个特斯拉线圈来抵消一下。"
	reward = CARGO_CRATE_VALUE * 5
	wanted_types = list(/obj/machinery/power/energy_accumulator/tesla_coil = TRUE)

/datum/bounty/item/ds2_engie/reflector
	name = "反射器"
	description = "我们想让发射器走更长的路线，给我们弄个反射器来实现这个。"
	reward = CARGO_CRATE_VALUE * 7
	wanted_types = list(/obj/structure/reflector = TRUE)

/datum/bounty/item/ds2_engie/communications
	name = "通讯控制台"
	description = "我们这里的通讯阵列丢了，给我们发一个新的预制通讯控制台。"
	reward = CARGO_CRATE_VALUE * 10
	wanted_types = list(/obj/machinery/computer/communications = TRUE)

