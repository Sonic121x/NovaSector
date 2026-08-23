// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
ADMIN_VERB(map_template_load, R_DEBUG, "地图模板 - 放置", "Place a map template at your current location.", ADMIN_CATEGORY_DEBUG)
	var/datum/map_template/template
	var/map = tgui_input_list(user, LANG("datum.df722bd148ed9cb4", null),LANG("datum.de09f2bc91e549f6", null), sort_list(SSmapping.map_templates))
	if(!map)
		return
	template = SSmapping.map_templates[map]

	var/turf/T = get_turf(user.mob)
	if(!T)
		return

	var/list/preview = list()
	var/center
	var/centeralert = tgui_alert(user,LANG("datum.e2b88a2458e9ffd9", null),LANG("datum.677defdc7fda96aa", null),list("Yes","No"))
	switch(centeralert)
		if("Yes")
			center = TRUE
		if("No")
			center = FALSE
		else
			return
	for(var/turf/place_on as anything in template.get_affected_turfs(T,centered = center))
		var/image/item = image('icons/turf/overlays.dmi', place_on,"greenOverlay")
		SET_PLANE(item, ABOVE_LIGHTING_PLANE, place_on)
		preview += item
	user.images += preview
	if(tgui_alert(user,LANG("datum.17851815cad5fd82", null),LANG("datum.03e50a993df37fd5", null),list("Yes","No")) == "Yes")
		if(template.load(T, centered = center))
			var/affected = template.get_affected_turfs(T, centered = center)
			for(var/AT in affected)
				for(var/obj/docking_port/mobile/P in AT)
					if(istype(P, /obj/docking_port/mobile))
						template.post_load(P)
						break

			message_admins(span_adminnotice("[key_name_admin(user)] has placed a map template ([template.name]) at [ADMIN_COORDJMP(T)]"))
		else
			to_chat(user, LANG("datum.88d8e3ef13b13557", null), confidential = TRUE)
	user.images -= preview

ADMIN_VERB(map_template_upload, R_DEBUG, "地图模板 - 上传", "Upload a map template to the server.", ADMIN_CATEGORY_DEBUG)
	var/map = input(user, LANG("datum.b3f7e640ddd948d9", null),LANG("datum.588f2e448c79d850", null)) as null|file
	if(!map)
		return
	if(copytext("[map]", -4) != ".dmm")//4 == length(".dmm")
		to_chat(user, span_warning(LANG("datum.9585169dfa1419a7", list(map))), confidential = TRUE)
		return
	var/datum/map_template/M
	switch(tgui_alert(user, LANG("datum.8b6cd3766a3c7cbf", null), LANG("datum.6ad9084347f79ab5", null), list("Normal", "Shuttle", "Cancel")))
		if("Normal")
			M = new /datum/map_template(map, "[map]", TRUE)
		if("Shuttle")
			M = new /datum/map_template/shuttle(map, "[map]", TRUE)
		else
			return
	if(!M.cached_map)
		to_chat(user, span_warning(LANG("datum.32977cd7d3d54631", list(map))), confidential = TRUE)
		return

	var/datum/map_report/report = M.cached_map.check_for_errors()
	var/report_link
	if(report)
		report.show_to(user)
		report_link = " - <a href='byond://?src=[REF(report)];[HrefToken(forceGlobal = TRUE)];show=1'>validation report</a>"
		to_chat(user, span_warning(LANG("datum.8c68fd5a97e97970", list(map, REF(report), HrefToken()))), confidential = TRUE)
		if(report.loadable)
			var/response = tgui_alert(user, LANG("datum.9c469de59c7d05ef", null), LANG("datum.98ed387dc4f6a7eb", null), list("Cancel", "Upload Anyways"))
			if(response != "Upload Anyways")
				return
		else
			tgui_alert(user, LANG("datum.178fb14a346c3da7", null), LANG("datum.98ed387dc4f6a7eb", null), list("Oh Darn"))
			return

	SSmapping.map_templates[M.name] = M
	message_admins(span_adminnotice("[key_name_admin(user)] has uploaded a map template '[map]' ([M.width]x[M.height])[report_link]."))
	to_chat(user, span_notice(LANG("datum.028c2e477cedde91", list(map, M.width, M.height))), confidential = TRUE)
