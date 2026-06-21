// Readds the materials crates the GMM removed, but mostly for things like assistant projects.

/datum/supply_pack/materials/glass_fifty
	name = "50张玻璃板材"
	desc = "用五十张玻璃板材让一些美好的光线透进来吧！"
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/stack/sheet/glass/fifty)
	crate_name = "glass sheets crate"

/datum/supply_pack/materials/iron_fifty
	name = "50张铁板材"
	desc = "任何建筑工程都始于五十张铁板材的好堆叠！"
	cost = CARGO_CRATE_VALUE * 2.5
	contains = list(/obj/item/stack/sheet/iron/fifty)
	crate_name = "iron sheets crate"

/datum/supply_pack/materials/plasteel_twenty
	name = "20张塑钢板材"
	desc = "用二十张塑钢板材加固空间站的完整性！"
	cost = CARGO_CRATE_VALUE * 15
	contains = list(/obj/item/stack/sheet/plasteel/twenty)
	crate_name = "plasteel sheets crate"

/datum/supply_pack/materials/plasteel_fifty
	name = "50张塑钢板材"
	desc = "用于当你真的必须加固某些东西的时候。"
	cost = CARGO_CRATE_VALUE * 33
	contains = list(/obj/item/stack/sheet/plasteel/fifty)
	crate_name = "plasteel sheets crate"

/datum/supply_pack/materials/stone_fifty
	name = "50块石砖"
	desc = "太忙了没空自己去采矿？我们帮你搞定！"
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/stack/sheet/mineral/stone/fifty)
	crate_name = "stone bricks crate"
