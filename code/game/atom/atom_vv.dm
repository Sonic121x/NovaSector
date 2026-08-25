// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/**
 * Return the markup to for the dropdown list for the VV panel for this atom
 *
 * Override in subtypes to add custom VV handling in the VV panel
 */
/atom/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION("", "--- /atom ---")
	if(!ismovable(src))
		var/turf/curturf = get_turf(src)
		if(curturf)
			. += LANG("atom.a98f9a3a13c7ce91", list(HrefToken(), curturf.x, curturf.y, curturf.z))
	VV_DROPDOWN_OPTION(VV_HK_MODIFY_TRANSFORM, "Modify Transform")
	VV_DROPDOWN_OPTION(VV_HK_DEBUG_APPEARANCE, "Debug Appearance")
	VV_DROPDOWN_OPTION(VV_HK_DOWNLOAD_SPRITE, "Download Sprite")
	VV_DROPDOWN_OPTION(VV_HK_SPIN_ANIMATION, "SpinAnimation")
	VV_DROPDOWN_OPTION(VV_HK_STOP_ALL_ANIMATIONS, "Stop All Animations")
	VV_DROPDOWN_OPTION(VV_HK_SHOW_HIDDENPRINTS, "Show Hiddenprint log")
	VV_DROPDOWN_OPTION(VV_HK_ADD_REAGENT, "Add Reagent")
	VV_DROPDOWN_OPTION(VV_HK_TRIGGER_EMP, "EMP Pulse")
	VV_DROPDOWN_OPTION(VV_HK_TRIGGER_EXPLOSION, "Explosion")
	VV_DROPDOWN_OPTION(VV_HK_EDIT_FILTERS, "Edit Filters")
	VV_DROPDOWN_OPTION(VV_HK_EDIT_COLOR_MATRIX, "Edit Color as Matrix")
	VV_DROPDOWN_OPTION(VV_HK_TEST_MATRIXES, "Test Matrices")
	VV_DROPDOWN_OPTION(VV_HK_ADD_AI, "Add AI controller")
	VV_DROPDOWN_OPTION(VV_HK_ARMOR_MOD, "Modify Armor")
	if(greyscale_colors)
		VV_DROPDOWN_OPTION(VV_HK_MODIFY_GREYSCALE, "Modify greyscale colors")

/atom/vv_do_topic(list/href_list)
	. = ..()

	if(!.)
		return

	if(href_list[VV_HK_ADD_REAGENT])
		if(!reagents)
			var/amount = tgui_input_number(usr, LANG("atom.5e9da115acc0fdda", list(src)), LANG("atom.79ad2c0f9c08fe47", null), 50)
			if(!amount)
				return
			create_reagents(amount)

		if(!reagents)
			return

		var/chosen_id
		switch(tgui_alert(usr, LANG("atom.dc95397ff9abf213", null), LANG("atom.a21ddbb3b32efd08", null), list("Search", "Choose from a list", "I'm feeling lucky")))
			if("Search")
				var/valid_id
				while(!valid_id)
					chosen_id = tgui_input_text(usr, LANG("atom.d4cf7df60e6e7714", null), LANG("atom.130464905b6cdd46", null))
					if(isnull(chosen_id)) //Get me out of here!
						break
					if (!ispath(text2path(chosen_id)))
						chosen_id = pick_closest_path(chosen_id, make_types_fancy(subtypesof(/datum/reagent)))
						if (ispath(chosen_id))
							valid_id = TRUE
					else
						valid_id = TRUE
					if(!valid_id)
						to_chat(usr, span_warning(LANG("atom.66e644d87af88862", null)))
			if("Choose from a list")
				chosen_id = tgui_input_list(usr, LANG("atom.2aa830799bc2e4a5", null), LANG("atom.a34b595fc59be99a", null), sort_list(subtypesof(/datum/reagent), GLOBAL_PROC_REF(cmp_typepaths_asc)))
			if("I'm feeling lucky")
				chosen_id = pick(subtypesof(/datum/reagent))

		if(!chosen_id)
			return
		var/amount = tgui_input_number(usr, LANG("atom.acdb4d7b70fc1fdf", null), LANG("atom.3b3f4833177ca9c5", null), reagents.maximum_volume - reagents.total_volume, reagents.maximum_volume)
		if(!amount)
			return
		reagents.add_reagent(chosen_id, amount)
		log_admin("[key_name(usr)] has added [amount] units of [chosen_id] to [src]")
		message_admins(span_notice("[key_name(usr)] has added [amount] units of [chosen_id] to [src]"))

	if(href_list[VV_HK_TRIGGER_EXPLOSION])
		return SSadmin_verbs.dynamic_invoke_verb(usr, /datum/admin_verb/admin_explosion, src)

	if(href_list[VV_HK_TRIGGER_EMP])
		return SSadmin_verbs.dynamic_invoke_verb(usr, /datum/admin_verb/admin_emp, src)

	if(href_list[VV_HK_SHOW_HIDDENPRINTS])
		if(!check_rights(R_ADMIN))
			return
		usr.client.cmd_show_hiddenprints(src)

	if(href_list[VV_HK_ARMOR_MOD])
		var/list/picker_list = list()
		var/list/armor_list = get_armor().get_rating_list()
		for (var/rating in armor_list)
			picker_list += list(list("value" = armor_list[rating], "name" = rating))

		var/list/result = present_picker(usr, "Modify armor", "Modify armor: [src]", button_1 = "Save", button_2 = "Cancel", timeout = FALSE, input_type = "text", values = picker_list)
		if(!islist(result))
			return
		if(result["button"] == 2) // If the user pressed the cancel button
			return

		var/list/armor_all = ARMOR_LIST_ALL
		// text2num conveniently returns a null on invalid values
		var/list/converted = list()
		for(var/armor_key in armor_all)
			converted[armor_key] = text2num(result["values"][armor_key])
		set_armor(get_armor().generate_new_with_specific(converted))

		var/message = "[key_name(usr)] modified the armor on [src] ([type]) to: "
		for(var/armor_key in armor_all)
			message += "[armor_key]=[get_armor_rating(armor_key)],"
		message = copytext(message, 1, -1)
		log_admin(span_notice(message))
		message_admins(span_notice(message))

	if(href_list[VV_HK_ADD_AI])
		var/result = tgui_input_list(usr, LANG("atom.640de2a9789f45be", null), LANG("atom.fff81a5e17e1c0ba", null), sort_list(subtypesof(/datum/ai_controller), GLOBAL_PROC_REF(cmp_typepaths_asc)))
		if(result)
			ai_controller = new result(src)

	if(href_list[VV_HK_MODIFY_TRANSFORM])
		var/result = input(usr, LANG("atom.87afafb85017fc9a", null),LANG("atom.502f20827e2d9f5c", null)) as null|anything in list("Scale","Translate","Rotate","Shear")
		var/matrix/M = transform
		if(!result)
			return
		switch(result)
			if("Scale")
				var/x = input(usr, LANG("atom.53fee51eba3750b6", null),LANG("atom.502f20827e2d9f5c", null)) as null|num
				var/y = input(usr, LANG("atom.d8cf59895fb198fd", null),LANG("atom.502f20827e2d9f5c", null)) as null|num
				if(isnull(x) || isnull(y))
					return
				transform = M.Scale(x,y)
			if("Translate")
				var/x = input(usr, LANG("atom.ef5f1db9a3653d80", null),LANG("atom.502f20827e2d9f5c", null)) as null|num
				var/y = input(usr, LANG("atom.0163f037773e8390", null),LANG("atom.502f20827e2d9f5c", null)) as null|num
				if(isnull(x) || isnull(y))
					return
				transform = M.Translate(x,y)
			if("Shear")
				var/x = input(usr, LANG("atom.53fee51eba3750b6", null),LANG("atom.502f20827e2d9f5c", null)) as null|num
				var/y = input(usr, LANG("atom.d8cf59895fb198fd", null),LANG("atom.502f20827e2d9f5c", null)) as null|num
				if(isnull(x) || isnull(y))
					return
				transform = M.Shear(x,y)
			if("Rotate")
				var/angle = input(usr, LANG("atom.0b9647f12d1e9115", null),LANG("atom.502f20827e2d9f5c", null)) as null|num
				if(isnull(angle))
					return
				transform = M.Turn(angle)
		SEND_SIGNAL(src, COMSIG_ATOM_VV_MODIFY_TRANSFORM)

	if(href_list[VV_HK_SPIN_ANIMATION])
		var/num_spins = input(usr, LANG("atom.548a341c4956beb9", null), LANG("atom.4979cc623c111693", null)) in list("Yes", "No")
		if(num_spins == "No")
			num_spins = input(usr, LANG("atom.7cdbbbf8bf70b2f3", null), LANG("atom.4979cc623c111693", null)) as null|num
		else
			num_spins = -1
		if(!num_spins)
			return
		var/spins_per_sec = input(usr, LANG("atom.7e3529c034285002", null), LANG("atom.4979cc623c111693", null)) as null|num
		if(!spins_per_sec)
			return
		var/direction = input(usr, LANG("atom.0b76de35fa4613b1", null), LANG("atom.4979cc623c111693", null)) in list("Clockwise", "Counter-clockwise")
		switch(direction)
			if("Clockwise")
				direction = 1
			if("Counter-clockwise")
				direction = 0
			else
				return
		SpinAnimation(1 SECONDS / spins_per_sec, num_spins, direction)

	if(href_list[VV_HK_STOP_ALL_ANIMATIONS])
		// Critical: Needs to be accessible in case of animation spam breaking shit
		// Do not TGUIfy
		var/result = input(usr, LANG("atom.773441628de640b4", null), LANG("atom.aa79af7e71ee3093", null)) in list("Yes", "No")
		if(result == "Yes")
			animate(src, transform = null, flags = ANIMATION_END_NOW) // Literally just fucking stop animating entirely because admin said so
		return

	if(href_list[VV_HK_AUTO_RENAME])
		var/newname = input(usr, LANG("atom.04b1bd5bd5140e8d", null), LANG("atom.19468889a14b0a8a", null)) as null|text
		// Check the new name against the chat filter. If it triggers the IC chat filter, give an option to confirm.
		if(newname && !(is_ic_filtered(newname) || is_soft_ic_filtered(newname) && tgui_alert(usr, LANG("atom.9b4d40a4361fec9f", null), LANG("atom.fc9f6a2c02e9e4c4", null), list("Confirm", "Cancel")) != "Confirm"))
			vv_auto_rename(newname)

	if(href_list[VV_HK_EDIT_FILTERS])
		usr.client?.open_filter_editor(src)

	if(href_list[VV_HK_EDIT_COLOR_MATRIX])
		usr.client?.open_color_matrix_editor(src)

	if(href_list[VV_HK_TEST_MATRIXES])
		usr.client?.open_matrix_tester(src)

	if(href_list[VV_HK_DOWNLOAD_SPRITE])
		var/icon/target_icon = getFlatIcon(src)
		usr << ftp(target_icon, "[name].png")

/atom/vv_get_header()
	. = ..()
	var/refid = REF(src)
	. += "[VV_HREF_TARGETREF(refid, VV_HK_AUTO_RENAME, "<b id='name'>[src]</b>")]"
	. += "<br><font size='1'><a href='byond://?_src_=vars;[HrefToken()];rotatedatum=[refid];rotatedir=left'><<</a> <a href='byond://?_src_=vars;[HrefToken()];datumedit=[refid];varnameedit=dir' id='dir'>[dir2text(dir) || dir]</a> <a href='byond://?_src_=vars;[HrefToken()];rotatedatum=[refid];rotatedir=right'>>></a></font>"

/**
 * call back when a var is edited on this atom
 *
 * Can be used to implement special handling of vars
 *
 * At the atom level, if you edit a var named "color" it will add the atom colour with
 * admin level priority to the atom colours list
 *
 * Also, if GLOB.debugging_enabled is FALSE, it sets the [ADMIN_SPAWNED_1] flag on [flags_1][/atom/var/flags_1], which signifies
 * the object has been admin edited
 */
/atom/vv_edit_var(var_name, var_value)
	var/old_light_flags = light_flags
	// Disable frozen lights for now, so we can actually modify it
	light_flags &= ~LIGHT_FROZEN
	switch(var_name)
		if(NAMEOF(src, light_range))
			if(light_system == COMPLEX_LIGHT)
				set_light(l_range = var_value)
			else
				set_light_range(var_value)
			. = TRUE
		if(NAMEOF(src, light_power))
			if(light_system == COMPLEX_LIGHT)
				set_light(l_power = var_value)
			else
				set_light_power(var_value)
			. = TRUE
		if(NAMEOF(src, light_color))
			if(light_system == COMPLEX_LIGHT)
				set_light(l_color = var_value)
			else
				set_light_color(var_value)
			. = TRUE
		if(NAMEOF(src, light_angle))
			if(light_system == COMPLEX_LIGHT)
				set_light(l_angle = var_value)
				. = TRUE
		if(NAMEOF(src, light_dir))
			if(light_system == COMPLEX_LIGHT)
				set_light(l_dir = var_value)
				. = TRUE
		if(NAMEOF(src, light_height))
			if(light_system == COMPLEX_LIGHT)
				set_light(l_height = var_value)
				. = TRUE
		if(NAMEOF(src, light_on))
			if(light_system == COMPLEX_LIGHT)
				set_light(l_on = var_value)
			else
				set_light_on(var_value)
			. = TRUE
		if(NAMEOF(src, light_flags))
			set_light_flags(var_value)
			// I'm sorry
			old_light_flags = var_value
			. = TRUE
		if(NAMEOF(src, light_render_source))
			set_light_render_source(var_value)
			. = TRUE
		if(NAMEOF(src, light_angle))
			if(light_system == COMPLEX_LIGHT)
				set_light(l_angle = var_value)
			else
				set_light_angle(var_value)
			. = TRUE
		if(NAMEOF(src, light_dir))
			if(light_system == COMPLEX_LIGHT)
				set_light(l_dir = var_value)
			else
				set_light_dir(var_value)
			. = TRUE
		if(NAMEOF(src, light_height))
			if(light_system == COMPLEX_LIGHT)
				set_light(l_height = var_value)
			else
				set_light_height(var_value)
			. = TRUE
		if(NAMEOF(src, smoothing_junction))
			set_smoothed_icon_state(var_value)
			. = TRUE
		if(NAMEOF(src, opacity))
			set_opacity(var_value)
			. = TRUE
		if(NAMEOF(src, base_pixel_x))
			set_base_pixel_x(var_value)
			. = TRUE
		if(NAMEOF(src, base_pixel_y))
			set_base_pixel_y(var_value)
			. = TRUE
		if(NAMEOF(src, material_flags))
			toggle_material_flags(var_value)
			. = TRUE
		if(NAMEOF(src, material_modifier))
			change_material_modifier(var_value)
			. = TRUE

	light_flags = old_light_flags
	if(!isnull(.))
		datum_flags |= DF_VAR_EDITED
		return

	if(!GLOB.debugging_enabled)
		flags_1 |= ADMIN_SPAWNED_1

	. = ..()

	switch(var_name)
		if(NAMEOF(src, color))
			add_atom_colour(color, ADMIN_COLOUR_PRIORITY)
			update_appearance()

/atom/proc/vv_auto_rename(newname)
	name = newname
