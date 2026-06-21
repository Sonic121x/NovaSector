/datum/crafting_recipe/food/tiziran_sausage
	name = "Raw Tiziran blood sausage-生蜥蜴式血肠"
	reqs = list(
		/obj/item/food/meat/rawcutlet = 1,
		/obj/item/food/meat/rawbacon = 1,
		/datum/reagent/blood = 5,
		/datum/reagent/consumable/salt = 2
	)
	result = /obj/item/food/raw_tiziran_sausage
	cuisine_category = CUISINE_LIZARD
	dish_category = DISH_MEAT

/datum/crafting_recipe/food/headcheese
	name = "Raw headcheese-生头肉冻"
	reqs = list(
		/obj/item/food/meat/slab = 1,
		/datum/reagent/consumable/salt = 10,
		/datum/reagent/consumable/blackpepper = 5
	)
	result = /obj/item/food/raw_headcheese
	added_foodtypes = GORE
	cuisine_category = CUISINE_LIZARD
	dish_category = DISH_MEAT

/datum/crafting_recipe/food/shredded_lungs
	name = "Crispy shredded lung stirfry-香脆肺丝"
	reqs = list(
		/obj/item/food/grown/carrot = 1,
		/obj/item/food/grown/chili = 1,
		/obj/item/food/grown/onion = 1,
		/obj/item/organ/lungs = 1,
		/obj/item/reagent_containers/cup/bowl = 1,
	)
	blacklist = list(
		/obj/item/organ/lungs/cybernetic,
	)
	result = /obj/item/food/shredded_lungs
	added_foodtypes = MEAT|GORE
	cuisine_category = CUISINE_LIZARD
	dish_category = DISH_SALAD

/datum/crafting_recipe/food/tsatsikh
	name = "Tsatsikh"
	reqs = list(
		/obj/item/organ/heart = 1,
		/obj/item/organ/liver = 1,
		/obj/item/organ/lungs = 1,
		/obj/item/organ/stomach = 1,
		/datum/reagent/consumable/salt = 2,
		/datum/reagent/consumable/blackpepper = 2
	)
	result = /obj/item/food/tsatsikh
	cuisine_category = CUISINE_LIZARD
	dish_category = DISH_MEAT

/datum/crafting_recipe/food/liver_pate
	name = "Liver pate-肝酱"
	reqs = list(
		/obj/item/organ/liver = 1,
		/obj/item/food/meat/rawcutlet = 1,
		/obj/item/food/grown/onion = 1
	)
	result = /obj/item/food/liver_pate
	removed_foodtypes = RAW
	cuisine_category = CUISINE_LIZARD
	dish_category = DISH_MEAT

/datum/crafting_recipe/food/moonfish_caviar
	name = "Moonfish caviar paste-月鱼鱼子酱"
	reqs = list(
		/obj/item/food/moonfish_eggs = 1,
		/datum/reagent/consumable/salt = 2
	)
	result = /obj/item/food/moonfish_caviar
	cuisine_category = CUISINE_LIZARD
	meal_category = MEAL_APPETIZER

/datum/crafting_recipe/food/lizard_escargot
	name = "Desert snail cocleas-椰香沙漠蜗牛"
	reqs = list(
		/obj/item/food/canned/desert_snails = 1,
		/obj/item/food/grown/garlic = 1,
		/datum/reagent/consumable/lemonjuice = 3,
		/datum/reagent/consumable/blackpepper = 2,
		/datum/reagent/consumable/nutriment/fat/oil/olive = 3,
		/obj/item/reagent_containers/cup/bowl = 1,
	)
	result = /obj/item/food/lizard_escargot
	removed_foodtypes = GORE
	cuisine_category = CUISINE_LIZARD
	meal_category = MEAL_APPETIZER

/datum/crafting_recipe/food/fried_blood_sausage
	name = "Fried blood sausage-香煎血肠"
	reqs = list(
		/obj/item/food/raw_tiziran_sausage = 1,
		/datum/reagent/consumable/korta_flour = 5,
		/datum/reagent/water = 5
	)
	result = /obj/item/food/fried_blood_sausage
	added_foodtypes = FRIED|NUTS
	removed_foodtypes = RAW
	cuisine_category = CUISINE_LIZARD
	dish_category = DISH_MEAT

/datum/crafting_recipe/food/lizard_fries
	name = "Loaded poms-franzisks-加好料的肉酱薯条"
	reqs = list(
		/obj/item/food/fries = 1,
		/obj/item/food/meat/cutlet = 2,
		/datum/reagent/consumable/bbqsauce = 5,
		/obj/item/plate = 1,
	)
	result = /obj/item/food/lizard_fries
	cuisine_category = CUISINE_LIZARD
	meal_category = MEAL_APPETIZER

/datum/crafting_recipe/food/brain_pate
	name = "Eyeball-and-brain pate-眼脑肉酱"
	reqs = list(
		/obj/item/organ/brain = 1,
		/obj/item/organ/eyes = 1,
		/obj/item/food/grown/onion = 1,
		/datum/reagent/consumable/salt = 3
	)
	result = /obj/item/food/brain_pate
	added_foodtypes = MEAT|GORE
	cuisine_category = CUISINE_LIZARD
	dish_category = DISH_MEAT

/datum/crafting_recipe/food/crispy_headcheese
	name = "Crispy breaded headcheese-酥脆的头肉冻"
	reqs = list(
		/obj/item/food/headcheese_slice = 1,
		/obj/item/food/breadslice/root = 1
	)
	result = /obj/item/food/crispy_headcheese
	cuisine_category = CUISINE_LIZARD
	meal_category = MEAL_APPETIZER

/datum/crafting_recipe/food/picoss_skewers
	name = "Picoss 烤串"
	reqs = list(
		/obj/item/food/fishmeat/armorfish = 2,
		/obj/item/food/grown/onion = 1,
		/obj/item/food/grown/chili = 1,
		/obj/item/stack/rods = 1,
		/datum/reagent/consumable/vinegar = 5
	)
	result = /obj/item/food/kebab/picoss_skewers
	cuisine_category = CUISINE_LIZARD
	dish_category = DISH_MEAT

/datum/crafting_recipe/food/nectar_larvae
	name = "Nectar larvae-花蜜腌虫"
	reqs = list(
		/obj/item/food/canned/larvae = 1,
		/obj/item/food/grown/tomato = 1,
		/obj/item/food/grown/chili = 1,
		/datum/reagent/consumable/korta_nectar = 5
	)
	result = /obj/item/food/nectar_larvae
	cuisine_category = CUISINE_LIZARD
	meal_category = MEAL_APPETIZER

/datum/crafting_recipe/food/mushroomy_stirfry
	name = "Mushroomy Stirfry-爆炒蘑菇"
	reqs = list(
		/obj/item/food/steeped_mushrooms = 1,
		/obj/item/food/grown/mushroom/plumphelmet = 1,
		/obj/item/food/grown/mushroom/chanterelle = 1,
		/datum/reagent/consumable/nutriment/fat/oil/olive = 5
	)
	result = /obj/item/food/mushroomy_stirfry
	cuisine_category = CUISINE_LIZARD
	dish_category = DISH_SALAD

/datum/crafting_recipe/food/moonfish_demiglace
	name = "Moonfish demiglace-月鱼半冰沙司"
	reqs = list(
		/obj/item/food/grilled_moonfish = 1,
		/obj/item/food/grown/potato = 1,
		/obj/item/food/grown/carrot = 1,
		/datum/reagent/consumable/korta_milk = 5,
		/datum/reagent/consumable/ethanol/wine = 5
	)
	result = /obj/item/food/moonfish_demiglace
	cuisine_category = CUISINE_LIZARD
	dish_category = DISH_MEAT

