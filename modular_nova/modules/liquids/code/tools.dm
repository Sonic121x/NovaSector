ADMIN_VERB(spawn_liquid, R_ADMIN, "生成液体", "Spawns an amount of chosen liquid at your current location.", ADMIN_CATEGORY_FUN)
	var/choice
	var/valid_id
	while(!valid_id)
		choice = tgui_input_text(user, LANG("datum.d4cf7df6", null), LANG("datum.13046490", null), max_length = MAX_NAME_LEN)
		if(isnull(choice)) //Get me out of here!
			break
		if (!ispath(text2path(choice)))
			choice = pick_closest_path(choice, make_types_fancy(subtypesof(/datum/reagent)))
			if (ispath(choice))
				valid_id = TRUE
		else
			valid_id = TRUE
		if(!valid_id)
			to_chat(user, span_warning(LANG("datum.66e644d8", null)))
	if(!choice)
		return
	var/volume = tgui_input_number(user, LANG("datum.a2039dea", null), LANG("datum.6fe23489", null))
	if(!volume)
		return
	var/turf/epicenter = get_turf(user.mob)
	epicenter.add_liquid(choice, volume)
	message_admins("[ADMIN_LOOKUPFLW(user)] spawned liquid at [epicenter.loc] ([choice] - [volume]).")
	log_admin("[key_name(user)] spawned liquid at [epicenter.loc] ([choice] - [volume]).")

ADMIN_VERB_AND_CONTEXT_MENU(remove_liquid, R_ADMIN, "移除液体", "Removes all liquids in specified radius.", ADMIN_CATEGORY_GAME, /turf)
	VERB_ARG_TYPED(epicenter, VERB_ARG_TYPE_TURF, VERB_ARG_SOURCE_WORLD, /turf)
	var/range = tgui_input_number(user, LANG("datum.55b07550", null), LANG("datum.bc37ad53", null), 2)

	for(var/obj/effect/abstract/liquid_turf/liquid in range(range, epicenter))
		qdel(liquid, TRUE)

	message_admins("[key_name_admin(user)] removed liquids with range [range] in [epicenter.loc.name]")
	log_game("[key_name_admin(user)] removed liquids with range [range] in [epicenter.loc.name]")
