/obj/item/food/donkpocket/liver
	name = "\improper 肝口袋饼"
	desc = "Donk 公司声明：本口袋饼生产过程中没有任何肝脏受到伤害"
	icon = 'modular_z121/icons/obj/food/liverpocket.dmi'
	icon_state = "liverpocket"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/iron = 5,
		/datum/reagent/consumable/nutriment/organ_tissue = 2,
		/datum/reagent/consumable/nutriment/peptides = 3,
		/datum/reagent/medicine/higadrite = 4
		)
	tastes = list("earthly pungent" = 2, "iron" = 1)
	foodtypes = MEAT/GORE
	crafting_complexity = FOOD_COMPLEXITY_2
	warm_type = /obj/item/food/donkpocket/warm/liver

/obj/item/food/donkpocket/dank/make_bakeable()
	AddComponent(/datum/component/bakeable, warm_type, rand(baking_time_short, baking_time_long), TRUE, TRUE, child_added_reagents)

/obj/item/food/donkpocket/dank/make_microwaveable()
	AddElement(/datum/element/microwavable, warm_type, child_added_reagents)

/obj/item/food/donkpocket/warm/liver
	name = "温肝口袋饼"
	desc = "冰冷的肝脏化为了温暖的口袋饼"
	icon = 'modular_z121/icons/obj/food/liverpocket.dmi'
	icon_state = "warm_liverpocket"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/iron = 5,
		/datum/reagent/consumable/nutriment/organ_tissue = 2,
		/datum/reagent/consumable/nutriment/peptides = 3,
		/datum/reagent/medicine/omnizine = 5,
		/datum/reagent/medicine/higadrite = 4
	)
	tastes = list("meat" = 2, "iron" = 1)
	foodtypes = MEAT
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/storage/box/donkpockets/donkpocketliver
	name = "一盒肝口袋饼"
	icon = 'modular_z121/icons/obj/food/liverpocket.dmi'
	icon_state = "donkpocketliver"
	donktype = /obj/item/food/donkpocket/liver
