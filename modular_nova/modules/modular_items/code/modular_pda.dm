/*
PDA GALORE!
*/

/obj/item/modular_computer/pda/ancient
	name = "老式PDA"
	desc = "一块塑料制品，看起来是全新制造的，但设计仿照了更老型号的设备。"
	icon = 'modular_nova/master_files/icons/obj/devices/modular_pda.dmi'
	icon_state = "/obj/item/modular_computer/pda/ancient"
	post_init_icon_state = "pda"

	greyscale_config = /datum/greyscale_config/tablet/nova
	greyscale_colors = "#5f5f5f#969696"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/modular_computer/pda/ultraslim
	name = "超薄型PDA"
	desc = "一款新型号的PDA，看起来只有一半大小……可惜它看起来比其他型号更脆弱。尽量别摔了它。"
	icon = 'modular_nova/master_files/icons/obj/devices/modular_pda.dmi'
	icon_state = "/obj/item/modular_computer/pda/ultraslim"
	post_init_icon_state = "pda"
	max_integrity = 50

	greyscale_config = /datum/greyscale_config/tablet/nova/ultraslim
	greyscale_colors = "#5f5f5f#969696"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/modular_computer/pda/ceti
	name = "塞提PDA"
	desc = "一款在边疆空间深处制造的PDA，通常在HC（人类殖民地）普遍使用，这款PDA是为持久耐用而打造的。"
	icon = 'modular_nova/master_files/icons/obj/devices/modular_pda.dmi'
	icon_state = "/obj/item/modular_computer/pda/ceti"
	post_init_icon_state = "pda"
	max_integrity = 200

	greyscale_config = /datum/greyscale_config/tablet/nova/ceti
	greyscale_colors = "#5f5f5f#969696"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/modular_computer/pda/virtual
	name = "虚拟PDA"
	desc = "一款还算有用的PDA，上面的防撞缓冲垫不怎么样，不过不清楚它为何被称为“虚拟”。"
	icon = 'modular_nova/master_files/icons/obj/devices/modular_pda.dmi'
	icon_state = "/obj/item/modular_computer/pda/virtual"
	post_init_icon_state = "pda"
	max_integrity = 125

	greyscale_config = /datum/greyscale_config/tablet/nova/virtual
	greyscale_colors = "#5f5f5f#969696"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/modular_computer/pda/robust
	name = "\improper 弹震症PDA"
	desc = "一款仿照人类古老诺基亚手机制造的PDA，这款PDA构造坚固，能承受大多数击打"
	icon = 'modular_nova/master_files/icons/obj/devices/modular_pda.dmi'
	icon_state = "/obj/item/modular_computer/pda/robust"
	post_init_icon_state = "pda"
	max_integrity = 250 // DAMN THAT IS PRETTY GOOD

	greyscale_config = /datum/greyscale_config/tablet/nova/robust
	greyscale_colors = "#5f5f5f#969696"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/modular_computer/pda/neko
	name = "Neko PDA"
	desc = "这东西是对某种事物的冒犯。"
	icon = 'modular_nova/master_files/icons/obj/devices/modular_pda.dmi'
	icon_state = "/obj/item/modular_computer/pda/neko"
	post_init_icon_state = "pda"

	greyscale_config = /datum/greyscale_config/tablet/nova/neko
	greyscale_colors = "#5f5f5f#969696"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/modular_computer/pda/old
	name = "过时PDA"
	desc = "这款PDA来自一个已逝的时代，仍然有用，构造坚固……可能因为其老旧部件而速度不那么快。"
	icon = 'modular_nova/master_files/icons/obj/devices/modular_pda.dmi'
	icon_state = "/obj/item/modular_computer/pda/old"
	post_init_icon_state = "pda"

	greyscale_config = /datum/greyscale_config/tablet/nova/outdated
	greyscale_colors = "#5f5f5f#969696"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/modular_computer/pda/holodeck
	name = "全息甲板PDA"
	desc = "一款还算不错的PDA，使用全息技术作为其显示屏。"
	icon = 'modular_nova/master_files/icons/obj/devices/modular_pda.dmi'
	icon_state = "/obj/item/modular_computer/pda/holodeck"
	post_init_icon_state = "pda"

	greyscale_config = /datum/greyscale_config/tablet/nova/holodeck
	greyscale_colors = "#5f5f5f#969696"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/modular_computer/pda/hologram
	name = "全息PDA"
	desc = "一款相当脆弱的PDA设备，采用全息技术构建，用于显示数据和信息。"
	icon = 'modular_nova/master_files/icons/obj/devices/modular_pda.dmi'
	icon_state = "/obj/item/modular_computer/pda/hologram"
	post_init_icon_state = "pda"
	max_integrity = 50

	greyscale_config = /datum/greyscale_config/tablet/nova/hologram
	greyscale_colors = "#5f5f5f#969696"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/modular_computer/pda/tablet
	name = "平板PDA"
	desc = "一种小众的PDA类型，据说你能听到有人问你在上面有没有游戏。"
	icon = 'modular_nova/master_files/icons/obj/devices/modular_pda.dmi'
	icon_state = "/obj/item/modular_computer/pda/tablet"
	post_init_icon_state = "pda"

	greyscale_config = /datum/greyscale_config/tablet/nova/tablet
	greyscale_colors = "#5f5f5f#969696"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/modular_computer/pda/slimline
	name = "纤薄PDA"
	desc = "一款更加纤薄、便携的微型计算机"
	icon = 'modular_nova/master_files/icons/obj/devices/modular_pda.dmi'
	icon_state = "/obj/item/modular_computer/pda/slimline"
	post_init_icon_state = "pda"

	greyscale_config = /datum/greyscale_config/tablet/nova/slimline
	greyscale_colors = "#5f5f5f#969696"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/modular_computer/pda/rugged
	name = "坚固型PDA"
	desc = "一款更加坚固耐用、做工精良的便携式微型计算机。"
	icon = 'modular_nova/master_files/icons/obj/devices/modular_pda.dmi'
	icon_state = "/obj/item/modular_computer/pda/rugged"
	post_init_icon_state = "pda"
	max_integrity = 150

	greyscale_config = /datum/greyscale_config/tablet/nova/rugged
	greyscale_colors = "#5f5f5f#969696"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/modular_computer/pda/g3
	name = "\improper G3 PDA"
	desc = "一款独特的便携式微型计算机设计。"
	icon = 'modular_nova/master_files/icons/obj/devices/modular_pda.dmi'
	icon_state = "/obj/item/modular_computer/pda/g3"
	post_init_icon_state = "pda"
	max_integrity = 50

	greyscale_config = /datum/greyscale_config/tablet/nova/g3
	greyscale_colors = "#5f5f5f#969696"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/modular_computer/pda/holosystem
	name = "全息系统PDA"
	desc = "一款全息便携式微型计算机。"
	icon = 'modular_nova/master_files/icons/obj/devices/modular_pda.dmi'
	icon_state = "/obj/item/modular_computer/pda/holosystem"
	post_init_icon_state = "pda"
	max_integrity = 50

	greyscale_config = /datum/greyscale_config/tablet/nova/holosystem
	greyscale_colors = "#5f5f5f#969696"
	flags_1 = IS_PLAYER_COLORABLE_1
