/datum/supply_pack/science/synthetic_burns
	name = "合成物灼伤处理套件"
	desc = "包含预冷的汞齐和二氮等离子体瓶，非常适合处理合成物灼伤！"
	cost = CARGO_CRATE_VALUE * 2.5
	contains = list(/obj/item/reagent_containers/spray/hercuri/chilled = 3, /obj/item/reagent_containers/spray/dinitrogen_plasmide = 3)
	crate_name = "chilled hercuri crate"

	access_view = FALSE
	access = FALSE
	access_any = FALSE

/datum/supply_pack/science/synth_treatment_kits
	name = "合成物治疗套件"
	desc = "包含 2 个合成生命体治疗套件，装满治疗无机伤口所需的一切物品！"
	cost = CARGO_CRATE_VALUE * 4.5
	contains = list(/obj/item/storage/backpack/duffelbag/synth_treatment_kit = 2)
	crate_name = "synthetic treatment kits crate"

	access_view = FALSE
	access = FALSE
	access_any = FALSE

/datum/supply_pack/science/synth_healing_chems
	name = "合成物药品包"
	desc = "包含多种合成物专用药品。2 瓶液态焊剂，2 瓶纳米浆液，2 瓶系统清洁剂。"
	cost = CARGO_CRATE_VALUE * 7 // rarely made, so it should be expensive(?)
	contains = list(
		/obj/item/storage/pill_bottle/liquid_solder = 2,
		/obj/item/storage/pill_bottle/nanite_slurry = 2,
		/obj/item/storage/pill_bottle/system_cleaner = 2
	)
	crate_name = "synthetic medicine crate"

	access_view = FALSE
	access = FALSE
	access_any = FALSE

/datum/supply_pack/science/synth_medkits
	name = "机械维修套件"
	desc = "包含几个低级的便携式合成物医疗套件，适合分发给船员。"
	cost = CARGO_CRATE_VALUE * 4.5 // same as treatment kits
	contains = list(/obj/item/storage/medkit/robotic_repair/stocked = 4)

	crate_name = "synthetic repair kits crate"

	access_view = FALSE
	access = FALSE
	access_any = FALSE
