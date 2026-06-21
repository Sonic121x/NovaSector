ADMIN_VERB(admin_change_map, R_SERVER, "Change Map", "Set the next map.", ADMIN_CATEGORY_SERVER)
	var/list/maprotatechoices = list()
	for (var/map in config.maplist)
		var/datum/map_config/virtual_map = config.maplist[map]
		var/mapname = virtual_map.map_name
		if (virtual_map == config.defaultmap)
			mapname += " (Default)"

		if (virtual_map.config_min_users > 0 || virtual_map.config_max_users > 0)
			mapname += " \["
			if (virtual_map.config_min_users > 0)
				mapname += "[virtual_map.config_min_users]"
			else
				mapname += "0"
			mapname += "-"
			if (virtual_map.config_max_users > 0)
				mapname += "[virtual_map.config_max_users]"
			else
				mapname += "inf"
			mapname += "\]"

		maprotatechoices[mapname] = virtual_map
	var/chosenmap = tgui_input_list(user, "选择要切换到的地图", "Change Map-更改地图", sort_list(maprotatechoices)|"自定义")
	if (isnull(chosenmap))
		return

	if(chosenmap == "Custom")
		message_admins("[key_name_admin(user)] is changing the map to a custom map")
		log_admin("[key_name(user)] is changing the map to a custom map")
		var/datum/map_config/virtual_map = new

		var/map_file = input(user, "选择文件：", "地图文件") as null|file
		if(isnull(map_file))
			return

		if(copytext("[map_file]", -4) != ".dmm")//4 == length(".dmm")
			to_chat(user, span_warning("Filename must end in '.dmm': [map_file]"))
			return

		if(fexists("_maps/custom/[map_file]"))
			fdel("_maps/custom/[map_file]")
		if(!fcopy(map_file, "_maps/custom/[map_file]"))
			return
		// This is to make sure the map works so the server does not start without a map.
		var/datum/parsed_map/M = new (map_file)
		if(!M)
			to_chat(user, span_warning("地图 '[map_file]' 解析失败。"))
			return

		if(!M.bounds)
			to_chat(user, span_warning("地图 '[map_file]' 的边界不存在。"))
			qdel(M)
			return

		qdel(M)
		var/config_file = null
		var/list/json_value = list()
		var/config = tgui_alert(user,"您想为此地图上传额外的配置文件吗？", "地图配置", list("Yes", "No"))
		if(config == "Yes")
			config_file = input(user, "选择文件：", "配置 JSON 文件") as null|file
			if(isnull(config_file))
				return
			if(copytext("[config_file]", -5) != ".json")
				to_chat(src, span_warning("Filename must end in '.json': [config_file]"))
				return
			if(fexists("data/custom_map_json/[config_file]"))
				fdel("data/custom_map_json/[config_file]")
			if(!fcopy(config_file, "data/custom_map_json/[config_file]"))
				return

			json_value = virtual_map.LoadConfig("data/custom_map_json/[config_file]", TRUE)

			if(!json_value)
				to_chat(src, span_warning("加载配置失败: [config_file]。请检查字段是否正确填写。\"map_path\": \"custom\" 和 \"map_file\": \"your_map_name.dmm\""))
				return
		else
			virtual_map = load_map_config()
			virtual_map.map_name = input(user, "为地图选择名称", "地图名称") as null|text
			if(isnull(virtual_map.map_name))
				virtual_map.map_name = "Custom"

			var/shuttles = tgui_alert(user,"你想要修改穿梭机吗？", "地图穿梭机", list("Yes", "No"))
			if(shuttles == "Yes")
				for(var/s in virtual_map.shuttles)
					var/shuttle = input(user, s, "地图穿梭机") as null|text
					if(!shuttle)
						continue
					if(!SSmapping.shuttle_templates[shuttle])
						to_chat(user, span_warning("不存在名为 '[shuttle]' 的穿梭机，使用默认值。"))
						continue
					virtual_map.shuttles[s] = shuttle

			json_value = list(
				"version" = MAP_CURRENT_VERSION,
				"map_name" = virtual_map.map_name,
				"map_path" = CUSTOM_MAP_PATH,
				"map_file" = "[map_file]",
				"shuttles" = virtual_map.shuttles,
			)

		// If the file isn't removed text2file will just append.
		if(fexists(PATH_TO_NEXT_MAP_JSON))
			fdel(PATH_TO_NEXT_MAP_JSON)
		text2file(json_encode(json_value), PATH_TO_NEXT_MAP_JSON)

		if(SSmap_vote.set_next_map(virtual_map))
			message_admins("[key_name_admin(user)] has changed the map to [virtual_map.map_name]")
			SSmap_vote.admin_override = TRUE
		fdel("data/custom_map_json/[config_file]")
	else
		var/datum/map_config/virtual_map = maprotatechoices[chosenmap]
		message_admins("[key_name_admin(user)] is changing the map to [virtual_map.map_name]")
		log_admin("[key_name(user)] is changing the map to [virtual_map.map_name]")
		if (SSmap_vote.set_next_map(virtual_map))
			message_admins("[key_name_admin(user)] has changed the map to [virtual_map.map_name]")
			SSmap_vote.admin_override = TRUE

ADMIN_VERB(admin_revert_map, R_SERVER, "Revert Map Vote", "Revert the map vote, allowing a new vote.", ADMIN_CATEGORY_SERVER)
	SSmap_vote.revert_next_map(user)
