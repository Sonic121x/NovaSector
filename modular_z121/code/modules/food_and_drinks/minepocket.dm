/obj/item/food/donkpocket/mine
	name = "\improper 默剧口袋饼"
	desc = "..."
	icon = 'modular_z121/icons/obj/food/pocket/minepocket.dmi'
	icon_state = "minepocket"
	food_reagents = list(
		/datum/reagent/nitrogent = 4,
		/datum/reagent/oxygen = 1,
        /datum/reagent/toxin/slimejelly = 6,
		/datum/reagent/consumable/nutriment = 6,
        /datum/reagent/consumable/nutriment/protein = 4,
		)
	tastes = list("nothing" = 2)
	foodtypes = GRAIN
	crafting_complexity = FOOD_COMPLEXITY_2
	warm_type = /obj/item/food/donkpocket/warm/mine

/obj/item/food/donkpocket/warm/mine
	name = "温默剧口袋饼"
	desc = "..."
	icon = 'modular_z121/icons/obj/food/pocket/minepocket.dmi'
	icon_state = "warm_minepocket"
	food_reagents = list(
		/datum/reagent/nitrogent = 4,
		/datum/reagent/oxygen = 1,
		/datum/reagent/toxin/mutetoxin
		/datum/reagent/consumable/nutriment = 6,
        /datum/reagent/consumable/nutriment/protein = 4
	)
	tastes = list("nothing" = 2)
	foodtypes = GRAIN
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/storage/box/donkpockets/donkpocketslime
	name = "一盒默剧口袋饼"
	icon = 'modular_z121/icons/obj/food/pocket/minepocket.dmi'
	icon_state = "donkpocketmine"
	donktype = /obj/item/food/donkpocket/mine

/datum/crafting_recipe/food/minepocket
	time = 15
	name = "默剧口袋饼"
	reqs = list(
		/obj/item/food/doughslice = 1,
		/datum/reagent/nitrogent = 20,
		/datum/reagent/oxygen = 5
	)
	result = /obj/item/food/donkpocket/slime
	category = CAT_PASTRY
