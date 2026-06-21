/obj/item/reagent_containers/cooler_jug
	name = "冷却水壶"
	desc = "一个巨大、笨重的水壶。是液体冷却器的生命之源。闻起来像刚冷却的塑料。"
	icon = 'icons/obj/medical/chemical_tanks.dmi'
	icon_state = "cooler_jug"
	volume = 200
	custom_materials = list(/datum/material/plastic = SHEET_MATERIAL_AMOUNT * 4)
	initial_reagent_flags = REFILLABLE | DRAINABLE | INJECTABLE | DRAWABLE | TRANSPARENT | NO_SPLASH
	has_variable_transfer_amount = FALSE
	interaction_flags_click = NEED_DEXTERITY
	fill_icon_state = "cooler_jug_overlay"
	fill_icon_thresholds = list(25, 50, 75, 100)
	obj_flags = UNIQUE_RENAME
	w_class = WEIGHT_CLASS_BULKY

/obj/item/reagent_containers/cooler_jug/water
	name = "水壶"
	desc = "An elegant-looking water cooler jug. There's a water cooler out there, somewhere, waiting to be reunited with this. The jug's mouth smells intoxicatingly stale and metallic."
	list_reagents = list(/datum/reagent/water = 200)

/obj/item/reagent_containers/cooler_jug/punch
	name = "潘趣酒壶"
	desc = "一个用于储存水果潘趣酒的壶。上面贴满了数十个警告标签和你不认识的吓人符号。甜美的潘趣酒气味附着在壶口。"
	list_reagents = list(/datum/reagent/consumable/fruit_punch = 200)
