/datum/supply_pack/vending
	group = "Vending Restocks"

/datum/supply_pack/vending/bartending
	name = "酒饮和咖啡补给箱"
	desc = "来点酒精和咖啡自动售货机的补充吧。"
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/vending_refill/boozeomat,
					/obj/item/vending_refill/coffee,
				)
	crate_name = "bartending supply crate"

/datum/supply_pack/vending/cigarette
	name = "Cigarette Supply Crate"
	desc = "Don't believe the reports - smoke today! Contains a \
		cigarette vending machine refill."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/vending_refill/cigarette)
	crate_name = "cigarette supply crate"
	crate_type = /obj/structure/closet/crate/robust

/datum/supply_pack/vending/science/cytopro
	name = "Cytology Vendor Supply Crate"
	desc = "For all your vat-growing needs! Contains a CytoPro machine refill."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/vending_refill/cytopro)
	crate_name = "cytopro supply crate"

/datum/supply_pack/vending/dinnerware
	name = "Dinnerware Supply Crate"
	desc = "给大厨准备更多的刀。"
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/vending_refill/dinnerware)
	crate_name = "dinnerware supply crate"

/datum/supply_pack/vending/science/modularpc
	name = "豪华掌上电脑精选补货"
	desc = "计算机是什么？包含一个豪华掌上电脑精选补货装置。"
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/vending_refill/modularpc)
	crate_name = "computer supply crate"

/datum/supply_pack/vending/engivend
	name = "EngiVend Supply Crate"
	desc = "工程师的金属泡沫手榴弹用完了？这个应该有帮助。"
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/vending_refill/engivend)
	crate_name = "engineering supply crate"

/datum/supply_pack/vending/games
	name = "Games Supply Crate"
	desc = "用这台游戏自动售货机补充你的游戏乐趣。"
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/vending_refill/games)
	crate_name = "games supply crate"
	crate_type = /obj/structure/closet/crate

/datum/supply_pack/vending/hydro_refills
	name = "水培自动售货机补充品"
	desc = "When the clown takes all the banana seeds. \
		Contains a NutriMax refill and a MegaSeed Servitor refill."
	cost = CARGO_CRATE_VALUE * 4
	crate_type = /obj/structure/closet/crate
	contains = list(/obj/item/vending_refill/hydroseeds,
					/obj/item/vending_refill/hydronutrients,
				)
	crate_name = "hydroponics supply crate"

/datum/supply_pack/vending/imported
	name = "进口自动售货机"
	desc = "在银河系其他地方也很有名的自动售货机。"
	cost = CARGO_CRATE_VALUE * 5
	contains = list(/obj/item/vending_refill/sustenance,
					/obj/item/vending_refill/robotics,
					/obj/item/vending_refill/sovietsoda,
					/obj/item/vending_refill/engineering,
				)
	crate_name = "unlabeled supply crate"

/datum/supply_pack/vending/medical
	name = "Medical Vending Crate"
	desc = "Contains one NanoMed Plus refill, one NanoDrug Plus refill, \
		and one wall-mounted NanoMed refill."
	cost = CARGO_CRATE_VALUE * 3.5
	contains = list(/obj/item/vending_refill/medical,
					/obj/item/vending_refill/drugs,
					/obj/item/vending_refill/wallmed,
				)
	crate_name = "medical vending crate"

/datum/supply_pack/vending/ptech
	name = "PTech Supply Crate"
	desc = "Not enough cartridges after half the crew lost their PDA \
		to explosions? This may fix it."
	cost = CARGO_CRATE_VALUE * 2.5
	contains = list(/obj/item/vending_refill/cart)
	crate_name = "\improper PTech supply crate"

/datum/supply_pack/vending/sectech
	name = "SecTech Supply Crate"
	desc = "Officer Paul bought all the donuts? Then refill the security \
		vendor with this crate."
	cost = CARGO_CRATE_VALUE * 3
	access = ACCESS_SECURITY
	contains = list(/obj/item/vending_refill/security)
	crate_name = "\improper SecTech supply crate"
	crate_type = /obj/structure/closet/crate/secure/gear

/datum/supply_pack/vending/snack
	name = "零食贩卖机补给箱"
	desc = "One vending machine refill of cavity-bringin' goodness! \
		The number one dentist recommended order!"
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/vending_refill/snack)
	crate_name = "snacks supply crate"
	crate_type = /obj/structure/closet/crate/robust

/datum/supply_pack/vending/cola
	name = "汽水贩卖机补给箱"
	desc = "Got whacked by a toolbox, but you still have those pesky teeth? \
		Get rid of those pearly whites with this soda machine refill, today!"
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/vending_refill/cola)
	crate_name = "soft drinks supply crate"

