// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/machinery/netpod/Exited(atom/movable/gone, direction)
	. = ..()
	if(!state_open && gone == occupant)
		container_resist_act(gone)


/obj/machinery/netpod/relaymove(mob/living/user, direction)
	if(!state_open)
		container_resist_act(user)


/obj/machinery/netpod/container_resist_act(mob/living/user)
	user.visible_message(span_notice(LANG("obj.8616ec7ef6eb4cb4", list(occupant, src))),
		span_notice(LANG("obj.adaf0a2d27164b52", list(src))),
		span_notice(LANG("obj.f867c29d88684f1e", null)))
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
		span_danger(LANG("obj.44411a9a23efb065", list(user, src))),
		span_notice(LANG("obj.68c3aeb6cb28ee15", list(src))),
		span_notice(LANG("obj.e8e1ff73b4a188b4", null))
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
