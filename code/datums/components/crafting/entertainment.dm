/datum/crafting_recipe/moffers
	name = "莫弗斯"
	result = /obj/item/clothing/shoes/clown_shoes/moffers
	time = 6 SECONDS //opportunity to rethink your life
	reqs = list(
		/obj/item/stack/sheet/animalhide/mothroach = 2,
		/obj/item/clothing/shoes/clown_shoes = 1,
	)
	blacklist = list(
		/obj/item/clothing/shoes/clown_shoes/combat,
		/obj/item/clothing/shoes/clown_shoes/banana_shoes,
		/obj/item/clothing/shoes/clown_shoes/banana_shoes/combat,
		/obj/item/clothing/shoes/clown_shoes/jester,
		/obj/item/clothing/shoes/clown_shoes/meown_shoes,
		/obj/item/clothing/shoes/clown_shoes/moffers,
	)
	category = CAT_ENTERTAINMENT

/datum/crafting_recipe/mothplush
	name = "蛾子玩偶"
	result = /obj/item/toy/plush/moth
	reqs = list(
		/obj/item/stack/sheet/animalhide/mothroach = 1,
		/obj/item/organ/heart = 1,
		/obj/item/stack/sheet/cloth = 3,
	)
	category = CAT_ENTERTAINMENT

/datum/crafting_recipe/sharkplush
	name = "鲨鱼玩偶"
	result = /obj/item/toy/plush/shark
	reqs = list(
		/obj/item/clothing/suit/hooded/shark_costume = 1,
		/obj/item/grown/cotton = 10,
		/obj/item/stack/sheet/cloth = 5,
	)
	category = CAT_ENTERTAINMENT

/datum/crafting_recipe/monkeyplush
	name = "猴子玩偶"
	result = /obj/item/toy/plush/monkey
	reqs = list(
		/obj/item/clothing/mask/gas/monkeymask = 1,
		/obj/item/clothing/suit/costume/monkeysuit = 1,
		/obj/item/grown/cotton = 10,
	)
	category = CAT_ENTERTAINMENT

/datum/crafting_recipe/mixedbouquet
	name = "混合花束"
	result = /obj/item/bouquet
	reqs = list(
		/obj/item/food/grown/poppy/lily = 2,
		/obj/item/food/grown/sunflower = 2,
		/obj/item/food/grown/poppy/geranium = 2,
	)
	category = CAT_ENTERTAINMENT

/datum/crafting_recipe/sunbouquet
	name = "向日葵花束"
	result = /obj/item/bouquet/sunflower
	reqs = list(/obj/item/food/grown/sunflower = 6)
	category = CAT_ENTERTAINMENT

/datum/crafting_recipe/poppybouquet
	name = "罂粟花花束"
	result = /obj/item/bouquet/poppy
	reqs = list (/obj/item/food/grown/poppy = 6)
	category = CAT_ENTERTAINMENT

/datum/crafting_recipe/rosebouquet
	name = "玫瑰花束"
	result = /obj/item/bouquet/rose
	reqs = list(/obj/item/food/grown/rose = 6)
	category = CAT_ENTERTAINMENT

/datum/crafting_recipe/spooky_camera
	name = "暗箱相机"
	result = /obj/item/camera/spooky
	time = 1.5 SECONDS
	reqs = list(
		/obj/item/camera = 1,
		/datum/reagent/water/holywater = 10,
	)
	category = CAT_ENTERTAINMENT


/datum/crafting_recipe/skateboard
	name = "滑板"
	result = /obj/vehicle/ridden/scooter/skateboard/improvised
	time = 6 SECONDS
	reqs = list(
		/obj/item/stack/sheet/iron = 5,
		/obj/item/stack/rods = 10,
	)
	category = CAT_ENTERTAINMENT

/datum/crafting_recipe/scooter
	name = "滑板车"
	result = /obj/vehicle/ridden/scooter
	time = 6.5 SECONDS
	reqs = list(
		/obj/item/stack/sheet/iron = 5,
		/obj/item/stack/rods = 12,
	)
	category = CAT_ENTERTAINMENT

/datum/crafting_recipe/headpike
	name = "穿刺首级（玻璃矛）"
	time = 6.5 SECONDS
	reqs = list(
		/obj/item/spear = 1,
		/obj/item/bodypart/head = 1,
	)
	parts = list(
		/obj/item/bodypart/head = 1,
		/obj/item/spear = 1,
	)
	blacklist = list(
		/obj/item/spear/explosive,
		/obj/item/spear/bonespear,
		/obj/item/spear/bamboospear,
		/obj/item/spear/military,
	)
	result = /obj/structure/headpike
	category = CAT_ENTERTAINMENT

/datum/crafting_recipe/headpikebone
	name = "穿刺首级（骨矛）"
	time = 6.5 SECONDS
	reqs = list(
		/obj/item/spear/bonespear = 1,
		/obj/item/bodypart/head = 1,
	)
	parts = list(
		/obj/item/bodypart/head = 1,
		/obj/item/spear/bonespear = 1,
	)
	result = /obj/structure/headpike/bone
	category = CAT_ENTERTAINMENT

/datum/crafting_recipe/headpikebamboo
	name = "穿刺首级（竹矛）"
	time = 6.5 SECONDS
	reqs = list(
		/obj/item/spear/bamboospear = 1,
		/obj/item/bodypart/head = 1,
	)
	parts = list(
		/obj/item/bodypart/head = 1,
		/obj/item/spear/bamboospear = 1,
	)
	result = /obj/structure/headpike/bamboo
	category = CAT_ENTERTAINMENT

/datum/crafting_recipe/headpikemilitary
	name = "穿刺首级（军用）"
	time = 6.5 SECONDS
	reqs = list(
		/obj/item/spear/military = 1,
		/obj/item/bodypart/head = 1,
	)
	parts = list(
		/obj/item/bodypart/head = 1,
		/obj/item/spear/military = 1,
	)
	result = /obj/structure/headpike/military
	category = CAT_ENTERTAINMENT

/datum/crafting_recipe/guillotine
	name = "断头台"
	result = /obj/structure/guillotine
	time = 15 SECONDS // Building a functioning guillotine takes time
	reqs = list(
		/obj/item/stack/sheet/plasteel = 3,
		/obj/item/stack/sheet/mineral/wood = 20,
		/obj/item/stack/cable_coil = 10,
	)
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WRENCH, TOOL_WELDER)
	category = CAT_ENTERTAINMENT

/datum/crafting_recipe/toiletbong
	name = "马桶烟枪"
	category = CAT_ENTERTAINMENT
	tool_behaviors = list(TOOL_WRENCH)
	reqs = list(/obj/item/flamethrower = 1)
	structures = list(/obj/structure/toilet = CRAFTING_STRUCTURE_CONSUME)
	result = /obj/structure/toiletbong
	time = 5 SECONDS
	steps = list(
		"make sure the flamethrower has a plasma tank attached",
	)

/datum/crafting_recipe/toiletbong/check_requirements(mob/user, list/collected_requirements)
	var/obj/item/flamethrower/flamethrower = collected_requirements[/obj/item/flamethrower][1]
	if(!flamethrower.ptank)
		return FALSE
	return ..()

/datum/crafting_recipe/punching_bag
	name = "沙袋"
	result = /obj/structure/punching_bag
	tool_behaviors = list(TOOL_SCREWDRIVER)
	reqs = list(
		/obj/item/stack/sheet/iron = 2,
		/obj/item/stack/rods = 1,
		/obj/item/pillow = 1,
	)
	category = CAT_ENTERTAINMENT
	time = 10 SECONDS

/datum/crafting_recipe/stacklifter
	name = "卧推器"
	result = /obj/structure/weightmachine
	tool_behaviors = list(TOOL_SCREWDRIVER)
	reqs = list(
		/obj/item/stack/sheet/iron = 5,
		/obj/item/stack/rods = 2,
		/obj/item/chair = 1,
	)
	category = CAT_ENTERTAINMENT
	time = 10 SECONDS

/datum/crafting_recipe/weightlifter
	name = "杠铃卧推器"
	result = /obj/structure/weightmachine/weightlifter
	tool_behaviors = list(TOOL_SCREWDRIVER)
	reqs = list(
		/obj/item/stack/sheet/iron = 5,
		/obj/item/stack/rods = 2,
		/obj/item/chair = 1,
	)
	category = CAT_ENTERTAINMENT
	time = 10 SECONDS

/datum/crafting_recipe/latexballoon
	name = "乳胶气球"
	result = /obj/item/latexballoon
	time = 5 SECONDS
	reqs = list(
		/obj/item/clothing/gloves/latex = 1,
		/obj/item/stack/cable_coil = 2,
	)
	category = CAT_ENTERTAINMENT

/datum/crafting_recipe/violin
	name = "小提琴"
	result = /obj/item/instrument/violin
	reqs = list(
		/obj/item/stack/sheet/mineral/wood = 4,
		/obj/item/stack/sheet/cloth = 2,
		/obj/item/stack/sheet/iron = 1,
	)
	tool_paths = list(
		/obj/item/hatchet,
	)
	time = 30 SECONDS
	category = CAT_ENTERTAINMENT
	crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_MUST_BE_LEARNED

/datum/crafting_recipe/crackpipe
	name = "玻璃烟斗"
	result = /obj/item/cigarette/pipe/crackpipe
	time = 5 SECONDS
	reqs = list(
		/obj/item/stack/sheet/glass = 3,
	)
	tool_paths = list(
		/obj/item/screwdriver,
	)
	category = CAT_ENTERTAINMENT
