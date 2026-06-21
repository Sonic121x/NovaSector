//WRENCHES//
/obj/item/wrench/advanced
	name = "高级扳手"
	desc = "一种使用与绑架者工具相同磁力技术的扳手，但效率稍低。它看起来是拼凑而成的。"
	icon = 'modular_nova/modules/mapping/icons/obj/items/advancedtools.dmi'
	icon_state = "wrench"
	usesound = 'sound/effects/empulse.ogg'
	toolspeed = 0.2

//WIRECUTTERS//
/obj/item/wirecutters/advanced
	name = "高级钢丝钳"
	desc = "一套仿制的外星钢丝钳，它们有银色的手柄和极其锋利的刀片。上面贴着一张标签，声明需要根据'最新样本'进行更新。"
	icon = 'modular_nova/modules/mapping/icons/obj/items/advancedtools.dmi'
	icon_state = "cutters"
	toolspeed = 0.2
	greyscale_config = null
	greyscale_config_inhand_left = null
	greyscale_config_inhand_right = null
	greyscale_colors = null
	random_color = FALSE

//WELDING TOOLS//
/obj/item/weldingtool/advanced
	name = "高级焊接工具"
	desc = "一种结合了现代实验性焊接工具与外星焊接工具生成方法的工具，它永远不会耗尽燃料，并且工作速度几乎一样快。"
	icon = 'modular_nova/modules/mapping/icons/obj/items/advancedtools.dmi'
	icon_state = "welder"
	toolspeed = 0.2
	light_system = NO_LIGHT_SUPPORT
	light_range = 0
	change_icons = 0

/obj/item/weldingtool/advanced/process()
	if(get_fuel() <= max_fuel)
		reagents.add_reagent(/datum/reagent/fuel, 1)
	..()

//SCREWDRIVERS//
/obj/item/screwdriver/advanced
	name = "高级螺丝刀"
	desc = "一把优雅的银色螺丝刀，配有外星合金尖端，其效果几乎与真品一样好。上面贴着一张标签，声明需要根据'最新样本'进行更新。"
	icon = 'modular_nova/modules/mapping/icons/obj/items/advancedtools.dmi'
	icon_state = "screwdriver_a"
	post_init_icon_state = null
	inhand_icon_state = "screwdriver_nuke"
	usesound = 'sound/items/pshoom/pshoom.ogg'
	toolspeed = 0.2
	random_color = FALSE
	greyscale_colors = null
	greyscale_config = null
	greyscale_config_inhand_left = null
	greyscale_config_inhand_right = null
	post_init_icon_state = null

//CROWBAR//
/obj/item/crowbar/advanced
	name = "高级撬棍"
	desc = "科学家对绑架者撬棍的一次几乎成功的仿制品，它使用了相同的技术，但配有一个无法完全握持的手柄。"
	icon = 'modular_nova/modules/mapping/icons/obj/items/advancedtools.dmi'
	usesound = 'sound/items/weapons/sonic_jackhammer.ogg'
	icon_state = "crowbar"
	toolspeed = 0.2

//MULTITOOLS//
/obj/item/multitool/advanced
	name = "高级多功能工具"
	desc = "The reproduction of an abductor's multitool, this multitool is a classy silver. There's a sticker attached declaring that it needs updating from 'the latest samples'."
	icon = 'modular_nova/modules/mapping/icons/obj/items/advancedtools.dmi'
	icon_state = "multitool"
	toolspeed = 0.2
