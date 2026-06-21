
/////////////////
//Misc. Frozen.//
/////////////////

/datum/crafting_recipe/food/icecreamsandwich
	name = "Icecream sandwich-冰淇淋三明治"
	reqs = list(
		/datum/reagent/consumable/cream = 5,
		/datum/reagent/consumable/ice = 5,
		/obj/item/food/icecream = 1
	)
	result = /obj/item/food/icecreamsandwich
	dish_category = DISH_FROZEN
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/strawberryicecreamsandwich
	name = "Strawberry ice cream sandwich-草莓冰淇淋三明治"
	reqs = list(
		/datum/reagent/consumable/cream = 5,
		/datum/reagent/consumable/ice = 5,
		/obj/item/food/grown/berries = 2,
		/obj/item/food/icecream = 1
	)
	result = /obj/item/food/strawberryicecreamsandwich
	dish_category = DISH_FROZEN
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/spacefreezy
	name ="太空冰棒"
	reqs = list(
		/datum/reagent/consumable/bluecherryjelly = 5,
		/datum/reagent/consumable/spacemountainwind = 15,
		/obj/item/food/icecream = 1
	)
	result = /obj/item/food/spacefreezy
	added_foodtypes = FRUIT
	dish_category = DISH_FROZEN
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/sundae
	name ="圣代"
	reqs = list(
		/datum/reagent/consumable/cream = 5,
		/obj/item/food/grown/cherries = 1,
		/obj/item/food/grown/banana = 1,
		/obj/item/food/icecream = 1
	)
	result = /obj/item/food/sundae
	dish_category = DISH_FROZEN
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/honkdae
	name ="轰克代"
	reqs = list(
		/datum/reagent/consumable/cream = 5,
		/obj/item/clothing/mask/gas/clown_hat = 1,
		/obj/item/food/grown/cherries = 1,
		/obj/item/food/grown/banana = 2,
		/obj/item/food/icecream = 1
	)
	result = /obj/item/food/honkdae
	dish_category = DISH_FROZEN
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/cornuto
	name = "科努托"
	reqs = list(
		/obj/item/food/chocolatebar = 1,
		/datum/reagent/consumable/cream = 4,
		/datum/reagent/consumable/ice = 2,
		/datum/reagent/consumable/sugar = 4,
		/obj/item/food/icecream = 1
	)
	result = /obj/item/food/cornuto
	removed_foodtypes = JUNKFOOD
	dish_category = DISH_FROZEN
	meal_category = MEAL_DESSERT

//////////////////////////SNOW CONES///////////////////////

/datum/crafting_recipe/food/snowcone
	name = "Flavorless snowcone-无味刨冰"
	reqs = list(
		/obj/item/reagent_containers/cup/glass/sillycup = 1,
		/datum/reagent/consumable/ice = 15
	)
	result = /obj/item/food/snowcones
	dish_category = DISH_FROZEN
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/snowcone/pineapple
	name = "Pineapple snowcone-菠萝刨冰"
	reqs = list(
		/obj/item/reagent_containers/cup/glass/sillycup = 1,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/consumable/pineapplejuice = 5
	)
	result = /obj/item/food/snowcones/pineapple

/datum/crafting_recipe/food/snowcone/lime
	name = "Lime snowcone-酸橙刨冰"
	reqs = list(
		/obj/item/reagent_containers/cup/glass/sillycup = 1,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/consumable/limejuice = 5
	)
	result = /obj/item/food/snowcones/lime

/datum/crafting_recipe/food/snowcone/lemon
	name = "Lemon snowcone-柠檬刨冰"
	reqs = list(
		/obj/item/reagent_containers/cup/glass/sillycup = 1,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/consumable/lemonjuice = 5
	)
	result = /obj/item/food/snowcones/lemon

/datum/crafting_recipe/food/snowcone/apple
	name = "Apple snowcone-苹果刨冰"
	reqs = list(
		/obj/item/reagent_containers/cup/glass/sillycup = 1,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/consumable/applejuice = 5
	)
	result = /obj/item/food/snowcones/apple

/datum/crafting_recipe/food/snowcone/grape
	name = "Grape snowcone-葡萄刨冰"
	reqs = list(
		/obj/item/reagent_containers/cup/glass/sillycup = 1,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/consumable/grapejuice = 5
	)
	result = /obj/item/food/snowcones/grape

/datum/crafting_recipe/food/snowcone/orange
	name = "Orange snowcone-橙子刨冰"
	reqs = list(
		/obj/item/reagent_containers/cup/glass/sillycup = 1,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/consumable/orangejuice = 5
	)
	result = /obj/item/food/snowcones/orange

/datum/crafting_recipe/food/snowcone/blue
	name = "Bluecherry snowcone-蓝莓刨冰"
	reqs = list(
		/obj/item/reagent_containers/cup/glass/sillycup = 1,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/consumable/bluecherryjelly= 5
	)
	result = /obj/item/food/snowcones/blue

/datum/crafting_recipe/food/snowcone/red
	name = "Cherry snowcone-樱桃刨冰"
	reqs = list(
		/obj/item/reagent_containers/cup/glass/sillycup = 1,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/consumable/cherryjelly= 5
	)
	result = /obj/item/food/snowcones/red

/datum/crafting_recipe/food/snowcone/berry
	name = "Berry snowcone-浆果刨冰"
	reqs = list(
		/obj/item/reagent_containers/cup/glass/sillycup = 1,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/consumable/berryjuice = 5
	)
	result = /obj/item/food/snowcones/berry

/datum/crafting_recipe/food/snowcone/fruitsalad
	name = "Fruit Salad snowcone-水果沙拉刨冰"
	reqs = list(
		/obj/item/reagent_containers/cup/glass/sillycup = 1,
		/datum/reagent/water = 5,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/consumable/orangejuice = 5,
		/datum/reagent/consumable/limejuice = 5,
		/datum/reagent/consumable/lemonjuice = 5
	)
	result = /obj/item/food/snowcones/fruitsalad

/datum/crafting_recipe/food/snowcone/mime
	name = "Mime snowcone-默剧刨冰"
	reqs = list(
		/obj/item/reagent_containers/cup/glass/sillycup = 1,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/consumable/nothing = 5
	)
	result = /obj/item/food/snowcones/mime

/datum/crafting_recipe/food/snowcone/clown
	name = "Clown snowcone-小丑刨冰"
	reqs = list(
		/obj/item/reagent_containers/cup/glass/sillycup = 1,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/consumable/laughter = 5
	)
	result = /obj/item/food/snowcones/clown

/datum/crafting_recipe/food/snowcone/soda
	name = "Space Cola snowcone-太空可乐刨冰"
	reqs = list(
		/obj/item/reagent_containers/cup/glass/sillycup = 1,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/consumable/space_cola = 5
	)
	result = /obj/item/food/snowcones/soda

/datum/crafting_recipe/food/snowcone/spacemountainwind
	name = "Space Mountain Wind snowcone-太空山风刨冰"
	reqs = list(
		/obj/item/reagent_containers/cup/glass/sillycup = 1,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/consumable/spacemountainwind = 5
	)
	result = /obj/item/food/snowcones/spacemountainwind

/datum/crafting_recipe/food/snowcone/pwrgame
	name = "Pwrgame snowcone-头号玩家刨冰"
	reqs = list(
		/obj/item/reagent_containers/cup/glass/sillycup = 1,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/consumable/pwr_game = 15
	)
	result = /obj/item/food/snowcones/pwrgame

/datum/crafting_recipe/food/snowcone/honey
	name = "Honey snowcone-蜂蜜刨冰"
	reqs = list(
		/obj/item/reagent_containers/cup/glass/sillycup = 1,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/consumable/honey = 5
	)
	result = /obj/item/food/snowcones/honey

/datum/crafting_recipe/food/snowcone/rainbow
	name = "Rainbow snowcone-彩虹刨冰"
	reqs = list(
		/obj/item/reagent_containers/cup/glass/sillycup = 1,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/colorful_reagent = 1 //Harder to make
	)
	result = /obj/item/food/snowcones/rainbow

//////////////////////////POPSICLES///////////////////////

// This section includes any frozen treat served on a stick.
////////////////////////////////////////////////////////////

/datum/crafting_recipe/food/orange_popsicle
	name = "Orange popsicle-橙子冰棍"
	reqs = list(
		/obj/item/popsicle_stick = 1,
		/datum/reagent/consumable/orangejuice = 4,
		/datum/reagent/consumable/ice = 2,
		/datum/reagent/consumable/cream = 2,
		/datum/reagent/consumable/vanilla = 2,
		/datum/reagent/consumable/sugar = 2
	)
	result = /obj/item/food/popsicle/creamsicle_orange
	dish_category = DISH_FROZEN
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/berry_popsicle
	name = "Berry popsicle-浆果冰棍"
	reqs = list(
		/obj/item/popsicle_stick = 1,
		/datum/reagent/consumable/berryjuice = 4,
		/datum/reagent/consumable/ice = 2,
		/datum/reagent/consumable/cream = 2,
		/datum/reagent/consumable/vanilla = 2,
		/datum/reagent/consumable/sugar = 2
	)
	result = /obj/item/food/popsicle/creamsicle_berry
	dish_category = DISH_FROZEN
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/jumbo
	name = "Jumbo icecream-巨无霸冰淇淋"
	reqs = list(
		/obj/item/popsicle_stick = 1,
		/obj/item/food/chocolatebar = 1,
		/datum/reagent/consumable/ice = 2,
		/datum/reagent/consumable/cream = 2,
		/datum/reagent/consumable/vanilla = 3,
		/datum/reagent/consumable/sugar = 2
	)
	result = /obj/item/food/popsicle/jumbo
	added_foodtypes = DAIRY
	removed_foodtypes = JUNKFOOD
	dish_category = DISH_FROZEN
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/licorice_creamsicle
	name = "Licorice popsicle-甘草冰淇淋"
	reqs = list(
		/obj/item/popsicle_stick = 1,
		/datum/reagent/consumable/blumpkinjuice = 4, //natural source of ammonium chloride
		/datum/reagent/consumable/salt = 2,
		/datum/reagent/consumable/ice = 2,
		/datum/reagent/consumable/cream = 2,
		/datum/reagent/consumable/vanilla = 2,
		/datum/reagent/consumable/sugar = 2
	)
	result = /obj/item/food/popsicle/licorice_creamsicle
	dish_category = DISH_FROZEN
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/meatsicle
	name = "肉冰棒"
	reqs = list(
		/obj/item/popsicle_stick = 1,
		/obj/item/food/meat/slab = 1,
		/datum/reagent/consumable/ice = 2,
		/datum/reagent/consumable/sugar = 2
	)
	result = /obj/item/food/popsicle/meatsicle
	added_foodtypes = SUGAR
	dish_category = DISH_FROZEN
	meal_category = MEAL_DESSERT
