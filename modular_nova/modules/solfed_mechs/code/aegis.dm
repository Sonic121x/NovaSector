/obj/vehicle/sealed/mecha/solfed/aegis
	desc = "一款由太阳联邦特警部队部署的坚固防暴控制平台。专为高风险区域的群体压制和防御性护送而设计。"
	name = "\improper MRC-2544D1 \"埃癸斯\""
	icon_state = "aegis" //Sprite by diltyrr on discord
	base_icon_state = "aegis"
	movedelay = 4.5
	max_integrity = 375
	accesses = list() //check whatever SWAT access is.
	armor_type = /datum/armor/mecha_aegis
	max_temperature = 30000
	force = 30
	destruction_sleep_duration = 40
	exit_delay = 40
	wreckage = /obj/structure/mecha_wreckage/solfed/aegis
	pivot_step = TRUE
	max_equip_by_category = list(
		MECHA_L_ARM = 1,
		MECHA_R_ARM = 1,
		MECHA_UTILITY = 4,
		MECHA_POWER = 1,
		MECHA_ARMOR = 1,
	)
	equip_by_category = list(
		MECHA_L_ARM = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/solfed_riotgun,
		MECHA_R_ARM = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/solfed_teargas,
		MECHA_UTILITY = list(/obj/item/mecha_parts/mecha_equipment/radio, /obj/item/mecha_parts/mecha_equipment/air_tank/full, /obj/item/mecha_parts/mecha_equipment/kinetic_dampener, /obj/item/mecha_parts/mecha_equipment/repair_droid),
		MECHA_POWER = list(/obj/item/mecha_parts/mecha_equipment/generator),
		MECHA_ARMOR = list(/obj/item/mecha_parts/mecha_equipment/armor/anticcw_armor_booster),
	)

/datum/armor/mecha_aegis
	melee = 50
	bullet = 40
	laser = 20
	energy = 15
	bomb = 30
	fire = 100
	acid = 100

/obj/vehicle/sealed/mecha/solfed/aegis/Initialize(mapload)
	. = ..()
	max_ammo()

/obj/vehicle/sealed/mecha/solfed/aegis/populate_parts()
	cell = new /obj/item/stock_parts/power_store/cell/bluespace(src)
	scanmod = new /obj/item/stock_parts/scanning_module/triphasic(src)
	capacitor = new /obj/item/stock_parts/capacitor/quadratic(src)
	servo = new /obj/item/stock_parts/servo/femto(src)
	update_part_values()

/obj/structure/mecha_wreckage/solfed/aegis
	name = "\improper 埃癸斯残骸"
	desc = "一具埃癸斯级机甲的扭曲残骸。其装甲撕裂烧焦，肢体以不自然的角度扭曲。无论是什么击毁了它，过程都绝不温和。"
	icon = 'modular_nova/modules/solfed_mechs/icons/solfed_mechs.dmi'
	icon_state = "aegis-broken"
	welder_salvage = list(/obj/item/stack/sheet/iron, /obj/item/stack/rods)

