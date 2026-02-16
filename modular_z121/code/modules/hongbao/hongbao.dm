/**
 * 红包系统
 * 可以打开获得随机物品，支持自定义战利品表和概率
 */

/obj/item/hongbao
	name = "红包"
	desc = "一个喜庆的红包，里面似乎装着什么东西。打开看看吧！"
	icon = 'modular_z121/icons/obj/hongbao.dmi'
	icon_state = "hongbao"
	inhand_icon_state = "envelope"
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE

	/// 战利品表 - 格式: list(物品路径 = 权重)
	var/list/loot_table = null
	/// 是否已经被打开过
	var/opened = FALSE
	/// 打开时的消息
	var/open_message = "打开了红包"
	/// 打开时的音效
	var/open_sound = 'sound/items/poster/poster_ripped.ogg'

/obj/item/hongbao/Initialize(mapload)
	. = ..()
	pixel_x = rand(-5, 5)
	pixel_y = rand(-5, 5)

	// 如果没有指定战利品表，使用默认的
	if(isnull(loot_table))
		loot_table = get_default_loot_table()

/obj/item/hongbao/examine(mob/user)
	. = ..()
	if(opened)
		. += span_notice("这个红包已经被打开过了。")
	else
		. += span_notice("你可以<b>点击</b>它来打开红包。")

/obj/item/hongbao/attack_self(mob/user)
	if(opened)
		to_chat(user, span_warning("[src]已经被打开过了！"))
		return

	if(!loot_table || !length(loot_table))
		to_chat(user, span_warning("[src]里面什么都没有..."))
		qdel(src)
		return

	// 播放音效
	if(open_sound)
		playsound(src, open_sound, 50, TRUE)

	// 从战利品表中随机选择一个物品
	var/chosen_loot = pick_weight(loot_table)

	if(!chosen_loot)
		user.visible_message(
			span_notice("[user][open_message]，但里面什么都没有！"),
			span_notice("你[open_message]，但里面什么都没有...")
		)
		qdel(src)
		return

	// 生成物品在地板上
	var/obj/item/spawned_item = new chosen_loot(get_turf(user))

	spawned_item.add_fingerprint(user)
	// 尝试放到玩家手上，如果失败就留在地板上
	if(user.put_in_hands(spawned_item))
		user.visible_message(
			span_notice("[user][open_message]，获得了[spawned_item]！"),
			span_notice("你[open_message]，获得了[spawned_item]！")
		)
	else
		user.visible_message(
			span_notice("[user][open_message]，[spawned_item]掉在了地上！"),
			span_notice("你[open_message]，但手上拿不下了，[spawned_item]掉在了地上！")
		)

	opened = TRUE
	qdel(src)

/// 获取默认的战利品表
/obj/item/hongbao/proc/get_default_loot_table()
	return list(
		// 现金类
		/obj/item/stack/spacecash/c100 = 30,
		/obj/item/stack/spacecash/c200 = 35,
		/obj/item/stack/spacecash/c500 = 25,
		/obj/item/stack/spacecash/c1000 = 15,
		/obj/item/stack/spacecash/c10000 = 5,
		//福
		/obj/item/sticker/fuzi = 20,
		/obj/item/storage/box/fireworks = 20,
		//稀有大奖
		/obj/item/defibrillator/compact/combat/loaded/nanotrasen = 4,
		/obj/item/bodybag/environmental/nanotrasen = 3,
		/obj/item/gun/medbeam = 4,
		/obj/item/reagent_containers/hypospray/combat/nanites = 3,
		/obj/item/gun/energy/pulse/pistol/loyalpin = 2,
		/obj/item/gun/energy/pulse/carbine/loyalpin = 1,
		/obj/item/mecha_summon_remote/aegis = 1,
	)

// ============================================
// 特殊的
// ============================================

/obj/item/hongbao/syndicate
	name = "辛迪加红包"
	desc = "一个看起来很危险的红包，上面印着辛迪加的标志..."
	icon_state = "syndi"
	open_message = "小心翼翼地打开了辛迪加红包"
	open_sound = 'sound/items/poster/poster_ripped.ogg'

/obj/item/hongbao/syndicate/get_default_loot_table()
	return list(
		// 现金类
		/obj/item/stack/spacecash/c100 = 30,
		/obj/item/stack/spacecash/c200 = 35,
		/obj/item/stack/spacecash/c500 = 25,
		/obj/item/stack/spacecash/c1000 = 15,
		/obj/item/stack/spacecash/c10000 = 5,
		/obj/item/sticker/fuzi = 15,
		/obj/item/storage/box/fireworks = 20,
		// 辛迪加物品
		/obj/item/clothing/under/syndicate = 15,
		/obj/item/card/emag = 5,
		/obj/item/storage/box/syndie_kit = 10,
		/obj/item/clothing/mask/chameleon = 8,
		/obj/item/clothing/gloves/tackler/combat = 12,
		/obj/item/storage/toolbox/syndicate = 15,
		/obj/item/pen/edagger = 5,
		/obj/item/clothing/shoes/chameleon/noslip = 8,
		/obj/item/storage/backpack/duffelbag/syndie = 10,
		/obj/item/clothing/glasses/thermal/syndi = 10,
		/obj/item/clothing/gloves/rapid = 2,
		/obj/item/reagent_containers/hypospray/medipen/stimulants = 5,
		/obj/item/storage/box/syndie_kit/imp_stealth = 5,
		/obj/item/storage/box/syndie_kit/imp_freedom = 5,
		/obj/item/storage/box/syndicate/horse_box = 5,
		// 核队武器套装
		/obj/item/gun/ballistic/automatic/pistol = 7,
		/obj/item/gun/ballistic/shotgun/bulldog = 5,
		/obj/item/gun/ballistic/automatic/c20r = 4,
		/obj/item/gun/ballistic/automatic/l6_saw = 3,
		/obj/item/gun/energy/e_gun/nuclear = 6,
		/obj/item/storage/toolbox/guncase/rocketlauncher = 4,
		/obj/item/mod/control/pre_equipped/elite/unrestricted = 2,
		/obj/item/antag_spawner/nuke_ops/borg_tele/saboteur = 5,
		/obj/item/antag_spawner/nuke_ops/borg_tele/medical = 5,
		/obj/item/antag_spawner/nuke_ops/borg_tele/assault = 5,
		/obj/item/storage/toolbox/guncase/m90gl = 5,
		/obj/item/storage/toolbox/guncase/sword_and_board = 5,
		/obj/item/storage/toolbox/guncase/cqc = 5,
		/obj/item/storage/toolbox/guncase/doublesword = 5,


	)
/obj/item/hongbao/gold
	name = "金色红包"
	desc = "一个十分华丽的金包，但不知为何，也有人叫它“洪包”..."
	icon_state = "gold"
	open_message = "兴奋地打开了金色红包"
	open_sound = 'sound/items/poster/poster_ripped.ogg'
/obj/item/hongbao/gold/get_default_loot_table()
	return list(
		// 现金类
		/obj/item/stack/spacecash/c100 = 10,
		/obj/item/stack/spacecash/c200 = 35,
		/obj/item/stack/spacecash/c500 = 25,
		/obj/item/stack/spacecash/c1000 = 15,
		/obj/item/stack/spacecash/c10000 = 5,
		//黄金钻石
		/obj/item/stack/sheet/mineral/gold = 20,
		/obj/item/stack/sheet/mineral/bananium = 10,
		/obj/item/stack/sheet/mineral/diamond = 10,

		// 小丑物品
		/obj/item/bikehorn/golden = 18,
		/obj/item/card/id/advanced/chameleon/black = 6,
		/obj/item/clothing/shoes/clown_shoes/combat = 9,
		/obj/item/pneumatic_cannon/pie/selfcharge = 3,
		/obj/item/melee/energy/sword/bananium = 4,
		/obj/item/shield/energy/bananium = 4,
		/obj/item/mod/control/pre_equipped/responsory/clown = 2,
		/obj/item/clothing/mask/gas/clown_hat = 8,
		/obj/item/storage/backpack/clown = 10,
		/obj/item/clothing/head/beret/clown = 10,

	)
