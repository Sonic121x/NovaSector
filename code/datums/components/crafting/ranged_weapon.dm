/datum/crafting_recipe/bola
	name = "流星锤"
	result = /obj/item/restraints/legcuffs/bola
	reqs = list(
		/obj/item/restraints/handcuffs/cable = 1,
		/obj/item/stack/sheet/iron = 6,
	)
	time = 2 SECONDS //faster than crafting them by hand!
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/gonbola
	name = "冈波拉"
	result = /obj/item/restraints/legcuffs/bola/gonbola
	reqs = list(
		/obj/item/restraints/handcuffs/cable = 1,
		/obj/item/stack/sheet/iron = 6,
		/obj/item/stack/sheet/animalhide/gondola = 1,
	)
	time = 4 SECONDS
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/receiver
	name = "模块化步枪机匣"
	tool_behaviors = list(TOOL_WRENCH, TOOL_WELDER)
	result = /obj/item/weaponcrafting/receiver
	reqs = list(
		/obj/item/stack/sheet/iron = 5,
		/obj/item/stack/medical/wrap/sticky_tape = 1,
		/obj/item/screwdriver = 1,
		/obj/item/assembly/mousetrap = 1,
	)
	time = 10 SECONDS
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/riflestock
	name = "木制步枪枪托"
	tool_paths = list(/obj/item/hatchet)
	result = /obj/item/weaponcrafting/stock
	reqs = list(
		/obj/item/stack/sheet/mineral/wood = 8,
		/obj/item/stack/medical/wrap/sticky_tape = 1,
	)
	time = 5 SECONDS
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/gun_maint_kit
	name = "简易枪支维护套件"
	tool_behaviors = list(TOOL_WRENCH, TOOL_WELDER, TOOL_SCREWDRIVER)
	result = /obj/item/gun_maintenance_supplies/makeshift
	reqs = list(
		/obj/item/stack/sheet/iron = 5,
		/obj/item/stack/medical/wrap/sticky_tape = 1,
		/obj/item/pipe = 1,
		/obj/item/stack/sheet/cloth = 2,
	)
	time = 5 SECONDS
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/advancedegun
	name = "高级能量枪"
	result = /obj/item/gun/energy/e_gun/nuclear
	reqs = list(
		/obj/item/gun/energy/e_gun = 1,
		/obj/item/weaponcrafting/gunkit/nuclear = 1,
	)
	time = 10 SECONDS
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/advancedegun/New()
	LAZYADD(blacklist, typecacheof(/obj/item/gun/energy/e_gun, ignore_root_path = TRUE))
	return ..()

/datum/crafting_recipe/tempgun
	name = "温度枪"
	result = /obj/item/gun/energy/temperature
	reqs = list(
		/obj/item/gun/energy/disabler = 1,
		/obj/item/weaponcrafting/gunkit/temperature = 1,
	)
	time = 10 SECONDS
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/tempgun/New()
	LAZYADD(blacklist, typecacheof(/obj/item/gun/energy/e_gun, ignore_root_path = TRUE))
	return ..()

/datum/crafting_recipe/beam_rifle
	name = "视界反存在光束步枪"
	result = /obj/item/gun/energy/event_horizon
	reqs = list(
		/obj/item/assembly/signaler/anomaly/flux = 2,
		/obj/item/assembly/signaler/anomaly/grav = 1,
		/obj/item/assembly/signaler/anomaly/vortex = (MAX_CORES_VORTEX - 1),
		/obj/item/assembly/signaler/anomaly/bluespace = 1,
		/obj/item/weaponcrafting/gunkit/beam_rifle = 1,
	)
	time = 30 SECONDS //Maybe the delay will make you reconsider your choices
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/ebow
	name = "能量弩"
	result = /obj/item/gun/energy/recharge/ebow/large
	reqs = list(
		/obj/item/gun/energy/recharge/kinetic_accelerator = 1,
		/obj/item/weaponcrafting/gunkit/ebow = 1,
		/datum/reagent/uranium/radium = 15,
	)
	time = 10 SECONDS
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/laser
	abstract_type = /datum/crafting_recipe/laser
	/// We will use the same blacklist for every type here to avoid repeating lists
	var/static/list/laser_blacklist

/datum/crafting_recipe/laser/New()
	if(isnull(laser_blacklist))
		laser_blacklist = typecacheof(/obj/item/gun/energy/laser, ignore_root_path = TRUE)
	blacklist = laser_blacklist
	return ..()

/datum/crafting_recipe/laser/xraylaser
	name = "X射线激光枪"
	result = /obj/item/gun/energy/laser/xray
	reqs = list(
		/obj/item/gun/energy/laser = 1,
		/obj/item/weaponcrafting/gunkit/xray = 1,
	)
	time = 10 SECONDS
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/laser/hellgun
	name = "地狱火激光枪"
	result = /obj/item/gun/energy/laser/hellgun
	reqs = list(
		/obj/item/gun/energy/laser = 1,
		/obj/item/weaponcrafting/gunkit/hellgun = 1,
	)
	time = 10 SECONDS
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/laser/ioncarbine
	name = "离子卡宾枪"
	result = /obj/item/gun/energy/ionrifle/carbine
	reqs = list(
		/obj/item/gun/energy/laser = 1,
		/obj/item/weaponcrafting/gunkit/ion = 1,
	)
	time = 10 SECONDS
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/teslacannon
	name = "特斯拉炮"
	result = /obj/item/gun/energy/tesla_cannon
	reqs = list(
		/obj/item/assembly/signaler/anomaly/flux = 1,
		/obj/item/weaponcrafting/gunkit/tesla = 1,
	)
	time = 10 SECONDS
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/improvised_pneumatic_cannon //Pretty easy to obtain but
	name = "气动炮"
	result = /obj/item/pneumatic_cannon/ghetto
	tool_behaviors = list(TOOL_WELDER, TOOL_WRENCH)
	reqs = list(
		/obj/item/stack/sheet/iron = 4,
		/obj/item/stack/package_wrap = 8,
		/obj/item/pipe = 2,
	)
	time = 5 SECONDS
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/flamethrower
	name = "火焰喷射器"
	result = /obj/item/flamethrower
	reqs = list(
		/obj/item/weldingtool = 1,
		/obj/item/assembly/igniter = 1,
		/obj/item/stack/rods = 1,
	)
	parts = list(
		/obj/item/assembly/igniter = 1,
		/obj/item/weldingtool = 1,
	)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 1 SECONDS
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/pipegun
	name = "管式枪"
	result = /obj/item/gun/ballistic/rifle/boltaction/pipegun
	reqs = list(
		/obj/item/weaponcrafting/receiver = 1,
		/obj/item/pipe = 2,
		/obj/item/weaponcrafting/stock = 1,
		/obj/item/storage/toolbox = 1, // for the screws
		/obj/item/stack/medical/wrap/sticky_tape = 1,
	)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 5 SECONDS
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/pipepistol
	name = "管式手枪"
	result = /obj/item/gun/ballistic/rifle/boltaction/pipegun/pistol
	reqs = list(
		/obj/item/weaponcrafting/receiver = 1,
		/obj/item/pipe = 1,
		/obj/item/stock_parts/servo = 2,
		/obj/item/stack/sheet/mineral/wood = 4,
		/obj/item/storage/toolbox = 1, // for the screws
		/obj/item/stack/medical/wrap/sticky_tape = 1,
	)
	tool_paths = list(/obj/item/hatchet)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 5 SECONDS
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/rebarxbow
	name = "加热钢筋弩"
	result = /obj/item/gun/ballistic/rifle/rebarxbow
	reqs = list(
		/obj/item/stack/rods = 6,
		/obj/item/stack/cable_coil = 12,
		/obj/item/inducer =  1,
	)
	blacklist = list(
		/obj/item/inducer/sci,
	)
	tool_behaviors = list(TOOL_WELDER)
	time = 5 SECONDS
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/rebarxbowforced
	name = "强制装填钢筋弩"
	desc = "装填快得多……代价是开火时有几率射中自己。"
	result = /obj/item/gun/ballistic/rifle/rebarxbow/forced
	reqs = list(
		/obj/item/gun/ballistic/rifle/rebarxbow = 1,
	)
	blacklist = list(
		/obj/item/gun/ballistic/rifle/rebarxbow/forced,
		/obj/item/gun/ballistic/rifle/rebarxbow/syndie,
	)
	tool_behaviors = list(TOOL_CROWBAR)
	time = 1 SECONDS
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/pipegun_prime
	name = "皇家管式枪"
	result = /obj/item/gun/ballistic/rifle/boltaction/pipegun/prime
	reqs = list(
		/obj/item/gun/ballistic/rifle/boltaction/pipegun = 1,
		/obj/item/food/deadmouse = 1,
		/datum/reagent/consumable/grey_bull = 20,
		/obj/item/spear = 1,
		/obj/item/storage/toolbox = 1,
		/obj/item/clothing/head/costume/crown = 1, // Any ol' crown will do
	)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	tool_paths = list(/obj/item/clothing/gloves/color/yellow, /obj/item/clothing/mask/gas, /obj/item/melee/baton/security/cattleprod)
	time = 15 SECONDS //contemplate for a bit
	category = CAT_WEAPON_RANGED
	crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_MUST_BE_LEARNED

