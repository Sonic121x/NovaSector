/obj/machinery/modular_computer/preset/time_clock
	name = "打卡钟"
	desc = "允许员工打卡上下班。比喻意义上的，不是字面意思……我希望如此。"
	icon = 'modular_nova/modules/plexagon_selfserve/icons/time_clock.dmi'
	density = FALSE
	light_color = LIGHT_COLOR_DARK_BLUE
	starting_programs = list(
		/datum/computer_file/program/crew_self_serve,
	)

	connectable = FALSE

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/modular_computer/preset/time_clock, 28)

/obj/machinery/modular_computer/preset/time_clock/Initialize(mapload)
	. = ..()
	SSticker.OnRoundstart(CALLBACK(src, PROC_REF(setup_starting_software)))

/obj/machinery/modular_computer/preset/time_clock/proc/setup_starting_software()
	var/datum/computer_file/program/crew_self_serve/punch_clock = cpu.find_file_by_name("plexagonselfserve")
	cpu.allow_chunky = TRUE // everyone should be able to use the punch clock
	cpu.active_program = punch_clock
	punch_clock.register_signals()
	set_light(light_strength)
