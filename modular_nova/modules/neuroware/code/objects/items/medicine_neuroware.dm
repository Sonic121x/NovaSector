// Removes all reagents which were added by neuroware chips.
/obj/item/disk/neuroware/reset
	name = "系统重置神经软件"
	desc = "一块包含系统重置程序的神经软件芯片，能停止并删除所有已安装的神经软件。包含多用户许可。"
	icon_state = "/obj/item/disk/neuroware/reset"
	post_init_icon_state = "chip_deforest"
	greyscale_colors = "#474747"
	list_reagents = list(/datum/reagent/medicine/reset_neuroware = 15)
	manufacturer_tag = NEUROWARE_DEFOREST
	success_message = "neuroware reset"
	uses = 3

/obj/item/disk/neuroware/brain
	name = "损坏修复神经软件"
	desc = "一块包含损坏修复程序的神经软件芯片，能尝试修复轻微的脑部创伤。包含多用户许可。"
	icon_state = "/obj/item/disk/neuroware/brain"
	post_init_icon_state = "chip_super"
	greyscale_colors = "#474747"
	list_reagents = list(/datum/reagent/medicine/brain_neuroware = 15)
	manufacturer_tag = NEUROWARE_DEFOREST
	uses = 3

/obj/item/disk/neuroware/synaptizine
	name = "\improper 突触调谐专家版神经软件"
	desc = "一块包含突触调谐专家版的神经软件芯片，能减少困倦和幻觉，同时增强对击晕的抗性。包含多用户许可。"
	icon_state = "/obj/item/disk/neuroware/synaptizine"
	post_init_icon_state = "chip_zenghu"
	greyscale_colors = "#474747"
	list_reagents = list(/datum/reagent/medicine/synaptizine/synth = 15)
	manufacturer_tag = NEUROWARE_ZENGHU
	uses = 2

/obj/item/disk/neuroware/psicodine
	name = "\improper 禅意急救神经软件"
	desc = "一块包含禅意急救的神经软件芯片，这是一种“情绪急救包”，能抑制焦虑和精神困扰。包含多用户许可。"
	icon_state = "/obj/item/disk/neuroware/psicodine"
	post_init_icon_state = "chip_zenghu"
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	list_reagents = list(/datum/reagent/medicine/psicodine/synth = 15)
	manufacturer_tag = NEUROWARE_ZENGHU
	uses = 2

/obj/item/disk/neuroware/morphine
	name = "\improper 麻醉合成神经软件"
	desc = "一块包含麻醉合成的神经软件芯片，这是一种通用的麻醉程序，能阻断疼痛并导致昏迷。包含多用户许可。"
	icon_state = "/obj/item/disk/neuroware/morphine"
	post_init_icon_state = "chip_bishop"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	list_reagents = list(/datum/reagent/medicine/morphine/synth = 10)
	manufacturer_tag = NEUROWARE_BISHOP
	uses = 3

/obj/item/disk/neuroware/lidocaine
	name = "\improper NGesic神经软件"
	desc = "一块包含NGesic的神经软件芯片，这是一种“止痛药”镇痛程序，能阻断疼痛信号。包含多用户许可证。"
	icon_state = "/obj/item/disk/neuroware/lidocaine"
	post_init_icon_state = "chip_bishop"
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	list_reagents = list(/datum/reagent/medicine/lidocaine/synth = 10)
	manufacturer_tag = NEUROWARE_BISHOP
	uses = 3
