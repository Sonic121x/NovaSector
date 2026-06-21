
/obj/machinery/computer/ert_control
	name = "舰队资产控制台"
	desc = "用于重新部署纳米传讯紧急响应资产的终端。"
	icon_screen = "comm"
	icon_keyboard = "tech_key"
	req_access = list(ACCESS_CENT_CAPTAIN)
	circuit = /obj/item/circuitboard/computer/communications
	light_color = LIGHT_COLOR_BLUE

/obj/item/circuitboard/computer/ert_control
	name = "舰队控制（电脑主板）"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/computer/ert_control

