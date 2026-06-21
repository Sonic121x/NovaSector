/datum/crafting_recipe/pipe
	name = "智能管道配件"
	tool_behaviors = list(TOOL_WRENCH)
	result = /obj/item/pipe/quaternary/pipe/crafted
	reqs = list(/obj/item/stack/sheet/iron = 1)
	time = 0.5 SECONDS
	category = CAT_ATMOSPHERIC

/datum/crafting_recipe/igniter
	name = "点火器"
	result = /obj/machinery/igniter
	reqs = list(
		/obj/item/stack/sheet/iron = 5,
		/obj/item/assembly/igniter = 1,
	)
	blacklist = list(/obj/item/assembly/igniter/condenser)
	crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF
	time = 2 SECONDS
	category = CAT_ATMOSPHERIC

/datum/crafting_recipe/air_sensor
	name = "监控式空气传感器"
	result = /obj/item/air_sensor
	reqs = list(
		/obj/item/analyzer = 1,
		/obj/item/stack/sheet/iron = 1,
		)
	blacklist = list(/obj/item/analyzer/ranged)
	category = CAT_ATMOSPHERIC

/datum/crafting_recipe/portable_wind_turbine
	name = "便携式风力涡轮机"
	result = /obj/item/portable_wind_turbine
	tool_behaviors = list(TOOL_WELDER)
	reqs = list(
		/obj/item/knife/kitchen = 3,
		/obj/item/stack/sheet/plastic = 5,
		/obj/item/stack/rods = 8,
		/obj/item/stock_parts/servo = 2,
		/obj/item/stack/cable_coil = 5,
		)
	category = CAT_ATMOSPHERIC

///abstract path for pipe crafting recipes that set the pipe_type of their results and have other checks as well
/datum/crafting_recipe/spec_pipe
	var/pipe_type

/datum/crafting_recipe/spec_pipe/check_requirements(mob/user, list/collected_requirements)
	var/obj/item/pipe/required_pipe = collected_requirements[/obj/item/pipe][1]
	if(ispath(required_pipe.pipe_type, /obj/machinery/atmospherics/pipe/smart))
		return TRUE
	return FALSE

/datum/crafting_recipe/spec_pipe/layer_adapter
	name = "层流管汇接头"
	tool_behaviors = list(TOOL_WRENCH, TOOL_WELDER)
	result = /obj/item/pipe/binary/layer_adapter
	reqs = list(
		/obj/item/pipe = 1,
		/obj/item/stack/sheet/iron = 1,
	)
	time = 1 SECONDS
	category = CAT_ATMOSPHERIC
	pipe_type = /obj/machinery/atmospherics/pipe/layer_manifold

/datum/crafting_recipe/spec_pipe/color_adapter
	name = "颜色适配接头"
	tool_behaviors = list(TOOL_WRENCH, TOOL_WELDER)
	result = /obj/item/pipe/binary/color_adapter
	reqs = list(
		/obj/item/pipe = 1,
		/obj/item/stack/sheet/iron = 1,
	)
	time = 1 SECONDS
	category = CAT_ATMOSPHERIC
	pipe_type = /obj/machinery/atmospherics/pipe/color_adapter

/datum/crafting_recipe/spec_pipe/he_pipe
	name = "热交换管道接头"
	tool_behaviors = list(TOOL_WRENCH, TOOL_WELDER)
	result = /obj/item/pipe/quaternary/he_pipe
	reqs = list(
		/obj/item/pipe = 1,
		/obj/item/stack/sheet/iron = 1,
	)
	time = 1 SECONDS
	category = CAT_ATMOSPHERIC
	pipe_type = /obj/machinery/atmospherics/pipe/heat_exchanging/manifold4w

/datum/crafting_recipe/spec_pipe/he_junction
	name = "热交换三通接头"
	tool_behaviors = list(TOOL_WRENCH, TOOL_WELDER)
	result = /obj/item/pipe/directional/he_junction
	reqs = list(
		/obj/item/pipe = 1,
		/obj/item/stack/sheet/iron = 1,
	)
	time = 1 SECONDS
	category = CAT_ATMOSPHERIC
	pipe_type = /obj/machinery/atmospherics/pipe/heat_exchanging/junction

/datum/crafting_recipe/spec_pipe/pressure_pump
	name = "压力泵接头"
	tool_behaviors = list(TOOL_WRENCH, TOOL_WELDER)
	result = /obj/item/pipe/binary/pressure_pump
	reqs = list(
		/obj/item/pipe = 1,
		/obj/item/stack/sheet/iron = 5,
		/obj/item/stack/cable_coil = 5,
	)
	time = 2 SECONDS
	category = CAT_ATMOSPHERIC
	pipe_type = /obj/machinery/atmospherics/components/binary/pump

/datum/crafting_recipe/spec_pipe/manual_valve
	name = "手动阀门接头"
	tool_behaviors = list(TOOL_WRENCH, TOOL_WELDER)
	result = /obj/item/pipe/binary/manual_valve
	reqs = list(
		/obj/item/pipe = 1,
		/obj/item/stack/sheet/iron = 1,
	)
	time = 2 SECONDS
	category = CAT_ATMOSPHERIC
	pipe_type = /obj/machinery/atmospherics/components/binary/valve

