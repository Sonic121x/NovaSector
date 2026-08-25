// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/buildmode_mode/advanced
	key = "advanced"
	var/atom/objholder = null

/datum/buildmode_mode/advanced/show_help(client/builder)
	to_chat(builder, span_purple(boxed_message(
		LANG("datum.8e765a3fe6aacc04", list(span_bold("Set object type"), span_bold("Copy object type"), span_bold("Place objects"), span_bold("Delete objects")))))
	)

/datum/buildmode_mode/advanced/change_settings(client/c)
	var/target_path = input(c, LANG("datum.d60ae892d7e29eb6", null), LANG("datum.1a01b0f5ae81d070", null), "/obj/structure/closet")
	objholder = text2path(target_path)
	if(!ispath(objholder))
		objholder = pick_closest_path(target_path)
		if(!objholder)
			tgui_alert(usr,LANG("datum.2cd7ebeeebee9b19", null))
			return
		else if(ispath(objholder, /area))
			objholder = null
			tgui_alert(usr,LANG("datum.45653dfddec86c29", null))
			return
	BM.preview_selected_item(objholder)

/datum/buildmode_mode/advanced/handle_click(client/c, params, obj/object)
	var/list/modifiers = params2list(params)
	var/left_click = LAZYACCESS(modifiers, LEFT_CLICK)
	var/right_click = LAZYACCESS(modifiers, RIGHT_CLICK)
	var/alt_click = LAZYACCESS(modifiers, ALT_CLICK)

	if(left_click && alt_click)
		if (istype(object, /turf) || isobj(object) || istype(object, /mob))
			objholder = object.type
			to_chat(c, span_notice(LANG("datum.c79babd939db393a", list(initial(object.name), object.type))))
			BM.preview_selected_item(objholder)
		else
			to_chat(c, span_notice(LANG("datum.74987fdfe817380b", list(initial(object.name)))))
	else if(left_click)
		if(ispath(objholder,/turf))
			var/turf/T = get_turf(object)
			log_admin("Build Mode: [key_name(c)] modified [T] in [AREACOORD(object)] to [objholder]")
			T = T.ChangeTurf(objholder)
			T.setDir(BM.build_dir)
		else if(ispath(objholder, /obj/effect/turf_decal))
			var/turf/T = get_turf(object)
			T.AddElement(/datum/element/decal, initial(objholder.icon), initial(objholder.icon_state), BM.build_dir, null, null, initial(objholder.alpha), initial(objholder.color), null, FALSE, null)
			log_admin("Build Mode: [key_name(c)] in [AREACOORD(object)] added a [initial(objholder.name)] decal with dir [BM.build_dir] to [T]")
		else if(!isnull(objholder))
			var/obj/A = new objholder (get_turf(object))
			A.setDir(BM.build_dir)
			log_admin("Build Mode: [key_name(c)] modified [A]'s [COORD(A)] dir to [BM.build_dir]")
		else
			to_chat(c, span_warning(LANG("datum.9779f12d4a2d3589", null)))
	else if(right_click)
		if(isobj(object))
			log_admin("Build Mode: [key_name(c)] deleted [object] at [AREACOORD(object)]")
			// NOVA EDIT ADDITION START -- optional bluespace sparks on delete
			if(c.prefs.read_preference(/datum/preference/toggle/admin/delete_sparks))
				do_admin_sparks(10, TRUE, object) // non-interactive sparks
			// NOVA EDIT ADDITION END
			qdel(object)
