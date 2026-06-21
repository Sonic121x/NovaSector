/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/solfed_riotgun
	name = "\improper S-12 \"守望者\" 动能防暴枪"
	desc = "一种太阳联邦防暴控制武器，设计用于压制和区域拒止。发射高密度橡胶弹。"
	icon_state = "mecha_scatter"
	equip_cooldown = 1.5 SECONDS
	projectile = /obj/projectile/bullet/c85x20mm/rubber
	projectiles = 20
	projectiles_cache = 20
	projectiles_cache_max = 80
	projectiles_per_shot = 1
	variance = 10
	harmful = TRUE
	ammo_type = MECHA_AMMO_RUBBER
	fire_sound = 'sound/items/weapons/gun/shotgun/shot.ogg'
	detachable = FALSE

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/solfed_rotary
	name = "\improper VX-9 \"硫磺\" 转轮机炮"
	desc = "一种太阳联邦突击级转轮机炮。以高速连发射击燃烧弹。"
	icon = 'modular_nova/modules/solfed_mechs/icons/mecha_equipment.dmi'
	icon_state = "rotary"
	equip_cooldown = 0.4 SECONDS
	projectile = /obj/projectile/bullet/c40sol/incendiary
	projectiles = 180
	projectiles_cache = 180
	projectiles_cache_max = 720
	projectiles_per_shot = 3
	variance = 5
	randomspread = 1
	projectile_delay = 1
	harmful = TRUE
	ammo_type = MECHA_AMMO_INCENDIARY
	fire_sound = 'sound/items/weapons/gun/hmg/hmg.ogg'
	detachable = FALSE

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/solfed_railgun
	name = "\improper T-99 \"天坠\" 质量加速器"
	desc = "安装在塔纳托斯平台上的攻城级弹道武器。发射能够穿透加固结构的超密度弹体。"
	icon_state = "mecha_pulse"
	equip_cooldown = 6 SECONDS
	projectile = /obj/projectile/bullet/rocket/c250x40mm
	projectiles = 12
	projectiles_cache = 12
	projectiles_cache_max = 24
	projectiles_per_shot = 1
	variance = 2
	harmful = TRUE
	ammo_type = MECHA_AMMO_SIEGE
	fire_sound = 'modular_nova/modules/solfed_mechs/sounds/railgun.ogg'
	detachable = FALSE

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/solfed_teargas
	name = "\improper SGL-7 \"警戒\" 气体发射器"
	desc = "一种用于维和外骨骼的武器。发射已启动的催泪瓦斯榴弹以驱散敌对人群。"
	icon_state = "mecha_grenadelnchr"
	projectile = /obj/item/grenade/chem_grenade/solfed/teargas
	fire_sound = 'sound/items/weapons/gun/general/grenade_launch.ogg'
	projectiles = 6
	projectiles_cache = 6
	projectiles_cache_max = 24
	missile_speed = 1.5
	equip_cooldown = 6 SECONDS
	ammo_type = MECHA_AMMO_TEARGAS
	detachable = FALSE
	///Time between firing and grenade detonating.
	var/det_time = 1 SECONDS

/obj/item/grenade/chem_grenade/solfed
	icon = 'modular_nova/modules/solfed_mechs/icons/grenades.dmi'
	///icon_state for the detonated grenade.
	det_time = 1 SECONDS
	possible_fuse_time = list("10")
	var/post_detonation_icon_state = null
	///Has this exploded already?
	var/detonated = FALSE

/obj/item/grenade/chem_grenade/solfed/attack_self(mob/user)
	if (detonated)
		to_chat(user, span_warning("这颗手榴弹已经用过了。"))
	else
		to_chat(user, span_warning("你似乎找不到手动引爆这台机甲手榴弹的方法。"))
	return FALSE

/obj/item/grenade/chem_grenade/solfed/teargas
	name = "催泪瓦斯手榴弹"
	desc = "一种非致命性人群控制装置，引爆后会释放刺激性气体云。用于驱散敌对集会并制服不合作的个体。"
	base_icon_state = "teargas"
	stage = GRENADE_READY
	post_detonation_icon_state = "teargas_spent"

//Ammount of chem divided by two compared to normal teargas for balance
/obj/item/grenade/chem_grenade/solfed/teargas/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/cup/beaker/large/beaker_one = new(src)
	var/obj/item/reagent_containers/cup/beaker/large/beaker_two = new(src)

	beaker_one.reagents.add_reagent(/datum/reagent/consumable/condensedcapsaicin, 30)
	beaker_one.reagents.add_reagent(/datum/reagent/potassium, 20)
	beaker_two.reagents.add_reagent(/datum/reagent/phosphorus, 20)
	beaker_two.reagents.add_reagent(/datum/reagent/consumable/sugar, 20)

	beakers += beaker_one
	beakers += beaker_two

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/solfed_teargas/proj_init(obj/item/grenade/chem_grenade/teargas/grenade)
	var/turf/tar_turf = get_turf(src)
	message_admins("[ADMIN_LOOKUPFLW(usr)] fired a [grenade] in [ADMIN_VERBOSEJMP(tar_turf)]")
	usr.log_message("fired a [grenade] in [AREACOORD(tar_turf)].", LOG_GAME)
	usr.log_message("fired a [grenade] in [AREACOORD(tar_turf)].", LOG_ATTACK)
	addtimer(CALLBACK(grenade, TYPE_PROC_REF(/obj/item/grenade/chem_grenade/solfed/teargas, detonate)), det_time, TIMER_STOPPABLE | TIMER_DELETE_ME)

/obj/item/grenade/chem_grenade/solfed/teargas/detonate(mob/living/lanced_by)
	. = ..()
	set_post_detonation_icon()

///Updates the grenades icon after detonation.
/obj/item/grenade/chem_grenade/solfed/proc/set_post_detonation_icon()
	if(post_detonation_icon_state)
		icon_state = post_detonation_icon_state
		detonated = TRUE

/obj/item/grenade/chem_grenade/solfed/napalm
	name = "凝固汽油手榴弹"
	base_icon_state = "napalm"
	desc = "一种高温燃烧装置。散布凝胶基化合物，能附着在表面并剧烈燃烧。请极其小心地处理。"
	stage = GRENADE_READY
	post_detonation_icon_state = "napalm_spent"
	///Amount of sparks made by the grenade, used to light the napalm on fire.
	var/spark_amount = 3

/obj/item/grenade/chem_grenade/solfed/napalm/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/cup/beaker/large/beaker_one = new(src)
	var/obj/item/reagent_containers/cup/beaker/large/beaker_two = new(src)

	beaker_one.reagents.add_reagent(/datum/reagent/napalm, 30)
	beaker_two.reagents.add_reagent(/datum/reagent/napalm, 30)

	beakers += beaker_one
	beakers += beaker_two

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/solfed_napalm
	name = "\improper VX-13 \"灰烬制造者\" 燃烧迫击炮"
	desc = "安装在普罗米修斯级突破机甲上的短程迫击炮系统。发射设计用于附着、燃烧和驱赶掩体内目标的燃烧凝胶弹，同时不损害船体完整性。"
	icon_state = "mecha_grenadelnchr"
	projectile = /obj/item/grenade/chem_grenade/solfed/napalm
	fire_sound = 'sound/items/weapons/gun/general/grenade_launch.ogg'
	projectiles = 6
	projectiles_cache = 6
	projectiles_cache_max = 24
	missile_speed = 1.5
	equip_cooldown = 6 SECONDS
	ammo_type = MECHA_AMMO_NAPALM
	detachable = FALSE
	///Time between firing the grenade and it exploding.
	var/det_time = 1 SECONDS

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/launcher/solfed_napalm/proj_init(obj/item/grenade/chem_grenade/solfed/napalm/grenade)
	var/turf/tar_turf = get_turf(src)
	message_admins("[ADMIN_LOOKUPFLW(usr)] fired a [grenade] in [ADMIN_VERBOSEJMP(tar_turf)]")
	usr.log_message("fired a [grenade] in [AREACOORD(tar_turf)].", LOG_GAME)
	usr.log_message("fired a [grenade] in [AREACOORD(tar_turf)].", LOG_ATTACK)
	update_icon_state()
	addtimer(CALLBACK(grenade, TYPE_PROC_REF(/obj/item/grenade/chem_grenade/solfed/napalm, detonate)), det_time, TIMER_STOPPABLE | TIMER_DELETE_ME)

