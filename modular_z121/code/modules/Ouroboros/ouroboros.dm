/obj/item/gun/energy/ouroboros
	name = "SC-Ⅲ「衔尾蛇」多相能量手枪"
	desc = "一把搭载六种相位调制射击模式的实验性自充能激光手枪。"
	lore_blurb = "Allstar Lasers Inc.为索尔联邦武装部队研发的实验型高级能量手枪。作为Nanotrasen长期控制与合作的能源武器制造商，Allstar在研发过程中大量采用了NT授权的成熟技术，并以此为基础进行了整合与改进，试图打造一款能够独立于Nanotrasen之外的高端产品。<br><br>\
	然而，SC-Ⅲ的研发很快引起了Nanotrasen的注意。其涉及了大量NT技术，以及Allstar试图绕过NT、直接向索尔联邦出售武器的行为，使其遭到了NT法务与科研部门的严厉干预。随后，Allstar陷入严重的法律纠纷与技术授权封锁，项目因此陷入停滞。<br><br>\
	更耐人寻味的是，有情报指出，Cybersun Industries可能曾暗中资助SC-Ⅲ项目。作为辛迪加最大的投资公司与Nanotrasen最激烈的竞争对手，Cybersun长期试图扩大其在能源武器领域的影响力。至于这一说法是否属实，至今没有得到任何一方的正式承认。<br><br>\
	与此同时，索尔联邦武装部队更偏好成熟可靠的弹道武器，对昂贵复杂的能量武器兴趣有限。<br><br>\
	最终，SC-Ⅲ未能进入量产，仅留下少量原型机，其中绝大多数被Nanotrasen迅速回收。"
	icon = 'modular_z121/code/modules/Ouroboros/icons/ouroboros.dmi'
	icon_state = "Ouroboros"
	base_icon_state = "Ouroboros"
	lefthand_file = 'modular_z121/code/modules/Ouroboros/icons/ouroboros_lefthand.dmi'
	righthand_file = 'modular_z121/code/modules/Ouroboros/icons/ouroboros_righthand.dmi'
	inhand_icon_state = "Ouroboroskill5"
	worn_icon_state = "gun"
	cell_type = /obj/item/stock_parts/power_store/cell
	ammo_type = list(/obj/item/ammo_casing/energy/ouroboros/kill)
	can_select = FALSE
	automatic_charge_overlays = FALSE
	charge_sections = 5
	selfcharge = 1
	charge_delay = 15
	self_charge_amount = STANDARD_ENERGY_GUN_SELF_CHARGE_RATE
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_BELT
	obj_flags = UNIQUE_RENAME
	w_class = WEIGHT_CLASS_NORMAL
	weapon_weight = WEAPON_MEDIUM
	recoil = 0.2

	var/list/weapon_mode_options = list(
		/datum/ouroboros_weapon_mode/disable,
		/datum/ouroboros_weapon_mode,
		/datum/ouroboros_weapon_mode/hellfire,
		/datum/ouroboros_weapon_mode/ion,
		/datum/ouroboros_weapon_mode/stun,
		/datum/ouroboros_weapon_mode/xray,
	)
	var/list/weapon_mode_name_to_mode = list()
	var/list/radial_menu_data = list()
	var/datum/ouroboros_weapon_mode/currently_selected_mode
	var/current_mode_key = "kill"
	var/currently_switching_types = FALSE
	var/default_selected_mode = "杀伤"

/obj/item/gun/energy/ouroboros/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/manufacturer_examine, COMPANY_ALLSTAR)
	create_weapon_mode_data()
	update_appearance()

/obj/item/gun/energy/ouroboros/examine(mob/user)
	. = ..()
	if(currently_selected_mode)
		. += span_notice("当前射击模式：<b>[currently_selected_mode.name]</b>。")

/obj/item/gun/energy/ouroboros/add_seclight_point()
	AddComponent(/datum/component/seclite_attachable, \
		light_overlay_icon = 'icons/obj/weapons/guns/flashlights.dmi', \
		light_overlay = "flight", \
		overlay_x = 18, \
		overlay_y = 11)

/obj/item/gun/energy/ouroboros/proc/create_weapon_mode_data()
	if(length(weapon_mode_name_to_mode) || length(radial_menu_data))
		return
	for(var/datum/ouroboros_weapon_mode/mode_path as anything in weapon_mode_options)
		var/datum/ouroboros_weapon_mode/mode = new mode_path()
		weapon_mode_name_to_mode[mode.name] = mode
		var/obj/projectile/mode_projectile = initial(mode.casing.projectile_type)
		radial_menu_data[mode.name] = image(icon = mode_projectile.icon, icon_state = mode_projectile.icon_state)
	currently_selected_mode = weapon_mode_name_to_mode[default_selected_mode]
	currently_selected_mode.apply_to(src)

/obj/item/gun/energy/ouroboros/attack_self(mob/living/user)
	if(currently_switching_types)
		return ..()
	currently_switching_types = TRUE
	chambered = null
	show_radial_choice_menu(user)
	return ..()

/obj/item/gun/energy/ouroboros/proc/show_radial_choice_menu(mob/living/user)
	if(!user?.is_holding(src))
		currently_switching_types = FALSE
		return
	var/picked_choice = show_radial_menu(user, src, radial_menu_data, require_near = TRUE, tooltips = TRUE)
	var/datum/ouroboros_weapon_mode/new_mode = weapon_mode_name_to_mode[picked_choice]
	if(new_mode)
		new_mode.apply_to(src)
		playsound(src, fire_mode_switch_sound, 50, TRUE)
		balloon_alert(user, "设为[new_mode.name]")
	currently_switching_types = FALSE

/obj/item/gun/energy/ouroboros/can_trigger_gun(mob/living/user, akimbo_usage)
	. = ..()
	if(currently_switching_types)
		return FALSE

/obj/item/gun/energy/ouroboros/update_icon_state()
	. = ..()
	var/charge_ratio = get_charge_ratio()
	var/hand_charge_state = charge_ratio
	inhand_icon_state = "Ouroboros[current_mode_key][hand_charge_state]"
	update_inhand_icon()
	return .

/obj/item/gun/energy/ouroboros/update_overlays()
	var/list/ouroboros_overlays = list()
	if(cell)
		var/charge_ratio = get_charge_ratio()
		var/overlay_state = charge_ratio ? "Ouroboros_[current_mode_key]_[6 - charge_ratio]" : "Ouroboros_[current_mode_key]_empty"
		ouroboros_overlays += mutable_appearance(icon, overlay_state)
	. = ..()
	. = ouroboros_overlays + .

/datum/ouroboros_weapon_mode
	var/name = "杀伤"
	var/icon_key = "kill"
	var/obj/item/ammo_casing/energy/casing = /obj/item/ammo_casing/energy/ouroboros/kill
	var/fire_delay = 0.3 SECONDS
	var/recoil = 0.2

/datum/ouroboros_weapon_mode/proc/apply_to(obj/item/gun/energy/ouroboros/gun)
	if(length(gun.ammo_type))
		QDEL_LIST(gun.ammo_type)
	gun.select = 1
	gun.ammo_type = list(casing)
	gun.update_ammo_types()
	gun.currently_selected_mode = src
	gun.current_mode_key = icon_key
	gun.fire_delay = fire_delay
	gun.recoil = recoil
	gun.update_appearance()

/datum/ouroboros_weapon_mode/disable
	name = "镇爆"
	icon_key = "disable"
	casing = /obj/item/ammo_casing/energy/ouroboros/disable
	fire_delay = 0.25 SECONDS
	recoil = 0.1

/datum/ouroboros_weapon_mode/hellfire
	name = "地狱火"
	icon_key = "hellfire"
	casing = /obj/item/ammo_casing/energy/ouroboros/hellfire
	fire_delay = 0.4 SECONDS
	recoil = 0.3

/datum/ouroboros_weapon_mode/ion
	name = "离子"
	icon_key = "ion"
	casing = /obj/item/ammo_casing/energy/ouroboros/ion
	fire_delay = 0.4 SECONDS

/datum/ouroboros_weapon_mode/stun
	name = "泰瑟"
	icon_key = "stun"
	casing = /obj/item/ammo_casing/energy/ouroboros/stun
	fire_delay = 1.5 SECONDS
	recoil = 0.1

/datum/ouroboros_weapon_mode/xray
	name = "X光束"
	icon_key = "xray"
	casing = /obj/item/ammo_casing/energy/ouroboros/xray
	fire_delay = 0.4 SECONDS

/obj/item/storage/toolbox/guncase/nova/ntspecial/pistol/ouroboros
	name = "\improper Ouroboros 枪箱"
	weapon_to_spawn = /obj/item/gun/energy/ouroboros

