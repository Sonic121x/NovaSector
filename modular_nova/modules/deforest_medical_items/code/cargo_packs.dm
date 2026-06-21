/datum/supply_pack/medical/civil_defense
	name = "民防医疗包板条箱"
	crate_name = "civil defense medical kit crate"
	desc = "包含十个民防医疗包，这些小型注射器包旨在紧急情况下分发给公众。"
	access = ACCESS_MEDICAL
	cost = CARGO_CRATE_VALUE * 10 // 2000
	contains = list(
		/obj/item/storage/medkit/civil_defense/stocked = 10,
	)

/datum/supply_pack/medical/civil_defense/comfort
	name = "\improper 民防症状支持包板条箱"
	crate_name = "civil defense symptom support kit crate"
	desc = "包含五个民防症状支持包，配备三支psifinil笔和一支装有5片alifil药片的管剂，这是两种DeForest专有混合物，旨在为慢性疾病和重力病等综合征提供长效缓解。"
	access = ACCESS_MEDICAL
	cost = CARGO_CRATE_VALUE * 5 // 2000
	contains = list(
		/obj/item/storage/medkit/civil_defense/comfort/stocked = 10,
	)

/datum/supply_pack/medical/frontier_first_aid
	name = "边疆急救箱板条箱"
	crate_name = "frontier first aid crate"
	desc = "包含边疆医疗包和战地外科医生医疗包各两个。"
	access = ACCESS_MEDICAL
	cost = CARGO_CRATE_VALUE * 10
	contains = list(
		/obj/item/storage/medkit/frontier/stocked = 3,
		/obj/item/storage/medkit/combat_surgeon/stocked = 3,
	)

/datum/supply_pack/medical/kit_technician
	name = "重型医疗包板条箱 - 技术员"
	crate_name = "technician kit crate"
	desc = "包含一个粉红色的医疗技术员包。"
	access = ACCESS_MEDICAL
	cost = CARGO_CRATE_VALUE * 5.5
	contains = list(
		/obj/item/storage/backpack/duffelbag/deforest_paramedic/stocked,
	)

/datum/supply_pack/medical/kit_surgical
	name = "重型医疗包板条箱 - 外科"
	crate_name = "surgical kit crate"
	desc = "包含一个灰色的急救外科包。"
	access = ACCESS_MEDICAL
	cost = CARGO_CRATE_VALUE * 5
	contains = list(
		/obj/item/storage/backpack/duffelbag/deforest_surgical/stocked,
	)

/datum/supply_pack/medical/kit_medical
	name = "重型医疗包板条箱 - 医疗"
	crate_name = "medical kit crate"
	desc = "包含一个橙色的挎包式医疗包。"
	access = ACCESS_MEDICAL
	cost = CARGO_CRATE_VALUE * 4.5
	contains = list(
		/obj/item/storage/backpack/duffelbag/deforest_medkit/stocked,
	)

/datum/supply_pack/medical/deforest_vendor_refill
	name = "DeForest 医疗贩卖机补给箱"
	crate_name = "\improper DeForest Med-Vend resupply crate"
	desc = "包含一个用于 DeForest 医疗贩卖机的补货罐。"
	access = ACCESS_MEDICAL
	cost = CARGO_CRATE_VALUE * 5
	contains = list(
		/obj/item/vending_refill/medical_deforest,
	)
