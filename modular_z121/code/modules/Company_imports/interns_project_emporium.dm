#define CARGO_COMPANY_INTERN (1 << 31)
#define INTERNS_PROJECT_NAME "Intern's Project Emporium"

//	注册到货仓公司进口页面
/datum/cargo_company/intern_project
	name = INTERNS_PROJECT_NAME
	company_flag = CARGO_COMPANY_INTERN

//	公司售卖物品的基类
/datum/armament_entry/company_import/intern_project
	category = INTERNS_PROJECT_NAME
	company_bitflag = CARGO_COMPANY_INTERN

//	小型枪械
/datum/armament_entry/company_import/intern_project/sidearm
	subcategory = "小型枪械"
	cost = PAYCHECK_COMMAND * 4

/datum/armament_entry/company_import/intern_project/sidearm/sofap
	item_type = /obj/item/gun/ballistic/automatic/pistol/sofap

//	大型枪械
/datum/armament_entry/company_import/intern_project/primary
	subcategory = "大型枪械"
	cost = PAYCHECK_COMMAND * 6

/datum/armament_entry/company_import/intern_project/primary/crossbow
	item_type = /obj/item/gun/ballistic/rifle/rebarxbow/crossbow

/datum/armament_entry/company_import/intern_project/primary/aa12
	item_type = /obj/item/gun/ballistic/automatic/aa12
	cost = PAYCHECK_COMMAND * 16

/datum/armament_entry/company_import/intern_project/primary/hk5p
	item_type = /obj/item/gun/ballistic/automatic/hk5p
	cost = PAYCHECK_COMMAND * 10

/datum/armament_entry/company_import/intern_project/primary/europa
	item_type = /obj/item/gun/ballistic/automatic/europa
	cost = PAYCHECK_COMMAND * 20



//	弹药
/datum/armament_entry/company_import/intern_project/ammo
	subcategory = "弹药"
	cost = PAYCHECK_CREW

/datum/armament_entry/company_import/intern_project/ammo
	item_type = /obj/item/ammo_casing/rebar/bolt

/datum/armament_entry/company_import/intern_project/ammo/aa12_mag
	item_type = /obj/item/ammo_box/magazine/aa12/starts_empty

/datum/armament_entry/company_import/intern_project/ammo/aa12_drum
	item_type = /obj/item/ammo_box/magazine/aa12/drum/starts_empty
	cost = PAYCHECK_CREW * 3

/datum/armament_entry/company_import/intern_project/ammo/europa_mag
	item_type = /obj/item/ammo_box/magazine/europa/starts_empty
	cost = PAYCHECK_CREW * 4


//	医疗用品
/datum/armament_entry/company_import/intern_project/medical
	subcategory = "医疗用品"
	cost = PAYCHECK_CREW

/datum/armament_entry/company_import/intern_project/medical/beacon
	item_type = /obj/item/deployable_healer
	cost = PAYCHECK_CREW * 20

//  模块
/datum/armament_entry/company_import/intern_project/modules
	subcategory = "模块"
	cost = PAYCHECK_CREW

/datum/armament_entry/company_import/intern_project/modules/popcorndispenser
	item_type = /obj/item/mod/module/dispenser/popcorn
	cost = PAYCHECK_CREW * 5

//  食物
/datum/armament_entry/company_import/intern_project/food
	subcategory = "食物"
	cost = PAYCHECK_CREW

/datum/armament_entry/company_import/intern_project/food/liverpocket
	item_type = /obj/item/storage/box/donkpockets/donkpocketliver
	cost = PAYCHECK_CREW * 2



//	杂项
/datum/armament_entry/company_import/intern_project/misc
	subcategory = "杂项"
	cost = PAYCHECK_CREW * 6

/datum/armament_entry/company_import/intern_project/misc/generic_pouch
	item_type = /obj/item/storage/pouch/generic_pouch

/datum/armament_entry/company_import/intern_project/misc/expanded_pouch
	item_type = /obj/item/storage/pouch/expanded_pouch
	cost = PAYCHECK_CREW * 6 * 1.5

/datum/armament_entry/company_import/intern_project/misc/carrying_pouch
	item_type = /obj/item/storage/pouch/carrying_pouch
	cost = PAYCHECK_CREW * 6 * 1.5

/datum/armament_entry/company_import/intern_project/misc/plush_ghastling
	item_type = /obj/item/toy/plush/ghastling
	cost = PAYCHECK_CREW * 4
