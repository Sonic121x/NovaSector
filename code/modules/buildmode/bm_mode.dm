// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/// Corner A area section for buildmode
#define AREASELECT_CORNERA "corner A"
/// Corner B area selection for buildmode
#define AREASELECT_CORNERB "corner B"

/datum/buildmode_mode
	var/key = "oops"
	var/datum/buildmode/BM

	// would corner selection work better as a component?
	var/use_corner_selection = FALSE
	var/list/preview
	var/turf/cornerA
	var/turf/cornerB

/datum/buildmode_mode/New(datum/buildmode/BM)
	src.BM = BM
	preview = list()
	return ..()

/datum/buildmode_mode/Destroy()
	cornerA = null
	cornerB = null
	QDEL_LIST(preview)
	preview = null
	return ..()

/datum/buildmode_mode/proc/enter_mode(datum/buildmode/BM)
	return

/datum/buildmode_mode/proc/exit_mode(datum/buildmode/BM)
	return

/datum/buildmode_mode/proc/get_button_iconstate()
	return "buildmode_[key]"

/datum/buildmode_mode/proc/show_help(client/c)
	CRASH("No help defined, yell at a coder")

/datum/buildmode_mode/proc/change_settings(client/c)
	to_chat(c, span_warning(LANG("datum.97d59d087af39c4c", null)))
	return

/datum/buildmode_mode/proc/Reset()
	deselect_region()

/datum/buildmode_mode/proc/select_tile(turf/T, corner_to_select)
	var/overlaystate
	BM.holder.images -= preview
	switch(corner_to_select)
		if(AREASELECT_CORNERA)
			overlaystate = "greenOverlay"
		if(AREASELECT_CORNERB)
			overlaystate = "blueOverlay"

	var/image/I = image('icons/turf/overlays.dmi', T, overlaystate)
	SET_PLANE(I, ABOVE_LIGHTING_PLANE, T)
	preview += I
	BM.holder.images += preview
	return T

/datum/buildmode_mode/proc/highlight_region(region)
	BM.holder.images -= preview
	for(var/turf/member as anything in region)
		var/image/I = image('icons/turf/overlays.dmi', member, "redOverlay")
		SET_PLANE(I, ABOVE_LIGHTING_PLANE, member)
		preview += I
	BM.holder.images += preview

/datum/buildmode_mode/proc/deselect_region()
	BM.holder.images -= preview
	preview.Cut()
	cornerA = null
	cornerB = null

/datum/buildmode_mode/proc/handle_click(client/c, params, object)
	var/list/modifiers = params2list(params)
	if(use_corner_selection)
		if(LAZYACCESS(modifiers, LEFT_CLICK))
			if(!cornerA)
				cornerA = select_tile(get_turf(object), AREASELECT_CORNERA)
				return
			if(cornerA && !cornerB)
				cornerB = select_tile(get_turf(object), AREASELECT_CORNERB)
				to_chat(c, span_boldwarning(LANG("datum.24fa4ccea1cadf63", null)))
				return
			handle_selected_area(c, params)
			deselect_region()
		else
			to_chat(c, span_notice(LANG("datum.9b9431f4c9940f1d", null)))
			deselect_region()
	return

/datum/buildmode_mode/proc/handle_selected_area(client/c, params)

#undef AREASELECT_CORNERA
#undef AREASELECT_CORNERB
