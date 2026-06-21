/obj/item/tank/jetpack
	name = "喷气背包（氧气）"
	desc = "一个压缩气体罐，用于在零重力区域提供推进力。请谨慎使用。"
	icon_state = "jetpack"
	inhand_icon_state = "jetpack"
	lefthand_file = 'icons/mob/inhands/equipment/jetpacks_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/jetpacks_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	distribute_pressure = ONE_ATMOSPHERE * O2STANDARD
	actions_types = list(/datum/action/item_action/set_internals, /datum/action/item_action/toggle_jetpack, /datum/action/item_action/jetpack_stabilization)
	/// What gas our jetpack is filled with on initialize
	var/gas_type = /datum/gas/oxygen
	/// If the jetpack is currently active
	var/on = FALSE
	/// If the jetpack will stop when you stop moving
	var/stabilize = FALSE
	/// If the jetpack will have a speedboost in space/nograv or not
	var/full_speed = TRUE
	/// If our jetpack is disabled, from getting EMPd
	var/disabled = FALSE
	/// Callback for the jetpack component
	var/thrust_callback
	/// How much force out jetpack can output per tick
	var/drift_force = 1.5 NEWTONS

/obj/item/tank/jetpack/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob, ITEM_SLOT_SUITSTORE)
	thrust_callback = CALLBACK(src, PROC_REF(allow_thrust), 0.01)
	configure_jetpack(stabilize)

/obj/item/tank/jetpack/Destroy()
	thrust_callback = null
	return ..()

/**
 * configures/re-configures the jetpack component
 *
 * Arguments
 * stabilize - Should this jetpack be stabalized
 */
/obj/item/tank/jetpack/proc/configure_jetpack(stabilize, mob/user = null)
	src.stabilize = stabilize

	AddComponent( \
		/datum/component/jetpack, \
		src.stabilize, \
		drift_force, \
		COMSIG_JETPACK_ACTIVATED, \
		COMSIG_JETPACK_DEACTIVATED, \
		JETPACK_ACTIVATION_FAILED, \
		thrust_callback, \
		thrust_callback, \
		/datum/effect_system/trail_follow/ion, \
	)

	if (!isnull(user) && user.get_item_by_slot(slot_flags) == src)
		if (!stabilize)
			ADD_TRAIT(user, TRAIT_NOGRAV_ALWAYS_DRIFT, JETPACK_TRAIT)
		else
			REMOVE_TRAIT(user, TRAIT_NOGRAV_ALWAYS_DRIFT, JETPACK_TRAIT)

/obj/item/tank/jetpack/equipped(mob/user, slot, initial)
	. = ..()
	if(on && !(slot & slot_flags))
		turn_off(user)

/obj/item/tank/jetpack/dropped(mob/user, silent)
	. = ..()
	if(on)
		turn_off(user)

/obj/item/tank/jetpack/populate_gas()
	if(gas_type)
		var/datum/gas_mixture/our_mix = return_air()
		our_mix.set_gas(gas_type,  ((6 * ONE_ATMOSPHERE) * volume / (R_IDEAL_GAS_EQUATION * T20C)))

/obj/item/tank/jetpack/ui_action_click(mob/user, action)
	if(istype(action, /datum/action/item_action/toggle_jetpack))
		cycle(user)
	else if(istype(action, /datum/action/item_action/jetpack_stabilization))
		if(on)
			configure_jetpack(!stabilize, user)
			to_chat(user, span_notice("You turn the jetpack stabilization [stabilize ? "on" : "off"]."))
	else
		toggle_internals(user)

/obj/item/tank/jetpack/proc/cycle(mob/user)
	if(user.incapacitated)
		return

	if(!on)
		if(turn_on(user))
			to_chat(user, span_notice("你打开了喷气背包。"))
		else
			to_chat(user, span_notice("你没能启动喷气背包。"))
			return
	else
		turn_off(user)
		to_chat(user, span_notice("你关闭了喷气背包。"))

	update_item_action_buttons()

/obj/item/tank/jetpack/update_icon_state()
	. = ..()
	icon_state = "[initial(icon_state)][on ? "-on" : ""]"

/obj/item/tank/jetpack/proc/turn_on(mob/user)
	if(disabled)
		return FALSE
	if(SEND_SIGNAL(src, COMSIG_JETPACK_ACTIVATED, user) & JETPACK_ACTIVATION_FAILED)
		return FALSE
	on = TRUE
	update_icon(UPDATE_ICON_STATE)
	if(full_speed)
		user.add_movespeed_modifier(/datum/movespeed_modifier/jetpack/full_speed)
	if (!stabilize)
		ADD_TRAIT(user, TRAIT_NOGRAV_ALWAYS_DRIFT, JETPACK_TRAIT)
	return TRUE

/obj/item/tank/jetpack/proc/turn_off(mob/user)
	SEND_SIGNAL(src, COMSIG_JETPACK_DEACTIVATED, user)
	on = FALSE
	update_icon(UPDATE_ICON_STATE)
	if(user)
		user.remove_movespeed_modifier(/datum/movespeed_modifier/jetpack/full_speed)
		REMOVE_TRAIT(user, TRAIT_NOGRAV_ALWAYS_DRIFT, JETPACK_TRAIT)

/obj/item/tank/jetpack/proc/allow_thrust(num, use_fuel = TRUE)
	if(!ismob(loc))
		return FALSE
	var/mob/user = loc

	if((num < 0.005 || air_contents.total_moles() < num))
		turn_off(user)
		return FALSE

	// We've got the gas, it's chill
	if(!use_fuel)
		return TRUE

	var/datum/gas_mixture/removed = remove_air(num)
	if(removed.total_moles() < 0.005)
		turn_off(user)
		return FALSE

	var/turf/T = get_turf(src)
	T.assume_air(removed)
	return TRUE

/obj/item/tank/jetpack/suicide_act(mob/living/user)
	if (!ishuman(user))
		return
	var/mob/living/carbon/human/suffocater = user
	suffocater.say("WHAT THE FUCK IS CARBON DIOXIDE?")
	suffocater.visible_message(span_suicide("[user] 正用 [user.p_them()] 窒息 [src]自己！看起来 [user.p_they()] 没读喷气背包上的说明！"))
	return OXYLOSS

/obj/item/tank/jetpack/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_CONTENTS)
		return
	if(ismob(loc) && (item_flags & IN_INVENTORY))
		var/mob/wearer = loc
		turn_off(wearer)
	else
		turn_off()
	update_item_action_buttons()
	disabled = TRUE
	addtimer(CALLBACK(src, PROC_REF(remove_emp)), 4 SECONDS)

///Removes the disabled flag after getting EMPd
/obj/item/tank/jetpack/proc/remove_emp()
	disabled = FALSE

/obj/item/tank/jetpack/improvised
	name = "临时喷气背包"
	desc = "一个由两个气罐、一个灭火器和一些大气设备制成的喷气背包。看起来装不了多少东西。"
	icon_state = "jetpack-improvised"
	inhand_icon_state = "jetpack-improvised"
	worn_icon = null
	worn_icon_state = "jetpack-improvised"
	volume = 20 //normal jetpacks have 70 volume
	gas_type = null //it starts empty
	full_speed = FALSE
	drift_force = 1 NEWTONS
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 4.4, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 3)

/obj/item/tank/jetpack/improvised/allow_thrust(num)
	if(!ismob(loc))
		return FALSE

	var/mob/user = loc
	if(rand(0,250) == 0)
		to_chat(user, span_notice("你感觉到你的喷气背包引擎熄火了。"))
		turn_off(user)
		return
	return ..()

/obj/item/tank/jetpack/void
	name = "虚空喷气背包（氧气）"
	desc = "它在真空中运行良好。"
	icon_state = "jetpack-void"
	inhand_icon_state = "jetpack-void"

/obj/item/tank/jetpack/harness
	name = "喷射背带（氧气）"
	desc = "一种轻量级战术背带，供那些不想被传统喷气背包拖累的人使用。"
	icon_state = "jetpack-mini"
	inhand_icon_state = "jetpack-black"
	volume = 40
	throw_range = 7
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/tank/jetpack/captain
	name = "舰长的喷气背包"
	desc = "一个紧凑、轻便的喷气背包，内含大量压缩氧气。"
	icon_state = "jetpack-captain"
	inhand_icon_state = "jetpack-captain"
	w_class = WEIGHT_CLASS_NORMAL
	volume = 90
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF //steal objective items are hard to destroy.
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_SUITSTORE
	drift_force = 2 NEWTONS

/obj/item/tank/jetpack/security
	name = "安保喷气背包（氧气）"
	desc = "一个压缩氧气罐，供安保部队在零重力区域用作推进装置。"
	icon_state = "jetpack-sec"
	inhand_icon_state = "jetpack-sec"

/obj/item/tank/jetpack/carbondioxide
	name = "喷气背包（二氧化碳）"
	desc = "一个压缩二氧化碳罐，用于在零重力区域提供推进力。涂成黑色以表明不应作为内部呼吸气源使用。"
	icon_state = "jetpack-black"
	inhand_icon_state = "jetpack-black"
	distribute_pressure = 0
	gas_type = /datum/gas/carbon_dioxide
