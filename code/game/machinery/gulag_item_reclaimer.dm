/obj/machinery/gulag_item_reclaimer
	name = "装备回收站"
	desc = "用于在劳改服刑结束后回收物品"
	icon = 'icons/obj/machines/wallmounts.dmi'
	icon_state = "gulag_off"
	req_access = list(ACCESS_BRIG) //REQACCESS TO ACCESS ALL STORED ITEMS
	density = FALSE

	var/list/stored_items = list()
	var/obj/machinery/gulag_teleporter/linked_teleporter = null
	///Icon of the current screen status
	var/screen_icon = "gulag_on"

/obj/machinery/gulag_item_reclaimer/Exited(atom/movable/gone, direction)
	. = ..()
	for(var/person in stored_items)
		stored_items[person] -= gone

/obj/machinery/gulag_item_reclaimer/update_overlays()
	. = ..()
	if(machine_stat & (NOPOWER|BROKEN))
		return

	. += mutable_appearance(icon, screen_icon)
	. += emissive_appearance(icon, screen_icon, src)

/obj/machinery/gulag_item_reclaimer/Destroy()
	for(var/i in contents)
		var/obj/item/I = i
		I.forceMove(get_turf(src))
	if(linked_teleporter)
		linked_teleporter.linked_reclaimer = null
	linked_teleporter = null
	return ..()

/obj/machinery/gulag_item_reclaimer/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(obj_flags & EMAGGED) // emagging lets anyone reclaim all the items
		return FALSE
	req_access = list()
	obj_flags |= EMAGGED
	screen_icon = "emagged_general"
	update_appearance()
	balloon_alert(user, "身份检查器已扰乱")
	return TRUE

/obj/machinery/gulag_item_reclaimer/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "GulagItemReclaimer", name)
		ui.open()

/obj/machinery/gulag_item_reclaimer/ui_data(mob/user)
	var/list/data = list()
	var/can_reclaim = FALSE

	if(allowed(user))
		can_reclaim = TRUE

	var/obj/item/card/id/I
	if(isliving(user))
		var/mob/living/L = user
		I = L.get_idcard(TRUE)
	if(istype(I, /obj/item/card/id/advanced/prisoner))
		var/obj/item/card/id/advanced/prisoner/P = I
		if(P.points >= P.goal)
			can_reclaim = TRUE

	var/list/mobs = list()
	for(var/i in stored_items)
		var/mob/thismob = i
		if(QDELETED(thismob))
			say("Alert! Unable to locate vital signals of a previously processed prisoner. Ejecting equipment!")
			drop_items(thismob)
			continue
		var/list/mob_info = list()
		mob_info["name"] = thismob.real_name
		mob_info["mob"] = "[REF(thismob)]"
		mobs += list(mob_info)

	data["mobs"] = mobs
	data["can_reclaim"] = can_reclaim

	return data

/obj/machinery/gulag_item_reclaimer/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("release_items")
			var/mob/living/carbon/human/H = locate(params["mobref"]) in stored_items
			if(H != usr && !allowed(usr))
				to_chat(usr, span_warning("拒绝访问."))
				return
			drop_items(H)
			. = TRUE

/obj/machinery/gulag_item_reclaimer/proc/drop_items(mob/user)
	if(!stored_items[user])
		return
	if(!use_energy(active_power_usage, force = FALSE))
		balloon_alert(user, "能量不足！")
		return
	var/drop_location = drop_location()
	for(var/i in stored_items[user])
		var/obj/item/W = i
		stored_items[user] -= W
		W.forceMove(drop_location)
	stored_items -= user
	user.log_message("has reclaimed their items from the gulag item reclaimer.", LOG_GAME)
