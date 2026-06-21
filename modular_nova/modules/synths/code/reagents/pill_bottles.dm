// Pill bottles for synthetic healing medications
/obj/item/storage/pill_bottle/liquid_solder
	name = "液态焊锡药丸瓶"
	desc = "包含用于治疗硅基脑损伤的药丸。"
	spawn_count = 7
	spawn_type = /obj/item/reagent_containers/applicator/pill/liquid_solder

// Contains 4 liquid_solder pills instead of 7, and 10u pills instead of 50u.
// 50u pills heal 375 brain damage, 10u pills heal 75.
/obj/item/storage/pill_bottle/liquid_solder/braintumor
	desc = "包含用于治疗硅基脑损伤症状的稀释药丸。感到头晕时服用一粒。"
	spawn_count = 4
	spawn_type = /obj/item/reagent_containers/applicator/pill/liquid_solder/braintumor

/obj/item/storage/pill_bottle/nanite_slurry
	name = "纳米浆液药丸瓶"
	desc = "包含用于治疗机器人身体部位的药丸。"
	spawn_count = 7
	spawn_type = /obj/item/reagent_containers/applicator/pill/nanite_slurry

/obj/item/storage/pill_bottle/system_cleaner
	name = "系统清洁剂药丸瓶"
	desc = "包含用于为硅基身体解毒的药丸。"
	spawn_count = 7
	spawn_type = /obj/item/reagent_containers/applicator/pill/system_cleaner
