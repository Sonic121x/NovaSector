////// Outpost Turret, Will be used for space ruins.
/obj/item/storage/toolbox/emergency/turret/mag_fed/outpost
	name = "前哨防御炮塔套件"
	desc = "一种为前哨点防御和驱离流浪动物而设计的可部署炮塔。"
	icon = 'modular_nova/modules/magfed_turret/icons/turrets/ruins.dmi'
	icon_state = "outpost_toolbox"
	righthand_file = 'modular_nova/modules/magfed_turret/icons/inhands/righthand.dmi'
	lefthand_file = 'modular_nova/modules/magfed_turret/icons//inhands/lefthand.dmi'
	inhand_icon_state = "outpost_turretkit"
	turret_type = /obj/machinery/porta_turret/syndicate/toolbox/mag_fed/outpost
	mag_slots = 2
	mag_types_allowed = list(
		/obj/item/ammo_box/magazine/c40sol_rifle
	)

/obj/item/storage/toolbox/emergency/turret/mag_fed/outpost/pre_filled/PopulateContents()
	new /obj/item/ammo_box/magazine/c40sol_rifle(src)
	new /obj/item/ammo_box/magazine/c40sol_rifle(src)

/obj/machinery/porta_turret/syndicate/toolbox/mag_fed/outpost
	name = "\improper 前哨点防御炮塔"
	desc = "一种用于保护前哨站和民用设施的可部署炮塔。"
	max_integrity = 120
	icon = 'modular_nova/modules/magfed_turret/icons/turrets/ruins.dmi'
	icon_state = "outpost_off"
	base_icon_state = "outpost"
	shot_delay = 1.5 SECONDS
	faction = list(FACTION_TURRET)
	fragile = TRUE
	turret_frame = /obj/item/turret_assembly
	mag_box_type = /obj/item/storage/toolbox/emergency/turret/mag_fed/outpost/pre_filled

/obj/machinery/porta_turret/syndicate/toolbox/mag_fed/outpost/malf
	name = "\improper 故障前哨炮塔"
	faction = list(FACTION_MALF_TURRET)
	shot_delay = 1 SECONDS

////// Colonist Turret. Kinda just made to be a ghost-role friendly version of the outpost turret

/obj/item/storage/toolbox/emergency/turret/mag_fed/colonist
	name = "殖民者防御炮塔套件"
	desc = "一种为殖民地建设和殖民者远征营地安全而设计的可部署炮塔。它使用.40索尔弹药"
	icon = 'modular_nova/modules/magfed_turret/icons/turrets/ruins.dmi'
	icon_state = "colonist_toolbox"
	righthand_file = 'modular_nova/modules/magfed_turret/icons/inhands/righthand.dmi'
	lefthand_file = 'modular_nova/modules/magfed_turret/icons//inhands/lefthand.dmi'
	inhand_icon_state = "colonist_turretkit"
	turret_type = /obj/machinery/porta_turret/syndicate/toolbox/mag_fed/colonist
	mag_slots = 2
	easy_deploy = TRUE
	turret_safety = TRUE
	mag_types_allowed = list(
		/obj/item/ammo_box/magazine/c40sol_rifle,
	)

/obj/item/storage/toolbox/emergency/turret/mag_fed/colonist/pre_filled/PopulateContents()
	new /obj/item/ammo_box/magazine/c40sol_rifle(src)
	new /obj/item/ammo_box/magazine/c40sol_rifle(src)

/obj/machinery/porta_turret/syndicate/toolbox/mag_fed/colonist
	name = "\improper 殖民者点防御炮塔"
	desc = "一种用于在建设或远征旅行期间保护殖民者的可部署炮塔。它装填了.40索尔弹药。"
	max_integrity = 150 //bit more health since it's ment for mobs only. Malf version is one of a kind to use.
	icon = 'modular_nova/modules/magfed_turret/icons/turrets/ruins.dmi'
	icon_state = "colonist_off"
	base_icon_state = "colonist"
	shot_delay = 1.5 SECONDS
	quick_retract = TRUE
	faction = list(FACTION_TURRET)
	mag_box_type = /obj/item/storage/toolbox/emergency/turret/mag_fed/colonist/pre_filled

/obj/machinery/porta_turret/syndicate/toolbox/mag_fed/colonist/malf
	name = "\improper 故障殖民者点防御炮塔"
	faction = list(FACTION_MALF_TURRET)
	mag_box_type = /obj/item/storage/toolbox/emergency/turret/mag_fed/colonist/pre_filled

////// Spider turret. Throw-deployable turret with actual ammunition.

/obj/item/storage/toolbox/emergency/turret/mag_fed/spider
	name = "蜘蛛攻击炮塔胶囊"
	desc = "一种投掷部署式炮塔胶囊，专为在敌对生物控制区域内确保安全而设计。它使用.35索尔弹药。"
	icon = 'modular_nova/modules/magfed_turret/icons/turrets/ruins.dmi'
	icon_state = "35_spider_toolbox"
	inhand_icon_state = "smoke" //I dont want to squash-make something. This should cover until i work something.
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
	throw_speed = 2
	w_class = WEIGHT_CLASS_NORMAL // This isn't going to spawn outside of ruins/ghost roles, so it being small shouldn't be too big of a concern?
	quick_deployable = TRUE
	quick_deploy_timer = 1 SECONDS
	turret_type = /obj/machinery/porta_turret/syndicate/toolbox/mag_fed/spider
	mag_slots = 1
	turret_safety = TRUE
	mag_types_allowed = list(
		/obj/item/ammo_box/magazine/c35sol_pistol,
	)

/obj/item/storage/toolbox/emergency/turret/mag_fed/spider/pre_filled/PopulateContents()
	new /obj/item/ammo_box/magazine/c35sol_pistol(src)

/obj/machinery/porta_turret/syndicate/toolbox/mag_fed/spider
	name = "\improper 毒刺蜘蛛炮塔"
	desc = "一种用于积极扩张和区域防御的可部署炮塔。它装填了.35索尔弹药。"
	max_integrity = 80
	icon = 'modular_nova/modules/magfed_turret/icons/turrets/ruins.dmi'
	icon_state = "35_spider_off"
	base_icon_state = "35_spider"
	shot_delay = 1.5 SECONDS
	faction = list(FACTION_TURRET)
	mag_box_type = /obj/item/storage/toolbox/emergency/turret/mag_fed/spider/pre_filled

/obj/machinery/porta_turret/syndicate/toolbox/mag_fed/spider/malf // for ruins from here on
	name = "\improper 故障的双牙炮塔"
	faction = list(FACTION_MALF_TURRET)
	mag_box_type = /obj/item/storage/toolbox/emergency/turret/mag_fed/spider/malf/pre_filled

/obj/item/storage/toolbox/emergency/turret/mag_fed/spider/malf
	name = "怪异蜘蛛炮塔套件"
	desc = "一种用于积极扩张和区域防御的可部署炮塔套件。它使用.35索尔弹药。这个炮塔似乎有些奇怪的灯光在闪烁。"
	turret_type = /obj/machinery/porta_turret/syndicate/toolbox/mag_fed/spider/malf

/obj/item/storage/toolbox/emergency/turret/mag_fed/spider/malf/pre_filled/PopulateContents()
	new /obj/item/ammo_box/magazine/c35sol_pistol(src)

////// Twin-Fang turret. Spider Turret's nastier cousin. Slightly less durable but more vitriol. Chambered in .27-54

/obj/item/storage/toolbox/emergency/turret/mag_fed/spider/twin_fang
	name = "双牙进攻型炮塔胶囊"
	desc = "一种投掷部署的炮塔胶囊，设计用于在敌对生物占据的区域中确保安全。它使用.27-54切萨尔佐瓦弹药。"
	icon = 'modular_nova/modules/magfed_turret/icons/turrets/ruins.dmi'
	icon_state = "twin_spider_toolbox"
	turret_type = /obj/machinery/porta_turret/syndicate/toolbox/mag_fed/spider/twin_fang
	mag_slots = 1
	turret_safety = FALSE
	mag_types_allowed = list(
		/obj/item/ammo_box/magazine/miecz,
	)

/obj/item/storage/toolbox/emergency/turret/mag_fed/spider/twin_fang/pre_filled/PopulateContents()
	new /obj/item/ammo_box/magazine/miecz(src)

/obj/machinery/porta_turret/syndicate/toolbox/mag_fed/spider/twin_fang
	name = "\improper 双牙蜘蛛炮塔"
	desc = "一种用于积极扩张和区域防御的可部署炮塔。它使用.27-54切萨尔佐瓦弹药。"
	max_integrity = 50 // more aggressive but obviously easier to deal with.
	icon = 'modular_nova/modules/magfed_turret/icons/turrets/ruins.dmi'
	icon_state = "twin_spider_off"
	base_icon_state = "twin_spider"
	fragile = TRUE
	turret_frame = /obj/item/turret_assembly/twin_fang
	quick_retract = TRUE
	shot_delay = 0.1 SECONDS
	burst_fire = TRUE
	burst_delay = 1.5 SECONDS
	burst_volley = 2
	faction = list(FACTION_TURRET)
	mag_box_type = /obj/item/storage/toolbox/emergency/turret/mag_fed/spider/twin_fang/pre_filled

/obj/machinery/porta_turret/syndicate/toolbox/mag_fed/spider/twin_fang/malf
	name = "\improper 故障双牙炮塔"
	faction = list(FACTION_MALF_TURRET)
	mag_box_type = /obj/item/storage/toolbox/emergency/turret/mag_fed/spider/twin_fang/malf/pre_filled

/obj/item/storage/toolbox/emergency/turret/mag_fed/spider/twin_fang/malf
	name = "怪异双牙炮塔套件"
	desc = "一种投掷部署的炮塔胶囊，设计用于在敌对生物占据的区域中确保安全。它使用.27-54切萨尔佐瓦弹药。这个炮塔似乎有些奇怪的灯光在闪烁。"
	turret_type = /obj/machinery/porta_turret/syndicate/toolbox/mag_fed/spider/twin_fang/malf

/obj/item/storage/toolbox/emergency/turret/mag_fed/spider/twin_fang/malf/pre_filled/PopulateContents()
	new /obj/item/ammo_box/magazine/miecz(src)

////// Shotgun Turret. Surprisingly nothing new added as the firing proc will handle pellet clouds. Note however that shotgun rounds CANT smart-gun around allies.
/obj/item/storage/toolbox/emergency/turret/mag_fed/duster
	name = "除尘者应急炮塔套件"
	desc = "一种为紧急情况设计的快速部署炮塔套件，带有警告：“不要站在枪管前。友军火力可不是闹着玩的”。它适配使用散装霰弹或M12g弹匣。"
	icon = 'modular_nova/modules/magfed_turret/icons/turrets/ruins.dmi'
	icon_state = "duster_toolbox"
	righthand_file = 'modular_nova/modules/magfed_turret/icons/inhands/righthand.dmi'
	lefthand_file = 'modular_nova/modules/magfed_turret/icons//inhands/lefthand.dmi'
	inhand_icon_state = "duster_turretkit"
	easy_deploy = TRUE
	turret_type = /obj/machinery/porta_turret/syndicate/toolbox/mag_fed/duster
	mag_slots = 3 // Most mags dont have more than 8 rounds, and you're going to have hell getting a shotgun mag to re-fill. 24 round total.
	turret_safety = FALSE
	mag_types_allowed = list(
		/obj/item/ammo_box/magazine/ammo_stack/s12gauge, //Easy to get actually. Quite Nice
		/obj/item/ammo_box/magazine/m12g,
	)

/obj/item/storage/toolbox/emergency/turret/mag_fed/duster/pre_filled/PopulateContents()
	new /obj/item/ammo_box/magazine/ammo_stack/s12gauge/prefilled/buckshot(src)
	new /obj/item/ammo_box/magazine/ammo_stack/s12gauge/prefilled/buckshot(src)
	new /obj/item/ammo_box/magazine/ammo_stack/s12gauge/prefilled/buckshot(src)

/obj/machinery/porta_turret/syndicate/toolbox/mag_fed/duster
	name = "\improper 除尘者应急炮塔"
	desc = "一种用于紧急情况和撤退部署的快速部署炮塔，无法使用智能弹丸瞄准。它适配使用散装霰弹或M12g弹匣。"
	max_integrity = 100
	icon = 'modular_nova/modules/magfed_turret/icons/turrets/ruins.dmi'
	icon_state = "duster_off"
	base_icon_state = "duster"
	fragile = TRUE
	turret_frame = /obj/item/turret_assembly/duster
	ignore_faction = FALSE // Pellet cloud wont work with it anyways.
	quick_retract = TRUE
	shot_delay = 2 SECONDS
	faction = list(FACTION_TURRET)
	mag_box_type = /obj/item/storage/toolbox/emergency/turret/mag_fed/duster/pre_filled

/obj/machinery/porta_turret/syndicate/toolbox/mag_fed/duster/malf
	name = "\improper 故障除尘者炮塔"
	faction = list(FACTION_MALF_TURRET)
