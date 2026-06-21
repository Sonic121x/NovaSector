///////////////////Computer Boards///////////////////////////////////

/datum/design/board
	name = "空项电路板"
	desc = "我保证这里面没有辛迪加的好东西！"
	build_type = IMPRINTER | AWAY_IMPRINTER
	materials = list(/datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT)

/datum/design/board/arcade_battle
	name = "战斗游戏机电路板"
	desc = "能够用于构建游戏机的电路板。"
	id = "arcade_battle"
	build_path = /obj/item/circuitboard/computer/arcade/battle
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_ENTERTAINMENT
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/board/orion_trail
	name = "猎户座小径电路板"
	desc = "允许建造用于组装新猎户座之旅机器的电路板。"
	id = "arcade_orion"
	build_path = /obj/item/circuitboard/computer/arcade/orion_trail
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_ENTERTAINMENT
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/board/seccamera
	name = "安保摄像头电路板"
	desc = "允许建造用于组装安保摄像头计算机的电路板。"
	id = "seccamera"
	build_path = /obj/item/circuitboard/computer/security
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/board/rdcamera
	name = "研究监控器电路板"
	desc = "允许建造用于组装研究摄像头计算机的电路板。"
	id = "rdcamera"
	build_path = /obj/item/circuitboard/computer/research
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/xenobiocamera
	name = "异种生物学控制台电路板"
	desc = "允许建造用于组装异种生物学摄像头计算机的电路板。"
	id = "xenobioconsole"
	build_path = /obj/item/circuitboard/computer/xenobiology
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/aiupload
	name = "AI上传电路板"
	desc = "允许建造用于组装AI上传控制台的电路板。"
	id = "aiupload"
	materials = list(/datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/gold =SHEET_MATERIAL_AMOUNT, /datum/material/diamond =SHEET_MATERIAL_AMOUNT, /datum/material/bluespace =SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/circuitboard/computer/aiupload
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_ROBOTICS
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/borgupload
	name = "赛博上传电路板"
	desc = "允许建造用于组装机械人上传控制台的电路板。"
	id = "borgupload"
	materials = list(/datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/gold =SHEET_MATERIAL_AMOUNT, /datum/material/diamond =SHEET_MATERIAL_AMOUNT, /datum/material/bluespace =SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/circuitboard/computer/borgupload
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_ROBOTICS
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/med_data
	name = "医疗记录电路板"
	desc = "允许制造用于构建医疗记录控制台的电路板。"
	id = "med_data"
	build_path = /obj/item/circuitboard/computer/med_data
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/board/operating
	name = "手术计算机电路板"
	desc = "允许建造用于构建手术计算机控制台的电路板。"
	id = "operating"
	build_path = /obj/item/circuitboard/computer/operating
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/pandemic
	name = "广域瘟.疫.病 2200 电路板"
	desc = "允许建造用于构建PanD.E.M.I.C. 2200控制台的电路板。"
	id = "pandemic"
	build_path = /obj/item/circuitboard/computer/pandemic
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/board/comconsole
	name = "通信电路板"
	desc = "允许建造用于构建通讯控制台的电路板。"
	id = "comconsole"
	build_path = /obj/item/circuitboard/computer/communications
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_COMMAND
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SECURITY //Honestly should have a bridge techfab for this sometime.

/datum/design/board/bankmachine
	name = "银行机器电路板"
	desc = "允许建造用于构建银行机器的电路板。"
	id = "bankmachine"
	build_path = /obj/item/circuitboard/computer/bankmachine
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_COMMAND
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SECURITY

/datum/design/board/crewconsole
	name = "乘员监控计算机电路板"
	desc = "允许建造用于构建乘员监控计算机的电路板。"
	id = "crewconsole"
	build_type = IMPRINTER
	build_path = /obj/item/circuitboard/computer/crew
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_MEDICAL

/datum/design/board/secdata
	name = "安保记录控制台电路板"
	desc = "允许建造用于构建安保记录控制台的电路板。"
	id = "secdata"
	build_path = /obj/item/circuitboard/computer/secure_data
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/board/atmosalerts
	name = "大气警报电路板"
	desc = "允许建造用于构建大气警报控制台的电路板。"
	id = "atmosalerts"
	build_path = /obj/item/circuitboard/computer/atmos_alert
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/atmos_control
	name = "大气监控器电路板"
	desc = "允许建造用于构建大气监测器的电路板。"
	id = "atmos_control"
	build_path = /obj/item/circuitboard/computer/atmos_control
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/robocontrol
	name = "机器人学控制台电路板"
	desc = "允许建造用于构建机器人控制台的电路板。"
	id = "robocontrol"
	materials = list(/datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/gold =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/silver =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/bluespace =SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/circuitboard/computer/robotics
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_ROBOTICS
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/slot_machine
	name = "老虎机电路板"
	desc = "允许建造用于构建新老虎机的电路板。"
	id = "slotmachine"
	build_path = /obj/item/circuitboard/computer/slot_machine
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_ENTERTAINMENT
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE


/datum/design/board/powermonitor
	name = "电力监控器电路板"
	desc = "允许制造用于构建电力监控器的电路板。"
	id = "powermonitor"
	build_path = /obj/item/circuitboard/computer/powermonitor
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/solarcontrol
	name = "太阳能控制器电路板"
	desc = "允许建造用于构建太阳能控制台的电路板。"
	id = "solarcontrol"
	build_path = /obj/item/circuitboard/computer/solar_control
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/prisonmanage
	name = "囚犯管理控制台电路板"
	desc = "允许制造用于构建囚犯管理控制台的电路板。"
	id = "prisonmanage"
	build_path = /obj/item/circuitboard/computer/prisoner
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/board/mechacontrol
	name = "外骨骼装甲控制台电路板"
	desc = "允许制造用于构建外骨骼装甲控制台的电路板。"
	id = "mechacontrol"
	build_path = /obj/item/circuitboard/computer/mecha_control
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_ROBOTICS
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/mechapower
	name = "机甲湾电源控制台电路板"
	desc = "允许制造用于构建机甲湾电源控制台的电路板。"
	id = "mechapower"
	build_path = /obj/item/circuitboard/computer/mech_bay_power_console
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_ROBOTICS
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/rdconsole
	name = "研发控制台电路板"
	desc = "允许制造用于构建研发控制台的电路板。"
	id = "rdconsole"
	build_path = /obj/item/circuitboard/computer/rdconsole
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/cargo
	name = "供应控制台电路板"
	desc = "允许制造用于构建供应控制台的电路板。"
	id = "cargo"
	build_type = IMPRINTER
	build_path = /obj/item/circuitboard/computer/cargo
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_CARGO
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO

/datum/design/board/cargorequest
	name = "供应请求控制台电路板"
	desc = "允许制造用于构建供应请求控制台的电路板。"
	id = "cargorequest"
	build_type = IMPRINTER
	build_path = /obj/item/circuitboard/computer/cargo/request
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_CARGO
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO

/datum/design/board/mining
	name = "前哨状态显示器电路板"
	desc = "允许制造用于构建前哨状态显示器的电路板。"
	id = "mining"
	build_path = /obj/item/circuitboard/computer/mining
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_CARGO
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SECURITY

/datum/design/board/comm_monitor
	name = "通信监控控制台电路板"
	desc = "允许制造用于构建通信监控控制台的电路板。"
	id = "comm_monitor"
	build_path = /obj/item/circuitboard/computer/comm_monitor
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/comm_server
	name = "通信服务器监控控制台电路板"
	desc = "允许制造用于构建通信服务器监控控制台的电路板。"
	id = "comm_server"
	build_path = /obj/item/circuitboard/computer/comm_server
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/message_monitor
	name = "通信监控控制台电路板"
	desc = "允许制造用于构建通信监控控制台的电路板。"
	id = "message_monitor"
	build_path = /obj/item/circuitboard/computer/message_monitor
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/aifixer
	name = "AI完整性恢复器电路板"
	desc = "允许制造用于构建AI完整性恢复器的电路板。"
	id = "aifixer"
	build_path = /obj/item/circuitboard/computer/aifixer
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_ROBOTICS
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/libraryconsole
	name = "图书馆控制台电路板"
	desc = "允许制造用于构建图书馆控制台的电路板。"
	id = "libraryconsole"
	build_path = /obj/item/circuitboard/computer/libraryconsole
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_ENTERTAINMENT
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/board/apc_control
	name = "APC控制台电路板"
	desc = "允许制造用于构建APC控制台的电路板。"
	id = "apc_control"
	build_path = /obj/item/circuitboard/computer/apc_control
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/advanced_camera
	name = "高级摄像头控制台电路板"
	desc = "允许制造用于构建高级摄像头控制台的电路板。"
	id = "advanced_camera"
	build_path = /obj/item/circuitboard/computer/advanced_camera
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/board/bountypad_control
	name = "民用赏金发射控制台电路板"
	desc = "允许制造用于构建民用赏金发射控制台的电路板。"
	id = "bounty_pad_control"
	build_path = /obj/item/circuitboard/computer/bountypad
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_CARGO
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO

/datum/design/board/exoscanner_console
	name = "扫描仪阵列控制台电路板"
	desc = "允许制造用于构建扫描仪阵列控制台的电路板。"
	id = "exoscanner_console"
	build_type = IMPRINTER
	build_path = /obj/item/circuitboard/computer/exoscanner_console
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/exodrone_console
	name = "勘探无人机控制台电路板"
	desc = "允许制造用于构建勘探无人机控制台的电路板。"
	id = "exodrone_console"
	build_type = IMPRINTER
	build_path = /obj/item/circuitboard/computer/exodrone_console
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/accounting_console
	name = "账户查询控制台电路板"
	desc = "允许制造用于构建账户查询控制台的电路板。"
	id = "account_console"
	build_type = IMPRINTER
	build_path = /obj/item/circuitboard/computer/accounting
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_COMMAND
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY //Honestly should have a bridge techfab for this sometime.

/datum/design/board/shuttle
	build_type = IMPRINTER
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_CARGO

/datum/design/board/shuttle/flight_control
	name = "计算机设计（穿梭机飞行控制）"
	desc = "允许建造用于构建启用穿梭机飞行的控制台的电路板"
	id = "shuttle_control"
	build_path = /obj/item/circuitboard/computer/shuttle/flight_control

/datum/design/board/shuttle/shuttle_docker
	name = "计算机设计（穿梭机导航计算机）"
	desc = "允许建造用于构建能够定位自定义飞行位置的控制台的电路板"
	id = "shuttle_docker"
	build_path = /obj/item/circuitboard/computer/shuttle/docker

/datum/design/board/quantum_console
	name = "量子控制台电路板"
	desc = "允许建造用于构建量子控制台的电路板。"
	id = "quantum_console"
	build_path = /obj/item/circuitboard/computer/quantum_console
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_CARGO
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING
