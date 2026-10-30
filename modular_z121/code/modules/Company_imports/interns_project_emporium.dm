//	小型枪械
/datum/supply_pack/companies/ballistics/intern_project/sidearm
	cost = PAYCHECK_COMMAND * 4

/datum/supply_pack/companies/ballistics/intern_project/sidearm/sofap
	contains = list(/obj/item/gun/ballistic/automatic/pistol/sofap)
	//restricted = TRUE

/datum/supply_pack/companies/ballistics/intern_project/sidearm/tac9
	contains = list(/obj/item/gun/ballistic/automatic/pistol/tac9)
	access = FALSE
	access_view = FALSE
	express_lock = FALSE

/datum/supply_pack/companies/ballistics/intern_project/sidearm/nt38
	contains = list(/obj/item/gun/ballistic/automatic/pistol/c38)
	access = FALSE
	access_view = FALSE
	express_lock = FALSE

/datum/supply_pack/companies/ballistics/intern_project/sidearm/bfr500
	contains = list(/obj/item/gun/ballistic/revolver/single)
	cost = PAYCHECK_COMMAND * 6
	access = FALSE
	access_view = FALSE
	express_lock = FALSE

//	大型枪械
/datum/supply_pack/companies/ballistics/intern_project/primary
	cost = PAYCHECK_COMMAND * 6

/datum/supply_pack/companies/ballistics/intern_project/primary/crossbow
	contains = list(/obj/item/gun/ballistic/rifle/rebarxbow/crossbow)
	access = FALSE
	access_view = FALSE
	express_lock = FALSE

/datum/supply_pack/companies/ballistics/intern_project/primary/ostrza
	contains = list(/obj/item/gun/ballistic/automatic/ostrza)
	cost = PAYCHECK_COMMAND * 16

/datum/supply_pack/companies/ballistics/intern_project/primary/aa12
	contains = list(/obj/item/gun/ballistic/shotgun/aa12)
	cost = PAYCHECK_COMMAND * 16
	//restricted = TRUE

/datum/supply_pack/companies/ballistics/intern_project/primary/europa
	contains = list(/obj/item/gun/ballistic/automatic/europa)
	cost = PAYCHECK_COMMAND * 20
	//restricted = TRUE

/datum/supply_pack/companies/ballistics/intern_project/primary/solstice
	contains = list(/obj/item/gun/ballistic/rifle/solstice)
	cost = PAYCHECK_COMMAND * 16

/datum/supply_pack/companies/energy/intern_project/photon_sniper
	contains = list(/obj/item/gun/energy/photon_sniper)
	cost = PAYCHECK_COMMAND * 8
	//restricted = TRUE

//	弹药
/datum/supply_pack/companies/mags_and_ammo/intern_project
	cost = PAYCHECK_CREW

/datum/supply_pack/companies/mags_and_ammo/intern_project/c20nuoli
	contains = list(/obj/item/ammo_box/c20nuoli)
	cost = PAYCHECK_CREW * 2

/datum/supply_pack/companies/mags_and_ammo/intern_project/c20nuoli_smart
	contains = list(/obj/item/ammo_box/c20nuoli/smart)
	cost = PAYCHECK_CREW * 2

/datum/supply_pack/companies/mags_and_ammo/intern_project/c20nuoli_breacher
	contains = list(/obj/item/ammo_box/c20nuoli/breacher)
	cost = PAYCHECK_CREW * 2

/datum/supply_pack/companies/mags_and_ammo/intern_project/bolt
	contains = list(/obj/item/ammo_casing/rebar/bolt)

/datum/supply_pack/companies/mags_and_ammo/intern_project/tac9
	contains = list(/obj/item/ammo_box/magazine/tac9/starts_empty)

/datum/supply_pack/companies/mags_and_ammo/intern_project/nt38
	contains = list(/obj/item/ammo_box/magazine/m38_pistol/starts_empty)

/datum/supply_pack/companies/mags_and_ammo/intern_project/bfr500
	contains = list(/obj/item/ammo_box/speedloader/bfr500)

