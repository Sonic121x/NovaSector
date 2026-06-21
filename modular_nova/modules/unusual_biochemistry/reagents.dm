/datum/reagent/manganese
	name = "锰"
	description = "一种银灰色金属，外观类似铁。它坚硬且非常脆，难以熔合，但容易氧化。"
	color = "#3D3C47"
	taste_description = "metal"
	ph = 6
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

// New blood packs
/obj/item/reagent_containers/blood/haemocyanin
	blood_type = "Haemocyanin"

/obj/item/reagent_containers/blood/chlorocruorin
	blood_type = "Chlorocruorin"

/obj/item/reagent_containers/blood/hemerythrin
	blood_type = "Hemerythrin"

/obj/item/reagent_containers/blood/pinnaglobin
	blood_type = "Pinnaglobin"

/obj/item/reagent_containers/blood/exotic
	blood_type = "Exotic"

/datum/supply_pack/medical/bloodpacks/uncommon
	name = "稀有血型包种类箱"
	desc = "包含十种不同的稀有血型包，用于为患者补充血液。"
	cost = CARGO_CRATE_VALUE * 7
	contains = list(
		/obj/item/reagent_containers/blood/haemocyanin = 2,
		/obj/item/reagent_containers/blood/chlorocruorin = 2,
		/obj/item/reagent_containers/blood/hemerythrin = 2,
		/obj/item/reagent_containers/blood/pinnaglobin = 2,
		/obj/item/reagent_containers/blood/exotic = 2,
	)
	crate_name = "blood freezer"
	crate_type = /obj/structure/closet/crate/freezer
