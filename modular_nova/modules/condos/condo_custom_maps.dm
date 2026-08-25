/*
 * Admin (R_ADMIN) custom condo maps.
 *
 * An admin uploads a .dmm (max 40x40 tiles) and picks:
 *   - Private: load it once and step in. Not added to the picker list.
 *   - Public:  render its preview, then add it to the condo picker for the rest of the round
 *              so anyone can create/enter it. It is NOT listed until the preview rendered.
 *
 * The map must use /area/misc/condo (and a hoteldoor) like the built-in condos, otherwise the
 * room won't link up properly (we bail gracefully instead of runtiming - see link_condo_turfs).
 * Custom maps live only for the current round.
 */

/// Bumped per upload so each custom map gets a unique preview asset name.
GLOBAL_VAR_INIT(condo_custom_map_counter, 0)

/// Set on admin-uploaded templates so every load forces its tiles into /area/misc/condo (admins
/// don't have to set the area themselves).
/datum/map_template/condo/var/force_condo_area = FALSE

/// Moves every reserved tile into a fresh /area/misc/condo so the room links up correctly.
/proc/condo_force_areas(datum/turf_reservation/condo/reservation)
	if(!reservation)
		return
	var/area/misc/condo/new_area = new
	for(var/turf/room_turf as anything in reservation.reserved_turfs)
		room_turf.change_area(get_area(room_turf), new_area)

ADMIN_VERB(condo_upload_map, R_ADMIN, "公寓 - 上传自定义地图", "Upload a custom condo map (max 40x40), public or private.", ADMIN_CATEGORY_FUN)
	var/map_file = input(user.mob, LANG("datum.d04ed595ff6aff7c", null), LANG("datum.b4a6d63f05b6223f", null)) as null|file
	if(!map_file)
		return
	if(copytext("[map_file]", -4) != ".dmm")
		to_chat(user, span_warning(LANG("datum.de8dc092c573c978", null)), confidential = TRUE)
		return
	var/map_name = tgui_input_text(user.mob, LANG("datum.a2124513112abfce", null), LANG("datum.dafdbcd7acf9b1a9", null), "Custom Condo", max_length = 42)
	if(!map_name)
		return

	// parse + measure the map (cache = TRUE keeps the parsed map so we can load it from memory)
	var/datum/map_template/condo/custom = new(map_file, map_name, TRUE)
	if(!custom.cached_map)
		to_chat(user, span_warning(LANG("datum.ea19df3ccda18b07", null)), confidential = TRUE)
		qdel(custom)
		return
	if(custom.width > 40 || custom.height > 40)
		to_chat(user, span_warning(LANG("datum.822e669ccdee2c7b", list(custom.width, custom.height))), confidential = TRUE)
		qdel(custom)
		return

	custom.keep_cached_map = TRUE // the uploaded file won't stick around, so load from memory
	// let the admin choose where players land (1 = bottom-left corner); default to the map center
	var/land_x = tgui_input_number(user.mob, LANG("datum.511666048ece6548", list(custom.width)), LANG("datum.7015ed0d22b0cdab", null), clamp(round(custom.width / 2), 1, custom.width), custom.width, 1)
	var/land_y = tgui_input_number(user.mob, LANG("datum.106cbaf1f29e9e96", list(custom.height)), LANG("datum.7015ed0d22b0cdab", null), clamp(round(custom.height / 2), 1, custom.height), custom.height, 1)
	custom.landing_zone_x_offset = (isnull(land_x) ? round(custom.width / 2) : land_x - 1)
	custom.landing_zone_y_offset = (isnull(land_y) ? round(custom.height / 2) : land_y - 1)
	GLOB.condo_custom_map_counter++
	custom.mappath = "custom_condo_[GLOB.condo_custom_map_counter].dmm" // fake path, only names the preview asset
	custom.force_condo_area = TRUE // we'll set the areas to condo on load, the admin doesn't have to

	// load it once to confirm it has a condo door + that it loads, fixing its areas in the process
	if(!condo_validate_custom_map(custom, user))
		qdel(custom)
		return

	switch(tgui_alert(user.mob, LANG("datum.4c12f873a599e04d", null), LANG("datum.272a8164645d479f", list(map_name, custom.width, custom.height)), list("Public", "Private", "Cancel")))
		if("Public")
			// render the preview FIRST - only add it to the picker once that worked
			var/icon/photo = SScondos.photograph_interior(custom)
			if(!photo)
				to_chat(user, span_warning(LANG("datum.f09ab6088e79abe5", null)), confidential = TRUE)
				qdel(custom)
				return
			var/asset_name = condo_preview_asset_name(custom.mappath)
			var/datum/asset/simple/condo_previews/preview_assets = get_asset_datum(/datum/asset/simple/condo_previews)
			preview_assets.assets[asset_name] = SSassets.transport.register_asset(asset_name, fcopy_rsc(photo))
			// url mappings are cached on first use (with round-start previews); drop the cache so the
			// next teleporter open rebuilds it and clients can resolve this new preview
			preview_assets.cached_serialized_url_mappings = null
			// a map with the same name replaces the previous upload (override)
			var/overwrote = !isnull(SScondos.condo_templates[custom.name])
			SScondos.condo_templates[custom.name] = custom
			log_admin("[key_name(user)] [overwrote ? "overwrote" : "published"] a PUBLIC custom condo map '[custom.name]' ([custom.width]x[custom.height]).")
			message_admins("[key_name_admin(user)] [overwrote ? "overwrote" : "published"] a PUBLIC custom condo map '[custom.name]' ([custom.width]x[custom.height]).")
			to_chat(user, span_notice(LANG("datum.fc6246b43e7c9510", list(overwrote ? "Overwrote" : "Published", custom.name))), confidential = TRUE)
		if("Private")
			var/datum/condo_room/room = SScondos.create_room(custom, user.mob, null, custom.name, TRUE, null)
			if(!room)
				to_chat(user, span_warning(LANG("datum.354c2fc2d52ee684", null)), confidential = TRUE)
				qdel(custom)
				return
			log_admin("[key_name(user)] loaded a PRIVATE custom condo map '[custom.name]' ([custom.width]x[custom.height]).")
			message_admins("[key_name_admin(user)] loaded a PRIVATE custom condo map '[custom.name]' ([custom.width]x[custom.height]).")
		else
			qdel(custom)

/// Loads the template once into a temp reservation to confirm it loads + has a condo door, fixes
/// its areas in the process, then frees it. Returns TRUE if it's usable.
/proc/condo_validate_custom_map(datum/map_template/condo/template, user)
	var/datum/turf_reservation/condo/check = SSmapping.request_turf_block_reservation(template.width, template.height, 1, reservation_type = /datum/turf_reservation/condo)
	if(!check)
		return FALSE
	var/turf/bottom_left = check.bottom_left_turfs[1]
	if(!bottom_left)
		qdel(check)
		return FALSE
	template.load(bottom_left)
	if(template.force_condo_area)
		condo_force_areas(check)
	var/turf/landing = locate(bottom_left.x + template.landing_zone_x_offset, bottom_left.y + template.landing_zone_y_offset, bottom_left.z)
	var/landing_blocked = (!landing || landing.density)
	var/has_door = FALSE
	for(var/turf/closed/indestructible/hoteldoor/door in check.reserved_turfs)
		has_door = TRUE
		break
	qdel(check)
	if(!has_door)
		to_chat(user, span_warning(LANG("_root.ea5a697a9e2024a0", null)), confidential = TRUE)
		return FALSE
	if(landing_blocked)
		to_chat(user, span_warning(LANG("_root.dc563a76fe0c36a1", null)), confidential = TRUE)
	return TRUE
