/datum/supply_pack/security/armory/soft_armor
	name = "软质护甲套装板条箱"
	crate_name = "soft armor kit crate"
	desc = "包含三套太阳联邦制造的软质防弹衣和配套头盔。"
	cost = CARGO_CRATE_VALUE * 5
	contains = list(
		/obj/item/clothing/head/helmet/sf_peacekeeper/debranded = 3,
		/obj/item/clothing/suit/armor/sf_peacekeeper/debranded = 3,
	)

/datum/supply_pack/security/armory/hardened_armor
	name = "硬化护甲套装板条箱"
	crate_name = "hardened armor kit crate"
	desc = "包含三套太阳联邦制造的硬化防弹衣和配套头盔。"
	cost = CARGO_CRATE_VALUE * 5
	contains = list(
		/obj/item/clothing/head/helmet/toggleable/sf_hardened = 3,
		/obj/item/clothing/suit/armor/sf_hardened = 3,
	)

/datum/supply_pack/security/armory/sacrificial_armor
	name = "牺牲护甲套装板条箱"
	crate_name = "sacrificial armor kit crate"
	desc = "包含三套太阳联邦制造的牺牲防弹衣和配套头盔。"
	cost = CARGO_CRATE_VALUE * 5
	contains = list(
		/obj/item/clothing/head/helmet/sf_sacrificial = 3,
		/obj/item/sacrificial_face_shield = 3,
		/obj/item/clothing/suit/armor/sf_sacrificial = 3,
	)
