/*Power cells are in code\modules\power\cell.dm

If you create T5+ please take a pass at mech_fabricator.dm. The parts being good enough allows it to go into minus values and create materials out of thin air when printing stuff.*/

/obj/item/stock_parts
	name = "stock part"
	desc = "What?"
	icon = 'icons/obj/devices/stock_parts.dmi'
	///The generic category type that the stock part belongs to.  Generic objects that should not be instantiated should have the same type and abstract_type
	abstract_type = /obj/item/stock_parts
	w_class = WEIGHT_CLASS_SMALL
	sound_vary = TRUE
	pickup_sound = SFX_GENERIC_DEVICE_PICKUP
	drop_sound = SFX_GENERIC_DEVICE_DROP
	var/rating = 1
	///Used when a base part has a different name to higher tiers of part. For example, machine frames want any servo and not just a micro-servo.
	var/base_name
	var/energy_rating = 1

/obj/item/stock_parts/Initialize(mapload)
	. = ..()
	pixel_x = base_pixel_x + rand(-5, 5)
	pixel_y = base_pixel_y + rand(-5, 5)

/obj/item/stock_parts/get_part_rating()
	return rating

//Rating 1

/obj/item/stock_parts/capacitor
	name = "电容器"
	desc = "一种基本的电容器，被广泛应用于各类设备的制造中。"
	icon_state = "capacitor"
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*0.5, /datum/material/glass=SMALL_MATERIAL_AMOUNT*0.5)

/obj/item/stock_parts/scanning_module
	name = "扫描模块"
	desc = "一种紧凑型、高分辨率的扫描模块，用于某些设备的制造过程中。"
	icon_state = "scan_module"
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*0.5, /datum/material/glass=SMALL_MATERIAL_AMOUNT*0.2)

/obj/item/stock_parts/servo
	name = "micro-servo"
	desc = "A tiny little servo motor used in the construction of certain devices."
	icon_state = "micro_servo"
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*0.3)
	base_name = "servo"

/obj/item/stock_parts/micro_laser
	name = "微型-镭射"
	desc = "一种用于某些设备的小型镭射发生器。"
	icon_state = "micro_laser"
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*0.1, /datum/material/glass=SMALL_MATERIAL_AMOUNT*0.2)

/obj/item/stock_parts/matter_bin
	name = "物质仓"
	desc = "一个用于存放待重新组装的压缩物质的容器。"
	icon_state = "matter_bin"
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*0.8)

//Rating 2

/obj/item/stock_parts/capacitor/adv
	name = "高级电容器"
	desc = "一种先进的电容器，被广泛应用于各类设备的制造中。"
	icon_state = "adv_capacitor"
	rating = 2
	energy_rating = 3
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*0.5, /datum/material/glass=SMALL_MATERIAL_AMOUNT*0.5)

/obj/item/stock_parts/scanning_module/adv
	name = "高级扫描模块"
	desc = "A compact, high resolution scanning module used in the construction of certain devices."
	icon_state = "adv_scan_module"
	rating = 2
	energy_rating = 3
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*0.5, /datum/material/glass=SMALL_MATERIAL_AMOUNT*0.2)

/obj/item/stock_parts/servo/nano
	name = "nano-servo"
	desc = "A tiny little servo motor used in the construction of certain devices."
	icon_state = "nano_servo"
	rating = 2
	energy_rating = 3
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*0.3)

/obj/item/stock_parts/micro_laser/high
	name = "高功率微型-镭射"
	desc = "A tiny laser used in certain devices."
	icon_state = "high_micro_laser"
	rating = 2
	energy_rating = 3
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*0.1, /datum/material/glass=SMALL_MATERIAL_AMOUNT*0.2)

/obj/item/stock_parts/matter_bin/adv
	name = "高级物质仓"
	desc = "A container designed to hold compressed matter awaiting reconstruction."
	icon_state = "advanced_matter_bin"
	rating = 2
	energy_rating = 3
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*0.8)

//Rating 3

/obj/item/stock_parts/capacitor/super
	name = "超级电容器"
	desc = "一种超大容量的电容器，用于各类设备的制造。"
	icon_state = "super_capacitor"
	rating = 3
	energy_rating = 5
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*0.5, /datum/material/glass=SMALL_MATERIAL_AMOUNT*0.5)

/obj/item/stock_parts/scanning_module/phasic
	name = "相位扫描模块"
	desc = "一种紧凑型、高分辨率的脉冲扫描模块，用于某些设备的制造。"
	icon_state = "super_scan_module"
	rating = 3
	energy_rating = 5
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*0.5, /datum/material/glass=SMALL_MATERIAL_AMOUNT*0.2)

/obj/item/stock_parts/servo/pico
	name = "pico-servo"
	desc = "A tiny little servo motor used in the construction of certain devices."
	icon_state = "pico_servo"
	rating = 3
	energy_rating = 5
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*0.3)

/obj/item/stock_parts/micro_laser/ultra
	name = "超功率微型-镭射"
	icon_state = "ultra_high_micro_laser"
	desc = "A tiny laser used in certain devices."
	rating = 3
	energy_rating = 5
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*0.1, /datum/material/glass=SMALL_MATERIAL_AMOUNT*0.2)

/obj/item/stock_parts/matter_bin/super
	name = "高级物质仓"
	desc = "A container designed to hold compressed matter awaiting reconstruction."
	icon_state = "super_matter_bin"
	rating = 3
	energy_rating = 5
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*0.8)

//Rating 4

/obj/item/stock_parts/capacitor/quadratic
	name = "二次电容器"
	desc = "一种用于多种设备制造过程中的电容元件。"
	icon_state = "quadratic_capacitor"
	rating = 4
	energy_rating = 10
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*0.5, /datum/material/glass=SMALL_MATERIAL_AMOUNT*0.5)

/obj/item/stock_parts/scanning_module/triphasic
	name = "三相扫描模块"
	desc = "一种紧凑型、超高分辨率的三相扫描模块，被用于某些设备的制造。"
	icon_state = "triphasic_scan_module"
	rating = 4
	energy_rating = 10
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*0.5, /datum/material/glass=SMALL_MATERIAL_AMOUNT*0.2)

/obj/item/stock_parts/servo/femto
	name = "femto-servo"
	desc = "A tiny little servo motor used in the construction of certain devices."
	icon_state = "femto_servo"
	rating = 4
	energy_rating = 10
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*0.3)

/obj/item/stock_parts/micro_laser/quadultra
	name = "二次极微型-镭射"
	icon_state = "quadultra_micro_laser"
	desc = "A tiny laser used in certain devices."
	rating = 4
	energy_rating = 10
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*0.1, /datum/material/glass=SMALL_MATERIAL_AMOUNT*0.2)

/obj/item/stock_parts/matter_bin/bluespace
	name = "蓝空物质仓"
	desc = "A container designed to hold compressed matter awaiting reconstruction."
	icon_state = "bluespace_matter_bin"
	rating = 4
	energy_rating = 10
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*0.8)

// Subspace stock parts

/obj/item/stock_parts/subspace
	name = "subspace stock part"
	desc = "What?"
	abstract_type = /obj/item/stock_parts/subspace

/obj/item/stock_parts/subspace/ansible
	name = "子空间安塞波器"
	icon_state = "subspace_ansible"
	desc = "一个小巧的模块，能够探测到超维度活动。"
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*0.3, /datum/material/glass=SMALL_MATERIAL_AMOUNT*0.1)

/obj/item/stock_parts/subspace/filter
	name = "超波滤波器"
	icon_state = "hyperwave_filter"
	desc = "A tiny device capable of filtering and converting super-intense radio waves."
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*0.3, /datum/material/glass=SMALL_MATERIAL_AMOUNT*0.1)

/obj/item/stock_parts/subspace/amplifier
	name = "子空间放大器"
	icon_state = "subspace_amplifier"
	desc = "一种能够放大微弱子空间传输信号的紧凑型微型机器。"
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*0.3, /datum/material/glass=SMALL_MATERIAL_AMOUNT*0.1)

/obj/item/stock_parts/subspace/treatment
	name = "子空间处理磁盘"
	icon_state = "treatment_disk"
	desc = "一种能够拉伸超压缩无线电波的紧凑型微型机器。"
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*0.3, /datum/material/glass=SMALL_MATERIAL_AMOUNT*0.1)

/obj/item/stock_parts/subspace/analyzer
	name = "子空间波长分析仪"
	icon_state = "wavelength_analyzer"
	desc = "一种能够分析神秘子空间波长的精密分析仪。"
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*0.3, /datum/material/glass=SMALL_MATERIAL_AMOUNT*0.1)

/obj/item/stock_parts/subspace/crystal
	name = "安塞波晶体"
	icon_state = "ansible_crystal"
	desc = "一种由纯玻璃制成的晶体，用于向亚空间传输激光数据脉冲。"
	custom_materials = list(/datum/material/glass=SMALL_MATERIAL_AMOUNT*0.5)

/obj/item/stock_parts/subspace/transmitter
	name = "子空间发射机"
	icon_state = "subspace_transmitter"
	desc = "用于打开通往亚空间维度窗口的大型设备。"
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*0.5)

// Misc. Parts

/obj/item/stock_parts/card_reader
	name = "读卡器"
	icon_state = "card_reader"
	desc = "一个小型的磁卡读取器，用于接收和传输信用点的设备使用。"
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*0.5, /datum/material/glass=SMALL_MATERIAL_AMOUNT*0.1)

/obj/item/stock_parts/water_recycler
	name = "水回收器"
	icon_state = "water_recycler"
	desc = "A chemical reclamation component, which serves to re-accumulate and filter water over time."
	custom_materials = list(/datum/material/plastic=SMALL_MATERIAL_AMOUNT * 2, /datum/material/iron=SMALL_MATERIAL_AMOUNT*0.5)

/obj/item/research//Makes testing much less of a pain -Sieve
	name = "研究"
	icon = 'icons/obj/devices/stock_parts.dmi'
	icon_state = "capacitor"
	desc = "用于研究的调试物品"
