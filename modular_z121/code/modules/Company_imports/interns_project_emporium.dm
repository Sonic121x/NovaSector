//	小型枪械
/datum/supply_pack/companies/ballistics/intern_project/sidearm
	cost = PAYCHECK_COMMAND * 4

/datum/supply_pack/companies/ballistics/intern_project/sidearm/sofap
	contains = /obj/item/gun/ballistic/automatic/pistol/sofap
	//restricted = TRUE

/datum/supply_pack/companies/ballistics/intern_project/sidearm/tac9
	contains = /obj/item/gun/ballistic/automatic/pistol/tac9

/datum/supply_pack/companies/ballistics/intern_project/sidearm/bfr500
	contains = /obj/item/gun/ballistic/revolver/single
	cost = PAYCHECK_COMMAND * 6

//	大型枪械
/datum/supply_pack/companies/ballistics/intern_project/primary
	cost = PAYCHECK_COMMAND * 6

/datum/supply_pack/companies/ballistics/intern_project/primary/crossbow
	contains = /obj/item/gun/ballistic/rifle/rebarxbow/crossbow

/datum/supply_pack/companies/ballistics/intern_project/primary/aa12
	contains = /obj/item/gun/ballistic/shotgun/aa12
	cost = PAYCHECK_COMMAND * 16
	//restricted = TRUE

/datum/supply_pack/companies/ballistics/intern_project/primary/evo
	contains = /obj/item/gun/ballistic/automatic/evo
	cost = PAYCHECK_COMMAND * 10
	//restricted = TRUE

/datum/supply_pack/companies/ballistics/intern_project/primary/europa
	contains = /obj/item/gun/ballistic/automatic/europa
	cost = PAYCHECK_COMMAND * 20
	//restricted = TRUE

/datum/supply_pack/companies/ballistics/intern_project/primary/dex4
	contains = /obj/item/gun/ballistic/shotgun/dex4
	cost = PAYCHECK_COMMAND * 12
	//restricted = TRUE

/datum/supply_pack/companies/energy/intern_project/photon_sniper
	contains = /obj/item/gun/energy/photon_sniper
	cost = PAYCHECK_COMMAND * 8
	//restricted = TRUE

//	弹药
/datum/supply_pack/companies/mags_and_ammo/intern_project
	cost = PAYCHECK_CREW

/datum/supply_pack/companies/mags_and_ammo/intern_project/bolt
	contains = /obj/item/ammo_casing/rebar/bolt

/datum/supply_pack/companies/mags_and_ammo/intern_project/tac9
	contains = /obj/item/ammo_box/magazine/tac9/starts_empty

/datum/supply_pack/companies/mags_and_ammo/intern_project/bfr500
	contains = /obj/item/ammo_box/bfr500

/datum/supply_pack/companies/mags_and_ammo/intern_project/aa12_mag
	contains = /obj/item/ammo_box/magazine/aa12/starts_empty

/datum/supply_pack/companies/mags_and_ammo/intern_project/aa12_drum
	contains = /obj/item/ammo_box/magazine/aa12/drum/starts_empty
	cost = PAYCHECK_CREW * 3

/datum/supply_pack/companies/mags_and_ammo/intern_project/evo_mag
	contains = /obj/item/ammo_box/magazine/evo_c9mm/starts_empty
	cost = PAYCHECK_CREW

/datum/supply_pack/companies/mags_and_ammo/intern_project/europa_mag
	contains = /obj/item/ammo_box/magazine/europa/starts_empty
	cost = PAYCHECK_CREW * 4

/datum/supply_pack/companies/mags_and_ammo/intern_project/dex4_mag
	contains = /obj/item/ammo_box/magazine/dex4/starts_empty
	cost = PAYCHECK_CREW

//	医疗用品
/datum/supply_pack/companies/medical/intern_project
	cost = PAYCHECK_CREW

/datum/supply_pack/companies/medical/intern_project/beacon
	contains = /obj/item/deployable_healer
	cost = PAYCHECK_CREW * 20

//  模块
/datum/supply_pack/companies/modsuits/mods/intern_project
	cost = PAYCHECK_CREW

/datum/supply_pack/companies/modsuits/mods/intern_project/popcorndispenser
	contains = /obj/item/mod/module/dispenser/popcorn
	cost = PAYCHECK_CREW * 5
/*
//  食物
/datum/armament_entry/company_import/intern_project/food
	//subcategory = "食物"
	cost = PAYCHECK_CREW
*/
/datum/supply_pack/companies/general/donk/liverpocket
	contains = /obj/item/storage/box/donkpockets/donkpocketliver
	cost = PAYCHECK_CREW * 2

/datum/supply_pack/companies/general/donk/ratpocket
	contains = /obj/item/storage/box/donkpockets/donkpocketrat
	cost = PAYCHECK_CREW * 2

/datum/supply_pack/companies/general/donk/slimepocket
	contains = /obj/item/storage/box/donkpockets/donkpocketslime
	cost = PAYCHECK_CREW * 2

/datum/supply_pack/companies/general/donk/mimepocket
	contains = /obj/item/storage/box/donkpockets/donkpocketmime
	cost = PAYCHECK_CREW * 2



//	杂项
/datum/supply_pack/companies/apparel/intern_project/pouch
	//subcategory = "杂项"
	cost = PAYCHECK_CREW * 6

/datum/supply_pack/companies/apparel/intern_project/pouch/generic_pouch
	contains = /obj/item/storage/pouch/generic_pouch

/datum/supply_pack/companies/apparel/intern_project/pouch/expanded_pouch
	contains = /obj/item/storage/pouch/expanded_pouch
	cost = PAYCHECK_CREW * 6 * 1.5

/datum/supply_pack/companies/apparel/intern_project/pouch/carrying_pouch
	contains = /obj/item/storage/pouch/carrying_pouch
	cost = PAYCHECK_CREW * 6 * 1.5

/datum/supply_pack/companies/apparel/intern_project/pouch/plush_ghastling
	contains = /obj/item/toy/plush/ghastling
	cost = PAYCHECK_CREW * 4
