// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/buildmode_mode/area_edit
	key = "areaedit"
	use_corner_selection = TRUE
	var/area/storedarea
	var/image/areaimage

/datum/buildmode_mode/area_edit/New()
	areaimage = image('icons/area/areas_misc.dmi', null, "yellow")
	..()

/datum/buildmode_mode/area_edit/show_help(client/builder)
	to_chat(builder, span_purple(boxed_message(
		LANG("datum.0f192544bad83f55", list(span_bold("Select corner"), span_bold("Paint area"), span_bold("Select area to paint"), span_bold("Create new area")))))
	)

/datum/buildmode_mode/area_edit/enter_mode(datum/buildmode/BM)
	BM.holder.images += areaimage

/datum/buildmode_mode/area_edit/exit_mode(datum/buildmode/BM)
	areaimage.loc = null // de-color the area
	BM.holder.images -= areaimage
	return ..()

/datum/buildmode_mode/area_edit/Destroy()
	QDEL_NULL(areaimage)
	storedarea = null
	return ..()

/datum/buildmode_mode/area_edit/change_settings(client/c)
	var/target_path = input(c, LANG("datum.d60ae892d7e29eb6", null), LANG("datum.1a01b0f5ae81d070", null), "/area")
	var/areatype = text2path(target_path)
	if(ispath(areatype,/area))
		var/areaname = input(c, LANG("datum.a7bfd1f186807538", null), LANG("datum.355bff783e48031a", null), "Area")
		if(!areaname || !length(areaname))
			return
		storedarea = new areatype
		storedarea.power_equip = 0
		storedarea.power_light = 0
		storedarea.power_environ = 0
		storedarea.always_unpowered = 0
		storedarea.name = areaname
		areaimage.loc = storedarea // color our area

/datum/buildmode_mode/area_edit/handle_click(client/c, params, object)
	var/list/modifiers = params2list(params)

	if(LAZYACCESS(modifiers, LEFT_CLICK))
		if(!storedarea)
			to_chat(c, span_warning(LANG("datum.7b6c0cc20bd7474a", null)))
			return
		if(LAZYACCESS(modifiers, ALT_CLICK))
			var/turf/T = get_turf(object)
			if(get_area(T) != storedarea)
				log_admin("Build Mode: [key_name(c)] added [AREACOORD(T)] to [storedarea]")
				storedarea.contents.Add(T)
			return
		return ..()
	else if(LAZYACCESS(modifiers, RIGHT_CLICK))
		var/turf/T = get_turf(object)
		storedarea = get_area(T)
		areaimage.loc = storedarea // color our area

/datum/buildmode_mode/area_edit/handle_selected_area(client/c, params)
	var/list/modifiers = params2list(params)

	if(LAZYACCESS(modifiers, LEFT_CLICK))
		var/choice = alert(LANG("datum.9ecddd9e9b26ab4a", null), LANG("datum.e681f2d95e0a70f8", null), "Yes", "No")
		if(choice != "Yes")
			return
		for(var/turf/T in block(get_turf(cornerA),get_turf(cornerB)))
			storedarea.contents.Add(T)
		log_admin("Build Mode: [key_name(c)] set the area of the region from [AREACOORD(cornerA)] through [AREACOORD(cornerB)] to [storedarea].")

