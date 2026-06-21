/obj/machinery/modular_computer/preset
	///List of programs the computer starts with, given on Initialize.
	var/list/datum/computer_file/starting_programs = list()

/obj/machinery/modular_computer/preset/Initialize(mapload)
	. = ..()
	if(!cpu)
		return

	for(var/programs in starting_programs)
		var/datum/computer_file/program_type = new programs
		cpu.store_file(program_type)

// ===== ENGINEERING CONSOLE =====
/obj/machinery/modular_computer/preset/engineering
	name = "工程控制台"
	desc = "一台固定式计算机。此设备预装了工程程序。"
	starting_programs = list(
		/datum/computer_file/program/power_monitor,
		/datum/computer_file/program/alarm_monitor,
		/datum/computer_file/program/supermatter_monitor,
	)

// ===== RESEARCH CONSOLE =====
/obj/machinery/modular_computer/preset/research
	name = "研究主管控制台"
	desc = "一台固定的计算机。这台电脑已预先安装了各类研究程序。"
	starting_programs = list(
		/datum/computer_file/program/ntnetmonitor,
		/datum/computer_file/program/chatclient,
		/datum/computer_file/program/ai_restorer,
		/datum/computer_file/program/robocontrol,
		/datum/computer_file/program/scipaper_program,
	)

/obj/machinery/modular_computer/preset/research/away
	name = "旧研究控制台"
	desc = "一台用于撰写研究论文的旧电脑。"
	starting_programs = list(
		/datum/computer_file/program/scipaper_program,
	)

/obj/machinery/modular_computer/preset/research/away/Initialize(mapload)
	. = ..()
	cpu.device_theme = PDA_THEME_RETRO

// ===== COMMAND CONSOLE =====
/obj/machinery/modular_computer/preset/command
	name = "指挥控制台"
	desc = "一台固定的计算机。这台计算机预装了命令程序。"
	starting_programs = list(
		/datum/computer_file/program/chatclient,
		/datum/computer_file/program/card_mod,
	)

// ===== IDENTIFICATION CONSOLE =====
/obj/machinery/modular_computer/preset/id
	name = "身份识别控制台"
	desc = "一台固定式计算机.这台计算机预装了身份修改程序."
	starting_programs = list(
		/datum/computer_file/program/chatclient,
		/datum/computer_file/program/card_mod,
		/datum/computer_file/program/job_management,
		/datum/computer_file/program/crew_manifest,
	)

/obj/machinery/modular_computer/preset/id/centcom
	desc = "一台固定式计算机。这台设备预装了中央指挥部的身份识别修改程序。"

/obj/machinery/modular_computer/preset/id/centcom/Initialize(mapload)
	. = ..()
	var/datum/computer_file/program/card_mod/card_mod_centcom = cpu.find_file_by_name("plexagonidwriter")
	card_mod_centcom.is_centcom = TRUE

// ===== CIVILIAN CONSOLE =====
/obj/machinery/modular_computer/preset/civilian
	name = "民用控制台"
	desc = "一台固定式计算机。这台电脑已预先安装了通用程序。"
	starting_programs = list(
		/datum/computer_file/program/chatclient,
		/datum/computer_file/program/arcade,
	)

// curator
/obj/machinery/modular_computer/preset/curator
	name = "馆长控制台"
	desc = "一台固定式计算机。这台计算机预装了文学及艺术程序。"
	starting_programs = list(
		/datum/computer_file/program/portrait_printer,
	)

// ===== CARGO CHAT CONSOLES =====
/obj/machinery/modular_computer/preset/cargochat
	name = "货运交互控制台"
	desc = "一台预装了与货运部门交互软件的固定式电脑。"
	starting_programs = list(
		/datum/computer_file/program/chatclient,
	)
	/// What department type is assigned to this console?
	var/datum/job_department/department_type

/obj/machinery/modular_computer/preset/cargochat/Initialize(mapload)
	add_starting_software()
	. = ..()
	setup_starting_software()
	REGISTER_REQUIRED_MAP_ITEM(1, 1)
	if(department_type)
		name = "[LOWER_TEXT(initial(department_type.department_name))] [name]"
		cpu.name = name

/obj/machinery/modular_computer/preset/cargochat/proc/add_starting_software()
	starting_programs += /datum/computer_file/program/department_order

/obj/machinery/modular_computer/preset/cargochat/proc/setup_starting_software()
	if(!department_type)
		return

	var/datum/computer_file/program/chatclient/chatprogram = cpu.find_file_by_name("ntnrc_client")
	chatprogram.username = "[LOWER_TEXT(initial(department_type.department_name))]_department"
	cpu.idle_threads += chatprogram

	var/datum/computer_file/program/department_order/orderprogram = cpu.find_file_by_name("dept_order")
	orderprogram.set_linked_department(department_type)
	cpu.active_program = orderprogram
	update_appearance(UPDATE_ICON)

/obj/machinery/modular_computer/preset/cargochat/service
	department_type = /datum/job_department/service

/obj/machinery/modular_computer/preset/cargochat/engineering
	department_type = /datum/job_department/engineering

/obj/machinery/modular_computer/preset/cargochat/science
	department_type = /datum/job_department/science

/obj/machinery/modular_computer/preset/cargochat/security
	department_type = /datum/job_department/security

/obj/machinery/modular_computer/preset/cargochat/medical
	department_type = /datum/job_department/medical

/obj/machinery/modular_computer/preset/cargochat/cargo
	department_type = /datum/job_department/cargo
	name = "部门交互控制台"
	desc = "一台预装了用于处理各部门货运请求交互软件的固定式电脑。"

/obj/machinery/modular_computer/preset/cargochat/cargo/add_starting_software()
	starting_programs += /datum/computer_file/program/bounty_board
	starting_programs += /datum/computer_file/program/budgetorders
	starting_programs += /datum/computer_file/program/shipping
	starting_programs += /datum/computer_file/program/restock_tracker

/obj/machinery/modular_computer/preset/cargochat/cargo/setup_starting_software()
	var/datum/computer_file/program/chatclient/chatprogram = cpu.find_file_by_name("ntnrc_client")
	cpu.active_program = chatprogram
	update_appearance(UPDATE_ICON)
	// Rest of the chat program setup is done in LateInit

/obj/machinery/modular_computer/preset/cargochat/cargo/post_machine_initialize()
	. = ..()
	var/datum/computer_file/program/chatclient/chatprogram = cpu.find_file_by_name("ntnrc_client")
	chatprogram.username = "cargo_requests_operator"

	var/datum/ntnet_conversation/cargochat = chatprogram.create_new_channel("#cargobus", strong = TRUE)
	for(var/obj/machinery/modular_computer/preset/cargochat/cargochat_console as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/modular_computer/preset/cargochat))
		if(cargochat_console == src)
			continue
		var/datum/computer_file/program/chatclient/other_chatprograms = cargochat_console.cpu.find_file_by_name("ntnrc_client")
		other_chatprograms.active_channel = chatprogram.active_channel
		cargochat.add_client(other_chatprograms, silent = TRUE)
