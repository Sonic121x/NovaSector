////////////////////////////////////////
//////////////MISC Boards///////////////
////////////////////////////////////////
/datum/design/board/electrolyzer
	name = "电解机电路板"
	desc = "电解机所用的电路板。"
	id = "electrolyzer"
	build_path = /obj/item/circuitboard/machine/electrolyzer
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ATMOS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/smes
	name = "超导储能装置电路板"
	desc = "超导储能装置所用的电路板。"
	id = "smes"
	build_path = /obj/item/circuitboard/machine/smes
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/power_connector
	name = "电力连接器电路板"
	desc = "便携式SMES电力连接器的电路板。"
	id = "power_connector"
	build_path = /obj/item/circuitboard/machine/smes/connector
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/smesbank
	name = "便携式SMES电路板"
	desc = "便携式SMES的电路板，需要使用连接器。"
	id = "portable_smes"
	build_path = /obj/item/circuitboard/machine/smesbank
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/announcement_system
	name = "自动公告系统电路板"
	desc = "自动公告系统所用的电路板。"
	id = "automated_announcement"
	build_path = /obj/item/circuitboard/machine/announcement_system
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_TELECOMMS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/turbine_computer
	name = "涡轮动力控制台电路板"
	desc = "涡轮动力控制台所用的电路板"
	id = "power_turbine_console"
	build_path = /obj/item/circuitboard/computer/turbine_computer
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ATMOS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/emitter
	name = "发射器电路板"
	desc = "发射器所用的电路板。"
	id = "emitter"
	build_path = /obj/item/circuitboard/machine/emitter
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/mass_driver
	name = "质量驱动器电路板"
	desc = "质量驱动器的电路板。"
	id = "mass_driver"
	build_path = /obj/item/circuitboard/machine/mass_driver
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/turbine_compressor
	name = "涡轮压缩机电路板"
	desc = "涡轮压缩机所用的电路板。"
	id = "turbine_compressor"
	build_path = /obj/item/circuitboard/machine/turbine_compressor
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ATMOS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/turbine_rotor
	name = "涡轮机转子电路板"
	desc = "涡轮转子所用的电路板。"
	id = "turbine_rotor"
	build_path = /obj/item/circuitboard/machine/turbine_rotor
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ATMOS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/turbine_stator
	name = "涡轮机定子电路板"
	desc = "涡轮定子所用的电路板。"
	id = "turbine_stator"
	build_path = /obj/item/circuitboard/machine/turbine_stator
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ATMOS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/thermomachine
	name = "空调电路板"
	desc = "空调的电路板"
	id = "thermomachine"
	build_path = /obj/item/circuitboard/machine/thermomachine
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ATMOS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/space_heater
	name = "太空加热器电路板"
	desc = "太空加热器所用的电路板。"
	id = "space_heater"
	build_path = /obj/item/circuitboard/machine/space_heater
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ATMOS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/teleport_station
	name = "传送站电路板"
	desc = "传送站所用的电路板。"
	id = "tele_station"
	build_type = IMPRINTER
	build_path = /obj/item/circuitboard/machine/teleporter_station
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_TELEPORT
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/teleport_hub
	name = "传送枢纽电路板"
	desc = "传送枢纽所用的电路板。"
	id = "tele_hub"
	build_type = IMPRINTER
	build_path = /obj/item/circuitboard/machine/teleporter_hub
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_TELEPORT
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/quantumpad
	name = "量子板电路板"
	desc = "量子遥控器电路板"
	id = "quantumpad"
	build_type = IMPRINTER
	build_path = /obj/item/circuitboard/machine/quantumpad
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_TELEPORT
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/botpad
	name = "机器人发射台电路板"
	desc = "用于机器人发射台的电路板。"
	id = "botpad"
	build_type = IMPRINTER
	build_path = /obj/item/circuitboard/machine/botpad
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/launchpad
	name = "蓝空发射台电路板"
	desc = "蓝空发射台所用的电路板。"
	id = "launchpad"
	build_type = IMPRINTER
	build_path = /obj/item/circuitboard/machine/launchpad
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_TELEPORT
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/launchpad_console
	name = "蓝空发射台操作台电路板"
	desc = "蓝空发射台操作台所用的电路板。"
	id = "launchpad_console"
	build_type = IMPRINTER
	build_path = /obj/item/circuitboard/computer/launchpad_console
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_TELEPORT
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/modular_shield_gate
	name = "模块化护盾门电路板"
	desc = "模块化护盾门的电路板。"
	id = "modular_shield_gate"
	build_path = /obj/item/circuitboard/machine/modular_shield_generator/gate
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
		)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/modular_shield_generator
	name = "模块化护盾发生器电路板"
	desc = "模块化护盾发生器的电路板。"
	id = "modular_shield_generator"
	build_path = /obj/item/circuitboard/machine/modular_shield_generator
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/modular_shield_node
	name = "模块化护盾节点电路板"
	desc = "模块化护盾节点的电路板。"
	id = "modular_shield_node"
	build_path = /obj/item/circuitboard/machine/modular_shield_node
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/modular_shield_cable
	name = "模块化护盾电缆电路板"
	desc = "模块化护盾电缆的电路板。"
	id = "modular_shield_cable"
	build_path = /obj/item/circuitboard/machine/modular_shield_cable
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/modular_shield_relay
	name = "模块化护盾中继器电路板"
	desc = "模块化护盾中继器的电路板。"
	id = "modular_shield_relay"
	build_path = /obj/item/circuitboard/machine/modular_shield_relay
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/modular_shield_charger
	name = "模块化护盾充能器电路板"
	desc = "模块化护盾充能器的电路板。"
	id = "modular_shield_charger"
	build_path = /obj/item/circuitboard/machine/modular_shield_charger
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/modular_shield_well
	name = "模块化护盾井电路板"
	desc = "模块化护盾井的电路板。"
	id = "modular_shield_well"
	build_path = /obj/item/circuitboard/machine/modular_shield_well
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/modular_shield_console
	name = "模块化护盾控制台电路板"
	desc = "模块化护盾控制台的电路板。"
	id = "modular_shield_console"
	build_path = /obj/item/circuitboard/computer/modular_shield_console
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/teleconsole
	name = "传送器控制台电路板"
	desc = "可用于构建传送器控制台的电路板。"
	id = "teleconsole"
	build_type = IMPRINTER
	build_path = /obj/item/circuitboard/computer/teleporter
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_TELEPORT
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/cryotube
	name = "低温管电路板"
	desc = "用于低温管的电路板。"
	id = "cryotube"
	build_path = /obj/item/circuitboard/machine/cryo_tube
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_MEDICAL

/datum/design/board/chem_dispenser
	name = "便携式化学分配机电路板"
	desc = "化学分配机所用的电路板。"
	id = "chem_dispenser"
	build_path = /obj/item/circuitboard/machine/chem_dispenser
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_CHEMISTRY
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_MEDICAL

/datum/design/board/chem_master
	name = "化学大师电路板"
	desc = "化学大师3000的电路板"
	id = "chem_master"
	build_path = /obj/item/circuitboard/machine/chem_master
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_CHEMISTRY
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_MEDICAL

/datum/design/board/chem_heater
	name = "化学品加热器电路板"
	desc = "化学品加热器所用的电路板。"
	id = "chem_heater"
	build_path = /obj/item/circuitboard/machine/chem_heater
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_CHEMISTRY
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_MEDICAL

/datum/design/board/chem_mass_spec
	name = "高效液相色谱仪电路板"
	desc = "高效液相色谱仪的电路板。"
	id = "chem_mass_spec"
	build_path = /obj/item/circuitboard/machine/chem_mass_spec
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_CHEMISTRY
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_MEDICAL

/datum/design/board/smoke_machine
	name = "造雾机电路板"
	desc = "造雾机所用的电路板。"
	id = "smoke_machine"
	build_path = /obj/item/circuitboard/machine/smoke_machine
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_CHEMISTRY
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/board/reagentgrinder
	name = "一体式研磨机电路板"
	desc = "一体式研磨机所用的电路板。"
	id = "reagentgrinder"
	build_path = /obj/item/circuitboard/machine/reagentgrinder
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_CHEMISTRY
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SERVICE

/datum/design/board/hypnochair
	name = "强化审讯室电路板"
	desc = "我是不会告诉你任何事情的，呃呃呃啊啊啊啊啊啊嗷嗷嗷嗷嗷嗷嗷嗷。"
	id = "hypnochair"
	build_path = /obj/item/circuitboard/machine/hypnochair
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/board/photobooth
	name = "照相亭电路板"
	desc = "照相亭的电路板。"
	id = "photobooth"
	build_path = /obj/item/circuitboard/machine/photobooth
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/board/security_photobooth
	name = "安保照相亭电路板"
	desc = "安保照相亭的电路板。"
	id = "security_photobooth"
	build_path = /obj/item/circuitboard/machine/photobooth/security
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/board/biogenerator
	name = "生物反应器电路板"
	desc = "生物反应器所用的电路板。"
	id = "biogenerator"
	build_path = /obj/item/circuitboard/machine/biogenerator
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_BOTANY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/board/hydroponics
	name = "水培托盘电路板"
	desc = "水培托盘所用的电路板。"
	id = "hydro_tray"
	build_path = /obj/item/circuitboard/machine/hydroponics
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_BOTANY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/board/destructive_analyzer
	name = "破坏性分析仪电路板"
	desc = "破坏性分析仪所用的电路板。"
	id = "destructive_analyzer"
	build_path = /obj/item/circuitboard/machine/destructive_analyzer
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/experimentor
	name = "实验机-导师电路板"
	desc = "这是实验机-导师电路板"
	id = "experimentor"
	build_path = /obj/item/circuitboard/machine/experimentor
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/circuit_imprinter
	name = "电路板打印机(电路板)"
	desc = "电路板打印机所用的电路板。"
	id = "circuit_imprinter"
	build_type = IMPRINTER
	build_path = /obj/item/circuitboard/machine/circuit_imprinter
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_FAB
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/circuit_imprinter/offstation
	name = "古老的电路板打印机电路板"
	desc = "古老的电路板打印机所用的电路板。"
	id = "circuit_imprinter_offstation"
	build_type = AWAY_IMPRINTER
	build_path = /obj/item/circuitboard/machine/circuit_imprinter/offstation
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_FAB
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/rdservercontrol
	name = "研发服务器控制台电路板"
	desc = "研发服务器控制台所用的电路板。"
	id = "rdservercontrol"
	build_path = /obj/item/circuitboard/computer/rdservercontrol
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/rdserver
	name = "R&D服务器电路板"
	desc = "R&D服务器所用的电路板。"
	id = "rdserver"
	build_path = /obj/item/circuitboard/machine/rdserver
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/mechfab
	name = "外骨骼机甲加工厂电路板"
	desc = "一个外骨骼机甲加工厂的电路板"
	id = "mechfab"
	build_path = /obj/item/circuitboard/machine/mechfab
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ROBOTICS
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/cyborgrecharger
	name = "赛博充电器电路板"
	desc = "赛博充电器所用的电路板。"
	id = "cyborgrecharger"
	build_path = /obj/item/circuitboard/machine/cyborgrecharger
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ROBOTICS
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/mech_recharger
	name = "机甲湾充电器电路板"
	desc = "机甲湾充电器所用的电路板。"
	id = "mech_recharger"
	build_path = /obj/item/circuitboard/machine/mech_recharger
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ROBOTICS
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/dnascanner
	name = "DNA扫描仪电路板"
	desc = "DNA扫描仪所用的电路板。"
	id = "dnascanner"
	build_path = /obj/item/circuitboard/machine/dnascanner
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_GENETICS
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/dnainfuser
	name = "DNA注入器电路板"
	desc = "DNA注入器的电路板。"
	id = "dnainfuser"
	build_path = /obj/item/circuitboard/machine/dna_infuser
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_GENETICS
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/scan_console
	name = "DNA控制台电路板"
	desc = "允许制造用于构建DNA控制台的电路板。"
	id = "scan_console"
	build_path = /obj/item/circuitboard/computer/scan_consolenew
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_GENETICS
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/destructive_scanner
	name = "破坏性扫描仪电路板"
	desc = "实验性破坏扫描仪所用的电路板。"
	id = "destructive_scanner"
	build_path = /obj/item/circuitboard/machine/destructive_scanner
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/doppler_array
	name = "速子多普勒效应阵列电路板"
	desc = "速子多普勒效应阵列所用的电路板"
	id = "doppler_array"
	build_path = /obj/item/circuitboard/machine/doppler_array
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/anomaly_refinery
	name = "异常精炼器电路板"
	desc = "异常精炼器所用的电路板。"
	id = "anomaly_refinery"
	build_path = /obj/item/circuitboard/machine/anomaly_refinery
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/tank_compressor
	name = "罐式压缩机电路板"
	desc = "罐式压缩机所用的电路板"
	id = "tank_compressor"
	build_path = /obj/item/circuitboard/machine/tank_compressor
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/microwave
	name = "微波电路板"
	desc = "微波所用的电路板。"
	id = "microwave"
	build_path = /obj/item/circuitboard/machine/microwave
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_KITCHEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/board/microwave_engineering
	name = "无线微波炉电路板"
	desc = "电池供电微波炉的电路板。"
	id = "microwave_engineering"
	build_path = /obj/item/circuitboard/machine/microwave/engineering
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_KITCHEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/gibber
	name = "绞肉机电路板"
	desc = "绞肉机所用的电路板。"
	id = "gibber"
	build_path = /obj/item/circuitboard/machine/gibber
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_KITCHEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/board/smartfridge
	name = "智能冰箱电路板"
	desc = "智能冰箱所用的电路板。"
	id = "smartfridge"
	build_path = /obj/item/circuitboard/machine/smartfridge
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_KITCHEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/board/dehydrator
	name = "脱水机电路板"
	desc = "脱水机的电路板。"
	id = "dehydrator"
	build_path = /obj/item/circuitboard/machine/dehydrator
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_KITCHEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/board/vatgrower
	name = "培养槽电路板"
	desc = "培养槽的电路板。"
	id = "vatgrower"
	build_path = /obj/item/circuitboard/machine/vatgrower
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/monkey_recycler
	name = "猴子再循环器电路板"
	desc = "猴子再循环器所用的电路板。"
	id = "monkey_recycler"
	build_path = /obj/item/circuitboard/machine/monkey_recycler
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/seed_extractor
	name = "种子提取器电路板"
	desc = "种子提取器所用的电路板。"
	id = "seed_extractor"
	build_path = /obj/item/circuitboard/machine/seed_extractor
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_BOTANY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/board/processor
	name = "食品/史莱姆处理机电路板"
	desc = "用于处理机的电路板。螺丝刀切换食物（默认）或史莱姆处理。"
	id = "processor"
	build_path = /obj/item/circuitboard/machine/processor
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_KITCHEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE

/datum/design/board/soda_dispenser
	name = "便携式软饮料分配机电路板"
	desc = "便携式软饮料分配机所用的电路板。"
	id = "soda_dispenser"
	build_path = /obj/item/circuitboard/machine/chem_dispenser/drinks
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_BAR
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/board/beer_dispenser
	name = "酒品分配机电路板"
	desc = "酒品分配机所用的电路板。"
	id = "beer_dispenser"
	build_path = /obj/item/circuitboard/machine/chem_dispenser/drinks/beer
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_BAR
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/board/recycler
	name = "回收机电路板"
	desc = "回收机所用的电路板。"
	id = "recycler"
	build_path = /obj/item/circuitboard/machine/recycler
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/scanner_gate
	name = "扫描门电路板"
	desc = "扫描门所用的电路板。"
	id = "scanner_gate"
	build_path = /obj/item/circuitboard/machine/scanner_gate
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_MEDICAL

/datum/design/board/holopad
	name = "AI全息板电路板"
	desc = "AI全息板所用的电路板。"
	id = "holopad"
	build_path = /obj/item/circuitboard/machine/holopad
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/autolathe
	name = "自动车床电路板"
	desc = "自动车床所用的电路板。"
	id = "autolathe"
	build_path = /obj/item/circuitboard/machine/autolathe
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_FAB
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/recharger
	name = "武器充电器电路板"
	desc = "武器充电器所用的电路板。"
	id = "recharger"
	materials = list(/datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/gold =SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/circuitboard/machine/recharger
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SECURITY

/datum/design/board/vendor
	name = "售货机电路板"
	desc = "售货机所用的电路板。"
	id = "vendor"
	build_path = /obj/item/circuitboard/machine/vendor
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/board/ore_redemption
	name = "矿物提炼机电路板"
	desc = "矿物提炼机所用的电路板。"
	id = "ore_redemption"
	build_path = /obj/item/circuitboard/machine/ore_redemption
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_CARGO
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/mining_equipment_vendor
	name = "矿工奖励供应商（电路板）"
	desc = "“矿工奖励供应商”所用的电路板。"
	id = "mining_equipment_vendor"
	build_path = /obj/item/circuitboard/computer/order_console/mining
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_CARGO
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO

/datum/design/board/suit_storage_unit
	name = "防护服存储单元"
	desc = "防护服存储单元的电路板。"
	id = "suit_storage_unit"
	build_path = /obj/item/circuitboard/machine/suit_storage_unit
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ROBOTICS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/tesla_coil
	name = "特斯拉感应线圈电路板"
	desc = "特斯拉感应线圈所用的电路板。"
	id = "tesla_coil"
	build_path = /obj/item/circuitboard/machine/tesla_coil
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/grounding_rod
	name = "避雷针电路板"
	desc = "避雷针所用的电路板。"
	id = "grounding_rod"
	build_path = /obj/item/circuitboard/machine/grounding_rod
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/ntnet_relay
	name = "NTNet中继（电路板）"
	desc = "无线网络中继设备的电路板。"
	id = "ntnet_relay"
	build_path = /obj/item/circuitboard/machine/ntnet_relay
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_TELECOMMS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/crossing_signal
	name = "道口信号电路板"
	desc = "轨道车道口信号的电路板。"
	id = "crossing_signal"
	build_path = /obj/item/circuitboard/machine/crossing_signal
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_TELECOMMS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/guideway_sensor
	name = "导轨传感器电路板"
	desc = "轨道车接近传感器的电路板。"
	id = "guideway_sensor"
	build_path = /obj/item/circuitboard/machine/guideway_sensor
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_TELECOMMS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/limbgrower
	name = "肢体生长器电路板"
	desc = "肢体生长器所用的电路板。"
	id = "limbgrower"
	build_path = /obj/item/circuitboard/machine/limbgrower
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/board/harvester
	name = "器官收割器电路板"
	desc = "器官收割器所用的电路板。"
	id = "harvester"
	build_path = /obj/item/circuitboard/machine/harvester
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/board/deepfryer
	name = "油炸锅电路板"
	desc = "油炸锅所用的电路板。"
	id = "deepfryer"
	build_path = /obj/item/circuitboard/machine/deep_fryer
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_KITCHEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/board/griddle
	name = "烤板电路板"
	desc = "烤板所用的电路板。"
	id = "griddle"
	build_path = /obj/item/circuitboard/machine/griddle
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_KITCHEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/board/oven
	name = "烤箱电路板"
	desc = "烤箱所用的电路板。"
	id = "oven"
	build_path = /obj/item/circuitboard/machine/oven
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_KITCHEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/board/stove
	name = "炉灶电路板"
	desc = "炉灶的电路板。"
	id = "stove"
	build_path = /obj/item/circuitboard/machine/stove
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_KITCHEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/board/range
	name = "灶台电路板"
	desc = "灶台的电路板，它既是烤箱也是炉灶。"
	id = "range"
	build_path = /obj/item/circuitboard/machine/range
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_KITCHEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/board/cell_charger
	name = "电池充电器电路板"
	desc = "电池充电器所用的电路板。"
	id = "cell_charger"
	build_path = /obj/item/circuitboard/machine/cell_charger
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/dish_drive
	name = "餐盘驱动器电路板"
	desc = "餐盘驱动器的电路板。"
	id = "dish_drive"
	build_path = /obj/item/circuitboard/machine/dish_drive
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_KITCHEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/board/stacking_unit_console
	name = "堆叠机控制台电路板"
	desc = "堆叠机控制台的电路板。"
	id = "stack_console"
	build_path = /obj/item/circuitboard/machine/stacking_unit_console
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_CARGO
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/stacking_machine
	name = "堆叠机电路板"
	desc = "堆叠机的电路板。"
	id = "stack_machine"
	build_path = /obj/item/circuitboard/machine/stacking_machine
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_CARGO
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/ore_silo
	name = "矿井电路板"
	desc = "矿井所用的电路板。"
	id = "ore_silo"
	build_path = /obj/item/circuitboard/machine/ore_silo
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_CARGO
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/fat_sucker
	name = "脂质提取器电路板"
	desc = "脂质提取器所用的电路板。"
	id = "fat_sucker"
	build_path = /obj/item/circuitboard/machine/fat_sucker
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/board/stasis
	name = "静滞床电路板"
	desc = "静滞床所用的电路板"
	id = "stasis"
	build_path = /obj/item/circuitboard/machine/stasis
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/board/medical_kiosk
	name = "医疗亭（电路板）"
	desc = "医疗亭的电路板。"
	id = "medical_kiosk"
	build_path = /obj/item/circuitboard/machine/medical_kiosk
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/board/medipen_refiller
	name = "医疗笔装填机电路板"
	desc = "医疗笔装填机所用的电路板。"
	id = "medipen_refiller"
	build_path = /obj/item/circuitboard/machine/medipen_refiller
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/board/plumbing_receiver
	name = "化学接收器电路板"
	desc = "化学接收器的电路板。"
	id = "plumbing_receiver"
	build_path = /obj/item/circuitboard/machine/plumbing_receiver
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_CHEMISTRY
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SERVICE

/datum/design/board/sheetifier
	name = "板材大师 2000 电路板"
	desc = "板材大师 2000 的电路板。"
	id = "sheetifier"
	build_path = /obj/item/circuitboard/machine/sheetifier
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_FAB
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_CARGO

/datum/design/board/restaurant_portal
	name = "餐厅传送门电路板"
	desc = "餐厅传送门所用的电路板。"
	id = "restaurant_portal"
	build_path = /obj/item/circuitboard/machine/restaurant_portal
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_KITCHEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/board/bountypad
	name = "民用赏金发射台电路板"
	desc = "民用赏金发射台所用的电路板。"
	id = "bounty_pad"
	build_path = /obj/item/circuitboard/machine/bountypad
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_CARGO
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO

/datum/design/board/skill_station
	name = "技能站电路板"
	desc = "技能站所用的电路板。"
	id = "skill_station"
	build_path = /obj/item/circuitboard/machine/skill_station
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/board/fax
	name = "传真机电路板"
	desc = "传真机所用的电路板。"
	id = "fax"
	build_path = /obj/item/circuitboard/machine/fax
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_CARGO

//Hypertorus fusion reactor designs

/datum/design/board/HFR_core
	name = "超聚反应堆核心电路板"
	desc = "超聚反应堆核心所用的电路板。"
	id = "HFR_core"
	build_path = /obj/item/circuitboard/machine/HFR_core
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ATMOS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/HFR_fuel_input
	name = "超聚反应堆燃料输入口电路板"
	desc = "超聚反应堆燃料输入口所用的电路板。"
	id = "HFR_fuel_input"
	build_path = /obj/item/circuitboard/machine/HFR_fuel_input
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ATMOS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/HFR_waste_output
	name = "超聚反应堆废气排出口电路板"
	desc = "超聚反应堆废气排出口所用的电路板。"
	id = "HFR_waste_output"
	build_path = /obj/item/circuitboard/machine/HFR_waste_output
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ATMOS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/HFR_moderator_input
	name = "超聚反应堆慢化剂输入口电路板"
	desc = "超聚反应堆慢化剂输入口所用的电路板。"
	id = "HFR_moderator_input"
	build_path = /obj/item/circuitboard/machine/HFR_moderator_input
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ATMOS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/HFR_corner
	name = "超聚反应堆转角组件电路板"
	desc = "超聚反应堆转角组件所用的电路板."
	id = "HFR_corner"
	build_path = /obj/item/circuitboard/machine/HFR_corner
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ATMOS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/HFR_interface
	name = "超聚反应堆人机界面电路板"
	desc = "超聚反应堆人机界面所用的电路板."
	id = "HFR_interface"
	build_path = /obj/item/circuitboard/machine/HFR_interface
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ATMOS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/crystallizer
	name = "结晶器电路板"
	desc = "结晶器所用的电路板。"
	id = "crystallizer"
	build_path = /obj/item/circuitboard/machine/crystallizer
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ATMOS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/exoscanner
	name = "扫描仪阵列电路板"
	desc = "扫描仪阵列所用的电路板。"
	id = "exoscanner"
	build_path = /obj/item/circuitboard/machine/exoscanner
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO

/datum/design/board/exodrone_launcher
	name = "探索无人机发射器电路板"
	desc = "勘查无人机发射器所用的电路板。"
	id = "exodrone_launcher"
	build_path = /obj/item/circuitboard/machine/exodrone_launcher
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO

/datum/design/board/component_printer
	name = "组件打印厂(电路板)"
	desc = "一台组件打印厂所用的电路板"
	id = "component_printer"
	build_path = /obj/item/circuitboard/machine/component_printer
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/module_printer
	name = "模块复印机（电路板）"
	desc = "模块复印机的电路板"
	id = "module_duplicator"
	build_path = /obj/item/circuitboard/machine/module_duplicator
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/coffeemaker
	name = "咖啡机电路板"
	desc = "咖啡机所用的电路板。"
	id = "coffeemaker"
	build_path = /obj/item/circuitboard/machine/coffeemaker
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/navbeacon
	name = "机器人导航信标电路板"
	desc = "用于辅助机器人导航的信标电路板。"
	id = "botnavbeacon"
	build_path = /obj/item/circuitboard/machine/navbeacon
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ROBOTICS
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/fishing_portal_generator
	name = "钓鱼传送门发生器电路板"
	desc = "钓鱼传送门发生器的电路板"
	id = "fishing_portal_generator"
	build_path = /obj/item/circuitboard/machine/fishing_portal_generator
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/brm
	name = "巨石回收矩阵电路板"
	id = "brm"
	materials = list(
		/datum/material/glass = SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/circuitboard/machine/brm
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_TELEPORT,
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO

/datum/design/board/flatpacker
	name = "平板包装机电路板"
	desc = "平板包装机的电路板。"
	id = "flatpacker"
	build_path = /obj/item/circuitboard/machine/flatpacker
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/scrubber
	name = "便携式空气净化器电路板"
	desc = "便携式空气净化器的电路板。"
	id = "scrubber"
	build_path = /obj/item/circuitboard/machine/scrubber
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ATMOS
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/pump
	name = "便携式空气泵电路板"
	desc = "便携式空气泵的电路板。"
	id = "pump"
	build_path = /obj/item/circuitboard/machine/pump
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ATMOS
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/pipe_scrubber
	name = "便携式管道净化器电路板"
	desc = "便携式管道净化器的电路板。"
	id = "pipe_scrubber"
	build_path = /obj/item/circuitboard/machine/pipe_scrubber
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ATMOS
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/bookbinder
	name = "书籍装订机"
	desc = "书籍装订机的电路板"
	id = "bookbinder"
	build_path = /obj/item/circuitboard/machine/bookbinder
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/board/libraryscanner
	name = "书籍扫描仪"
	desc = "书籍扫描仪的电路板"
	id = "libraryscanner"
	build_path = /obj/item/circuitboard/machine/libraryscanner
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/board/big_manipulator
	name = "大型机械臂电路板"
	desc = "大型机械臂的电路板。"
	id = "big_manipulator"
	build_path = /obj/item/circuitboard/machine/big_manipulator
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SERVICE

/datum/design/board/manulathe
	name = "制造车床电路板"
	desc = "该机器的电路板。"
	id = "manulathe"
	build_path = /obj/item/circuitboard/machine/manulathe
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_CARGO

/datum/design/board/manucrafter
	name = "制造装配机电路板"
	desc = "该机器的电路板。"
	id = "manucrafter"
	build_path = /obj/item/circuitboard/machine/manucrafter
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_CARGO

/datum/design/board/manucrusher
	name = "制造粉碎机电路板"
	desc = "该机器的电路板。"
	id = "manucrusher"
	build_path = /obj/item/circuitboard/machine/manucrusher
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_CARGO

/datum/design/board/manurouter
	name = "制造路由器电路板"
	desc = "该机器的电路板。"
	id = "manurouter"
	build_path = /obj/item/circuitboard/machine/manurouter
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_CARGO

/datum/design/board/manusorter
	name = "传送带分拣路由器电路板"
	desc = "该机器的电路板。"
	id = "manusorter"
	build_path = /obj/item/circuitboard/machine/manusorter
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_CARGO

/datum/design/board/manuunloader
	name = "制造货箱卸载机电路板"
	desc = "该机器的电路板。"
	id = "manuunloader"
	build_path = /obj/item/circuitboard/machine/manuunloader
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_CARGO

/datum/design/board/manusmelter
	name = "制造熔炉电路板"
	desc = "该机器的电路板。"
	id = "manusmelter"
	build_path = /obj/item/circuitboard/machine/manusmelter
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_CARGO

/datum/design/board/mailsorter
	name = "邮件分拣机电路板"
	desc = "邮件分拣单元的电路板。"
	id = "mailsorter"
	build_path = /obj/item/circuitboard/machine/mailsorter
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_CARGO
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/propulsion_engine
	name = "推进引擎电路板"
	desc = "推进引擎的电路。"
	id = "propulsion_engine"
	build_path = /obj/item/circuitboard/machine/engine/propulsion
	build_type = IMPRINTER
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/photopcopier
	name = "复印机"
	desc = "复印机的电路板。"
	id = "photocopier"
	build_path = /obj/item/circuitboard/machine/photocopier
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SERVICE

/datum/design/board/atmosshieldgen
	name = "大气护盾发生器电路板"
	desc = "大气护盾发生器的电路板。"
	id = "atmosshieldgen"
	build_path = /obj/item/circuitboard/machine/atmos_shield_gen
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ATMOS
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/netpod
	name = "网络舱电路板"
	desc = "网络舱的电路板。"
	id = "netpod"
	build_path = /obj/item/circuitboard/machine/netpod
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_CARGO
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/byteforge
	name = "字节熔炉电路板"
	desc = "允许建造用于构建字节熔炉的电路板。"
	id = "byteforge"
	build_path = /obj/item/circuitboard/machine/byteforge
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_CARGO
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/washing_machine
	name = "洗衣机"
	desc = "用于建造洗衣机的电路板。"
	id = "washing_machine"
	build_path = /obj/item/circuitboard/machine/washing_machine
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE
