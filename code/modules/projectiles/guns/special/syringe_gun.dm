/obj/item/gun/syringe
	name = "医疗注射枪"
	desc = "一种装有弹簧的发射器，设计用于发射注射器，可以从远处让不守规矩的病人失去行动能力."
	icon = 'icons/obj/weapons/guns/syringegun.dmi'
	icon_state = "medicalsyringegun"
	lefthand_file = 'icons/mob/inhands/weapons/64x_guns_left.dmi'
	righthand_file = 'icons/mob/inhands/weapons/64x_guns_right.dmi'
	inhand_icon_state = "medicalsyringegun"
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	worn_icon_state = null
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	throw_speed = 3
	throw_range = 7
	force = 6
	base_pixel_x = -4
	pixel_x = -4
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT)
	clumsy_check = FALSE
	fire_sound = 'sound/items/syringeproj.ogg'
	can_muzzle_flash = FALSE
	gun_flags = NOT_A_REAL_GUN
	var/load_sound = 'sound/items/weapons/gun/shotgun/insert_shell.ogg'
	var/list/syringes = list()
	/// The number of syringes it can store.
	var/max_syringes = 1
	/// If it has an overlay for inserted syringes. If true, the overlay is determined by the number of syringes inserted into it.
	var/has_syringe_overlay = TRUE
	/// In low power mode syringes will instead embed and slowly inject their reagents
	var/low_power = FALSE

/obj/item/gun/syringe/Initialize(mapload)
	. = ..()
	chambered = new /obj/item/ammo_casing/syringegun(src)
	recharge_newshot()

/obj/item/gun/syringe/apply_fantasy_bonuses(bonus)
	. = ..()
	max_syringes = modify_fantasy_variable("max_syringes", max_syringes, bonus, minimum = 1)

/obj/item/gun/syringe/remove_fantasy_bonuses(bonus)
	max_syringes = reset_fantasy_variable("max_syringes", max_syringes)
	return ..()

/obj/item/gun/syringe/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone in syringes)
		syringes -= gone

/obj/item/gun/syringe/recharge_newshot()
	if(!syringes.len)
		return
	//NOVA EDIT SMARTDARTS
	if(istype(syringes[length(syringes)], /obj/item/reagent_containers/syringe/smartdart))
		chambered = new /obj/item/ammo_casing/syringegun/dart(src)
	else
		chambered = new /obj/item/ammo_casing/syringegun(src)
	//NOVA EDIT SMARTDARTS END
	chambered.newshot()
	return ..()

/obj/item/gun/syringe/can_shoot()
	return syringes.len

/obj/item/gun/syringe/handle_chamber()
	if(chambered && !chambered.loaded_projectile) //we just fired
		recharge_newshot()
	update_appearance()

/obj/item/gun/syringe/examine(mob/user)
	. = ..()
	. += span_notice("可容纳 [max_syringes] 支syringe\s 。还剩 [syringes.len] 支syringe\s 。")
	if (low_power)
		. += span_notice("其压力调节器设置为低功率模式，确保射出的注射器会嵌入目标并缓慢释放其试剂。")
	else
		. += span_notice("其压力调节器已调至最大，能瞬间注入试剂，但代价是射出的注射器会损坏。")
	. += span_notice("右键点击[src]以切换至[low_power ? "full" : "low"]功率模式。")

/obj/item/gun/syringe/attack_self(mob/living/user, list/modifiers)
	if (!syringes.len)
		balloon_alert(user, "它是空的！")
		return FALSE

	var/obj/item/reagent_containers/syringe/syringe = syringes[syringes.len]

	if (!syringe)
		return FALSE
	user.put_in_hands(syringe)

	syringes.Remove(syringe)
	balloon_alert(user, "[syringe.name]已卸下")
	update_appearance()
	return TRUE

/obj/item/gun/syringe/attack_self_secondary(mob/user, modifiers)
	. = ..()
	if (.)
		return

	low_power = !low_power
	if (low_power)
		balloon_alert(user, "已启用低功率模式")
		to_chat(user, span_notice("你小心地调低了压力调节器的设置，确保射出的注射器会嵌入目标。"))
	else
		balloon_alert(user, "已启用高功率模式")
		to_chat(user, span_notice("你将压力调节器调至最大，确保射出的注射器能瞬间注入其内容物。"))
	playsound(user, 'sound/machines/click.ogg', 75, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/gun/syringe/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/reagent_containers/syringe/bluespace))
		balloon_alert(user, "[tool.name]太大了！")
		return ITEM_INTERACT_BLOCKING

	if(!istype(tool, /obj/item/reagent_containers/syringe))
		return NONE

	if(syringes.len >= max_syringes)
		balloon_alert(user, "它已经满了！")
		return ITEM_INTERACT_BLOCKING

	if(!user.transferItemToLoc(tool, src))
		return ITEM_INTERACT_BLOCKING

	balloon_alert(user, "[tool.name]已装填")
	syringes += tool
	recharge_newshot()
	update_appearance()
	playsound(src, load_sound, 40)
	return ITEM_INTERACT_SUCCESS

/obj/item/gun/syringe/update_overlays()
	. = ..()
	if(!has_syringe_overlay)
		return
	var/syringe_count = syringes.len
	. += "[initial(icon_state)]_[syringe_count ? clamp(syringe_count, 1, initial(max_syringes)) : "empty"]"

/obj/item/gun/syringe/rapidsyringe
	name = "紧凑型快速注射枪"
	desc = "对注射枪设计的改进，使其更加紧凑，并使用旋转式圆筒来存储最多六支注射器。"
	icon_state = "rapidsyringegun"
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	inhand_icon_state = "syringegun"
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	worn_icon_state = "gun"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_BELT
	base_pixel_x = 0
	pixel_x = 0
	max_syringes = 6
	force = 4

/obj/item/gun/syringe/syndicate
	name = "注射手枪"
	desc = "一种小型弹簧加载的随身携带性武器，其功能与注射枪相同"
	icon_state = "dartsyringegun"
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	inhand_icon_state = "gun" //Smaller inhand
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	worn_icon_state = "gun"
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_BELT
	base_pixel_x = 0
	pixel_x = 0
	force = 2 //Also very weak because it's smaller
	suppressed = SUPPRESSED_QUIET //Softer fire sound
	can_unsuppress = FALSE //Permanently silenced
	syringes = list(new /obj/item/reagent_containers/syringe())

/obj/item/gun/syringe/dna
	name = "紧凑型修饰注射枪"
	desc = "一把被改进得更为紧凑的注射枪，适合装载DNA注射器而不是普通注射器."
	icon_state = "dnasyringegun"
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	inhand_icon_state = "syringegun"
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	worn_icon_state = "gun"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_BELT
	base_pixel_x = 0
	pixel_x = 0
	force = 4

/obj/item/gun/syringe/dna/Initialize(mapload)
	. = ..()
	chambered = new /obj/item/ammo_casing/dnainjector(src)

/obj/item/gun/syringe/dna/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/dnainjector))
		var/obj/item/dnainjector/D = tool
		if(D.used)
			balloon_alert(user, "[D.name]已耗尽！")
			return ITEM_INTERACT_BLOCKING
		if(syringes.len < max_syringes)
			if(!user.transferItemToLoc(D, src))
				return ITEM_INTERACT_BLOCKING
			balloon_alert(user, "[D.name]已装填")
			syringes += D
			recharge_newshot()
			update_appearance()
			playsound(loc, load_sound, 40)
			return ITEM_INTERACT_SUCCESS
		balloon_alert(user, "它已经满了！")
		return ITEM_INTERACT_BLOCKING
	return NONE

/obj/item/gun/syringe/blowgun
	name = "吹箭筒"
	desc = "在较近的距离处向目标发射注射器。"
	icon = 'icons/obj/weapons/guns/ballistic.dmi'
	icon_state = "blowgun"
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	inhand_icon_state = "blowgun"
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	worn_icon_state = "gun"
	has_syringe_overlay = FALSE
	fire_sound = 'sound/items/syringeproj.ogg'
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_BELT
	base_pixel_x = 0
	pixel_x = 0
	force = 4
	trigger_guard = TRIGGER_GUARD_ALLOW_ALL
	custom_materials = list(/datum/material/bamboo = SHEET_MATERIAL_AMOUNT * 10)
	about_to_shoot_inside_mail_text = "The air in the envelope is rushing out!"

/obj/item/gun/syringe/blowgun/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	. = ..()
	if(!.)
		return
	visible_message(span_danger("[user] 吹出了吹箭！"))
	user.adjust_stamina_loss(20, updating_stamina = FALSE)
	user.adjust_oxy_loss(20)