/datum/crafting_recipe/deagle_prime //When you factor in the makarov (7 tc), the toolbox (1 tc), and the emag (3 tc), this comes to a total of 18 TC or thereabouts. Igorning the 20k pricetag, obviously.
	name = "帝王秃鹫"
	result = /obj/item/gun/ballistic/automatic/pistol/deagle/regal
	reqs = list(
		/obj/item/gun/ballistic/automatic/pistol = 1,
		/obj/item/stack/sheet/mineral/gold = 25,
		/obj/item/stack/sheet/mineral/silver = 25,
		/obj/item/food/donkpocket = 1,
		/obj/item/stack/telecrystal = 4,
		/obj/item/clothing/head/costume/crown/fancy = 1, //the captain's crown
		/obj/item/storage/toolbox/syndicate = 1,
		/obj/item/stack/sheet/iron = 10,
	)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	tool_paths = list(
		/obj/item/clothing/under/syndicate,
		/obj/item/clothing/mask/gas/syndicate,
		/obj/item/card/emag
	)
	time = 30 SECONDS
	category = CAT_WEAPON_RANGED
	crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_MUST_BE_LEARNED

/datum/crafting_recipe/deagle_prime/New()
	LAZYADD(blacklist, typecacheof(/obj/item/gun/ballistic/automatic/pistol, ignore_root_path = TRUE))
	return ..()

/datum/crafting_recipe/deagle_prime_mag
	name = "Regal Condor Magazine (.45 Reaper)"
	result = /obj/item/ammo_box/magazine/r45
	reqs = list(
		/obj/item/stack/sheet/iron = 10,
		/obj/item/stack/sheet/mineral/gold = 10,
		/obj/item/stack/sheet/mineral/silver = 10,
		/obj/item/stack/sheet/mineral/plasma = 10,
		/obj/item/food/donkpocket = 1, //Station mass murder, as sponsored by Donk Co.
	)
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WELDER)
	tool_paths = list(
		/obj/item/clothing/under/syndicate,
		/obj/item/clothing/mask/gas/syndicate,
		/obj/item/card/emag,
		/obj/item/gun/ballistic/automatic/pistol/deagle/regal
	)
	time = 5 SECONDS
	category = CAT_WEAPON_RANGED
	crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_MUST_BE_LEARNED

/datum/crafting_recipe/pipe_organ_gun
	name = "管风琴枪"
	tool_behaviors = list(TOOL_WELDER, TOOL_SCREWDRIVER)
	result = /obj/structure/mounted_gun/organ_gun
	reqs = list(
		/obj/item/pipe = 8,
		/obj/item/stack/sheet/mineral/wood = 15,
		/obj/item/stack/sheet/iron = 10,
		/obj/item/storage/toolbox = 1,
		/obj/item/stack/rods = 10,
		/obj/item/assembly/igniter = 2,
	)
	time = 15 SECONDS
	category = CAT_WEAPON_RANGED
	crafting_flags = CRAFT_CHECK_DENSITY

/datum/crafting_recipe/ratvarian_repeater
	name = "拉特瓦里安固定连发器"
	tool_behaviors = list(TOOL_SCREWDRIVER,TOOL_WRENCH)
	result = /obj/structure/mounted_gun/ratvarian_repeater
	reqs = list(
		/obj/item/stack/cable_coil = 15,
		/obj/item/stock_parts/micro_laser = 2,
		/obj/item/stock_parts/capacitor = 2,
		/obj/item/reagent_containers/cup/glass/drinkingglass = 2,
		/obj/item/stack/sheet/bronze = 5,
		/obj/item/stack/rods = 10,
	)
	time = 15 SECONDS
	category = CAT_WEAPON_RANGED
	crafting_flags = CRAFT_CHECK_DENSITY

/datum/crafting_recipe/detached_ratvarian_repeater
	name = "圣像破坏者连发器"
	tool_behaviors = list(TOOL_WELDER)
	result = /obj/item/gun/energy/laser/musket/repeater
	structures = list(
		/obj/structure/mounted_gun/ratvarian_repeater = CRAFTING_STRUCTURE_CONSUME,
	)
	time = 10 SECONDS
	category = CAT_WEAPON_RANGED
	crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_MUST_BE_LEARNED


/datum/crafting_recipe/large_ballista
	name = "简易弩炮"
	tool_behaviors = list(TOOL_WELDER,TOOL_SCREWDRIVER,TOOL_WRENCH,TOOL_WIRECUTTER)
	result = /obj/structure/mounted_gun/ballista
	reqs = list(
		/obj/item/stack/cable_coil = 15,
		/obj/item/stack/sheet/iron = 10,
		/obj/item/stack/rods = 10,
	)
	time = 8 SECONDS
	category = CAT_WEAPON_RANGED
	crafting_flags = CRAFT_CHECK_DENSITY

