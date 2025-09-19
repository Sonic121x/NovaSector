/obj/item/food/donkpocket/slime
	name = "\improper 史莱姆口袋饼"
	desc = "为什么一个看起来就是坨史莱姆的饼里会有营养物质，这河里吗？——Donk 首席研究员 ZIPT\ 注:在加热前对非史莱姆人剧毒。"
	icon = 'modular_z121/icons/obj/food/slimepocket.dmi'
	icon_state = "slimepocket"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 10,
		/datum/reagent/consumable/nutriment/protein = 5,
        /datum/reagent/toxin/slimejelly = 8,
		)
	tastes = list("stickiness" = 2, "sweetness" = 1)
	foodtypes = TOXIC | GRAIN
	crafting_complexity = FOOD_COMPLEXITY_2
	warm_type = /obj/item/food/donkpocket/warm/slime

/obj/item/food/donkpocket/warm/slime
	name = "温史莱姆口袋饼"
	desc = "Donk 公司严肃声明:本公司不为食用本口袋饼造成的任何头发变色问题负责。非史莱姆人请磨碎本产品后注射使用。"
	icon = 'modular_z121/icons/obj/food/slimepocket.dmi'
	icon_state = "warm_slimepocket"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 14,
        /datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/medicine/regen_jelly = 6
	)
	tastes = list("stickiness" = 2, "sweetness" = 1)
	foodtypes = GRAIN | TOXIC
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/storage/box/donkpockets/donkpocketslime
	name = "一盒史莱姆口袋饼"
	icon = 'modular_z121/icons/obj/food/slimepocket.dmi'
	icon_state = "donkpocketslime"
	donktype = /obj/item/food/donkpocket/slime

/datum/crafting_recipe/food/slimepocket
	time = 15
	name = "史莱姆口袋饼"
	reqs = list(
		/obj/item/food/doughslice = 1,
		/obj/item/slime_extract/grey = 1
	)
	result = /obj/item/food/donkpocket/slime
	category = CAT_PASTRY
