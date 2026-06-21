/obj/item/stock_parts/power_store/battery
	name = "巨型电池"
	desc = "一系列可充电的电化学电池串联在一起，能储存比标准电源电池多得多的能量。"
	icon = 'icons/obj/machines/cell_charger.dmi'
	icon_state = "cellbig"
	cell_size_prefix = "cellbig"
	inhand_icon_state = "cell"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	force = 10
	throwforce = 5
	throw_speed = 2
	throw_range = 2
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*12, /datum/material/glass=SMALL_MATERIAL_AMOUNT*2)
	rating_base = STANDARD_BATTERY_CHARGE
	maxcharge = STANDARD_BATTERY_CHARGE
	chargerate = STANDARD_BATTERY_RATE

/obj/item/stock_parts/power_store/battery/grind_results()
	return list(/datum/reagent/lithium = 60, /datum/reagent/iron = 10, /datum/reagent/silicon = 10)

/obj/item/stock_parts/power_store/battery/empty
	empty = TRUE

/obj/item/stock_parts/power_store/battery/upgraded
	name = "升级型巨型电池"
	desc = "容量比普通型号稍高的电池！"
	maxcharge = STANDARD_BATTERY_CHARGE * 2.5
	custom_materials = list(/datum/material/glass=SMALL_MATERIAL_AMOUNT*2.5)
	chargerate = STANDARD_BATTERY_RATE * 0.5

/obj/item/stock_parts/power_store/battery/high
	name = "高容量巨型电池"
	icon_state = "hcellbig"
	maxcharge = STANDARD_BATTERY_CHARGE * 10
	custom_materials = list(/datum/material/glass=SMALL_MATERIAL_AMOUNT * 3)
	chargerate = STANDARD_BATTERY_RATE * 0.75

/obj/item/stock_parts/power_store/battery/high/empty
	empty = TRUE

/obj/item/stock_parts/power_store/battery/super
	name = "超高容量巨型电池"
	icon_state = "scellbig"
	maxcharge = STANDARD_BATTERY_CHARGE * 20
	custom_materials = list(/datum/material/glass=SMALL_MATERIAL_AMOUNT * 4)
	chargerate = STANDARD_BATTERY_RATE

/obj/item/stock_parts/power_store/battery/super/empty
	empty = TRUE

/obj/item/stock_parts/power_store/battery/hyper
	name = "超极容量巨型电池"
	icon_state = "hpcellbig"
	maxcharge = STANDARD_BATTERY_CHARGE * 30
	custom_materials = list(/datum/material/glass=SMALL_MATERIAL_AMOUNT * 5)
	chargerate = STANDARD_BATTERY_RATE * 1.5

/obj/item/stock_parts/power_store/battery/hyper/empty
	empty = TRUE

/obj/item/stock_parts/power_store/battery/bluespace
	name = "蓝空巨型电池"
	desc = "一种可充电的超维度巨型电池。"
	icon_state = "bscellbig"
	maxcharge = STANDARD_BATTERY_CHARGE * 40
	custom_materials = list(/datum/material/glass=SMALL_MATERIAL_AMOUNT*6)
	chargerate = STANDARD_BATTERY_RATE * 2

/obj/item/stock_parts/power_store/battery/bluespace/empty
	empty = TRUE

/obj/item/stock_parts/power_store/battery/crap
	name = "\improper 纳米传讯品牌可充电AA巨型电池"
	desc = "等离子顶盖，无与伦比。" //TOTALLY TRADEMARK INFRINGEMENT
	maxcharge = STANDARD_BATTERY_CHARGE * 0.5
	custom_materials = list(/datum/material/glass=SMALL_MATERIAL_AMOUNT*1)

/obj/item/stock_parts/power_store/battery/crap/empty
	empty = TRUE

/obj/item/stock_parts/power_store/battery/infinite
	name = "无限容量巨型电池"
	desc = "一个拥有无穷容量的跨维度巨型电池。"
	icon_state = "icellbig"
	maxcharge = INFINITY
	chargerate = INFINITY
	ratingdesc = FALSE

/obj/item/stock_parts/power_store/battery/infinite/use(used, force = FALSE)
	return used
