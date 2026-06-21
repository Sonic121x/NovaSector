/obj/machinery/door/puzzle/keycard/roro
	name = "织物处理"
	desc = "一扇布满灰尘和划痕的门，上面装着一把厚重的锁。"
	puzzle_id = "roroco"

/obj/item/keycard/roro
	name = "织物处理门禁卡"
	desc = ""
	color = "#b1634c"
	puzzle_id = "roroco"

/area/ruin/roroco
	name = "\improper RoroCo 主走廊"

/area/ruin/roroco/management
	name = "\improper RoroCo 管理办公室"

/area/ruin/roroco/packing
	name = "\improper RoroCo 包装室"

/area/ruin/roroco/extraction
	name = "\improper RoroCo 产品提取室"

/area/ruin/roroco/harvesting
	name = "\improper RoroCo 收获室"

/area/ruin/roroco/maintenance
	name = "\improper RoroCo 维护区走廊"

/area/ruin/roroco/janitor
	name = "\improper RoroCo 清洁工储物间"

/obj/item/card/id/away/roroco
	name = "\improper RoroCo ID卡"
	desc = "一张塑料卡片，证明持有者是 RoroCo 的员工。内嵌电子芯片用于与气闸门及其他机器通信。上面没有标注姓名。"
	icon_state = "card_roro"
	trim = /datum/id_trim/away/roroco

/obj/item/card/id/away/roroco/boss
	desc = "一张塑料卡片，证明持有者是 RoroCo 的高级员工，拥有进入安全区域的增强权限。内嵌电子芯片用于与气闸门及其他机器通信。上面没有标注姓名。"
	icon_state = "card_roroboss"
	trim = /datum/id_trim/away/roroco/boss

/obj/structure/closet/cardboard/roroco
	icon_state = "cardboard_roroco"

/obj/item/clothing/suit/toggle/labcoat/roroco
	name = "\improper RoroCo 实验服"
	desc = "一件能防护轻微化学泄漏的防护服，但其深红色调使其难以被察觉。非常适合隐藏血迹，不过……"
	icon = 'icons/map_icons/clothing/suit/_suit.dmi'
	icon_state = "/obj/item/clothing/suit/toggle/labcoat/roroco"
	post_init_icon_state = "labcoat_job"
	greyscale_config = /datum/greyscale_config/labcoat
	greyscale_config_worn = /datum/greyscale_config/labcoat/worn
	greyscale_colors = "#88242D#39393F#39393F#39393F"

/obj/item/clothing/under/costume/buttondown/slacks/roroco
	icon_state = "/obj/item/clothing/under/costume/buttondown/slacks/roroco"
	greyscale_colors = "#FFCCCC#17171B#17171B#88242D"

/datum/outfit/roroco
	name = "RoroCo手套包装工"
	gloves = /obj/item/clothing/gloves/cargo_gauntlet
	shoes = /obj/item/clothing/shoes/workboots
	uniform = /obj/item/clothing/under/costume/buttondown/slacks/roroco
	suit = /obj/item/clothing/suit/hazardvest

/datum/outfit/roroco/processing
	name = "Roroco织物技术员"
	glasses = /obj/item/clothing/glasses/science
	gloves = /obj/item/clothing/gloves/latex/nitrile
	suit = /obj/item/clothing/suit/toggle/labcoat/roroco
	id = /obj/item/card/id/away/roroco/boss

/obj/effect/mob_spawn/corpse/human/roroco_packing
	name = "RoroCo手套包装工尸体"
	mob_name = "Nameless Glove Packer"
	outfit = /datum/outfit/roroco

/obj/effect/mob_spawn/corpse/human/roroco_processing
	name = "Roroco织物技术员尸体"
	mob_name = "Nameless Fabric Technician"
	outfit = /datum/outfit/roroco/processing