/datum/supply_pack/vending/vendomat
	name = "Part-Mart & YouTool Supply Crate"
	desc = "为您的IED测试设施提供更多工具。"
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/vending_refill/assist,
					/obj/item/vending_refill/youtool,
				)
	crate_name = "\improper Part-Mart & YouTool supply crate"

/datum/supply_pack/vending/clothesmate
	name = "ClothesMate Supply Crate"
	desc = "牛仔靴卖完了？买这个箱子吧。"
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/vending_refill/clothing)
	crate_name = "\improper ClothesMate supply crate"


/// Clothing Vending Restocks

/datum/supply_pack/vending/wardrobes/autodrobe
	name = "Autodrobe Supply Crate"
	desc = "Autodrobe missing your favorite dress? Solve that issue today \
		with this autodrobe refill."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/vending_refill/autodrobe)
	crate_name = "autodrobe supply crate"

/datum/supply_pack/vending/wardrobes/cargo
	name = "补给衣橱补给箱"
	desc = "这个箱子里装有 CargoDrobe 的补充包。"
	cost = CARGO_CRATE_VALUE * 1.5
	contains = list(/obj/item/vending_refill/wardrobe/cargo_wardrobe)
	crate_name = "cargo department supply crate"

/datum/supply_pack/vending/wardrobes/engineering
	name = "工程衣橱补给箱"
	desc = "这个箱子里装有用于EngiDrobe和AtmosDrobe的补充装。"
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/vending_refill/wardrobe/engi_wardrobe,
					/obj/item/vending_refill/wardrobe/atmos_wardrobe,
				)
	crate_name = "engineering department wardrobe supply crate"

/datum/supply_pack/vending/wardrobes/general
	name = "通用衣橱补给箱"
	desc = "This crate contains refills for the CuraDrobe, BarDrobe, \
		ChefDrobe and ChapDrobe."
	cost = CARGO_CRATE_VALUE * 6
	contains = list(/obj/item/vending_refill/wardrobe/curator_wardrobe,
					/obj/item/vending_refill/wardrobe/bar_wardrobe,
					/obj/item/vending_refill/wardrobe/chef_wardrobe,
					/obj/item/vending_refill/wardrobe/chap_wardrobe,
				)
	crate_name = "general wardrobes vendor refills"

/datum/supply_pack/vending/wardrobes/hydroponics
	name = "Hydrobe Supply Crate"
	desc = "这个箱子里有一个 Hydrobe 的补充装。"
	cost = CARGO_CRATE_VALUE * 1.5
	contains = list(/obj/item/vending_refill/wardrobe/hydro_wardrobe)
	crate_name = "hydrobe supply crate"

/datum/supply_pack/vending/wardrobes/janitor
	name = "JaniDrobe Supply Crate"
	desc = "这个箱子里装有 JaniDrobe 的补充装。"
	cost = CARGO_CRATE_VALUE * 1.5
	contains = list(/obj/item/vending_refill/wardrobe/jani_wardrobe)
	crate_name = "janidrobe supply crate"

/datum/supply_pack/vending/wardrobes/medical
	name = "医疗衣橱补给箱"
	desc = "This crate contains refills for the MediDrobe, \
		ChemDrobe, ViroDrobe, and MortiDrobe."
	cost = CARGO_CRATE_VALUE * 6
	contains = list(/obj/item/vending_refill/wardrobe/medi_wardrobe,
					/obj/item/vending_refill/wardrobe/chem_wardrobe,
					/obj/item/vending_refill/wardrobe/viro_wardrobe,
					/obj/item/vending_refill/wardrobe/coroner_wardrobe,
				)
	crate_name = "medical department wardrobe supply crate"

/datum/supply_pack/vending/wardrobes/science
	name = "科研衣橱补给箱"
	desc = "This crate contains refills for the SciDrobe, \
		GeneDrobe, and RoboDrobe."
	cost = CARGO_CRATE_VALUE * 4.5
	contains = list(/obj/item/vending_refill/wardrobe/robo_wardrobe,
					/obj/item/vending_refill/wardrobe/gene_wardrobe,
					/obj/item/vending_refill/wardrobe/science_wardrobe,
				)
	crate_name = "science department wardrobe supply crate"

/datum/supply_pack/vending/wardrobes/security
	name = "安保衣橱补给箱"
	desc = "This crate contains refills for the SecDrobe, \
		DetDrobe and LawDrobe."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/obj/item/vending_refill/wardrobe/sec_wardrobe,
					/obj/item/vending_refill/wardrobe/det_wardrobe,
					/obj/item/vending_refill/wardrobe/law_wardrobe,
				)
	crate_name = "security department supply crate"
