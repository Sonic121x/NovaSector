/obj/vehicle/sealed/mecha/solfed/prometheus
	desc = "一款为突入行动和城市战设计的双足突击机甲。其重型武装和加固底盘使其成为夺回失守区域的理想选择。"
	name = "\improper MAI-2548A2 \"普罗米修斯\""
	icon_state = "prometheus" //Sprite by diltyrr on discord
	base_icon_state = "prometheus"
	movedelay = 3.5
	max_integrity = 425
	armor_type = /datum/armor/mecha_prometheus
	max_temperature = 30000
	force = 35
	destruction_sleep_duration = 40
	exit_delay = 40
	wreckage = /obj/structure/mecha_wreckage/solfed/prometheus
	pivot_step = TRUE
	max_equip_by_category = list(
		MECHA_L_ARM = 1,
		MECHA_R_ARM = 1,
		MECHA_UTILITY = 4,
		MECHA_POWER = 1,
		MECHA_ARMOR = 1,
	)
	equip_by_category = list(
		MECHA_L_ARM = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/solfed_rotary,
		MECHA_R_ARM = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/solfed_napalm,
		MECHA_UTILITY = list(/obj/item/mecha_parts/mecha_equipment/radio, /obj/item/mecha_parts/mecha_equipment/air_tank/full, /obj/item/mecha_parts/mecha_equipment/repair_droid, /obj/item/mecha_parts/mecha_equipment/kinetic_dampener),
		MECHA_POWER = list(/obj/item/mecha_parts/mecha_equipment/generator),
		MECHA_ARMOR = list(/obj/item/mecha_parts/mecha_equipment/armor/antiproj_armor_booster),
	)

/datum/armor/mecha_prometheus
	melee = 60
	bullet = 45
	laser = 35
	energy = 25
	bomb = 50
	fire = 100
	acid = 100

/obj/vehicle/sealed/mecha/solfed/prometheus/Initialize(mapload)
	. = ..()
	max_ammo()

/obj/vehicle/sealed/mecha/solfed/prometheus/generate_actions()
	. = ..()
	initialize_controller_action_type(/datum/action/vehicle/sealed/mecha/prometheus_ram, VEHICLE_CONTROL_SETTINGS)

/obj/vehicle/sealed/mecha/solfed/prometheus/populate_parts()
	cell = new /obj/item/stock_parts/power_store/cell/bluespace(src)
	scanmod = new /obj/item/stock_parts/scanning_module/triphasic(src)
	capacitor = new /obj/item/stock_parts/capacitor/quadratic(src)
	servo = new /obj/item/stock_parts/servo/femto(src)
	update_part_values()

/obj/structure/mecha_wreckage/solfed/prometheus
	name = "\improper 普罗米修斯残骸"
	desc = "普罗米修斯级突入机甲的残骸。其前部装甲向内凹陷，液压冲撞器已熔毁卡死。有什么东西的打击超出了它的设计承受极限。"
	icon = 'modular_nova/modules/solfed_mechs/icons/solfed_mechs.dmi'
	icon_state = "prometheus-broken"
	welder_salvage = list(/obj/item/stack/sheet/iron, /obj/item/stack/rods)

/datum/action/vehicle/sealed/mecha/prometheus_ram
	name = "液压冲撞器"
	desc = "启动普罗米修斯胸部的液压冲撞器，猛击正前方的目标。"
	button_icon = 'modular_nova/modules/sec_haul/icons/peacekeeper/peacekeeper_items.dmi'
	button_icon_state = "peacekeeper_hammer"

/datum/action/vehicle/sealed/mecha/prometheus_ram/Trigger(mob/user, trigger_flags)
	. = ..()
	if(!.)
		return
	var/turf/front_turf = get_step(chassis, chassis.dir)
	if(!front_turf)
		return

	var/atom/movable/ram_target

	// Priority 1: Vehicle
	var/obj/vehicle/vehicle_target = locate(/obj/vehicle) in front_turf
	if(vehicle_target)
		ram_target = vehicle_target

	// Priority 2: Mob
	if(!ram_target)
		var/mob/living/living_target = locate(/mob/living) in front_turf
		if(living_target)
			ram_target = living_target

	// Priority 3: Firedoor (active only)
	if(!ram_target)
		var/obj/machinery/door/firedoor/firedoor_target = locate(/obj/machinery/door/firedoor) in front_turf
		if(firedoor_target && firedoor_target.active)
			ram_target = firedoor_target

	// Priority 4: airlock door
	if(!ram_target)
		var/obj/machinery/door/door_target = locate(/obj/machinery/door/airlock) in front_turf
		ram_target = door_target

	// Priority 5: Door assembly
	if(!ram_target)
		var/obj/structure/door_assembly/assembly_target = locate(/obj/structure/door_assembly) in front_turf
		ram_target = assembly_target

	if(!ram_target)
		to_chat(user, span_warning("正前方没有有效目标！"))
		return

	// Wind-up with do_after (2 seconds)
	if(!do_after(user, 2 SECONDS, ram_target))
		return

	playsound(chassis, 'sound/effects/clang.ogg', 70, TRUE)
	user.visible_message(
		span_danger("[chassis] 将其液压冲撞器以震耳欲聋的巨响砸向 [ram_target]！"),
		span_danger("你将液压冲撞器猛击向 [ram_target]！"),
		null,
		COMBAT_MESSAGE_RANGE
	)

	var/damage_amount = chassis.force
	if(istype(ram_target, /mob/living))
		var/mob/living/living_target = ram_target
		living_target.apply_damage(damage_amount, BRUTE)
	else
		damage_amount = chassis.force * 9
		var/atom/ramget = ram_target
		ramget.take_damage(damage_amount)
