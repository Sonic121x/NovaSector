
/obj/machinery/food_cart
	name = "餐车"
	desc = "一款小巧便携且可拆卸的移动烹饪架。哇！打开包装后，你会觉得它很像那些在 NTNet 上网的人所使用的那种油腻的电脑游戏配置设备。"
	icon = 'icons/obj/service/kitchen.dmi'
	icon_state = "foodcart"
	density = TRUE
	anchored = FALSE
	use_power = NO_POWER_USE
	req_access = list(ACCESS_KITCHEN)
	obj_flags = parent_type::obj_flags | NO_DEBRIS_AFTER_DECONSTRUCTION
	var/unpacked = FALSE
	var/obj/machinery/griddle/stand/cart_griddle
	var/obj/machinery/smartfridge/food/cart_smartfridge
	var/obj/structure/table/reinforced/cart_table
	var/obj/effect/food_cart_stand/cart_tent
	var/list/packed_things

/obj/machinery/food_cart/Initialize(mapload)
	. = ..()
	cart_griddle = new(src)
	cart_smartfridge = new(src)
	cart_table = new(src)
	cart_tent = new(src)
	packed_things = list(cart_table, cart_smartfridge, cart_tent, cart_griddle) //middle, left, left, right
	RegisterSignal(cart_griddle, COMSIG_QDELETING, PROC_REF(lost_part))
	RegisterSignal(cart_smartfridge, COMSIG_QDELETING, PROC_REF(lost_part))
	RegisterSignal(cart_table, COMSIG_QDELETING, PROC_REF(lost_part))
	RegisterSignal(cart_tent, COMSIG_QDELETING, PROC_REF(lost_part))

/obj/machinery/food_cart/Destroy()
	if(cart_griddle)
		QDEL_NULL(cart_griddle)
	if(cart_smartfridge)
		QDEL_NULL(cart_smartfridge)
	if(cart_table)
		QDEL_NULL(cart_table)
	if(cart_tent)
		QDEL_NULL(cart_tent)
	packed_things.Cut()
	return ..()

/obj/machinery/food_cart/examine(mob/user)
	. = ..()
	if(!(machine_stat & BROKEN))
		if(cart_griddle.machine_stat & BROKEN)
			. += span_warning("摊位的<b>烤盘</b>完全坏了！")
		else
			. += span_notice("摊位的<b>烤盘</b>完好无损。")
		. += span_notice("The stand's <b>fridge</b> seems fine.") //weirdly enough, these fridges don't break
		. += span_notice("摊位的<b>桌子</b>看起来没问题。")

/obj/machinery/food_cart/proc/pack_up()
	if(!unpacked)
		return
	visible_message(span_notice("[src]收回了所有展开的组件。"))
	for(var/o in packed_things)
		var/obj/object = o
		UnregisterSignal(object, COMSIG_MOVABLE_MOVED)
		object.forceMove(src)
	set_anchored(FALSE)
	unpacked = FALSE

/obj/machinery/food_cart/proc/unpack(mob/user)
	if(unpacked)
		return
	if(!check_setup_place())
		to_chat(user, span_warning("这里没有足够的空间展开！无效空间已用红色标记。"))
		return
	visible_message(span_notice("[src] 展开成了一个完整的摊位。"))
	set_anchored(TRUE)
	var/iteration = 1
	var/turf/grabbed_turf = get_step(get_turf(src), EAST)
	for(var/angle in list(0, -45, -45, 45))
		var/turf/T = get_step(grabbed_turf, turn(SOUTH, angle))
		var/obj/thing = packed_things[iteration]
		thing.forceMove(T)
		RegisterSignal(thing, COMSIG_MOVABLE_MOVED, PROC_REF(lost_part))
		iteration++
	unpacked = TRUE

/obj/machinery/food_cart/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(machine_stat & BROKEN)
		to_chat(user, span_warning("[src] 完全坏掉了。"))
		return
	var/obj/item/card/id/id_card = user.get_idcard(hand_first = TRUE)
	if(!check_access(id_card))
		playsound(src, 'sound/machines/buzz/buzz-sigh.ogg', 30, TRUE)
		return
	to_chat(user, span_notice("你试图[unpacked ? "pack up" :"unpack"][src]..."))
	if(!do_after(user, 5 SECONDS, src))
		to_chat(user, span_warning("你[unpacked ? "" :"un"]打包[src]的过程被打断了！"))
		return
	if(unpacked)
		pack_up()
	else
		unpack(user)

/obj/machinery/food_cart/proc/check_setup_place()
	var/has_space = TRUE
	var/turf/grabbed_turf = get_step(get_turf(src), EAST)
	for(var/angle in list(0, -45, 45))
		var/turf/T = get_step(grabbed_turf, turn(SOUTH, angle))
		if(T && !T.density)
			new /obj/effect/temp_visual/cart_space(T)
		else
			has_space = FALSE
			new /obj/effect/temp_visual/cart_space/bad(T)
	return has_space

/obj/machinery/food_cart/proc/lost_part(atom/movable/source, force)
	SIGNAL_HANDLER

	//okay, so it's deleting the fridge or griddle which are more important. We're gonna break the machine then
	UnregisterSignal(cart_griddle, list(COMSIG_QDELETING, COMSIG_MOVABLE_MOVED))
	UnregisterSignal(cart_smartfridge, list(COMSIG_QDELETING, COMSIG_MOVABLE_MOVED))
	UnregisterSignal(cart_table, list(COMSIG_QDELETING, COMSIG_MOVABLE_MOVED))
	UnregisterSignal(cart_tent, list(COMSIG_QDELETING, COMSIG_MOVABLE_MOVED))
	atom_break()

/obj/machinery/food_cart/atom_break(damage_flag)
	. = ..()
	pack_up()
	if(!QDELETED(cart_griddle))
		QDEL_NULL(cart_griddle)
	if(!QDELETED(cart_smartfridge))
		QDEL_NULL(cart_smartfridge)
	if(!QDELETED(cart_table))
		QDEL_NULL(cart_table)
	if(!QDELETED(cart_tent))
		QDEL_NULL(cart_tent)

/obj/effect/food_cart_stand
	name = "餐车帐篷"
	desc = "需要一些东西来抵御阳光的侵袭，因为那些汉堡摊主可没有休息的机会。"
	icon = 'icons/obj/fluff/3x3.dmi'
	icon_state = "stand"
	layer = ABOVE_MOB_LAYER//big mobs will still go over the tent, this is fine and cool