/datum/supply_pack/companies/mags_and_ammo/intern_project/aa12_mag
	contains = list(/obj/item/ammo_box/magazine/aa12/starts_empty)

/datum/supply_pack/companies/mags_and_ammo/intern_project/aa12_drum
	contains = list(/obj/item/ammo_box/magazine/aa12/drum/starts_empty)
	cost = PAYCHECK_CREW * 3

/datum/supply_pack/companies/mags_and_ammo/intern_project/europa_mag
	contains = list(/obj/item/ammo_box/magazine/europa/starts_empty)
	cost = PAYCHECK_CREW * 2

//	医疗用品
/datum/supply_pack/companies/medical/intern_project
	cost = PAYCHECK_CREW

/datum/supply_pack/companies/medical/intern_project/beacon
	contains = list(/obj/item/deployable_healer)
	cost = PAYCHECK_CREW * 20

/datum/supply_pack/companies/medical/intern_project/paramedic_jaws_kit
	contains = list(/obj/item/crafting_conversion_kit/paramedic_jaws)
	cost = PAYCHECK_CREW

//  模块
/datum/supply_pack/companies/modsuits/mods/intern_project
	cost = PAYCHECK_CREW

/datum/supply_pack/companies/modsuits/mods/intern_project/popcorndispenser
	contains = list(/obj/item/mod/module/dispenser/popcorn)
	cost = PAYCHECK_CREW * 5
/*
//  食物
/datum/armament_entry/company_import/intern_project/food
	//subcategory = "食物"
	cost = PAYCHECK_CREW
*/
/datum/supply_pack/companies/general/donk/liverpocket
	contains = list(/obj/item/storage/box/donkpockets/donkpocketliver)
	cost = PAYCHECK_CREW * 2

/datum/supply_pack/companies/general/donk/ratpocket
	contains = list(/obj/item/storage/box/donkpockets/donkpocketrat)
	cost = PAYCHECK_CREW * 2

/datum/supply_pack/companies/general/donk/slimepocket
	contains = list(/obj/item/storage/box/donkpockets/donkpocketslime)
	cost = PAYCHECK_CREW * 2

/datum/supply_pack/companies/general/donk/mimepocket
	contains = list(/obj/item/storage/box/donkpockets/donkpocketmime)
	cost = PAYCHECK_CREW * 2

/datum/supply_pack/companies/general/donk/caramel_medipen
	contains = list(/obj/item/storage/box/caramel_medipen)
	cost = PAYCHECK_CREW * 2

//	载具
/datum/supply_pack/service/sedan
	name = "轿车套件"
	desc = "一辆属于你自己的汽车，驶向太空！驶向新生活！"
	cost = CARGO_CRATE_VALUE * 10
	contains = list(
		/obj/vehicle/sealed/car/sedan = 1,
		/obj/item/key/car = 1,
	)
	crate_name = "轿车套件"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/service/car_key
	name = "备用车钥匙"
	desc = "如果你弄丢了你的车钥匙，你可以买一个新的，保证和原来的一模一样！但是，请不要用它来启动不属于你自己的车，可以吗？"
	cost = PAYCHECK_CREW * 5
	contains = list(/obj/item/key/car)

//	杂项
/datum/supply_pack/companies/apparel/intern_project/pouch
	//subcategory = "杂项"
	cost = PAYCHECK_CREW * 6

/datum/supply_pack/companies/apparel/intern_project/pouch/generic_pouch
	contains = list(/obj/item/storage/pouch/generic_pouch)

/datum/supply_pack/companies/apparel/intern_project/pouch/expanded_pouch
	contains = list(/obj/item/storage/pouch/expanded_pouch)
	cost = PAYCHECK_CREW * 6 * 1.5

/datum/supply_pack/companies/apparel/intern_project/pouch/carrying_pouch
	contains = list(/obj/item/storage/pouch/carrying_pouch)
	cost = PAYCHECK_CREW * 6 * 1.5

/datum/supply_pack/companies/apparel/intern_project/pouch/plush_ghastling
	contains = list(/obj/item/toy/plush/ghastling)
	cost = PAYCHECK_CREW * 4
