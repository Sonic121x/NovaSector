// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md

#define STEALTH_MODE_TRAIT "stealth_mode"

/client/proc/add_admin_verbs()
	control_freak = CONTROL_FREAK_SKIN | CONTROL_FREAK_MACROS
	SSadmin_verbs.assosciate_admin(src)

/client/proc/remove_admin_verbs()
	control_freak = initial(control_freak)
	SSadmin_verbs.deassosciate_admin(src)

ADMIN_VERB(hide_verbs, R_NONE, "管理员命令 - 全部隐藏", "Hide most of your admin verbs.", ADMIN_CATEGORY_MAIN)
	user.remove_admin_verbs()
	ASSIGN_GAME_VERB(user, /client, show_verbs)

	to_chat(user, span_interface(LANG("datum.d0317d5bc2e06168", null)), confidential = TRUE)
	BLACKBOX_LOG_ADMIN_VERB("Hide All Adminverbs")

ADMIN_VERB(admin_ghost, R_ADMIN, "管理员幽灵", "Become a ghost without DNR.", ADMIN_CATEGORY_GAME)
	. = TRUE
	if(isobserver(user.mob))
		//re-enter
		var/mob/dead/observer/ghost = user.mob
		if(!ghost.mind || !ghost.mind.current) //won't do anything if there is no body
			return FALSE
		if(!ghost.can_reenter_corpse)
			log_admin("[key_name(user)] re-entered corpse")
			message_admins("[key_name_admin(user)] re-entered corpse")
		ghost.can_reenter_corpse = 1 //force re-entering even when otherwise not possible
		ghost.reenter_corpse()
		BLACKBOX_LOG_ADMIN_VERB("Admin Reenter")
	else if(isnewplayer(user.mob))
		to_chat(user, span_warning(LANG("datum.fe41dab40761c6bd", null)), confidential = TRUE)
		return FALSE
	else
		//ghostize
		log_admin("[key_name(user)] admin ghosted.")
		message_admins("[key_name_admin(user)] admin ghosted.")
		var/mob/body = user.mob
		var/mob/dead/observer/ghost = body.ghostize(TRUE, TRUE)
		user.init_verbs()
		if(body && !body.key)
			body.key = "@[user.key]" //Haaaaaaaack. But the people have spoken. If it breaks; blame adminbus
		// Carry over invisimin to their aghost
		var/is_stealth_mode = user.holder.fakekey
		var/is_invisimin = HAS_TRAIT_FROM(body, TRAIT_INVISIMIN, ADMIN_TRAIT)
		if(is_stealth_mode || is_invisimin)
			if(is_invisimin)
				ADD_TRAIT(ghost, TRAIT_INVISIMIN, ADMIN_TRAIT)
				ghost.SetInvisibility(INVISIBILITY_ADMIN, INVISIBILITY_SOURCE_INVISIMIN, INVISIBILITY_PRIORITY_ADMIN)
			else
				ghost.SetInvisibility(INVISIBILITY_ABSTRACT, INVISIBILITY_SOURCE_STEALTHMODE, INVISIBILITY_PRIORITY_ADMIN)
				ghost.name = " "
				ghost.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
			ghost.alpha = 0
			ghost.remove_from_all_data_huds()
			ADD_TRAIT(ghost, TRAIT_ORBITING_FORBIDDEN, is_invisimin ? ADMIN_TRAIT : STEALTH_MODE_TRAIT)
			QDEL_NULL(ghost.orbiters)

		BLACKBOX_LOG_ADMIN_VERB("Admin Ghost")

ADMIN_VERB(invisimin, R_ADMIN, "管理员隐身", "Toggles ghost-like invisibility.", ADMIN_CATEGORY_GAME)
	// Toggle OFF
	if(HAS_TRAIT(user.mob, TRAIT_INVISIMIN))
		user.mob.remove_traits(list(
				TRAIT_INVISIMIN,
				TRAIT_ORBITING_FORBIDDEN,
				TRAIT_MOVE_PHASING,
				TRAIT_PIERCEIMMUNE,
				TRAIT_INVISIBLE_TO_CAMERA,
			), ADMIN_TRAIT)
		user.mob.add_to_all_human_data_huds()
		user.mob.RemoveInvisibility(INVISIBILITY_SOURCE_INVISIMIN)
		to_chat(user, span_adminnotice(span_bold(LANG("datum.07011746296f45da", null))), confidential = TRUE)
		if(isobserver(user.mob) && !user.holder.fakekey) // Set the alpha back if we're not still stealth mode
			user.mob.alpha = initial(user.mob.alpha)
		return

	// Toggle ON
	user.mob.add_traits(list(
			TRAIT_INVISIMIN,
			TRAIT_ORBITING_FORBIDDEN,
			TRAIT_MOVE_PHASING,
			TRAIT_PIERCEIMMUNE,
			TRAIT_INVISIBLE_TO_CAMERA,
		), ADMIN_TRAIT)
	user.mob.remove_from_all_data_huds()
	user.mob.SetInvisibility(INVISIBILITY_ADMIN, INVISIBILITY_SOURCE_INVISIMIN, INVISIBILITY_PRIORITY_ADMIN)
	if(isobserver(user.mob))
		user.mob.alpha = 0
	QDEL_NULL(user.mob.orbiters)
	to_chat(user, span_adminnotice(span_bold(LANG("datum.1e9fa6f49e5ef527", null))), confidential = TRUE)

ADMIN_VERB(toggle_admin_esp, R_ADMIN, "切换管理员 ESP", "Toggle to be able to see ghosts and invisimins.", ADMIN_CATEGORY_GAME)
	// Toggle OFF
	if(HAS_TRAIT(user.mob, TRAIT_ADMIN_ESP))
		if(isliving(user.mob))
			var/mob/living/living_user = user.mob
			living_user.remove_status_effect(/datum/status_effect/admin_esp)
		else if(isobserver(user.mob))
			user.mob.set_invis_see(SEE_INVISIBLE_OBSERVER)
		else
			user.mob.set_invis_see(SEE_INVISIBLE_LIVING)
		REMOVE_TRAIT(user.mob, TRAIT_ADMIN_ESP, ADMIN_TRAIT)
		to_chat(user.mob, span_adminnotice(LANG("datum.f0723e74f713d40f", list(isliving(user.mob) ? "ghosts or " : ""))), confidential = TRUE)
		return

	// Toggle ON
	if(isliving(user.mob))
		var/mob/living/living_user = user.mob
		living_user.apply_status_effect(/datum/status_effect/admin_esp)
	else if(ismob(user.mob))
		user.mob.set_invis_see(SEE_INVISIBLE_ADMIN)
	else
		to_chat(user.mob, span_warning(LANG("datum.0d86d42110ce5722", null)), confidential = TRUE)
		return

	ADD_TRAIT(user.mob, TRAIT_ADMIN_ESP, ADMIN_TRAIT)
	to_chat(user.mob, span_adminnotice(LANG("datum.e6d97b24518ec991", list(isliving(user.mob) ? "ghosts and " : ""))), confidential = TRUE)

ADMIN_VERB(check_antagonists, R_ADMIN, "检查反派", "See all antagonists for the round.", ADMIN_CATEGORY_GAME)
	user.holder.check_antagonists()
	log_admin("[key_name(user)] checked antagonists.")
	if(!isobserver(user.mob) && SSticker.HasRoundStarted())
		message_admins("[key_name_admin(user)] checked antagonists.")
	BLACKBOX_LOG_ADMIN_VERB("Check Antagonists")

ADMIN_VERB(list_bombers, R_ADMIN, "列出炸弹与嫌疑人", "Look at all bombs and their likely culprit.", ADMIN_CATEGORY_GAME)
	user.holder.list_bombers()
	BLACKBOX_LOG_ADMIN_VERB("List Bombers")

ADMIN_VERB(list_signalers, R_ADMIN, "列出信号器", "View all signalers.", ADMIN_CATEGORY_GAME)
	user.holder.list_signalers()
	BLACKBOX_LOG_ADMIN_VERB("List Signalers")

ADMIN_VERB(list_law_changes, R_ADMIN, "列出法则变更", "View all AI law changes.", ADMIN_CATEGORY_DEBUG)
	user.holder.list_law_changes()
	BLACKBOX_LOG_ADMIN_VERB("List Law Changes")

ADMIN_VERB(show_manifest, R_ADMIN, "显示名单", "View the shift's Manifest.", ADMIN_CATEGORY_DEBUG)
	user.holder.show_manifest()
	BLACKBOX_LOG_ADMIN_VERB("Show Manifest")

ADMIN_VERB(list_dna, R_ADMIN, "列出 DNA", "View DNA.", ADMIN_CATEGORY_DEBUG)
	user.holder.list_dna()
	BLACKBOX_LOG_ADMIN_VERB("List DNA")

ADMIN_VERB(list_fingerprints, R_ADMIN, "列出指纹", "View fingerprints.", ADMIN_CATEGORY_DEBUG)
	user.holder.list_fingerprints()
	BLACKBOX_LOG_ADMIN_VERB("List Fingerprints")

ADMIN_VERB(ban_panel, R_BAN, "封禁面板", "Ban players here.", ADMIN_CATEGORY_MAIN)
	user.holder.ban_panel()
	BLACKBOX_LOG_ADMIN_VERB("Banning Panel")

ADMIN_VERB(unban_panel, R_BAN, "解封面板", "Unban players here.", ADMIN_CATEGORY_MAIN)
	user.holder.unban_panel()
	BLACKBOX_LOG_ADMIN_VERB("Unbanning Panel")

ADMIN_VERB(game_panel, R_ADMIN, "游戏面板", "Look at the state of the game.", ADMIN_CATEGORY_GAME)
	user.holder.Game()
	BLACKBOX_LOG_ADMIN_VERB("Game Panel")

ADMIN_VERB(poll_panel, R_POLL, "服务器投票管理", "View and manage polls.", ADMIN_CATEGORY_MAIN)
	user.holder.poll_list_panel()
	BLACKBOX_LOG_ADMIN_VERB("Server Poll Management")

/// Returns this client's stealthed ckey
/client/proc/getStealthKey()
	return GLOB.stealthminID[ckey]

/// Takes a stealthed ckey as input, returns the true key it represents
/proc/findTrueKey(stealth_key)
	if(!stealth_key)
		return
	for(var/potentialKey in GLOB.stealthminID)
		if(GLOB.stealthminID[potentialKey] == stealth_key)
			return potentialKey

/// Hands back a stealth ckey to use, guarenteed to be unique
/proc/generateStealthCkey()
	var/guess = rand(0, 1000)
	var/text_guess
	var/valid_found = FALSE
	while(valid_found == FALSE)
		valid_found = TRUE
		text_guess = "@[num2text(guess)]"
		// We take a guess at some number, and if it's not in the existing stealthmin list we exit
		for(var/key in GLOB.stealthminID)
			// If it is in the list tho, we up one number, and redo the loop
			if(GLOB.stealthminID[key] == text_guess)
				guess += 1
				valid_found = FALSE
				break

	return text_guess

/client/proc/createStealthKey()
	GLOB.stealthminID["[ckey]"] = generateStealthCkey()

ADMIN_VERB(stealth, R_STEALTH, "潜行模式", "Toggle stealth.", ADMIN_CATEGORY_MAIN)
	if(user.holder.fakekey)
		user.disable_stealth_mode()
	else
		user.enable_stealth_mode()

	BLACKBOX_LOG_ADMIN_VERB("Stealth Mode")

/client/proc/enable_stealth_mode()
	var/new_key = ckeyEx(stripped_input(usr, "Enter your desired display name.", "Fake Key", key, 26))
	if(!new_key)
		return
	holder.fakekey = new_key
	createStealthKey()
	if(isobserver(mob))
		mob.SetInvisibility(INVISIBILITY_ABSTRACT, INVISIBILITY_SOURCE_STEALTHMODE, INVISIBILITY_PRIORITY_ADMIN)
		mob.alpha = 0 //JUUUUST IN CASE
		mob.name = " "
		mob.mouse_opacity = MOUSE_OPACITY_TRANSPARENT

	ADD_TRAIT(mob, TRAIT_ORBITING_FORBIDDEN, STEALTH_MODE_TRAIT)
	QDEL_NULL(mob.orbiters)

	log_admin("[key_name(usr)] has turned stealth mode ON")
	message_admins("[key_name_admin(usr)] has turned stealth mode ON")

/client/proc/disable_stealth_mode()
	holder.fakekey = null
	if(isobserver(mob))
		mob.RemoveInvisibility(INVISIBILITY_SOURCE_STEALTHMODE)
		if(!HAS_TRAIT_FROM(mob, TRAIT_INVISIMIN, ADMIN_TRAIT)) // Don't reset our alpha if we're also invisimin'd
			mob.alpha = initial(mob.alpha)
		if(mob.mind)
			if(mob.mind.ghostname)
				mob.name = mob.mind.ghostname
			else
				mob.name = mob.mind.name
		else
			mob.name = mob.real_name
		mob.mouse_opacity = initial(mob.mouse_opacity)

	REMOVE_TRAIT(mob, TRAIT_ORBITING_FORBIDDEN, STEALTH_MODE_TRAIT)

	log_admin("[key_name(usr)] has turned stealth mode OFF")
	message_admins("[key_name_admin(usr)] has turned stealth mode OFF")

ADMIN_VERB(drop_bomb, R_FUN, "投放炸弹", "Cause an explosion of varying strength at your location", ADMIN_CATEGORY_FUN)
	var/list/choices = list("Small Bomb (1, 2, 3, 3)", "Medium Bomb (2, 3, 4, 4)", "Big Bomb (3, 5, 7, 5)", "Maxcap", "Custom Bomb")
	var/choice = tgui_input_list(user, LANG("datum.6b74fb9d5d92e2e6", null), LANG("datum.2860e853aeb90f24", null), choices)
	if(isnull(choice))
		return
	var/turf/epicenter = user.mob.loc

	switch(choice)
		if("Small Bomb (1, 2, 3, 3)")
			explosion(epicenter, devastation_range = 1, heavy_impact_range = 2, light_impact_range = 3, flash_range = 3, adminlog = TRUE, ignorecap = TRUE, explosion_cause = user.mob)
		if("Medium Bomb (2, 3, 4, 4)")
			explosion(epicenter, devastation_range = 2, heavy_impact_range = 3, light_impact_range = 4, flash_range = 4, adminlog = TRUE, ignorecap = TRUE, explosion_cause = user.mob)
		if("Big Bomb (3, 5, 7, 5)")
			explosion(epicenter, devastation_range = 3, heavy_impact_range = 5, light_impact_range = 7, flash_range = 5, adminlog = TRUE, ignorecap = TRUE, explosion_cause = user.mob)
		if("Maxcap")
			explosion(epicenter, devastation_range = GLOB.MAX_EX_DEVESTATION_RANGE, heavy_impact_range = GLOB.MAX_EX_HEAVY_RANGE, light_impact_range = GLOB.MAX_EX_LIGHT_RANGE, flash_range = GLOB.MAX_EX_FLASH_RANGE, adminlog = TRUE, ignorecap = TRUE, explosion_cause = user.mob)
		if("Custom Bomb")
			var/range_devastation = input(user, LANG("datum.aa69bbaad917b78f", null)) as null|num
			if(range_devastation == null)
				return
			var/range_heavy = input(user, LANG("datum.c40eea7b35e73490", null)) as null|num
			if(range_heavy == null)
				return
			var/range_light = input(user, LANG("datum.9eec93bbdbcc1499", null)) as null|num
			if(range_light == null)
				return
			var/range_flash = input(user, LANG("datum.5bd47f000fd0b3f7", null)) as null|num
			if(range_flash == null)
				return
			if(range_devastation > GLOB.MAX_EX_DEVESTATION_RANGE || range_heavy > GLOB.MAX_EX_HEAVY_RANGE || range_light > GLOB.MAX_EX_LIGHT_RANGE || range_flash > GLOB.MAX_EX_FLASH_RANGE)
				if(tgui_alert(user, LANG("datum.6e916adb7e2afecf", null),,list("Yes","No")) != "Yes")
					return
			epicenter = get_turf(user.mob) //We need to reupdate as they may have moved again
			explosion(epicenter, devastation_range = range_devastation, heavy_impact_range = range_heavy, light_impact_range = range_light, flash_range = range_flash, adminlog = TRUE, ignorecap = TRUE, explosion_cause = user.mob)
	message_admins("[ADMIN_LOOKUPFLW(user.mob)] creating an admin explosion at [epicenter.loc].")
	log_admin("[key_name(user)] created an admin explosion at [epicenter.loc].")
	BLACKBOX_LOG_ADMIN_VERB("Drop Bomb")

ADMIN_VERB(drop_bomb_dynex, R_FUN, "投放 DynEx 炸弹", "Cause an explosion of varying strength at your location.", ADMIN_CATEGORY_FUN)
	var/ex_power = input(user, LANG("datum.73d10f27810130eb", null)) as null|num
	var/turf/epicenter = get_turf(user.mob)
	if(!ex_power || !epicenter)
		return
	dyn_explosion(epicenter, ex_power)
	message_admins("[ADMIN_LOOKUPFLW(user.mob)] creating an admin explosion at [epicenter.loc].")
	log_admin("[key_name(user)] created an admin explosion at [epicenter.loc].")
	BLACKBOX_LOG_ADMIN_VERB("Drop Dynamic Bomb")

ADMIN_VERB(get_dynex_range, R_FUN, "获取 DynEx 范围", "Get the estimated range of a bomb using explosive power.", ADMIN_CATEGORY_DEBUG)
	var/ex_power = input(user, LANG("datum.73d10f27810130eb", null)) as null|num
	if (isnull(ex_power))
		return
	var/range = round((2 * ex_power)**GLOB.DYN_EX_SCALE)
	to_chat(user, LANG("datum.b6a72f7fffcbe185", list(round(range*0.25), round(range*0.5), round(range))), confidential = TRUE)

ADMIN_VERB(get_dynex_power, R_FUN, "获取 DynEx 威力", "Get the estimated required power of a bomb to reach the given range.", ADMIN_CATEGORY_DEBUG)
	var/ex_range = input(user, LANG("datum.077f0baccc0b5912", null)) as null|num
	if (isnull(ex_range))
		return
	var/power = (0.5 * ex_range)**(1/GLOB.DYN_EX_SCALE)
	to_chat(user, LANG("datum.08f203acec720752", list(power)), confidential = TRUE)

ADMIN_VERB(set_dynex_scale, R_FUN, "设置 DynEx 比例", "Set the scale multiplier on dynex explosions. Default 0.5.", ADMIN_CATEGORY_DEBUG)
	var/ex_scale = input(user, LANG("datum.6aea31546c89340d", null)) as null|num
	if(!ex_scale)
		return
	GLOB.DYN_EX_SCALE = ex_scale
	log_admin("[key_name(user)] has modified Dynamic Explosion Scale: [ex_scale]")
	message_admins("[key_name_admin(user)] has  modified Dynamic Explosion Scale: [ex_scale]")

ADMIN_VERB(atmos_control, R_DEBUG|R_SERVER, "大气控制面板", "Open the atmospherics control panel.", ADMIN_CATEGORY_DEBUG)
	SSair.ui_interact(user.mob)

ADMIN_VERB(reload_cards, R_DEBUG, "重新加载卡牌", "Reload all TCG cards.", ADMIN_CATEGORY_DEBUG)
	if(!SStrading_card_game.loaded)
		message_admins("The card subsystem is not currently loaded")
		return
	SStrading_card_game.reloadAllCardFiles()

ADMIN_VERB(validate_cards, R_DEBUG, "验证卡牌", "Validate the card settings.", ADMIN_CATEGORY_DEBUG)
	if(!SStrading_card_game.loaded)
		message_admins("The card subsystem is not currently loaded")
		return
	var/message = SStrading_card_game.check_cardpacks(SStrading_card_game.card_packs)
	message += SStrading_card_game.check_card_datums()
	if(message)
		message_admins(message)
	else
		message_admins("No errors found in card rarities or overrides.")

ADMIN_VERB(test_cardpack_distribution, R_DEBUG, "测试卡包分发", "Test the distribution of a card pack.", ADMIN_CATEGORY_DEBUG)
	if(!SStrading_card_game.loaded)
		message_admins("The card subsystem is not currently loaded")
		return
	var/pack = tgui_input_list(user, LANG("datum.b41790cd216301dc", null), LANG("datum.2d815bdc03a37aa0", null), sort_list(SStrading_card_game.card_packs))
	if(!pack)
		return
	var/batch_count = tgui_input_number(user, LANG("datum.4d264d301a9e21d6", null), LANG("datum.e172866ca96e24c4", null))
	var/batch_size = tgui_input_number(user, LANG("datum.5d1e15a31a7a0417", null), LANG("datum.9d3d62d08b2251aa", null))
	var/guar = tgui_input_number(user, LANG("datum.c2d2fcea201eda40", null), LANG("datum.c2230a42ff79ade6", null))
	SStrading_card_game.check_card_distribution(pack, batch_size, batch_count, guar)

ADMIN_VERB(print_cards, R_DEBUG, "输出卡牌列表", "Print all cards to chat.", ADMIN_CATEGORY_DEBUG)
	SStrading_card_game.printAllCards()

ADMIN_VERB(give_mob_action, R_FUN, "给予生物动作", ADMIN_VERB_NO_DESCRIPTION, ADMIN_CATEGORY_HIDDEN)
	VERB_ARG_TYPED(ability_recipient, VERB_ARG_TYPE_MOB, VERB_ARG_SOURCE_WORLD, /mob)
	var/static/list/all_mob_actions = sort_list(subtypesof(/datum/action/cooldown/mob_cooldown), GLOBAL_PROC_REF(cmp_typepaths_asc))
	var/static/list/actions_by_name = list()
	if (!length(actions_by_name))
		for (var/datum/action/cooldown/mob_cooldown as anything in all_mob_actions)
			actions_by_name["[initial(mob_cooldown.name)] ([mob_cooldown])"] = mob_cooldown

	var/ability = tgui_input_list(user, LANG("datum.037e009e94df2870", null), LANG("datum.aeb9f33ff1b74069", null), actions_by_name)
	if(isnull(ability))
		return

	var/ability_type = actions_by_name[ability]
	var/datum/action/cooldown/mob_cooldown/add_ability

	var/make_sequence = tgui_alert(user, LANG("datum.d4eb895f5ca3aaaf", null), LANG("datum.27191d52699c8c1e", null), list("Yes", "No"))
	if(make_sequence == "Yes")
		add_ability = new /datum/action/cooldown/mob_cooldown(ability_recipient)
		add_ability.sequence_actions = list()
		while(!isnull(ability_type))
			var/ability_delay = tgui_input_number(user, LANG("datum.5b24dfdc7ee82cc7", null), LANG("datum.c0323dc7bd7805ab", null), 2)
			if(isnull(ability_delay) || ability_delay < 0)
				ability_delay = 0
			add_ability.sequence_actions[ability_type] = ability_delay * 1 SECONDS
			ability = tgui_input_list(user, LANG("datum.ab7c7ef75301eb04", null), LANG("datum.27191d52699c8c1e", null), actions_by_name)
			ability_type = actions_by_name[ability]
		var/ability_cooldown = tgui_input_number(user, LANG("datum.d0676d7fae6c4af7", null), LANG("datum.7adb2d18e4651ab6", null), 2)
		if(isnull(ability_cooldown) || ability_cooldown < 0)
			ability_cooldown = 2
		add_ability.cooldown_time = ability_cooldown * 1 SECONDS
		var/ability_melee_cooldown = tgui_input_number(user, LANG("datum.5dfd060c01748173", null), LANG("datum.cb24c5b4d59e8d07", null), 2)
		if(isnull(ability_melee_cooldown) || ability_melee_cooldown < 0)
			ability_melee_cooldown = 2
		add_ability.melee_cooldown_time = ability_melee_cooldown * 1 SECONDS
		add_ability.name = tgui_input_text(user, LANG("datum.68ba7c466ec3cc5b", null), LANG("datum.eef0b58bf570588a", null), "Generic Ability", max_length = MAX_NAME_LEN)
		add_ability.create_sequence_actions()
	else
		add_ability = new ability_type(ability_recipient)

	if(isnull(ability_recipient))
		return
	add_ability.Grant(ability_recipient)

	message_admins("[key_name_admin(user)] added mob ability [ability_type] to mob [ability_recipient].")
	log_admin("[key_name(user)] added mob ability [ability_type] to mob [ability_recipient].")
	BLACKBOX_LOG_ADMIN_VERB("Add Mob Ability")

ADMIN_VERB(remove_mob_action, R_FUN, "移除生物动作", ADMIN_VERB_NO_DESCRIPTION, ADMIN_CATEGORY_HIDDEN)
	VERB_ARG_TYPED(removal_target, VERB_ARG_TYPE_MOB, VERB_ARG_SOURCE_WORLD, /mob)
	var/list/target_abilities = list()
	for(var/datum/action/cooldown/mob_cooldown/ability in removal_target.actions)
		target_abilities[ability.name] = ability

	if(!length(target_abilities))
		return

	var/chosen_ability = tgui_input_list(user, LANG("datum.9fd5efdc8efa2f07", list(removal_target)), LANG("datum.36872840c4097d81", null), sort_list(target_abilities))
	if(isnull(chosen_ability))
		return
	var/datum/action/cooldown/mob_cooldown/to_remove = target_abilities[chosen_ability]
	if(!istype(to_remove))
		return

	qdel(to_remove)
	log_admin("[key_name(user)] removed the ability [chosen_ability] from [key_name(removal_target)].")
	message_admins("[key_name_admin(user)] removed the ability [chosen_ability] from [key_name_admin(removal_target)].")
	BLACKBOX_LOG_ADMIN_VERB("Remove Mob Ability")

ADMIN_VERB(give_spell, R_FUN, "给予法术", ADMIN_VERB_NO_DESCRIPTION, ADMIN_CATEGORY_HIDDEN)
	VERB_ARG_TYPED(spell_recipient, VERB_ARG_TYPE_MOB, VERB_ARG_SOURCE_WORLD, /mob)
	var/which = tgui_alert(user, LANG("datum.f926544ac005d6fd", null), LANG("datum.1967f954c9a762ee", null), list("Name", "Typepath"))
	if(!which)
		return
	if(QDELETED(spell_recipient))
		to_chat(user, span_warning(LANG("datum.25ac67c79eaa67d4", null)))
		return

	var/list/spell_list = list()
	for(var/datum/action/cooldown/spell/to_add as anything in subtypesof(/datum/action/cooldown/spell))
		var/spell_name = initial(to_add.name)
		if(spell_name == "Spell") // abstract or un-named spells should be skipped.
			continue

		if(which == "Name")
			spell_list[spell_name] = to_add
		else
			spell_list += to_add

	var/chosen_spell = tgui_input_list(user, LANG("datum.4a47821537ef62b2", list(spell_recipient)), LANG("datum.a55c6f394a700cb5", null), sort_list(spell_list))
	if(isnull(chosen_spell))
		return
	var/datum/action/cooldown/spell/spell_path = which == "Typepath" ? chosen_spell : spell_list[chosen_spell]
	if(!ispath(spell_path))
		return

	var/robeless = (tgui_alert(user, LANG("datum.8fe49527e487af78", null), LANG("datum.d1641999fdce218d", null), list("Force Robeless", "Use Spell Setting")) == "Force Robeless")

	if(QDELETED(spell_recipient))
		to_chat(user, span_warning(LANG("datum.25ac67c79eaa67d4", null)))
		return

	BLACKBOX_LOG_ADMIN_VERB("Give Spell")
	log_admin("[key_name(user)] gave [key_name(spell_recipient)] the spell [chosen_spell][robeless ? " (Forced robeless)" : ""].")
	message_admins("[key_name_admin(user)] gave [key_name_admin(spell_recipient)] the spell [chosen_spell][robeless ? " (Forced robeless)" : ""].")

	var/datum/action/cooldown/spell/new_spell = new spell_path(spell_recipient.mind || spell_recipient)

	if(robeless)
		new_spell.spell_requirements &= ~SPELL_REQUIRES_WIZARD_GARB

	new_spell.Grant(spell_recipient)

	if(!spell_recipient.mind)
		to_chat(user, span_userdanger(LANG("datum.f13c244aa14c8033", null)))

ADMIN_VERB(remove_spell, R_FUN, "移除法术", ADMIN_VERB_NO_DESCRIPTION, ADMIN_CATEGORY_HIDDEN)
	VERB_ARG_TYPED(removal_target, VERB_ARG_TYPE_MOB, VERB_ARG_SOURCE_WORLD, /mob)
	var/list/target_spell_list = list()
	for(var/datum/action/cooldown/spell/spell in removal_target.actions)
		target_spell_list[spell.name] = spell

	if(!length(target_spell_list))
		return

	var/chosen_spell = tgui_input_list(user, LANG("datum.9fd5efdc8efa2f07", list(removal_target)), LANG("datum.a55c6f394a700cb5", null), sort_list(target_spell_list))
	if(isnull(chosen_spell))
		return
	var/datum/action/cooldown/spell/to_remove = target_spell_list[chosen_spell]
	if(!istype(to_remove))
		return

	qdel(to_remove)
	log_admin("[key_name(user)] removed the spell [chosen_spell] from [key_name(removal_target)].")
	message_admins("[key_name_admin(user)] removed the spell [chosen_spell] from [key_name_admin(removal_target)].")
	BLACKBOX_LOG_ADMIN_VERB("Remove Spell")

ADMIN_VERB(give_disease, R_FUN, "给予疾病", ADMIN_VERB_NO_DESCRIPTION, ADMIN_CATEGORY_HIDDEN)
	VERB_ARG_TYPED(victim, VERB_ARG_TYPE_MOB, VERB_ARG_SOURCE_WORLD, /mob/living)
	var/datum/disease/disease = tgui_input_list(user, LANG("datum.1bc99a53be9650e0", null), LANG("datum.75cd3f6d3e763bae", null), sort_list(SSdisease.diseases, GLOBAL_PROC_REF(cmp_typepaths_asc)))
	if(!disease)
		return
	victim.ForceContractDisease(new disease, FALSE, TRUE)
	BLACKBOX_LOG_ADMIN_VERB("Give Disease")
	log_admin("[key_name(user)] gave [key_name(victim)] the disease [disease].")
	message_admins(span_adminnotice("[key_name_admin(user)] gave [key_name_admin(victim)] the disease [disease]."))

ADMIN_VERB_AND_CONTEXT_MENU(object_say, R_FUN, "OOC 发言", ADMIN_VERB_NO_DESCRIPTION, ADMIN_CATEGORY_HIDDEN, /obj)
	VERB_ARG_TYPED(speaker, VERB_ARG_TYPE_OBJ, VERB_ARG_SOURCE_WORLD, /obj)
	var/message = tgui_input_text(user, LANG("datum.43f83808dec80d8f", null), LANG("datum.f119adcc8b6f0eda", null), encode = FALSE)
	if(!message)
		return
	speaker.say(message, sanitize = FALSE)
	log_admin("[key_name(user)] made [speaker] at [AREACOORD(speaker)] say \"[message]\"")
	message_admins(span_adminnotice("[key_name_admin(user)] made [speaker] at [AREACOORD(speaker)]. say \"[message]\""))
	BLACKBOX_LOG_ADMIN_VERB("Object Say")

ADMIN_VERB(build_mode_self, R_BUILD, "切换自身建造模式", "Toggle build mode for yourself.", ADMIN_CATEGORY_EVENTS)
	togglebuildmode(user.mob) // why is this a global proc???
	BLACKBOX_LOG_ADMIN_VERB("Toggle Build Mode")

ADMIN_VERB(check_ai_laws, R_ADMIN, "检查 AI 法则", "View the current AI laws.", ADMIN_CATEGORY_GAME)
	user.holder.output_ai_laws()

ADMIN_VERB(manage_sect, R_ADMIN, "管理宗教教派", "Manages the chaplain's religion.", ADMIN_CATEGORY_GAME)
	if (!isnull(GLOB.religious_sect))
		var/you_sure = tgui_alert(
			user,
			LANG("datum.04a00f6027177405", list(GLOB.religious_sect.name)),
			LANG("datum.ee32b53ba5dd69c0", null),
			list("Yes", "Cancel"),
		)
		if (you_sure != "Yes")
			return

	var/static/list/choices = list()
	if (!length(choices))
		choices["nothing"] = null
		for(var/datum/religion_sect/sect as anything in subtypesof(/datum/religion_sect))
			choices[initial(sect.name)] = sect
	var/choice = tgui_input_list(user, LANG("datum.e82b3b105d18c822", null), LANG("datum.711d37b16c321d41", null), choices)
	if(isnull(choice))
		return
	if(choice == "nothing")
		reset_religious_sect()
		return
	set_new_religious_sect(choices[choice], reset_existing = TRUE)

ADMIN_VERB(deadmin, R_NONE, "卸任管理员", "Shed your admin powers.", ADMIN_CATEGORY_MAIN)
	user.holder.deactivate()
	to_chat(user, span_interface(LANG("datum.2989f127a1a91fa5", null)))
	log_admin("[key_name(user)] deadminned themselves.")
	message_admins("[key_name_admin(user)] deadminned themselves.")
	BLACKBOX_LOG_ADMIN_VERB("Deadmin")

ADMIN_VERB(populate_world, R_DEBUG, "填充世界", "Populate the world with test mobs.", ADMIN_CATEGORY_DEBUG)
	VERB_ARG(amount, VERB_ARG_TYPE_NUM, VERB_ARG_SOURCE_INPUT)
	for (var/i in 1 to amount)
		var/turf/tile = get_safe_random_station_turf_equal_weight()
		var/mob/living/carbon/human/hooman = new(tile)
		hooman.equipOutfit(pick(subtypesof(/datum/outfit)))
		testing("Spawned test mob at [get_area_name(tile, TRUE)] ([tile.x],[tile.y],[tile.z])")

ADMIN_VERB(toggle_ai_interact, R_ADMIN, "切换管理员 AI 交互", "Allows you to interact with most machines as an AI would as a ghost.", ADMIN_CATEGORY_GAME)
	var/doesnt_have_silicon_access = !HAS_TRAIT_FROM(user, TRAIT_AI_ACCESS, ADMIN_TRAIT)
	if(doesnt_have_silicon_access)
		ADD_TRAIT(user, TRAIT_AI_ACCESS, ADMIN_TRAIT)
	else
		REMOVE_TRAIT(user, TRAIT_AI_ACCESS, ADMIN_TRAIT)

	log_admin("[key_name(user)] has [doesnt_have_silicon_access ? "activated" : "deactivated"] Admin AI Interact")
	message_admins("[key_name_admin(user)] has [doesnt_have_silicon_access ? "activated" : "deactivated"] their AI interaction")

ADMIN_VERB(debug_statpanel, R_DEBUG, "调试状态面板", "Toggles local debug of the stat panel", ADMIN_CATEGORY_DEBUG)
	user.stat_panel.send_message("create_debug")

ADMIN_VERB(display_sendmaps, R_DEBUG, "发送地图性能分析", "View the profile.", ADMIN_CATEGORY_DEBUG)
	user << link("?debug=profile&type=sendmaps&window=test")

ADMIN_VERB(spawn_debug_full_crew, R_DEBUG, "生成调试用完整船员", "Creates a full crew for the station, flling datacore and assigning minds and jobs.", ADMIN_CATEGORY_DEBUG)
	if(SSticker.current_state != GAME_STATE_PLAYING)
		to_chat(user, LANG("datum.4f8d0876d394cd26", null))
		return

	// Two input checks here to make sure people are certain when they're using this.
	if(tgui_alert(user, LANG("datum.4e1a6fb5a1a608bb", null), LANG("datum.3da3029e3a4e4e7b", null), list("Yes", "Cancel")) != "Yes")
		return

	if(!user.is_localhost() && tgui_alert(user, LANG("datum.6a0ce11a0f7cbe36", null), LANG("datum.6424ee1502e563d4", null), list("Yes", "Cancel")) != "Yes")
		return

	// Find the observer spawn, so we have a place to dump the dummies.
	var/obj/effect/landmark/observer_start/observer_point = locate(/obj/effect/landmark/observer_start) in GLOB.landmarks_list
	var/turf/destination = get_turf(observer_point)
	if(!destination)
		to_chat(user, LANG("datum.7c2c16466e2cfac8", null))
		return

	// Okay, now go through all nameable occupations.
	// Pick out all jobs that have JOB_CREW_MEMBER set.
	// Then, spawn a human and slap a person into it.
	var/number_made = 0
	for(var/rank in SSjob.name_occupations)
		var/datum/job/job = SSjob.get_job(rank)

		// JOB_CREW_MEMBER is all jobs that pretty much aren't silicon
		if(!(job.job_flags & JOB_CREW_MEMBER))
			continue

		// Create our new_player for this job and set up its mind.
		var/mob/dead/new_player/new_guy = new()
		new_guy.mind_initialize()
		new_guy.mind.name = "[rank] Dummy"

		// Assign the rank to the new player dummy.
		if(!SSjob.assign_role(new_guy, job, do_eligibility_checks = FALSE))
			qdel(new_guy)
			to_chat(user, LANG("datum.9cfc94fa40bbab0c", list(rank)))
			continue

		// It's got a job, spawn in a human and shove it in the human.
		var/mob/living/carbon/human/character = new(destination)
		character.name = new_guy.mind.name
		new_guy.mind.transfer_to(character)
		qdel(new_guy)

		// Then equip up the human with job gear.
		SSjob.equip_rank(character, job)
		job.after_latejoin_spawn(character)

		// Finally, ensure the minds are tracked and in the manifest.
		SSticker.minds += character.mind
		if(ishuman(character))
			GLOB.manifest.inject(character)

		number_made++
		CHECK_TICK

	to_chat(user, LANG("datum.0b8d03adfb4d8597", list(number_made)))

ADMIN_VERB(debug_spell_requirements, R_DEBUG, "调试法术需求", "View all spells and their requirements.", ADMIN_CATEGORY_DEBUG)
	var/header = "<tr><th>Name</th> <th>Requirements</th>"
	var/all_requirements = list()
	for(var/datum/action/cooldown/spell/spell as anything in typesof(/datum/action/cooldown/spell))
		if(initial(spell.name) == "Spell")
			continue

		var/list/real_reqs = list()
		var/reqs = initial(spell.spell_requirements)
		if(reqs & SPELL_CASTABLE_AS_BRAIN)
			real_reqs += "Castable as brain"
		if(reqs & SPELL_REQUIRES_HUMAN)
			real_reqs += "Must be human"
		if(reqs & SPELL_REQUIRES_MIME_VOW)
			real_reqs += "Must be miming"
		if(reqs & SPELL_REQUIRES_MIND)
			real_reqs += "Must have a mind"
		if(reqs & SPELL_REQUIRES_NO_ANTIMAGIC)
			real_reqs += "Must have no antimagic"
		if(reqs & SPELL_REQUIRES_STATION)
			real_reqs += "Must be on the station z-level"
		if(reqs & SPELL_REQUIRES_WIZARD_GARB)
			real_reqs += "Must have wizard clothes"

		all_requirements += "<tr><td>[initial(spell.name)]</td> <td>[english_list(real_reqs, "No requirements")]</td></tr>"

	var/page_style = "<style>table, th, td {border: 1px solid black;border-collapse: collapse;}</style>"
	var/page_contents = "[page_style]<table style=\"width:100%\">[header][jointext(all_requirements, "")]</table>"
	var/datum/browser/popup = new(user.mob, "spellreqs", "Spell Requirements", 600, 400)
	popup.set_content(page_contents)
	popup.open()

ADMIN_VERB(load_lazy_template, R_ADMIN, "加载/跳转懒加载模板", "Loads a lazy template and/or jumps to it.", ADMIN_CATEGORY_EVENTS)
	var/list/choices = LAZY_TEMPLATE_KEY_LIST_ALL()
	var/choice = tgui_input_list(user, LANG("datum.3e390d40dc332736", null), LANG("datum.09afa419bfc59174", null), choices)
	var/teleport_to_template = tgui_input_list(user, LANG("datum.346fe89a2e5bce74", null), LANG("datum.2a9ec0ea650a17d4", null), list("Yes", "No"))
	if(!choice)
		return

	choice = choices[choice]
	if(!choice)
		to_chat(user, span_warning(LANG("datum.dc7bd1d4c4869b22", null)))
		return

	var/already_loaded = LAZYACCESS(SSmapping.loaded_lazy_templates, choice)
	var/force_load = FALSE
	if(already_loaded && (tgui_alert(user, LANG("datum.739f65e0df651a61", null), "", list("Jump", "Load Again")) == "Load Again"))
		force_load = TRUE

	var/datum/turf_reservation/reservation = SSmapping.lazy_load_template(choice, force = force_load)
	if(!reservation)
		to_chat(user, span_boldwarning(LANG("datum.b679aec22a4d91dd", null)))
		return

	if(teleport_to_template == "Yes")
		if(!isobserver(user.mob))
			SSadmin_verbs.dynamic_invoke_verb(user, /datum/admin_verb/admin_ghost)
		user.mob.forceMove(reservation.bottom_left_turfs[1])
		to_chat(user, span_boldnicegreen(LANG("datum.003175d040187deb", null)))

	message_admins("[key_name_admin(user)] has loaded lazy template '[choice]'")

ADMIN_VERB(library_control, R_BAN, "图书馆管理", "List and manage the Library.", ADMIN_CATEGORY_MAIN)
	if(!user.holder.library_manager)
		user.holder.library_manager = new
	user.holder.library_manager.ui_interact(user.mob)
	BLACKBOX_LOG_ADMIN_VERB("Library Management")

ADMIN_VERB(create_mob_worm, R_FUN, "创建 Mob 蠕虫", "Attach a linked list of mobs to your marked mob.", ADMIN_CATEGORY_FUN)
	if(!isliving(user.holder.marked_datum))
		to_chat(user, span_warning(LANG("datum.4df7072b0b7ce47a", null)))
		return
	var/mob/living/head = user.holder.marked_datum

	var/attempted_target_path = tgui_input_text(
		user,
		LANG("datum.cb1c65e7a1ddf75c", null),
		LANG("datum.1a01b0f5ae81d070", null),
		"[/mob/living/basic/pet/dog/corgi/ian]",
	)

	if (isnull(attempted_target_path))
		return //The user pressed "Cancel"

	var/desired_mob = text2path(attempted_target_path)
	if(!ispath(desired_mob))
		desired_mob = pick_closest_path(attempted_target_path, make_types_fancy(subtypesof(/mob/living)))
	if(isnull(desired_mob) || !ispath(desired_mob) || QDELETED(head))
		return //The user pressed "Cancel"

	var/amount = tgui_input_number(user, LANG("datum.a8aca1d001ef316e", null), LANG("datum.6b06d7a3250f6f9e", null), default = 3, min_value = 1)
	if (isnull(amount) || amount < 1 || QDELETED(head))
		return
	head.AddComponent(/datum/component/mob_chain)
	var/mob/living/previous = head
	for (var/i in 1 to amount)
		var/mob/living/segment = new desired_mob(head.drop_location())
		if (QDELETED(segment)) // ffs mobs which replace themselves with other mobs
			i--
			continue
		ADD_TRAIT(segment, TRAIT_PERMANENTLY_MORTAL, INNATE_TRAIT)
		QDEL_NULL(segment.ai_controller)
		segment.AddComponent(/datum/component/mob_chain, front = previous)
		previous = segment

ADMIN_VERB(give_ai_controller, R_FUN, "授予 AI 控制器", ADMIN_VERB_NO_DESCRIPTION, ADMIN_CATEGORY_HIDDEN)
	VERB_ARG_TYPED(my_guy, VERB_ARG_TYPE_MOB, VERB_ARG_SOURCE_WORLD, /mob/living)
	var/static/list/controllers = subtypesof(/datum/admin_ai_template)
	var/static/list/controllers_by_name = list()
	if (!length(controllers_by_name))
		for (var/datum/admin_ai_template/template as anything in controllers)
			controllers_by_name["[initial(template.name)]"] = template

	var/chosen = tgui_input_list(user, LANG("datum.45c5c7898fb68282", null), LANG("datum.5a4a8b3a8cff7ce3", null), controllers_by_name)
	if (isnull(chosen))
		return

	var/chosen_type = controllers_by_name[chosen]
	var/datum/admin_ai_template/using_template = new chosen_type
	using_template.apply(my_guy, user)

ADMIN_VERB(clear_legacy_asset_cache, R_DEBUG, "清除旧版资源缓存", "Clears the legacy asset cache, regenerating it immediately (may cause lag).", ADMIN_CATEGORY_DEBUG)
	if(!CONFIG_GET(flag/cache_assets))
		to_chat(user, span_warning(LANG("datum.978d642fff7d0b9e", null)))
		return
	var/regenerated = 0
	for(var/datum/asset/target_spritesheet as anything in valid_subtypesof(/datum/asset))
		if(!initial(target_spritesheet.cross_round_cachable))
			continue
		var/datum/asset/asset_datum = GLOB.asset_datums[target_spritesheet]
		asset_datum.regenerate()
		regenerated++
	to_chat(user, span_notice(LANG("datum.4b16d9234da59317", list(regenerated))))

ADMIN_VERB(clear_smart_asset_cache, R_DEBUG, "清除智能资源缓存", "Clear the smart asset cache, causing it to regenerate next round.", ADMIN_CATEGORY_DEBUG)
	if(!CONFIG_GET(flag/smart_cache_assets))
		to_chat(user, span_warning(LANG("datum.b5924be2eba747d7", null)))
		return
	var/cleared = 0
	for(var/datum/asset/spritesheet_batched/target_spritesheet as anything in valid_subtypesof(/datum/asset/spritesheet_batched))
		fdel("[ASSET_CROSS_ROUND_SMART_CACHE_DIRECTORY]/spritesheet_cache.[initial(target_spritesheet.name)].json")
		cleared++
	to_chat(user, span_notice(LANG("datum.186c25e282626dd7", list(cleared))))

ADMIN_VERB(open_event_logger, R_DEBUG, "打开事件记录器", "Open the event logger interface.", ADMIN_CATEGORY_DEBUG)
	GLOB.event_logger.ui_interact(user.mob)

ADMIN_VERB(view_behavior_tree, R_DEBUG, "查看行为树", "Inspect the AI behavior tree of a mob.", ADMIN_CATEGORY_DEBUG)
	GLOB.bt_viewer.ui_interact(user.mob)

ADMIN_VERB(new_blackmarket_item, R_BUILD, "创建黑市物品", "Add an item to the black market for purchase.", ADMIN_CATEGORY_EVENTS)
	VERB_ARG(object, VERB_ARG_TYPE_TYPEPATH, VERB_ARG_SOURCE_INPUT)
	if(!object)
		to_chat(user, span_boldwarning(LANG("datum.6793d2b877768af7", null)))
		return
	//first: have admins select a typepath for the item they want to offer.
	var/obj/chosen = pick_closest_path(object, make_types_fancy(subtypesof(/obj)))
	// second: poll admins for the name, description, price, and quantity.
	if(isnull(chosen))
		return
	var/name = tgui_input_text(user, LANG("datum.02e2ab584724a530", null), LANG("datum.dda67683487b5b02", null), "Arcane Object", max_length = MAX_NAME_LEN)
	if(isnull(name))
		return
	var/description = tgui_input_text(user, LANG("datum.4640c340b6a6dfdc", null), LANG("datum.f6dd515fc006e327", null), "[chosen::desc]", max_length = 200)
	if(isnull(description))
		return
	var/price = tgui_input_number(user, LANG("datum.96761edf6092eb3d", null), LANG("datum.91d17d0d02bedfef", null), max_value = INFINITY, min_value = 1, round_value = TRUE)
	if(isnull(price))
		return
	var/quantity = tgui_input_number(user, LANG("datum.1940bff824399549", null), LANG("datum.c7876276b722ea68", null), default = 1, max_value = 100, min_value = 1, round_value = TRUE)
	if(isnull(quantity))
		return
	//lastly: pick a category for the item to go under
	var/category = tgui_input_list(user, LANG("datum.07c3f521117ba2d9", null), LANG("datum.b622031ce1dd0325", null), BLACKMARKET_CATEGORIES)
	if(isnull(category))
		return

	var/datum/market_item/admin_item = new /datum/market_item()
	// Making a note here that we don't need to assign to blackmarket because we still only have one market type, but if we ever start using multiple we'll want to poll admins.
	admin_item.item = chosen
	SSblackbox.record_feedback("tally", "admin blackmarket items", 1, chosen)

	admin_item.name = name
	admin_item.desc = description
	admin_item.price = price
	admin_item.stock = quantity
	admin_item.category = category
	admin_item.restockable = FALSE

	SSmarket.admin_items_spawned++
	admin_item.identifier = "admin_[SSmarket.admin_items_spawned]"

	SSmarket.initialize_admin_item(admin_item)
	log_admin("[key_name(user)] created a new black market item: [name] ([chosen]) for [price] credits, of quantity [quantity].")
	message_admins("[key_name(user)] created a new black market item: [name] ([chosen]) for [price] credits, of quantity [quantity].")

	BLACKBOX_LOG_ADMIN_VERB("Create Black Market Item")


#undef STEALTH_MODE_TRAIT
