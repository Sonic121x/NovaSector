/datum/crafting_recipe/meteorslug
	name = "陨石弹壳"
	result = /obj/item/ammo_casing/shotgun/meteorslug
	reqs = list(
		/obj/item/ammo_casing/shotgun/techshell = 1,
		/obj/item/rcd_ammo = 1,
		/datum/reagent/gunpowder = 10,
		/datum/reagent/consumable/ethanol/rum = 10,
		/obj/item/stock_parts/servo = 2,
	)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 0.5 SECONDS
	category = CAT_WEAPON_AMMO

/datum/crafting_recipe/paperball
	name = "纸团"
	result = /obj/item/ammo_casing/rebar/paperball
	reqs = list(
		/obj/item/paper = 1,
	)
	time = 0.1 SECONDS
	category = CAT_WEAPON_AMMO

/datum/crafting_recipe/rebarsyndie
	name = "锯齿铁棍"
	result = /obj/item/ammo_casing/rebar/syndie
	reqs = list(
		/obj/item/stack/rods = 1,
	)
	tool_behaviors = list(TOOL_WIRECUTTER)
	time = 0.1 SECONDS
	category = CAT_WEAPON_AMMO
	crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_MUST_BE_LEARNED

/datum/crafting_recipe/healium_bolt
	name = "愈疗水晶弩箭"
	result = /obj/item/ammo_casing/rebar/healium
	reqs = list(
		/obj/item/grenade/gas_crystal/healium_crystal = 1
	)
	time = 0.1 SECONDS
	category = CAT_WEAPON_AMMO
	crafting_flags = CRAFT_CHECK_DENSITY

/datum/crafting_recipe/pulseslug
	name = "脉冲弹壳"
	result = /obj/item/ammo_casing/shotgun/pulseslug
	reqs = list(
		/obj/item/ammo_casing/shotgun/techshell = 1,
		/obj/item/stock_parts/capacitor/adv = 2,
		/obj/item/stock_parts/micro_laser/ultra = 1,
	)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 0.5 SECONDS
	category = CAT_WEAPON_AMMO

/datum/crafting_recipe/dragonsbreath
	name = "龙息弹壳"
	result = /obj/item/ammo_casing/shotgun/dragonsbreath
	reqs = list(
		/obj/item/ammo_casing/shotgun/techshell = 1,
		/datum/reagent/phosphorus = 5,
	)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 0.5 SECONDS
	category = CAT_WEAPON_AMMO

/datum/crafting_recipe/frag12
	name = "FRAG-12破片弹壳"
	result = /obj/item/ammo_casing/shotgun/frag12
	reqs = list(
		/obj/item/ammo_casing/shotgun/techshell = 1,
		/datum/reagent/glycerol = 5,
		/datum/reagent/toxin/acid/fluacid = 10,
	)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 0.5 SECONDS
	category = CAT_WEAPON_AMMO

/datum/crafting_recipe/ionslug
	name = "离子散射弹壳"
	result = /obj/item/ammo_casing/shotgun/ion
	reqs = list(
		/obj/item/ammo_casing/shotgun/techshell = 1,
		/obj/item/stock_parts/micro_laser/ultra = 1,
		/obj/item/stock_parts/subspace/crystal = 1,
	)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 0.5 SECONDS
	category = CAT_WEAPON_AMMO

/datum/crafting_recipe/improvisedslug
	name = "垃圾弹壳"
	result = /obj/effect/spawner/random/junk_shell
	reqs = list(
		/obj/item/stack/sheet/iron = 2,
		/obj/item/stack/cable_coil = 1,
		/obj/item/shard = 1,
		/datum/reagent/fuel = 10,
	)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 1.2 SECONDS
	category = CAT_WEAPON_AMMO
	crafting_flags = CRAFT_SKIP_MATERIALS_PARITY

/datum/crafting_recipe/trashball
	name = "垃圾球"
	result = /obj/item/stack/cannonball/trashball
	reqs = list(
		/obj/item/stack/sheet = 5,
		/datum/reagent/consumable/space_cola = 10,
	)
	category = CAT_WEAPON_AMMO
	crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_MUST_BE_LEARNED

/datum/crafting_recipe/arrow
	name = "箭矢"
	result = /obj/item/ammo_casing/arrow
	reqs = list(
		/obj/item/stack/sheet/mineral/wood = 1,
		/obj/item/stack/sheet/cloth = 1,
		/obj/item/stack/sheet/iron = 1,
	)
	tool_paths = list(
		/obj/item/hatchet,
	)
	time = 5 SECONDS
	category = CAT_WEAPON_AMMO
	crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_MUST_BE_LEARNED

/datum/crafting_recipe/sticky_arrow
	name = "粘性箭矢"
	result = /obj/item/ammo_casing/arrow/sticky
	reqs = list(
		/obj/item/ammo_casing/arrow = 1,
		/obj/item/food/honeycomb = 3,
	)
	time = 5 SECONDS
	category = CAT_WEAPON_AMMO
	crafting_flags = CRAFT_CHECK_DENSITY

/datum/crafting_recipe/poison_arrow
	name = "毒箭"
	result = /obj/item/ammo_casing/arrow/poison
	reqs = list(
		/obj/item/ammo_casing/arrow = 1,
		/obj/item/food/grown/berries/poison = 5,
	)
	time = 5 SECONDS
	category = CAT_WEAPON_AMMO
	crafting_flags = CRAFT_CHECK_DENSITY

/datum/crafting_recipe/plastic_arrow
	name = "塑料箭矢"
	result = /obj/item/ammo_casing/arrow/plastic
	reqs = list(
		/obj/item/stack/sheet/plastic = 1,
	)
	tool_paths = list(
		/obj/item/hatchet,
	)
	time = 5 SECONDS
	category = CAT_WEAPON_AMMO
	crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_MUST_BE_LEARNED


/datum/crafting_recipe/holy_arrow
	name = "神圣箭矢"
	result = /obj/item/ammo_casing/arrow/holy
	reqs = list(
		/obj/item/ammo_casing/arrow = 1,
		/datum/reagent/water/holywater = 10,
	)
	tool_paths = list(
		/obj/item/gun/ballistic/bow/divine,
	)
	time = 5 SECONDS
	category = CAT_WEAPON_AMMO
	crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_MUST_BE_LEARNED

/datum/crafting_recipe/ashen_arrow
	name = "灰烬箭矢"
	result = /obj/item/ammo_casing/arrow/ashen
	reqs = list(
		/obj/item/stack/sheet/bone = 1,
		/obj/item/stack/sheet/sinew = 1,
	)
	time = 5 SECONDS
	category = CAT_WEAPON_AMMO
