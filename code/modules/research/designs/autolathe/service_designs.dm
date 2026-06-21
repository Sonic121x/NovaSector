/datum/design/bucket
	name = "水桶"
	id = "bucket"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT * 2)
	build_path = /obj/item/reagent_containers/cup/bucket
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_JANITORIAL,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/wet_floor_sign
	name = "Wet Floor Sign"
	id = "wet_floor_sign"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/plastic =SMALL_MATERIAL_AMOUNT)
	build_path = /obj/item/clothing/suit/caution
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_JANITORIAL,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/watering_can
	name = "洒水壶"
	id = "watering_can"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT * 2)
	build_path = /obj/item/reagent_containers/cup/watering_can
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_BOTANY,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/mop
	name = "拖把"
	id = "mop"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/mop
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_JANITORIAL,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/broom
	name = "推式扫帚"
	id = "pushbroom"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/pushbroom
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_JANITORIAL,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/camera
	name = "相机"
	id = "camera"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*0.5, /datum/material/glass =SMALL_MATERIAL_AMOUNT)
	build_path = /obj/item/camera
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_SERVICE,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/camera_film
	name = "相机胶卷盒"
	id = "camera_film"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT*0.1, /datum/material/glass = SMALL_MATERIAL_AMOUNT*0.1)
	build_path = /obj/item/camera_film
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_SERVICE,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/kitchen_knife
	name = "厨房刀"
	id = "kitchen_knife"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*6)
	build_path = /obj/item/knife/kitchen
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_KITCHEN,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/plastic_knife
	name = "塑料刀"
	id = "plastic_knife"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/plastic =SMALL_MATERIAL_AMOUNT)
	build_path = /obj/item/knife/plastic
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_KITCHEN,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/fork
	name = "叉子"
	id = "fork"
	build_type =  AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT)
	build_path = /obj/item/kitchen/fork
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_KITCHEN,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/plastic_fork
	name = "塑料叉"
	id = "plastic_fork"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/plastic = SMALL_MATERIAL_AMOUNT)
	build_path = /obj/item/kitchen/fork/plastic
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_KITCHEN,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/spoon
	name = "勺子"
	id = "spoon"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT*1.2)
	build_path = /obj/item/kitchen/spoon
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_KITCHEN,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/plastic_spoon
	name = "塑料勺"
	id = "plastic_spoon"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/plastic = SMALL_MATERIAL_AMOUNT*1.2)
	build_path = /obj/item/kitchen/spoon/plastic
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_KITCHEN,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/tongs
	name = "夹子"
	id = "tongs"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 2)
	build_path = /obj/item/kitchen/tongs
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_KITCHEN,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/tray
	name = "餐盘"
	id = "servingtray"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT * 1.5)
	build_path = /obj/item/storage/bag/tray
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_KITCHEN,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/plate
	name = "盘子"
	id = "plate"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*1.5)
	build_path = /obj/item/plate
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_KITCHEN,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/cafeteria_tray
	name = "食堂托盘"
	id = "foodtray"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT * 1.5)
	build_path = /obj/item/storage/bag/tray/cafeteria
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_KITCHEN,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/bowl
	name = "碗"
	id = "bowl"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/glass =SMALL_MATERIAL_AMOUNT*5)
	category = list(RND_CATEGORY_INITIAL, RND_CATEGORY_EQUIPMENT)
	build_path = /obj/item/reagent_containers/cup/bowl
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_KITCHEN,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/drinking_glass
	name = "玻璃杯"
	id = "drinking_glass"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/glass =SMALL_MATERIAL_AMOUNT*5)
	category = list(RND_CATEGORY_INITIAL, RND_CATEGORY_EQUIPMENT)
	build_path = /obj/item/reagent_containers/cup/glass/drinkingglass
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_KITCHEN,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/shot_glass
	name = "烈酒杯"
	id = "shot_glass"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/glass =SMALL_MATERIAL_AMOUNT)
	category = list(RND_CATEGORY_INITIAL, RND_CATEGORY_EQUIPMENT)
	build_path = /obj/item/reagent_containers/cup/glass/drinkingglass/shotglass
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_KITCHEN,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/shaker
	name = "摇酒器"
	id = "shaker"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT * 1.5)
	category = list(RND_CATEGORY_INITIAL, RND_CATEGORY_EQUIPMENT)
	build_path = /obj/item/reagent_containers/cup/glass/shaker
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_KITCHEN,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/cultivator
	name = "园艺铲"
	id = "cultivator"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*0.5)
	build_path = /obj/item/cultivator
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_BOTANY,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/plant_analyzer
	name = "植物分析仪"
	id = "plant_analyzer"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT*0.3, /datum/material/glass =SMALL_MATERIAL_AMOUNT*0.2)
	build_path = /obj/item/plant_analyzer
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_BOTANY,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/shovel
	name = "铁锹"
	id = "shovel"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*0.5)
	build_path = /obj/item/shovel
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_BOTANY,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_CARGO

