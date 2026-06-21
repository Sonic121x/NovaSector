
/// Fire all loaded contents at once.
#define PCANNON_FIREALL 1
/// First in, Last out.
#define PCANNON_FILO 2
/// First in, first out. Default value.
#define PCANNON_FIFO 3

///Defines for the pressure strength of the cannon
#define LOW_PRESSURE 1
#define MID_PRESSURE 2
#define HIGH_PRESSURE 3

/obj/item/pneumatic_cannon
	name = "气动炮"
	desc = "一种气体动力炮，可以发射装入其中的任何物体。"
	w_class = WEIGHT_CLASS_BULKY
	force = 8 //Very heavy
	attack_verb_continuous = list("bludgeons", "smashes", "beats")
	attack_verb_simple = list("bludgeon", "smash", "beat")
	icon = 'icons/obj/weapons/pneumaticCannon.dmi'
	icon_state = "pneumaticCannon"
	inhand_icon_state = "bulldog"
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	armor_type = /datum/armor/item_pneumatic_cannon
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 6)
	/// The max weight of items that can fit into the cannon
	var/maxWeightClass = 20
	/// The weight of items currently in the cannon
	var/loadedWeightClass = 0
	/// The gas tank that is drawn from to fire things
	var/obj/item/tank/internals/tank = null
	/// How much gas is drawn from a tank's pressure to fire
	var/gasPerThrow = 3
	/// The items loaded into the cannon that will be fired out
	var/list/loadedItems = list()
	/// How powerful the cannon is - higher pressure = more gas but more powerful throws
	var/pressure_setting = LOW_PRESSURE
	/// Additional multiplier that adjusts how much farther thrown objects can travel.
	var/range_multiplier = 1
	/// How many items to throw per fire
	var/throw_amount = 1
	/// What methodology should be used when firing? See #defines at top of file.
	var/fire_mode = PCANNON_FIFO
	/// Allows you to hold down LMB to continuously fire.
	var/automatic = FALSE
	/// Determines if a pneumatic cannon needs an air tank to fire. False for things like the pie cannons.
	var/needs_air = TRUE
	/// If true, has side effects if fired with the clumsy trait (read: clowns)
	var/clumsyCheck = TRUE
	///Leave as null to allow all. Otherwise whitelists what can be inserted into the cannon.
	var/list/allowed_typecache
	var/charge_amount = 1
	var/charge_ticks = 1
	var/charge_tick = 0
	var/atom/charge_type
	var/selfcharge = FALSE
	var/fire_sound = 'sound/items/weapons/sonic_jackhammer.ogg'
	///Do the projectiles spin when launched?
	var/spin_item = TRUE
	trigger_guard = TRIGGER_GUARD_NORMAL


/datum/armor/item_pneumatic_cannon
	fire = 60
	acid = 50

/obj/item/pneumatic_cannon/Initialize(mapload)
	. = ..()
	if(selfcharge)
		init_charge()

/obj/item/pneumatic_cannon/proc/init_charge() //wrapper so it can be vv'd easier
	START_PROCESSING(SSobj, src)

/obj/item/pneumatic_cannon/process()
	charge_tick++
	if(charge_tick >= charge_ticks && charge_type)
		fill_with_type(charge_type, charge_amount)

/obj/item/pneumatic_cannon/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/pneumatic_cannon/CanItemAutoclick()
	return automatic

/obj/item/pneumatic_cannon/proc/pressure_setting_to_text(pressure_setting)
	switch(pressure_setting)
		if(LOW_PRESSURE)
			return "low"
		if(MID_PRESSURE)
			return "medium"
		if(HIGH_PRESSURE)
			return "high"
		else
			CRASH("Invalid pressure setting: [pressure_setting]!")

/obj/item/pneumatic_cannon/examine(mob/user)
	. = ..()
	var/list/out = list()
	if(!in_range(user, src))
		out += span_notice("你需要靠近些才能看到更多信息。")
		return
	if(selfcharge)
		if(length(loadedItems))
			out += span_info("[icon2html(pick(loadedItems), user)] It has [length(loadedItems)] [charge_type::name] loaded.")
	else
		for(var/obj/item/I in loadedItems)
			out += span_info("[icon2html(I, user)] 它已装填了\a [I]。")
			CHECK_TICK
	if(!length(loadedItems))
		out += span_info("The chamber has nothing loaded.")
	if(tank)
		out += span_notice("[icon2html(tank, user)] It has \a [tank] mounted onto it. It could be removed with a <b>screwdriver</b>.")
	if(needs_air == TRUE)
		. += span_notice("使用<b>扳手</b>来改变压力等级。当前输出等级为<b>[pressure_setting_to_text(pressure_setting)]</b>。")
	. += out.Join("\n")

/obj/item/pneumatic_cannon/screwdriver_act(mob/living/user, obj/item/tool)
	if(tank)
		tool.play_tool_sound(src)
		updateTank(tank, 1, user)
	return TRUE

/obj/item/pneumatic_cannon/wrench_act(mob/living/user, obj/item/tool)
	if(needs_air == FALSE)
		return
	playsound(src, 'sound/items/tools/ratchet.ogg', 50, TRUE)
	pressure_setting = pressure_setting >= HIGH_PRESSURE ? LOW_PRESSURE : pressure_setting + 1
	balloon_alert(user, "输出等级设置为[pressure_setting_to_text(pressure_setting)]")
	return TRUE

/obj/item/pneumatic_cannon/attackby(obj/item/W, mob/living/user, list/modifiers, list/attack_modifiers)
	if(user.combat_mode)
		return ..()
	if(istype(W, /obj/item/tank/internals))
		if(needs_air == FALSE)
			return
		if(!tank)
			var/obj/item/tank/internals/IT = W
			if(IT.volume <= 3)
				to_chat(user, span_warning("\The [IT] 对于\the [src]来说太小了。"))
				return
			updateTank(W, 0, user)
	else if(W.type == type)
		to_chat(user, span_warning("你相当确定把一个气动炮放进另一个气动炮里会引起时空紊乱。"))
	else if(loadedWeightClass >= maxWeightClass)
		to_chat(user, span_warning("\The [src] 装不下更多物品了！"))
	else if(isitem(W))
		var/obj/item/IW = W
		load_item(IW, user)

/obj/item/pneumatic_cannon/proc/can_load_item(obj/item/I, mob/user)
	if(!istype(I)) //Players can't load non items, this allows for admin varedit inserts.
		return TRUE
	if(allowed_typecache && !is_type_in_typecache(I, allowed_typecache))
		if(user)
			to_chat(user, span_warning("[I] 无法装入 [src]！"))
		return
	if((loadedWeightClass + I.w_class) > maxWeightClass) //Only make messages if there's a user
		if(user)
			to_chat(user, span_warning("\The [I] 无法装入 \the [src]！"))
		return FALSE
	if(I.w_class > w_class)
		if(user)
			to_chat(user, span_warning("\The [I] 太大了，无法装入 \the [src]！"))
		return FALSE
	return TRUE

/obj/item/pneumatic_cannon/proc/load_item(obj/item/I, mob/user)
	if(!can_load_item(I, user))
		return FALSE
	if(user) //Only use transfer proc if there's a user, otherwise just set loc.
		if(!user.transferItemToLoc(I, src))
			return FALSE
		to_chat(user, span_notice("你将 \the [I] 装入了 \the [src]。"))
	else
		I.forceMove(src)
	loadedItems += I
	if(isitem(I))
		loadedWeightClass += I.w_class
	else
		loadedWeightClass++
	return TRUE

/obj/item/pneumatic_cannon/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(user.combat_mode)
		return ITEM_INTERACT_SKIP_TO_ATTACK
	if(!pre_fire(user, interacting_with))
		return NONE
	Fire(user, interacting_with)
	return ITEM_INTERACT_SUCCESS

/obj/item/pneumatic_cannon/ranged_interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	Fire(user, interacting_with)
	return ITEM_INTERACT_SUCCESS

/** Checks */
/obj/item/pneumatic_cannon/proc/pre_fire(mob/living/user, atom/target)
	if(user.Adjacent(target))
		if(target in user.contents)
			return FALSE
		if(!ismob(target))
			return FALSE
	return TRUE

/obj/item/pneumatic_cannon/proc/Fire(mob/living/user, atom/target)
	if(!istype(user) && !target)
		return
	var/discharge = 0
	if(!can_trigger_gun(user))
		return
	if(!loadedItems || !loadedWeightClass)
		to_chat(user, span_warning("\The [src] 没有装载任何物品。"))
		return
	if(!tank && needs_air)
		to_chat(user, span_warning("\The [src] 没有气源无法发射。"))
		return
	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, span_warning("You can't bring yourself to fire \the [src]! You don't want to risk harming anyone...") )
		return
	if(tank && !tank.remove_air(gasPerThrow * pressure_setting))
		to_chat(user, span_warning("\The [src] 发出一声微弱的气流声，没有反应！"))
		return
	if(HAS_TRAIT(user, TRAIT_CLUMSY) && prob(75) && clumsyCheck && iscarbon(user))
		var/mob/living/carbon/C = user
		C.visible_message(span_warning("[C] 失去了[C.p_their()]对 [src] 的抓握，导致它走火了！"), span_userdanger("[src] 从你手中滑脱并走火了！"))
		C.dropItemToGround(src, TRUE)
		if(prob(10))
			target = get_turf(user)
		else
			var/list/possible_targets = range(3,src)
			target = pick(possible_targets)
		discharge = 1
	if(!discharge)
		user.visible_message(span_danger("[user] 发射了 \the [src]！"), \
				    		 span_danger("你发射了 \the [src]！"))
	log_combat(user, target, "fired at", src)
	var/turf/T = get_target(target, get_turf(src))
	playsound(src, fire_sound, 50, TRUE)
	fire_items(T, user)
	if(pressure_setting >= 3 && iscarbon(user))
		var/mob/living/carbon/C = user
		C.visible_message(span_warning("[C] 被大炮的力量掀翻在地！"), span_userdanger("[src] 猛撞在你的肩膀上，把你击倒了！"))
		C.Paralyze(60)

/obj/item/pneumatic_cannon/proc/fire_items(turf/target, mob/user)
	if(fire_mode == PCANNON_FIREALL)
		for(var/obj/item/ITD in loadedItems) //Item To Discharge
			if(!throw_item(target, ITD, user))
				break
	else
		for(var/i in 1 to throw_amount)
			if(!loadedItems.len)
				break
			var/atom/movable/I
			if(fire_mode == PCANNON_FILO)
				I = loadedItems[loadedItems.len]
			else
				I = loadedItems[1]
			if(!throw_item(target, I, user))
				break

/obj/item/pneumatic_cannon/proc/throw_item(turf/target, atom/movable/AM, mob/user)
	if(!istype(AM))
		return FALSE
	loadedItems -= AM
	if(isitem(AM))
		var/obj/item/I = AM
		loadedWeightClass -= I.w_class
	else
		loadedWeightClass--
	AM.forceMove(get_turf(src))
	AM.throw_at(target, pressure_setting * 10 * range_multiplier, pressure_setting * 2, user, spin_item)
	return TRUE

/obj/item/pneumatic_cannon/proc/get_target(turf/target, turf/starting)
	if(range_multiplier == 1)
		return target
	var/x_o = (target.x - starting.x)
	var/y_o = (target.y - starting.y)
	var/new_x = clamp((starting.x + (x_o * range_multiplier)), 0, world.maxx)
	var/new_y = clamp((starting.y + (y_o * range_multiplier)), 0, world.maxy)
	var/turf/newtarget = locate(new_x, new_y, starting.z)
	return newtarget

/obj/item/pneumatic_cannon/Exited(atom/movable/gone, direction)
	. = ..()
	if(loadedItems.Remove(gone))
		var/obj/item/item = gone
		if(istype(item))
			loadedWeightClass -= item.w_class
		else
			loadedWeightClass--
	else if (gone == tank)
		tank = null
		update_appearance()

/obj/item/pneumatic_cannon/ghetto //Obtainable by improvised methods; more gas per use, less capacity
	name = "简易气动炮"
	desc = "一个由常见零件制成的、以气体为动力、可发射物体的炮。"
	force = 5
	maxWeightClass = 10
	gasPerThrow = 5

/obj/item/pneumatic_cannon/proc/updateTank(obj/item/tank/internals/thetank, removing = 0, mob/living/carbon/human/user)
	if(removing)
		if(!tank)
			return
		to_chat(user, span_notice("你将 \the [thetank] 从 \the [src] 上拆下。"))
		tank.forceMove(user.drop_location())
		user.put_in_hands(tank)
		tank = null
	if(!removing)
		if(tank)
			to_chat(user, span_warning("\The [src] 已经有一个气罐了。"))
			return
		if(!user.transferItemToLoc(thetank, src))
			return
		to_chat(user, span_notice("你将 \the [thetank] 连接到 \the [src] 上。"))
		tank = thetank
	update_appearance()

/obj/item/pneumatic_cannon/update_overlays()
	. = ..()
	if(!tank)
		return
	. += tank.icon_state

/obj/item/pneumatic_cannon/proc/fill_with_type(type, amount)
	if(!ispath(type, /obj) && !ispath(type, /mob))
		return FALSE
	var/loaded = 0
	for(var/i in 1 to amount)
		var/obj/item/I = new type
		if(!load_item(I, null))
			qdel(I)
			return loaded
		loaded++
		CHECK_TICK

/obj/item/pneumatic_cannon/pie
	name = "派炮"
	desc = "装载奶油派以获得最佳效果。"
	force = 10
	icon_state = "piecannon"
	gasPerThrow = 0
	range_multiplier = 3
	throw_amount = 1
	maxWeightClass = (/obj/item/food/pie::w_class * 50) //50 pies. :^)
	needs_air = FALSE
	clumsyCheck = FALSE
	var/static/list/pie_typecache = typecacheof(/obj/item/food/pie)

/obj/item/pneumatic_cannon/pie/Initialize(mapload)
	. = ..()
	allowed_typecache = pie_typecache

/obj/item/pneumatic_cannon/pie/selfcharge
	automatic = TRUE
	selfcharge = TRUE
	charge_type = /obj/item/food/pie/cream
	maxWeightClass = (/obj/item/food/pie::w_class * 20) //20 pies.

/obj/item/pneumatic_cannon/pie/selfcharge/cyborg
	name = "低速派炮"
	automatic = FALSE
	charge_type = /obj/item/food/pie/cream/nostun
	maxWeightClass = (/obj/item/food/pie::w_class * 2) //2 pies
	charge_ticks = 2 //4 second/pie

#undef PCANNON_FIREALL
#undef PCANNON_FILO
#undef PCANNON_FIFO
#undef LOW_PRESSURE
#undef MID_PRESSURE
#undef HIGH_PRESSURE
