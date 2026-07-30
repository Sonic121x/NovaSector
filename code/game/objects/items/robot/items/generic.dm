// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
#define HUG_MODE_NICE 0
#define HUG_MODE_HUG 1
#define HUG_MODE_SHOCK 2
#define HUG_MODE_CRUSH 3

#define HUG_SHOCK_COOLDOWN (2 SECONDS)
#define HUG_CRUSH_COOLDOWN (1 SECONDS)

#define HARM_ALARM_NO_SAFETY_COOLDOWN (60 SECONDS)
#define HARM_ALARM_SAFETY_COOLDOWN (20 SECONDS)

/obj/item/borg
	icon = 'icons/mob/silicon/robot_items.dmi'
	abstract_type = /obj/item/borg

/// Cost to use the stun arm
#define CYBORG_STUN_CHARGE_COST (0.2 * STANDARD_CELL_CHARGE)

/obj/item/borg/stun
	name = "electrically-charged arm"
	icon_state = "elecarm"
	var/stamina_damage = 60 //Same as normal batong
	var/cooldown_check = 0
	/// cooldown between attacks
	var/cooldown = 4 SECONDS // same as baton

/obj/item/borg/stun/attack(mob/living/attacked_mob, mob/living/user)
	if(cooldown_check > world.time)
		user.balloon_alert(user, LANG("obj.26defd6f", null))
		return
	if(ishuman(attacked_mob))
		var/mob/living/carbon/human/human = attacked_mob
		if(human.check_block(src, 0, "[attacked_mob]'s [name]", MELEE_ATTACK))
			playsound(attacked_mob, 'sound/items/weapons/genhit.ogg', 50, TRUE)
			return FALSE
	if(iscyborg(user))
		var/mob/living/silicon/robot/robot_user = user
		if(!robot_user.cell.use(CYBORG_STUN_CHARGE_COST))
			return

	user.do_attack_animation(attacked_mob)
	attacked_mob.adjust_stamina_loss(stamina_damage)
	attacked_mob.set_confusion_if_lower(5 SECONDS)
	attacked_mob.adjust_stutter(20 SECONDS)
	attacked_mob.set_jitter_if_lower(5 SECONDS)
	if(issilicon(attacked_mob))
		attacked_mob.emp_act(EMP_HEAVY)
		attacked_mob.visible_message(
			span_danger(LANG("obj.d656a7da", list(user, attacked_mob, src))),
			span_userdanger(LANG("obj.f3d4edd4", list(user, src))),
		)
	else
		attacked_mob.visible_message(
			span_danger(LANG("obj.238f0c6a", list(user, attacked_mob, src))),
			span_userdanger(LANG("obj.6825a6bb", list(user, src))),
		)

	SEND_SIGNAL(attacked_mob, COMSIG_LIVING_MINOR_SHOCK) // NOVA EDIT ADDITION
	playsound(loc, 'sound/items/weapons/egloves.ogg', 50, TRUE, -1)
	cooldown_check = world.time + cooldown
	log_combat(user, attacked_mob, "stunned", src, "(Combat mode: [user.combat_mode ? "On" : "Off"])")

#undef CYBORG_STUN_CHARGE_COST

/obj/item/borg/cyborghug
	name = "hugging module"
	icon_state = "hugmodule"
	desc = "For when a someone really needs a hug."
	/// Hug mode
	var/mode = HUG_MODE_NICE
	/// Crush cooldown
	COOLDOWN_DECLARE(crush_cooldown)
	/// Shock cooldown
	COOLDOWN_DECLARE(shock_cooldown)
	/// Can it be a stunarm when emagged. Only PK borgs get this by default.
	var/shockallowed = FALSE
	var/boop = FALSE

/obj/item/borg/cyborghug/attack_self(mob/living/user)
	if(iscyborg(user))
		var/mob/living/silicon/robot/robot_user = user
		if(robot_user.emagged && shockallowed == 1)
			if(mode < HUG_MODE_CRUSH)
				mode++
			else
				mode = HUG_MODE_NICE
		else if(mode < HUG_MODE_HUG)
			mode++
		else
			mode = HUG_MODE_NICE
	switch(mode)
		if(HUG_MODE_NICE)
			to_chat(user, span_infoplain(LANG("obj.60f99919", null)))
		if(HUG_MODE_HUG)
			to_chat(user, span_infoplain(LANG("obj.66c0e486", null)))
		if(HUG_MODE_SHOCK)
			to_chat(user, LANG("obj.1aaf7f88", null))
		if(HUG_MODE_CRUSH)
			to_chat(user, LANG("obj.0a022aa3", null))

/obj/item/borg/cyborghug/attack(mob/living/attacked_mob, mob/living/silicon/robot/user, list/modifiers, list/attack_modifiers)
	if(attacked_mob == user)
		return
	if(attacked_mob.health < 0)
		return
	switch(mode)
		if(HUG_MODE_NICE)
			if(isanimal_or_basicmob(attacked_mob))
				if (!user.combat_mode && !LAZYACCESS(modifiers, RIGHT_CLICK))
					attacked_mob.attack_hand(user, modifiers) //This enables borgs to get the floating heart icon and mob emote from simple_animal's that have petbonus == true.
				return
			if(user.zone_selected == BODY_ZONE_HEAD)
				user.visible_message(
					span_notice(LANG("obj.92bbbd71", list(user, attacked_mob))),
					span_notice(LANG("obj.5b22fd59", list(attacked_mob))),
				)
				user.do_attack_animation(attacked_mob, ATTACK_EFFECT_BOOP)
				playsound(loc, 'sound/items/weapons/tap.ogg', 50, TRUE, -1)
			else if(ishuman(attacked_mob))
				if(user.body_position == LYING_DOWN)
					user.visible_message(
						span_notice(LANG("obj.b37c53ea", list(user, attacked_mob, attacked_mob.p_them()))),
						span_notice(LANG("obj.8abc44ac", list(attacked_mob, attacked_mob.p_them()))),
					)
				else
					user.visible_message(
						span_notice(LANG("obj.dde9bc77", list(user, attacked_mob, attacked_mob.p_them()))),
						span_notice(LANG("obj.04eb052a", list(attacked_mob, attacked_mob.p_them()))),
					)
				if(attacked_mob.resting)
					attacked_mob.set_resting(FALSE, TRUE)
			else
				user.visible_message(
					span_notice(LANG("obj.0239e2cd", list(user, attacked_mob))),
					span_notice(LANG("obj.3ced569c", list(attacked_mob))),
				)
			playsound(loc, 'sound/items/weapons/thudswoosh.ogg', 50, TRUE, -1)
		if(HUG_MODE_HUG)
			if(ishuman(attacked_mob))
				attacked_mob.adjust_status_effects_on_shake_up()
				if(attacked_mob.body_position == LYING_DOWN)
					user.visible_message(
						span_notice(LANG("obj.b37c53ea", list(user, attacked_mob, attacked_mob.p_them()))),
						span_notice(LANG("obj.8abc44ac", list(attacked_mob, attacked_mob.p_them()))),
					)
				else if(user.zone_selected == BODY_ZONE_HEAD)
					user.visible_message(span_warning(LANG("obj.8b26e949", list(user, attacked_mob))),
						span_warning(LANG("obj.f08745e9", list(attacked_mob))),
					)
					user.do_attack_animation(attacked_mob, ATTACK_EFFECT_PUNCH)
				else
					if(!(SEND_SIGNAL(attacked_mob, COMSIG_BORG_HUG_MOB, user) & COMSIG_BORG_HUG_HANDLED))
						user.visible_message(
							span_warning(LANG("obj.2c384008", list(user, attacked_mob, attacked_mob))),
							span_warning(LANG("obj.430162c7", list(attacked_mob, attacked_mob.p_them(), attacked_mob))),
						)
				if(attacked_mob.resting)
					attacked_mob.set_resting(FALSE, TRUE)
			else
				user.visible_message(
					span_warning(LANG("obj.8b26e949", list(user, attacked_mob))),
					span_warning(LANG("obj.f08745e9", list(attacked_mob))),
				)
			playsound(loc, 'sound/items/weapons/tap.ogg', 50, TRUE, -1)
		if(HUG_MODE_SHOCK)
			if (!COOLDOWN_FINISHED(src, shock_cooldown))
				return
			if(ishuman(attacked_mob))
				attacked_mob.electrocute_act(5, "[user]", flags = SHOCK_NOGLOVES | SHOCK_NOSTUN)
				attacked_mob.dropItemToGround(attacked_mob.get_active_held_item())
				attacked_mob.dropItemToGround(attacked_mob.get_inactive_held_item())
				user.visible_message(
					span_userdanger(LANG("obj.e7ae6904", list(user, attacked_mob, user.p_their()))),
					span_danger(LANG("obj.fe2b3f85", list(attacked_mob))),
				)
			else
				if(!iscyborg(attacked_mob))
					attacked_mob.adjust_fire_loss(10)
					user.visible_message(
						span_userdanger(LANG("obj.d016fc16", list(user, attacked_mob))),
						span_danger(LANG("obj.ac5b962b", list(attacked_mob))),
					)
				else
					user.visible_message(
						span_userdanger(LANG("obj.814568fc", list(user, attacked_mob))),
						span_danger(LANG("obj.92056e5e", list(attacked_mob))),
					)
			playsound(loc, 'sound/effects/sparks/sparks2.ogg', 50, TRUE, -1)
			user.cell.use(0.5 * STANDARD_CELL_CHARGE, force = TRUE)
			COOLDOWN_START(src, shock_cooldown, HUG_SHOCK_COOLDOWN)
		if(HUG_MODE_CRUSH)
			if (!COOLDOWN_FINISHED(src, crush_cooldown))
				return
			if(ishuman(attacked_mob))
				user.visible_message(
					span_userdanger(LANG("obj.73c68314", list(user, attacked_mob, user.p_their()))),
					span_danger(LANG("obj.298e1261", list(attacked_mob))),
				)
			else
				user.visible_message(
					span_userdanger(LANG("obj.a1d666d4", list(user, attacked_mob))),
						span_danger(LANG("obj.e79ecc98", list(attacked_mob))),
				)
			playsound(loc, 'sound/items/weapons/smash.ogg', 50, TRUE, -1)
			attacked_mob.adjust_brute_loss(15)
			user.cell.use(0.3 * STANDARD_CELL_CHARGE, force = TRUE)
			COOLDOWN_START(src, crush_cooldown, HUG_CRUSH_COOLDOWN)

/obj/item/borg/cyborghug/peacekeeper
	shockallowed = TRUE

/obj/item/borg/cyborghug/medical
	boop = TRUE

/obj/item/borg/charger
	name = "power connector"
	icon_state = "charger_draw"
	item_flags = NOBLUDGEON
	/// Charging mode
	var/mode = "draw"
	/// Whitelist of charging machines
	var/static/list/charge_machines = typecacheof(list(/obj/machinery/cell_charger, /obj/machinery/recharger, /obj/machinery/recharge_station, /obj/machinery/mech_bay_recharge_port))
	/// Whitelist of chargable items
	var/static/list/charge_items = typecacheof(list(/obj/item/stock_parts/power_store, /obj/item/gun/energy))

/obj/item/borg/charger/update_icon_state()
	icon_state = "charger_[mode]"
	return ..()

/obj/item/borg/charger/attack_self(mob/user)
	if(mode == "draw")
		mode = "charge"
	else
		mode = "draw"
	to_chat(user, span_notice(LANG("obj.2d716125", list(src, mode))))
	update_appearance()

/obj/item/borg/charger/interact_with_atom(atom/target, mob/living/silicon/robot/user, list/modifiers)
	if(!iscyborg(user))
		return NONE

	. = ITEM_INTERACT_BLOCKING
	if(mode == "draw")
		if(is_type_in_list(target, charge_machines))
			var/obj/machinery/target_machine = target
			if((target_machine.machine_stat & (NOPOWER|BROKEN)) || !target_machine.anchored)
				to_chat(user, span_warning(LANG("obj.5c3745ea", list(target_machine))))
				return

			to_chat(user, span_notice(LANG("obj.5807fb0d", list(target_machine))))
			while(do_after(user, 1.5 SECONDS, target = target_machine, show_progress = FALSE))
				if(!user || !user.cell || mode != "draw")
					return

				if((target_machine.machine_stat & (NOPOWER|BROKEN)) || !target_machine.anchored)
					break

				target_machine.charge_cell(0.15 * STANDARD_CELL_CHARGE, user.cell)

			to_chat(user, span_notice(LANG("obj.26c09d1c", null)))

		else if(is_type_in_list(target, charge_items))
			var/obj/item/stock_parts/power_store/cell = target
			if(!istype(cell))
				cell = locate(/obj/item/stock_parts/power_store) in target
			if(!cell)
				to_chat(user, span_warning(LANG("obj.c6df9dc9", list(target))))
				return

			if(istype(target, /obj/item/gun/energy))
				var/obj/item/gun/energy/energy_gun = target
				if(!energy_gun.can_charge)
					to_chat(user, span_warning(LANG("obj.bb3e56b7", list(target))))
					return

			if(!cell.charge)
				to_chat(user, span_warning(LANG("obj.84948dc2", list(target))))


			to_chat(user, span_notice(LANG("obj.72b279e1", list(target))))

			while(do_after(user, 1.5 SECONDS, target = target, show_progress = FALSE))
				if(!user || !user.cell || mode != "draw")
					return

				if(!cell || !target)
					return

				if(cell != target && cell.loc != target)
					return

				var/draw = min(cell.charge, cell.chargerate*0.5, user.cell.maxcharge - user.cell.charge)
				if(!cell.use(draw))
					break
				if(!user.cell.give(draw))
					break
				target.update_appearance()

			to_chat(user, span_notice(LANG("obj.26c09d1c", null)))

	else if(is_type_in_list(target, charge_items))
		var/obj/item/stock_parts/power_store/cell = target
		if(!istype(cell))
			cell = locate(/obj/item/stock_parts/power_store) in target
		if(!cell)
			to_chat(user, span_warning(LANG("obj.c6df9dc9", list(target))))
			return

		if(istype(target, /obj/item/gun/energy))
			var/obj/item/gun/energy/energy_gun = target
			if(!energy_gun.can_charge)
				to_chat(user, span_warning(LANG("obj.bb3e56b7", list(target))))
				return

		if(cell.charge >= cell.maxcharge)
			to_chat(user, span_warning(LANG("obj.d228da44", list(target))))

		to_chat(user, span_notice(LANG("obj.72b279e1", list(target))))

		while(do_after(user, 1.5 SECONDS, target = target, show_progress = FALSE))
			if(!user || !user.cell || mode != "charge")
				return

			if(!cell || !target)
				return

			if(cell != target && cell.loc != target)
				return

			var/draw = min(user.cell.charge, cell.chargerate * 0.5, cell.maxcharge - cell.charge)
			if(!user.cell.use(draw))
				break
			if(!cell.give(draw))
				break
			target.update_appearance()

		to_chat(user, span_notice(LANG("obj.d02d54e8", list(target))))

/obj/item/harmalarm
	name = "\improper Sonic Harm Prevention Tool"
	desc = "Releases a harmless blast that confuses most organics. For when the harm is JUST TOO MUCH."
	icon = 'icons/obj/devices/voice.dmi'
	icon_state = "megaphone"
	/// Harm alarm cooldown
	COOLDOWN_DECLARE(alarm_cooldown)

/obj/item/harmalarm/emag_act(mob/user, obj/item/card/emag/emag_card)
	obj_flags ^= EMAGGED
	if(obj_flags & EMAGGED)
		balloon_alert(user, LANG("obj.9f2c2e26", null))
	else
		balloon_alert(user, LANG("obj.fc8c1c99", null))
	return TRUE

/obj/item/harmalarm/attack_self(mob/user)
	var/safety = !(obj_flags & EMAGGED)
	if (!COOLDOWN_FINISHED(src, alarm_cooldown))
		to_chat(user, LANG("obj.9306fd19", null))
		return

	if(iscyborg(user))
		var/mob/living/silicon/robot/robot_user = user
		if(!robot_user.cell || robot_user.cell.charge < 1200)
			to_chat(user, span_warning(LANG("obj.949e51ce", null)))
			return
		robot_user.cell.charge -= 1000
		if(robot_user.emagged)
			safety = FALSE

	if(safety == TRUE)
		user.visible_message(
			LANG("obj.e54f5ded", list(user)),
			span_userdanger(LANG("obj.e12a98a6", list(iscyborg(user) ? "you" : "and confuses you"))),
			span_danger(LANG("obj.b3d71be9", null)),
		)
		for(var/mob/living/carbon/carbon in get_hearers_in_view(9, user))
			if(carbon.get_ear_protection() > 0)
				continue
			carbon.adjust_confusion(6 SECONDS)

		audible_message(LANG("obj.b60d5fa4", null))
		playsound(get_turf(src), 'sound/mobs/non-humanoids/cyborg/harmalarm.ogg', 70, 3)
		COOLDOWN_START(src, alarm_cooldown, HARM_ALARM_SAFETY_COOLDOWN)
		user.log_message("used a Cyborg Harm Alarm", LOG_ATTACK)
		if(iscyborg(user))
			var/mob/living/silicon/robot/robot_user = user
			to_chat(robot_user.connected_ai, "<br>[span_notice("NOTICE - Peacekeeping 'HARM ALARM' used by: [user]")]<br>")
	else
		user.audible_message(LANG("obj.ce8d743c", null))
		for(var/mob/living/living in get_hearers_in_view(9, user))
			var/bang_effect = living.soundbang_act(SOUNDBANG_STRONG, 0, 0, 5)
			switch(bang_effect)
				if(0)
					continue
				if(1)
					living.adjust_confusion(5 SECONDS)
					living.adjust_stutter(20 SECONDS)
					living.adjust_jitter(20 SECONDS)
				else
					living.Paralyze(4 SECONDS)
					living.adjust_confusion(10 SECONDS)
					living.adjust_stutter(30 SECONDS)
					living.adjust_jitter(50 SECONDS)
		playsound(get_turf(src), 'sound/machines/warning-buzzer.ogg', 130, 3)
		COOLDOWN_START(src, alarm_cooldown, HARM_ALARM_NO_SAFETY_COOLDOWN)
		user.log_message("used an emagged Cyborg Harm Alarm", LOG_ATTACK)

/obj/item/shield_module
	name = "Shield Activator"
	icon = 'icons/mob/silicon/robot_items.dmi'
	icon_state = "module_miner"
	var/active = FALSE
	var/mutable_appearance/shield_overlay

/obj/item/shield_module/Initialize(mapload)
	. = ..()
	shield_overlay = mutable_appearance('icons/mob/effects/durand_shield.dmi', "borg_shield")

/obj/item/shield_module/attack_self(mob/living/silicon/borg)
	active = !active
	if(active)
		playsound(src, 'sound/vehicles/mecha/mech_shield_raise.ogg', 50, FALSE)
		RegisterSignal(borg, COMSIG_ATOM_UPDATE_OVERLAYS, PROC_REF(on_shield_overlay_update), override = TRUE)
	else
		playsound(src, 'sound/vehicles/mecha/mech_shield_drop.ogg', 50, FALSE)
		UnregisterSignal(borg, COMSIG_ATOM_UPDATE_OVERLAYS)
	borg.update_appearance()

/obj/item/shield_module/cyborg_unequip(mob/living/silicon/robot/borg)
	active = FALSE
	playsound(src, 'sound/vehicles/mecha/mech_shield_drop.ogg', 50, FALSE)
	borg.cut_overlay(shield_overlay)

/obj/item/shield_module/proc/on_shield_overlay_update(atom/source, list/overlays)
	SIGNAL_HANDLER
	if(active)
		overlays += shield_overlay

#undef HUG_MODE_NICE
#undef HUG_MODE_HUG
#undef HUG_MODE_SHOCK
#undef HUG_MODE_CRUSH

#undef HUG_SHOCK_COOLDOWN
#undef HUG_CRUSH_COOLDOWN

#undef HARM_ALARM_NO_SAFETY_COOLDOWN
#undef HARM_ALARM_SAFETY_COOLDOWN
