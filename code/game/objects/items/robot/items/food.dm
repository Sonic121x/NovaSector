#define DISPENSE_LOLLIPOP_MODE 1
#define THROW_LOLLIPOP_MODE 2
#define THROW_GUMBALL_MODE 3
#define DISPENSE_ICECREAM_MODE 4

/obj/item/borg/lollipop
	name = "零食制造机"
	desc = "用各种零食奖励人类。在模块内切换以在分发和高速弹射模式之间切换。"
	icon_state = "lollipop"
	/// The current amount of available candy
	var/candy = 5
	/// The maximum amount of candy possible to hold
	var/candymax = 5
	/// Length of time it takes to regenerate a new candy
	var/charge_delay = 10 SECONDS
	/// Is the fabricator charging right now?
	var/charging = FALSE
	/// Dispensing mode
	var/mode = DISPENSE_LOLLIPOP_MODE

	/// Delay until next fire
	var/firedelay = 0
	var/hitspeed = 2

/obj/item/borg/lollipop/equipped()
	check_amount()
	return ..()

/obj/item/borg/lollipop/dropped()
	check_amount()
	return ..()

///Queues another lollipop to be fabricated if there is enough room for one
/obj/item/borg/lollipop/proc/check_amount()
	if(!charging && candy < candymax)
		addtimer(CALLBACK(src, PROC_REF(charge_lollipops)), charge_delay)
		charging = TRUE

///Increases the amount of lollipops
/obj/item/borg/lollipop/proc/charge_lollipops()
	candy++
	charging = FALSE
	check_amount()

///Dispenses a lollipop
/obj/item/borg/lollipop/proc/dispense(atom/atom_dispensed_to, mob/user)
	if(candy <= 0)
		to_chat(user, span_warning("存储中没有零食了！"))
		return FALSE
	var/turf/turf_to_dispense_to = get_turf(atom_dispensed_to)
	if(!turf_to_dispense_to || !isopenturf(turf_to_dispense_to))
		return FALSE
	if(isobj(atom_dispensed_to))
		var/obj/obj_dispensed_to = atom_dispensed_to
		if(obj_dispensed_to.density)
			return FALSE

	var/obj/item/food_item
	switch(mode)
		if(DISPENSE_LOLLIPOP_MODE)
			food_item = new /obj/item/food/lollipop/cyborg(turf_to_dispense_to)
		if(DISPENSE_ICECREAM_MODE)
			food_item = new /obj/item/food/icecream(turf_to_dispense_to, list(ICE_CREAM_VANILLA))
			food_item.desc = "吃掉这个冰淇淋。"

	var/into_hands = FALSE
	if(ismob(atom_dispensed_to))
		var/mob/mob_dispensed_to = atom_dispensed_to
		into_hands = mob_dispensed_to.put_in_hands(food_item)

	candy--
	check_amount()

	if(into_hands)
		user.visible_message(span_notice("[user] 将一份零食分发到 [atom_dispensed_to] 的手中。"), span_notice("你将一份零食分发到 [atom_dispensed_to] 的手中。"), span_hear("你听到咔哒一声。"))
	else
		user.visible_message(span_notice("[user] 分发了一份零食。"), span_notice("你分发了一份零食。"), span_hear("你听到咔哒一声。"))

	playsound(src.loc, 'sound/machines/click.ogg', 50, TRUE)
	return TRUE

/// Shoot a lollipop
/obj/item/borg/lollipop/proc/shootL(atom/target, mob/living/user, params)
	if(candy <= 0)
		to_chat(user, span_warning("剩下的棒棒糖不够了！"))
		return FALSE
	candy--

	var/obj/item/ammo_casing/lollipop/lollipop
	var/mob/living/silicon/robot/robot_user = user
	if(istype(robot_user) && robot_user.emagged)
		lollipop = new /obj/item/ammo_casing/lollipop/harmful(src)
	else
		lollipop = new /obj/item/ammo_casing/lollipop(src)

	playsound(src.loc, 'sound/machines/click.ogg', 50, TRUE)
	lollipop.fire_casing(target, user, params, 0, 0, null, 0, src)
	user.visible_message(span_warning("[user] 向 [target] 发射了一根飞行的棒棒糖！"))
	check_amount()

/// Shoot a gumball
/obj/item/borg/lollipop/proc/shootG(atom/target, mob/living/user, params)
	if(candy <= 0)
		to_chat(user, span_warning("剩下的口香糖球不够了！"))
		return FALSE
	candy--
	var/obj/item/ammo_casing/gumball/gumball
	var/mob/living/silicon/robot/robot_user = user
	if(istype(robot_user) && robot_user.emagged)
		gumball = new /obj/item/ammo_casing/gumball/harmful(src)
	else
		gumball = new /obj/item/ammo_casing/gumball(src)

	gumball.loaded_projectile.color = rgb(rand(0, 255), rand(0, 255), rand(0, 255))
	playsound(src.loc, 'sound/items/weapons/bulletflyby3.ogg', 50, TRUE)
	gumball.fire_casing(target, user, params, 0, 0, null, 0, src)
	user.visible_message(span_warning("[user]向[target]射出了一颗高速口香糖球！"))
	check_amount()

/obj/item/borg/lollipop/ranged_interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	check_amount()
	if(iscyborg(user))
		var/mob/living/silicon/robot/robot_user = user
		if(!robot_user.cell?.use(0.012 * STANDARD_CELL_CHARGE))
			to_chat(user, span_warning("能量不足。"))
			return ITEM_INTERACT_BLOCKING

	switch(mode)
		if(THROW_LOLLIPOP_MODE)
			shootL(interacting_with, user, list2params(modifiers))
			return ITEM_INTERACT_SUCCESS

		if(THROW_GUMBALL_MODE)
			shootG(interacting_with, user, list2params(modifiers))
			return ITEM_INTERACT_SUCCESS

	return NONE

/obj/item/borg/lollipop/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	check_amount()
	if(iscyborg(user))
		var/mob/living/silicon/robot/robot_user = user
		if(!robot_user.cell?.use(0.012 * STANDARD_CELL_CHARGE))
			to_chat(user, span_warning("能量不足。"))
			return ITEM_INTERACT_BLOCKING

	switch(mode)
		if(DISPENSE_LOLLIPOP_MODE, DISPENSE_ICECREAM_MODE)
			dispense(interacting_with, user)
			return ITEM_INTERACT_SUCCESS

	return NONE

/obj/item/borg/lollipop/attack_self(mob/living/user)
	switch_mode(user)
	return ..()

/obj/item/borg/lollipop/proc/switch_mode(mob/living/user)
	switch(mode)
		if(DISPENSE_LOLLIPOP_MODE)
			mode = THROW_LOLLIPOP_MODE
			to_chat(user, span_notice("模块现在改为投掷棒棒糖。"))
		if(THROW_LOLLIPOP_MODE)
			mode = THROW_GUMBALL_MODE
			to_chat(user, span_notice("模块现在改为发射口香糖球。"))
		if(THROW_GUMBALL_MODE)
			mode = DISPENSE_ICECREAM_MODE
			to_chat(user, span_notice("模块现在改为分发冰淇淋。"))
		if(DISPENSE_ICECREAM_MODE)
			mode = DISPENSE_LOLLIPOP_MODE
			to_chat(user, span_notice("模块现在改为分发棒棒糖。"))

/obj/item/borg/lollipop/ice_cream
	name = "冰淇淋制造机"
	desc = "用香草冰淇淋奖励人类。这总不会错。"
	candy = 4
	candymax = 4
	charge_delay = 15 SECONDS
	mode = DISPENSE_ICECREAM_MODE

/obj/item/borg/lollipop/ice_cream/switch_mode(mob/living/user)
	return

/obj/item/ammo_casing/gumball
	name = "口香糖球"
	desc = "你怎么会看到这个？！"
	projectile_type = /obj/projectile/bullet/gumball
	click_cooldown_override = 2

/obj/item/ammo_casing/gumball/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/caseless)

/obj/item/ammo_casing/gumball/harmful
	projectile_type = /obj/projectile/bullet/gumball/harmful

/obj/projectile/bullet/gumball
	name = "口香糖球"
	desc = "哦不！一颗高速飞行的口香糖球！"
	icon_state = "gumball"
	damage = 0
	speed = 2
	embed_type = null

/obj/projectile/bullet/gumball/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/projectile_drop, /obj/item/food/gumball)
	RegisterSignal(src, COMSIG_PROJECTILE_ON_SPAWN_DROP, PROC_REF(handle_drop))

/obj/projectile/bullet/gumball/harmful
	damage = 10

/obj/projectile/bullet/gumball/proc/handle_drop(datum/source, obj/item/food/gumball/gumball)
	SIGNAL_HANDLER
	gumball.color = color

/obj/item/ammo_casing/lollipop //NEEDS RANDOMIZED COLOR LOGIC.
	name = "棒棒糖"
	desc = "你怎么会看到这个？！"
	projectile_type = /obj/projectile/bullet/lollipop
	click_cooldown_override = 2

/obj/item/ammo_casing/lollipop/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/caseless)

/obj/item/ammo_casing/lollipop/harmful
	projectile_type = /obj/projectile/bullet/lollipop/harmful

/obj/projectile/bullet/lollipop
	name = "棒棒糖"
	desc = "哦不！一根高速飞行的棒棒糖！"
	icon_state = "lollipop_1"
	damage = 0
	speed = 2
	embed_type = null
	var/head_color

/obj/projectile/bullet/lollipop/harmful
	embed_type = /datum/embedding/lollipop
	damage = 10
	shrapnel_type = /obj/item/food/lollipop/cyborg
	embed_falloff_tile = 0

/datum/embedding/lollipop
	embed_chance = 35
	fall_chance = 2
	jostle_chance = 0
	ignore_throwspeed_threshold = TRUE
	pain_stam_pct = 0.5
	pain_mult = 3
	rip_time = 1 SECONDS

/obj/projectile/bullet/lollipop/Initialize(mapload)
	. = ..()
	var/mutable_appearance/head = mutable_appearance('icons/obj/weapons/guns/projectiles.dmi', "lollipop_2")
	head.color = head_color = rgb(rand(0, 255), rand(0, 255), rand(0, 255))
	add_overlay(head)
	if(!embed_type)
		AddElement(/datum/element/projectile_drop, /obj/item/food/lollipop/cyborg)
	RegisterSignals(src, list(COMSIG_PROJECTILE_ON_SPAWN_DROP, COMSIG_PROJECTILE_ON_SPAWN_EMBEDDED), PROC_REF(handle_drop))

/obj/projectile/bullet/lollipop/proc/handle_drop(datum/source, obj/item/food/lollipop/lollipop)
	SIGNAL_HANDLER
	lollipop.change_head_color(head_color)

#undef DISPENSE_LOLLIPOP_MODE
#undef THROW_LOLLIPOP_MODE
#undef THROW_GUMBALL_MODE
#undef DISPENSE_ICECREAM_MODE

/obj/item/borg/cookbook
	name = "机械美食法典"
	desc = "这是一本机器人烹饪书！"
	icon = 'icons/obj/service/library.dmi'
	icon_state = "cooked_book"
	item_flags = NOBLUDGEON
	var/datum/component/personal_crafting/cooking

/obj/item/borg/cookbook/Initialize(mapload)
	. = ..()
	cooking = AddComponent(/datum/component/personal_crafting)
	cooking.forced_mode = TRUE
	cooking.mode = TRUE

/obj/item/borg/cookbook/attack_self(mob/user, modifiers)
	. = ..()
	cooking.ui_interact(user)

/obj/item/borg/cookbook/dropped(mob/user, silent)
	SStgui.close_uis(cooking)
	return ..()
