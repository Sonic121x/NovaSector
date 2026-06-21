#define RND_SUBCATEGORY_MACHINE_XENOARCH "/Xenoarchaeology Machinery"
#define RND_SUBCATEGORY_EQUIPMENT_XENOARCH "/Xenoarchaeology Equipment"
#define RND_SUBCATEGORY_TOOLS_XENOARCH "/Xenoarchaeology Tools"
#define RND_SUBCATEGORY_TOOLS_XENOARCH_ADVANCED "/Xenoarchaeology Tools (Advanced)"

/datum/design/xenoarch
	build_type = PROTOLATHE | AWAY_LATHE
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SERVICE
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT * 2,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT,
	)

/datum/design/xenoarch/tool
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_XENOARCH,
	)

/datum/design/xenoarch/tool/hammer
	name = "锤子 (厘米 1)"
	desc = "一把可以缓慢清除奇异岩石上碎屑的锤子。"
	id = "hammer_cm1"
	build_path = /obj/item/xenoarch/hammer

/datum/design/xenoarch/tool/hammer/cm2
	name = "锤子 (厘米 2)"
	id = "hammer_cm2"
	build_path = /obj/item/xenoarch/hammer/cm2

/datum/design/xenoarch/tool/hammer/cm3
	name = "锤子 (厘米 3)"
	id = "hammer_cm3"
	build_path = /obj/item/xenoarch/hammer/cm3

/datum/design/xenoarch/tool/hammer/cm4
	name = "锤子 (厘米 4)"
	id = "hammer_cm4"
	build_path = /obj/item/xenoarch/hammer/cm4

/datum/design/xenoarch/tool/hammer/cm5
	name = "锤子 (厘米 5)"
	id = "hammer_cm5"
	build_path = /obj/item/xenoarch/hammer/cm5

/datum/design/xenoarch/tool/hammer/cm6
	name = "锤子 (厘米 6)"
	id = "hammer_cm6"
	build_path = /obj/item/xenoarch/hammer/cm6

/datum/design/xenoarch/tool/hammer/cm10
	name = "锤子 (厘米 10)"
	id = "hammer_cm10"
	build_path = /obj/item/xenoarch/hammer/cm10

/datum/design/xenoarch/tool/brush
	name = "刷子"
	desc = "一把可以缓慢清除奇异岩石上碎屑的刷子。"
	id = "xenoarch_brush"
	build_path = /obj/item/xenoarch/brush

/datum/design/xenoarch/tool/xeno_tape
	name = "异星考古卷尺"
	desc = "一把用于测量奇异岩石挖掘深度的卷尺。"
	id = "xenoarch_tapemeasure"
	build_path = /obj/item/xenoarch

/datum/design/xenoarch/tool/scanner
	name = "异星考古手持扫描仪"
	desc = "一种用于奇异岩石的手持扫描仪，能够标记“安全”深度和最大深度。"
	id = "xenoarch_handscanner"
	build_path = /obj/item/xenoarch/handheld_scanner

/datum/design/xenoarch/tool/stabilizer
	name = "异星考古文物稳定器"
	desc = "一种用于稳定巨石的过时技术。"
	id = "xenoarch_artifact_stabilizer"
	build_path = /obj/item/xenoarch/anomaly_stabilizer
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/xenoarch/tool/core_sampler
	name = "岩芯取样器"
	desc = "一种采集岩石和泥土样本的过时方法。"
	id = "xenoarch_core_sampler"
	build_path = /obj/item/xenoarch/core_sampler
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/xenoarch/tool/particles_battery
	name = "奇异粒子能量电池"
	desc = "一种可以收集奇异粒子并在适当使用时将其释放的电池。"
	id = "xenoarch_particles_battery"
	build_path = /obj/item/xenoarch/particles_battery
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/plasma = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/bluespace = SMALL_MATERIAL_AMOUNT,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/xenoarch/tool/xenoarch_utilizer
	name = "奇异粒子能量利用器"
	desc = "一种用于释放奇异粒子电池能量的设备。"
	id = "xenoarch_utilizer"
	build_path = /obj/item/xenoarch/xenoarch_utilizer
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/plasma = HALF_SHEET_MATERIAL_AMOUNT,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/xenoarch/tool/wave_scanner_backpack
	name = "波形扫描背包"
	desc = "一种寻找奇异粒子的过时方法。"
	id = "xenoarch_wave_scanner"
	build_path = /obj/item/xenoarch/wave_scanner_backpack
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT*2,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/plasma = SHEET_MATERIAL_AMOUNT,
		/datum/material/bluespace = SMALL_MATERIAL_AMOUNT,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/xenoarch/tool/advanced
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT * 2 ,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT * 2,
		/datum/material/uranium = SMALL_MATERIAL_AMOUNT * 4,
	)
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_XENOARCH_ADVANCED,
	)