/datum/design/spade
	name = "小铲"
	id = "spade"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*0.5)
	build_path = /obj/item/shovel/spade
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_BOTANY,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/hatchet
	name = "手斧"
	id = "hatchet"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*7.5)
	build_path = /obj/item/hatchet
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_BOTANY,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/secateurs
	name = "修枝剪"
	id = "secateurs"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*2)
	build_path = /obj/item/secateurs
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_BOTANY,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/radio_headset
	name = "无线电耳机"
	id = "radio_headset"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT*0.75)
	build_path = /obj/item/radio/headset
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_TELECOMMS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/bounced_radio
	name = "空间站中继无线电"
	id = "bounced_radio"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT*0.75, /datum/material/glass =SMALL_MATERIAL_AMOUNT*0.25)
	build_path = /obj/item/radio/off
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_TELECOMMS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/handlabeler
	name = "手动贴标机"
	id = "handlabel"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT*1.5, /datum/material/glass = SMALL_MATERIAL_AMOUNT*1.25)
	build_path = /obj/item/hand_labeler
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_SERVICE,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/pet_carrier
	name = "宠物运输箱"
	id = "pet_carrier"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*3.75, /datum/material/glass =SMALL_MATERIAL_AMOUNT)
	build_path = /obj/item/pet_carrier
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SERVICE,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/toygun
	name = "玩具火帽枪"
	id = "toygun"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT, /datum/material/glass =SMALL_MATERIAL_AMOUNT*0.5)
	build_path = /obj/item/toy/gun
	category = list(
		RND_CATEGORY_HACKED,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SERVICE,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/capbox
	name = "玩具火帽枪子弹盒"
	id = "capbox"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*0.2, /datum/material/glass = SMALL_MATERIAL_AMOUNT*0.1)
	build_path = /obj/item/toy/ammo/gun
	category = list(
		RND_CATEGORY_HACKED,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SERVICE,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/toy_balloon
	name = "塑料气球"
	id = "toy_balloon"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/plastic = HALF_SHEET_MATERIAL_AMOUNT*1.2)
	build_path = /obj/item/toy/balloon
	category = list(
		RND_CATEGORY_HACKED,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SERVICE,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/toy_armblade
	name = "塑料臂刃"
	id = "toy_armblade"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/plastic =SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/toy/foamblade
	category = list(
		RND_CATEGORY_HACKED,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SERVICE,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/plastic_tree
	name = "塑料盆栽植物"
	id = "plastic_trees"
	build_type = AUTOLATHE
	materials = list(/datum/material/plastic = SHEET_MATERIAL_AMOUNT*4)
	build_path = /obj/item/kirbyplants/random/fullysynthetic
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SERVICE,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/beads
	name = "塑料串珠项链"
	id = "plastic_necklace"
	build_type = AUTOLATHE
	materials = list(/datum/material/plastic =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/clothing/neck/beads
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SERVICE,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/plastic_ring
	name = "塑料拉环"
	id = "ring_holder"
	build_type = AUTOLATHE
	materials = list(/datum/material/plastic = HALF_SHEET_MATERIAL_AMOUNT*1.2)
	build_path = /obj/item/storage/cans
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SERVICE,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/plastic_box
	name = "塑料盒"
	id = "plastic_box"
	build_type = AUTOLATHE
	materials = list(/datum/material/plastic =HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/storage/box/plastic
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SERVICE,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/sticky_tape
	name = "胶带"
	id = "sticky_tape"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/plastic =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/stack/medical/wrap/sticky_tape
	category = list(RND_CATEGORY_INITIAL, RND_CATEGORY_EQUIPMENT)
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SERVICE,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/chisel
	name = "凿子"
	id = "chisel"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT*0.75)
	build_path = /obj/item/chisel
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_SERVICE,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/paperroll
	name = "手持标签机纸卷"
	id = "roll"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*0.5, /datum/material/glass =SMALL_MATERIAL_AMOUNT*0.25)
	build_path = /obj/item/hand_labeler_refill
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_SERVICE,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/toner
	name = "墨粉盒"
	id = "toner"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT*0.1, /datum/material/glass = SMALL_MATERIAL_AMOUNT*0.1)
	build_path = /obj/item/toner
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SERVICE,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/toner/large
	name = "墨粉盒（大容量）"
	id = "toner_large"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT*0.5, /datum/material/glass = SMALL_MATERIAL_AMOUNT*0.5)
	build_path = /obj/item/toner/large
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SERVICE,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/fishing_rod_basic
	name = "钓鱼竿"
	id = "fishing_rod"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT * 2, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 2)
	build_path = /obj/item/fishing_rod
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_SERVICE,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/fishing_rod_material
	name = "材料钓鱼竿"
	id = "fishing_rod_material"
	build_type = AUTOLATHE
	materials = list(/datum/material_requirement/solid_material = SMALL_MATERIAL_AMOUNT * 4)
	build_path = /obj/item/fishing_rod/material
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_SERVICE,
	)

