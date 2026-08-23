// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/buildmode_mode/basic
	key = "basic"

/datum/buildmode_mode/basic/show_help(client/builder)
	to_chat(builder, span_purple(boxed_message(
		LANG("datum.66c5e0c1b2770635", list(span_bold("Construct / Upgrade"), span_bold("Deconstruct / Delete / Downgrade"), span_bold("R-Window"), span_bold("Airlock")))))
	)

/datum/buildmode_mode/basic/handle_click(client/c, params, obj/object)
	var/list/modifiers = params2list(params)

	var/left_click = LAZYACCESS(modifiers, LEFT_CLICK)
	var/right_click = LAZYACCESS(modifiers, RIGHT_CLICK)
	var/alt_click = LAZYACCESS(modifiers, ALT_CLICK)
	var/ctrl_click = LAZYACCESS(modifiers, CTRL_CLICK)

	if(istype(object,/turf) && left_click && !alt_click && !ctrl_click)
		var/turf/clicked_turf = object
		if(isplatingturf(object))
			clicked_turf.place_on_top(/turf/open/floor/iron, flags = CHANGETURF_INHERIT_AIR)
		else if(isfloorturf(object))
			clicked_turf.place_on_top(/turf/closed/wall)
		else if(iswallturf(object))
			clicked_turf.place_on_top(/turf/closed/wall/r_wall)
		else
			clicked_turf.place_on_top(/turf/open/floor/plating, flags = CHANGETURF_INHERIT_AIR) // Gotta do something
		log_admin("Build Mode: [key_name(c)] built [clicked_turf] at [AREACOORD(clicked_turf)]")
		return
	else if(right_click)
		log_admin("Build Mode: [key_name(c)] deleted [object] at [AREACOORD(object)]")
		if(isturf(object))
			var/turf/T = object
			T.ScrapeAway(flags = CHANGETURF_INHERIT_AIR)
		else if(isobj(object))
			// NOVA EDIT ADDITION START -- optional bluespace sparks on delete
			if(c.prefs.read_preference(/datum/preference/toggle/admin/delete_sparks))
				do_admin_sparks(10, TRUE, object) // non-interactive sparks
			// NOVA EDIT ADDITION END
			qdel(object)
		return
	else if(istype(object,/turf) && alt_click && left_click)
		log_admin("Build Mode: [key_name(c)] built an airlock at [AREACOORD(object)]")
		new/obj/machinery/door/airlock(get_turf(object))
	else if(istype(object,/turf) && ctrl_click && left_click)
		var/obj/structure/window/reinforced/window
		if(BM.build_dir in GLOB.diagonals)
			window = new /obj/structure/window/reinforced/fulltile(get_turf(object))
		else
			window = new /obj/structure/window/reinforced(get_turf(object))
			window.setDir(BM.build_dir)
		log_admin("Build Mode: [key_name(c)] built a window at [AREACOORD(object)]")
