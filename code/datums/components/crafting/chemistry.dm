/datum/crafting_recipe/improv_explosive
	name = "简易爆炸装置"
	result = /obj/item/grenade/iedcasing/spawned
	tool_behaviors = list(TOOL_WELDER, TOOL_SCREWDRIVER)
	reqs = list(
		/datum/reagent/fuel = 20,
		/obj/item/stack/cable_coil = 15,
		/obj/item/assembly/timer = 1,
		/obj/item/pipe = 1,
	)
	time = 6 SECONDS
	category = CAT_CHEMISTRY

/datum/crafting_recipe/molotov
	name = "莫洛托夫鸡尾酒"
	result = /obj/item/reagent_containers/cup/glass/bottle/molotov
	reqs = list(
		/obj/item/rag = 1,
		/obj/item/reagent_containers/cup/glass/bottle = 1,
	)
	time = 4 SECONDS
	category = CAT_CHEMISTRY

/datum/crafting_recipe/chemical_payload
	name = "化学载荷（C4）"
	result = /obj/item/bombcore/chemical
	reqs = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/grenade/c4 = 1,
		/obj/item/grenade/chem_grenade = 2
	)
	time = 3 SECONDS
	category = CAT_CHEMISTRY

/datum/crafting_recipe/chemical_payload2
	name = "化学载荷（吉布顿岩）"
	result = /obj/item/bombcore/chemical
	reqs = list(
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/gibtonite = 1,
		/obj/item/grenade/chem_grenade = 2,
	)
	time = 5 SECONDS
	category = CAT_CHEMISTRY
	crafting_flags = parent_type::crafting_flags | CRAFT_SKIP_MATERIALS_PARITY //there are two ways to make a chem bombcore. We go with the first one for mats check

/datum/crafting_recipe/alcohol_burner
	name = "燃烧器（乙醇）"
	result = /obj/item/burner
	time = 5 SECONDS
	reqs = list(
		/obj/item/reagent_containers/cup = 1,
		/datum/reagent/consumable/ethanol = 15,
		/obj/item/paper = 1,
	)
	category = CAT_CHEMISTRY

/datum/crafting_recipe/oil_burner
	name = "燃烧器（油）"
	result = /obj/item/burner/oil
	time = 5 SECONDS
	reqs = list(
		/obj/item/reagent_containers/cup = 1,
		/datum/reagent/fuel/oil = 15,
		/obj/item/paper = 1,
	)
	category = CAT_CHEMISTRY

/datum/crafting_recipe/fuel_burner
	name = "燃烧器（燃料）"
	result = /obj/item/burner/fuel
	time = 5 SECONDS
	reqs = list(
		/obj/item/reagent_containers/cup = 1,
		/datum/reagent/fuel = 15,
		/obj/item/paper = 1,
	)
	category = CAT_CHEMISTRY

/datum/crafting_recipe/thermometer
	name = "温度计"
	tool_behaviors = list(TOOL_WELDER)
	result = /obj/item/thermometer
	time = 5 SECONDS
	reqs = list(
		/datum/reagent/mercury = 5,
		/obj/item/stack/sheet/glass = 1,
	)
	category = CAT_CHEMISTRY

/datum/crafting_recipe/thermometer_alt
	name = "温度计"
	result = /obj/item/thermometer/pen
	time = 5 SECONDS
	reqs = list(
		/datum/reagent/mercury = 5,
		/obj/item/pen = 1,
	)
	category = CAT_CHEMISTRY

/datum/crafting_recipe/ph_booklet
	name = "pH试纸册"
	result = /obj/item/ph_booklet
	time = 5 SECONDS
	reqs = list(
		/datum/reagent/universal_indicator = 5,
		/obj/item/paper = 1,
	)
	category = CAT_CHEMISTRY

/datum/crafting_recipe/dropper //Maybe make a glass pipette icon?
	name = "滴管"
	result = /obj/item/reagent_containers/dropper
	tool_behaviors = list(TOOL_WELDER)
	time = 5 SECONDS
	reqs = list(
		/obj/item/stack/sheet/glass = 1,
	)
	category = CAT_CHEMISTRY


/datum/crafting_recipe/chem_separator
	name = "化学分离器"
	result = /obj/structure/chem_separator
	tool_behaviors = list(TOOL_WELDER)
	time = 5 SECONDS
	reqs = list(
		/obj/item/stack/sheet/mineral/wood = 1,
		/obj/item/stack/sheet/glass = 1,
		/obj/item/burner = 1,
		/obj/item/thermometer = 1,
	)
	category = CAT_CHEMISTRY

/datum/crafting_recipe/improvised_chem_heater
	name = "简易化学加热器"
	result = /obj/machinery/space_heater/improvised_chem_heater
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_MULTITOOL, TOOL_WIRECUTTER)
	time = 15 SECONDS
	reqs = list(
		/obj/item/stack/cable_coil = 2,
		/obj/item/stack/sheet/glass = 2,
		/obj/item/stack/sheet/iron = 2,
		/datum/reagent/water = 50,
		/obj/item/thermometer = 1,
	)
	machinery = list(/obj/machinery/space_heater = CRAFTING_MACHINERY_CONSUME)
	category = CAT_CHEMISTRY

/datum/crafting_recipe/improvised_coolant
	name = "简易冷却喷雾"
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	result = /obj/item/extinguisher/crafted
	time = 10 SECONDS
	reqs = list(
		/obj/item/toy/crayon/spraycan = 1,
		/datum/reagent/water = 20,
		/datum/reagent/consumable/ice = 10,
	)
	category = CAT_CHEMISTRY
