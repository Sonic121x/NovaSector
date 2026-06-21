/datum/round_event_control/easter
	name = "复活节彩蛋大赏"
	holidayID = EASTER
	typepath = /datum/round_event/easter
	weight = -1
	max_occurrences = 1
	earliest_start = 0 MINUTES
	category = EVENT_CATEGORY_HOLIDAY
	description = "在维护区藏匿装满惊喜的复活节彩蛋。"

/datum/round_event/easter/announce(fake)
	priority_announce(pick("蹦蹦跳跳迎复活节！","找找兔兔的藏宝！","今天是全国“猎兔”日。","友善一点，送出巧克力蛋吧！"))


/datum/round_event_control/rabbitrelease
	name = "释放兔子!"
	holidayID = EASTER
	typepath = /datum/round_event/rabbitrelease
	weight = 5
	max_occurrences = 10
	category = EVENT_CATEGORY_HOLIDAY
	description = "召唤一波可爱的兔子。"

/datum/round_event/rabbitrelease/announce(fake)
	priority_announce("检测到不明毛茸物体正在登临[station_name()]。当心可爱袭击。", "毛茸警报", ANNOUNCER_ALIENS)


/datum/round_event/rabbitrelease/start()

	for(var/obj/effect/landmark/event_spawn/spawn_point as anything in GLOB.generic_event_spawns) //Common public bunnies
		if(prob(35))
			new /mob/living/basic/rabbit/easter(spawn_point.loc)
		CHECK_TICK

	for(var/obj/effect/landmark/event_spawn/spawn_point as anything in GLOB.generic_maintenance_landmarks) // The rare maint bunnies
		if(prob(15))
			new /mob/living/basic/rabbit/easter(spawn_point.loc)
		CHECK_TICK

	for(var/obj/effect/landmark/carpspawn/spawn_point in GLOB.landmarks_list) // The rare space bunnies
		if(prob(15))
			new /mob/living/basic/rabbit/easter/space(spawn_point.loc)
		CHECK_TICK


//Easter Baskets
/obj/item/storage/basket/easter
	name = "复活节篮子"
	storage_type = /datum/storage/basket/easter

//Bunny Suit
/obj/item/clothing/head/costume/bunnyhead
	name = "复活节兔头"
	icon_state = "bunnyhead"
	inhand_icon_state = null
	desc = "Considerably more cute than 'Frank'."
	slowdown = -0.3
	clothing_flags = THICKMATERIAL | SNUG_FIT
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT

/obj/item/clothing/suit/costume/bunnysuit
	name = "复活节兔子套装"
	desc = "蹦蹦跳跳！"
	icon_state = "bunnysuit"
	icon = 'icons/obj/clothing/suits/costume.dmi'
	worn_icon = 'icons/mob/clothing/suits/costume.dmi'
	inhand_icon_state = null
	slowdown = -0.3
	clothing_flags = THICKMATERIAL
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT

//Bunny bag!
/obj/item/storage/backpack/satchel/bunnysatchel
	name = "复活节兔子包"
	desc = "对你的眼睛有益。"
	icon_state = "satchel_carrot"
	inhand_icon_state = null

//Egg prizes and egg spawns!
/obj/item/surprise_egg
	name = "彩蛋"
	desc = "一个巧克力蛋，里面有特别的东西。打开包装，享受吧！"
	icon_state = "egg"
	resistance_flags = FLAMMABLE
	w_class = WEIGHT_CLASS_TINY
	icon = 'icons/obj/food/egg.dmi'
	lefthand_file = 'icons/mob/inhands/items/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/food_righthand.dmi'
	obj_flags = UNIQUE_RENAME

/obj/item/surprise_egg/Initialize(mapload)
	. = ..()
	var/eggcolor = pick("blue","green","mime","orange","purple","rainbow","red","yellow")
	icon_state = "egg-[eggcolor]"

/obj/item/surprise_egg/proc/dispensePrize(turf/where)
	var/static/list/prize_list = list(/obj/item/clothing/head/costume/bunnyhead,
		/obj/item/clothing/suit/costume/bunnysuit,
		/obj/item/storage/backpack/satchel/bunnysatchel,
		/obj/item/food/grown/carrot,
		/obj/item/toy/balloon,
		/obj/item/toy/gun,
		/obj/item/toy/sword,
		/obj/item/toy/talking/ai,
		/obj/item/toy/talking/owl,
		/obj/item/toy/talking/griffin,
		/obj/item/toy/minimeteor,
		/obj/item/toy/clockwork_watch,
		/obj/item/toy/toy_xeno,
		/obj/item/toy/foamblade,
		/obj/item/toy/plush/carpplushie,
		/obj/item/toy/redbutton,
		/obj/item/toy/windup_toolbox,
		/obj/item/clothing/head/collectable/rabbitears
		) + subtypesof(/obj/item/toy/mecha)
	var/won = pick(prize_list)
	new won(where)
	new/obj/item/food/chocolateegg(where)

/obj/item/surprise_egg/attack_self(mob/user)
	..()
	to_chat(user, span_notice("你拆开了[src]，发现里面有个奖品！"))
	dispensePrize(get_turf(src))
	qdel(src)

//Easter Recipes + food
/obj/item/food/hotcrossbun
	name = "热十字面包"
	desc = "十字架代表为你的罪而死的助手。"
	icon_state = "hotcrossbun"
	food_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/sugar = 1)
	foodtypes = SUGAR | GRAIN | BREAKFAST
	tastes = list("pastry" = 1, "easter" = 1)
	bite_consumption = 2
	crafting_complexity = FOOD_COMPLEXITY_1

/datum/crafting_recipe/food/hotcrossbun
	name = "热十字面包"
	reqs = list(
		/obj/item/food/breadslice/plain = 1,
		/datum/reagent/consumable/sugar = 1
	)
	result = /obj/item/food/hotcrossbun
	added_foodtypes = SUGAR | BREAKFAST
	dish_category = DISH_BREAD
	meal_category = MEAL_SNACK

/datum/crafting_recipe/food/briochecake
	name = "布里欧修蛋糕"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/datum/reagent/consumable/sugar = 2
	)
	result = /obj/item/food/cake/brioche
	dish_category = DISH_PASTRY
	meal_category = MEAL_DESSERT

/obj/item/food/scotchegg
	name = "苏格兰蛋"
	desc = "一个煮熟的鸡蛋包裹在美味且调味恰当的肉丸之中。"
	icon = 'icons/obj/food/egg.dmi'
	icon_state = "scotchegg"
	bite_consumption = 3
	custom_materials = list(/datum/material/meat = MEATDISH_MATERIAL_AMOUNT)
	food_reagents = list(/datum/reagent/consumable/nutriment = 6, /datum/reagent/consumable/nutriment/vitamin = 2)
	crafting_complexity = FOOD_COMPLEXITY_2
	foodtypes = MEAT|EGG

/datum/crafting_recipe/food/scotchegg
	name = "苏格兰蛋"
	reqs = list(
		/datum/reagent/consumable/salt = 1,
		/datum/reagent/consumable/blackpepper = 1,
		/obj/item/food/boiledegg = 1,
		/obj/item/food/meatball = 1
	)
	result = /obj/item/food/scotchegg
	removed_foodtypes = BREAKFAST
	dish_category = DISH_MEAT
	meal_category = MEAL_APPETIZER

/datum/crafting_recipe/food/mammi
	name = "马米"
	reqs = list(
		/obj/item/food/bread/plain = 1,
		/obj/item/food/chocolatebar = 1,
		/datum/reagent/consumable/milk = 5
	)
	result = /obj/item/food/bowled/mammi
	added_foodtypes = DAIRY
	dish_category = DISH_CANDY
	meal_category = MEAL_DESSERT

/obj/item/food/chocolatebunny
	name = "巧克力兔"
	desc = "含有不到 10% 的真兔子成分！"
	icon_state = "chocolatebunny"
	food_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/sugar = 2, /datum/reagent/consumable/coco = 2, /datum/reagent/consumable/nutriment/vitamin = 1)
	crafting_complexity = FOOD_COMPLEXITY_1
	foodtypes = JUNKFOOD | SUGAR

/datum/crafting_recipe/food/chocolatebunny
	name = "巧克力兔"
	reqs = list(
		/datum/reagent/consumable/sugar = 2,
		/obj/item/food/chocolatebar = 1
	)
	result = /obj/item/food/chocolatebunny
	dish_category = DISH_CANDY
	meal_category = MEAL_DESSERT
