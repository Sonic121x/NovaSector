// File ordered by progression

/datum/uplink_category/suits
	name = "太空服"
	weight = 3

/datum/uplink_item/suits
	category = /datum/uplink_category/suits
	surplus = 40

//---- SUITS

/datum/uplink_item/suits/infiltrator_bundle
	name = "Infiltrator MODsuit"
	desc = "Developed by the Roseus Galactic Actors Guild in conjunction with the Gorlex Marauders to produce a functional suit for urban operations, \
			this suit proves to be cheaper than your standard issue MODsuit, with none of the movement restrictions of the space suits employed by the company. \
			However, this greater mobility comes at a cost, and the suit is ineffective at protecting the wearer from the vacuum of space. \
			The suit does come pre-equipped with a special psi-emitter stealth module that makes it impossible to recognize the wearer \
			as well as causing significant demoralization amongst Nanotrasen crew."
	item = /obj/item/mod/control/pre_equipped/infiltrator
	cost = 6
	purchasable_from = ~UPLINK_ALL_SYNDIE_OPS

/datum/uplink_item/suits/space_suit
	name = "Syndicate Space Suit"
	desc = "This red and black Syndicate space suit is less encumbering than Nanotrasen variants, \
			fits inside bags, and has a weapon slot. Nanotrasen crew members are trained to report red space suit \
			sightings, however."
	item = /obj/item/storage/box/syndie_kit/space
	cost = 4

/datum/uplink_item/suits/modsuit
	name = "Syndicate MODsuit"
	desc = "辛迪加特工令人闻风丧胆的MOD套装。配备护甲和一系列内置模块。"
	item = /obj/item/mod/control/pre_equipped/traitor
	cost = 8
	purchasable_from = ~UPLINK_ALL_SYNDIE_OPS //you can't buy it in nuke, because the elite modsuit costs the same while being better

//---- MODULES

/datum/uplink_item/suits/thermal
	name = "MODsuit Thermal Visor Module"
	desc = "一款用于模块服的护目镜。它能让您透过墙壁看到生物。"
	item = /obj/item/mod/module/visor/thermal
	cost = 2

/datum/uplink_item/suits/chameleon
	name = "MODsuit Chameleon Module"
	desc = "一款模块服模块，能让模块服能够伪装成其他物体。"
	item = /obj/item/mod/module/chameleon
	cost = 1

/datum/uplink_item/suits/plate_compression
	name = "MODsuit Plate Compression Module"
	desc = "一款可使模块服收缩变小的模块。但该模块不与存储模块或渗透者模块服兼容。"
	item = /obj/item/mod/module/plate_compression
	cost = 1

/datum/uplink_item/suits/noslip
	name = "MODsuit Anti-Slip Module"
	desc = "一款模块服模块，可防止用户在水中滑倒。"
	item = /obj/item/mod/module/noslip
	cost = 1

/datum/uplink_item/suits/shock_absorber
	name = "MODsuit Shock-Absorber Module"
	desc = "A MODsuit module preventing the user from getting knocked down by batons."
	item = /obj/item/mod/module/shock_absorber
	cost = 1

/datum/uplink_item/suits/modsuit/wraith
	name = "MODsuit wraith cloaking module"
	desc = "A MODsuit module that grants to the user Optical camouflage and the ability to overload light sources to recharge suit power. \
		Incompatible with armored MODsuits."
	item = /obj/item/mod/module/stealth/wraith
	cost = 2
