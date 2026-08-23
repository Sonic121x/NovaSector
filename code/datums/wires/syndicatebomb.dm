// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/wires/syndicatebomb
	holder_type = /obj/machinery/syndicatebomb
	proper_name = "Syndicate Explosive Device"
	randomize = TRUE

/datum/wires/syndicatebomb/New(atom/holder)
	setup_wires()
	return ..()

/**
 * Handles setting up the wires list.
 *
 * * num_booms: The number of boom wires to add.
 * * num_duds: The number of dud wires to add.
 */
/datum/wires/syndicatebomb/proc/setup_wires(num_booms = 2, num_duds = 0)
	wires = list(
		WIRE_ACTIVATE,
		WIRE_DELAY,
		WIRE_PROCEED,
		WIRE_UNBOLT,
	)
	add_booms(num_booms)
	add_duds(num_duds)
	shuffle_wires()

/// Adds a number of wires which will explode the bomb if pulse/cut
/datum/wires/syndicatebomb/proc/add_booms(booms = 2)
	for(var/i in 1 to booms)
		wires += "[WIRE_BOOM] [i]"

/datum/wires/syndicatebomb/interactable(mob/user)
	var/obj/machinery/syndicatebomb/bomb = holder
	return ..() && bomb.open_panel

/// Translates numbered boom wires into WIRE_BOOM.
/datum/wires/syndicatebomb/proc/parse_wire(wire)
	return findtext(wire, WIRE_BOOM) ? WIRE_BOOM : wire

/// Checks if the bomb, if detonated, is dangerous to the user.
/datum/wires/syndicatebomb/proc/is_dangerous()
	var/obj/machinery/syndicatebomb/bomb = holder
	if(isnull(bomb.payload))
		return FALSE
	if(istype(bomb.payload, /obj/item/bombcore/training))
		return FALSE
	return TRUE

/datum/wires/syndicatebomb/on_pulse(wire, mob/user)
	var/obj/machinery/syndicatebomb/bomb = holder
	switch(parse_wire(wire))
		if(WIRE_BOOM)
			if(!bomb.active)
				holder.visible_message(span_notice(LANG("datum.2b0fa738c5df44cf", list(icon2html(bomb, viewers(holder))))))
				return

			holder.visible_message(span_danger(LANG("datum.3b536419c0e9b07a", list(icon2html(bomb, viewers(holder))))))
			bomb.explode_now = TRUE
			if(is_dangerous())
				tell_admins(bomb, user, "detonated via boom wire")
				if(isliving(user))
					add_memory_in_range(bomb, 7, /datum/memory/bomb_defuse_failure, protagonist = user, antagonist = bomb)

		if(WIRE_UNBOLT)
			holder.visible_message(span_notice(LANG("datum.f5dacf9362ccb9ac", list(icon2html(bomb, viewers(holder))))))

		if(WIRE_DELAY)
			if(bomb.delayedbig)
				holder.visible_message(span_notice(LANG("datum.2b0fa738c5df44cf", list(icon2html(bomb, viewers(holder))))))
				return

			holder.visible_message(span_notice(LANG("datum.87abafc0f3c06d9d", list(icon2html(bomb, viewers(holder))))))
			playsound(bomb, 'sound/machines/chime.ogg', 30, TRUE)
			bomb.detonation_timer += (30 SECONDS)
			if(bomb.active)
				bomb.delayedbig = TRUE

		if(WIRE_PROCEED)
			holder.visible_message(span_danger(LANG("datum.a4fc487b4cd1ad6d", list(icon2html(bomb, viewers(holder))))))
			playsound(bomb, 'sound/machines/buzz/buzz-sigh.ogg', 30, TRUE)
			var/seconds = bomb.seconds_remaining()
			if(seconds >= 61) // Long fuse bombs can suddenly become more dangerous if you tinker with them.
				bomb.detonation_timer = world.time + (60 SECONDS)
			else if(seconds >= 21)
				bomb.detonation_timer -= (10 SECONDS)
			else if(seconds >= 11) // Both to prevent negative timers and to have a little mercy.
				bomb.detonation_timer = world.time + (10 SECONDS)

		if(WIRE_ACTIVATE)
			if(!bomb.active)
				holder.visible_message(span_danger(LANG("datum.b1c28b4bb2cf7d68", list(icon2html(bomb, viewers(holder))))))
				bomb.activate()
				bomb.update_appearance()
			else if(bomb.delayedlittle)
				holder.visible_message(span_notice(LANG("datum.2b0fa738c5df44cf", list(icon2html(bomb, viewers(holder))))))
			else
				holder.visible_message(span_notice(LANG("datum.bd075beb7eef5578", list(icon2html(bomb, viewers(holder))))))
				bomb.detonation_timer += 100
				bomb.delayedlittle = TRUE

/datum/wires/syndicatebomb/on_cut(wire, mend, source)
	var/obj/machinery/syndicatebomb/bomb = holder
	switch(parse_wire(wire))
		if(WIRE_BOOM)
			if(mend || !bomb.active)
				return
			holder.visible_message(span_danger(LANG("datum.3b536419c0e9b07a", list(icon2html(bomb, viewers(holder))))))
			bomb.explode_now = TRUE
			if(is_dangerous())
				tell_admins(bomb, source, "detonated via boom wire")
				if(isliving(source))
					add_memory_in_range(bomb, 7, /datum/memory/bomb_defuse_failure, protagonist = source, antagonist = bomb)

		if(WIRE_UNBOLT)
			if(mend || !bomb.anchored)
				return
			holder.visible_message(span_notice(LANG("datum.3063a6968bcf76fa", list(icon2html(bomb, viewers(holder))))))
			playsound(bomb, 'sound/effects/stealthoff.ogg', 30, TRUE)
			bomb.set_anchored(FALSE)

		if(WIRE_PROCEED)
			if(mend || !bomb.active)
				return
			holder.visible_message(span_danger(LANG("datum.21c4fac602311547", list(icon2html(bomb, viewers(holder))))))
			bomb.examinable_countdown = FALSE

		if(WIRE_ACTIVATE)
			if(mend || !bomb.active)
				return
			var/bomb_time_left = bomb.seconds_remaining()
			holder.visible_message(span_notice(LANG("datum.fbbfd6b7235bedde", list(icon2html(bomb, viewers(holder))))))
			bomb.defuse()
			if(is_dangerous())
				tell_admins(bomb, source, "defused")
				if(isliving(source))
					add_memory_in_range(bomb, 7, /datum/memory/bomb_defuse_success, protagonist = source, antagonist = bomb, bomb_time_left = bomb_time_left)

/datum/wires/syndicatebomb/proc/tell_admins(obj/machinery/syndicatebomb/bomb, atom/source, what_happened)
	var/turf/bombloc = get_turf(bomb)
	log_game("\A [bomb] was [what_happened] at [AREACOORD(bombloc)] by [source || "nothing(?)"].")
	message_admins("\A [bomb] was [what_happened] at [ADMIN_VERBOSEJMP(bombloc)] by [source ? ADMIN_LOOKUPFLW(source) : "nothing(?)"].")
	if(isliving(source))
		log_combat(source, bomb, what_happened)
