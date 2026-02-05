//	tac-9
/obj/item/gun/ballistic/automatic/pistol/tac9
	name = "TAC-9 战斗手枪"
	desc = "在枪械市场上最受欢迎的手枪之一，枪声清脆响亮，据说它的设计灵感来至于21世纪的9mm半自动手枪。这把枪使用15发弹匣"
	w_class = WEIGHT_CLASS_NORMAL

	icon = 'modular_z121/icons/obj/guns/weapon_addtion/guns32x.dmi'
	icon_state = "tac9"

	accepted_magazine_type = /obj/item/ammo_box/magazine/tac9
	can_suppress = TRUE
	suppressor_x_offset = 9
	suppressor_y_offset = 0

	fire_sound = 'modular_z121/sound/guns/tac9/tac9_fire.ogg'
	fire_sound_volume = 45

	projectile_damage_multiplier = 0.8

/obj/item/gun/ballistic/automatic/pistol/tac9/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/seclite_attachable, \
		starting_light = new /obj/item/flashlight/seclite(src), \
		is_light_removable = FALSE, \
	)

/obj/item/ammo_box/magazine/tac9
	name = "TAC-9 弹匣"
	desc = "可容纳15发9mm子弹的弹匣，容量不大不小，大小也适中"
	icon = 'modular_z121/icons/obj/guns/weapon_addtion/ammo.dmi'
	icon_state = "tac"
	base_icon_state = "tac"
	ammo_type = /obj/item/ammo_casing/c9mm
	caliber = CALIBER_9MM
	max_ammo = 15
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/ammo_box/magazine/tac9/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]-[round(ammo_count(), 3)]"

/obj/item/ammo_box/magazine/tac9/starts_empty
	start_empty = TRUE

//	sofap
/obj/item/gun/ballistic/automatic/pistol/sofap
	name = "\improper SOFAP 自动手枪"
	desc = "一把可全自动开火的自动手枪，使用 .35 sol 制式弹匣，开火迅速，但伤害不高。枪口刻有可以固定消音器的螺纹，还配有一个可以挂载战术手电的导轨。"

	icon = 'modular_z121/icons/obj/guns/weapon_addtion/guns32x.dmi'
	icon_state = "sofap"

	lefthand_file = 'modular_z121/icons/mob/guns/weapon_addtion/guns_lefthand.dmi'
	righthand_file = 'modular_z121/icons/mob/guns/weapon_addtion/guns_righthand.dmi'
	inhand_icon_state = "sofap"

	fire_sound = 'modular_z121/sound/guns/sofap/sofap_fire.ogg'
	fire_sound_volume = 80
	suppressed_sound = 'modular_z121/sound/guns/sofap/sofap_fire_suppressed.ogg'

	w_class = WEIGHT_CLASS_NORMAL

	accepted_magazine_type = /obj/item/ammo_box/magazine/c35sol_pistol
	special_mags = TRUE	//  不同的弹匣贴图
	empty_indicator = TRUE	//  弹药耗尽贴图

	//  可安装消音器
	can_suppress = TRUE

	suppressor_x_offset = 6
	suppressor_y_offset = 0

	fire_delay = 0.1 SECONDS
	bolt_type = BOLT_TYPE_STANDARD
	actions_types = list()	//  无法切换射击模式
	spread = 12.5
	recoil = 0.5

	//  0.6x 伤害修正
	projectile_damage_multiplier = 0.6

//  SOFAP 可挂载战术手电
/obj/item/gun/ballistic/automatic/pistol/sofap/add_seclight_point()
	AddComponent(/datum/component/seclite_attachable, \
		light_overlay_icon = 'modular_z121/icons/obj/guns/weapon_addtion/guns32x.dmi', \
		light_overlay = "sofap_flashlight", \
		overlay_x = 0, \
		overlay_y = 0)

/obj/item/gun/ballistic/automatic/pistol/sofap/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, fire_delay)//  全自动开火

/obj/item/gun/ballistic/automatic/pistol/sofap/no_mag
	spawnwithmagazine = FALSE

//	BFR-500
/obj/item/gun/ballistic/revolver/single
	name = "BFR-500 单动式左轮"
	desc = "一把大口径左轮，它不一定不适合狩猎动物，不过用它狩猎两脚兽再适合不过了"
	icon = 'modular_z121/icons/obj/guns/weapon_addtion/guns32x.dmi'
	icon_state = "bfr500"
	lefthand_file = 'modular_z121/icons/mob/guns/weapon_addtion/guns_lefthand.dmi'
	righthand_file = 'modular_z121/icons/mob/guns/weapon_addtion/guns_righthand.dmi'
	inhand_icon_state = "bfr500"
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/cylinder/bfr500
	fire_sound = 'modular_z121/sound/guns/bfr500/bfr500_fire.ogg'
	fire_sound_volume = 35
	semi_auto = FALSE
	recoil = 2
	fire_delay = 1 SECONDS
	projectile_damage_multiplier = 0.75

	var/hammer_back_sound = 'modular_z121/sound/guns/bfr500/hammer_back.ogg'
	var/hammer_back_sound_volume = 50

	var/hammer_fall_sound = 'sound/items/weapons/gun/general/bolt_drop.ogg'
	var/hammer_fall_sound_volume = 50
	var/cocked = TRUE

/obj/item/gun/ballistic/revolver/single/examine(mob/user)
	. = ..()
	. += "<b>alt + click</b> 弹出子弹"

/obj/item/gun/ballistic/revolver/single/can_shoot()
	if (!cocked)
		return FALSE
	return ..()

/obj/item/gun/ballistic/revolver/single/before_firing(atom/target,mob/user)
	cocked = FALSE
	update_appearance()
	return ..()

/obj/item/gun/ballistic/revolver/single/shoot_with_empty_chamber(mob/living/user as mob|obj)
	if(cocked)
		playsound(src, hammer_fall_sound, hammer_fall_sound_volume, TRUE)
		if (user)
			balloon_alert_to_viewers("击锤放下")
		cocked = FALSE
		update_appearance()
	else
		playsound(src, dry_fire_sound, dry_fire_sound_volume, TRUE)
		balloon_alert_to_viewers("*click*")
	return

/obj/item/gun/ballistic/revolver/single/attack_self(mob/living/user, obj/item/tool, list/modifiers)
	if (!cocked)
		balloon_alert(user, "击锤压下")
		cocked = TRUE
		chamber_round()
		playsound(src, hammer_back_sound, hammer_back_sound_volume, TRUE)
		update_appearance()
	else
		balloon_alert(user, "击锤已压下")
	return

/obj/item/gun/ballistic/revolver/single/click_alt(mob/user)
	unload_ammo(user)
	return CLICK_ACTION_SUCCESS

/obj/item/gun/ballistic/revolver/single/update_overlays()
	. = ..()
	. += "[icon_state]_hammer[cocked ? "_back": ""]"

/obj/item/ammo_box/magazine/internal/cylinder/bfr500
	name = "bfr500 cylinder"
	ammo_type = /obj/item/ammo_casing/c357
	caliber = CALIBER_357
	max_ammo = 5

/obj/item/ammo_box/bfr500
	name = "BFR-500 快速装弹器"
	desc = "BFR-500专用装弹器，它的大小非常大，就像是秤砣一样"
	icon = 'modular_z121/icons/obj/guns/weapon_addtion/ammo.dmi'
	icon_state = "bfr_loader"
	w_class = WEIGHT_CLASS_NORMAL
	ammo_type = /obj/item/ammo_casing/c357
	max_ammo = 5
	multiple_sprites = AMMO_BOX_PER_BULLET
	item_flags = NO_MAT_REDEMPTION

//	防止被叛徒利用
/obj/item/gun/ballistic/revolver/c38/detective/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if (istype(tool, /obj/item/ammo_box/bfr500))
		to_chat(user, span_danger("你尝试使用[tool]装填[src]，但它们不兼容！"))
		return
	return ..()

//	EVO-13
/obj/item/gun/ballistic/automatic/evo
	name = "EVO-13 冲锋枪"
	desc = "这把枪是以21世纪的某把枪为原型，复原出来的产物，使用标准9mm子弹"

	icon = 'modular_z121/icons/obj/guns/weapon_addtion/guns48x.dmi'
	icon_state = "evo"

	worn_icon = 'modular_z121/icons/mob/guns/weapon_addtion/guns_worn.dmi'
	worn_icon_state = "evo"

	lefthand_file = 'modular_z121/icons/mob/guns/weapon_addtion/guns_lefthand.dmi'
	righthand_file = 'modular_z121/icons/mob/guns/weapon_addtion/guns_righthand.dmi'
	inhand_icon_state = "evo"
	SET_BASE_PIXEL(-8, 0)

	fire_sound = 'modular_z121/sound/guns/evo13/evo13_fire.ogg'
	fire_sound_volume = 40
	suppressed_sound = 'sound/items/weapons/gun/smg/shot_suppressed.ogg'

	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY
	slot_flags = ITEM_SLOT_BACK

	accepted_magazine_type = /obj/item/ammo_box/magazine/evo_c9mm

	//  可安装消音器
	can_suppress = TRUE
	suppressor_x_offset = 4
	suppressor_y_offset = 0

	burst_size = 1
	projectile_damage_multiplier = 0.3
	fire_delay = 0.1 SECONDS
	spread = 5

	actions_types = list()

/obj/item/gun/ballistic/automatic/evo/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, fire_delay)

/obj/item/gun/ballistic/automatic/evo/no_mag
	spawnwithmagazine = FALSE

/obj/item/ammo_box/magazine/evo_c9mm
	name = "EVO-13 冲锋枪弹匣"
	desc = "EVO-13的专用弹匣，可容纳30发子弹"
	icon = 'modular_z121/icons/obj/guns/weapon_addtion/ammo.dmi'
	icon_state = "evo"
	base_icon_state = "evo"
	multiple_sprites = AMMO_BOX_FULL_EMPTY
	ammo_type = /obj/item/ammo_casing/c9mm
	caliber = CALIBER_9MM
	max_ammo = 30

/obj/item/ammo_box/magazine/evo_c9mm/starts_empty
	start_empty = TRUE

//	europa
/obj/item/gun/ballistic/automatic/europa
	name = "\improper europa轻机枪"
	desc = "一把沉重的.40Sol long口径机枪，自带两根用于稳定射击的脚架，只使用特制的50发大弹盒"

	icon = 'modular_z121/icons/obj/guns/weapon_addtion/guns48x.dmi'
	icon_state = "europa"

	worn_icon = 'modular_z121/icons/mob/guns/weapon_addtion/guns_worn.dmi'
	worn_icon_state = "europa"

	lefthand_file = 'modular_z121/icons/mob/guns/weapon_addtion/guns_lefthand.dmi'
	righthand_file = 'modular_z121/icons/mob/guns/weapon_addtion/guns_righthand.dmi'
	inhand_icon_state = "europa"

	fire_sound = 'modular_z121/sound/guns/europa/europa_fire.ogg'

	mag_display = TRUE  // 显示弹匣
	mag_display_ammo = TRUE  // 显示剩余弹药
	empty_indicator = TRUE

	w_class = WEIGHT_CLASS_HUGE
	weapon_weight = WEAPON_HEAVY
	slot_flags = ITEM_SLOT_BACK

	accepted_magazine_type = /obj/item/ammo_box/magazine/europa

	item_flags = SLOWS_WHILE_IN_HAND
	slowdown = 1

	burst_size = 1
	fire_delay = 0.2 SECONDS
	recoil = 1
	spread = 25

	actions_types = list()

	projectile_damage_multiplier = 0.75

	force = 15 //你也可以用这枪砸人，也挺疼的

	var/bipod_open = FALSE //脚架的部署状态

/obj/item/gun/ballistic/automatic/europa/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)
	AddComponent(/datum/component/automatic_fire, fire_delay)

/obj/item/gun/ballistic/automatic/europa/examine(mob/user)
	. = ..()
	. += "<b>alt + click</b> 把脚架 [bipod_open ? "收起" : "放下"]"
	. += "脚架放下并趴下射击弹道会更加稳定"

/obj/item/gun/ballistic/automatic/europa/click_alt(mob/user)
	bipod_open = !bipod_open
	balloon_alert(user, "脚架 [bipod_open ? "放下" : "收起"]")
	playsound(src, 'sound/items/weapons/gun/l6/l6_door.ogg', 60, TRUE)
	update_appearance()
	return CLICK_ACTION_SUCCESS

/obj/item/gun/ballistic/automatic/europa/update_overlays()
	. = ..()
	. += "europa_bipod_[bipod_open ? "open" : "closed"]"


/obj/item/gun/ballistic/automatic/europa/process_fire(atom/target, mob/living/user, message, params, zone_override)
	if(bipod_open && user.body_position == LYING_DOWN && user.has_gravity())
		recoil = 0.25
		spread = 7.5
	else
		recoil = initial(recoil)
		spread = initial(spread)

	. = ..()
	if(.)
		update_appearance()
	return .

/obj/item/gun/ballistic/automatic/europa/no_mag
	spawnwithmagazine = FALSE

/obj/item/ammo_box/magazine/europa
	name = "europa弹盒"
	desc = "可以容纳50发.40Sol long的弹盒，体积很大"
	icon = 'modular_z121/icons/obj/guns/weapon_addtion/ammo.dmi'
	icon_state = "europa"

	w_class = WEIGHT_CLASS_NORMAL

	ammo_type = /obj/item/ammo_casing/c40sol
	caliber = CALIBER_SOL40LONG
	max_ammo = 50

/obj/item/ammo_box/magazine/europa/update_icon_state()
	. = ..()
	icon_state = "europa-[min(round(ammo_count(), 10), 50)]"

/obj/item/ammo_box/magazine/europa/starts_empty
	start_empty = TRUE

//	AA12
/obj/item/gun/ballistic/shotgun/aa12
	name = "AA12 全自动霰弹枪"
	desc = "这是一把巨大且沉重的霰弹枪，与其它霰弹枪相比，它死沉死沉的。不过至少，它可以全自动开火"

	icon = 'modular_z121/icons/obj/guns/weapon_addtion/guns48x.dmi'
	icon_state = "aa12"

	worn_icon = 'modular_z121/icons/mob/guns/weapon_addtion/guns_worn.dmi'
	worn_icon_state = "aa12"

	lefthand_file = 'modular_z121/icons/mob/guns/weapon_addtion/guns_lefthand.dmi'
	righthand_file = 'modular_z121/icons/mob/guns/weapon_addtion/guns_righthand.dmi'
	inhand_icon_state = "aa12"
	inhand_x_dimension = 32
	inhand_y_dimension = 32

	SET_BASE_PIXEL(-8, 0)
	fire_sound = 'modular_z121/sound/guns/aa12/aa12_fire.ogg'

	special_mags = TRUE
	semi_auto = TRUE
	casing_ejector = TRUE
	internal_magazine = FALSE
	tac_reloads = TRUE

	w_class = WEIGHT_CLASS_HUGE
	weapon_weight = WEAPON_HEAVY
	slot_flags = ITEM_SLOT_BACK

	accepted_magazine_type = /obj/item/ammo_box/magazine/aa12
	spawnwithmagazine = TRUE

	burst_size = 1
	fire_delay = 0.5 SECONDS
	actions_types = list()
	spread = 0

	//  0.75x 伤害修正
	projectile_damage_multiplier = 0.75

	//  开膛待击
	bolt_type = BOLT_TYPE_OPEN

/obj/item/gun/ballistic/shotgun/aa12/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, fire_delay)

/obj/item/ammo_box/magazine/aa12
	name = "AA12 弹匣"
	desc = "可容纳5发霰弹的弹匣，它看上去有点大"

	icon = 'modular_z121/icons/obj/guns/weapon_addtion/ammo.dmi'
	icon_state = "aa12_standard"
	base_icon_state = "aa12_standard"

	multiple_sprites = AMMO_BOX_FULL_EMPTY
	w_class = WEIGHT_CLASS_SMALL

	ammo_type = /obj/item/ammo_casing/shotgun/rubbershot
	caliber = CALIBER_SHOTGUN
	max_ammo = 5

/obj/item/ammo_box/magazine/aa12/starts_empty
	start_empty = TRUE


/obj/item/ammo_box/magazine/aa12/drum
	name = "AA12 弹鼓"
	desc = "可容纳15发霰弹的弹鼓，容量大的惊人，体积也大的惊人"

	icon = 'modular_z121/icons/obj/guns/weapon_addtion/ammo.dmi'
	icon_state = "aa12_drum"
	base_icon_state = "aa12_drum"

	multiple_sprites = AMMO_BOX_FULL_EMPTY
	w_class = WEIGHT_CLASS_NORMAL

	ammo_type = /obj/item/ammo_casing/shotgun/rubbershot
	caliber = CALIBER_SHOTGUN
	max_ammo = 15

/obj/item/ammo_box/magazine/aa12/drum/starts_empty
	start_empty = TRUE

//	DEX-4
/obj/item/gun/ballistic/shotgun/dex4
	name = "DEX-4 智能霰弹枪"
	desc = "这是把实验性半自动霰弹枪，刚上市不久。采用了电磁加速技术，能将各种霰弹给予足以穿透护甲动能"
	icon = 'modular_z121/icons/obj/guns/weapon_addtion/guns48x.dmi'
	icon_state = "dex4"
	inhand_icon_state = "dex4"
	lefthand_file = 'modular_z121/icons/mob/guns/weapon_addtion/guns_lefthand.dmi'
	righthand_file = 'modular_z121/icons/mob/guns/weapon_addtion/guns_righthand.dmi'
	worn_icon = 'modular_z121/icons/mob/guns/weapon_addtion/guns_worn.dmi'
	worn_icon_state = "dex4"
	SET_BASE_PIXEL(-8, 0)
	fire_sound = 'modular_z121/sound/guns/dex4/dex4_fire.ogg'
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	actions_types = list(/datum/action/item_action/dex4/toggle_spread)
	w_class = WEIGHT_CLASS_BULKY
	semi_auto = TRUE
	casing_ejector = TRUE
	internal_magazine = FALSE
	tac_reloads = TRUE
	empty_indicator = TRUE
	empty_alarm = TRUE
	accepted_magazine_type = /obj/item/ammo_box/magazine/dex4
	fire_delay = 1 SECONDS

	var/emp_malfunction = FALSE
	var/obj/item/ammo_casing/casing
	var/spread_mode = FALSE

/obj/item/gun/ballistic/shotgun/dex4/examine(mob/user)
	. = ..()
	if(obj_flags & EMAGGED)
		. += span_notice("[src] 的显示屏上显示着黄色<font color='#ffaa00'>三角警告标志</font>，你最好<b><font color='#ff0000'>不要使用这把枪开火</font></b>，除非你被逼入绝境")
	else if(emp_malfunction)
		. += span_notice("[src] 的显示屏上显示着巨大红色的<font color='#ff0000'>叉叉</font>，看来这把枪<b><font color='#ff0000'>故障</font></b>了")
	else
		. += span_notice("[src] 的显示屏上显示着 [spread_mode ? "一些扩散分布的圆形图案，看来这把枪处于<b>散射模式</b>" : "一些直线分布的圆形图案，看来这把枪处于<b>集束模式</b>"]")

/obj/item/gun/ballistic/shotgun/dex4/handle_chamber(empty_chamber = TRUE, from_firing = TRUE, chamber_next_round = TRUE)
	if(chambered)
		chambered.variance = initial(chambered.variance)
		UnregisterSignal(casing, COMSIG_CASING_READY_PROJECTILE)
	. = ..()
	casing = chambered
	spread_change(casing)
	RegisterSignal(casing, COMSIG_CASING_READY_PROJECTILE, PROC_REF(casing_modifiers))

/datum/action/item_action/dex4/toggle_spread
	name = "切换扩散"
	desc = "切换武器的扩散模式"
	button_icon = 'modular_z121/icons/mob/actions/dex4.dmi'
	button_icon_state = "precision"

/datum/action/item_action/dex4/toggle_spread/IsAvailable(feedback = FALSE)
	. = ..()
	if(!.)
		return FALSE
	if(!istype(target, /obj/item/gun/ballistic/shotgun/dex4))
		return FALSE

	var/obj/item/gun/ballistic/shotgun/dex4/toggle_spread = target
	if(toggle_spread.emp_malfunction)
		return FALSE
	return TRUE

/obj/item/gun/ballistic/shotgun/dex4/ui_action_click(mob/user, action)
	. = ..()
	if(istype(action, /datum/action/item_action/dex4/toggle_spread))
		var/datum/action/item_action/dex4/toggle_spread/spreadmode = locate() in actions
		playsound(src, 'sound/items/modsuit/ballin.ogg', 100, TRUE)
		spread_mode = !spread_mode
		balloon_alert(user, "切换 [spread_mode ? "散射" : "集束"] 模式")
		spreadmode.button_icon_state = "[spread_mode ? "spread" : "precision"]"
		spreadmode.build_all_button_icons()
		spread_change(casing)

/obj/item/gun/ballistic/shotgun/dex4/proc/spread_change(obj/item/ammo_casing/the_casing)
	if(!the_casing)
		return
	if(spread_mode)
		the_casing.variance = initial(the_casing.variance) * 2
	else
		the_casing.variance = initial(the_casing.variance) * 0.75

/obj/item/gun/ballistic/shotgun/dex4/proc/casing_modifiers()
	var/obj/projectile/bullet = casing.loaded_projectile
	if(!emp_malfunction || obj_flags & EMAGGED)
	//	移除护甲弱效
		bullet.weak_against_armour = FALSE
		//	霰弹的衰减率减少
		bullet.damage_falloff_tile *= 0.25
		bullet.stamina_falloff_tile *= 0.25
		bullet.wound_falloff_tile *= 0.25
		bullet.embed_falloff_tile *= 0.25
	if(obj_flags & EMAGGED)
		bullet.armour_penetration += 50

/obj/item/gun/ballistic/shotgun/dex4/emp_act(severity)
	. = ..()
	if (!(. & EMP_PROTECT_SELF) && prob(50 / severity))
		emp_malfunction = TRUE
		spread_mode = TRUE
		spread_change(casing)
		var/datum/action/item_action/dex4/toggle_spread/spreadmode = locate() in actions
		spreadmode.button_icon_state = "spread"
		spreadmode.build_all_button_icons(UPDATE_BUTTON_STATUS)

/obj/item/gun/ballistic/shotgun/dex4/multitool_act(mob/living/user, obj/item/tool)
	if(!tool.use_tool(src, user, 20 SECONDS, volume = 50))
		balloon_alert(user, "打断！")
		return ITEM_INTERACT_BLOCKING

	emp_malfunction = FALSE
	update_appearance()
	balloon_alert(user, "系统重启")
	var/datum/action/item_action/dex4/toggle_spread/spreadmode = locate() in actions
	spreadmode.build_all_button_icons(UPDATE_BUTTON_STATUS)
	return ITEM_INTERACT_SUCCESS

/obj/item/gun/ballistic/shotgun/dex4/emag_act(mob/user, obj/item/card/emag/emag_card)
	. = ..()
	if(obj_flags & EMAGGED)
		return FALSE
	obj_flags |= EMAGGED
	projectile_damage_multiplier = 2
	projectile_speed_multiplier = 2
	balloon_alert(user, "电磁抑制系统已停用")

	return TRUE

/obj/item/gun/ballistic/shotgun/dex4/process_fire(atom/target, mob/living/user, params)
	. = ..()
	if ((obj_flags & EMAGGED))
		//	爆！！！
		explosion(src, heavy_impact_range = 1, light_impact_range = 3, explosion_cause = src)
		qdel(src)

/obj/item/ammo_box/magazine/dex4
	name = "DEX-4 弹匣"
	desc = "可容纳8发霰弹的弹匣"
	icon = 'modular_z121/icons/obj/guns/weapon_addtion/ammo.dmi'
	icon_state = "dex"
	base_icon_state = "dex"
	multiple_sprites = AMMO_BOX_FULL_EMPTY
	ammo_type = /obj/item/ammo_casing/shotgun/rubbershot
	caliber = CALIBER_SHOTGUN
	max_ammo = 8

/obj/item/ammo_box/magazine/dex4/starts_empty
	start_empty = TRUE

//光子
/obj/item/gun/energy/photon_sniper
	name = "光子狙击步枪"
	desc = "一把能量狙击枪，发射足以点燃目标的高能激光，且不能烤肉，建议使用年龄：18岁以上"
	icon = 'modular_z121/icons/obj/guns/weapon_addtion/guns48x.dmi'
	icon_state = "photon"
	lefthand_file = 'modular_z121/icons/mob/guns/weapon_addtion/guns_lefthand.dmi'
	righthand_file = 'modular_z121/icons/mob/guns/weapon_addtion/guns_righthand.dmi'
	inhand_icon_state = "photon"
	worn_icon = 'modular_z121/icons/mob/guns/weapon_addtion/guns_worn.dmi'
	worn_icon_state = "photon"
	SET_BASE_VISUAL_PIXEL(-8, 0)
	weapon_weight = WEAPON_HEAVY
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	ammo_type = list(/obj/item/ammo_casing/energy/photon_sniper)
	shaded_charge = TRUE
	charge_sections = 3

/obj/item/gun/energy/photon_sniper/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/scope, range_modifier = 2)

/obj/item/ammo_casing/energy/photon_sniper
	projectile_type = /obj/projectile/energy/photon_sniper
	e_cost = LASER_SHOTS(10, STANDARD_CELL_CHARGE)
	fire_sound = "modular_z121/sound/guns/photon_sniper/photon_sniper_fire.ogg"
	click_cooldown_override = 25
	select_name = "burn"

/obj/projectile/energy/photon_sniper
	name = "光子束"
	icon_state = null
	hitscan = TRUE
	muzzle_type = /obj/effect/projectile/muzzle/heavy_laser
	tracer_type = /obj/effect/projectile/tracer/laser/emitter/redlens
	impact_type = /obj/effect/projectile/impact/heavy_laser
	impact_effect_type = null
	damage = 20
	damage_type = BURN
	armor_flag = ENERGY
	reflectable = NONE
	range = 50
	var/temperature = 300
	var/fire_stacks = 1

/obj/projectile/energy/photon_sniper/on_hit(atom/target, blocked = 0, pierce_hit)
	. = ..()
	if(iscarbon(target))
		var/mob/living/carbon/hit_mob = target
		var/thermal_protection = 1 - hit_mob.get_insulation_protection(hit_mob.bodytemperature + temperature)
		var/how_hot_is_target = hit_mob.bodytemperature
		var/danger_zone = hit_mob.dna.species.bodytemp_heat_damage_limit + 300

		// The new body temperature is adjusted by the bullet's effect temperature
		// Reduce the amount of the effect temperature change based on the amount of insulation the mob is wearing
		hit_mob.adjust_bodytemperature((thermal_protection * temperature) + temperature)

		if(how_hot_is_target > danger_zone)
			hit_mob.adjust_fire_stacks(fire_stacks)
			hit_mob.ignite_mob()

	else if(isliving(target))
		var/mob/living/L = target
		// the new body temperature is adjusted by the bullet's effect temperature
		L.adjust_bodytemperature((1 - blocked) * temperature)

	if(isobj(target))
		var/obj/objectification = target

		if(objectification.reagents)
			var/datum/reagents/reagents = objectification.reagents
			reagents?.expose_temperature(temperature)

//	矿用霰弹
/obj/item/gun/ballistic/shotgun/mining
	name = "矿用霰弹枪"
	desc = "一种特化的半自动霰弹枪，主要用于狩猎爱好者与矿工在拉瓦兰狩猎。为了防止有人滥用这把枪，它被设计成了只能装填狩猎独头弹"
	icon = 'modular_z121/icons/obj/guns/weapon_addtion/guns48x.dmi'
	icon_state = "mining_shotgun"

	worn_icon = 'modular_z121/icons/mob/guns/weapon_addtion/guns_worn.dmi'
	worn_icon_state = "mining_shotgun"

	lefthand_file = 'modular_z121/icons/mob/guns/weapon_addtion/guns_lefthand.dmi'
	righthand_file = 'modular_z121/icons/mob/guns/weapon_addtion/guns_righthand.dmi'
	inhand_icon_state = "mining_shotgun"

	SET_BASE_PIXEL(-8, 0)

	inhand_x_dimension = 32
	inhand_y_dimension = 32
	resistance_flags = FIRE_PROOF
	weapon_weight = WEAPON_HEAVY
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/shot/mining

	can_suppress = FALSE
	fire_delay = 0.8 SECONDS
	fire_sound = 'modular_z121/sound/guns/mining_ballistic/mining_shotgun_fire.ogg'
	projectile_damage_multiplier = 0.75
	casing_ejector = TRUE
	semi_auto = TRUE

	pin = /obj/item/firing_pin/wastes

/obj/item/gun/ballistic/shotgun/mining/add_seclight_point()
	AddComponent(/datum/component/seclite_attachable, \
		starting_light = new /obj/item/flashlight/seclite(src), \
		is_light_removable = FALSE, \
	)

/obj/item/ammo_box/magazine/internal/shot/mining
	ammo_type = /obj/item/ammo_casing/shotgun/hunter
	caliber = null
	max_ammo = 8

//	十字弩
/obj/item/ammo_box/magazine/internal/boltaction/rebarxbow/crossbow
	name = "内置单发弩箭弹匣"
	max_ammo = 1
	caliber = CALIBER_REBAR
	ammo_type = /obj/item/ammo_casing/rebar/bolt

/obj/item/gun/ballistic/rifle/rebarxbow/crossbow
	name = "十字弩"
	desc = "一把采用了现代工艺的十字弩，优势在于噪音很小，但威力欠佳。"

	icon = 'modular_z121/icons/obj/guns/weapon_addtion/guns32x.dmi'
	icon_state = "crossbow"

	lefthand_file = 'modular_z121/icons/mob/guns/weapon_addtion/guns_lefthand.dmi'
	righthand_file = 'modular_z121/icons/mob/guns/weapon_addtion/guns_righthand.dmi'
	inhand_icon_state = "crossbow"

	worn_icon = 'modular_z121/icons/mob/guns/weapon_addtion/guns_worn.dmi'
	worn_icon_state = "crossbow"

	empty_indicator = FALSE

	draw_time = 2 SECONDS

	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/boltaction/rebarxbow/crossbow

/obj/projectile/bullet/rebar/bolt
	name = "钢制弩箭"

	icon = 'modular_z121/icons/obj/guns/projectiles.dmi'
	icon_state = "steel_bolt"

	//  买的东西还有概率断肢显得太弱智了
	dismemberment = 0

/obj/item/ammo_casing/rebar/bolt
	name = "钢制弩箭"
	desc = "由碳钢铸造的弩箭，可以重复使用。适用于隐蔽作战，在太空内也能保持有效杀伤。"

	icon = 'modular_z121/icons/obj/guns/ammo.dmi'
	icon_state = "steel_bolt"
	base_icon_state = "steel_bolt"

	projectile_type = /obj/projectile/bullet/rebar/bolt
