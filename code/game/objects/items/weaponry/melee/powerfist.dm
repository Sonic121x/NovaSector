// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
///Defines for the pressure strength of the fist
#define LOW_PRESSURE 1
#define MID_PRESSURE 2
#define HIGH_PRESSURE 3
///Defines for the tank change action
#define TANK_INSERTING 0
#define TANK_REMOVING 1

/obj/item/melee/powerfist
	name = "power-fist"
	desc = "A metal gauntlet with a piston-powered ram on top for that extra 'oomph' in your punch."
	icon = 'icons/obj/antags/syndicate_tools.dmi'
	icon_state = "powerfist"
	inhand_icon_state = "powerfist"
	icon_angle = 180
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	obj_flags = CONDUCTS_ELECTRICITY
	attack_verb_continuous = list("whacks", "fists", "power-punches")
	attack_verb_simple = list("whack", "fist", "power-punch")
	force = 20
	throwforce = 10
	throw_range = 7
	w_class = WEIGHT_CLASS_NORMAL
	armor_type = /datum/armor/melee_powerfist
	resistance_flags = FIRE_PROOF
	/// Delay between attacks
	var/click_delay = 0.15 SECONDS
	/// Pressure level on the fist
	var/fist_pressure_setting = LOW_PRESSURE
	/// Amount of moles per punch
	var/gas_per_fist = 3
	/// Tank used for the gauntlet's piston-ram.
	var/obj/item/tank/internals/tank

/datum/armor/melee_powerfist
	fire = 100
	acid = 40

/obj/item/melee/powerfist/proc/pressure_setting_to_text(fist_pressure_setting)
	switch(fist_pressure_setting)
		if(LOW_PRESSURE)
			return "low"
		if(MID_PRESSURE)
			return "medium"
		if(HIGH_PRESSURE)
			return "high"
		else
			CRASH("Invalid pressure setting: [fist_pressure_setting]!")

/obj/item/melee/powerfist/examine(mob/user)
	. = ..()
	if(!in_range(user, src))
		. += span_notice(LANG("obj.019d2a69da853da8", null))
		return
	if(tank)
		. += span_notice(LANG("obj.42dd9fda5dedb634", list(icon2html(tank, user), tank)))
		. += span_notice(LANG("obj.db598e2ec773ebb9", null))

	. += span_notice(LANG("obj.ffe2641afb5e74a5", list(pressure_setting_to_text(fist_pressure_setting))))

/obj/item/melee/powerfist/wrench_act(mob/living/user, obj/item/tool)
	fist_pressure_setting = fist_pressure_setting >= HIGH_PRESSURE ? LOW_PRESSURE : fist_pressure_setting + 1
	tool.play_tool_sound(src)
	balloon_alert(user, LANG("obj.d1a5a78cab68fe74", list(pressure_setting_to_text(fist_pressure_setting))))
	return TRUE

/obj/item/melee/powerfist/screwdriver_act(mob/living/user, obj/item/tool)
	if(!tank)
		balloon_alert(user, LANG("obj.c78df2ef788d35ec", null))
		return
	update_tank(tank, TANK_REMOVING, user)
	return TRUE

/obj/item/melee/powerfist/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/tank/internals))
		return NONE

	if(tank)
		to_chat(user, span_notice(LANG("obj.a5df63a84c3a569f", null)))
		return ITEM_INTERACT_BLOCKING

	if(astype(tool, /obj/item/tank/internals).volume <= 3)
		to_chat(user, span_warning(LANG("obj.a09c595106b1ac72", list(tool, src))))
		return ITEM_INTERACT_BLOCKING

	update_tank(tool, TANK_INSERTING, user)
	return ITEM_INTERACT_SUCCESS

/obj/item/melee/powerfist/proc/update_tank(obj/item/tank/internals/the_tank, removing = TANK_INSERTING, mob/living/carbon/human/user)
	if(removing)
		if(!tank)
			to_chat(user, span_notice(LANG("obj.96a0bfe8e5bf4fbf", list(src))))
			return
		to_chat(user, span_notice(LANG("obj.870413e7cda9a700", list(the_tank, src))))
		tank.forceMove(get_turf(user))
		user.put_in_hands(tank)
		tank = null
		return

	if(tank)
		to_chat(user, span_warning(LANG("obj.a5a5404f96390518", list(src))))
		return
	if(!user.transferItemToLoc(the_tank, src))
		return
	to_chat(user, span_notice(LANG("obj.08206c7e1040abca", list(the_tank, src))))
	tank = the_tank

/obj/item/melee/powerfist/attack(mob/living/target, mob/living/user)
	if(!tank)
		to_chat(user, span_warning(LANG("obj.239e4ee8c2a22d2a", list(src))))
		return
	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, span_warning(LANG("obj.c2a13fcc69a895f5", null)))
		return
	var/turf/our_turf = get_turf(src)
	if(!our_turf)
		return

	var/datum/gas_mixture/gas_used = tank.remove_air(gas_per_fist * fist_pressure_setting)
	if(!gas_used)
		to_chat(user, span_warning(LANG("obj.470967648afaaf2d", list(src))))
		target.apply_damage((force / 5), BRUTE)
		playsound(loc, 'sound/items/weapons/punch1.ogg', 50, TRUE)
		target.visible_message(span_danger(LANG("obj.9d61b1eae896b01a", list(user, user.p_they(), user.p_es(), target.name))), \
			span_userdanger(LANG("obj.6d49be37518ff190", list(user))))
		return

	if(!molar_cmp_equals(gas_used.total_moles(), gas_per_fist * fist_pressure_setting))
		our_turf.assume_air(gas_used)
		to_chat(user, span_warning(LANG("obj.bef15588b2444e41", list(src))))
		playsound(loc, 'sound/items/weapons/punch4.ogg', 50, TRUE)
		target.apply_damage((force / 2), BRUTE)
		target.visible_message(span_danger(LANG("obj.56f3c2a5b762723c", list(user, user.p_they(), user.p_es(), target.name))), \
			span_userdanger(LANG("obj.cdc29886ba1aeb17", list(user))))
		return

	target.visible_message(span_danger(LANG("obj.9e5479375d42bb0c", list(user, user.p_they(), user.p_es(), target.name))), \
		span_userdanger(LANG("obj.10e0ad1cbea2f035", list(user))))
	new /obj/effect/temp_visual/kinetic_blast(target.loc)
	target.apply_damage(force * fist_pressure_setting, BRUTE, wound_bonus = CANT_WOUND)
	playsound(src, 'sound/items/weapons/resonator_blast.ogg', 50, TRUE)
	playsound(src, 'sound/items/weapons/genhit2.ogg', 50, TRUE)

	if(!QDELETED(target))
		var/atom/throw_target = get_edge_target_turf(target, get_dir(src, get_step_away(target, src)))

		target.throw_at(throw_target, 5 * fist_pressure_setting, 0.5 + (fist_pressure_setting / 2))

	log_combat(user, target, "power fisted", src)

	user.changeNext_move(CLICK_CD_MELEE * click_delay)

	our_turf.assume_air(gas_used)

#undef LOW_PRESSURE
#undef MID_PRESSURE
#undef HIGH_PRESSURE
#undef TANK_INSERTING
#undef TANK_REMOVING
