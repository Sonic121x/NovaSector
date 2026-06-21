///One of the special items that spawns in the overwatch agent's room.
/obj/item/paper/fluff/overwatch
	name = "OVERWATCH NOTES #1"
	color = COLOR_RED
	desc = "A note from Syndicate leadership regarding your new job. You should read this!"
	default_raw_text = @{"恭喜！你被选为一次反纳米传讯自杀任务的唯一幸存者！
我们开玩笑的，这类任务的存活率通常高得反常。我想这充分说明了你的团队将要面对的是什么样的对手。
<br>
你被指派为执行此次行动的地面部队提供情报支持。
每位特工都配备了随身摄像头，你可以通过你的监视者摄像头控制台访问。
此外，我们还为你提供了访问空间站警报、摄像头以及远程控制渗透者穿梭机的电路板。
<br>
请随意布置你的工作场所。我们已经在你后方的房间里提供了工具和电路板。
<br>
狩猎愉快！"}

/obj/machinery/computer/security/overwatch
	name = "overwatch camera console"
	desc = "Allows you to view members of your operative team via their bodycam feeds. We call them 'bodycams', but they're actually a swarm of tiny, near-imperceptible camera drones that follow each target. \
		It is believed that adversaries either don't notice the drones, or avoid attacking them in hopes that they'll capture footage of their combat prowess against our operatives."
	icon_screen = "commsyndie"
	icon_keyboard = "syndie_key"
	network = list(OPERATIVE_CAMERA_NET)
	circuit = /obj/item/circuitboard/computer/overwatch

/obj/item/circuitboard/computer/overwatch
	name = "Overwatch Body Cameras"
	build_path = /obj/machinery/computer/security/overwatch
	greyscale_colors = CIRCUIT_COLOR_SECURITY

/obj/item/circuitboard/computer/syndicate_shuttle_docker
	name = "Shuttle Controller"
	build_path = /obj/machinery/computer/camera_advanced/shuttle_docker/syndicate
	greyscale_colors = CIRCUIT_COLOR_SECURITY

/obj/item/clothing/glasses/overwatch
	name = "intelligence glasses"
	desc = "A set of incredibly advanced sunglasses, providing you with an array of different sensor scans and visual readouts for pretty much anything you look at. \
		It's kind of overwhelming, actually. Wearing this for a few hours will probably give you a migrane."
	icon_state = "sunhudmed"
	flags_cover = GLASSESCOVERSEYES
	flash_protect = FLASH_PROTECTION_WELDER
	clothing_traits = list(TRAIT_REAGENT_SCANNER, TRAIT_SECURITY_HUD, TRAIT_MEDICAL_HUD, TRAIT_DIAGNOSTIC_HUD)
