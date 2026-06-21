/obj/vehicle/sealed/mecha/solfed/atlas
	desc = "一款为工程和医疗援助配备的战场支援机甲。部署用于在火力下稳定基础设施并救治伤员。"
	name = "\improper MSU-2539B1 \"擎天神\""
	icon_state = "atlas" //Sprite by diltyrr on discord
	base_icon_state = "atlas"
	movedelay = 3.75
	max_integrity = 300
	armor_type = /datum/armor/mecha_atlas
	max_temperature = 30000
	force = 25
	destruction_sleep_duration = 40
	exit_delay = 40
	wreckage = /obj/structure/mecha_wreckage/solfed/atlas
	max_equip_by_category = list(
		MECHA_L_ARM = 1,
		MECHA_R_ARM = 1,
		MECHA_UTILITY = 6,
		MECHA_POWER = 1,
		MECHA_ARMOR = 1,
	)
	equip_by_category = list(
		MECHA_L_ARM = /obj/item/mecha_parts/mecha_equipment/solfed_welder,
		MECHA_R_ARM = /obj/item/mecha_parts/mecha_equipment/medical/mechmedbeam/solfed,
		MECHA_UTILITY = list(
			/obj/item/mecha_parts/mecha_equipment/radio,
			/obj/item/mecha_parts/mecha_equipment/air_tank/full,
			/obj/item/mecha_parts/mecha_equipment/thrusters/ion,
			/obj/item/mecha_parts/mecha_equipment/repair_droid,
			/obj/item/mecha_parts/mecha_equipment/kinetic_dampener,
			/obj/item/mecha_parts/mecha_equipment/utility/fob_3d_printer,
		),
		MECHA_POWER = list(/obj/item/mecha_parts/mecha_equipment/generator),
		MECHA_ARMOR = list(/obj/item/mecha_parts/mecha_equipment/armor/anticcw_armor_booster),
	)

/datum/armor/mecha_atlas
	melee = 35
	bullet = 30
	laser = 20
	energy = 20
	bomb = 40
	fire = 100
	acid = 100

/obj/vehicle/sealed/mecha/solfed/atlas/Initialize(mapload)
	. = ..()
	max_ammo()

/obj/vehicle/sealed/mecha/solfed/atlas/populate_parts()
	cell = new /obj/item/stock_parts/power_store/cell/bluespace(src)
	scanmod = new /obj/item/stock_parts/scanning_module/triphasic(src)
	capacitor = new /obj/item/stock_parts/capacitor/quadratic(src)
	servo = new /obj/item/stock_parts/servo/femto(src)
	update_part_values()

/obj/structure/mecha_wreckage/solfed/atlas
	name = "\improper 擎天神残骸"
	desc = "擎天神级支援机甲的残骸。其钳形模块扭曲且半熔化，底盘烧焦。"
	icon = 'modular_nova/modules/solfed_mechs/icons/solfed_mechs.dmi'
	icon_state = "atlas-broken"
	welder_salvage = list(/obj/item/stack/sheet/iron, /obj/item/stack/rods)

/obj/vehicle/sealed/mecha/solfed/atlas/moved_inside(mob/living/carbon/human/human)
	. = ..()
	if(!.)
		return
	ADD_TRAIT(human, TRAIT_MEDICAL_HUD, VEHICLE_TRAIT)
	ADD_TRAIT(human, TRAIT_DIAGNOSTIC_HUD, VEHICLE_TRAIT)

/obj/vehicle/sealed/mecha/solfed/atlas/remove_occupant(mob/living/carbon/human/human)
	REMOVE_TRAIT(human, TRAIT_MEDICAL_HUD, VEHICLE_TRAIT)
	REMOVE_TRAIT(human, TRAIT_DIAGNOSTIC_HUD, VEHICLE_TRAIT)
	return ..()
