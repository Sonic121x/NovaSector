////////////////////////////////////////
/////////////Stock Parts////////////////
////////////////////////////////////////

/datum/design/rped
	name = "快捷零件更换器"
	desc = "专门设计的机械模块，用于存储、分类和装配标准的机器零件。"
	id = "rped"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*5, /datum/material/glass =SHEET_MATERIAL_AMOUNT * 2.5)
	build_path = /obj/item/storage/part_replacer
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_EXCHANGERS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/bs_rped
	name = "蓝空RPED"
	desc = "借助蓝空技术，这种零件交换装置变体能够从远处对建筑物进行升级，无需先拆除防护面板。"
	id = "bs_rped"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*7.5, /datum/material/glass =SHEET_MATERIAL_AMOUNT * 2.5, /datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT*2.5)
	build_path = /obj/item/storage/part_replacer/bluespace
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_EXCHANGERS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

//Capacitors
/datum/design/basic_capacitor
	name = "初级电容器-Capacitor"
	desc = "一种在各类设备制造中使用的通用部件。"
	id = "basic_capacitor"
	build_type = PROTOLATHE | AWAY_LATHE | AUTOLATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT, /datum/material/glass =SMALL_MATERIAL_AMOUNT)
	build_path = /obj/item/stock_parts/capacitor
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_1
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/adv_capacitor
	name = "高级电容器-Capacitor"
	desc = "一种在各类设备制造中使用的通用部件。"
	id = "adv_capacitor"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT*1.5, /datum/material/glass = SMALL_MATERIAL_AMOUNT*1.5)
	build_path = /obj/item/stock_parts/capacitor/adv
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_2
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/super_capacitor
	name = "超级电容器-Capacitor"
	desc = "一种在各类设备制造中使用的通用部件。"
	id = "super_capacitor"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT * 2, /datum/material/glass =SMALL_MATERIAL_AMOUNT * 2, /datum/material/gold =SMALL_MATERIAL_AMOUNT)
	build_path = /obj/item/stock_parts/capacitor/super
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_3
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/quadratic_capacitor
	name = "二次电容器-Capacitor"
	desc = "一种在各类设备制造中使用的通用部件。"
	id = "quadratic_capacitor"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT * 2, /datum/material/glass =SMALL_MATERIAL_AMOUNT * 2, /datum/material/gold =SMALL_MATERIAL_AMOUNT, /datum/material/diamond =SMALL_MATERIAL_AMOUNT)
	build_path = /obj/item/stock_parts/capacitor/quadratic
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_4
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

//Scanning modules
/datum/design/basic_scanning
	name = "初级扫描模块-Scanning Module"
	desc = "一种在各类设备制造中使用的通用部件。"
	id = "basic_scanning"
	build_type = PROTOLATHE | AWAY_LATHE | AUTOLATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT, /datum/material/glass =SMALL_MATERIAL_AMOUNT*0.5)
	build_path = /obj/item/stock_parts/scanning_module
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_1
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/adv_scanning
	name = "高级扫描模块-Scanning Module"
	desc = "一种在各类设备制造中使用的通用部件。"
	id = "adv_scanning"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT*1.5, /datum/material/glass =SMALL_MATERIAL_AMOUNT)
	build_path = /obj/item/stock_parts/scanning_module/adv
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_2
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/phasic_scanning
	name = "相位扫描模块-Scanning Module"
	desc = "一种在各类设备制造中使用的通用部件。"
	id = "phasic_scanning"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT * 2, /datum/material/glass = SMALL_MATERIAL_AMOUNT*1.5, /datum/material/silver = SMALL_MATERIAL_AMOUNT*0.6)
	build_path = /obj/item/stock_parts/scanning_module/phasic
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_3
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/triphasic_scanning
	name = "三相扫描模块-Scanning Module"
	desc = "一种在各类设备制造中使用的通用部件。"
	id = "triphasic_scanning"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT * 2, /datum/material/glass =SMALL_MATERIAL_AMOUNT * 2, /datum/material/diamond = SMALL_MATERIAL_AMOUNT*0.3, /datum/material/bluespace = SMALL_MATERIAL_AMOUNT*0.5)
	build_path = /obj/item/stock_parts/scanning_module/triphasic
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_4
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

//Maipulators
/datum/design/micro_servo
	name = "微型伺服器"
	desc = "A stock part used in the construction of various devices."
	id = "micro_servo"
	build_type = PROTOLATHE | AWAY_LATHE | AUTOLATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT)
	build_path = /obj/item/stock_parts/servo
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_1
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/nano_servo
	name = "纳米伺服器"
	desc = "A stock part used in the construction of various devices."
	id = "nano_servo"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT*1.5)
	build_path = /obj/item/stock_parts/servo/nano
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_2
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/pico_servo
	name = "皮可伺服器"
	desc = "A stock part used in the construction of various devices."
	id = "pico_servo"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT * 2)
	build_path = /obj/item/stock_parts/servo/pico
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_3
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/femto_servo
	name = "飞托伺服器"
	desc = "A stock part used in the construction of various devices."
	id = "femto_servo"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT * 2, /datum/material/diamond = SMALL_MATERIAL_AMOUNT*0.3, /datum/material/titanium = SMALL_MATERIAL_AMOUNT*0.3)
	build_path = /obj/item/stock_parts/servo/femto
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_4
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

//Micro-lasers
/datum/design/basic_micro_laser
	name = "初级微型镭射-Micro Laser"
	desc = "一种在各类设备制造中使用的通用部件。"
	id = "basic_micro_laser"
	build_type = PROTOLATHE | AWAY_LATHE | AUTOLATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT, /datum/material/glass =SMALL_MATERIAL_AMOUNT*0.5)
	build_path = /obj/item/stock_parts/micro_laser
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_1
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/high_micro_laser
	name = "高功率微型镭射-Micro Laser"
	desc = "一种在各类设备制造中使用的通用部件。"
	id = "high_micro_laser"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT*1.5, /datum/material/glass =SMALL_MATERIAL_AMOUNT)
	build_path = /obj/item/stock_parts/micro_laser/high
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_2
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/ultra_micro_laser
	name = "超功率微型镭射-Micro Laser"
	desc = "一种在各类设备制造中使用的通用部件。"
	id = "ultra_micro_laser"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT * 2, /datum/material/glass = SMALL_MATERIAL_AMOUNT*1.5, /datum/material/uranium = SMALL_MATERIAL_AMOUNT*0.6)
	build_path = /obj/item/stock_parts/micro_laser/ultra
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_3
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/quadultra_micro_laser
	name = "二次极微型镭射-Micro Laser"
	desc = "一种在各类设备制造中使用的通用部件。"
	id = "quadultra_micro_laser"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT * 2, /datum/material/glass =SMALL_MATERIAL_AMOUNT * 2, /datum/material/uranium =SMALL_MATERIAL_AMOUNT, /datum/material/diamond = SMALL_MATERIAL_AMOUNT*0.6)
	build_path = /obj/item/stock_parts/micro_laser/quadultra
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_4
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/basic_matter_bin
	name = "初级物质仓-Matter Bin"
	desc = "一种在各类设备制造中使用的通用部件。"
	id = "basic_matter_bin"
	build_type = PROTOLATHE | AWAY_LATHE | AUTOLATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT)
	build_path = /obj/item/stock_parts/matter_bin
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_1
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/adv_matter_bin
	name = "高级物质仓-Matter Bin"
	desc = "一种在各类设备制造中使用的通用部件。"
	id = "adv_matter_bin"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT*1.5)
	build_path = /obj/item/stock_parts/matter_bin/adv
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_2
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/super_matter_bin
	name = "超级物质仓-Matter Bin"
	desc = "一种在各类设备制造中使用的通用部件。"
	id = "super_matter_bin"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT * 2)
	build_path = /obj/item/stock_parts/matter_bin/super
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_3
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/bluespace_matter_bin
	name = "蓝空物质仓-Matter Bin"
	desc = "一种在各类设备制造中使用的通用部件。"
	id = "bluespace_matter_bin"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT*2.5, /datum/material/diamond =SMALL_MATERIAL_AMOUNT, /datum/material/bluespace =SMALL_MATERIAL_AMOUNT)
	build_path = /obj/item/stock_parts/matter_bin/bluespace
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_4
	)
	lathe_time_factor = 0.2
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

//T-Comms devices
/datum/design/subspace_ansible
	name = "子空间安塞波器-Subspace Ansible"
	desc = "一个小巧的模块，能够探测到超维度活动。"
	id = "s_ansible"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT, /datum/material/silver =SMALL_MATERIAL_AMOUNT)
	build_path = /obj/item/stock_parts/subspace/ansible
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_TELECOMMS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/hyperwave_filter
	name = "超波滤波器-Hyperwave Filter"
	desc = "一种能够过滤并转换超强无线电波的微型设备。"
	id = "s_filter"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT, /datum/material/silver =SMALL_MATERIAL_AMOUNT)
	build_path = /obj/item/stock_parts/subspace/filter
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_TELECOMMS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/subspace_amplifier
	name = "子空间放大器-Subspace Amplifier"
	desc = "一种小巧的微型机器，能够增强微弱的子空间信号传输。"
	id = "s_amplifier"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT, /datum/material/gold =SMALL_MATERIAL_AMOUNT, /datum/material/uranium =SMALL_MATERIAL_AMOUNT)
	build_path = /obj/item/stock_parts/subspace/amplifier
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_TELECOMMS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/subspace_treatment
	name = "子空间处理磁盘"
	desc = "一种小巧的微型机器，能够将极度压缩的无线电波展开。"
	id = "s_treatment"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT, /datum/material/silver =SMALL_MATERIAL_AMOUNT * 2)
	build_path = /obj/item/stock_parts/subspace/treatment
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_TELECOMMS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/subspace_analyzer
	name = "子空间分析仪-Subspace Analyzer"
	desc = "一种功能先进的分析器，能够分析隐秘的子空间波长。"
	id = "s_analyzer"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT, /datum/material/gold =SMALL_MATERIAL_AMOUNT)
	build_path = /obj/item/stock_parts/subspace/analyzer
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_TELECOMMS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/subspace_crystal
	name = "安塞波晶体-Ansible Crystal"
	desc = "一种功能先进的分析器，能够分析隐秘的子空间波长。"
	id = "s_crystal"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/glass = SMALL_MATERIAL_AMOUNT*8, /datum/material/silver =SMALL_MATERIAL_AMOUNT, /datum/material/gold =SMALL_MATERIAL_AMOUNT)
	build_path = /obj/item/stock_parts/subspace/crystal
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_TELECOMMS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/subspace_transmitter
	name = "子空间发射机-Subspace Transmitter"
	desc = "一种大型设备，用于打开通往次空间维度的通道。"
	id = "s_transmitter"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/glass =SMALL_MATERIAL_AMOUNT, /datum/material/silver =SMALL_MATERIAL_AMOUNT, /datum/material/uranium =SMALL_MATERIAL_AMOUNT)
	build_path = /obj/item/stock_parts/subspace/transmitter
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_TELECOMMS
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/card_reader
	name = "读卡器-Card Reader"
	desc = "一个小型的磁卡读取器，用于接收和传输信用点的设备使用。"
	id = "c-reader"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*0.5, /datum/material/glass=SMALL_MATERIAL_AMOUNT*0.1)
	build_path = /obj/item/stock_parts/card_reader
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_MISC
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_CARGO

/datum/design/water_recycler
	name = "水回收器-Water Recycler"
	desc = "这是一种小型的静压式回收装置，它能从空气中吸收水分并将其送入装置。"
	id = "w-recycler"
	build_type = PROTOLATHE | AWAY_LATHE | AUTOLATHE
	materials = list(/datum/material/plastic =SMALL_MATERIAL_AMOUNT * 2, /datum/material/iron =SMALL_MATERIAL_AMOUNT*0.5)
	build_path = /obj/item/stock_parts/water_recycler
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_MISC
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE
