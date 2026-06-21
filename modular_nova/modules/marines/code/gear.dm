/obj/item/gun/ballistic/automatic/ar/modular/m44a
	name = "\improper 纳米传讯 M44A脉冲步枪"
	desc = "一款纳米传讯公司特制的弹道脉冲步枪，使用压缩弹匣，能在紧凑的枪身内输出惊人的火力。"
	icon_state = "m44a"
	inhand_icon_state = "m44a"
	icon = 'modular_nova/modules/marines/icons/m44a.dmi'
	righthand_file = 'modular_nova/modules/marines/icons/m44a_r.dmi'
	lefthand_file = 'modular_nova/modules/marines/icons/m44a_l.dmi'
	fire_sound = 'modular_nova/modules/marines/sound/m44a.ogg'
	fire_delay = 1
	burst_size = 3
	spread = 6
	pin = /obj/item/firing_pin/implant/mindshield
	can_suppress = FALSE
	mag_display = TRUE
	mag_display_ammo = FALSE
	accepted_magazine_type = /obj/item/ammo_box/magazine/m44a
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BELT

/obj/item/gun/ballistic/automatic/ar/modular/m44a/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, fire_delay)

/obj/item/gun/ballistic/automatic/ar/modular/m44a/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_NANOTRASEN)

/obj/item/ammo_box/magazine/m44a
	name = "m44a弹匣（.300压缩弹）"
	desc = "该弹匣利用蓝空压缩腔室，最多可容纳九十九发供M44A脉冲步枪使用的.300口径无壳弹。"
	icon = 'modular_nova/modules/marines/icons/m44a.dmi'
	icon_state = "300compressed"
	max_ammo = 99
	multiple_sprites = AMMO_BOX_FULL_EMPTY
	ammo_type = /obj/item/ammo_casing/c300
	caliber = "300comp"

/obj/item/ammo_casing/c300
	name = ".300无壳弹"
	desc = "一枚供纳米传讯公司专有枪械使用的.300无壳弹。"
	caliber = "300comp"
	projectile_type = /obj/projectile/bullet/a300

/obj/item/ammo_casing/c300/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/caseless)

/obj/projectile/bullet/a300
	name = ".300无壳弹头"
	damage = 13
	armour_penetration = 30 //gonna actually kill the brit that made this var require a U in armor
	embed_type = null // Oh, I love the 600 rantimes just from these things, simply because I called marines ert...
	shrapnel_type = null

/obj/item/gun/ballistic/automatic/ar/modular/m44a/scoped
	name = "\improper 纳米传讯 M44AS脉冲步枪"
	desc = "一款纳米传讯公司特制的弹道脉冲步枪，使用压缩弹匣，能在紧凑的枪身内输出惊人的火力。这把加装了远程瞄准镜。"
	icon_state = "m44a_s"
	inhand_icon_state = "m44a_s"

/obj/item/gun/ballistic/automatic/ar/modular/m44a/scoped/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/scope, range_modifier = 2.2)

/obj/item/gun/ballistic/automatic/ar/modular/m44a/shotgun
	name = "\improper 纳米传讯 M44ASG脉冲步枪"
	desc = "一款纳米传讯公司特制的弹道脉冲步枪，使用压缩弹匣，能在紧凑的枪身内输出惊人的火力。这把加装了一个两发半自动下挂式12号口径霰弹枪。"
	icon_state = "m44a_sg"
	inhand_icon_state = "m44a_sg"
	/// Reference to the underbarrel shotgun
	var/obj/item/gun/ballistic/shotgun/automatic/ubsg/underbarrel

/obj/item/gun/ballistic/automatic/ar/modular/m44a/shotgun/Initialize(mapload)
	. = ..()
	underbarrel = new /obj/item/gun/ballistic/shotgun/automatic/ubsg(src)
	update_appearance()

/obj/item/gun/ballistic/automatic/ar/modular/m44a/shotgun/Destroy()
	QDEL_NULL(underbarrel)
	return ..()

/obj/item/gun/ballistic/automatic/ar/modular/m44a/shotgun/try_fire_gun(atom/target, mob/living/user, params)
	if(LAZYACCESS(params2list(params), RIGHT_CLICK))
		return underbarrel.try_fire_gun(target, user, params)
	return ..()

/obj/item/gun/ballistic/automatic/ar/modular/m44a/shotgun/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(isammocasing(tool))
		if(istype(tool, underbarrel.magazine.ammo_type))
			underbarrel.item_interaction(user, tool, modifiers)
		return ITEM_INTERACT_BLOCKING
	return ..()

/obj/item/gun/ballistic/automatic/ar/modular/m44a/grenadelauncher
	name = "\improper 纳米传讯 M44AGL脉冲步枪"
	desc = "一款纳米传讯公司特制的弹道脉冲步枪，使用压缩弹匣，能在紧凑的枪身内输出惊人的火力。这把加装了一个下挂式榴弹发射器，以及一个用于辅助瞄准的红点镜。是在弥补什么不足吗？"
	icon_state = "m44a_gl"
	inhand_icon_state = "m44a_gl"
	/// Underbarrel grenade launcher reference
	var/obj/item/gun/ballistic/revolver/grenadelauncher/underbarrel/underbarrel

/obj/item/gun/ballistic/automatic/ar/modular/m44a/grenadelauncher/Initialize(mapload)
	. = ..()
	underbarrel = new(src)
	update_appearance()

/obj/item/gun/ballistic/automatic/ar/modular/m44a/grenadelauncher/Destroy()
	QDEL_NULL(underbarrel)
	return ..()

/obj/item/gun/ballistic/automatic/ar/modular/m44a/grenadelauncher/try_fire_gun(atom/target, mob/living/user, params)
	if(LAZYACCESS(params2list(params), RIGHT_CLICK))
		return underbarrel.try_fire_gun(target, user, params)
	return ..()

/obj/item/gun/ballistic/automatic/ar/modular/m44a/grenadelauncher/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(isammocasing(tool))
		if(istype(tool, underbarrel.magazine.ammo_type))
			underbarrel.item_interaction(user, tool, modifiers)
		return ITEM_INTERACT_BLOCKING
	return ..()

// Underbarrel shotgun

/obj/item/gun/ballistic/shotgun/automatic/ubsg
	name = "\improper M2自动霰弹枪下挂模块"
	desc = "这玩意儿不该在这儿！"
	can_suppress = FALSE
	spawn_blacklisted = TRUE
	pin = null
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/shot/ubsg

/obj/item/gun/ballistic/shotgun/automatic/ubsg/Initialize(mapload)
	. = ..()
	var/obj/item/gun/gun = loc
	if (!istype(gun))
		return INITIALIZE_HINT_QDEL
	pin = gun.pin
	RegisterSignal(gun, COMSIG_GUN_PIN_INSERTED, PROC_REF(on_pin_inserted))
	RegisterSignal(gun, COMSIG_GUN_PIN_REMOVED, PROC_REF(on_pin_removed))

/obj/item/gun/ballistic/shotgun/automatic/ubsg/give_gun_safeties()
	return

/// When inserting a pin into the gun to which we are attached, inserts the same pin into this gun
/obj/item/gun/ballistic/shotgun/automatic/ubsg/proc/on_pin_inserted(obj/item/gun/source, obj/item/firing_pin/new_pin, mob/living/user)
	SIGNAL_HANDLER
	pin = new_pin

/// When removing a pin from the gun to which we are attached, removes the pin in this gun as well
/obj/item/gun/ballistic/shotgun/automatic/ubsg/proc/on_pin_removed(obj/item/gun/source, obj/item/firing_pin/old_pin, mob/living/user)
	SIGNAL_HANDLER
	pin = null

/obj/item/ammo_box/magazine/internal/shot/ubsg
	max_ammo = 3
	ammo_type = /obj/item/ammo_casing/shotgun/buckshot
