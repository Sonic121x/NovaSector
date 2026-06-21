ADMIN_VERB(map_template_load, R_DEBUG, "Map Template - Place", "Place a map template at your current location.", ADMIN_CATEGORY_DEBUG)
	var/datum/map_template/template
	var/map = tgui_input_list(user, "选择一个地图模板放置在你当前位置","放置地图模板", sort_list(SSmapping.map_templates))
	if(!map)
		return
	template = SSmapping.map_templates[map]

	var/turf/T = get_turf(user.mob)
	if(!T)
		return

	var/list/preview = list()
	var/center
	var/centeralert = tgui_alert(user,"居中模板。","模板居中",list("Yes","No"))
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
	if(tgui_alert(user,"确认位置。","模板确认",list("Yes","No")) == "Yes")
		if(template.load(T, centered = center))
			var/affected = template.get_affected_turfs(T, centered = center)
			for(var/AT in affected)
				for(var/obj/docking_port/mobile/P in AT)
					if(istype(P, /obj/docking_port/mobile))
						template.post_load(P)
						break

			message_admins(span_adminnotice("[key_name_admin(user)] 在 [template.name] 放置了一个地图模板（[ADMIN_COORDJMP(T)]）"))
		else
			to_chat(user, "放置地图失败", confidential = TRUE)
	user.images -= preview

ADMIN_VERB(map_template_upload, R_DEBUG, "Map Template - Upload", "Upload a map template to the server.", ADMIN_CATEGORY_DEBUG)
	var/map = input(user, "选择一个地图模板上传到模板存储","上传地图模板") as null|file
	if(!map)
		return
	if(copytext("[map]", -4) != ".dmm")//4 == length(".dmm")
		to_chat(user, span_warning("Filename must end in '.dmm': [map]"), confidential = TRUE)
		return
	var/datum/map_template/M
	switch(tgui_alert(user, "这是什么类型的地图？", "地图类型", list("Normal", "Shuttle", "Cancel")))
		if("Normal")
			M = new /datum/map_template(map, "[map]", TRUE)
		if("Shuttle")
			M = new /datum/map_template/shuttle(map, "[map]", TRUE)
		else
			return
	if(!M.cached_map)
		to_chat(user, span_warning("地图模板'[map]'解析失败。"), confidential = TRUE)
		return

	var/datum/map_report/report = M.cached_map.check_for_errors()
	var/report_link
	if(report)
		report.show_to(user)
		report_link = " - <a href='byond://?src=[REF(report)];[HrefToken(forceGlobal = TRUE)];show=1'>validation report</a>"
		to_chat(user, span_warning("Map template '[map]' <a href='byond://?src=[REF(report)];[HrefToken()];show=1'>failed validation</a>."), confidential = TRUE)
		if(report.loadable)
			var/response = tgui_alert(user, "地图验证失败，你仍要加载它吗？", "地图错误", list("Cancel", "Upload Anyways"))
			if(response != "Upload Anyways")
				return
		else
			tgui_alert(user, "地图验证失败，无法加载。", "地图错误", list("Oh Darn"))
			return

	SSmapping.map_templates[M.name] = M
	message_admins(span_adminnotice("[key_name_admin(user)] 上传了地图模板 '[map]' ([M.width]x[M.height])[report_link]。"))
	to_chat(user, span_notice("地图模板 '[map]' 已准备放置 ([M.width]x[M.height])"), confidential = TRUE)
