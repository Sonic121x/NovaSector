// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
#define FILL_WARNING_MIN 150

/datum/buildmode_mode/fill
	key = "fill"

	use_corner_selection = TRUE
	var/atom/objholder = null

/datum/buildmode_mode/fill/show_help(client/builder)
	to_chat(builder, span_purple(boxed_message(
		LANG("datum.57fc8fe766c2cf3e", list(span_bold("Select corner"), span_bold("Delete region"), span_bold("Select object type")))))
	)

/datum/buildmode_mode/fill/change_settings(client/c)
	var/target_path = input(c, LANG("datum.d60ae892d7e29eb6", null) ,LANG("datum.1a01b0f5ae81d070", null),"/obj/structure/closet")
	objholder = text2path(target_path)
	if(!ispath(objholder))
		objholder = pick_closest_path(target_path)
		if(!objholder)
			tgui_alert(usr,LANG("datum.1eb7594a88c7d4b0", null))
			return
		else if(ispath(objholder, /area))
			objholder = null
			tgui_alert(usr,LANG("datum.aa137c6eecbe258c", null))
			return
	BM.preview_selected_item(objholder)
	deselect_region()

/datum/buildmode_mode/fill/handle_click(client/c, params, obj/object)
	if(isnull(objholder))
		to_chat(c, span_warning(LANG("datum.7c68ae630fafd7d5", null)))
		deselect_region()
		return
	..()

/datum/buildmode_mode/fill/handle_selected_area(client/c, params)
	var/list/modifiers = params2list(params)

	if(LAZYACCESS(modifiers, LEFT_CLICK)) //rectangular
		if(LAZYACCESS(modifiers, ALT_CLICK))
			var/list/deletion_area = block(get_turf(cornerA),get_turf(cornerB))
			for(var/beep in deletion_area)
				var/turf/T = beep
				for(var/atom/movable/AM in T)
					qdel(AM)
				// extreme haircut
				T.ScrapeAway(INFINITY, CHANGETURF_DEFER_CHANGE)
			for(var/beep in deletion_area)
				var/turf/T = beep
				T.AfterChange()
			log_admin("Build Mode: [key_name(c)] deleted turfs from [AREACOORD(cornerA)] through [AREACOORD(cornerB)]")
			// if there's an analogous proc for this on tg lmk
			// empty_region(block(get_turf(cornerA),get_turf(cornerB)))
		else
			var/selection_size = abs(cornerA.x - cornerB.x) * abs(cornerA.y - cornerB.y)

			if(selection_size > FILL_WARNING_MIN) // Confirm fill if the number of tiles in the selection is greater than FILL_WARNING_MIN
				var/choice = tgui_alert(usr,LANG("datum.ed54b6cddab3289a", list(selection_size)), LANG("datum.a1e2eebcdf49dee3", null), list("Yes", "No"))
				if(choice != "Yes")
					return

			for(var/turf/T in block(get_turf(cornerA),get_turf(cornerB)))
				if(ispath(objholder,/turf))
					T = T.ChangeTurf(objholder)
					T.setDir(BM.build_dir)
				else if(ispath(objholder, /obj/effect/turf_decal))
					T.AddElement(/datum/element/decal, initial(objholder.icon), initial(objholder.icon_state), BM.build_dir, null, null, initial(objholder.alpha), initial(objholder.color), null, FALSE, null)
				else
					var/obj/A = new objholder(T)
					A.setDir(BM.build_dir)
			log_admin("Build Mode: [key_name(c)] with path [objholder], filled the region from [AREACOORD(cornerA)] through [AREACOORD(cornerB)]")

#undef FILL_WARNING_MIN
