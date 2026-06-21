///////////////////////////////////
/////Subspace Telecomms////////////
///////////////////////////////////

/datum/design/board/subspace_receiver
	name = "子空间接收器电路板"
	desc = "允许构建子空间接收器。"
	id = "s_receiver"
	build_path = /obj/item/circuitboard/machine/telecomms/receiver
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_TELECOMMS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/telecomms_bus
	name = "总线主机电路板"
	desc = "允许构建电信总线主机。"
	id = "s_bus"
	build_path = /obj/item/circuitboard/machine/telecomms/bus
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_TELECOMMS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/telecomms_hub
	name = "主机枢纽电路板"
	desc = "允许构建主机枢纽。"
	id = "s_hub"
	build_path = /obj/item/circuitboard/machine/telecomms/hub
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_TELECOMMS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/telecomms_relay
	name = "中继主机电路板"
	desc = "允许构建电信中继主机。"
	id = "s_relay"
	build_path = /obj/item/circuitboard/machine/telecomms/relay
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_TELECOMMS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/telecomms_processor
	name = "处理器单元电路板"
	desc = "可用于构建电信处理单元。"
	id = "s_processor"
	build_path = /obj/item/circuitboard/machine/telecomms/processor
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_TELECOMMS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/telecomms_server
	name = "服务器主机电路板"
	desc = "允许构建电信服务器。"
	id = "s_server"
	build_path = /obj/item/circuitboard/machine/telecomms/server
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_TELECOMMS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/telecomms_messaging
	name = "发信服务器电路板"
	desc = "允许构建电信发信服务器。"
	id = "s_messaging"
	build_path = /obj/item/circuitboard/machine/telecomms/message_server
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_TELECOMMS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/subspace_broadcaster
	name = "子空间广播器电路板"
	desc = "允许构建子空间广播器。"
	id = "s_broadcaster"
	build_path = /obj/item/circuitboard/machine/telecomms/broadcaster
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_TELECOMMS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE
