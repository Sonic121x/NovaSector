// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
// Proc taken from yogstation, credit to nichlas0010 for the original
ADMIN_VERB_AND_CONTEXT_MENU(fix_air, R_ADMIN, "修复空气", "Fixes air in a specified radius.", ADMIN_CATEGORY_GAME, turf/open/locale, range = 2 as num)
	message_admins("[key_name_admin(user)] fixed air with range [range] in area [locale.loc.name]")
	user.mob.log_message("fixed air with range [range] in area [locale.loc.name]", LOG_ADMIN)

	for(var/turf/open/valid_range_turf in range(range,locale))
		if(valid_range_turf.blocks_air)
		//skip walls
			continue
		var/datum/gas_mixture/GM = SSair.parse_gas_string(valid_range_turf.initial_gas_mix, /datum/gas_mixture/turf)
		valid_range_turf.copy_air(GM)
		valid_range_turf.temperature = initial(valid_range_turf.temperature)
		valid_range_turf.update_visuals()
		//NOVA EDIT ADDITION START
		if(valid_range_turf.pollution)
			qdel(valid_range_turf.pollution)
		//NOVA EDIT ADDITION END
