// This is the home of drink related tablecrafting recipes, I have opted to only let players bottle fancy boozes to reduce the number of entries.

///////////////// Booze & Bottles ///////////////////

/datum/crafting_recipe/lizardwine
	name = "Lizard Wine-蜥蜴酒"
	time = 4 SECONDS
	reqs = list(
		/obj/item/organ/tail/lizard = 1,
		/datum/reagent/consumable/ethanol = 100
	)
	blacklist = list(/obj/item/organ/tail/lizard/fake)
	result = /obj/item/reagent_containers/cup/glass/bottle/lizardwine
	category = CAT_DRINK

/datum/crafting_recipe/moonshinejug
	name = "非法烈酒"
	time = 3 SECONDS
	reqs = list(
		/obj/item/reagent_containers/cup/glass/bottle = 1,
		/datum/reagent/consumable/ethanol/moonshine = 100
	)
	result = /obj/item/reagent_containers/cup/glass/bottle/moonshine
	category = CAT_DRINK

/datum/crafting_recipe/hoochbottle
	name = "装私酒的瓶子"
	time = 3 SECONDS
	reqs = list(
		/obj/item/reagent_containers/cup/glass/bottle = 1,
		/obj/item/storage/box/papersack = 1,
		/datum/reagent/consumable/ethanol/hooch = 100
	)
	result = /obj/item/reagent_containers/cup/glass/bottle/hooch
	requirements_mats_blacklist = list(/obj/item/storage/box/papersack)
	category = CAT_DRINK

/datum/crafting_recipe/blazaambottle
	name = "布拉扎姆酒瓶"
	time = 2 SECONDS
	reqs = list(
		/obj/item/reagent_containers/cup/glass/bottle = 1,
		/datum/reagent/consumable/ethanol/blazaam = 100
	)
	result = /obj/item/reagent_containers/cup/glass/bottle/blazaam
	category = CAT_DRINK

/datum/crafting_recipe/champagnebottle
	name = "香槟酒瓶"
	time = 3 SECONDS
	reqs = list(
		/obj/item/reagent_containers/cup/glass/bottle = 1,
		/datum/reagent/consumable/ethanol/champagne = 100
	)
	result = /obj/item/reagent_containers/cup/glass/bottle/champagne
	category = CAT_DRINK

/datum/crafting_recipe/trappistbottle
	name = "特拉普酒瓶"
	time = 1.5 SECONDS
	reqs = list(
		/obj/item/reagent_containers/cup/glass/bottle/small = 1,
		/datum/reagent/consumable/ethanol/trappist = 50
	)
	result = /obj/item/reagent_containers/cup/glass/bottle/trappist
	category = CAT_DRINK

/datum/crafting_recipe/goldschlagerbottle
	name = "金施拉格酒瓶"
	time = 3 SECONDS
	reqs = list(
		/obj/item/reagent_containers/cup/glass/bottle = 1,
		/datum/reagent/consumable/ethanol/goldschlager = 100
	)
	result = /obj/item/reagent_containers/cup/glass/bottle/goldschlager
	category = CAT_DRINK

/datum/crafting_recipe/patronbottle
	name = "帕特龙酒瓶"
	time = 3 SECONDS
	reqs = list(
		/obj/item/reagent_containers/cup/glass/bottle = 1,
		/datum/reagent/consumable/ethanol/patron = 100
	)
	result = /obj/item/reagent_containers/cup/glass/bottle/patron
	category = CAT_DRINK

////////////////////// Non-alcoholic recipes ///////////////////

/datum/crafting_recipe/holybottle
	name = "圣水烧瓶"
	time = 3 SECONDS
	reqs = list(
		/obj/item/reagent_containers/cup/glass/bottle = 1,
		/datum/reagent/water/holywater = 100
	)
	result = /obj/item/reagent_containers/cup/glass/bottle/holywater
	category = CAT_DRINK

//flask of unholy water is a beaker for some reason, I will try making it a bottle and add it here once the antag freeze is over. t. kryson

/datum/crafting_recipe/nothingbottle
	name = "虚无酒瓶"
	time = 3 SECONDS
	reqs = list(
		/obj/item/reagent_containers/cup/glass/bottle = 1,
		/datum/reagent/consumable/nothing = 100
	)
	result = /obj/item/reagent_containers/cup/glass/bottle/bottleofnothing
	category = CAT_DRINK

/datum/crafting_recipe/smallcarton
	name = "小纸盒"
	result = /obj/item/reagent_containers/cup/glass/bottle/juice/smallcarton
	time = 1 SECONDS
	reqs = list(/obj/item/stack/sheet/cardboard = 1)
	category = CAT_CONTAINERS

/datum/crafting_recipe/candycornliquor
	name = "candy corn liquor-甜玉米酒"
	result = /obj/item/reagent_containers/cup/glass/bottle/candycornliquor
	time = 3 SECONDS
	reqs = list(/datum/reagent/consumable/ethanol/whiskey = 100,
				/obj/item/food/candy_corn = 1,
				/obj/item/reagent_containers/cup/glass/bottle = 1)
	category = CAT_DRINK

/datum/crafting_recipe/kong
	name = "Kong-港酒"
	result = /obj/item/reagent_containers/cup/glass/bottle/kong
	time = 3 SECONDS
	reqs = list(/datum/reagent/consumable/ethanol/whiskey = 100,
				/obj/item/food/monkeycube = 1,
				/obj/item/reagent_containers/cup/glass/bottle = 1)
	category = CAT_DRINK

/datum/crafting_recipe/pruno
	name = "pruno mix-监狱酒升级版"
	result = /obj/item/reagent_containers/cup/glass/bottle/pruno
	time = 3 SECONDS
	reqs = list(/obj/item/storage/bag/trash = 1,
		/obj/item/food/breadslice/moldy = 1,
		/obj/item/food/grown = 4,
		/obj/item/food/candy_corn = 2,
		/datum/reagent/water = 15,
	)
	//We can't spawn the abstract food/grown path
	unit_test_spawn_extras = list(/obj/item/food/grown/banana = 4)
	category = CAT_DRINK

/datum/crafting_recipe/lean
	name = "紫水"
	result = /obj/item/reagent_containers/cup/glass/colocup/lean
	time = 1 SECONDS
	reqs = list(/obj/item/reagent_containers/cup/glass/colocup = 1,
				/obj/item/food/gumball = 2,
				/datum/reagent/medicine/morphine = 5,
				/datum/reagent/consumable/space_up = 15)
	category = CAT_DRINK
