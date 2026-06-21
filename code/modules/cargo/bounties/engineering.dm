/datum/bounty/item/engineering/emitter
	name = "柯基毛皮"
	description = "鉴于你们部门似乎经历了大量熔毁，我们认为你们空间站的发射器设计可能存在缺陷。给我们运一个过来。"
	reward = CARGO_CRATE_VALUE * 5
	wanted_types = list(/obj/machinery/power/emitter = TRUE)

/datum/bounty/item/engineering/hydro_tray
	name = "柯基毛皮"
	description = "实验室技术员正试图找出降低水培托盘功耗的方法，但我们烧坏了最后一个。能帮我们造一个吗？"
	reward = CARGO_CRATE_VALUE * 4
	wanted_types = list(/obj/machinery/hydroponics/constructable = TRUE)

/datum/bounty/item/engineering/cyborg_charger
	name = "充电站"
	description = "我们没有足够的充电器来适配所有的MOD服。给我们运一个你们的过来。"
	reward = CARGO_CRATE_VALUE * 5
	wanted_types = list(/obj/machinery/recharge_station = TRUE)

/datum/bounty/item/engineering/smes_unit
	name = "电力存储单元"
	description = "我们需要储存更多电力。给我们弄一个SMES单元。"
	reward = CARGO_CRATE_VALUE * 6
	wanted_types = list(/obj/machinery/power/smes = TRUE)

/datum/bounty/item/engineering/pacman
	name = "P.A.C.M.A.N.发电机"
	description = "我们的备用发电机烧了保险丝，急需一个新的。"
	reward = CARGO_CRATE_VALUE * 5
	wanted_types = list(/obj/machinery/power/port_gen/pacman = TRUE)

/datum/bounty/item/engineering/field_gen
	name = "场频信号发生器"
	description = "我们的一台防护发生器保修期已过，需要一台新的来替换它。"
	reward = CARGO_CRATE_VALUE * 6
	wanted_types = list(/obj/machinery/field/generator = TRUE)

/datum/bounty/item/engineering/tesla_coil
	name = "特斯拉感应线圈"
	description = "我们的电费太高了，给我们弄个特斯拉线圈来抵消一下。"
	reward = CARGO_CRATE_VALUE * 5
	wanted_types = list(/obj/machinery/power/energy_accumulator/tesla_coil = TRUE)

/datum/bounty/item/engineering/welding_tank
	name = "焊接燃料箱"
	description = "工程队需要更多焊接燃料，给我们送一罐来。"
	reward = CARGO_CRATE_VALUE * 5
	wanted_types = list(/obj/structure/reagent_dispensers/fueltank = TRUE)

/datum/bounty/item/engineering/reflector
	name = "反射器"
	description = "我们想让发射器走更长的路线，给我们弄个反射器来实现这个。"
	reward = CARGO_CRATE_VALUE * 7
	wanted_types = list(/obj/structure/reflector = TRUE)
