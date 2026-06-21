//Hydroponics tank and base code
/obj/item/watertank
	name = "背包式水箱"
	desc = "一个S.U.N.S.H.I.N.E.品牌的水箱背包，带有用于浇灌植物的喷嘴。"
	icon = 'icons/obj/service/hydroponics/equipment.dmi'
	icon_state = "waterbackpack"
	inhand_icon_state = "waterbackpack"
	lefthand_file = 'icons/mob/inhands/equipment/backpack_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/backpack_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	slowdown = 1
	actions_types = list(/datum/action/item_action/toggle_mister)
	max_integrity = 200
	armor_type = /datum/armor/item_watertank
	resistance_flags = FIRE_PROOF
	interaction_flags_mouse_drop = ALLOW_RESTING

	var/obj/item/noz
	var/volume = 500

/datum/armor/item_watertank
	fire = 100
	acid = 30

/obj/item/watertank/Initialize(mapload)
	. = ..()
	create_reagents(volume, OPENCONTAINER)
	noz = make_noz()
	RegisterSignal(noz, COMSIG_MOVABLE_MOVED, PROC_REF(noz_move))
	AddElement(/datum/element/drag_pickup)

/obj/item/watertank/Destroy()
	QDEL_NULL(noz)
	return ..()


/obj/item/watertank/ui_action_click(mob/user)
	toggle_mister(user)

/obj/item/watertank/proc/toggle_mister(mob/living/user)
	if(!istype(user))
		return
	if(user.get_item_by_slot(user.getBackSlot()) != src)
		to_chat(user, span_warning("必须正确穿戴水箱才能使用！"))
		return
	if(user.incapacitated)
		return

	if(QDELETED(noz))
		noz = make_noz()
		RegisterSignal(noz, COMSIG_MOVABLE_MOVED, PROC_REF(noz_move))
	if(noz in src)
		//Detach the nozzle into the user's hands
		if(!user.put_in_hands(noz))
			to_chat(user, span_warning("你需要一只空手来握住喷雾器！"))
			return
	else
		//Remove from their hands and put back "into" the tank
		remove_noz()

/obj/item/watertank/verb/toggle_mister_verb()
	set name = "Toggle Mister"
	toggle_mister(usr)

/obj/item/watertank/proc/make_noz()
	return new /obj/item/reagent_containers/spray/mister(src)

/obj/item/watertank/proc/noz_move(atom/movable/mover, atom/oldloc, direction)
	if(mover.loc == src || mover.loc == loc)
		return
	balloon_alert(loc, "喷嘴弹回")
	mover.forceMove(src)

/obj/item/watertank/equipped(mob/user, slot)
	..()
	if(!(slot & ITEM_SLOT_BACK))
		remove_noz()

/obj/item/watertank/proc/remove_noz()
	if(!QDELETED(noz))
		if(ismob(noz.loc))
			var/mob/M = noz.loc
			M.temporarilyRemoveItemFromInventory(noz, TRUE)
		noz.forceMove(src)

/obj/item/watertank/attack_hand(mob/user, list/modifiers)
	if (user.get_item_by_slot(user.getBackSlot()) == src)
		toggle_mister(user)
	else
		return ..()

/obj/item/watertank/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers)
	if(attacking_item == noz)
		remove_noz()
		return TRUE
	else
		return ..()

/obj/item/watertank/dropped(mob/user)
	..()
	remove_noz()

// This mister item is intended as an extension of the watertank and always attached to it.
// Therefore, it's designed to be "locked" to the player's hands or extended back onto
// the watertank backpack. Allowing it to be placed elsewhere or created without a parent
// watertank object will likely lead to weird behaviour or runtimes.
/obj/item/reagent_containers/spray/mister
	name = "水雾喷雾器"
	desc = "一个连接到水箱的喷雾喷嘴。"
	icon = 'icons/obj/service/hydroponics/equipment.dmi'
	icon_state = "mister"
	inhand_icon_state = "mister"
	lefthand_file = 'icons/mob/inhands/equipment/mister_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/mister_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	amount_per_transfer_from_this = 50
	possible_transfer_amounts = list(50)
	can_toggle_range = FALSE
	volume = 500
	item_flags = NOBLUDGEON | ABSTRACT  // don't put in storage
	slot_flags = NONE

/obj/item/reagent_containers/spray/mister/Initialize(mapload)
	. = ..()
	if(!loc?.reagents)
		return INITIALIZE_HINT_QDEL
	reagents = loc.reagents //This mister is really just a proxy for the tank's reagents

/obj/item/reagent_containers/spray/mister/try_spray(atom/target, mob/user)
	if(target.loc == loc) //Safety check so you don't fill your mister with mutagen or something and then blast yourself in the face with it
		return FALSE
	return ..()

//Janitor tank
/obj/item/watertank/janitor
	name = "背包式清洁剂箱"
	desc = "一个带有喷嘴的清洁工清洁背包，用于清洁血迹和涂鸦。"
	icon_state = "waterbackpackjani"
	inhand_icon_state = "waterbackpackjani"
	custom_price = PAYCHECK_CREW * 5

/obj/item/watertank/janitor/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/space_cleaner, 500)

/obj/item/reagent_containers/spray/mister/janitor
	name = "清洁工喷雾喷嘴"
	desc = "一个连接到水箱的清洁工喷雾喷嘴，设计用于清理大面积污渍。"
	icon = 'icons/obj/service/hydroponics/equipment.dmi'
	icon_state = "misterjani"
	inhand_icon_state = "misterjani"
	lefthand_file = 'icons/mob/inhands/equipment/mister_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/mister_righthand.dmi'
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5, 10)
	current_range = 5

/obj/item/watertank/janitor/make_noz()
	return new /obj/item/reagent_containers/spray/mister/janitor(src)

/obj/item/reagent_containers/spray/mister/janitor/mode_change_message(mob/user)
	to_chat(user, span_notice("你[amount_per_transfer_from_this == 10 ? "remove" : "affix"]了喷嘴。现在每次喷射将使用[amount_per_transfer_from_this]单位。"))

//Security tank
/obj/item/watertank/pepperspray
	name = "ANTI-TIDER-2500镇压背包"
	desc = "终极人群控制设备；此工具允许使用者快速有效地制服成群的敌对目标。"
	icon = 'icons/obj/service/hydroponics/equipment.dmi'
	icon_state = "pepperbackpacksec"
	inhand_icon_state = "pepperbackpacksec"
	custom_price = PAYCHECK_CREW * 2
	volume = 1000

/obj/item/watertank/pepperspray/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/consumable/condensedcapsaicin, 1000)

/obj/item/reagent_containers/spray/mister/pepperspray
	name = "安保喷雾喷嘴"
	desc = "一个连接到辣椒喷雾罐的镇静喷雾喷嘴，设计用于让嫌犯闭嘴。"
	icon = 'icons/obj/service/hydroponics/equipment.dmi'
	icon_state = "mistersec"
	inhand_icon_state = "mistersec"
	lefthand_file = 'icons/mob/inhands/equipment/mister_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/mister_righthand.dmi'
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5, 10)
	current_range = 6

/obj/item/watertank/pepperspray/make_noz()
	return new /obj/item/reagent_containers/spray/mister/pepperspray(src)

/obj/item/reagent_containers/spray/mister/pepperspray/mode_change_message(mob/user)
	to_chat(user, span_notice("你[amount_per_transfer_from_this == 10 ? "remove" : "affix"]了喷嘴。现在每次喷射将使用[amount_per_transfer_from_this]单位。"))

//ATMOS FIRE FIGHTING BACKPACK
/obj/item/watertank/atmos
	name = "背包式消防水箱"
	desc = "一个冷藏加压的背包水箱，配有灭火喷嘴，用于扑灭火灾。可在灭火器、树脂发射器和较小规模的树脂泡沫发生器之间切换。"
	inhand_icon_state = "waterbackpackatmos"
	icon_state = "waterbackpackatmos"
	worn_icon_state = "waterbackpackatmos"
	volume = 200
	slowdown = 0

/obj/item/watertank/atmos/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/water, 200)

/obj/item/watertank/atmos/make_noz()
	return new /obj/item/extinguisher/mini/nozzle(src)

/obj/item/watertank/atmos/dropped(mob/user)
	..()
	icon_state = "waterbackpackatmos"
	if(istype(noz, /obj/item/extinguisher/mini/nozzle))
		var/obj/item/extinguisher/mini/nozzle/N = noz
		N.nozzle_mode = 0

/obj/item/extinguisher/mini/nozzle
	name = "灭火器喷嘴"
	desc = "连接到消防员背包水箱的重型喷嘴。"
	icon = 'icons/obj/service/hydroponics/equipment.dmi'
	icon_state = "atmos_nozzle"
	inhand_icon_state = "nozzleatmos"
	lefthand_file = 'icons/mob/inhands/equipment/mister_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/mister_righthand.dmi'
	safety = 0
	max_water = 200
	power = 8
	force = 10
	precision = 1
	cooling_power = 5
	w_class = WEIGHT_CLASS_HUGE
	item_flags = ABSTRACT  // don't put in storage
	chem = null //holds no chems of its own, it takes from the tank.
	var/obj/item/tank
	var/nozzle_mode = 0
	var/metal_synthesis_cooldown = 0
	COOLDOWN_DECLARE(resin_cooldown)

/obj/item/extinguisher/mini/nozzle/Initialize(mapload)
	. = ..()
	tank = loc
	if (!tank?.reagents)
		return INITIALIZE_HINT_QDEL
	reagents = tank.reagents
	max_water = tank.reagents.maximum_volume


/obj/item/extinguisher/mini/nozzle/Destroy()
	reagents = null //This is a borrowed reference from the tank.
	tank = null
	return ..()

/obj/item/extinguisher/mini/nozzle/attack_self(mob/user)
	var/uses_pack = istype(tank, /obj/item/watertank/atmos)
	switch(nozzle_mode)
		if(EXTINGUISHER)
			nozzle_mode = RESIN_LAUNCHER
			if(uses_pack)
				tank.icon_state = "waterbackpackatmos_1"
			balloon_alert(user, "已切换至树脂发射器")
			return
		if(RESIN_LAUNCHER)
			nozzle_mode = RESIN_FOAM
			if(uses_pack)
				tank.icon_state = "waterbackpackatmos_2"
			balloon_alert(user, "已切换至树脂泡沫")
			return
		if(RESIN_FOAM)
			nozzle_mode = EXTINGUISHER
			if(uses_pack)
				tank.icon_state = "waterbackpackatmos_0"
			balloon_alert(user, "切换为灭火器")
			return
	return

/obj/item/extinguisher/mini/nozzle/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(AttemptRefill(interacting_with, user))
		return NONE
	return ..()

/obj/item/extinguisher/mini/nozzle/ranged_interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(nozzle_mode == EXTINGUISHER)
		return ..()

	var/Adj = user.Adjacent(interacting_with)
	if(nozzle_mode == RESIN_LAUNCHER)
		if(Adj && user.combat_mode)
			return ITEM_INTERACT_SKIP_TO_ATTACK
		var/datum/reagents/R = reagents
		if(R.total_volume < 100)
			balloon_alert(user, "水量不足！")
			return ITEM_INTERACT_BLOCKING
		if(!COOLDOWN_FINISHED(src, resin_cooldown))
			balloon_alert(user, "仍在充能中！")
			return ITEM_INTERACT_BLOCKING
		COOLDOWN_START(src, resin_cooldown, 10 SECONDS)
		R.remove_all(100)
		var/obj/effect/resin_container/resin = new (get_turf(src))
		user.log_message("used Resin Launcher", LOG_GAME)
		playsound(src,'sound/items/syringeproj.ogg',40,TRUE)
		var/delay = 2
		var/datum/move_loop/loop = GLOB.move_manager.move_towards(resin, interacting_with, delay, timeout = delay * 5, priority = MOVEMENT_ABOVE_SPACE_PRIORITY)
		RegisterSignal(loop, COMSIG_MOVELOOP_POSTPROCESS, PROC_REF(resin_stop_check))
		RegisterSignal(loop, COMSIG_QDELETING, PROC_REF(resin_landed))
		return ITEM_INTERACT_SUCCESS

	if(nozzle_mode == RESIN_FOAM)
		if(!isturf(interacting_with))
			return NONE
		if(!Adj)
			balloon_alert(user, "太远了！")
			return ITEM_INTERACT_BLOCKING
		for(var/thing in interacting_with)
			if(istype(thing, /obj/effect/particle_effect/fluid/foam/metal/resin) || istype(thing, /obj/structure/foamedmetal/resin))
				balloon_alert(user, "已有树脂！")
				return ITEM_INTERACT_BLOCKING
		if(metal_synthesis_cooldown < 5)
			var/obj/effect/particle_effect/fluid/foam/metal/resin/foam = new (get_turf(interacting_with))
			foam.group.target_size = 0
			metal_synthesis_cooldown++
			addtimer(CALLBACK(src, PROC_REF(reduce_metal_synth_cooldown)), 10 SECONDS)
			return ITEM_INTERACT_SUCCESS

		balloon_alert(user, "仍在合成中！")
		return ITEM_INTERACT_BLOCKING

	return NONE

/obj/item/extinguisher/mini/nozzle/proc/resin_stop_check(datum/move_loop/source, result)
	SIGNAL_HANDLER
	if(result == MOVELOOP_SUCCESS)
		return
	resin_landed(source)
	qdel(source)

/obj/item/extinguisher/mini/nozzle/proc/resin_landed(datum/move_loop/source)
	SIGNAL_HANDLER
	if(!istype(source.moving, /obj/effect/resin_container) || QDELETED(source.moving))
		return
	var/obj/effect/resin_container/resin = source.moving
	resin.Smoke()

/obj/item/extinguisher/mini/nozzle/proc/reduce_metal_synth_cooldown()
	metal_synthesis_cooldown--

/obj/effect/resin_container
	name = "树脂容器"
	desc = "一个压缩的膨胀树脂球，用于修复房间大气或密封破口。"
	icon = 'icons/effects/effects.dmi'
	icon_state = "frozen_smoke_capsule"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	pass_flags = PASSTABLE
	anchored = TRUE

/obj/effect/resin_container/proc/Smoke()
	do_foam(4, src, loc, foam_type = /datum/effect_system/fluid_spread/foam/metal/resin)
	playsound(src,'sound/effects/bamf.ogg',100,TRUE)
	qdel(src)

// Please don't spacedrift thanks
/obj/effect/resin_container/newtonian_move(inertia_angle, instant = FALSE, start_delay = 0, drift_force = 0, controlled_cap = null)
	return TRUE

#undef EXTINGUISHER
#undef RESIN_LAUNCHER
#undef RESIN_FOAM

/obj/item/reagent_containers/chemtank
	name = "背包式化学注射器"
	desc = "一种可以背在背上的化学自动注射器。"
	icon = 'icons/obj/service/hydroponics/equipment.dmi'
	icon_state = "waterbackpackchem"
	inhand_icon_state = "waterbackpackchem"
	lefthand_file = 'icons/mob/inhands/equipment/backpack_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/backpack_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	slowdown = 1
	actions_types = list(/datum/action/item_action/activate_injector)

	var/on = FALSE
	volume = 300
	var/usage_ratio = 5 //5 unit added per 1 removed
	/// How much to inject per second
	var/injection_amount = 0.5
	amount_per_transfer_from_this = 5
	initial_reagent_flags = TRANSPARENT
	possible_transfer_amounts = list(5,10,15)
	fill_icon_thresholds = list(0, 15, 60)
	fill_icon_state = "backpack"

/obj/item/reagent_containers/chemtank/ui_action_click()
	toggle_injection()

/obj/item/reagent_containers/chemtank/proc/toggle_injection()
	var/mob/living/carbon/human/user = usr
	if(!istype(user))
		return
	if (user.get_item_by_slot(ITEM_SLOT_BACK) != src)
		to_chat(user, span_warning("化学背包需要背在背上才能激活！"))
		return
	if(on)
		turn_off()
	else
		turn_on()

//Todo : cache these.
/obj/item/reagent_containers/chemtank/worn_overlays(mutable_appearance/standing, isinhands = FALSE) //apply chemcolor and level
	. = ..()
	//inhands + reagent_filling
	if(isinhands || !reagents.total_volume)
		return

	var/mutable_appearance/filling = mutable_appearance('icons/obj/medical/reagent_fillings.dmi', "backpackmob-10")
	var/percent = round((reagents.total_volume / volume) * 100)
	switch(percent)
		if(0 to 15)
			filling.icon_state = "backpackmob-10"
		if(16 to 60)
			filling.icon_state = "backpackmob50"
		if(61 to INFINITY)
			filling.icon_state = "backpackmob100"

	filling.color = mix_color_from_reagents(reagents.reagent_list)
	. += filling

/obj/item/reagent_containers/chemtank/proc/turn_on()
	on = TRUE
	START_PROCESSING(SSobj, src)
	if(ismob(loc))
		to_chat(loc, span_notice("[src] 已启动。"))

/obj/item/reagent_containers/chemtank/proc/turn_off()
	on = FALSE
	STOP_PROCESSING(SSobj, src)
	if(ismob(loc))
		to_chat(loc, span_notice("[src] 已关闭。"))

/obj/item/reagent_containers/chemtank/process(seconds_per_tick)
	if(!ishuman(loc))
		turn_off()
		return
	if(!reagents.total_volume)
		turn_off()
		return
	var/mob/living/carbon/human/user = loc
	if(user.back != src)
		turn_off()
		return

	var/inj_am = injection_amount * seconds_per_tick
	var/used_amount = inj_am / usage_ratio
	reagents.trans_to(user, used_amount, usage_ratio, methods = INJECT)
	update_appearance()
	user.update_worn_back() //for overlays update

/datum/action/item_action/activate_injector
	name = "激活注射器"
