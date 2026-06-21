/datum/supply_pack/materials
	group = "Canisters & Materials"

/datum/supply_pack/materials/cardboard50
	name = "50张纸板"
	desc = "制作一堆盒子。"
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/stack/sheet/cardboard/fifty)
	crate_name = "cardboard sheets crate"

/datum/supply_pack/materials/license50
	name = "50张空车牌"
	desc = "制作一堆车牌。"
	cost = CARGO_CRATE_VALUE * 2  // 50 * 25 + 700 - 1000 = 950 credits profit
	access_view = ACCESS_BRIG_ENTRANCE
	contains = list(/obj/item/stack/license_plates/empty/fifty)
	crate_name = "empty license plate crate"

/datum/supply_pack/materials/plastic50
	name = "50块塑料板"
	desc = "用50张塑料制作无限数量的玩具！"
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/stack/sheet/plastic/fifty)
	crate_name = "plastic sheets crate"

/datum/supply_pack/materials/sandstone30
	name = "30块砂岩块"
	desc = "Neither sandy nor stony, these thirty blocks will still get the job done."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/stack/sheet/mineral/sandstone/thirty)
	crate_name = "sandstone blocks crate"

/datum/supply_pack/materials/wood50
	name = "50块木板"
	desc = "Turn cargo's boring metal groundwork into beautiful \
		panelled flooring and much more with fifty wooden planks!"
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/obj/item/stack/sheet/mineral/wood/fifty)
	crate_name = "wood planks crate"

/datum/supply_pack/materials/foamtank
	name = "消防泡沫箱"
	desc = "装有一罐消防泡沫。也被称为“等离子人的克星”。"
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/structure/reagent_dispensers/foamtank)
	crate_name = "foam tank crate"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/materials/fueltank
	name = "Fuel Tank Crate"
	desc = "包含一个焊接油箱。小心，高度易燃。"
	cost = CARGO_CRATE_VALUE * 1.6
	contains = list(/obj/structure/reagent_dispensers/fueltank)
	crate_name = "fuel tank crate"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/materials/hightankfuel
	name = "大型燃料箱板条箱"
	desc = "包含一个高容量油箱。请将物品远离明火。"
	cost = CARGO_CRATE_VALUE * 4
	access_view = ACCESS_ENGINEERING
	contains = list(/obj/structure/reagent_dispensers/fueltank/large)
	crate_name = "high-capacity fuel tank crate"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/materials/watertank
	name = "Water Tank Crate"
	desc = "装有一罐一氧化二氢.....听起来很危险。"
	cost = CARGO_CRATE_VALUE * 1.2
	contains = list(/obj/structure/reagent_dispensers/watertank)
	crate_name = "water tank crate"
	crate_type = /obj/structure/closet/crate/large

/datum/supply_pack/materials/gas_canisters
	cost = CARGO_CRATE_VALUE * 0.05
	contains = list(/obj/machinery/portable_atmospherics/canister)
	crate_type = /obj/structure/closet/crate/large
	test_ignored = TRUE

/datum/supply_pack/materials/gas_canisters/generate_supply_packs()
	var/list/canister_packs = list()

	var/obj/machinery/portable_atmospherics/canister/fakeCanister = /obj/machinery/portable_atmospherics/canister
	// This is the amount of moles in a default canister
	var/moleCount = (initial(fakeCanister.maximum_pressure) * initial(fakeCanister.filled)) * initial(fakeCanister.volume) / (R_IDEAL_GAS_EQUATION * T20C)

	for(var/gasType in GLOB.meta_gas_info)
		var/datum/gas/gas = gasType
		var/name = initial(gas.name)
		if(!initial(gas.purchaseable))
			continue
		var/datum/supply_pack/materials/pack = new
		pack.name = "[name] Canister"
		pack.desc = "包含一气罐的[name]"
		if(initial(gas.dangerous))
			pack.access = ACCESS_ATMOSPHERICS
			pack.access_view = ACCESS_ATMOSPHERICS
		pack.crate_name = "[name] canister crate"
		pack.id = "[type]([name])"

		pack.cost = cost + moleCount * (GLOB.gas_base_values[gas] || initial(gas.base_value)) * 1.6 // NOVA EDIT CHANGE - ORIGINAL: pack.cost = cost + moleCount * initial(gas.base_value) * 1.6
		pack.cost = CEILING(pack.cost, 10)

		pack.test_ignored = FALSE

		pack.contains = list(GLOB.gas_id_to_canister[initial(gas.id)])

		pack.crate_type = crate_type

		canister_packs += pack

	return canister_packs
