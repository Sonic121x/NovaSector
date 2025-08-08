/obj/item/food/donkpocket/rat
	name = "\improper 鼠口袋饼"
	desc = "Donk 公司声明：本口袋饼生产过程中没有任何鼠鼠受到伤害"
	icon = 'modular_z121/icons/obj/food/ratpocket.dmi'
	icon_state = "ratpocket"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/blood = 2,
		/datum/reagent/consumable/nutriment/protein = 4,
		)
	tastes = list("meat" = 2, "blood" = 1)
	foodtypes = RAW | MEAT | GRAIN
	crafting_complexity = FOOD_COMPLEXITY_2
	warm_type = /obj/item/food/donkpocket/warm/rat

/obj/item/food/donkpocket/dank/make_bakeable()
	AddComponent(/datum/component/bakeable, warm_type, rand(baking_time_short, baking_time_long), TRUE, TRUE, child_added_reagents)

/obj/item/food/donkpocket/dank/make_microwaveable()
	AddElement(/datum/element/microwavable, warm_type, child_added_reagents)

/obj/item/food/donkpocket/warm/rat
	name = "温鼠口袋饼"
	desc = "老实说，你不知道为什么加热鼠口袋饼会带来奶酪的味道。"
	icon = 'modular_z121/icons/obj/food/ratpocket.dmi'
	icon_state = "warm_ratpocket"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 9,
		/datum/reagent/consumable/nutriment/protein = 6,
		/datum/reagent/consumable/nutriment/fat = 2,
		/datum/reagent/medicine/omnizine = 4,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("meat" = 2, "cheese" = 3)
	foodtypes = GRAIN | MEAT
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/storage/box/donkpockets/donkpocketrat
	name = "一盒鼠口袋饼"
	icon = 'modular_z121/icons/obj/food/ratpocket.dmi'
	icon_state = "donkpocketrat"
	donktype = /obj/item/food/donkpocket/rat

/datum/crafting_recipe/food/ratpocket
	time = 15
	name = "鼠口袋饼"
	reqs = list(
		/obj/item/food/doughslice = 1,
		/obj/item/food/deadmouse = 1
	)
	result = /obj/item/food/donkpocket/rat
	category = CAT_PASTRY
