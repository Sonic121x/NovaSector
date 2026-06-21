/obj/item/disk/neuroware/camphor
	name = "\improper 爱神宁神经软件"
	desc = "一块包含爱神宁的神经软件芯片，这是一种基础的“抗催情剂”模拟程序，能降低性欲。这不是催情剂。包含多用户许可。"
	list_reagents = list(/datum/reagent/drug/aphrodisiac/camphor/synth = 15)
	icon_state = "/obj/item/disk/neuroware/camphor"
	post_init_icon_state = "chip_nolewd"
	greyscale_colors = "#eeeeee"
	uses = 4
	is_lewd = TRUE
	obj_flags_nova = ERP_ITEM

/obj/item/disk/neuroware/pentacamphor
	name = "\improper 无欲极速神经软件"
	desc = "一块包含无欲极速的神经软件芯片，这是一种非常强效的“抗催情剂”模拟程序，能极度降低性欲。过载可能导致系统损坏。包含多用户许可。"
	list_reagents = list(/datum/reagent/drug/aphrodisiac/camphor/pentacamphor/synth = 15)
	icon_state = "/obj/item/disk/neuroware/pentacamphor"
	post_init_icon_state = "chip_nolewd"
	greyscale_colors = "#474747"
	uses = 4
	is_lewd = TRUE
	obj_flags_nova = ERP_ITEM

/obj/item/disk/neuroware/crocin
	name = "\improper 爱欲刺激神经软件"
	desc = "一块包含爱欲刺激的神经软件芯片，这是一种基础的催情剂模拟程序，能增强性欲。包含多用户许可。"
	list_reagents = list(/datum/reagent/drug/aphrodisiac/crocin/synth = 15)
	icon_state = "/obj/item/disk/neuroware/crocin"
	post_init_icon_state = "chip_lewd"
	greyscale_colors = "#784abc"
	uses = 4
	is_lewd = TRUE
	obj_flags_nova = ERP_ITEM

/obj/item/disk/neuroware/hexacrocin
	name = "\improper 爱欲刺激豪华版神经软件"
	desc = "一块包含爱欲刺激豪华版的神经软件芯片，这是爱欲刺激催情剂模拟程序的一个极其强效且易上瘾的版本。成瘾戒断或过载可能导致系统损坏。包含多用户许可。"
	list_reagents = list(/datum/reagent/drug/aphrodisiac/crocin/hexacrocin/synth = 15)
	icon_state = "/obj/item/disk/neuroware/hexacrocin"
	post_init_icon_state = "chip_lewd"
	greyscale_colors = CIRCUIT_COLOR_SECURITY
	uses = 4
	is_lewd = TRUE
	obj_flags_nova = ERP_ITEM
