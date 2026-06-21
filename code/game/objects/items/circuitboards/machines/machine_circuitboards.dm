//Command

/obj/item/circuitboard/machine/bsa/back
	name = "蓝空炮生成器"
	greyscale_colors = CIRCUIT_COLOR_COMMAND
	build_path = /obj/machinery/bsa/back //No freebies!
	specific_parts = TRUE
	req_components = list(
		/datum/stock_part/capacitor/tier4 = 5,
		/obj/item/stack/cable_coil = 2)

/obj/item/circuitboard/machine/bsa/front
	name = "蓝空炮钻头"
	greyscale_colors = CIRCUIT_COLOR_COMMAND
	build_path = /obj/machinery/bsa/front
	specific_parts = TRUE
	req_components = list(
		/datum/stock_part/servo/tier4 = 5,
		/obj/item/stack/cable_coil = 2)

/obj/item/circuitboard/machine/bsa/middle
	name = "蓝空炮聚变器"
	greyscale_colors = CIRCUIT_COLOR_COMMAND
	build_path = /obj/machinery/bsa/middle
	req_components = list(
		/obj/item/stack/ore/bluespace_crystal = 20,
		/obj/item/stack/cable_coil = 2)

/obj/item/circuitboard/machine/dna_vault
	name = "DNA 保险库"
	greyscale_colors = CIRCUIT_COLOR_COMMAND
	build_path = /obj/machinery/dna_vault //No freebies!
	specific_parts = TRUE
	req_components = list(
		/datum/stock_part/capacitor/tier3 = 5,
		/datum/stock_part/servo/tier3 = 5,
		/obj/item/stack/cable_coil = 2)

/obj/item/circuitboard/machine/dna_vault/completion_requirements(obj/structure/frame/install_frame, mob/living/user)
	var/turf/center = get_turf(install_frame)
	var/blocked = FALSE
	for(var/turf/potential_turf as anything in CORNER_BLOCK_OFFSET(center, 3, 3, -1, -2))
		if(potential_turf.density)
			new /obj/effect/temp_visual/point(potential_turf)
			blocked = TRUE
	if(blocked)
		balloon_alert_to_viewers("no room! (3x3)")
		return FALSE
	return TRUE

//Engineering

/obj/item/circuitboard/machine/announcement_system
	name = "公告系统"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/announcement_system
	req_components = list(
		/obj/item/stack/cable_coil = 2,
		/obj/item/stack/sheet/glass = 1)

/obj/item/circuitboard/machine/suit_storage_unit
	name = "防护服存储单元"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/suit_storage_unit
	req_components = list(
		/obj/item/stack/sheet/glass = 2,
		/obj/item/stack/cable_coil = 5,
		/datum/stock_part/capacitor = 1,
		/obj/item/electronics/airlock = 1)

/obj/item/circuitboard/machine/mass_driver
	name = "质量驱动器"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/mass_driver
	req_components = list(
		/datum/stock_part/servo = 1,)

/obj/item/circuitboard/machine/autolathe
	name = "自动制造机"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/autolathe
	req_components = list(
		/datum/stock_part/matter_bin = 3,
		/datum/stock_part/servo = 1,
		/obj/item/stack/sheet/glass = 1)

/obj/item/circuitboard/machine/grounding_rod
	name = "接地棒"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/power/energy_accumulator/grounding_rod
	req_components = list(/datum/stock_part/capacitor = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/telecomms/broadcaster
	name = "子空间广播器"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/telecomms/broadcaster
	req_components = list(
		/datum/stock_part/servo = 2,
		/obj/item/stack/cable_coil = 1,
		/datum/stock_part/filter = 1,
		/datum/stock_part/crystal = 1,
		/datum/stock_part/micro_laser = 2,
	)

/obj/item/circuitboard/machine/telecomms/bus
	name = "总线主机"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/telecomms/bus
	req_components = list(
		/datum/stock_part/servo = 2,
		/obj/item/stack/cable_coil = 1,
		/datum/stock_part/filter = 1,
	)

/obj/item/circuitboard/machine/telecomms/hub
	name = "集线器主机"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/telecomms/hub
	req_components = list(
		/datum/stock_part/servo = 2,
		/obj/item/stack/cable_coil = 2,
		/datum/stock_part/filter = 2,
	)

/obj/item/circuitboard/machine/telecomms/message_server
	name = "消息服务器"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/telecomms/message_server
	req_components = list(
		/datum/stock_part/servo = 2,
		/obj/item/stack/cable_coil = 1,
		/datum/stock_part/filter = 3,
	)

/obj/item/circuitboard/machine/telecomms/processor
	name = "处理器单元"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/telecomms/processor
	req_components = list(
		/datum/stock_part/servo = 3,
		/datum/stock_part/filter = 1,
		/datum/stock_part/treatment = 2,
		/datum/stock_part/analyzer = 1,
		/obj/item/stack/cable_coil = 2,
		/datum/stock_part/amplifier = 1,
	)

/obj/item/circuitboard/machine/telecomms/receiver
	name = "子空间接收器"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/telecomms/receiver
	req_components = list(
		/datum/stock_part/ansible = 1,
		/datum/stock_part/filter = 1,
		/datum/stock_part/servo = 2,
		/datum/stock_part/micro_laser = 1,
	)

/obj/item/circuitboard/machine/telecomms/relay
	name = "中继主机"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/telecomms/relay
	req_components = list(
		/datum/stock_part/servo = 2,
		/obj/item/stack/cable_coil = 2,
		/datum/stock_part/filter = 2,
	)

/obj/item/circuitboard/machine/telecomms/server
	name = "电信服务器"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/telecomms/server
	req_components = list(
		/datum/stock_part/servo = 2,
		/obj/item/stack/cable_coil = 1,
		/datum/stock_part/filter = 1,
	)

/obj/item/circuitboard/machine/tesla_coil
	name = "特斯拉控制器"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	desc = "并不能让你从手中射出闪电。"
	build_path = /obj/machinery/power/energy_accumulator/tesla_coil
	req_components = list(/datum/stock_part/capacitor = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/modular_shield_generator/gate
	name = "模块化护盾闸门"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/modular_shield_generator/gate
	req_components = list(
		/datum/stock_part/servo = 1,
		/datum/stock_part/micro_laser = 1,
		/datum/stock_part/capacitor = 1,
		/obj/item/stack/sheet/plasteel = 2,
	)

/obj/item/circuitboard/machine/modular_shield_generator
	name = "模块化护盾发生器"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/modular_shield_generator
	req_components = list(
		/datum/stock_part/servo = 1,
		/datum/stock_part/micro_laser = 1,
		/datum/stock_part/capacitor = 1,
		/obj/item/stack/sheet/plasteel = 3,
	)

/obj/item/circuitboard/machine/modular_shield_node
	name = "模块化护盾节点"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/modular_shield/module/node
	req_components = list(
		/obj/item/stack/cable_coil = 15,
		/obj/item/stack/sheet/plasteel = 2,
	)

/obj/item/circuitboard/machine/modular_shield_cable
	name = "模块化护盾电缆"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/modular_shield/module/node/cable
	req_components = list(
		/obj/item/stack/sheet/plasteel = 1,
	)

/obj/item/circuitboard/machine/modular_shield_well
	name = "模块化护盾井"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/modular_shield/module/well
	req_components = list(
		/datum/stock_part/capacitor = 3,
		/obj/item/stack/sheet/plasteel = 2,
	)

/obj/item/circuitboard/machine/modular_shield_relay
	name = "模块化护盾中继器"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/modular_shield/module/relay
	req_components = list(
		/datum/stock_part/micro_laser = 3,
		/obj/item/stack/sheet/plasteel = 2,
	)

/obj/item/circuitboard/machine/modular_shield_charger
	name = "模块化护盾充能器"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/modular_shield/module/charger
	req_components = list(
		/datum/stock_part/servo = 3,
		/obj/item/stack/sheet/plasteel = 2,
	)

/obj/item/circuitboard/machine/cell_charger
	name = "电池充电器"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/cell_charger
	req_components = list(/datum/stock_part/capacitor = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/circulator
	name = "循环器/热交换器"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/atmospherics/components/binary/circulator
	req_components = list()

/obj/item/circuitboard/machine/emitter
	name = "发射器"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/power/emitter
	req_components = list(
		/datum/stock_part/micro_laser = 1,
		/datum/stock_part/servo = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/thermoelectric_generator
	name = "热电发电机"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/power/thermoelectric_generator
	req_components = list()

/obj/item/circuitboard/machine/ntnet_relay
	name = "NTNet中继器"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/ntnet_relay
	req_components = list(
		/obj/item/stack/cable_coil = 2,
		/datum/stock_part/filter = 1,
	)

/obj/item/circuitboard/machine/pacman
	name = "PACMAN型发电机"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/power/port_gen/pacman
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/obj/item/stack/sheet/iron = 5
	)
	needs_anchored = FALSE
	var/high_production_profile = FALSE

/obj/item/circuitboard/machine/pacman/examine(mob/user)
	. = ..()
	var/message = high_production_profile ? "high-power uranium mode" : "medium-power plasma mode"
	. += span_notice("它被设置为[message]。")
	. += span_notice("你可以用螺丝刀在[src]上切换模式。")

/obj/item/circuitboard/machine/pacman/screwdriver_act(mob/living/user, obj/item/tool)
	high_production_profile = !high_production_profile
	var/message = high_production_profile ? "high-power uranium mode" : "medium-power plasma mode"
	to_chat(user, span_notice("你将电路板设置为[message]"))

/obj/item/circuitboard/machine/turbine_compressor
	name = "涡轮机 - 进气压缩机"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/power/turbine/inlet_compressor
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/obj/item/stack/sheet/iron = 5)

/obj/item/circuitboard/machine/turbine_rotor
	name = "涡轮机 - 核心转子"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/power/turbine/core_rotor
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/obj/item/stack/sheet/iron = 5)

/obj/item/circuitboard/machine/turbine_stator
	name = "涡轮机 - 涡轮出口"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/power/turbine/turbine_outlet
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/obj/item/stack/sheet/iron = 5)

