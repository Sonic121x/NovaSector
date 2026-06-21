/obj/machinery/nuclearbomb/selfdestruct
	name = "空间站自毁终端"
	desc = "当一切都变得忍无可忍时。不要挑衅。"
	icon = 'icons/obj/machines/nuke_terminal.dmi'
	icon_state = "nuclearbomb_base"
	anchored = TRUE //stops it being moved

/obj/machinery/nuclearbomb/selfdestruct/set_anchor()
	return

/obj/machinery/nuclearbomb/selfdestruct/toggle_nuke_safety()
	. = ..()
	if(timing)
		SSmapping.add_nuke_threat(src)
	else
		SSmapping.remove_nuke_threat(src)

/obj/machinery/nuclearbomb/selfdestruct/toggle_nuke_armed()
	. = ..()
	if(timing)
		SSmapping.add_nuke_threat(src)
	else
		SSmapping.remove_nuke_threat(src)
