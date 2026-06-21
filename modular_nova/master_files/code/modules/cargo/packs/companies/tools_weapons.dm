/datum/supply_pack/companies/tools_weapons
	group = "★ Tools & Weapons"
	discountable = SUPPLY_PACK_NOT_DISCOUNTABLE

// Blacksteel

/datum/supply_pack/companies/tools_weapons/blacksteel
	cost = CARGO_CRATE_VALUE * 0.5

/datum/supply_pack/companies/tools_weapons/blacksteel/ranged/tomahawk
	contains = list(/obj/item/melee/tomahawk)

/datum/supply_pack/companies/tools_weapons/blacksteel/ranged/knife
	contains = list(/obj/item/knife/combat/throwing)

/datum/supply_pack/companies/tools_weapons/blacksteel/buckler
	contains = list(/obj/item/shield/buckler)

/datum/supply_pack/companies/tools_weapons/blacksteel/kite
	contains = list(/obj/item/shield/kite)

/datum/supply_pack/companies/tools_weapons/blacksteel/blade/hunting_knife
	contains = list(/obj/item/knife/hunting)
	cost = CARGO_CRATE_VALUE * 0.25

/datum/supply_pack/companies/tools_weapons/blacksteel/blade/survival_knife
	contains = list(/obj/item/knife/combat/survival)
	cost = CARGO_CRATE_VALUE * 0.25

/datum/supply_pack/companies/tools_weapons/blacksteel/blade/bowie_knife
	contains = list(/obj/item/storage/belt/bowie_sheath)
	cost = CARGO_CRATE_VALUE
	desc = "拓荒者的经典装备，与其说是刀不如说是短剑。附带刀鞘。"
	name = "博伊刀"
	auto_name = FALSE

/datum/supply_pack/companies/tools_weapons/blacksteel/blade/shamshir_sabre
	contains = list(/obj/item/storage/belt/sheath/sabre/cargo)
	name = "正宗舍施尔弯刀"
	desc = "一把由波斯人使用过的精工制作历史人类剑。包含刀鞘！"
	cost = CARGO_CRATE_VALUE
	auto_name = FALSE

// Kahraman

/datum/supply_pack/companies/tools_weapons/kahraman
	cost = CARGO_CRATE_VALUE * 0.5

/datum/supply_pack/companies/tools_weapons/kahraman/fock
	contains = list(/obj/item/multitool/fock)
	cost = CARGO_CRATE_VALUE * 2

/datum/supply_pack/companies/tools_weapons/kahraman/omni_drill
	contains = list(/obj/item/screwdriver/omni_drill)

/datum/supply_pack/companies/tools_weapons/kahraman/arc_welder
	contains = list(/obj/item/weldingtool/electric/arc_welder)

/datum/supply_pack/companies/tools_weapons/kahraman/compact_drill
	contains = list(/obj/item/pickaxe/drill/compact)

/datum/supply_pack/companies/tools_weapons/kahraman/gps
	contains = list(/obj/item/gps)
	cost = CARGO_CRATE_VALUE * 0.25

// Sol Defense

/datum/supply_pack/companies/tools_weapons/sol_fed

/datum/supply_pack/companies/tools_weapons/sol_fed/tele_shield
	cost = CARGO_CRATE_VALUE
	contains = list(/obj/item/shield/riot/tele)

// HC

/datum/supply_pack/companies/tools_weapons/hc_surplus
	cost = CARGO_CRATE_VALUE * 0.25

/datum/supply_pack/companies/tools_weapons/hc_surplus/flares
	contains = list(/obj/item/storage/box/nri_flares)
	cost = CARGO_CRATE_VALUE * 0.3

/datum/supply_pack/companies/tools_weapons/hc_surplus/binoculars
	contains = list(/obj/item/binoculars)

/datum/supply_pack/companies/tools_weapons/hc_surplus/screwdriver_pen
	name = "螺丝刀笔"
	desc = "这是一支也能当螺丝刀用的笔！HC工程的奇迹！"
	contains = list(/obj/item/pen/screwdriver)
	auto_name = FALSE

/datum/supply_pack/companies/tools_weapons/hc_surplus/trench_tool
	contains = list(/obj/item/trench_tool)

// Vitezstvi

/datum/supply_pack/companies/tools_weapons/vitezstvi
	cost = CARGO_CRATE_VALUE * 0.5

/datum/supply_pack/companies/tools_weapons/vitezstvi/suppressor
	contains = list(/obj/item/suppressor/standard)
	access = ACCESS_WEAPONS
	access_view = ACCESS_WEAPONS
	express_lock = TRUE
	order_flags = ORDER_GOODY

/datum/supply_pack/companies/tools_weapons/vitezstvi/seclight
	contains = list(/obj/item/flashlight/seclite)
