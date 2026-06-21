/obj/machinery/netpod/Exited(atom/movable/gone, direction)
	. = ..()
	if(!state_open && gone == occupant)
		container_resist_act(gone)


/obj/machinery/netpod/relaymove(mob/living/user, direction)
	if(!state_open)
		container_resist_act(user)


/obj/machinery/netpod/container_resist_act(mob/living/user)
	user.visible_message(span_notice("[occupant]从[src]中出来了！"),
		span_notice("你爬出了[src]！"),
		span_notice("伴随着嘶嘶声，你听到机器打开了。"))
	open_machine()


/obj/machinery/netpod/open_machine(drop = TRUE, density_to_set = FALSE)
	playsound(src, 'sound/machines/tram/tramopen.ogg', 60, TRUE, frequency = 65000)
	flick("[base_icon_state]_opening", src)
	SEND_SIGNAL(src, COMSIG_BITRUNNER_NETPOD_OPENED)
	update_use_power(IDLE_POWER_USE)

	return ..()


/obj/machinery/netpod/close_machine(mob/user, density_to_set = TRUE)
	if(!state_open || panel_open || !is_operational || !iscarbon(user))
		return

	playsound(src, 'sound/machines/tram/tramclose.ogg', 60, TRUE, frequency = 65000)
	flick("[base_icon_state]_closing", src)
	..()

	enter_matrix()


/obj/machinery/netpod/default_pry_open(mob/living/user, obj/item/crowbar, close_after_pry = FALSE, open_density = FALSE, closed_density = TRUE, deconstruct_on_fail = FALSE)
	if(!iscarbon(occupant))
		if(!state_open)
			if(panel_open)
				return deconstruct_on_fail ? default_deconstruction_crowbar(user, crowbar) : NONE
			open_machine()
		else
			shut_pod()

		return ITEM_INTERACT_SUCCESS

	user.visible_message(
		span_danger("[user] starts prying open [src]!"),
		span_notice("你开始撬开[src]。"),
		span_notice("你听到金属被撬动的巨响。")
	)
	playsound(src, 'sound/machines/airlock/airlock_alien_prying.ogg', 100, TRUE)

	SEND_SIGNAL(src, COMSIG_BITRUNNER_CROWBAR_ALERT, user)

	if(crowbar.use_tool(src, user, 15 SECONDS, volume = 50))
		if(!state_open)
			sever_connection()
			open_machine()

	return ITEM_INTERACT_SUCCESS


/// Closes the machine without shoving in an occupant
/obj/machinery/netpod/proc/shut_pod()
	state_open = FALSE
	playsound(src, 'sound/machines/tram/tramclose.ogg', 60, TRUE, frequency = 65000)
	flick("[base_icon_state]_closing", src)
	set_density(TRUE)

	update_appearance()
