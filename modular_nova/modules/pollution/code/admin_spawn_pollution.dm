ADMIN_VERB(spawn_pollution, R_ADMIN, "Spawn Pollution", "Spawns an amount of chosen pollutant at your current location.", ADMIN_CATEGORY_FUN)
	var/list/singleton_list = SSpollution.singletons
	var/choice = tgui_input_list(user, "您想生成哪种类型的污染物？", "生成污染物", singleton_list)
	if(!choice)
		return
	var/amount_choice = input("污染物数量：") as null|num
	if(!amount_choice)
		return
	var/turf/epicenter = get_turf(user.mob)
	epicenter.pollute_turf(choice, amount_choice)
	message_admins("[ADMIN_LOOKUPFLW(user)] spawned pollution at [epicenter.loc] ([choice] - [amount_choice]).")
	log_admin("[key_name(user)] spawned pollution at [epicenter.loc] ([choice] - [amount_choice]).")
