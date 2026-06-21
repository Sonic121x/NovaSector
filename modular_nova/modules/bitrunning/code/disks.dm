/obj/item/disk/bitrunning
	w_class = WEIGHT_CLASS_SMALL

/obj/item/disk/bitrunning/ability/tier0
	name = "比特狂奔程序：戏法"
	selectable_actions = list(
		/datum/action/cooldown/spell/shapeshift/minor_illusion,
		/datum/action/cooldown/spell/conjure_item/fire,
		/datum/action/cooldown/spell/conjure_item/water,
		/datum/action/cooldown/spell/conjure/cheese,
	)

/obj/item/disk/bitrunning/item/tier0
	name = "比特狂奔装备：小饰品"
	selectable_items = list(
		/obj/item/binoculars,
		/obj/item/stack/marker_beacon/thirty,
		/obj/item/storage/belt/military/snack/full,
		/obj/item/dice/d20,
		/obj/item/storage/pouch/medical/firstaid/stabilizer,
		/obj/item/storage/pouch/cin_medkit,
		/obj/item/storage/medkit/robotic_repair/preemo/stocked,
	)

/obj/item/disk/bitrunning/prefs
	name = "\improper 德福雷斯特生物模拟磁盘"
	desc = "一张包含生物模拟数据的磁盘，这些数据是将自定义角色加载到比特狂奔域中所必需的。"
	icon = 'icons/obj/devices/floppy_disks.dmi'
	base_icon_state = "datadisk"
	icon_state = "datadisk0"

	var/datum/preferences/loaded_preference

	var/include_loadout = FALSE

/obj/item/disk/bitrunning/prefs/examine(mob/user)
	. = ..()
	if(!isnull(loaded_preference))
		var/name = loaded_preference.read_preference(/datum/preference/name/real_name)
		. += "It currently has the character [name] loaded, with loadouts [(include_loadout ? "enabled" : "disabled")]"
		. += span_notice("Alt-点击以更改装备加载设置")

/obj/item/disk/bitrunning/prefs/click_alt(mob/user)
	if(isnull(loaded_preference))
		return CLICK_ACTION_BLOCKING
	include_loadout = !include_loadout // We just switch this around. Elegant!
	balloon_alert(user, include_loadout ? "装备已启用" : "装备已禁用")
	return CLICK_ACTION_SUCCESS

/obj/item/disk/bitrunning/prefs/attack_self(mob/user, modifiers)
	. = ..()

	var/list/prefdata_names = user.client.prefs?.create_character_profiles()
	if(isnull(prefdata_names))
		return

	var/response = tgui_alert(user, message = "更改所选偏好？", title = "偏好更改", buttons = list("Yes", "No"))
	if(isnull(response) || response == "No")
		return
	var/choice = tgui_input_list(user, message = "选择一个角色",  title = "角色选择", items = prefdata_names)
	if(isnull(choice) || !user.is_holding(src))
		return

	loaded_preference = new(user.client)
	loaded_preference.load_character(prefdata_names.Find(choice))

	balloon_alert(user, "角色已设置！")
	to_chat(user, span_notice("角色已成功设定为 [choice]！"))

/datum/orderable_item/bitrunning_tech/ability_tier0
	cost_per_order = 350
	purchase_path = /obj/item/disk/bitrunning/ability/tier0
	desc = "这张磁盘包含一个程序，可让你施放次级幻象、召唤奶酪、产生火焰或产生水。"

/datum/orderable_item/bitrunning_tech/item_tier0
	cost_per_order = 350
	purchase_path = /obj/item/disk/bitrunning/item/tier0
	desc = "这张磁盘包含一个程序，可让你装备一副双筒望远镜、三十个标记信标、一个零食架、一个D20骰子、一个稳定剂袋、一个机器人维修套件或一个空的殖民地急救袋。"

/obj/item/disk/bitrunning/item/tierrelax
	name = "比特狂奔装备：休闲"
	selectable_items = list(
		/obj/item/summon_beacon/relax,
		/obj/item/storage/box/nif_ghost_box,
		/obj/item/storage/box/syndie_kit/chameleon/ghostcafe,
		/obj/item/survivalcapsule/luxury,
	)

/obj/item/summon_beacon/relax
	name = "放松机信标"
	icon_state = "sb_delivery"
	desc = "选定自动售货机后，将其传送到目标位置。"

	allowed_areas = list(
		/area/virtual_domain,
		/area/space/virtual_domain,
		/area/ruin/space/virtual_domain,
		/area/icemoon/underground/explored/virtual_domain,
		/area/lavaland/surface/outdoors/virtual_domain,
	)

	selectable_atoms = list(
		/obj/machinery/vending/autodrobe/bitrunning, // "AutoDrobe"
		/obj/machinery/vending/games/bitrunning, // "Good Clean Fun"
		/obj/machinery/vending/clothing/bitrunning, // "ClothesMate"
	)

	area_string = "virtual domains"
	supply_pod_stay = FALSE

/obj/item/summon_beacon/relax/equipped(mob/user, slot, initial)
	. = ..()
	if (!CONFIG_GET(flag/disable_erp_preferences) && user?.client?.prefs.read_preference(/datum/preference/toggle/master_erp_preferences))
		selectable_atoms += /obj/machinery/vending/dorms/bitrunning
	else
		selectable_atoms -= /obj/machinery/vending/dorms/bitrunning

// Be warned, ye who dares to optimize the following bit of code, Initialize is required for vendors to be all_products_free = TRUE, for the code designed for circuits actually resets the value on iniitialize otherwise. be warned and do not spend hours debugging as your predecesors had.

/obj/machinery/vending/dorms/bitrunning/Initialize(mapload)
	. = ..()
	all_products_free = TRUE
	onstation = FALSE

/obj/machinery/vending/autodrobe/bitrunning/Initialize(mapload)
	. = ..()
	all_products_free = TRUE
	onstation = FALSE

/obj/machinery/vending/games/bitrunning/Initialize(mapload)
	. = ..()
	all_products_free = TRUE
	onstation = FALSE

/obj/machinery/vending/clothing/bitrunning/Initialize(mapload)
	. = ..()
	all_products_free = TRUE
	onstation = FALSE

/datum/orderable_item/bitrunning_tech/item_tierrelax
	cost_per_order = 250
	purchase_path = /obj/item/disk/bitrunning/item/tierrelax
	desc = "这张磁盘包含一个程序，可让你装备一个旨在帮助放松的自动售货机传送信标、一个快速启动的NIF程序包、一个豪华生存胶囊或一套变色龙服装。"

/obj/item/disk/bitrunning/item/tier1/Initialize(mapload)
	. = ..()
	selectable_items += list(
		/obj/item/antag_spawner/bitrunning_help,
		/obj/item/storage/belt/military,
		/obj/item/book_of_babel,
		/obj/item/storage/toolbox/syndicate,
		/obj/item/knife/combat,
	)

/obj/item/disk/bitrunning/item/tier2/Initialize(mapload)
	. = ..()
	selectable_items -= list(
		/obj/item/gun/ballistic/automatic/pistol,
	)
	selectable_items += list(
		/obj/item/storage/toolbox/guncase/clandestine,
		/obj/item/storage/toolbox/guncase/wt550,
		/obj/item/autosurgeon/syndicate/hackerman/bitrunning,
		/obj/item/clothing/head/helmet,
		/obj/item/melee/energy/sword/saber/blue,
		/obj/item/storage/medkit/expeditionary/surplus,
		/obj/item/katana,
		/obj/item/shield/riot/tele,
		/obj/item/gun/energy/modular_laser_rifle/carbine,
		/obj/item/syndicate_contacts,
	)

/obj/item/autosurgeon/syndicate/hackerman/bitrunning
	name = "黑客手臂植入器"

/obj/item/disk/bitrunning/item/tier3/Initialize(mapload)
	. = ..()
	selectable_items -= list(
		/obj/item/gun/energy/e_gun/nuclear,
	)
	selectable_items += list(
		/obj/item/domain_anchor,
		/obj/item/autosurgeon/syndicate/nodrop/bitrunning,
		/obj/item/gun/energy/modular_laser_rifle,
		/obj/item/storage/belt/holster/energy/nanite,
		/obj/item/minigunpack,
	)

/obj/item/autosurgeon/syndicate/nodrop/bitrunning
	name = "防掉落植入器"

/obj/item/disk/bitrunning/ability/tier1/Initialize(mapload)
	. = ..()
	selectable_actions += list(
		/datum/action/cooldown/spell/touch/lay_on_hands,
		/datum/action/cooldown/spell/conjure/flare,
	)
	selectable_actions -= list(
		/datum/action/cooldown/spell/conjure/cheese,
	)

/obj/item/disk/bitrunning/ability/tier2/Initialize(mapload)
	. = ..()
	selectable_actions += list(
		/datum/action/cooldown/adrenaline,
		/datum/action/cooldown/spell/charge,
		/datum/action/cooldown/mob_cooldown/dash,
		/datum/action/cooldown/spell/teleport/radius_turf/blink/bitrunning,
		/datum/action/cooldown/spell/sanguine_strike,
		/datum/action/cooldown/spell/tap/bitrunning,
		/datum/action/cooldown/spell/summonitem,
	)

/datum/action/cooldown/spell/tap/bitrunning
	name = "数据抽取"
	desc = "重置所有法术冷却时间，但会削弱你的连接，使用时降低你化身的最大生命值。"
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC

/datum/action/cooldown/spell/teleport/radius_turf/blink/bitrunning
	name = "位置腐化"
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC
	invocation = "CEE'OCEE TEH-HALL!" // coc testinghall
	desc = "将你随机传送到一小段距离外。在狭窄区域或靠近领域边界时可能不可靠。"

/datum/action/cooldown/spell/chuuni_invocations/bitrunning
	name = "生活片段数据洪流"
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC

/obj/item/disk/bitrunning/ability/tier3/Initialize(mapload)
	. = ..()
	selectable_actions += list(
		/datum/action/cooldown/spell/shapeshift/juggernaut,
		/datum/action/cooldown/spell/shapeshift/wraith,
		/datum/action/cooldown/spell/death_loop,
		/datum/action/cooldown/spell/chuuni_invocations/bitrunning,
	)

/obj/item/storage/belt/holster/energy/nanite
	name = "纳米手枪肩挂枪套"
	desc = "一副相当普通的肩挂枪套，内部有些衬垫。旨在容纳一对纳米手枪，但也能装下几种能量手枪。"

/obj/item/storage/belt/holster/energy/nanite/PopulateContents()
	generate_items_inside(list(
		/obj/item/gun/energy/laser/thermal = 2,
	),src)

/datum/orderable_item/bitrunning_tech/item_tier1
	desc = "这张磁盘包含一个程序，可让你装备一个分包协助请求信标、医疗光束枪、一个C4炸药、一盒无限披萨、一个战术工具箱、一把战斗刀或一件军用战术背心。"

/datum/orderable_item/bitrunning_tech/item_tier2
	desc = "这张磁盘包含一个程序，可让你装备一支豪华医疗笔、一个手枪箱、一个步枪箱、一件防弹背心、一顶头盔、一把能量剑、一把武士刀、一把模块化激光卡宾枪、一个远征医疗包、一面防弹盾牌、防闪光隐形眼镜或一个黑客植入体。"

/datum/orderable_item/bitrunning_tech/item_tier3
	desc = "这张磁盘包含一个程序，可让你装备一个领域连接锚、一把Hyeseong激光步枪、一个激光机枪背包、一个纳米手枪枪套、一把双刃能量剑、一个小型炸弹或一个防掉落植入器。"

/datum/orderable_item/bitrunning_tech/ability_tier1
	desc = "这张磁盘包含一个程序，可让你施放召唤光源、次级治疗或修复之触。"

/datum/orderable_item/bitrunning_tech/ability_tier2
	desc = "这张磁盘包含一个程序，可让你施放火球术、闪电箭、嗜血打击、力场墙、肾上腺素爆发、冲刺、闪烁、数据抽取、即刻召唤或充能物品。"

/datum/orderable_item/bitrunning_tech/ability_tier3
	desc = "这张磁盘包含一个程序，可让你变身为次级灰烬龙、北极熊、神圣巨像或神圣幽灵；或学习死亡循环或中二召唤术。"

/datum/orderable_item/bitrunning_tech/pref_item
	cost_per_order = 500
	purchase_path = /obj/item/disk/bitrunning/prefs
	desc = "这张磁盘包含一个程序，可让你载入自定义角色。"
