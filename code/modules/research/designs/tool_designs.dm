
/////////////////////////////////////////
/////////////////Tools///////////////////
/////////////////////////////////////////

/datum/design/fire_extinguisher_advanced
	name = "高级灭火器"
	id = "adv_fire_extinguisher"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/titanium =SMALL_MATERIAL_AMOUNT*5, /datum/material/gold =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/extinguisher/advanced/empty
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING_ADVANCED
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/handdrill
	name = "手钻"
	desc = "一款小型电动手钻，配有可更换的螺丝刀和螺栓钻头。"
	id = "handdrill"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT*1.75, /datum/material/silver =HALF_SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/titanium =SHEET_MATERIAL_AMOUNT*1.25)
	build_path = /obj/item/screwdriver/power
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING_ADVANCED
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/jawsoflife
	name = "液压钳"
	desc = "一款小巧紧凑的救援之颚多功能工具，其配有可互换的撬动钳口和切割钳口。"
	id = "jawsoflife" // added one more requirment since the Jaws of Life are a bit OP
	build_path = /obj/item/crowbar/power
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT*2.25, /datum/material/silver =SHEET_MATERIAL_AMOUNT*1.25, /datum/material/titanium =SHEET_MATERIAL_AMOUNT*1.75)
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING_ADVANCED
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING
	autolathe_exportable = FALSE

/datum/design/exwelder
	name = "实验用焊接工具"
	desc = "一种能够实现自身燃料生成的实验性焊接设备。"
	id = "exwelder"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/glass =SMALL_MATERIAL_AMOUNT*5, /datum/material/plasma =HALF_SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/uranium =SMALL_MATERIAL_AMOUNT * 2)
	build_path = /obj/item/weldingtool/experimental
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING_ADVANCED
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/rangedanalyzer
	name = "实验用远程气体分析仪"
	desc = "一种能够在分析远程气体的实验性气体分析仪"
	id = "rangedanalyzer"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT, /datum/material/glass =SMALL_MATERIAL_AMOUNT*0.2, /datum/material/gold =SMALL_MATERIAL_AMOUNT * 3, /datum/material/bluespace=SMALL_MATERIAL_AMOUNT * 2)
	build_path = /obj/item/analyzer/ranged
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ATMOSPHERICS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/rpd
	name = "快速管道分配器(RPD)"
	id = "rpd_loaded"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT*37.5, /datum/material/glass =SHEET_MATERIAL_AMOUNT*18.75)
	build_path = /obj/item/pipe_dispenser
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING_ADVANCED
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/rcd_loaded
	name = "快捷建设装置"
	desc = "一种能够即时构建和拆除墙壁、气闸以及地板的工具。"
	id = "rcd_loaded"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT*30, /datum/material/glass =SHEET_MATERIAL_AMOUNT * 2.5)
	build_path = /obj/item/construction/rcd/loaded
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING_ADVANCED
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/rtd_loaded
	name = "快速铺砖装置"
	desc = "一种可以即时铺设和拆除地板砖的工具。"
	id = "rtd_loaded"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT * 15, /datum/material/glass =SHEET_MATERIAL_AMOUNT*1.25)
	build_path = /obj/item/construction/rtd/loaded
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING_ADVANCED
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/rcd_ammo
	name = "RCD物质筒"
	id = "rcd_ammo"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT*6, /datum/material/glass =SHEET_MATERIAL_AMOUNT*4)
	build_path = /obj/item/rcd_ammo
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING_ADVANCED
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/rcd_upgrade/frames
	name = "RCD框架设计升级"
	desc = "在 RCD 中增加了计算机和机器框架的设计。"
	id = "rcd_upgrade_frames"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT * 2.5, /datum/material/glass =SHEET_MATERIAL_AMOUNT*1.25, /datum/material/silver =HALF_SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/titanium =SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/rcd_upgrade/frames
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING_ADVANCED
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/rcd_upgrade/simple_circuits
	name = "RCD基础电路设计升级"
	desc = "增加了使用RCD来制作简单电路的功能。"
	id = "rcd_upgrade_simple_circuits"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT * 2.5, /datum/material/glass =SHEET_MATERIAL_AMOUNT*1.25, /datum/material/silver =HALF_SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/titanium =SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/rcd_upgrade/simple_circuits
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING_ADVANCED
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/rcd_upgrade/anti_interrupt
	name = "RCD抗干扰设计升级"
	desc = "防止RCD建造和拆除过程被打断。"
	id = "rcd_upgrade_anti_interrupt"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2.5,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 1.25,
		/datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT * 1.5,
		/datum/material/titanium = SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/rcd_upgrade/anti_interrupt
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING_ADVANCED
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/rcd_upgrade/cooling
	name = "RCD冷却升级"
	desc = "允许RCD更快速地同时执行多个操作。"
	id = "rcd_upgrade_cooling"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT,
		/datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/rcd_upgrade/cooling
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING_ADVANCED
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/rcd_upgrade/furnishing
	name = "RCD家具升级"
	desc = "增加了使用 RCD 来布置区域的功能。"
	id = "rcd_upgrade_furnishing"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT * 2.5, /datum/material/glass =SHEET_MATERIAL_AMOUNT*1.25, /datum/material/silver =HALF_SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/titanium =SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/rcd_upgrade/furnishing
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING_ADVANCED
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/rcd_upgrade/silo_link
	name = "高级RCD矿井连接升级"
	desc = "对遥控装置进行升级，使其能够从矿物储仓中提取物料。在该遥控装置能够正常运行之前，必须先使用多功能工具将其与储料仓连接起来。"
	id = "rcd_upgrade_silo_link"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT*1.25, /datum/material/glass =SHEET_MATERIAL_AMOUNT*1.25, /datum/material/silver =SHEET_MATERIAL_AMOUNT*1.25, /datum/material/titanium =SHEET_MATERIAL_AMOUNT*1.25, /datum/material/bluespace =SHEET_MATERIAL_AMOUNT*1.25)
	build_path = /obj/item/rcd_upgrade/silo_link
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING_ADVANCED
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/rpd_upgrade/unwrench
	name = "RPD取消固定升级"
	desc = "将反向扳手模式添加到RPD。注意，由于预算削减，该模式与破坏模式控制按钮硬链接。"
	id = "rpd_upgrade_unwrench"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT * 2.5, /datum/material/glass =SHEET_MATERIAL_AMOUNT*1.25)
	build_path = /obj/item/rpd_upgrade/unwrench
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING_ADVANCED
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/rld_mini
	name = "迷你快捷照明装置(MRLD)"
	desc = "一种可以部署便携式和立式照明球以及荧光棒的工具。"
	id = "rld_mini"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT*10, /datum/material/glass =SHEET_MATERIAL_AMOUNT*5, /datum/material/plastic =SHEET_MATERIAL_AMOUNT*4, /datum/material/gold =SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/construction/rld/mini
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_JANITORIAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SERVICE

