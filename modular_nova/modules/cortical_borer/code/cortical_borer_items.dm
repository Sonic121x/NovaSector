/obj/item/cortical_cage
	name = "cortical borer cage"
	desc = "A harmless cage that is intended to capture cortical borers."
	icon = 'modular_nova/modules/cortical_borer/icons/items.dmi'
	icon_state = "cage"

	///If true, the trap is "open" and can trigger.
	var/opened = FALSE
	///The radio that is inserted into the trap.
	var/obj/item/radio/internal_radio
	///The borer that is inside the trap
	var/mob/living/basic/cortical_borer/trapped_borer

/obj/item/cortical_cage/Initialize(mapload)
	. = ..()
	update_appearance()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(spring_trap),
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/item/cortical_cage/update_overlays()
	. = ..()
	if(trapped_borer)
		. += "borer"
	if(internal_radio)
		. += "radio"
	if(opened)
		. += "doors_open"
	else
		. += "doors_closed"

/obj/item/cortical_cage/attack_self(mob/user, modifiers)
	opened = !opened
	if(opened)
		user.visible_message(LANG("obj.81f3dbc45176d2fd", list(user, src)), LANG("obj.89d38f23ec7473e8", list(src)), LANG("obj.8ec9d77f850f8e78", null))
	else
		user.visible_message(LANG("obj.e668eb947ba86a32", list(user, src)), LANG("obj.e65ef9005667b2ec", list(src)), LANG("obj.8ec9d77f850f8e78", null))
	playsound(src, 'sound/machines/airlock/boltsup.ogg', 30, TRUE)
	update_appearance()

/obj/item/cortical_cage/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/radio))
		internal_radio = tool
		internal_radio.forceMove(src)
		visible_message(LANG("obj.0799ae70d0921e89", list(internal_radio, src)), LANG("obj.eeaf6739cd500462", list(internal_radio, src)), LANG("obj.5584e97ea3f6a3df", null))
		update_appearance()
		return ITEM_INTERACT_SUCCESS
	return ..()

/obj/item/cortical_cage/crowbar_act(mob/living/user, obj/item/tool)
	. = ..()
	if(internal_radio)
		internal_radio.forceMove(get_turf(src))
		user.visible_message(LANG("obj.b621a9988eea2e71", list(internal_radio, src)), LANG("obj.5ca6d565993d1bf0", list(internal_radio, src)), LANG("obj.61e32594c547c32c", null))
		internal_radio = null
		update_appearance()
		return

/obj/item/cortical_cage/proc/spring_trap(datum/source, atom/movable/AM)
	SIGNAL_HANDLER
	//it will only trigger on a cortical borer, and it has to be opened
	if(!iscorticalborer(AM) || !opened)
		return
	trapped_borer = AM
	trapped_borer.visible_message(LANG("obj.763f67a573773323", list(trapped_borer, src)), LANG("obj.ffeb126eacd3a0ae", list(src)), LANG("obj.b22b680b7491702a", null))
	trapped_borer.forceMove(src)
	opened = FALSE
	if(internal_radio)
		var/area/src_area = get_area(src)
		internal_radio.talk_into(src, LANG("obj.4b28d589f9d7ed15", list(src_area)), RADIO_CHANNEL_COMMON)
	playsound(src, 'sound/machines/airlock/boltsup.ogg', 30, TRUE)
	update_appearance()

/obj/item/cortical_cage/relaymove(mob/living/user, direction)
	if(!iscorticalborer(user))
		user.forceMove(get_turf(src))
		update_appearance()
		return
	if(opened)
		loc.visible_message(span_notice(LANG("obj.dc5ea840c345fada", list(user, src))), \
		span_warning(LANG("obj.76224ddbbc305a56", list(user, src))))
		opened = FALSE
		trapped_borer.forceMove(get_turf(src))
		trapped_borer = null
		update_appearance()
		return
	else if(user.client)
		container_resist_act(user)

/obj/item/cortical_cage/container_resist_act(mob/living/user)
	user.changeNext_move(CLICK_CD_BREAKOUT)
	user.last_special = world.time + CLICK_CD_BREAKOUT
	to_chat(user, span_notice(LANG("obj.a8805b26dd4bd689", null)))
	to_chat(loc, span_warning(LANG("obj.c286349764322ae6", list(user))))
	if(!do_after(user, rand(30 SECONDS, 40 SECONDS), target = user) || opened || !(user in contents))
		return
	loc.visible_message(span_warning(LANG("obj.2dcb5725917e222f", list(user, src))), null, null, null, user)
	to_chat(user, span_boldannounce(LANG("obj.54f55369e3121feb", null)))
	opened = FALSE
	trapped_borer.forceMove(get_turf(src))
	trapped_borer = null
	update_appearance()
