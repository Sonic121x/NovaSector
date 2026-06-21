#define pet_carrier_full(carrier) carrier.occupants.len >= carrier.max_occupants || carrier.occupant_weight >= carrier.max_occupant_weight

//Used to transport little animals without having to drag them across the station.
//Comes with a handy lock to prevent them from running off.
/obj/item/pet_carrier
	name = "宠物运输箱"
	desc = "一个蓝白相间的大号宠物运输箱。很适合用来运送<s>给厨师的肉</s>可爱的小动物。"
	icon = 'icons/map_icons/items/_item.dmi'
	icon_state = "/obj/item/pet_carrier"
	post_init_icon_state = "pet_carrier_open"
	base_icon_state = "pet_carrier"
	inhand_icon_state = "pet_carrier"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	greyscale_config = /datum/greyscale_config/pet_carrier
	greyscale_config_inhand_left = /datum/greyscale_config/pet_carrier_inhands_left
	greyscale_config_inhand_right = /datum/greyscale_config/pet_carrier_inhands_right
	greyscale_colors = COLOR_BLUE
	force = 5
	attack_verb_continuous = list("bashes", "carries")
	attack_verb_simple = list("bash", "carry")
	w_class = WEIGHT_CLASS_BULKY
	throw_speed = 2
	throw_range = 3
	custom_materials = list(/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT * 7.5, /datum/material/glass = SMALL_MATERIAL_AMOUNT)
	interaction_flags_mouse_drop = NEED_DEXTERITY
	/// Is the pet carrier open? Allows you to collect/remove pets.
	var/open = TRUE
	/// Does this carrier allow locking? Disabled for the small pet carrier.
	var/allows_locking = TRUE
	/// Is this carrier locked? Locks don't require access, just an alt click.
	var/locked = FALSE
	/// List of all mob occupants from inside of the pet carrier.
	var/list/occupants = list()
	/// Combined weight of all mob occupants based on the MOB_SIZE_ defines.
	var/occupant_weight = 0
	/// Maximum number of mobs that can fit in a pet carrier, so you can't have infinite mice or something in one carrier
	var/max_occupants = 3
	/// Maximum weight of a mob that can be carried. This is calculated from the mob sizes of occupants
	var/max_occupant_weight = MOB_SIZE_SMALL

	/// Sound played when the mob carrier is opened.
	var/open_sound = 'sound/items/handling/cardboard_box/cardboard_box_rustle.ogg'
	/// Sound played when the mob carrier is closed.
	var/close_sound = 'sound/items/handling/cardboard_box/cardboardbox_drop.ogg'

/obj/item/pet_carrier/Initialize(mapload)
	. = ..()
	register_context()
	AddElement(/datum/element/cuffable_item)

/obj/item/pet_carrier/Destroy()
	if(occupants.len)
		for(var/V in occupants)
			remove_occupant(V)
	return ..()

/obj/item/pet_carrier/Exited(atom/movable/gone, direction)
	. = ..()
	if(isliving(gone) && (gone in occupants))
		var/mob/living/living_gone = gone
		occupants -= gone
		occupant_weight -= living_gone.mob_size

/obj/item/pet_carrier/examine(mob/user)
	. = ..()
	if(occupants.len)
		for(var/V in occupants)
			var/mob/living/L = V
			. += span_notice("里面装着[L]。")
	else
		. += span_notice("里面是空的。")

	// At some point these need to be converted to contextual screentips
	. += span_notice("在手中激活以 [open ? "close" : "open"] 它的门。点击拖动到地板上以释放其内的生物。")
	if(!open && allows_locking)
		. += span_notice("Alt+点击来[locked ? "unlock" : "lock"]它的门。")

/obj/item/pet_carrier/attack_self(mob/living/user)
	if(open)
		to_chat(user, span_notice("你关上了[src]的门。"))
		playsound(user, close_sound, 50, TRUE)
		open = FALSE
	else
		if(locked)
			to_chat(user, span_warning("[src]被锁住了！"))
			return
		to_chat(user, span_notice("你打开[src]的门."))
		playsound(user, open_sound, 50, TRUE)
		open = TRUE
	update_appearance()

/obj/item/pet_carrier/click_alt(mob/living/user)
	if(open || !allows_locking)
		return CLICK_ACTION_BLOCKING
	locked = !locked
	to_chat(user, span_notice("你将锁扣开关拨到了[locked ? "down" : "up"]。"))
	if(locked)
		playsound(user, 'sound/machines/airlock/boltsdown.ogg', 30, TRUE)
	else
		playsound(user, 'sound/machines/airlock/boltsup.ogg', 30, TRUE)
	update_appearance()
	return CLICK_ACTION_SUCCESS

/obj/item/pet_carrier/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(user.combat_mode || !isliving(interacting_with))
		return NONE
	if(!open)
		to_chat(user, span_warning("你需要先打开[src]的门！"))
		return ITEM_INTERACT_BLOCKING
	var/mob/living/target = interacting_with
	if(target.mob_size > max_occupant_weight)
		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			if(isfeline(H)) // NOVA EDIT - FELINE TRAITS. Was: isfelinid(H)
				to_chat(user, span_warning("你需要很多猫薄荷和零食，或许再加个激光笔，才能让它乖乖进去。"))
			else
				to_chat(user, span_warning("人类，一般来说，是塞不进宠物运输箱的。"))
		else
			to_chat(user, span_warning("你觉得[target]并不适合放进[name]里。"))
		return ITEM_INTERACT_BLOCKING
	if(user == target)
		to_chat(user, span_warning("你为什么要这么做？"))
		return ITEM_INTERACT_BLOCKING
	load_occupant(user, target)
	return ITEM_INTERACT_SUCCESS

/obj/item/pet_carrier/relaymove(mob/living/user, direction)
	if(open)
		loc.visible_message(span_notice("[user]从[src]里爬了出来！"), \
		span_warning("[user]从[src]里跳了出来！"))
		remove_occupant(user)
		return
	else if(!locked)
		loc.visible_message(span_notice("[user]推开了[src]的门！"), \
		span_warning("[user]推开了[src]的门！"))
		open = TRUE
		update_appearance()
		return
	else if(user.client)
		container_resist_act(user)

/obj/item/pet_carrier/container_resist_act(mob/living/user)
	user.changeNext_move(CLICK_CD_BREAKOUT)
	user.last_special = world.time + CLICK_CD_BREAKOUT
	if(user.mob_size <= MOB_SIZE_SMALL)
		to_chat(user, span_notice("你将肢体探出[src]的栅栏，开始摸索锁扣开关...（这需要一些时间。）"))
		to_chat(loc, span_warning("你看见[user]从栅栏间伸出手，摸索着锁扣开关！"))
		if(!do_after(user, rand(300, 400), target = user) || open || !locked || !(user in occupants))
			return
		loc.visible_message(span_warning("[user]伸手从栅栏间拨动了[src]的锁扣开关！"), null, null, null, user)
		to_chat(user, span_bolddanger("搞定！锁扣弹开了！"))
		locked = FALSE
		playsound(src, 'sound/machines/airlock/boltsup.ogg', 30, TRUE)
		update_appearance()
	else
		loc.visible_message(span_warning("[src]开始晃动，有什么东西在推门！"), null, null, null, user)
		to_chat(user, span_notice("你开始从[src]里往外挤...（这大约需要20秒。）"))
		if(!do_after(user, 20 SECONDS, target = user) || open || !locked || !(user in occupants))
			return
		loc.visible_message(span_warning("[user]从[src]里挤了出来！"), null, null, null, user)
		to_chat(user, span_notice("你用力顶开[src]的门，挣脱了锁扣的束缚，摔了出来！"))
		locked = FALSE
		open = TRUE
		update_appearance()
		remove_occupant(user)

/obj/item/pet_carrier/update_icon_state()
	if(open)
		icon_state = "[base_icon_state]_open"
		return ..()
	icon_state = "[base_icon_state]_[!occupants.len ? "closed" : "occupied"]_[locked ? "locked" : "unlocked"]"
	return ..()

/obj/item/pet_carrier/mouse_drop_dragged(atom/over_atom, mob/user, src_location, over_location, params)
	if(isopenturf(over_atom) && open && occupants.len)
		user.visible_message(span_notice("[user]卸下了[src]。"), \
		span_notice("你将[src]卸到了[over_atom]上。"))
		for(var/V in occupants)
			remove_occupant(V, over_atom)

/obj/item/pet_carrier/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()

	if(!locked)
		context[SCREENTIP_CONTEXT_LMB] = open ? "Close door" : "Open door"
		return TRUE
	if(allows_locking)
		context[SCREENTIP_CONTEXT_ALT_LMB] = locked ? "Unlock door" : "Lock door"
		return  TRUE

/obj/item/pet_carrier/proc/load_occupant(mob/living/user, mob/living/target)
	if(pet_carrier_full(src))
		to_chat(user, span_warning("[src]已经装得太满了！"))
		return
	user.visible_message(span_notice("[user]开始将[target]装进[src]。"), \
	span_notice("你开始将[target]装进[src]..."), null, null, target)
	to_chat(target, span_userdanger("[user]开始把你装进[user.p_their()]的[name]里！"))
	if(!do_after(user, 3 SECONDS, target))
		return
	if(target in occupants)
		return
	if(pet_carrier_full(src)) //Run the checks again, just in case
		to_chat(user, span_warning("[src]已经装得太满了！"))
		return
	user.visible_message(span_notice("[user]把[target]装进了[src]！"), \
	span_notice("你将[target]装进了[src]。"), null, null, target)
	to_chat(target, span_userdanger("[user]将你装进了[user.p_their()]的[name]里！"))
	add_occupant(target)

/obj/item/pet_carrier/proc/add_occupant(mob/living/occupant)
	if((occupant in occupants) || !istype(occupant))
		return
	occupant.forceMove(src)
	occupants += occupant
	occupant_weight += occupant.mob_size

/obj/item/pet_carrier/proc/remove_occupant(mob/living/occupant, turf/new_turf)
	if(!(occupant in occupants) || !istype(occupant))
		return
	occupant.forceMove(new_turf ? new_turf : drop_location())
	occupants -= occupant
	occupant_weight -= occupant.mob_size
	occupant.setDir(SOUTH)

/obj/item/pet_carrier/biopod
	name = "生物舱"
	desc = "用于不明目的的外星装置。或者用来装宠物。"
	icon = 'icons/obj/pet_carrier.dmi'
	icon_state = "biopod_open"
	post_init_icon_state = null
	base_icon_state = "biopod"
	inhand_icon_state = "biopod"
	greyscale_config = null
	greyscale_config_inhand_left = null
	greyscale_config_inhand_right = null
	greyscale_colors = null

/obj/item/pet_carrier/small
	name = "小型宠物笼"
	desc = "一个用于微型尺寸动物的小型宠物笼。"
	icon = 'icons/obj/pet_carrier.dmi'
	icon_state = "small_carrier_open"
	post_init_icon_state = null
	w_class = WEIGHT_CLASS_NORMAL
	base_icon_state = "small_carrier"
	inhand_icon_state = "syringe_kit"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	greyscale_config = null
	greyscale_config_inhand_left = null
	greyscale_config_inhand_right = null
	greyscale_colors = null

	max_occupants = 1
	allows_locking = FALSE

/obj/item/pet_carrier/small/mouse
	name = "小型老鼠笼"
	desc = "一个用于微型尺寸动物的小型宠物笼。这个看起来是为老鼠准备的。"
	icon_state = "small_carrier_occupied_unlocked"
	open = FALSE

/obj/item/pet_carrier/small/mouse/Initialize(mapload)
	var/mob/living/basic/mouse/hero_mouse = new /mob/living/basic/mouse(src)
	add_occupant(hero_mouse) //mouse hero
	return ..()

#undef pet_carrier_full
