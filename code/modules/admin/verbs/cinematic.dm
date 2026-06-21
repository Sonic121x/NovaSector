ADMIN_VERB(cinematic, R_FUN, "Cinematic", "Show a cinematic to all players.", ADMIN_CATEGORY_FUN)
	var/datum/cinematic/choice = tgui_input_list(
		user,
		"选择一个过场动画播放给服务器上的所有人。",
		"选择过场动画",
		sort_list(subtypesof(/datum/cinematic), GLOBAL_PROC_REF(cmp_typepaths_asc)),
	)
	if(!choice || !ispath(choice, /datum/cinematic))
		return
	play_cinematic(choice, world)
