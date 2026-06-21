/datum/supply_pack/companies/ballistics
	group = "★ Ballistic Weapons"
	access = ACCESS_WEAPONS
	access_view = ACCESS_WEAPONS
	express_lock = TRUE
	order_flags = ORDER_GOODY
	discountable = SUPPLY_PACK_STD_DISCOUNTABLE

// NT Weapons

/datum/supply_pack/companies/ballistics/nt
	console_flag = CARGO_CONSOLE_NT | CARGO_CONSOLE_PDA // This is mostly for flavor, as NT ghost companies had been given a lot of absurdly powerful unique stuff and can still access to the station to get these.

/datum/supply_pack/companies/ballistics/nt/mars_single
	name = "柯尔特侦探特制型"
	desc = "安保部长没收了你的枪和警徽？没问题！只要支付那荒谬的税费，你也能重新拥有.38口径的致命威力！"
	cost = CARGO_CRATE_VALUE * 2.5
	auto_name = FALSE
	access = FALSE
	access_view = FALSE
	express_lock = FALSE
	order_flags = ORDER_COMPANY
	contains = list(/obj/item/gun/ballistic/revolver/c38/detective)

/datum/supply_pack/companies/ballistics/nt/double_barrel
	name = "双管霰弹枪"
	desc = "你心爱的兔子在恶魔入侵中遇难了？小丑闯进来偷走了你心爱的枪？别担心！只要你能支付那荒谬的费用，就能获得一把新枪。"
	cost = CARGO_CRATE_VALUE * 2
	auto_name = FALSE
	access = FALSE
	access_view = FALSE
	express_lock = FALSE
	order_flags = ORDER_COMPANY
	contains = list(/obj/item/gun/ballistic/shotgun/doublebarrel)

/datum/supply_pack/companies/ballistics/nt/shotgun_automatic
	cost = CARGO_CRATE_VALUE * 5
	contains = list(/obj/item/gun/ballistic/shotgun/automatic/combat)

/datum/supply_pack/companies/ballistics/nt/c38_super_kit
	name = "纳米传讯/工程部 \"莱瓦汀\" 左轮手枪改装套件"
	desc = "一套用于将.38左轮手枪改装为纳米传讯最新磁加速副武器的零件。包含快速装弹器扩展工具组。"
	cost = CARGO_CRATE_VALUE * 1.5 // 300 cr at time of writing, 800 cr total
	contains = list(
		/obj/item/crafting_conversion_kit/c38_super,
		/obj/item/crafting_conversion_kit/c38_speedloader_plus,
	)
	auto_name = FALSE
	access = FALSE
	access_view = FALSE
	express_lock = FALSE
	order_flags = ORDER_COMPANY

/datum/supply_pack/companies/ballistics/nt/c96
	name = "NT M-96"
	desc = "Hot off the assembly line and right into your holster, this modern reproduction of the classic C96 is chambered in 9mm."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/obj/item/gun/ballistic/rifle/c96)
	auto_name = FALSE
	access = FALSE
	access_view = FALSE
	express_lock = FALSE
	order_flags = ORDER_COMPANY

// Aethon and HHI Weapons

/datum/supply_pack/companies/ballistics/atheon/rapier
	name = "M94 'Rapier' Submachinegun"
	desc = "Big and mean, spits hot lead and fills halls with casings. Perfect for when collateral damage is on the table. Chambered in 4.6mm."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/obj/item/gun/ballistic/automatic/rapier)

// Sol Fed Weapons
/datum/supply_pack/companies/ballistics/sol_fed

/datum/supply_pack/companies/ballistics/sol_fed/sidearm
	cost = CARGO_CRATE_VALUE * 2
	access = FALSE
	access_view = FALSE
	express_lock = FALSE
	order_flags = ORDER_COMPANY

/datum/supply_pack/companies/ballistics/sol_fed/sidearm/eland
	contains = list(/obj/item/gun/ballistic/revolver/sol)

/datum/supply_pack/companies/ballistics/sol_fed/sidearm/wespe
	contains = list(/obj/item/gun/ballistic/automatic/pistol/sol)

/datum/supply_pack/companies/ballistics/sol_fed/sidearm/type207
	contains = list(/obj/item/gun/ballistic/automatic/pistol/type207)

/datum/supply_pack/companies/ballistics/sol_fed/sidearm/skild
	contains = list(/obj/item/gun/ballistic/automatic/pistol/trappiste)
	cost = CARGO_CRATE_VALUE * 3

/datum/supply_pack/companies/ballistics/sol_fed/sidearm/takbok
	contains = list(/obj/item/gun/ballistic/revolver/takbok)
	cost = CARGO_CRATE_VALUE * 3

/datum/supply_pack/companies/ballistics/sol_fed/sidearm/alacran_civil
	contains = list(/obj/item/gun/ballistic/automatic/sol_pdw/civil)
	cost = CARGO_CRATE_VALUE * 2.5

/datum/supply_pack/companies/ballistics/sol_fed/longarm
	cost = CARGO_CRATE_VALUE * 3

/datum/supply_pack/companies/ballistics/sol_fed/longarm/renoster_super_kit
	name = "阿肯系统 \"KOLBEN/NACHTREIHER\" M64霰弹枪改装套件"
	desc = "一套用于将M64霰弹枪改装为阿肯战斗系统旨在提升霰弹枪终端用户体验的尝试性产品的零件。"
	cost = CARGO_CRATE_VALUE * 3 // 600 cr at time of writing, 1200 cr total
	contains = list(/obj/item/crafting_conversion_kit/riot_sol_super)
	auto_name = FALSE
	access = FALSE
	access_view = FALSE
	express_lock = FALSE

/datum/supply_pack/companies/ballistics/sol_fed/longarm/doublebarrel_super_kit
	name = "阿肯系统 \"胡兀鹫\" 双管霰弹枪改装套件"
	desc = "一套用于将双管霰弹枪改装为阿肯战斗系统旨在提升霰弹枪终端用户体验的尝试性产品的零件。"
	cost = CARGO_CRATE_VALUE * 3 // 600 cr at time of writing, 1000 cr total
	contains = list(/obj/item/crafting_conversion_kit/doublebarrel_super)
	auto_name = FALSE
	access = FALSE
	access_view = FALSE
	express_lock = FALSE

/datum/supply_pack/companies/ballistics/sol_fed/longarm/renoster
	contains = list(/obj/item/gun/ballistic/shotgun/riot/sol)

/datum/supply_pack/companies/ballistics/sol_fed/longarm/sindano
	contains = list(/obj/item/gun/ballistic/automatic/sol_smg)

/datum/supply_pack/companies/ballistics/sol_fed/longarm/alacran
	contains = list(/obj/item/gun/ballistic/automatic/sol_pdw)
	cost = CARGO_CRATE_VALUE * 4

/datum/supply_pack/companies/ballistics/sol_fed/longarm/type213
	contains = list(/obj/item/gun/ballistic/automatic/type213)

/datum/supply_pack/companies/ballistics/sol_fed/longarm/br38
	contains = list(/obj/item/gun/ballistic/automatic/battle_rifle)
	cost = CARGO_CRATE_VALUE * 4

/datum/supply_pack/companies/ballistics/sol_fed/longarm/elite
	contains = list(/obj/item/gun/ballistic/automatic/sol_classic/marksman)
	cost = CARGO_CRATE_VALUE * 6

/datum/supply_pack/companies/ballistics/sol_fed/longarm/bogseo
	contains = list(/obj/item/gun/ballistic/automatic/xhihao_smg)
	cost = CARGO_CRATE_VALUE * 5

/datum/supply_pack/companies/ballistics/sol_fed/longarm/jager
	contains = list(/obj/item/gun/ballistic/shotgun/katyusha/jager)
	cost = CARGO_CRATE_VALUE * 8

/datum/supply_pack/companies/ballistics/sol_fed/longarm/infanterie
	contains = list(/obj/item/gun/ballistic/automatic/sol_classic)
	cost = CARGO_CRATE_VALUE * 7

/* //
/datum/supply_pack/companies/ballistics/sol_fed/longarm/outomaties
	contains = list(/obj/item/gun/ballistic/automatic/sol_rifle/machinegun)
	cost = CARGO_CRATE_VALUE * 11.5
*/ //Commented out due to a severe lack of balance regarding it.

/datum/supply_pack/companies/ballistics/sol_fed/longarm/kiboko
	contains = list(/obj/item/gun/ballistic/automatic/sol_grenade_launcher)
	cost = CARGO_CRATE_VALUE * 23

// HC Surplus

/datum/supply_pack/companies/ballistics/hc_surplus
	cost = CARGO_CRATE_VALUE * 3

/datum/supply_pack/companies/ballistics/hc_surplus/shotgun_revolver
	contains = list(/obj/item/gun/ballistic/revolver/shotgun_revolver)
	access = FALSE
	access_view = FALSE
	express_lock = FALSE
	order_flags = ORDER_COMPANY

/datum/supply_pack/companies/ballistics/hc_surplus/zashch
	contains = list(/obj/item/gun/ballistic/automatic/pistol/zashch)
	access = FALSE
	access_view = FALSE
	express_lock = FALSE
	order_flags = ORDER_COMPANY

/datum/supply_pack/companies/ballistics/hc_surplus/miecz
	contains = list(/obj/item/gun/ballistic/automatic/miecz)
	cost = CARGO_CRATE_VALUE * 5

/datum/supply_pack/companies/ballistics/hc_surplus/napad
	contains = list(/obj/item/gun/ballistic/automatic/napad)
	cost = CARGO_CRATE_VALUE * 6

/datum/supply_pack/companies/ballistics/hc_surplus/sakhno_rifle
	contains = list(/obj/item/gun/ballistic/rifle/boltaction)
	cost = CARGO_CRATE_VALUE * 6

/datum/supply_pack/companies/ballistics/hc_surplus/lanca
	contains = list(/obj/item/gun/ballistic/automatic/lanca)
	cost = CARGO_CRATE_VALUE * 7

/datum/supply_pack/companies/ballistics/hc_surplus/anti_materiel_rifle
	contains = list(/obj/item/gun/ballistic/automatic/wylom)
	cost = CARGO_CRATE_VALUE * 8

// Donk

/datum/supply_pack/companies/ballistics/donk
	access = FALSE
	access_view = FALSE
	express_lock = FALSE
	order_flags = ORDER_COMPANY
	discountable = SUPPLY_PACK_NOT_DISCOUNTABLE

/datum/supply_pack/companies/ballistics/donk/foam_pistol
	contains = list(/obj/item/gun/ballistic/automatic/pistol/toy)
	cost = CARGO_CRATE_VALUE * 0.5

/datum/supply_pack/companies/ballistics/donk/foam_shotgun
	contains = list(/obj/item/gun/ballistic/shotgun/toy/riot)
	cost = CARGO_CRATE_VALUE * 0.5

/datum/supply_pack/companies/ballistics/donk/foam_smg
	contains = list(/obj/item/gun/ballistic/automatic/toy)
	cost = CARGO_CRATE_VALUE * 1.5

/datum/supply_pack/companies/ballistics/donk/foam_c20
	contains = list(/obj/item/gun/ballistic/automatic/c20r/toy/unrestricted)
	cost = CARGO_CRATE_VALUE * 1.5

/datum/supply_pack/companies/ballistics/donk/foam_turret
	contains = list(/obj/item/storage/toolbox/emergency/turret/mag_fed/toy/pre_filled)
	cost = CARGO_CRATE_VALUE * 2

/datum/supply_pack/companies/ballistics/donk/foam_lmg
	contains = list(/obj/item/gun/ballistic/automatic/l6_saw/toy/unrestricted)
	cost = CARGO_CRATE_VALUE * 2.5

// Blacksteel

/datum/supply_pack/companies/ballistics/blacksteel

/datum/supply_pack/companies/ballistics/blacksteel/longbow
	contains = list(/obj/item/gun/ballistic/bow/longbow)
	cost = CARGO_CRATE_VALUE * 1.5