/datum/crafting_recipe/food/lizard_surf_n_turf
	name = "Zagosk surf n turf smorgasbord-蜥蜴自助盛宴"
	reqs = list(
		/obj/item/food/grilled_moonfish = 1,
		/obj/item/food/kebab/picoss_skewers = 2,
		/obj/item/food/meat/steak = 1,
		/obj/item/food/bbqribs = 1
	)
	removed_foodtypes = SUGAR
	result = /obj/item/food/lizard_surf_n_turf
	cuisine_category = CUISINE_LIZARD
	dish_category = DISH_MEAT

/datum/crafting_recipe/food/rootdough
	name = "根茎面团（无蛋）"
	reqs = list(
		/obj/item/food/grown/potato = 2,
		/datum/reagent/consumable/soymilk = 15,
		/datum/reagent/consumable/korta_flour = 5,
		/datum/reagent/water = 10
	)
	result = /obj/item/food/rootdough
	added_foodtypes = NUTS
	cuisine_category = CUISINE_LIZARD
	dish_category = DISH_BREAD
	crafting_flags = parent_type::crafting_flags & ~CRAFT_TRANSFERS_REAGENT_COMPONENTS // prevents water from reacting immediately, clearing the dish

/datum/crafting_recipe/food/rootdough/with_eggs
	name = "根茎面团（含蛋）"
	reqs = list(
		/obj/item/food/grown/potato = 2,
		/obj/item/food/egg = 1,
		/datum/reagent/consumable/korta_flour = 5,
		/datum/reagent/water = 10
	)
	result = /obj/item/food/rootdough/egg
	removed_foodtypes = RAW|EGG
	/**
	 * So, at some point, we've had some mean issues with crafting with empty containers.
	 * Bugs happen and we fix them all the time, so let's make sure stuff like this won't happen again.
	 * Let's make his recipe spawn a bunch of unneeded containers and something else as well.
	 * If this breaks the CI, then something is wrong with crafting.
	 */
	unit_test_spawn_extras = list(
		/obj/item/food/rootdough/egg = 1,
		/obj/item/food/grown/potato = 1,
		/obj/item/reagent_containers/condiment = 1,
		/obj/item/reagent_containers/cup/bottle = 2,
		/obj/item/reagent_containers/cup/beaker/slime = 1,
		/obj/item/reagent_containers/applicator/patch/synthflesh = 1,
	)
	crafting_flags = parent_type::crafting_flags & ~CRAFT_TRANSFERS_REAGENT_COMPONENTS // prevents water from reacting immediately, clearing the dish

/datum/crafting_recipe/food/snail_nizaya
	name = "Desert snail nizaya-沙漠蜗牛千层面"
	reqs = list(
		/obj/item/food/canned/desert_snails = 1,
		/obj/item/food/spaghetti/nizaya = 1,
		/obj/item/food/grown/garlic = 1,
		/datum/reagent/consumable/ethanol/wine = 5
	)
	result = /obj/item/food/spaghetti/snail_nizaya
	removed_foodtypes = GORE
	cuisine_category = CUISINE_LIZARD
	dish_category = DISH_NOODLES

/datum/crafting_recipe/food/garlic_nizaya
	name = "Garlic nizaya-蒜香千层面"
	reqs = list(
		/obj/item/food/spaghetti/nizaya = 1,
		/obj/item/food/grown/garlic = 1,
		/obj/item/food/grown/chili = 1,
		/datum/reagent/consumable/nutriment/fat/oil/olive = 5
	)
	result = /obj/item/food/spaghetti/garlic_nizaya
	cuisine_category = CUISINE_LIZARD
	dish_category = DISH_NOODLES

/datum/crafting_recipe/food/demit_nizaya
	name = "Demit nizaya-解脱千层面"
	reqs = list(
		/obj/item/food/spaghetti/nizaya = 1,
		/obj/item/food/grown/carrot = 1,
		/obj/item/food/grown/onion = 1,
		/obj/item/food/grown/eggplant = 1,
		/datum/reagent/consumable/korta_milk = 5,
		/datum/reagent/consumable/korta_nectar = 5
	)
	result = /obj/item/food/spaghetti/demit_nizaya
	added_foodtypes = SUGAR
	cuisine_category = CUISINE_LIZARD
	dish_category = DISH_NOODLES

