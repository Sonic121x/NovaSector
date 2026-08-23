ADMIN_VERB(spawn_pollution, R_ADMIN, "生成污染", "Spawns an amount of chosen pollutant at your current location.", ADMIN_CATEGORY_FUN)
	var/list/singleton_list = SSpollution.singletons
	var/choice = tgui_input_list(user, LANG("datum.4231e79010cd62d3", null), LANG("datum.306e67cffa2fc4d1", null), singleton_list)
	if(!choice)
		return
	var/amount_choice = input(LANG("datum.1d1b0f4fbe496800", null)) as null|num
	if(!amount_choice)
		return
	var/turf/epicenter = get_turf(user.mob)
	epicenter.pollute_turf(choice, amount_choice)
	message_admins("[ADMIN_LOOKUPFLW(user)] spawned pollution at [epicenter.loc] ([choice] - [amount_choice]).")
	log_admin("[key_name(user)] spawned pollution at [epicenter.loc] ([choice] - [amount_choice]).")
