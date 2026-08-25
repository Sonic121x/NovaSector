// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/item/implantpad
	name = "implant pad"
	desc = "Used to modify implants."
	icon = 'icons/obj/devices/tool.dmi' //NOVA EDIT - ICON OVERRIDDEN IN AESTHETICS MODULE
	icon_state = "implantpad-0"
	base_icon_state = "implantpad"
	inhand_icon_state = "electronic"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	throw_speed = 3
	throw_range = 5
	w_class = WEIGHT_CLASS_SMALL
	interaction_flags_click = FORBID_TELEKINESIS_REACH|ALLOW_RESTING

	///The implant case currently inserted into the pad.
	var/obj/item/implantcase/inserted_case

	/// The deathrattle group currently saved to the implantpad.
	var/datum/deathrattle_group/saved_deathrattle_group

/obj/item/implantpad/update_icon_state()
	icon_state = "[base_icon_state]-[!isnull(inserted_case)]"
	return ..()

/obj/item/implantpad/examine(mob/user)
	. = ..()
	if(!inserted_case)
		. += span_info(LANG("obj.1b5f6bf077d688dd", null))
		return

	if(Adjacent(user))
		. += span_info(LANG("obj.eaca0139f8d2f814", list(inserted_case)))
	else
		. += span_warning(LANG("obj.6af3f4ff32643c3b", null))
	. += span_info(LANG("obj.cba63c8b08994ed5", list(inserted_case)))

/obj/item/implantpad/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == inserted_case)
		inserted_case = null
		update_appearance(UPDATE_ICON)

/obj/item/implantpad/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(inserted_case || !istype(tool, /obj/item/implantcase))
		return NONE
	if(!user.transferItemToLoc(tool, src))
		return ITEM_INTERACT_BLOCKING
	user.balloon_alert(user, LANG("obj.c2fd0905b0b6f62c", null))
	inserted_case = tool
	update_static_data_for_all_viewers()
	update_appearance(UPDATE_ICON)
	return ITEM_INTERACT_SUCCESS

/obj/item/implantpad/click_alt(mob/user)
	remove_implant(user)
	return CLICK_ACTION_SUCCESS

/obj/item/implantpad/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "ImplantPad", name)
		ui.open()

/obj/item/implantpad/ui_data(mob/user)
	var/list/data = list()
	data["saved_deathrattle_group"] = saved_deathrattle_group ? saved_deathrattle_group.name : null
	data["current_deathrattle_group"] = null
	data["has_case"] = !!inserted_case
	if(!inserted_case)
		return data
	data["has_implant"] = !!inserted_case.imp
	if(inserted_case.imp)
		data["case_information"] = inserted_case.imp.get_data()
		data["case_lore"] = inserted_case.imp.get_lore()
		if(istype(inserted_case.imp, /obj/item/implant/deathrattle))
			var/obj/item/implant/deathrattle/inserted_deathrattle = inserted_case.imp
			if(inserted_deathrattle.current_group)
				data["current_deathrattle_group"] = inserted_deathrattle.current_group
	return data

/obj/item/implantpad/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	var/mob/user = usr
	if(action == "eject_implant")
		remove_implant(user)
		return
	if(action == "save_deathrattle_group")
		save_deathrattle_group(user)
	if(action == "set_deathrattle_group")
		set_deathrattle_group(user)
	if(action == "init_deathrattle_group")
		init_deathrattle_group(user)

///Removes the implant from the pad and puts it in the user's hands if possible.
/obj/item/implantpad/proc/remove_implant(mob/user)
	if(!inserted_case)
		user.balloon_alert(user, LANG("obj.060f689ce74e247d", null))
		return FALSE
	add_fingerprint(user)
	inserted_case.add_fingerprint(user)
	user.put_in_hands(inserted_case)
	user.balloon_alert(user, LANG("obj.7eb3ffb401f9de31", null))
	update_appearance(UPDATE_ICON)
	update_static_data_for_all_viewers()
	return TRUE

/// Saves the currently inserted implant's deathrattle group.
/obj/item/implantpad/proc/save_deathrattle_group(mob/user)
	if(!inserted_case)
		user.balloon_alert(user, LANG("obj.060f689ce74e247d", null))
		return FALSE
	if(!istype(inserted_case.imp, /obj/item/implant/deathrattle))
		user.balloon_alert(user, LANG("obj.36313258a9141651", null))
		return FALSE
	var/obj/item/implant/deathrattle/inserted_implant = inserted_case.imp
	var/datum/deathrattle_group/current_group = inserted_implant.current_group
	if(!current_group)
		user.balloon_alert(user, LANG("obj.27252a990d60ee19", null))
		return FALSE
	saved_deathrattle_group = current_group
	user.balloon_alert(user, LANG("obj.431c3263867a418b", list(current_group.name)))
	update_static_data_for_all_viewers()
	return TRUE

/// Sets the currently inserted implant's deathrattle group to saved.
/obj/item/implantpad/proc/set_deathrattle_group(mob/user)
	if(!inserted_case)
		user.balloon_alert(user, LANG("obj.060f689ce74e247d", null))
		return FALSE
	if(!saved_deathrattle_group)
		user.balloon_alert(user, LANG("obj.bf3d50d825f606a2", null))
		return FALSE
	if(!istype(inserted_case.imp, /obj/item/implant/deathrattle))
		user.balloon_alert(user, LANG("obj.36313258a9141651", null))
		return FALSE
	var/obj/item/implant/deathrattle/inserted_implant = inserted_case.imp
	if(!istype(saved_deathrattle_group, inserted_implant.deathrattle_group_type))
		user.balloon_alert(user, LANG("obj.6272c3f2beff64bc", null))
		return FALSE
	saved_deathrattle_group.register(inserted_implant)
	user.balloon_alert(user, LANG("obj.4b9878a9ad063b36", list(saved_deathrattle_group.name)))
	inserted_case.name = "[initial(inserted_case.name)] - [saved_deathrattle_group.name]"
	update_static_data_for_all_viewers()
	return TRUE

/// Initializes and saves a new deathrattle group, then registers the current implant to it.
/obj/item/implantpad/proc/init_deathrattle_group(mob/user)
	if(!inserted_case)
		user.balloon_alert(user, LANG("obj.060f689ce74e247d", null))
		return FALSE
	if(!istype(inserted_case.imp, /obj/item/implant/deathrattle))
		user.balloon_alert(user, LANG("obj.36313258a9141651", null))
		return FALSE
	var/obj/item/implant/deathrattle/inserted_implant = inserted_case.imp
	if(inserted_implant.current_group)
		user.balloon_alert(user, LANG("obj.ba215ea32889d42d", null))
		return FALSE
	// init and save new group
	saved_deathrattle_group = new inserted_implant.deathrattle_group_type
	// register current implant
	saved_deathrattle_group.register(inserted_implant)
	user.balloon_alert(user, LANG("obj.87640da50d2b6872", list(saved_deathrattle_group.name)))
	inserted_case.name += " - [saved_deathrattle_group.name]"
	update_static_data_for_all_viewers()
	return TRUE