/datum/design/fish_case
	name = "停滞鱼箱"
	id = "fish_case"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT, /datum/material/plastic = SMALL_MATERIAL_AMOUNT)
	build_path = /obj/item/storage/fish_case
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SERVICE,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/aquarium_kit
	name = "水族箱套件"
	id = "aquarium_kit"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/aquarium_kit
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SERVICE,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/ticket_machine
	name = "售票机框架"
	id = "ticket_machine"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*7, /datum/material/glass = SHEET_MATERIAL_AMOUNT*4)
	build_path = /obj/item/wallframe/ticket_machine
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MOUNTS
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/telescreen_bar
	name = "酒吧远程屏幕"
	id = "telescreen_bar"
	build_type = PROTOLATHE
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT*5,
		/datum/material/glass =SHEET_MATERIAL_AMOUNT * 2.5,
	)
	build_path = /obj/item/wallframe/telescreen/bar
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MOUNTS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/telescreen_entertainment
	name = "娱乐远程屏幕"
	id = "telescreen_entertainment"
	build_type =  AUTOLATHE | PROTOLATHE
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT*5,
		/datum/material/glass =SHEET_MATERIAL_AMOUNT * 2.5,
	)
	build_path = /obj/item/wallframe/telescreen/entertainment
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MOUNTS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/telescreen_monastery
	name = "修道院远程屏幕"
	id = "telescreen_monastery"
	build_type = PROTOLATHE
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 2.5,
	)
	build_path = /obj/item/wallframe/telescreen/monastery
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MOUNTS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/telescreen_monastery/New()
	var/has_monastery = CHECK_MAP_JOB_CHANGE(JOB_CHAPLAIN, "has_monastery")
	if(!has_monastery)
		id = DESIGN_ID_IGNORE
	return ..()

/datum/design/entertainment_radio
	name = "娱乐收音机"
	id = "radio_entertainment"
	build_type =  AUTOLATHE | PROTOLATHE
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT*0.75,
		/datum/material/glass =SMALL_MATERIAL_AMOUNT*0.25
	)
	build_path = /obj/item/radio/entertainment/speakers/physical
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MOUNTS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/barcode_scanner
	name = "条形码扫描器"
	id = "barcode_scanner"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2)
	build_path = /obj/item/barcodescanner
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_SERVICE,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

/datum/design/rdd
	name = "Rapid Decoration Device (RDD)"
	id = "rdd"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 8,
		/datum/material/plastic = SHEET_MATERIAL_AMOUNT * 4,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 2,
	)
	build_path = /obj/item/construction/rdd/loaded
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_SERVICE,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE

