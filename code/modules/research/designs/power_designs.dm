////////////////////////////////////////
//////////////////Power/////////////////
////////////////////////////////////////

/datum/design/basic_cell
	name = "初级电池-Power Cell"
	desc = "一个基础的能量电池，可储存10千瓦的能量。"
	id = "basic_cell"
	build_type = PROTOLATHE | AWAY_LATHE | AUTOLATHE |MECHFAB
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 7, /datum/material/glass =SMALL_MATERIAL_AMOUNT * 0.5)
	build_path = /obj/item/stock_parts/power_store/cell/empty
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_1
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/high_cell
	name = "大功率电池-Power Cell"
	desc = "一个能量电池，可储存100千瓦的能量。"
	id = "high_cell"
	build_type = PROTOLATHE | AWAY_LATHE | AUTOLATHE | MECHFAB
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 7, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 0.6)
	build_path = /obj/item/stock_parts/power_store/cell/high/empty
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_1
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/super_cell
	name = "高功率电池-Power Cell"
	desc = "一个能量电池，可储存200千瓦的能量。"
	id = "super_cell"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 7, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 0.7)
	build_path = /obj/item/stock_parts/power_store/cell/super/empty
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_2
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/hyper_cell
	name = "超功率电池-Power Cell"
	desc = "一个能量电池，可储存300千瓦的能量。"
	id = "hyper_cell"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 7, /datum/material/gold = SMALL_MATERIAL_AMOUNT * 1.5, /datum/material/silver = SMALL_MATERIAL_AMOUNT * 1.5, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 0.8)
	build_path = /obj/item/stock_parts/power_store/cell/hyper/empty
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_3
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/bluespace_cell
	name = "蓝空电池-Power Cell"
	desc = "一个能量电池，可储存400千瓦的能量。"
	id = "bluespace_cell"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 8, /datum/material/gold = SMALL_MATERIAL_AMOUNT * 1.2, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 1.6, /datum/material/diamond = SMALL_MATERIAL_AMOUNT * 1.6, /datum/material/titanium =SMALL_MATERIAL_AMOUNT * 3, /datum/material/bluespace =SMALL_MATERIAL_AMOUNT)
	build_path = /obj/item/stock_parts/power_store/cell/bluespace/empty
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_4
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/basic_battery
	name = "基础巨型电池"
	desc = "一个基础的巨型电池，可储存1兆焦的能量。"
	id = "basic_battery"
	build_type = PROTOLATHE | AWAY_LATHE | AUTOLATHE |MECHFAB
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 12, /datum/material/glass =SMALL_MATERIAL_AMOUNT * 2)
	construction_time = 5 SECONDS
	build_path = /obj/item/stock_parts/power_store/battery/empty
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_1
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/high_battery
	name = "高容量巨型电池"
	desc = "一个巨型电池，可储存10兆焦的能量。"
	id = "high_battery"
	build_type = PROTOLATHE | AWAY_LATHE | AUTOLATHE | MECHFAB
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 12, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 3)
	construction_time = 5 SECONDS
	build_path = /obj/item/stock_parts/power_store/battery/high/empty
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_2
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/super_battery
	name = "超级容量巨型电池"
	desc = "一个巨型电池，可储存20兆焦的能量。"
	id = "super_battery"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 12, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 4)
	construction_time = 5 SECONDS
	build_path = /obj/item/stock_parts/power_store/battery/super/empty
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_3
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/hyper_battery
	name = "超容量巨型电池"
	desc = "一个巨型电池，可储存30兆焦的能量。"
	id = "hyper_battery"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 12, /datum/material/gold = SMALL_MATERIAL_AMOUNT * 1.5, /datum/material/silver = SMALL_MATERIAL_AMOUNT * 1.5, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 5)
	construction_time = 5 SECONDS
	build_path = /obj/item/stock_parts/power_store/battery/hyper/empty
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_3
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/bluespace_battery
	name = "蓝空巨型电池"
	desc = "一种可储存40兆焦耳能量的巨型电池。"
	id = "bluespace_battery"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 12, /datum/material/gold = SMALL_MATERIAL_AMOUNT * 1.2, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 6, /datum/material/diamond = SMALL_MATERIAL_AMOUNT * 1.6, /datum/material/titanium =SMALL_MATERIAL_AMOUNT * 3, /datum/material/bluespace =SMALL_MATERIAL_AMOUNT)
	construction_time = 5 SECONDS
	build_path = /obj/item/stock_parts/power_store/battery/bluespace/empty
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_4
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING


/datum/design/inducer
	name = "无线快充器"
	desc = "NT-75 电磁充电器能够以无线方式为物体充电，使您无需取出电池就能为其充电。"
	id = "inducer"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/inducer/sci
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/inducerengi
	name = "无线快充器"
	desc = "NT-75 电磁充电器能够以无线方式为物体充电，使您无需取出电池就能为其充电。"
	id = "inducerengi"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/inducer/empty
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/board/pacman
	name = "P.A.C.M.A.N.电路板"
	desc = "一款类似“吃豆人”风格的便携式发电机所用的电路板。"
	id = "pacman"
	build_path = /obj/item/circuitboard/machine/pacman
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/bioelec_gen
	name = "水族箱生物电组件"
	desc = "将水族箱转换为生物电发电机所需的组件。"
	id = "bioelec_gen"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 5, /datum/material/gold = SMALL_MATERIAL_AMOUNT)
	build_path = /obj/item/aquarium_upgrade/bioelec_gen
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/turbine_part_compressor
	name = "涡轮机压缩机"
	desc = "压缩机叶片的基础等级。"
	id = "turbine_part_compressor"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*5)
	construction_time = 10 SECONDS
	build_path = /obj/item/turbine_parts/compressor
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_TURBINE
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/turbine_part_rotor
	name = "涡轮机转子"
	desc = "转子轴的基础等级。"
	id = "turbine_part_rotor"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*5)
	construction_time = 10 SECONDS
	build_path = /obj/item/turbine_parts/rotor
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_TURBINE
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/turbine_part_stator
	name = "涡轮机定子"
	desc = "定子的基础等级。"
	id = "turbine_part_stator"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT*5)
	construction_time = 10 SECONDS
	build_path = /obj/item/turbine_parts/stator
	category = list(
		RND_CATEGORY_STOCK_PARTS + RND_SUBCATEGORY_STOCK_PARTS_TURBINE
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/diode_disk_stamina
	name = "电干扰二极管盘"
	desc = "一种能造成耐力伤害并治疗超物质晶体的二极管盘。"
	id = "diode_disk_stamina"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 0.5, /datum/material/glass =SMALL_MATERIAL_AMOUNT, /datum/material/gold =SMALL_MATERIAL_AMOUNT)
	construction_time = 0.5 SECONDS
	build_path = /obj/item/emitter_disk/stamina
	category = list(
		RND_CATEGORY_EQUIPMENT
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/diode_disk_healing
	name = "生物再生二极管盘"
	desc = "一种治疗活体生物的二极管盘。"
	id = "diode_disk_healing"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 0.5, /datum/material/glass =SMALL_MATERIAL_AMOUNT, /datum/material/silver =SMALL_MATERIAL_AMOUNT) //silver is medical metal. Why? who knows.
	construction_time = 0.5 SECONDS
	build_path = /obj/item/emitter_disk/healing
	category = list(
		RND_CATEGORY_EQUIPMENT
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/diode_disk_incendiary
	name = "纵火型二极管盘"
	desc = "一种高能燃烧型二极管盘。"
	id = "diode_disk_incendiary"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 0.5, /datum/material/glass =SMALL_MATERIAL_AMOUNT, /datum/material/diamond =SMALL_MATERIAL_AMOUNT * 0.5, /datum/material/plasma =SMALL_MATERIAL_AMOUNT * 2)
	construction_time = 0.5 SECONDS
	build_path = /obj/item/emitter_disk/incendiary
	category = list(
		RND_CATEGORY_EQUIPMENT
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/diode_disk_sanity
	name = "精神虹吸二极管盘"
	desc = "一种安抚超物质并令生物抑郁的二极管盘。"
	id = "diode_disk_sanity"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 0.5, /datum/material/glass =SMALL_MATERIAL_AMOUNT, /datum/material/uranium =SMALL_MATERIAL_AMOUNT * 0.5) //Uranium, the metal of love and warmth (from decay heat).
	construction_time = 0.5 SECONDS
	build_path = /obj/item/emitter_disk/sanity
	category = list(
		RND_CATEGORY_EQUIPMENT
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/diode_disk_magnetic
	name = "磁力生成二极管盘"
	desc = "一种吸收摩尔并吸引物品的二极管盘。"
	id = "diode_disk_magnetic"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 0.5, /datum/material/glass =SMALL_MATERIAL_AMOUNT, /datum/material/titanium =SMALL_MATERIAL_AMOUNT * 0.5)
	construction_time = 0.5 SECONDS
	build_path = /obj/item/emitter_disk/magnetic
	category = list(
		RND_CATEGORY_EQUIPMENT
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING
