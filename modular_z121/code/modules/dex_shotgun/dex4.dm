/obj/item/gun/ballistic/shotgun/dex4
	name = "DEX-4 智能霰弹枪"
	desc = "这是把实验性半自动霰弹枪，刚上市不久。采用了电磁加速技术，能将各种霰弹给予足以穿透护甲动能"
	icon = 'modular_z121/icons/obj/guns/dex4.dmi'
	icon_state = "dex4"
	inhand_icon_state = "dex4"
	lefthand_file = 'modular_z121/icons/mob/guns/dex4_lefthand.dmi'
	righthand_file = 'modular_z121/icons/mob/guns/dex4_righthand.dmi'
	worn_icon = 'modular_z121/icons/mob/guns/dex4_worn.dmi'
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
	fire_delay = 0.8 SECONDS

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
	icon = 'modular_z121/icons/obj/guns/dex4_mag.dmi'
	icon_state = "magazine"
	base_icon_state = "magazine"
	multiple_sprites = AMMO_BOX_FULL_EMPTY
	ammo_type = /obj/item/ammo_casing/shotgun
	caliber = CALIBER_SHOTGUN
	max_ammo = 8

/obj/item/ammo_box/magazine/dex4/starts_empty
	start_empty = TRUE