/obj/item/circuitboard/machine/protolathe/department/engineering
	name = "部门原型机 - 工程部"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/rnd/production/protolathe/department/engineering

/obj/item/circuitboard/machine/rtg
	name = "RTG"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/power/rtg
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/datum/stock_part/capacitor = 1,
		/obj/item/stack/sheet/mineral/uranium = 10) // We have no Pu-238, and this is the closest thing to it.

/obj/item/circuitboard/machine/rtg/advanced
	name = "高级RTG"
	build_path = /obj/machinery/power/rtg/advanced
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/datum/stock_part/capacitor = 1,
		/datum/stock_part/micro_laser = 1,
		/obj/item/stack/sheet/mineral/uranium = 10,
		/obj/item/stack/sheet/mineral/plasma = 5)

/obj/item/circuitboard/machine/scanner_gate
	name = "扫描门"
	greyscale_colors = CIRCUIT_COLOR_SECURITY
	build_path = /obj/machinery/scanner_gate
	req_components = list(
		/datum/stock_part/scanning_module = 3)

/obj/item/circuitboard/machine/smes
	name = "SMES"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/power/smes
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/obj/item/stock_parts/power_store/battery = 5,
		/datum/stock_part/capacitor = 1)
	def_components = list(/obj/item/stock_parts/power_store/battery = /obj/item/stock_parts/power_store/battery/high/empty)

/obj/item/circuitboard/machine/smes/connector
	name = "电源连接器"
	build_path = /obj/machinery/power/smes/connector
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/datum/stock_part/capacitor = 1,)

/obj/item/circuitboard/machine/smesbank
	name = "便携式SMES"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	needs_anchored = FALSE
	build_path = /obj/machinery/smesbank
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/obj/item/stock_parts/power_store/battery = 5,)
	def_components = list(/obj/item/stock_parts/power_store/battery = /obj/item/stock_parts/power_store/battery/high/empty)

/obj/item/circuitboard/machine/techfab/department/engineering
	name = "\improper 部门技术制造机 - 工程部"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/rnd/production/techfab/department/engineering

/obj/item/circuitboard/machine/smes/super
	def_components = list(/obj/item/stock_parts/power_store/battery = /obj/item/stock_parts/power_store/battery/super/empty)

/obj/item/circuitboard/machine/smesbank/super
	def_components = list(/obj/item/stock_parts/power_store/battery = /obj/item/stock_parts/power_store/battery/super/empty)

/obj/item/circuitboard/machine/thermomachine
	name = "热力机"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/atmospherics/components/unary/thermomachine/freezer
	var/pipe_layer = PIPING_LAYER_DEFAULT
	req_components = list(
		/datum/stock_part/matter_bin = 2,
		/datum/stock_part/micro_laser = 2,
		/obj/item/stack/cable_coil = 1,
		/obj/item/stack/sheet/glass = 1)

/obj/item/circuitboard/machine/thermomachine/multitool_act(mob/living/user, obj/item/multitool/multitool)
	. = ..()
	pipe_layer = (pipe_layer >= PIPING_LAYER_MAX) ? PIPING_LAYER_MIN : (pipe_layer + 1)
	to_chat(user, span_notice("你将电路板设置为[pipe_layer]层。"))

/obj/item/circuitboard/machine/thermomachine/examine()
	. = ..()
	. += span_notice("它被设置为[pipe_layer]层。")

/obj/item/circuitboard/machine/HFR_fuel_input
	name = "HFR燃料输入"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/atmospherics/components/unary/hypertorus/fuel_input
	req_components = list(
		/obj/item/stack/sheet/plasteel = 5)

/obj/item/circuitboard/machine/HFR_waste_output
	name = "HFR废物输出"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/atmospherics/components/unary/hypertorus/waste_output
	req_components = list(
		/obj/item/stack/sheet/plasteel = 5)

/obj/item/circuitboard/machine/HFR_moderator_input
	name = "HFR慢化剂输入"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/atmospherics/components/unary/hypertorus/moderator_input
	req_components = list(
		/obj/item/stack/sheet/plasteel = 5)

/obj/item/circuitboard/machine/HFR_core
	name = "HFR核心"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/atmospherics/components/unary/hypertorus/core
	req_components = list(
		/obj/item/stack/cable_coil = 10,
		/obj/item/stack/sheet/glass = 10,
		/obj/item/stack/sheet/plasteel = 10)

/obj/item/circuitboard/machine/HFR_corner
	name = "HFR转角"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/hypertorus/corner
	req_components = list(
		/obj/item/stack/sheet/plasteel = 5)

/obj/item/circuitboard/machine/HFR_interface
	name = "HFR接口"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/hypertorus/interface
	req_components = list(
		/obj/item/stack/cable_coil = 10,
		/obj/item/stack/sheet/glass = 10,
		/obj/item/stack/sheet/plasteel = 5)

/obj/item/circuitboard/machine/crystallizer
	name = "结晶器"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/atmospherics/components/binary/crystallizer
	req_components = list(
		/obj/item/stack/cable_coil = 10,
		/obj/item/stack/sheet/glass = 10,
		/obj/item/stack/sheet/plasteel = 5)

//Generic
/obj/item/circuitboard/machine/component_printer
	name = "\improper 组件打印机"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/component_printer
	req_components = list(
		/datum/stock_part/matter_bin = 2,
		/datum/stock_part/servo = 2,
	)

/obj/item/circuitboard/machine/module_duplicator
	name = "\improper 模块复制器"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/module_duplicator
	req_components = list(
		/datum/stock_part/matter_bin = 2,
		/datum/stock_part/servo = 2,
	)

/obj/item/circuitboard/machine/circuit_imprinter
	name = "电路印刷机"
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	build_path = /obj/machinery/rnd/production/circuit_imprinter
	req_components = list(
		/datum/stock_part/matter_bin = 1,
		/datum/stock_part/servo = 1,
		)

/obj/item/circuitboard/machine/circuit_imprinter/offstation
	name = "古代电路印刷机"
	build_path = /obj/machinery/rnd/production/circuit_imprinter/offstation

/obj/item/circuitboard/machine/circuit_imprinter/department
	name = "部门电路印刷机"
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	build_path = /obj/machinery/rnd/production/circuit_imprinter/department

/obj/item/circuitboard/machine/holopad
	name = "AI全息台"
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	build_path = /obj/machinery/holopad
	req_components = list(/datum/stock_part/capacitor = 1)
	needs_anchored = FALSE //wew lad
	var/secure = FALSE

/obj/item/circuitboard/machine/holopad/multitool_act(mob/living/user, obj/item/tool)
	if(secure)
		build_path = /obj/machinery/holopad
		secure = FALSE
	else
		build_path = /obj/machinery/holopad/secure
		secure = TRUE
	to_chat(user, span_notice("你[secure? "en" : "dis"]禁用了[src]上的安保功能"))
	return TRUE

/obj/item/circuitboard/machine/holopad/examine(mob/user)
	. = ..()
	. += "There is a connection port on this board that could be <b>pulsed</b>"
	if(secure)
		. += "There is a red light flashing next to the word \"secure\""

/obj/item/circuitboard/machine/launchpad
	name = "蓝空发射台"
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	build_path = /obj/machinery/launchpad
	req_components = list(
		/obj/item/stack/ore/bluespace_crystal = 1,
		/datum/stock_part/servo = 1)
	def_components = list(/obj/item/stack/ore/bluespace_crystal = /obj/item/stack/ore/bluespace_crystal/artificial)

/obj/item/circuitboard/machine/protolathe
	name = "原型机"
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	build_path = /obj/machinery/rnd/production/protolathe
	req_components = list(
		/datum/stock_part/matter_bin = 2,
		/datum/stock_part/servo = 2,
		)

/obj/item/circuitboard/machine/protolathe/offstation
	name = "古代原型机"
	build_path = /obj/machinery/rnd/production/protolathe/offstation

/obj/item/circuitboard/machine/protolathe/department
	name = "部门原型机"
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	build_path = /obj/machinery/rnd/production/protolathe/department

/obj/item/circuitboard/machine/reagentgrinder
	name = "全能研磨机"
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	build_path = /obj/machinery/reagentgrinder
	req_components = list(
		/datum/stock_part/servo = 1,
		/datum/stock_part/matter_bin = 1,
	)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/smartfridge
	name = "智能冰箱"
	build_path = /obj/machinery/smartfridge
	req_components = list(/datum/stock_part/matter_bin = 1)
	var/static/list/fridges_name_paths = list(/obj/machinery/smartfridge = "plant produce",
		/obj/machinery/smartfridge/food = "food",
		/obj/machinery/smartfridge/drinks = "drinks",
		/obj/machinery/smartfridge/extract = "slimes",
		/obj/machinery/smartfridge/petri = "petri",
		/obj/machinery/smartfridge/organ = "organs",
		/obj/machinery/smartfridge/chemistry = "chems",
		/obj/machinery/smartfridge/chemistry/virology = "viruses",
		/obj/machinery/smartfridge/disks = "disks")
	needs_anchored = FALSE
	var/is_special_type = FALSE

/obj/item/circuitboard/machine/smartfridge/apply_default_parts(obj/machinery/smartfridge/smartfridge)
	build_path = smartfridge.base_build_path
	if(!fridges_name_paths.Find(build_path))
		name = "[initial(smartfridge.name)]" //if it's a unique type, give it a unique name.
		is_special_type = TRUE
	return ..()

/obj/item/circuitboard/machine/smartfridge/screwdriver_act(mob/living/user, obj/item/tool)
	if (is_special_type)
		return FALSE
	var/position = fridges_name_paths.Find(build_path, fridges_name_paths)
	position = (position == length(fridges_name_paths)) ? 1 : (position + 1)
	build_path = fridges_name_paths[position]
	to_chat(user, span_notice("你将电路板设置为[fridges_name_paths[build_path]]。"))
	return TRUE

/obj/item/circuitboard/machine/smartfridge/examine(mob/user)
	. = ..()
	if(is_special_type)
		return
	. += span_info("[src]被设置为[fridges_name_paths[build_path]]。你可以用螺丝刀重新配置它。")

/obj/item/circuitboard/machine/dehydrator
	name = "脱水机"
	build_path = /obj/machinery/smartfridge/drying
	req_components = list(/datum/stock_part/matter_bin = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/space_heater
	name = "太空加热器"
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	build_path = /obj/machinery/space_heater
	req_components = list(
		/datum/stock_part/micro_laser = 1,
		/datum/stock_part/capacitor = 1,
		/obj/item/stack/cable_coil = 3)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/electrolyzer
	name = "电解器"
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	build_path = /obj/machinery/electrolyzer
	req_components = list(
		/datum/stock_part/servo = 2,
		/datum/stock_part/capacitor = 2,
		/obj/item/stack/cable_coil = 5,
		/obj/item/stack/sheet/glass = 1)

	needs_anchored = FALSE


/obj/item/circuitboard/machine/techfab
	name = "\improper 科技制造机"
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	build_path = /obj/machinery/rnd/production/techfab
	req_components = list(
		/datum/stock_part/matter_bin = 2,
		/datum/stock_part/servo = 2,
		)

/obj/item/circuitboard/machine/techfab/department
	name = "\improper 部门技术制造台"
	build_path = /obj/machinery/rnd/production/techfab/department

/obj/item/circuitboard/machine/vendor
	name = "自定义售货机"
	desc = "你可以使用螺丝刀转动“品牌选择”旋钮。"
	custom_premium_price = PAYCHECK_CREW * 1.5
	build_path = /obj/machinery/vending/custom
	req_components = list(/obj/item/vending_refill/custom = 1)

	///Assoc list (machine name = machine typepath) of all vendors that can be chosen when the circuit is screwdrivered
	var/static/list/valid_vendor_names_paths

/obj/item/circuitboard/machine/vendor/Initialize(mapload)
	. = ..()
	if(!valid_vendor_names_paths)
		valid_vendor_names_paths = list()
		for(var/obj/machinery/vending/vendor_type as anything in subtypesof(/obj/machinery/vending))
			if(vendor_type::allow_custom && vendor_type::refill_canister)
				valid_vendor_names_paths[vendor_type::name] = vendor_type

/obj/item/circuitboard/machine/vendor/screwdriver_act(mob/living/user, obj/item/tool)
	. = ITEM_INTERACT_FAILURE
	if(all_products_free)
		return
	var/choice = tgui_input_list(user, "选择新品牌", "选择物品", sort_list(valid_vendor_names_paths))
	if(isnull(choice))
		return
	if(!user.can_perform_action(src, FORBID_TELEKINESIS_REACH))
		return
	set_type(valid_vendor_names_paths[choice])
	return ITEM_INTERACT_SUCCESS

/**
 * Sets circuitboard details based on the vending machine type to create
 *
 * Arguments
 * * obj/machinery/vending/typepath - the vending machine type to create
*/
/obj/item/circuitboard/machine/vendor/proc/set_type(obj/machinery/vending/typepath)
	build_path = typepath
	name = "[typepath::name] 售货机"
	req_components = list(initial(typepath.refill_canister) = 1)
	flatpack_components = list(initial(typepath.refill_canister))

/obj/item/circuitboard/machine/vendor/apply_default_parts(obj/machinery/machine)
	set_type(machine.type)
	return ..()

/obj/item/circuitboard/machine/bountypad
	name = "民用悬赏终端"
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	build_path = /obj/machinery/piratepad/civilian
	req_components = list(
		/datum/stock_part/card_reader = 1,
		/datum/stock_part/scanning_module = 1,
		/datum/stock_part/micro_laser = 1
	)

/obj/item/circuitboard/machine/fax
	name = "传真机"
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	build_path = /obj/machinery/fax
	req_components = list(
		/datum/stock_part/crystal = 1,
		/datum/stock_part/scanning_module = 1,
		/datum/stock_part/micro_laser = 1,
		/datum/stock_part/servo = 1,)

/obj/item/circuitboard/machine/bookbinder
	name = "书籍装订机"
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	build_path = /obj/machinery/bookbinder
	req_components = list(
		/datum/stock_part/servo = 1,
	)

/obj/item/circuitboard/machine/libraryscanner
	name = "书籍扫描仪"
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	build_path = /obj/machinery/libraryscanner
	req_components = list(
		/datum/stock_part/scanning_module = 1,
	)

/obj/item/circuitboard/machine/photocopier
	name = "复印机"
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	build_path = /obj/machinery/photocopier
	req_components = list(
		/datum/stock_part/scanning_module = 1,
		/datum/stock_part/micro_laser = 1,
		/datum/stock_part/matter_bin = 1
	)

//Medical

/obj/item/circuitboard/machine/chem_dispenser
	name = "化学分配器"
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/chem_dispenser
	req_components = list(
		/datum/stock_part/matter_bin = 2,
		/datum/stock_part/capacitor = 1,
		/datum/stock_part/servo = 1,
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stock_parts/power_store/cell = 1)
	def_components = list(/obj/item/stock_parts/power_store/cell = /obj/item/stock_parts/power_store/cell/high)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/chem_dispenser/fullupgrade
	build_path = /obj/machinery/chem_dispenser/fullupgrade
	specific_parts = TRUE
	req_components = list(
		/datum/stock_part/matter_bin/tier4 = 2,
		/datum/stock_part/capacitor/tier4 = 2,
		/datum/stock_part/servo/tier4 = 2,
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stock_parts/power_store/cell/bluespace = 1,
	)

/obj/item/circuitboard/machine/chem_dispenser/mutagensaltpeter
	build_path = /obj/machinery/chem_dispenser/mutagensaltpeter
	specific_parts = TRUE
	req_components = list(
		/datum/stock_part/matter_bin/tier4 = 2,
		/datum/stock_part/capacitor/tier4 = 2,
		/datum/stock_part/servo/tier4 = 2,
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stock_parts/power_store/cell/bluespace = 1,
	)

/obj/item/circuitboard/machine/chem_dispenser/abductor
	name = "试剂合成器"
	name_extension = "(Abductor Machine Board)"
	icon_state = "abductor_mod"
	build_path = /obj/machinery/chem_dispenser/abductor
	specific_parts = TRUE
	req_components = list(
		/datum/stock_part/matter_bin/tier4 = 2,
		/datum/stock_part/capacitor/tier4 = 2,
		/datum/stock_part/servo/tier4 = 2,
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stock_parts/power_store/cell/bluespace = 1,
	)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/chem_heater
	name = "化学加热器"
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/chem_heater
	req_components = list(
		/datum/stock_part/micro_laser = 1,
		/obj/item/stack/sheet/glass = 1)

/obj/item/circuitboard/machine/chem_mass_spec
	name = "高效液相色谱仪"
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/chem_mass_spec
	req_components = list(
	/datum/stock_part/micro_laser = 1,
	/obj/item/stack/cable_coil = 5)

/obj/item/circuitboard/machine/chem_master
	name = "ChemMaster 3000"
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/chem_master
	desc = "你可以使用螺丝刀转动“模式选择”旋钮。"
	req_components = list(
		/obj/item/reagent_containers/cup/beaker = 2,
		/datum/stock_part/servo = 1,
		/obj/item/stack/sheet/glass = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/chem_master/screwdriver_act(mob/living/user, obj/item/tool)
	var/new_name = "ChemMaster"
	var/new_path = /obj/machinery/chem_master

	if(build_path == /obj/machinery/chem_master)
		new_name = "CondiMaster"
		new_path = /obj/machinery/chem_master/condimaster

	build_path = new_path
	name = "[new_name] 3000"
	to_chat(user, span_notice("你将电路板设置更改为“[new_name]”。"))
	return TRUE

/obj/item/circuitboard/machine/cryo_tube
	name = "低温休眠舱"
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/cryo_cell
	req_components = list(
		/datum/stock_part/matter_bin = 1,
		/obj/item/stack/cable_coil = 1,
		/obj/item/stack/sheet/glass = 4)

/obj/item/circuitboard/machine/fat_sucker
	name = "脂质提取器"
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/fat_sucker
	req_components = list(/datum/stock_part/micro_laser = 1,
		/obj/item/kitchen/fork = 1)

/obj/item/circuitboard/machine/harvester
	name = "收割机"
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/harvester
	req_components = list(/datum/stock_part/micro_laser = 4)

/obj/item/circuitboard/machine/medical_kiosk
	name = "医疗自助终端"
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/medical_kiosk
	var/custom_cost = 10
	req_components = list(
		/obj/item/healthanalyzer = 1,
		/datum/stock_part/scanning_module = 1)

/obj/item/circuitboard/machine/medical_kiosk/multitool_act(mob/living/user)
	. = ..()
	var/new_cost = tgui_input_number(user, "使用此医疗自助终端的新费用", "定价", custom_cost, 1000, 10)
	if(!new_cost || QDELETED(user) || QDELETED(src) || !user.can_perform_action(src, FORBID_TELEKINESIS_REACH))
		return
	if(loc != user)
		to_chat(user, span_warning("你必须手持电路板才能更改其费用！"))
		return
	custom_cost = new_cost
	to_chat(user, span_notice("费用现已设置为[custom_cost]。"))

/obj/item/circuitboard/machine/medical_kiosk/examine(mob/user)
	. = ..()
	. += "The cost to use this kiosk is set to [custom_cost]."

/obj/item/circuitboard/machine/limbgrower
	name = "肢体生长器"
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/limbgrower
	req_components = list(
		/datum/stock_part/servo = 1,
		/obj/item/reagent_containers/cup/beaker = 2,
		/obj/item/stack/sheet/glass = 1)

/obj/item/circuitboard/machine/limbgrower/fullupgrade
	name = "肢体生长器"
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/limbgrower
	req_components = list(
		/datum/stock_part/servo/tier4  = 1,
		/obj/item/reagent_containers/cup/beaker/bluespace = 2,
		/obj/item/stack/sheet/glass = 1)

/obj/item/circuitboard/machine/protolathe/department/medical
	name = "部门原型机 - 医疗"
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/rnd/production/protolathe/department/medical

/obj/item/circuitboard/machine/sleeper
	name = "休眠舱"
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/sleeper
	req_components = list(
		/datum/stock_part/matter_bin = 1,
		/datum/stock_part/servo = 1,
		/obj/item/stack/cable_coil = 1,
		/obj/item/stack/sheet/glass = 2)

/obj/item/circuitboard/machine/sleeper/syndie
	build_path = /obj/machinery/sleeper/syndie

/obj/item/circuitboard/machine/sleeper/fullupgrade
	build_path = /obj/machinery/sleeper/syndie/fullupgrade
	req_components = list(
		/datum/stock_part/matter_bin/tier4 = 1,
		/datum/stock_part/servo/tier4 = 1,
		/obj/item/stack/cable_coil = 1,
		/obj/item/stack/sheet/glass = 2)

/obj/item/circuitboard/machine/sleeper/party
	name = "派对舱"
	build_path = /obj/machinery/sleeper/party

/obj/item/circuitboard/machine/smoke_machine
	name = "烟雾机"
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/smoke_machine
	req_components = list(
		/datum/stock_part/matter_bin = 2,
		/datum/stock_part/capacitor = 1,
		/datum/stock_part/servo = 1,
		/obj/item/stack/sheet/glass = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/stasis
	name = "\improper 生命体停滞装置"
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/stasis
	req_components = list(
		/obj/item/stack/cable_coil = 3,
		/datum/stock_part/servo = 1,
		/datum/stock_part/capacitor = 1)

/obj/item/circuitboard/machine/medipen_refiller
	name = "医疗笔补充器"
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/medipen_refiller
	req_components = list(
		/datum/stock_part/matter_bin = 1)

/obj/item/circuitboard/machine/techfab/department/medical
	name = "\improper 部门技术制造机 - 医疗"
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/rnd/production/techfab/department/medical

//Science

/obj/item/circuitboard/machine/circuit_imprinter/department/science
	name = "部门电路印刷机 - 科学"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/rnd/production/circuit_imprinter/department/science

/obj/item/circuitboard/machine/cyborgrecharger
	name = "机器人充电器"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/recharge_station
	req_components = list(
		/datum/stock_part/capacitor = 2,
		/obj/item/stock_parts/power_store/cell = 1,
		/datum/stock_part/servo = 1)
	def_components = list(/obj/item/stock_parts/power_store/cell = /obj/item/stock_parts/power_store/cell/high)

/obj/item/circuitboard/machine/destructive_analyzer
	name = "破坏性分析仪"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/rnd/destructive_analyzer
	req_components = list(
		/datum/stock_part/scanning_module = 1,
		/datum/stock_part/servo = 1,
		/datum/stock_part/micro_laser = 1,
	)

/obj/item/circuitboard/machine/experimentor
	name = "E.X.P.E.R.I-MENTOR"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/rnd/experimentor
	req_components = list(
		/datum/stock_part/scanning_module = 1,
		/datum/stock_part/servo = 2,
		/datum/stock_part/micro_laser = 2)

/obj/item/circuitboard/machine/mech_recharger
	name = "机甲泊位充电器"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/mech_bay_recharge_port
	req_components = list(
		/obj/item/stack/cable_coil = 2,
		/datum/stock_part/capacitor = 5)

/obj/item/circuitboard/machine/mechfab
	name = "外骨骼装配机"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/mecha_part_fabricator
	req_components = list(
		/datum/stock_part/matter_bin = 2,
		/datum/stock_part/servo = 1,
		/datum/stock_part/micro_laser = 1,
		/obj/item/stack/sheet/glass = 1)

/obj/item/circuitboard/machine/vatgrower
	name = "生长培养缸"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/vatgrower

/obj/item/circuitboard/machine/monkey_recycler
	name = "猴子回收器"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/monkey_recycler
	req_components = list(
		/datum/stock_part/matter_bin = 1,
		/datum/stock_part/servo = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/processor/slime
	name = "史莱姆处理器"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/processor/slime

/obj/item/circuitboard/machine/processor/slime/fullupgrade
	build_path = /obj/machinery/processor/slime/fullupgrade
	specific_parts = TRUE
	req_components = list(
		/datum/stock_part/matter_bin/tier4 = 1,
		/datum/stock_part/servo/tier4 = 1,
	)

/obj/item/circuitboard/machine/protolathe/department/science
	name = "部门原型机 - 科学部"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/rnd/production/protolathe/department/science

/obj/item/circuitboard/machine/quantumpad
	name = "量子传送板"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/quantumpad
	req_components = list(
		/obj/item/stack/ore/bluespace_crystal = 1,
		/datum/stock_part/capacitor = 1,
		/datum/stock_part/servo = 1,
		/obj/item/stack/cable_coil = 1)
	def_components = list(/obj/item/stack/ore/bluespace_crystal = /obj/item/stack/ore/bluespace_crystal/artificial)

/obj/item/circuitboard/machine/rdserver
	name = "研发服务器"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/rnd/server
	req_components = list(
		/obj/item/stack/cable_coil = 2,
		/datum/stock_part/scanning_module = 1,
	)

/obj/item/circuitboard/machine/rdserver/oldstation
	name = "远古研发服务器"
	build_path = /obj/machinery/rnd/server/oldstation

/obj/item/circuitboard/machine/techfab/department/science
	name = "\improper 部门技术制造机 - 科学部"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/rnd/production/techfab/department/science

/obj/item/circuitboard/machine/teleporter_hub
	name = "传送器枢纽"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/teleport/hub
	req_components = list(
		/obj/item/stack/ore/bluespace_crystal = 3,
		/datum/stock_part/matter_bin = 1)
	def_components = list(/obj/item/stack/ore/bluespace_crystal = /obj/item/stack/ore/bluespace_crystal/artificial)

/obj/item/circuitboard/machine/teleporter_station
	name = "传送器控制站"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/teleport/station
	req_components = list(
		/obj/item/stack/ore/bluespace_crystal = 2,
		/datum/stock_part/capacitor = 2,
		/obj/item/stack/sheet/glass = 1)
	def_components = list(/obj/item/stack/ore/bluespace_crystal = /obj/item/stack/ore/bluespace_crystal/artificial)

/obj/item/circuitboard/machine/dnascanner
	name = "DNA扫描仪"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/dna_scannernew
	req_components = list(
		/datum/stock_part/scanning_module = 1,
		/datum/stock_part/matter_bin = 1,
		/datum/stock_part/micro_laser = 1,
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stack/cable_coil = 2)

/obj/item/circuitboard/machine/dna_infuser
	name = "DNA注入器"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/dna_infuser
	req_components = list(
		/datum/stock_part/scanning_module = 1,
		/datum/stock_part/matter_bin = 1,
		/datum/stock_part/micro_laser = 1,
		/obj/item/stack/cable_coil = 2,
	)

/obj/item/circuitboard/machine/experimental_cloner_scanner
	name = "实验性克隆扫描仪"
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/experimental_cloner_scanner
	req_components = list(
		/datum/stock_part/scanning_module = 1,
		/datum/stock_part/matter_bin = 1,
		/datum/stock_part/micro_laser = 1,
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stack/cable_coil = 2
	)

/obj/item/circuitboard/machine/experimental_cloner
	name = "实验性克隆舱"
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/experimental_cloner
	req_components = list(
		/datum/stock_part/matter_bin = 1,
		/obj/item/stack/cable_coil = 1,
		/obj/item/stack/sheet/glass = 4
	)

/obj/item/circuitboard/machine/mechpad
	name = "机甲轨道发射台"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/mechpad
	req_components = list()

/obj/item/circuitboard/machine/botpad
	name = "机器人发射台"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/botpad
	req_components = list()

//Security

/obj/item/circuitboard/machine/protolathe/department/security
	name = "部门原型机 - 安保部"
	greyscale_colors = CIRCUIT_COLOR_SECURITY
	build_path = /obj/machinery/rnd/production/protolathe/department/security

/obj/item/circuitboard/machine/recharger
	name = "武器充能器"
	greyscale_colors = CIRCUIT_COLOR_SECURITY
	build_path = /obj/machinery/recharger
	req_components = list(/datum/stock_part/capacitor = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/techfab/department/security
	name = "\improper 部门技术制造机 - 安保部"
	greyscale_colors = CIRCUIT_COLOR_SECURITY
	build_path = /obj/machinery/rnd/production/techfab/department/security

//Service
/obj/item/circuitboard/machine/photobooth
	name = "照相亭"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/photobooth
	req_components = list(
		/datum/stock_part/matter_bin = 1,
		/datum/stock_part/servo = 1,
	)

/obj/item/circuitboard/machine/photobooth/security
	name = "安保照相亭"
	greyscale_colors = CIRCUIT_COLOR_SECURITY
	build_path = /obj/machinery/photobooth/security

/obj/item/circuitboard/machine/biogenerator
	name = "生物生成器"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/biogenerator
	req_components = list(
		/datum/stock_part/matter_bin = 1,
		/datum/stock_part/servo = 1,
		/obj/item/stack/cable_coil = 1,
		/obj/item/stack/sheet/glass = 1)

/obj/item/circuitboard/machine/chem_dispenser/drinks
	name = "苏打水分配器"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/chem_dispenser/drinks

/obj/item/circuitboard/machine/chem_dispenser/drinks/fullupgrade
	build_path = /obj/machinery/chem_dispenser/drinks/fullupgrade
	req_components = list(
		/datum/stock_part/matter_bin/tier4 = 2,
		/datum/stock_part/capacitor/tier4 = 2,
		/datum/stock_part/servo/tier4 = 2,
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stock_parts/power_store/cell/bluespace = 1,
	)

/obj/item/circuitboard/machine/chem_dispenser/drinks/beer
	name = "酒类分配器"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/chem_dispenser/drinks/beer

/obj/item/circuitboard/machine/chem_dispenser/drinks/beer/fullupgrade
	build_path = /obj/machinery/chem_dispenser/drinks/beer/fullupgrade
	req_components = list(
		/datum/stock_part/matter_bin/tier4 = 2,
		/datum/stock_part/capacitor/tier4 = 2,
		/datum/stock_part/servo/tier4 = 2,
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stock_parts/power_store/cell/bluespace = 1,
	)

/obj/item/circuitboard/machine/chem_master/condi
	name = "调味大师3000"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/chem_master/condimaster

/obj/item/circuitboard/machine/deep_fryer
	name = "油炸锅"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/deepfryer
	req_components = list(/datum/stock_part/micro_laser = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/griddle
	name = "烤盘"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/griddle
	req_components = list(/datum/stock_part/micro_laser = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/oven
	name = "烤箱"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/oven
	req_components = list(/datum/stock_part/micro_laser = 1)
	needs_anchored = TRUE

/obj/item/circuitboard/machine/stove
	name = "炉灶"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/stove
	req_components = list(/datum/stock_part/micro_laser = 1)
	needs_anchored = TRUE

/obj/item/circuitboard/machine/range
	name = "灶台（烤箱与炉灶）"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/oven/range
	req_components = list(/datum/stock_part/micro_laser = 2)
	needs_anchored = TRUE

/obj/item/circuitboard/machine/dish_drive
	name = "餐具驱动器"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/dish_drive
	req_components = list(
		/obj/item/stack/sheet/glass = 1,
		/datum/stock_part/servo = 1,
		/datum/stock_part/matter_bin = 2)
	var/suction = TRUE
	var/transmit = TRUE
	needs_anchored = FALSE

/obj/item/circuitboard/machine/dish_drive/examine(mob/user)
	. = ..()
	. += span_notice("其吸力功能为[suction ? "enabled" : "disabled"]。手持使用以切换。")
	. += span_notice("其垃圾自动传输功能为[transmit ? "enabled" : "disabled"]。Alt-点击以切换。")

/obj/item/circuitboard/machine/dish_drive/attack_self(mob/living/user)
	suction = !suction
	to_chat(user, span_notice("你[suction ? "enable" : "disable"]了电路板的吸力功能。"))

/obj/item/circuitboard/machine/dish_drive/click_alt(mob/living/user)
	transmit = !transmit
	to_chat(user, span_notice("你[transmit ? "enable" : "disable"]了电路板的自动垃圾传输功能。"))
	return CLICK_ACTION_SUCCESS

/obj/item/circuitboard/machine/gibber
	name = "绞肉机"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/gibber
	req_components = list(
		/datum/stock_part/matter_bin = 1,
		/datum/stock_part/servo = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/hydroponics
	name = "水培托盘"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/hydroponics/constructable
	req_components = list(
		/datum/stock_part/matter_bin = 2,
		/datum/stock_part/servo = 1,
		/obj/item/stack/sheet/glass = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/hydroponics/proc/changeindicators(mob/living/user, obj/item/I)
	if(build_path == /obj/machinery/hydroponics/constructable/oldstyle)
		name = "Hydroponics Tray [name_extension]"
		build_path = /obj/machinery/hydroponics/constructable
		balloon_alert(user, "defaulting indicator location")
	else
		name = "Hydroponics Tray (Alt) [name_extension]"
		build_path = /obj/machinery/hydroponics/constructable/oldstyle
		balloon_alert(user, "moved indicators location")

/obj/item/circuitboard/machine/hydroponics/item_interaction(mob/living/user, obj/item/I, list/modifiers)
	if(istype(I, /obj/item/plant_analyzer))
		changeindicators(user)
		return ITEM_INTERACT_SUCCESS
	return ..()

/obj/item/circuitboard/machine/hydroponics/screwdriver_act(mob/living/user, obj/item/tool)
	changeindicators(user)
	return ITEM_INTERACT_SUCCESS

/obj/item/circuitboard/machine/hydroponics/fullupgrade
	build_path = /obj/machinery/hydroponics/constructable/fullupgrade
	specific_parts = TRUE
	req_components = list(
		/datum/stock_part/matter_bin/tier4 = 2,
		/datum/stock_part/servo/tier4 = 1,
		/obj/item/stack/sheet/glass = 1
	)

/obj/item/circuitboard/machine/microwave
	name = "微波炉"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/microwave
	req_components = list(
		/datum/stock_part/micro_laser = 1,
		/datum/stock_part/matter_bin = 1,
		/datum/stock_part/capacitor = 1,
		/obj/item/stack/cable_coil = 2,
		/obj/item/stack/sheet/glass = 2)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/microwave/engineering
	name = "无线微波炉"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/microwave/engineering
	req_components = list(
		/datum/stock_part/micro_laser = 1,
		/datum/stock_part/matter_bin = 1,
		/datum/stock_part/capacitor/tier2 = 1,
		/obj/item/stack/cable_coil = 4,
		/obj/item/stack/sheet/glass = 2)

/obj/item/circuitboard/machine/processor
	name = "食物处理器"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/processor
	req_components = list(
		/datum/stock_part/matter_bin = 1,
		/datum/stock_part/servo = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/processor/screwdriver_act(mob/living/user, obj/item/tool)
	if(build_path == /obj/machinery/processor)
		name = "史莱姆处理器"
		build_path = /obj/machinery/processor/slime
		to_chat(user, span_notice("命名协议已成功更新。"))
	else
		name = "食物处理器"
		build_path = /obj/machinery/processor
		to_chat(user, span_notice("恢复默认命名协议。"))
	return TRUE

/obj/item/circuitboard/machine/protolathe/department/service
	name = "部门原型机 - 服务部"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/rnd/production/protolathe/department/service

/obj/item/circuitboard/machine/recycler
	name = "回收机"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/recycler
	req_components = list(
		/datum/stock_part/servo = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/seed_extractor
	name = "种子提取器"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/seed_extractor
	req_components = list(
		/datum/stock_part/matter_bin = 1,
		/datum/stock_part/servo = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/techfab/department/service
	name = "\improper 部门科技制造机 - 服务部"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/rnd/production/techfab/department/service

/obj/item/circuitboard/machine/fishing_portal_generator
	name = "钓鱼传送门生成器"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/fishing_portal_generator
	req_components = list(
		/datum/stock_part/matter_bin = 2,
		/datum/stock_part/capacitor = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/fishing_portal_generator/emagged
	name = "电磁干扰钓鱼传送门生成器"
	build_path = /obj/machinery/fishing_portal_generator/emagged

//Supply
/obj/item/circuitboard/machine/ore_redemption
	name = "矿石回收机"
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/mineral/ore_redemption
	req_components = list(
		/obj/item/stack/sheet/glass = 1,
		/datum/stock_part/matter_bin = 1,
		/datum/stock_part/micro_laser = 1,
		/datum/stock_part/servo = 1,
		/obj/item/assembly/igniter = 1)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/ore_redemption/offstation
	build_path = /obj/machinery/mineral/ore_redemption/offstation

/obj/item/circuitboard/machine/ore_silo
	name = "矿石筒仓"
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/ore_silo
	req_components = list()

/obj/item/circuitboard/machine/protolathe/department/cargo
	name = "部门原型机 - 货舱"
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/rnd/production/protolathe/department/cargo

/obj/item/circuitboard/machine/stacking_machine
	name = "堆叠机"
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/mineral/stacking_machine
	req_components = list(
		/datum/stock_part/servo = 2,
		/datum/stock_part/matter_bin = 2)

/obj/item/circuitboard/machine/stacking_unit_console
	name = "堆叠机控制台"
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/mineral/stacking_unit_console
	req_components = list(
		/obj/item/stack/sheet/glass = 2,
		/obj/item/stack/cable_coil = 5)

/obj/item/circuitboard/machine/techfab/department/cargo
	name = "\improper 部门技术制造机 - 货舱"
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/rnd/production/techfab/department/cargo

/obj/item/circuitboard/machine/materials_market
	name = "银河材料市场"
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/materials_market
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/datum/stock_part/scanning_module = 1,
		/datum/stock_part/card_reader = 1)

/obj/item/circuitboard/machine/mailsorter
	name = "邮件分拣机"
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/mailsorter
	req_components = list(
		/obj/item/stack/sheet/glass = 1,
		/datum/stock_part/matter_bin = 2,
		/datum/stock_part/scanning_module = 1)
	needs_anchored = TRUE

//Tram
/obj/item/circuitboard/machine/crossing_signal
	name = "道口信号机"
	build_path = /obj/machinery/transport/crossing_signal
	req_components = list(
		/datum/stock_part/micro_laser = 1,
	)

/obj/item/circuitboard/machine/guideway_sensor
	name = "导轨传感器"
	build_path = /obj/machinery/transport/guideway_sensor
	req_components = list(
		/obj/item/assembly/prox_sensor = 1,
	)

//Misc
/obj/item/circuitboard/machine/sheetifier
	name = "板材大师 2000"
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/sheetifier
	req_components = list(
		/datum/stock_part/servo = 2,
		/datum/stock_part/matter_bin = 2)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/restaurant_portal
	name = "餐厅传送门"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/restaurant_portal
	req_components = list(
		/datum/stock_part/scanning_module = 2,
		/obj/item/stack/sheet/glass = 1)
	needs_anchored = TRUE
	/// Type of the venue that we're linked to
	var/venue_type = /datum/venue/restaurant

/obj/item/circuitboard/machine/restaurant_portal/multitool_act(mob/living/user)
	var/list/radial_items = list()
	var/list/radial_results = list()

	for(var/type_key in SSrestaurant.all_venues)
		var/datum/venue/venue = SSrestaurant.all_venues[type_key]
		radial_items[venue.name] = image('icons/obj/machines/restaurant_portal.dmi', venue.name)
		radial_results[venue.name] = type_key

	var/choice = show_radial_menu(user, src, radial_items, null, require_near = TRUE)

	if(!choice)
		return ITEM_INTERACT_BLOCKING

	venue_type = radial_results[choice]
	to_chat(user, span_notice("你更改了[src]的关联场所。"))
	return ITEM_INTERACT_SUCCESS

/obj/item/circuitboard/machine/restaurant_portal/examine(mob/user)
	. = ..()
	if (venue_type)
		var/datum/venue/as_venue = venue_type
		. += span_notice("[src]关联至\a [initial(as_venue.name)]场所。")

/obj/item/circuitboard/machine/restaurant_portal/configure_machine(obj/machinery/restaurant_portal/machine)
	if(!istype(machine))
		CRASH("Cargo board attempted to configure incorrect machine type: [machine] ([machine?.type])")
	machine.linked_venue = SSrestaurant.all_venues[venue_type]
	machine.linked_venue.restaurant_portals += machine

/obj/item/circuitboard/machine/abductor
	name = "外星电路板（请报告此问题）"
	icon_state = "abductor_mod"

/obj/item/circuitboard/machine/abductor/core
	name = "外星电路板"
	name_extension = "(Void Core)"
	build_path = /obj/machinery/power/rtg/abductor
	req_components = list(
		/datum/stock_part/capacitor = 1,
		/datum/stock_part/micro_laser = 1,
		/obj/item/stock_parts/power_store/cell/infinite/abductor = 1)
	def_components = list(
		/datum/stock_part/capacitor = /datum/stock_part/capacitor/tier4,
		/datum/stock_part/micro_laser = /datum/stock_part/micro_laser/tier4)

/obj/item/circuitboard/machine/hypnochair
	name = "强化审讯室"
	greyscale_colors = CIRCUIT_COLOR_SECURITY
	build_path = /obj/machinery/hypnochair
	req_components = list(
		/datum/stock_part/micro_laser = 2,
		/datum/stock_part/scanning_module = 2
	)

/obj/item/circuitboard/machine/plumbing_receiver
	name = "化学接收器"
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/plumbing/receiver
	req_components = list(
		/obj/item/stack/ore/bluespace_crystal = 1,
		/datum/stock_part/capacitor = 2,
		/obj/item/stack/sheet/glass = 1)
	def_components = list(/obj/item/stack/ore/bluespace_crystal = /obj/item/stack/ore/bluespace_crystal/artificial)
	needs_anchored = FALSE

/obj/item/circuitboard/machine/skill_station
	name = "技能站"
	build_path = /obj/machinery/skill_station
	req_components = list(
		/datum/stock_part/matter_bin = 2,
		/datum/stock_part/micro_laser = 2,
		/datum/stock_part/scanning_module = 2
	)

/obj/item/circuitboard/machine/destructive_scanner
	name = "实验性破坏性扫描仪"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/destructive_scanner
	req_components = list(
		/datum/stock_part/micro_laser = 2,
		/datum/stock_part/matter_bin = 1,
		/datum/stock_part/servo = 2)

/obj/item/circuitboard/machine/doppler_array
	name = "超光速多普勒研究阵列"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/doppler_array
	req_components = list(
		/datum/stock_part/micro_laser = 2,
		/datum/stock_part/scanning_module = 4)

/obj/item/circuitboard/machine/exoscanner
	name = "外太空扫描仪"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/exoscanner
	req_components = list(
		/datum/stock_part/micro_laser = 4,
		/datum/stock_part/scanning_module = 4)

/obj/item/circuitboard/machine/exodrone_launcher
	name = "勘探无人机发射器"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/exodrone_launcher
	req_components = list(
		/datum/stock_part/micro_laser = 4,
		/datum/stock_part/scanning_module = 4)

/obj/item/circuitboard/machine/ecto_sniffer
	name = "灵体外窥嗅探器"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/ecto_sniffer
	req_components = list(
		/datum/stock_part/scanning_module = 1)

/obj/item/circuitboard/machine/anomaly_refinery
	name = "异常精炼厂"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/research/anomaly_refinery
	req_components = list(
		/obj/item/stack/sheet/plasteel = 15,
		/datum/stock_part/scanning_module = 1,
		/datum/stock_part/servo = 1,
		)

/obj/item/circuitboard/machine/tank_compressor
	name = "储罐压缩机"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/atmospherics/components/binary/tank_compressor
	req_components = list(
		/obj/item/stack/sheet/plasteel = 5,
		/datum/stock_part/scanning_module = 4,
		)

/obj/item/circuitboard/machine/coffeemaker
	name = "咖啡机"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/coffeemaker
	req_components = list(
		/obj/item/stack/sheet/glass = 1,
		/obj/item/reagent_containers/cup/beaker = 2,
		/datum/stock_part/water_recycler = 1,
		/datum/stock_part/capacitor = 1,
		/datum/stock_part/micro_laser = 1,
	)

/obj/item/circuitboard/machine/coffeemaker/impressa
	name = "Impressa咖啡机"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/coffeemaker/impressa
	req_components = list(
		/obj/item/stack/sheet/glass = 1,
		/obj/item/reagent_containers/cup/beaker = 2,
		/datum/stock_part/water_recycler = 1,
		/datum/stock_part/capacitor/tier2 = 1,
		/datum/stock_part/micro_laser/tier2 = 2,
	)

/obj/item/circuitboard/machine/navbeacon
	name = "机器人导航信标"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/navbeacon
	req_components = list()

/obj/item/circuitboard/machine/radioactive_nebula_shielding
	name = "放射性星云屏蔽装置"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/nebula_shielding/radiation
	req_components = list(
		/datum/stock_part/capacitor = 2,
		/obj/item/mod/module/rad_protection = 1,
		/obj/item/stack/sheet/plasteel = 2,
	)

/obj/item/circuitboard/machine/brm
	name = "巨石回收矩阵"
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/brm
	req_components = list(
		/datum/stock_part/capacitor = 1,
		/datum/stock_part/scanning_module = 1,
		/datum/stock_part/micro_laser = 1,
	)

/obj/item/circuitboard/machine/refinery
	name = "巨石精炼厂"
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/bouldertech/refinery
	req_components = list(
		/obj/item/assembly/igniter/condenser = 1,
		/datum/stock_part/servo = 2,
		/datum/stock_part/matter_bin = 2,
		/obj/item/reagent_containers/cup/beaker = 1,
	)

/obj/item/circuitboard/machine/smelter
	name = "巨石熔炼炉"
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/bouldertech/refinery/smelter
	req_components = list(
		/obj/item/assembly/igniter = 1,
		/datum/stock_part/servo = 2,
		/datum/stock_part/matter_bin = 2,
		/obj/item/reagent_containers/cup/beaker = 1,
	)

/obj/item/circuitboard/machine/shieldwallgen
	name = "护盾墙发生器"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/power/shieldwallgen
	req_components = list(
		/datum/stock_part/capacitor/tier2 = 2,
		/datum/stock_part/micro_laser/tier2 = 2,
		/obj/item/stack/sheet/plasteel = 2,
	)

/obj/item/circuitboard/machine/flatpacker
	name = "平板包装机"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/flatpacker
	req_components = list(
		/datum/stock_part/matter_bin = 2,
		/datum/stock_part/micro_laser = 2,
		/datum/stock_part/servo = 1,
		/obj/item/stack/sheet/plasteel = 5,
	)

/obj/item/circuitboard/machine/scrubber
	name = "便携式空气净化器"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/portable_atmospherics/scrubber
	needs_anchored = FALSE
	req_components = list(
		/obj/item/pipe/directional/scrubber = 1,
	)

/obj/item/circuitboard/machine/pump
	name = "便携式空气泵"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/portable_atmospherics/pump
	needs_anchored = FALSE
	req_components = list(
		/obj/item/pipe/directional/vent = 1,
	)

/obj/item/circuitboard/machine/pipe_scrubber
	name = "便携式管道净化器"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/portable_atmospherics/pipe_scrubber
	needs_anchored = FALSE
	req_components = list(
		/obj/item/pipe/trinary/flippable/filter = 1,
	)

/obj/item/circuitboard/machine/portagrav
	name = "便携式重力单元"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/power/portagrav
	req_components = list(
		/datum/stock_part/capacitor = 2,
		/datum/stock_part/micro_laser = 2,
		/obj/item/stack/sheet/glass = 1)

/obj/item/circuitboard/machine/big_manipulator
	name = "大型机械臂"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/big_manipulator
	req_components = list(
		/datum/stock_part/servo = 1,
		)

/obj/item/circuitboard/machine/manucrafter
	name = /obj/machinery/power/manufacturing/crafter::name
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/power/manufacturing/crafter
	req_components = list(
		/obj/item/stack/sheet/iron = 5,
		/datum/stock_part/servo = 1,
	)

/obj/item/circuitboard/machine/manulathe
	name = /obj/machinery/power/manufacturing/lathe::name
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/power/manufacturing/lathe
	req_components = list(
		/obj/item/stack/sheet/iron = 5,
		/datum/stock_part/matter_bin = 1,
	)

/obj/item/circuitboard/machine/manucrusher
	name = /obj/machinery/power/manufacturing/crusher::name
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/power/manufacturing/crusher
	req_components = list(
		/obj/item/stack/sheet/iron = 5,
		/datum/stock_part/servo = 1,
	)

/obj/item/circuitboard/machine/manuunloader
	name = /obj/machinery/power/manufacturing/unloader::name
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/power/manufacturing/unloader
	req_components = list(
		/obj/item/stack/sheet/iron = 5,
		/datum/stock_part/servo = 1,
	)

/obj/item/circuitboard/machine/manusorter
	name = /obj/machinery/power/manufacturing/sorter::name
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/power/manufacturing/sorter
	req_components = list(
		/obj/item/stack/sheet/iron = 5,
		/datum/stock_part/scanning_module = 1,
	)

/obj/item/circuitboard/machine/manusmelter
	name = /obj/machinery/power/manufacturing/smelter::name
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/power/manufacturing/smelter
	req_components = list(
		/obj/item/stack/sheet/iron = 5,
		/datum/stock_part/micro_laser = 1,
	)

/obj/item/circuitboard/machine/manurouter
	name = /obj/machinery/power/manufacturing/router::name
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/power/manufacturing/router
	req_components = list(
		/obj/item/stack/sheet/iron = 5,
	)

/obj/item/circuitboard/machine/atmos_shield_gen
	name = /obj/machinery/atmos_shield_gen::name
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/atmos_shield_gen
	req_components = list(
		/datum/stock_part/micro_laser = 1,
		/datum/stock_part/capacitor = 1,
	)

/obj/item/circuitboard/machine/engine
	name = "穿梭机引擎"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/power/shuttle_engine
	needs_anchored = FALSE
	req_components = list(
		/datum/stock_part/capacitor = 2,
		/datum/stock_part/micro_laser = 2,
	)

/obj/item/circuitboard/machine/engine/heater
	name = "穿梭机引擎加热器"
	build_path = /obj/machinery/power/shuttle_engine/heater

/obj/item/circuitboard/machine/engine/propulsion
	name = "穿梭机引擎推进器"
	build_path = /obj/machinery/power/shuttle_engine/propulsion

/obj/item/circuitboard/machine/quantum_server
	name = "量子服务器"
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/quantum_server
	req_components = list(
		/datum/stock_part/servo = 2,
		/datum/stock_part/scanning_module = 1,
		/datum/stock_part/capacitor = 1,
	)

/obj/item/circuitboard/machine/netpod
	name = "网络舱"
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/netpod
	req_components = list(
		/datum/stock_part/servo = 1,
		/datum/stock_part/matter_bin = 2,
	)

/obj/item/circuitboard/computer/quantum_console
	name = "量子控制台"
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/computer/quantum_console

/obj/item/circuitboard/machine/byteforge
	name = "字节熔炉"
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/byteforge
	req_components = list(
		/datum/stock_part/micro_laser = 1,
	)

/obj/item/circuitboard/machine/washing_machine
	name = "洗衣机"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/washing_machine
	req_components = list(
		/obj/item/stack/sheet/glass = 1,
		/obj/item/reagent_containers/cup/beaker = 2,
		/datum/stock_part/water_recycler = 1,
		/datum/stock_part/servo = 1,
	)

/obj/item/circuitboard/machine/wall_healer
	name = "DeForest First Aid Station"
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/wall_healer
	req_components = list(
		/obj/item/healthanalyzer/simple = 1,
		/obj/item/reagent_containers/syringe = 1,
		/obj/item/hemostat = 1,
		/obj/item/scalpel = 1,
	)

/obj/item/circuitboard/machine/wall_healer/examine(mob/user)
	. = ..()
	if(obj_flags & EMAGGED)
		. += span_warning("The safety chip looks fried.")

/obj/item/circuitboard/machine/wall_healer/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(obj_flags & EMAGGED)
		return FALSE

	playsound(src, SFX_SPARKS, 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	visible_message(span_warning("Sparks fly out of [src]!"))
	balloon_alert(user, "safeties disabled")
	obj_flags |= EMAGGED
	return TRUE

// Someone please add generic support for constructing wall mounted objects thanks
/obj/item/circuitboard/machine/wall_healer/completion_requirements(obj/structure/frame/install_frame, mob/living/user)
	if(locate(/obj/machinery/wall_healer) in install_frame.loc) // for subtypes support
		install_frame.balloon_alert(user, "identical machine present!")
		return FALSE

	var/turf/facing_wall = get_step(install_frame, user.dir)
	if(!is_mountable_turf(facing_wall))
		install_frame.balloon_alert(user, "no wall to install on!")
		return FALSE

	return TRUE

/obj/item/circuitboard/machine/wall_healer/free
	name = "DeForest Emergency First Aid Station"
	build_path = /obj/machinery/wall_healer/free