/datum/design/geneshears
	name = "植物学遗传修饰剪"
	desc = "一把高科技、高保真度的植物修剪剪刀，能够剪除植物的遗传特征."
	id = "gene_shears"
	build_path = /obj/item/geneshears
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*2, /datum/material/uranium=HALF_SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/silver=SMALL_MATERIAL_AMOUNT*5)
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_BOTANY_ADVANCED
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/plumbing_rcd_service
	name = "服务管道构建机"
	id = "plumbing_rcd_service"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT*37.5, /datum/material/glass =SHEET_MATERIAL_AMOUNT*18.75, /datum/material/plastic =HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/construction/plumbing/service
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_PLUMBING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/biopsy_tool
	name = "活组织采样器"
	id = "biopsy_tool"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT*2, /datum/material/glass =SHEET_MATERIAL_AMOUNT*1.5)
	build_path = /obj/item/biopsy_tool
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_XENOBIOLOGY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/////////////////////////////////////////
//////////////Alien Tools////////////////
/////////////////////////////////////////

/datum/design/alienwrench
	name = "外星扳手"
	desc = "一款通过劫持者技术制造的高级扳手。"
	id = "alien_wrench"
	build_path = /obj/item/wrench/abductor
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT * 2.5, /datum/material/silver =SHEET_MATERIAL_AMOUNT*1.25, /datum/material/plasma =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/titanium =SHEET_MATERIAL_AMOUNT, /datum/material/diamond =SHEET_MATERIAL_AMOUNT)
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING_ALIEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/alienwirecutters
	name = "外星剪线钳"
	desc = "通过劫持者技术研制的高级电剪刀。"
	id = "alien_wirecutters"
	build_path = /obj/item/wirecutters/abductor
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT * 2.5, /datum/material/silver =SHEET_MATERIAL_AMOUNT*1.25, /datum/material/plasma =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/titanium =SHEET_MATERIAL_AMOUNT, /datum/material/diamond =SHEET_MATERIAL_AMOUNT)
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING_ALIEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/alienscrewdriver
	name = "外星螺丝刀"
	desc = "一款通过劫持者技术制造的高级螺丝刀。"
	id = "alien_screwdriver"
	build_path = /obj/item/screwdriver/abductor
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT * 2.5, /datum/material/silver =SHEET_MATERIAL_AMOUNT*1.25, /datum/material/plasma =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/titanium =SHEET_MATERIAL_AMOUNT, /datum/material/diamond =SHEET_MATERIAL_AMOUNT)
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING_ALIEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/aliencrowbar
	name = "外星撬棍"
	desc = "通过劫持者技术获得的一把高级撬棍。"
	id = "alien_crowbar"
	build_path = /obj/item/crowbar/abductor
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT * 2.5, /datum/material/silver =SHEET_MATERIAL_AMOUNT*1.25, /datum/material/plasma =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/titanium =SHEET_MATERIAL_AMOUNT, /datum/material/diamond =SHEET_MATERIAL_AMOUNT)
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING_ALIEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/alienwelder
	name = "外星焊接工具"
	desc = "一款通过劫持者技术研发而成的先进焊接工具。"
	id = "alien_welder"
	build_path = /obj/item/weldingtool/abductor
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT * 2.5, /datum/material/silver =SHEET_MATERIAL_AMOUNT*1.25, /datum/material/plasma =SHEET_MATERIAL_AMOUNT * 2.5, /datum/material/titanium =SHEET_MATERIAL_AMOUNT, /datum/material/diamond =SHEET_MATERIAL_AMOUNT)
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING_ALIEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/alienmultitool
	name = "外星多功能工具"
	desc = "通过劫持者技术研发高级多功能工具。"
	id = "alien_multitool"
	build_path = /obj/item/multitool/abductor
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT * 2.5, /datum/material/silver =SHEET_MATERIAL_AMOUNT*1.25, /datum/material/plasma =SHEET_MATERIAL_AMOUNT * 2.5, /datum/material/titanium =SHEET_MATERIAL_AMOUNT, /datum/material/diamond =SHEET_MATERIAL_AMOUNT)
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING_ALIEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/////////////////////////////////////////
/////////Alien Surgical Tools////////////
/////////////////////////////////////////

