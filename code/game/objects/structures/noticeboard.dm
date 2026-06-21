#define MAX_NOTICES 8

/obj/structure/noticeboard
	name = "告示牌"
	desc = "一块用于钉重要通知的板子。它由最上等的西班牙软木制成。"
	icon = 'icons/obj/wallmounts.dmi'
	icon_state = "noticeboard"
	density = FALSE
	anchored = TRUE
	max_integrity = 150
	/// Current number of a pinned notices
	var/notices = 0

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/noticeboard, 32)

/obj/structure/noticeboard/on_object_saved()
	var/data

	for(var/obj/item/paper/paper in contents)
		var/metadata = generate_tgm_metadata(paper)
		data += "[data ? ",\n" : ""][paper.type][metadata]"

	return data

/obj/structure/noticeboard/Initialize(mapload)
	. = ..()

	if(!mapload)
		return

	for(var/obj/item/paper/paper in loc)
		if(notices >= MAX_NOTICES)
			break

		paper.forceMove(src)
		notices++
	update_appearance(UPDATE_ICON)
	if(mapload)
		find_and_mount_on_atom()

//attaching papers!!
/obj/structure/noticeboard/attackby(obj/item/O, mob/user, list/modifiers, list/attack_modifiers)
	if(istype(O, /obj/item/paper) || istype(O, /obj/item/photo))
		if(!allowed(user))
			to_chat(user, span_warning("你无权添加通知！"))
			return
		if(notices < MAX_NOTICES)
			if(!user.transferItemToLoc(O, src))
				return
			notices++
			update_appearance(UPDATE_ICON)
			to_chat(user, span_notice("你将 [O] 钉在了通知板上。"))
		else
			to_chat(user, span_warning("布告牌上已经满了！"))
	else
		return ..()

/obj/structure/noticeboard/ui_state(mob/user)
	return GLOB.physical_state

/obj/structure/noticeboard/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "NoticeBoard", name)
		ui.open()

/obj/structure/noticeboard/ui_data(mob/user)
	var/list/data = list()
	data["allowed"] = allowed(user)
	data["items"] = list()
	for(var/obj/item/content in contents)
		var/list/content_data = list(
			name = content.name,
			ref = REF(content)
		)
		data["items"] += list(content_data)
	return data

/obj/structure/noticeboard/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/obj/item/item = locate(params["ref"]) in contents
	if(!istype(item) || item.loc != src)
		return

	var/mob/user = usr

	switch(action)
		if("examine")
			if(istype(item, /obj/item/paper))
				item.ui_interact(user)
			else
				user.examinate(item)
			return TRUE
		if("remove")
			if(!allowed(user))
				return
			remove_item(item, user)
			return TRUE

/obj/structure/noticeboard/update_overlays()
	. = ..()
	if(notices)
		. += "notices_[notices]"

/**
 * Removes an item from the notice board
 *
 * Arguments:
 * * item - The item that is to be removed
 * * user - The mob that is trying to get the item removed, if there is one
 */
/obj/structure/noticeboard/proc/remove_item(obj/item/item, mob/user)
	item.forceMove(drop_location())
	if(user)
		user.put_in_hands(item)
		balloon_alert(user, "已从布告板上移除")
	notices--
	update_appearance(UPDATE_ICON)

/obj/structure/noticeboard/atom_deconstruct(disassembled = TRUE)
	if(!disassembled)
		new /obj/item/stack/sheet/mineral/wood(loc)
	else
		new /obj/item/wallframe/noticeboard(loc)
	for(var/obj/item/content in contents)
		remove_item(content)

/obj/item/wallframe/noticeboard
	name = "告示牌"
	desc = "现在它更像是个写字夹板。请安装在墙上使用。"
	icon = 'icons/obj/wallmounts.dmi'
	icon_state = "noticeboard"
	custom_materials = list(
		/datum/material/wood = SHEET_MATERIAL_AMOUNT,
	)
	resistance_flags = FLAMMABLE
	result_path = /obj/structure/noticeboard
	pixel_shift = 32

// Notice boards for the heads of staff (plus the qm)

/obj/structure/noticeboard/captain
	name = "舰长告示牌"
	desc = "舰长的重要通知。"
	req_access = list(ACCESS_CAPTAIN)

/obj/structure/noticeboard/hop
	name = "人事部长布告栏"
	desc = "人事部长的重要通知。"
	req_access = list(ACCESS_HOP)

/obj/structure/noticeboard/ce
	name = "工程部长告示牌"
	desc = "工程部长的重要通知。"
	req_access = list(ACCESS_CE)

/obj/structure/noticeboard/hos
	name = "安全部长告示牌"
	desc = "安全部长的重要通知。"
	req_access = list(ACCESS_HOS)

/obj/structure/noticeboard/cmo
	name = "首席医疗官告示牌"
	desc = "首席医疗官的重要通知。"
	req_access = list(ACCESS_CMO)

/obj/structure/noticeboard/rd
	name = "研究总监告示牌"
	desc = "研究总监的重要通知。"
	req_access = list(ACCESS_RD)

/obj/structure/noticeboard/qm
	name = "军需官告示牌"
	desc = "军需官的重要通知。"
	req_access = list(ACCESS_QM)

/obj/structure/noticeboard/staff
	name = "员工告示牌"
	desc = "来自员工领导的重要通知。"
	req_access = list(ACCESS_COMMAND)

#undef MAX_NOTICES
