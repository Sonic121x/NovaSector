/obj/machinery/vending/toyliberationstation
	name = "\improper 辛迪加杜松玩具售货机"
	desc = "为8岁及以上儿童提供玩具的售货机。如果你找到正确的电线，你可以解锁成人模式设置！"
	icon_state = "syndi"
	panel_type = "panel18"
	product_slogans = "Get your cool toys today!;Trigger a valid hunter today!;Quality toy weapons for cheap prices!;Give them to HoPs for all access!;Give them to HoS to get permabrigged!"
	product_ads = "Feel robust with your toys!;Express your inner child today!;Toy weapons don't kill people, but valid hunters do!;Who needs responsibilities when you have toy weapons?;Make your next murder FUN!"
	vend_reply = "Come back for more!"
	products = list(
		/obj/item/card/emagfake = 4,
		/obj/item/hot_potato/harmless/toy = 4,
		/obj/item/toy/sword = 12,
		/obj/item/dualsaber/toy = 12,
		/obj/item/toy/foamblade = 12,
		/obj/item/gun/ballistic/automatic/pistol/toy/riot = 8,
		/obj/item/gun/ballistic/automatic/toy/riot = 8,
		/obj/item/gun/ballistic/shotgun/toy/riot = 8,
		/obj/item/ammo_box/foambox = 20,
	)
	contraband = list(
		/obj/item/toy/balloon/syndicate = 1,
		/obj/item/gun/ballistic/shotgun/toy/crossbow/riot = 8,
		/obj/item/storage/belt/sheath/katana/toy = 12,
	)
	premium = list(
		/obj/item/toy/cards/deck/syndicate = 12,
		/obj/item/storage/box/fakesyndiesuit = 4,
		/obj/item/gun/ballistic/automatic/c20r/toy/unrestricted/riot = 4,
		/obj/item/gun/ballistic/automatic/l6_saw/toy/unrestricted/riot = 4,
		/obj/item/ammo_box/foambox/riot = 20,
	)
	armor_type = /datum/armor/vending_toyliberationstation
	resistance_flags = FIRE_PROOF
	refill_canister = /obj/item/vending_refill/donksoft
	default_price = PAYCHECK_CREW
	extra_price = PAYCHECK_COMMAND
	payment_department = NO_FREEBIES
	light_mask = "donksoft-light-mask"
	allow_custom = FALSE

/datum/armor/vending_toyliberationstation
	melee = 100
	bullet = 100
	laser = 100
	energy = 100
	fire = 100
	acid = 50