/datum/crafting_recipe/trash_cannon
	name = "垃圾炮"
	tool_behaviors = list(TOOL_WELDER, TOOL_SCREWDRIVER)
	result = /obj/structure/cannon/trash
	reqs = list(
		/obj/item/melee/skateboard/improvised = 1,
		/obj/item/tank/internals/oxygen = 1,
		/datum/reagent/drug/maint/tar = 15,
		/obj/item/restraints/handcuffs/cable = 1,
		/obj/item/storage/toolbox = 1,
	)
	category = CAT_WEAPON_RANGED
	crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_MUST_BE_LEARNED

/datum/crafting_recipe/laser_musket
	name = "激光步枪"
	result = /obj/item/gun/energy/laser/musket
	reqs = list(
		/obj/item/weaponcrafting/stock = 1,
		/obj/item/stack/cable_coil = 15,
		/obj/item/stack/rods = 4,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/reagent_containers/cup/glass/drinkingglass = 2,
	)
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	time = 10 SECONDS
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/laser_musket_prime
	name = "英雄激光步枪"
	result = /obj/item/gun/energy/laser/musket/prime
	reqs = list(
		/obj/item/gun/energy/laser/musket = 1,
		/obj/item/stack/cable_coil = 15,
		/obj/item/stack/sheet/mineral/silver = 5,
		/obj/item/stock_parts/water_recycler = 1,
		/datum/reagent/consumable/nuka_cola = 15,
	)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	tool_paths = list(/obj/item/clothing/head/cowboy, /obj/item/clothing/shoes/cowboy)
	time = 30 SECONDS //contemplate for a bit
	category = CAT_WEAPON_RANGED
	crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_MUST_BE_LEARNED

/datum/crafting_recipe/smoothbore_disabler
	name = "滑膛眩晕枪"
	result = /obj/item/gun/energy/disabler/smoothbore
	reqs = list(
		/obj/item/weaponcrafting/stock = 1, //it becomes the grip
		/obj/item/stack/cable_coil = 5,
		/obj/item/pipe = 1,
		/obj/item/stock_parts/micro_laser = 1,
		/obj/item/stock_parts/power_store/cell = 1,
		/obj/item/assembly/mousetrap = 1,
	)
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WRENCH)
	time = 10 SECONDS
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/smoothbore_disabler_prime
	name = "精英滑膛眩晕枪"
	result = /obj/item/gun/energy/disabler/smoothbore/prime
	reqs = list(
		/obj/item/gun/energy/disabler/smoothbore = 1,
		/obj/item/stack/sheet/mineral/gold = 5,
		/obj/item/stock_parts/power_store/cell/hyper = 1,
		/datum/reagent/reaction_agent/speed_agent = 10,
	)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 20 SECONDS
	category = CAT_WEAPON_RANGED
	crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_MUST_BE_LEARNED

/datum/crafting_recipe/shortbow
	name = "短弓"
	result = /obj/item/gun/ballistic/bow/shortbow
	reqs = list(
		/obj/item/stack/sheet/mineral/wood = 4,
		/obj/item/stack/sheet/cloth = 2,
		/obj/item/stack/sheet/iron = 1,
	)
	tool_paths = list(
		/obj/item/hatchet,
	)
	time = 30 SECONDS
	category = CAT_WEAPON_RANGED
	crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_MUST_BE_LEARNED

/datum/crafting_recipe/ashenbow
	name = "灰烬弓"
	result = /obj/item/gun/ballistic/bow/ashenbow
	reqs = list(
		/obj/item/stack/sheet/bone = 6,
		/obj/item/stack/sheet/sinew = 3,
		/obj/item/stack/sheet/leather = 1,
	)
	time = 30 SECONDS
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/photoncannon
	name = "光子炮"
	result = /obj/item/gun/energy/photon
	reqs = list(
		/obj/item/assembly/signaler/anomaly/flux = 1,
		/obj/item/weaponcrafting/gunkit/photon = 1,
	)
	time = 10 SECONDS
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/sks
	name = "萨赫诺SKS半自动步枪"
	result = /obj/item/gun/ballistic/rifle/sks/empty
	reqs = list(
		/obj/item/weaponcrafting/stock = 1,
		/obj/item/weaponcrafting/receiver = 1,
		/obj/item/weaponcrafting/gunkit/sks = 1,
	)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 10 SECONDS
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/dimensional_bombcore
	name = "多维有效载荷"
	result = /obj/item/bombcore/dimensional
	reqs = list(
		/obj/item/gibtonite = 1,
		/obj/item/grenade/chem_grenade = 2,
		/obj/item/assembly/signaler/anomaly/dimensional = 1,
	)
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WELDER)
	time = 12 SECONDS
	category = CAT_WEAPON_RANGED
	steps = list(
		"use high quality gibtonite and advanced release or large grenades for better yield",
	)
