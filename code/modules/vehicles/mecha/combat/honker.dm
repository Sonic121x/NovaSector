/obj/vehicle/sealed/mecha/honker
	desc = "由“HONK暴政公司”生产，这款外骨骼装备专为增强角色的活力而设计。旨在传递生活的乐趣与喜悦。HONK！"
	name = "\improper H.O.N.K"
	ui_theme = "neutral"
	icon_state = "honker"
	base_icon_state = "honker"
	movedelay = 3
	max_integrity = 140
	force = 30
	armor_type = /datum/armor/mecha_honker
	max_temperature = 25000
	destruction_sleep_duration = 40
	exit_delay = 40
	accesses = list(ACCESS_MECH_SCIENCE, ACCESS_THEATRE)
	wreckage = /obj/structure/mecha_wreckage/honker
	mecha_flags = CAN_STRAFE | IS_ENCLOSED | HAS_LIGHTS | MMI_COMPATIBLE | BEACON_TRACKABLE | AI_COMPATIBLE | BEACON_CONTROLLABLE
	mech_type = EXOSUIT_MODULE_HONK
	max_equip_by_category = list(
		MECHA_L_ARM = 1,
		MECHA_R_ARM = 1,
		MECHA_UTILITY = 4,
		MECHA_POWER = 1,
		MECHA_ARMOR = 0,
	)
	var/squeak = TRUE

/datum/armor/mecha_honker
	melee = -20
	fire = 100
	acid = 100

/obj/vehicle/sealed/mecha/honker/Initialize(mapload, built_manually)
	. = ..()
	AddElementTrait(TRAIT_WADDLING, REF(src), /datum/element/waddling)

/obj/vehicle/sealed/mecha/honker/play_stepsound()
	if(squeak)
		playsound(src, SFX_CLOWN_STEP, 70, 1)
	squeak = !squeak


//DARK H.O.N.K.

/obj/vehicle/sealed/mecha/honker/dark
	desc = "这款外骨骼装备由“HONK暴政公司”生产，其设计初衷是为重装小丑提供支撑。此款已涂成黑色，以达到最大的趣味效果。HONK！"
	name = "\improper 暗黑H.O.N.K"
	ui_theme = "syndicate"
	icon_state = "darkhonker"
	max_integrity = 300
	armor_type = /datum/armor/honker_dark
	max_temperature = 35000
	accesses = list(ACCESS_SYNDICATE)
	wreckage = /obj/structure/mecha_wreckage/honker/dark
	mecha_flags = ID_LOCK_ON | CAN_STRAFE | IS_ENCLOSED | HAS_LIGHTS | MMI_COMPATIBLE | AI_COMPATIBLE
	max_equip_by_category = list(
		MECHA_L_ARM = 1,
		MECHA_R_ARM = 1,
		MECHA_UTILITY = 3,
		MECHA_POWER = 1,
		MECHA_ARMOR = 2,
	)

/obj/vehicle/sealed/mecha/honker/dark/Initialize(mapload, built_manually)
	. = ..()
	add_minimap_blip(src, MINIMAP_SYNDICATE_MECH_BLIP, "syndiemech")

/obj/vehicle/sealed/mecha/honker/dark/loaded
	equip_by_category = list(
		MECHA_L_ARM = /obj/item/mecha_parts/mecha_equipment/weapon/honker,
		MECHA_R_ARM = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/banana_mortar/bombanana,
		MECHA_UTILITY = list(/obj/item/mecha_parts/mecha_equipment/radio, /obj/item/mecha_parts/mecha_equipment/air_tank/full, /obj/item/mecha_parts/mecha_equipment/thrusters/ion),
		MECHA_POWER = list(),
		MECHA_ARMOR = list(),
	)

/datum/armor/honker_dark
	melee = 40
	bullet = 40
	laser = 50
	energy = 35
	bomb = 20
	fire = 100
	acid = 100

/obj/vehicle/sealed/mecha/honker/dark/loaded/populate_parts()
	cell = new /obj/item/stock_parts/power_store/cell/hyper(src)
	scanmod = new /obj/item/stock_parts/scanning_module/phasic(src)
	capacitor = new /obj/item/stock_parts/capacitor/super(src)
	servo = new /obj/item/stock_parts/servo/pico(src)
	update_part_values()

/obj/structure/mecha_wreckage/honker/dark
	name = "\improper 暗黑H.O.N.K残骸"
	icon_state = "darkhonker-broken"