/datum/design/xenoarch/tool/advanced/scanner
	name = "异星考古高级手持扫描仪"
	id = "xenoarch_handscanner_adv"
	build_path = /obj/item/xenoarch/handheld_scanner/advanced

/datum/design/xenoarch/tool/radar
	name = "Xenoarch Handheld Radar"
	desc = "一种能够回收因时间流逝而丢失物品的设备。"
	id = "xenoarch_radar"
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/xenoarch/handheld_radar

/datum/design/xenoarch/tool/advanced/adv_hammer
	name = "高级锤"
	desc = "一种能快速清除奇异岩石上的碎屑并改变挖掘深度的锤子。"
	id = "xenoarch_adv_hammer"
	build_path = /obj/item/xenoarch/hammer/adv

/datum/design/xenoarch/tool/advanced/adv_brush
	name = "高级刷"
	desc = "一种能快速清除奇异岩石上碎屑的刷子。"
	id = "xenoarch_adv_brush"
	build_path = /obj/item/xenoarch/brush/adv

/datum/design/xenoarch/equipment
	// everything under this except the adv bag feels redundant because cloth/leather are there too
	// but i guess we'll burn that bridge another time
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_XENOARCH,
	)

/datum/design/xenoarch/equipment/bag
	name = "异星考古学背包"
	desc = "一个可以容纳大约二十五块奇异岩石的背包。"
	id = "xenoarch_bag"
	build_path = /obj/item/storage/bag/xenoarch

/datum/design/xenoarch/equipment/belt
	name = "异星考古学腰带"
	desc = "一条可以容纳所有异星考古学必备工具的腰带。"
	id = "xenoarch_belt"
	build_path = /obj/item/storage/belt/utility/xenoarch

/datum/design/xenoarch/equipment/bag_adv
	name = "高级异星考古背包"
	desc = "一个能容纳约五十块奇异岩石的袋子。"
	id = "xenoarch_bag_adv"
	materials = list(/datum/material/gold = SMALL_MATERIAL_AMOUNT*2.5, /datum/material/uranium =SMALL_MATERIAL_AMOUNT*5) // same materials as the mining bag of holding.
	build_path = /obj/item/storage/bag/xenoarch/adv

/datum/design/board/xenoarch
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_XENOARCH,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/xenoarch/researcher
	name = "Xenoarch Researcher Board"
	desc = "允许建造用于组装新型异星考古研究员的电路板。"
	id = "xeno_researcher"
	build_path = /obj/item/circuitboard/machine/xenoarch_machine/xenoarch_researcher
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SERVICE

/datum/design/board/xenoarch/scanner
	name = "Xenoarch Scanner Board"
	desc = "允许建造用于组装新型异星考古扫描仪的电路板。"
	id = "xeno_scanner"
	build_path = /obj/item/circuitboard/machine/xenoarch_machine/xenoarch_scanner
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SERVICE

/datum/design/board/xenoarch/artifact_analyzer
	name = "Artifact Analyzer Board"
	desc = "允许建造用于组装新型异星考古文物分析仪的电路板。"
	id = "artifact_analyzer"
	build_path = /obj/item/circuitboard/machine/artifact_analyser

/datum/design/board/xenoarch/radiocarbon_spectrometer
	name = "Radiocarbon spectrometer Board"
	desc = "允许建造用于组装新型异星考古放射性碳光谱仪的电路板。"
	id = "radiocarbon spectrometer"
	build_path = /obj/item/circuitboard/machine/radiocarbon_spectrometer

/datum/design/board/xenoarch/artifact_harvester
	name = "Exotic Particle Harvester Board"
	desc = "允许建造用于组装新型异星考古奇异粒子收集器的电路板。"
	id = "artifact_harvester"
	build_path = /obj/item/circuitboard/machine/artifact_harvester

/datum/design/board/xenoarch/artifact_scanpad
	name = "Artifact Scanpad Board"
	desc = "允许建造用于组装新型异星考古文物扫描台的电路板。"
	id = "artifact_scanpad"
	build_path = /obj/item/circuitboard/machine/artifact_scanpad

/datum/design/board/xenoarch/digger
	name = "Xenoarch Digger Board"
	desc = "允许建造用于组装新型异星考古挖掘机的电路板。"
	id = "xeno_digger"
	build_path = /obj/item/circuitboard/machine/xenoarch_machine/xenoarch_digger
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SERVICE

/datum/techweb_node/basic_xenoarch
	id = TECHWEB_NODE_XENOARCH_BASIC
	starting_node = TRUE
	display_name = "Basic Xenoarchaeology"
	description = "外星考古学的基本设计。"
	design_ids = list(
		"hammer_cm1",
		"hammer_cm2",
		"hammer_cm3",
		"hammer_cm4",
		"hammer_cm5",
		"hammer_cm6",
		"hammer_cm10",
		"xenoarch_brush",
		"xenoarch_utilizer",
		"xenoarch_tapemeasure",
		"xenoarch_handscanner",
		"xenoarch_wave_scanner",
		"xenoarch_core_sampler",
		"xenoarch_particles_battery",
		"xenoarch_artifact_stabilizer",
		"xenoarch_belt",
		"xenoarch_bag",
		"xenoarch_radar",
		"xeno_researcher",
		"xeno_scanner",
	)
	announce_channels = list(RADIO_CHANNEL_SCIENCE, RADIO_CHANNEL_SERVICE, RADIO_CHANNEL_SUPPLY)

/datum/techweb_node/xenoarch_machines
	id = TECHWEB_NODE_XENOARCH_MACHINES
	display_name = "Xenoarchaeology Machines"
	description = "有时，外星考古学可能很耗时，也许机器能帮上忙？"
	prereq_ids = list(TECHWEB_NODE_XENOARCH_BASIC)
	design_ids = list(
		"artifact_analyzer",
		"artifact_scanpad",
		"artifact_harvester",
		"radiocarbon spectrometer",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE)

/datum/techweb_node/adv_xenoarch
	id = TECHWEB_NODE_XENOARCH_ADVANCED
	display_name = "Advanced Archeology"
	description = "一段时间后，我们使用的那些工具已经过时了——我们需要升级。"
	prereq_ids = list(TECHWEB_NODE_XENOARCH_BASIC)
	design_ids = list(
		"xenoarch_adv_hammer",
		"xenoarch_adv_brush",
		"xenoarch_bag_adv",
		"xenoarch_handscanner_adv",
		"xeno_digger",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE, RADIO_CHANNEL_SERVICE, RADIO_CHANNEL_SUPPLY)

#undef RND_SUBCATEGORY_MACHINE_XENOARCH
#undef RND_SUBCATEGORY_EQUIPMENT_XENOARCH
#undef RND_SUBCATEGORY_TOOLS_XENOARCH
#undef RND_SUBCATEGORY_TOOLS_XENOARCH_ADVANCED