/datum/design/alienscalpel
	name = "外星手术刀"
	desc = "通过劫持者技术研发的先进手术刀。"
	id = "alien_scalpel"
	build_path = /obj/item/scalpel/alien
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT, /datum/material/silver =HALF_SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/plasma =SMALL_MATERIAL_AMOUNT*5, /datum/material/titanium =HALF_SHEET_MATERIAL_AMOUNT * 1.5)
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL_ALIEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/alienhemostat
	name = "外星止血钳"
	desc = "通过劫持者技术制造的高级止血器。"
	id = "alien_hemostat"
	build_path = /obj/item/hemostat/alien
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT, /datum/material/silver =HALF_SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/plasma =SMALL_MATERIAL_AMOUNT*5, /datum/material/titanium =HALF_SHEET_MATERIAL_AMOUNT * 1.5)
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL_ALIEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/alienretractor
	name = "外星牵开器"
	desc = "一款通过劫持者技术研发而成的高级牵开器。"
	id = "alien_retractor"
	build_path = /obj/item/retractor/alien
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT, /datum/material/silver =HALF_SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/plasma =SMALL_MATERIAL_AMOUNT*5, /datum/material/titanium =HALF_SHEET_MATERIAL_AMOUNT * 1.5)
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL_ALIEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/aliensaw
	name = "外星圆锯"
	desc = "一款通过劫持者技术制造的高级手术锯。"
	id = "alien_saw"
	build_path = /obj/item/circular_saw/alien
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT*5, /datum/material/silver =SHEET_MATERIAL_AMOUNT*1.25, /datum/material/plasma =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/titanium =HALF_SHEET_MATERIAL_AMOUNT * 1.5)
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL_ALIEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/aliendrill
	name = "外星钻"
	desc = "通过劫持者技术研制的高级钻头。"
	id = "alien_drill"
	build_path = /obj/item/surgicaldrill/alien
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT*5, /datum/material/silver =SHEET_MATERIAL_AMOUNT*1.25, /datum/material/plasma =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/titanium =HALF_SHEET_MATERIAL_AMOUNT * 1.5)
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL_ALIEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/aliencautery
	name = "外星缝合器"
	desc = "通过劫持者技术研制的先进电灼装置。"
	id = "alien_cautery"
	build_path = /obj/item/cautery/alien
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT, /datum/material/silver =HALF_SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/plasma =SMALL_MATERIAL_AMOUNT*5, /datum/material/titanium =HALF_SHEET_MATERIAL_AMOUNT * 1.5)
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL_ALIEN
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/wirebrush
	name = "钢丝刷"
	desc = "一种用于清除墙壁上锈迹的工具。"
	id = "wirebrush"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	category = list(RND_CATEGORY_INITIAL, RND_CATEGORY_TOOLS)
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT * 2, /datum/material/glass =SMALL_MATERIAL_AMOUNT * 2)
	build_path = /obj/item/wirebrush
	category = list(RND_CATEGORY_TOOLS)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_JANITORIAL
	)

/datum/design/bolter_wrench
	name = "螺栓扳手"
	desc = "一种无论电源状态如何都能卸下气闸门螺栓的扳手。"
	id = "bolter_wrench"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/wrench/bolter
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING_ADVANCED
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/shuttle_blueprints
	name = "穿梭机蓝图"
	desc = "适用于建造穿梭机的蓝图"
	id = "shuttle_blueprints"
	build_type = PROTOLATHE
	materials = list(/datum/material/plastic = HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/shuttle_blueprints
	category = list(RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/shuttle_remote
	name = "穿梭机遥控器"
	desc = "一个遥控器，一旦连接到导航控制台，就可以发送穿梭机离开或尝试对接。"
	id = "shuttle_remote"
	build_type = PROTOLATHE
	build_path = /obj/item/shuttle_remote
	materials = list(/datum/material/gold = SHEET_MATERIAL_AMOUNT, /datum/material/bluespace = HALF_SHEET_MATERIAL_AMOUNT, /datum/material/iron = SMALL_MATERIAL_AMOUNT * 2, /datum/material/glass = SMALL_MATERIAL_AMOUNT)
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING
