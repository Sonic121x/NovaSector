/**
 * Command
 */
/obj/item/disk/computer/command
	icon_state = "datadisk7"
	max_capacity = 32
	///Static list of programss ALL command tablets have.
	var/static/list/datum/computer_file/command_programs = list(
		/datum/computer_file/program/science,
		/datum/computer_file/program/status,
	)

/obj/item/disk/computer/command/Initialize(mapload)
	. = ..()
	for(var/programs in command_programs)
		var/datum/computer_file/program/program_type = new programs
		add_file(program_type)

/obj/item/disk/computer/command/captain
	name = "舰长数据磁盘"
	desc = "用于下载舰长平板电脑必备应用的可移动磁盘。"
	icon_state = "datadisk10"
	starting_programs = list(
		/datum/computer_file/program/records/security,
		/datum/computer_file/program/records/medical,
	)

/obj/item/disk/computer/command/cmo
	name = "首席医疗官数据磁盘"
	desc = "用于下载首席医疗官平板电脑必备应用的可移动磁盘。"
	starting_programs = list(
		/datum/computer_file/program/records/medical,
	)

/obj/item/disk/computer/command/rd
	name = "研究主管数据磁盘"
	desc = "用于下载研究主管平板电脑必备应用的可移动磁盘。"
	starting_programs = list(
		/datum/computer_file/program/signal_commander,
	)

/obj/item/disk/computer/command/hos
	name = "安全主管数据磁盘"
	desc = "用于下载安全主管平板电脑必备应用程序的可移动磁盘。"
	icon_state = "datadisk9"
	starting_programs = list(
		/datum/computer_file/program/records/security,
	)

/obj/item/disk/computer/command/hop
	name = "人事主管数据磁盘"
	desc = "用于下载人事主管平板电脑必备应用程序的可移动磁盘。"
	starting_programs = list(
		/datum/computer_file/program/records/security,
		/datum/computer_file/program/job_management,
	)

/obj/item/disk/computer/command/ce
	name = "首席工程师数据磁盘"
	desc = "用于下载首席工程师平板电脑必备应用程序的可移动磁盘。"
	starting_programs = list(
		/datum/computer_file/program/supermatter_monitor,
		/datum/computer_file/program/atmosscan,
		/datum/computer_file/program/alarm_monitor,
	)

/**
 * Security
 */
/obj/item/disk/computer/security
	name = "安保干员数据盘"
	desc = "用于下载安保相关平板应用程序的可移动磁盘。"
	icon_state = "datadisk9"
	starting_programs = list(
		/datum/computer_file/program/records/security,
	)

/**
 * Medical
 */
/obj/item/disk/computer/medical
	name = "医疗医生数据磁盘"
	desc = "用于下载医疗相关平板应用程序的可移动磁盘。"
	icon_state = "datadisk7"
	starting_programs = list(
		/datum/computer_file/program/records/medical,
	)

/**
 * Supply
 */
/obj/item/disk/computer/quartermaster
	name = "货运数据磁盘"
	desc = "用于下载货运相关平板应用程序的可移动磁盘。"
	icon_state = "datadisk12"
	starting_programs = list(
		/datum/computer_file/program/shipping,
		/datum/computer_file/program/budgetorders,
		/datum/computer_file/program/restock_tracker,
	)

/**
 * Science
 */
/obj/item/disk/computer/ordnance
	name = "军械数据磁盘"
	desc = "用于下载军械相关平板应用程序的可移动磁盘。"
	icon_state = "datadisk5"
	starting_programs = list(
		/datum/computer_file/program/signal_commander,
		/datum/computer_file/program/scipaper_program,
	)

/**
 * Engineering
 */
/obj/item/disk/computer/engineering
	name = "工程数据磁盘"
	desc = "用于下载工程相关平板应用程序的可移动磁盘。"
	icon_state = "datadisk6"
	starting_programs = list(
		/datum/computer_file/program/alarm_monitor,
		/datum/computer_file/program/atmosscan,
		/datum/computer_file/program/supermatter_monitor,

	)

