/datum/design/ration
	name = "外域殖民口粮"
	id = "slavic_mre"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 550)
	build_path = /obj/item/storage/box/colonial_rations
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HC_FOOD,
	)

/datum/design/pljeskavica
	name = "外域殖民口粮，主菜"
	id = "slavic_burger"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 200)
	build_path = /obj/effect/spawner/random/food_or_drink/colonial_main
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HC_FOOD,
	)

/datum/design/nachos
	name = "外域殖民口粮，配菜"
	id = "mexican_chips"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 150)
	build_path = /obj/effect/spawner/random/food_or_drink/colonial_side
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HC_FOOD,
	)

/datum/design/blins
	name = "外域殖民口粮，甜点"
	id = "slavic_crepes"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 100)
	build_path = /obj/effect/spawner/random/food_or_drink/colonial_dessert
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HC_FOOD,
	)

///Despite being in the medical.dm file, it's still used to fill your hunger up, as such, technically, is food.
/datum/design/glucose
	name = "舱外活动葡萄糖注射器"
	id = "slavic_glupen"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 150)
	build_path = /obj/item/reagent_containers/hypospray/medipen/glucose
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HC_FOOD,
	)

/datum/design/spork
	name = "外域殖民口粮，餐具"
	id = "slavic_utens"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 75)
	build_path = /obj/item/storage/box/utensils
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HC_FOOD,
	)

/datum/design/bubblegum
	name = "外域殖民口粮，泡泡糖包"
	id = "slavic_gum"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 100)
	build_path = /obj/item/storage/box/gum/colonial
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HC_FOOD,
	)

/datum/design/cup
	name = "空纸杯"
	id = "slavic_cup"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 10)
	build_path = /obj/item/reagent_containers/cup/glass/coffee/colonial/empty
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HC_FOOD,
	)

/datum/design/tea
	name = "红茶粉"
	id = "slavic_tea"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 4)
	make_reagent = /datum/reagent/consumable/powdered_tea
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HC_FOOD,
	)

/datum/design/coffee
	name = "咖啡粉"
	id = "slavic_coffee"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 4)
	make_reagent = /datum/reagent/consumable/powdered_coffee
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HC_FOOD,
	)

/datum/design/cocoa
	name = "热巧克力粉"
	id = "slavic_coco"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 4)
	make_reagent = /datum/reagent/consumable/powdered_coco
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HC_FOOD,
	)

/datum/design/lemonade
	name = "柠檬水粉"
	id = "slavic_lemon"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 4)
	make_reagent = /datum/reagent/consumable/powdered_lemonade
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HC_FOOD,
	)

/datum/design/replicator_sugar
	name = "糖"
	id = "slavic_sugar"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 5)
	make_reagent = /datum/reagent/consumable/sugar
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HC_FOOD,
	)

/datum/design/powdered_milk
	name = "奶粉"
	id = "slavic_milk"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 4)
	make_reagent = /datum/reagent/consumable/powdered_milk
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HC_FOOD,
	)

/datum/design/water
	name = "水"
	id = "slavic_water"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 1)
	make_reagent = /datum/reagent/water
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HC_FOOD,
	)