/obj/item/grenade/chem_grenade/solfed/napalm/detonate(mob/living/lanced_by)
	. = ..()
	set_post_detonation_icon()
	addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/item/grenade/chem_grenade/solfed/napalm, ignite_napalm_pool)), 1 SECONDS, TIMER_STOPPABLE | TIMER_DELETE_ME)

///Create an amount of sparks from the grenade.
/obj/item/grenade/chem_grenade/solfed/napalm/proc/ignite_napalm_pool()
	do_sparks(spark_amount, FALSE, src)

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/turret/solfed_minigun
	name = "\improper VX-2 \"死神\" 旋转炮塔"
	desc = "安装在塔纳托斯级突破机甲上的双管旋转炮塔。交替发射.40索尔长弹进行火力压制和反人员交战。"
	icon = 'modular_nova/modules/solfed_mechs/icons/mecha_equipment.dmi'
	icon_state = "rotary"
	equip_cooldown = 0.3 SECONDS
	projectile = /obj/projectile/bullet/c40sol
	projectiles = 300
	projectiles_cache = 300
	projectiles_cache_max = 1200
	projectiles_per_shot = 4
	variance = 4
	randomspread = 1
	projectile_delay = 0.5
	harmful = TRUE
	ammo_type = MECHA_AMMO_LMG
	fire_sound = 'sound/items/weapons/gun/hmg/hmg.ogg'
	detachable = FALSE

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/solfed_emp_cannon
	name = "\improper EMC-2521 EMP 炮"
	desc = "为赫尔墨斯级侦察机甲开发的先进电磁脉冲炮。发射能够使电子设备和轻装甲系统失能的精确EMP脉冲。"
	icon_state = "mecha_ion"
	equip_cooldown = 2 SECONDS
	projectile = /obj/projectile/ion/small
	projectiles = 12
	projectiles_cache = 12
	projectiles_cache_max = 48
	projectile_delay = 0
	variance = 2
	harmful = TRUE
	ammo_type = MECHA_AMMO_EMP
	fire_sound = 'sound/items/weapons/gun/general/heavy_shot_suppressed.ogg'
	detachable = FALSE

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/solfed_carbine
	name = "\improper MMR-2543A \"卡拉德\" 轻机枪"
	desc = "卡拉德轻机枪的机甲适配版，使用.40索尔长弹。专为赫尔墨斯级侦察机甲设计，可进行精确的半自动点射。"
	icon_state = "mecha_carbine"
	equip_cooldown = 0.6 SECONDS
	projectile = /obj/projectile/bullet/c40sol
	projectiles = 30
	projectiles_cache = 30
	projectiles_cache_max = 120
	projectile_delay = 1
	projectiles_per_shot = 2
	variance = 3
	harmful = TRUE
	ammo_type = MECHA_AMMO_LMG
	fire_sound = 'sound/items/weapons/gun/general/heavy_shot_suppressed.ogg'
	detachable = FALSE

/obj/item/mecha_parts/mecha_equipment/medical/mechmedbeam/solfed
	name = "S-MBG 'Aegis' medical beamgun"
	desc = "索联工程设计的医疗射线枪，用于在敌对环境中进行战场部署。发射稳定的纳米脉冲，用于快速分诊和伤口闭合。"
	detachable = FALSE
	energy_drain = 12	//Slightly higher than NT, assuming NT tech is a bit better here.

/obj/item/weldingtool/electric/arc_welder/mech_mounted
	name = "阿特拉斯机甲焊枪"
	light_system = NO_LIGHT_SUPPORT
	light_range = 0

// mounted subtype that deletes its tool flash element on init
/obj/item/weldingtool/electric/arc_welder/mech_mounted/Initialize(mapload)
	. = ..()
	RemoveElement(/datum/element/tool_flash)

/obj/item/mecha_parts/mecha_equipment/solfed_welder
	name = "阿特拉斯工程焊枪"
	desc = "索联工程设计的焊枪，用于战场维修、结构焊接和战术拆解。"
	icon_state = "mecha_wholegen"
	equip_cooldown = 1 SECONDS
	force = 15
	damtype = BURN
	hitsound = 'sound/items/tools/welder.ogg'
	energy_drain = 10
	detachable = FALSE
	///The actual welding tool used for the welding actions.
	var/obj/item/weldingtool/electric/arc_welder/mech_mounted/welding_tool
	///Switch between main and alternate welder action.
	var/welding = FALSE

/obj/item/mecha_parts/mecha_equipment/solfed_welder/Initialize(mapload)
	. = ..()
	welding_tool = new /obj/item/weldingtool/electric/arc_welder/mech_mounted(src)
	welding_tool.welding = TRUE
	welding_tool.force = 15
	welding_tool.damtype = BURN
	welding_tool.hitsound = 'sound/items/tools/welder.ogg'

/obj/item/mecha_parts/mecha_equipment/solfed_welder/action(mob/living/source, atom/target, list/modifiers)
	if(!action_checks(target))
		return FALSE

	if(source.combat_mode)
		welding_tool.melee_attack_chain(source, target)
	else if(welding)
		target.welder_act_secondary(source, welding_tool)
	else
		target.welder_act(source, welding_tool)

	TIMER_COOLDOWN_START(chassis, COOLDOWN_MECHA_EQUIPMENT(type), equip_cooldown)
	SEND_SIGNAL(source, COMSIG_MOB_USED_MECH_EQUIPMENT, chassis)
	chassis.use_energy(energy_drain)

	return TRUE

/obj/item/mecha_parts/mecha_equipment/solfed_welder/attach(obj/vehicle/sealed/mecha/new_mecha, attach_right)
	. = ..()
	new_mecha.initialize_controller_action_type(/datum/action/vehicle/sealed/mecha/solfed_toggle_welding, VEHICLE_CONTROL_SETTINGS)

/obj/item/mecha_parts/mecha_equipment/solfed_welder/detach(atom/moveto)
	chassis?.destroy_controller_action_type(/datum/action/vehicle/sealed/mecha/solfed_toggle_welding, VEHICLE_CONTROL_SETTINGS)
	return ..()

/obj/item/mecha_parts/mecha_equipment/solfed_welder/Destroy()
	chassis?.destroy_controller_action_type(/datum/action/vehicle/sealed/mecha/solfed_toggle_welding, VEHICLE_CONTROL_SETTINGS)
	return ..()

/datum/action/vehicle/sealed/mecha/solfed_toggle_welding
	name = "切换焊枪模式"
	button_icon = 'modular_nova/modules/solfed_mechs/icons/action_mecha.dmi'
	button_icon_state = "welder_off"
	desc = "在主焊接模式与备用焊接模式之间切换。"

/datum/action/vehicle/sealed/mecha/solfed_toggle_welding/Trigger(mob/clicker, trigger_flags)
	. = ..()
	if(!.)
		return
	var/obj/item/mecha_parts/mecha_equipment/solfed_welder/welder = locate(/obj/item/mecha_parts/mecha_equipment/solfed_welder) in chassis.contents
	welder.welding = !welder.welding
	if(welder.welding)
		button_icon_state = "welder_on"
	else
		button_icon_state = "welder_off"
	build_all_button_icons()
	to_chat(clicker, "焊枪模式已切换：[welder.welding ? "Alternate mode" : "Main mode"]。")
