/////////////////// Xenobio Cam + control ///////////////////

/obj/machinery/computer/camera_advanced/xenobio/tarkon
	name = "塔康史莱姆管理控制台"
	desc = "一台用于远程处理史莱姆的计算机。安全第一。"
	networks = list("tarkon_xenob")
	circuit = /obj/item/circuitboard/computer/xenobiology/tarkon

/obj/item/circuitboard/computer/xenobiology/tarkon
	name = "塔康异种生物学控制台"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/computer/camera_advanced/xenobio/tarkon

/obj/machinery/camera/tarkon_xenob
	network = list("tarkon_xenob", "tarkon")
	dir = 4

/////////////////// Security Cam + control ///////////////////

/obj/machinery/computer/camera_advanced/tarkon_cam
	name = "塔康摄像头控制台"
	networks = list("tarkon")
	circuit = /obj/item/circuitboard/computer/tarkon_cam

/obj/item/circuitboard/computer/tarkon_cam
	name = "塔康摄像头控制台"
	build_path = /obj/machinery/computer/camera_advanced/tarkon_cam

/obj/machinery/camera/tarkon
	network = list("tarkon")

/obj/machinery/camera/autoname/tarkon
	network = list("tarkon")

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/camera/tarkon, 0)
MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/camera/autoname/tarkon, 0)