/datum/crafting_recipe/spec_pipe/vent
	name = "通风泵接头"
	tool_behaviors = list(TOOL_WRENCH, TOOL_WELDER)
	result = /obj/item/pipe/directional/vent
	reqs = list(
		/obj/item/pipe = 1,
		/obj/item/stack/sheet/iron = 5,
		/obj/item/stack/cable_coil = 5,
	)
	time = 2 SECONDS
	category = CAT_ATMOSPHERIC
	pipe_type = /obj/machinery/atmospherics/components/unary/vent_pump

/datum/crafting_recipe/spec_pipe/scrubber
	name = "洗涤器接头"
	tool_behaviors = list(TOOL_WRENCH, TOOL_WELDER)
	result = /obj/item/pipe/directional/scrubber
	reqs = list(
		/obj/item/pipe = 1,
		/obj/item/stack/sheet/iron = 5,
		/obj/item/stack/cable_coil = 5,
	)
	time = 2 SECONDS
	category = CAT_ATMOSPHERIC
	pipe_type = /obj/machinery/atmospherics/components/unary/vent_scrubber

/datum/crafting_recipe/spec_pipe/filter
	name = "过滤器接头"
	tool_behaviors = list(TOOL_WRENCH, TOOL_WELDER)
	result = /obj/item/pipe/trinary/flippable/filter
	reqs = list(
		/obj/item/pipe = 1,
		/obj/item/stack/sheet/iron = 5,
		/obj/item/stack/cable_coil = 5,
	)
	time = 2 SECONDS
	category = CAT_ATMOSPHERIC
	pipe_type = /obj/machinery/atmospherics/components/trinary/filter

/datum/crafting_recipe/spec_pipe/mixer
	name = "混合器接头"
	tool_behaviors = list(TOOL_WRENCH, TOOL_WELDER)
	result = /obj/item/pipe/trinary/flippable/mixer
	reqs = list(
		/obj/item/pipe = 1,
		/obj/item/stack/sheet/iron = 5,
		/obj/item/stack/cable_coil = 5,
	)
	time = 2 SECONDS
	category = CAT_ATMOSPHERIC
	pipe_type = /obj/machinery/atmospherics/components/trinary/mixer

/datum/crafting_recipe/spec_pipe/connector
	name = "便携式连接器接头"
	tool_behaviors = list(TOOL_WRENCH, TOOL_WELDER)
	result = /obj/item/pipe/directional/connector
	reqs = list(
		/obj/item/pipe = 1,
		/obj/item/stack/sheet/iron = 1,
	)
	time = 2 SECONDS
	category = CAT_ATMOSPHERIC
	pipe_type = /obj/machinery/atmospherics/components/unary/portables_connector

/datum/crafting_recipe/spec_pipe/passive_vent
	name = "被动通风口接头"
	tool_behaviors = list(TOOL_WRENCH, TOOL_WELDER)
	result = /obj/item/pipe/directional/passive_vent
	reqs = list(
		/obj/item/pipe = 1,
		/obj/item/stack/sheet/iron = 1,
	)
	time = 2 SECONDS
	category = CAT_ATMOSPHERIC
	pipe_type = /obj/machinery/atmospherics/components/unary/passive_vent

/datum/crafting_recipe/spec_pipe/injector
	name = "出口喷射器接头"
	tool_behaviors = list(TOOL_WRENCH, TOOL_WELDER)
	result = /obj/item/pipe/directional/injector
	reqs = list(
		/obj/item/pipe = 1,
		/obj/item/stack/sheet/iron = 1,
		/obj/item/stack/cable_coil = 5,
	)
	time = 2 SECONDS
	category = CAT_ATMOSPHERIC
	pipe_type = /obj/machinery/atmospherics/components/unary/outlet_injector

/datum/crafting_recipe/spec_pipe/he_exchanger
	name = "热交换器接头"
	tool_behaviors = list(TOOL_WRENCH, TOOL_WELDER)
	result = /obj/item/pipe/directional/he_exchanger
	reqs = list(
		/obj/item/pipe = 1,
		/obj/item/stack/sheet/plasteel = 1,
	)
	time = 2 SECONDS
	category = CAT_ATMOSPHERIC
	pipe_type = /obj/machinery/atmospherics/components/unary/heat_exchanger

/datum/crafting_recipe/steam_vent
	name = "蒸汽通风口"
	result = /obj/structure/steam_vent
	time = 0.8 SECONDS
	reqs = list(
		/obj/item/stack/sheet/iron = 2,
		/obj/item/stack/tile/iron = 1,
		/obj/item/stock_parts/water_recycler = 1,
	)
	category = CAT_ATMOSPHERIC

/datum/crafting_recipe/spec_pipe/airlock_pump
	name = "外部气闸泵"
	tool_behaviors = list(TOOL_WRENCH, TOOL_WELDER)
	result = /obj/item/pipe/directional/airlock_pump
	reqs = list(
		/obj/item/pipe = 1,
		/obj/item/stack/sheet/iron = 5,
		/obj/item/stack/cable_coil = 5,
		/obj/item/analyzer = 1,
	)
	time = 2 SECONDS
	category = CAT_ATMOSPHERIC
	pipe_type = /obj/machinery/atmospherics/components/unary/airlock_pump
