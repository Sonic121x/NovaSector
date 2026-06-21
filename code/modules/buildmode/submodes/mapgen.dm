/datum/buildmode_mode/mapgen
	key = "mapgen"

	use_corner_selection = TRUE
	var/generator_path

/datum/buildmode_mode/mapgen/show_help(client/builder)
	to_chat(builder, span_purple(boxed_message(
		"[span_bold("Select corner")] -> Left Mouse Button on turf/obj/mob\n\
		[span_bold("Select generator")] -> Right Mouse Button on buildmode button"))
	)

/datum/buildmode_mode/mapgen/change_settings(client/c)
	var/list/gen_paths = subtypesof(/datum/map_generator)
	var/list/options = list()
	for(var/path in gen_paths)
		var/datum/map_generator/MP = path
		options[initial(MP.buildmode_name)] = path
	var/type = input(c,"选择生成器类型","类型") as null|anything in options
	if(!type)
		return

	generator_path = options[type]
	deselect_region()

/datum/buildmode_mode/mapgen/handle_click(client/c, params, obj/object)
	if(isnull(generator_path))
		to_chat(c, span_warning("请先选择生成器类型。"))
		deselect_region()
		return
	..()

/datum/buildmode_mode/mapgen/handle_selected_area(client/c, params)
	var/list/modifiers = params2list(params)

	if(LAZYACCESS(modifiers, LEFT_CLICK))
		var/datum/map_generator/G = new generator_path
		if(istype(G, /datum/map_generator/repair/reload_station_map))
			if(GLOB.reloading_map)
				to_chat(c, span_boldwarning("你已经在重新加载一个区域！请等待其完全加载完毕后再尝试加载另一个！"))
				deselect_region()
				return
		G.defineRegion(cornerA, cornerB, 1)
		highlight_region(G.map)
		var/confirm = tgui_alert(usr,"你确定要运行地图生成器吗？", "运行生成器", list("Yes", "No"))
		if(confirm == "Yes")
			G.generate()
		log_admin("Build Mode: [key_name(c)] ran the map generator '[G.buildmode_name]' in the region from [AREACOORD(cornerA)] to [AREACOORD(cornerB)]")