/datum/crafting_recipe/food/mushroom_nizaya
	name = "Mushroom nizaya-蘑菇千层面"
	reqs = list(
		/obj/item/food/spaghetti/nizaya = 1,
		/obj/item/food/steeped_mushrooms = 1,
		/obj/item/food/grown/garlic = 1,
		/datum/reagent/consumable/nutriment/fat/oil/olive = 5
	)
	result = /obj/item/food/spaghetti/mushroom_nizaya
	cuisine_category = CUISINE_LIZARD
	dish_category = DISH_NOODLES

/datum/crafting_recipe/food/rustic_flatbread
	name = "Rustic flatbread-乡村烤饼"
	reqs = list(
		/obj/item/food/root_flatbread = 1,
		/obj/item/food/grown/garlic = 1,
		/datum/reagent/consumable/lemonjuice = 2,
		/datum/reagent/consumable/nutriment/fat/oil/olive = 3
	)
	result = /obj/item/food/pizza/flatbread/rustic
	cuisine_category = CUISINE_LIZARD
	dish_category = DISH_BREAD

/datum/crafting_recipe/food/italic_flatbread
	name = "Italic flatbread-意大利烤饼"
	reqs = list(
		/obj/item/food/root_flatbread = 1,
		/obj/item/food/grown/garlic = 1,
		/obj/item/food/grown/tomato = 1,
		/obj/item/food/meatball = 2,
		/datum/reagent/consumable/nutriment/fat/oil/olive = 3
	)
	result = /obj/item/food/pizza/flatbread/italic
	cuisine_category = CUISINE_LIZARD
	dish_category = DISH_BREAD

/datum/crafting_recipe/food/imperial_flatbread
	name = "Imperial flatbread-帝国烤饼"
	reqs = list(
		/obj/item/food/root_flatbread = 1,
		/obj/item/food/liver_pate = 1,
		/obj/item/food/sauerkraut = 1,
		/obj/item/food/headcheese = 1
	)
	result = /obj/item/food/pizza/flatbread/imperial
	cuisine_category = CUISINE_LIZARD
	dish_category = DISH_BREAD

/datum/crafting_recipe/food/rawmeat_flatbread
	name = "肉食爱好者扁面包"
	reqs = list(
		/obj/item/food/root_flatbread = 1,
		/obj/item/food/meat/slab = 1
	)
	result = /obj/item/food/pizza/flatbread/rawmeat
	cuisine_category = CUISINE_LIZARD
	dish_category = DISH_BREAD

/datum/crafting_recipe/food/stinging_flatbread
	name = "刺舌扁面包"
	reqs = list(
		/obj/item/food/root_flatbread = 1,
		/obj/item/food/canned/larvae = 1,
		/obj/item/food/canned/jellyfish = 1
	)
	result = /obj/item/food/pizza/flatbread/stinging
	cuisine_category = CUISINE_LIZARD
	dish_category = DISH_BREAD

/datum/crafting_recipe/food/zmorgast_flatbread
	name = "Zmorgast 扁面包"
	reqs = list(
		/obj/item/food/root_flatbread = 1,
		/obj/item/food/grown/cucumber = 2,
		/obj/item/food/egg = 1,
		/obj/item/organ/liver = 1
	)
	result = /obj/item/food/pizza/flatbread/zmorgast
	removed_foodtypes = RAW
	cuisine_category = CUISINE_LIZARD
	dish_category = DISH_BREAD

/datum/crafting_recipe/food/fish_flatbread
	name = "烧烤鱼扁面包"
	reqs = list(
		/obj/item/food/root_flatbread = 1,
		/obj/item/food/fishmeat = 2,
		/datum/reagent/consumable/bbqsauce = 5
	)
	result = /obj/item/food/pizza/flatbread/fish
	cuisine_category = CUISINE_LIZARD
	dish_category = DISH_BREAD

