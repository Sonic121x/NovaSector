/obj/item/reagent_containers/applicator/pill/liquid_solder
	name = "液态焊锡药丸"
	desc = "用于治疗硅基脑损伤。"
	icon_state = "pill21"
	list_reagents = list(/datum/reagent/medicine/liquid_solder = 10)
	rename_with_volume = TRUE

// Lower quantity solder pill.
// 50u pills heal 375 brain damage, 10u pills heal 75.
/obj/item/reagent_containers/applicator/pill/liquid_solder/braintumor
	desc = "用于治疗硅基脑损伤的症状。"
	list_reagents = list(/datum/reagent/medicine/liquid_solder = 10)

/obj/item/reagent_containers/applicator/pill/nanite_slurry
	name = "纳米浆液药丸"
	desc = "用于修复机器人身体部位。"
	icon_state = "pill18"
	list_reagents = list(/datum/reagent/medicine/nanite_slurry = 15) // 20 is OD
	rename_with_volume = TRUE

/obj/item/reagent_containers/applicator/pill/system_cleaner
	name = "系统清洁剂药丸"
	desc = "用于为硅基身体解毒。"
	icon_state = "pill7"
	list_reagents = list(/datum/reagent/medicine/system_cleaner = 10)
	rename_with_volume = TRUE
