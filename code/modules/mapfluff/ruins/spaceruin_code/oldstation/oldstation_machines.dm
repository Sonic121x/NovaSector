/obj/machinery/computer/old
	name = "旧电脑"
	circuit = /obj/item/circuitboard/computer

/obj/machinery/computer/old/Initialize(mapload)
	icon_keyboard = pick("generic_key", "med_key")
	icon_screen = pick("generic", "comm_monitor", "comm_logs")
	return ..()