/datum/crafting_recipe/food/mushroom_flatbread
	name = "蘑菇番茄扁面包"
	reqs = list(
		/obj/item/food/root_flatbread = 1,
		/obj/item/food/grown/tomato = 1,
		/obj/item/food/grown/mushroom = 3,
		/datum/reagent/consumable/nutriment/fat/oil/olive = 3
	)
	result = /obj/item/food/pizza/flatbread/mushroom
	cuisine_category = CUISINE_LIZARD
	dish_category = DISH_BREAD

/datum/crafting_recipe/food/nutty_flatbread
	name = "坚果酱扁面包"
	reqs = list(
		/obj/item/food/root_flatbread = 1,
		/datum/reagent/consumable/korta_flour = 5,
		/datum/reagent/consumable/korta_milk = 5
	)
	result = /obj/item/food/pizza/flatbread/nutty
	removed_foodtypes = VEGETABLES //This is so nuts
	cuisine_category = CUISINE_LIZARD
	dish_category = DISH_BREAD

/datum/crafting_recipe/food/emperor_roll
	name = "Emperor roll-君主卷饼"
	reqs = list(
		/obj/item/food/rootroll = 1,
		/obj/item/food/liver_pate = 1,
		/obj/item/food/headcheese_slice = 2,
		/obj/item/food/moonfish_caviar = 1
	)
	result = /obj/item/food/emperor_roll
	cuisine_category = CUISINE_LIZARD
	dish_category = DISH_PASTRY

/datum/crafting_recipe/food/honey_sweetroll
	name = "Honey sweetroll-蜜香甜卷"
	reqs = list(
		/obj/item/food/rootroll = 1,
		/obj/item/food/grown/berries = 1,
		/obj/item/food/grown/banana = 1,
		/datum/reagent/consumable/honey = 5
	)
	result = /obj/item/food/honey_roll
	cuisine_category = CUISINE_LIZARD
	dish_category = DISH_PASTRY

/datum/crafting_recipe/food/black_eggs
	name = "Black scrambled eggs-黑色的炒鸡蛋"
	reqs = list(
		/obj/item/food/egg = 2,
		/datum/reagent/blood = 5,
		/datum/reagent/consumable/vinegar = 2
	)
	result = /obj/item/food/black_eggs
	added_foodtypes = GORE|BREAKFAST
	removed_foodtypes = RAW
	cuisine_category = CUISINE_LIZARD
	meal_category = MEAL_APPETIZER

/datum/crafting_recipe/food/patzikula
	name = "Patzikula"
	reqs = list(
		/obj/item/food/grown/tomato = 2,
		/obj/item/food/grown/onion = 1,
		/obj/item/food/grown/chili = 1,
		/obj/item/food/egg = 2
	)
	result = /obj/item/food/patzikula
	removed_foodtypes = RAW
	added_foodtypes = BREAKFAST
	cuisine_category = CUISINE_LIZARD
	meal_category = MEAL_APPETIZER

/datum/crafting_recipe/food/korta_brittle
	name = "Korta brittle slab-科尔塔脆糖"
	reqs = list(
		/obj/item/food/grown/korta_nut = 2,
		/datum/reagent/consumable/korta_nectar = 5,
		/datum/reagent/consumable/sugar = 5,
		/datum/reagent/consumable/nutriment/fat/oil = 3,
		/datum/reagent/consumable/salt = 2
	)
	result = /obj/item/food/cake/korta_brittle
	added_foodtypes = SUGAR
	cuisine_category = CUISINE_LIZARD
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/korta_ice
	name = "Korta ice-科尔塔冰激凌"
	reqs = list(
		/obj/item/reagent_containers/cup/glass/sillycup = 1,
		/datum/reagent/consumable/ice = 15,
		/datum/reagent/consumable/korta_nectar = 5,
		/obj/item/food/grown/berries = 1
	)
	result = /obj/item/food/snowcones/korta_ice
	added_foodtypes = SUGAR|NUTS
	cuisine_category = CUISINE_LIZARD
	dish_category = DISH_FROZEN

/datum/crafting_recipe/food/candied_mushrooms
	name = "Candied mushrooms-蘑菇蜜饯"
	reqs = list(
		/obj/item/stack/rods = 1,
		/obj/item/food/steeped_mushrooms = 1,
		/datum/reagent/consumable/caramel = 5,
		/datum/reagent/consumable/salt = 1
	)
	result = /obj/item/food/kebab/candied_mushrooms
	added_foodtypes = SUGAR
	cuisine_category = CUISINE_LIZARD
	dish_category = DISH_CANDY
	meal_category = MEAL_DESSERT

/datum/crafting_recipe/food/sauerkraut
	name = "酸菜"
	reqs = list(
		/obj/item/food/grown/cabbage = 2,
		/datum/reagent/consumable/salt = 10
	)
	result = /obj/item/food/sauerkraut
	cuisine_category = CUISINE_LIZARD
	dish_category = DISH_CONDIMENT
	meal_category = MEAL_COMPONENT

/datum/crafting_recipe/food/lizard_dumplings
	name = "Tiziran dumplings-泰泽拉饺子"
	reqs = list(
		/obj/item/food/grown/potato = 1,
		/datum/reagent/consumable/korta_flour = 5
	)
	result = /obj/item/food/lizard_dumplings
	added_foodtypes = NUTS
	cuisine_category = CUISINE_LIZARD
	meal_category = MEAL_COMPONENT

/datum/crafting_recipe/food/steeped_mushrooms
	name = "Steeped mushrooms-浸渍蘑菇"
	reqs = list(
		/obj/item/food/grown/ash_flora/seraka = 1,
		/datum/reagent/lye = 5
	)
	result = /obj/item/food/steeped_mushrooms
	cuisine_category = CUISINE_LIZARD
	meal_category = MEAL_COMPONENT

/datum/crafting_recipe/food/rootbreadpbj
	name = "花生酱果酱根茎三明治"
	reqs = list(
		/obj/item/food/breadslice/root = 2,
		/datum/reagent/consumable/peanut_butter = 5,
		/datum/reagent/consumable/cherryjelly = 5
	)
	result = /obj/item/food/rootbread_peanut_butter_jelly
	added_foodtypes = FRUIT
	cuisine_category = CUISINE_LIZARD
	dish_category = DISH_SANDWICH

/datum/crafting_recipe/food/rootbreadpbb
	name = "花生酱香蕉根茎三明治"
	reqs = list(
		/obj/item/food/breadslice/root = 2,
		/datum/reagent/consumable/peanut_butter = 5,
		/obj/item/food/grown/banana = 1
	)
	result = /obj/item/food/rootbread_peanut_butter_banana
	added_foodtypes = FRUIT
	cuisine_category = CUISINE_LIZARD
	dish_category = DISH_SANDWICH
// Soups

/datum/crafting_recipe/food/reaction/soup/atrakor_dumplings
	reaction = /datum/chemical_reaction/food/soup/atrakor_dumplings
	cuisine_category = CUISINE_LIZARD

/datum/crafting_recipe/food/reaction/soup/meatball_noodles
	reaction = /datum/chemical_reaction/food/soup/meatball_noodles
	cuisine_category = CUISINE_LIZARD

/datum/crafting_recipe/food/reaction/soup/black_broth
	reaction = /datum/chemical_reaction/food/soup/black_broth
	cuisine_category = CUISINE_LIZARD

/datum/crafting_recipe/food/reaction/soup/jellyfish_stew
	reaction = /datum/chemical_reaction/food/soup/jellyfish_stew
	cuisine_category = CUISINE_LIZARD

/datum/crafting_recipe/food/reaction/soup/jellyfish_stew_two
	reaction = /datum/chemical_reaction/food/soup/jellyfish_stew_two
	cuisine_category = CUISINE_LIZARD

/datum/crafting_recipe/food/reaction/soup/rootbread_soup
	reaction = /datum/chemical_reaction/food/soup/rootbread_soup
	cuisine_category = CUISINE_LIZARD
