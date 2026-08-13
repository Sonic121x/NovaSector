// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
ADMIN_VERB(admin_explosion, R_ADMIN|R_FUN, "爆炸", ADMIN_VERB_NO_DESCRIPTION, ADMIN_CATEGORY_HIDDEN)
	VERB_ARG_TYPED(orignator, VERB_ARG_TYPE_OBJ | VERB_ARG_TYPE_TURF | VERB_ARG_TYPE_MOB, VERB_ARG_SOURCE_WORLD, /atom)
	var/devastation = input(user, LANG("datum.539bbd89", null), LANG("datum.8c7e56a2", null))  as num|null
	if(devastation == null)
		return
	var/heavy = input(user, LANG("datum.a5b19a22", null), LANG("datum.8c7e56a2", null))  as num|null
	if(heavy == null)
		return
	var/light = input(user, LANG("datum.c54ab0a6", null), LANG("datum.8c7e56a2", null))  as num|null
	if(light == null)
		return
	var/flash = input(user, LANG("datum.6090762c", null), LANG("datum.8c7e56a2", null))  as num|null
	if(flash == null)
		return
	var/flames = input(user, LANG("datum.9ebdf290", null), LANG("datum.8c7e56a2", null))  as num|null
	if(flames == null)
		return

	if ((devastation != -1) || (heavy != -1) || (light != -1) || (flash != -1) || (flames != -1))
		if ((devastation > 20) || (heavy > 20) || (light > 20) || (flames > 20))
			if (tgui_alert(user, LANG("datum.3e871e8e", null), LANG("datum.15bc27b6", null), list("Yes", "No")) == "No")
				return

		explosion(orignator, devastation, heavy, light, flames, flash, explosion_cause = user.mob)
		log_admin("[key_name(user)] created an explosion ([devastation],[heavy],[light],[flames]) at [AREACOORD(orignator)]")
		message_admins("[key_name_admin(user)] created an explosion ([devastation],[heavy],[light],[flames]) at [AREACOORD(orignator)]")
		BLACKBOX_LOG_ADMIN_VERB("Explosion")

ADMIN_VERB(admin_emp, R_ADMIN|R_FUN, "电磁脉冲", ADMIN_VERB_NO_DESCRIPTION, ADMIN_CATEGORY_HIDDEN)
	VERB_ARG_TYPED(orignator, VERB_ARG_TYPE_OBJ | VERB_ARG_TYPE_TURF | VERB_ARG_TYPE_MOB, VERB_ARG_SOURCE_WORLD, /atom)
	var/heavy = input(user, LANG("datum.722572ed", null), LANG("datum.8c7e56a2", null))  as num|null
	if(heavy == null)
		return
	var/light = input(user, LANG("datum.41554af3", null), LANG("datum.8c7e56a2", null))  as num|null
	if(light == null)
		return

	if (heavy || light)
		empulse(orignator, heavy, light)
		log_admin("[key_name(user)] created an EM Pulse ([heavy],[light]) at [AREACOORD(orignator)]")
		message_admins("[key_name_admin(user)] created an EM Pulse ([heavy],[light]) at [AREACOORD(orignator)]")
		BLACKBOX_LOG_ADMIN_VERB("EM Pulse")

ADMIN_VERB(gib_them, R_ADMIN, "碎尸", ADMIN_VERB_NO_DESCRIPTION, ADMIN_CATEGORY_HIDDEN)
	VERB_ARG_TYPED(victim, VERB_ARG_TYPE_MOB, VERB_ARG_SOURCE_WORLD, /mob)
	var/confirm = tgui_alert(user, LANG("datum.716b3c04", null), LANG("datum.3c1da715", null), list("Yes", "No","Cancel")) || "Cancel"
	if(confirm == "Cancel")
		return
	//Due to the delay here its easy for something to have happened to the mob
	if(isnull(victim))
		return

	log_admin("[key_name(user)] has gibbed [key_name(victim)]")
	message_admins("[key_name_admin(user)] has gibbed [key_name_admin(victim)]")

	if(isobserver(victim))
		new /obj/effect/gibspawner/generic(get_turf(victim))
		return

	var/mob/living/living_victim = victim
	if (istype(living_victim))
		living_victim.investigate_log("has been gibbed by an admin.", INVESTIGATE_DEATHS)
		if(confirm == "Yes")
			living_victim.gib(DROP_ALL_REMAINS)
		else
			living_victim.gib(DROP_ORGANS|DROP_BODYPARTS)

	BLACKBOX_LOG_ADMIN_VERB("Gib")

ADMIN_VERB(gib_self, R_ADMIN, "自我碎尸", "Give yourself the same treatment you give others.", ADMIN_CATEGORY_FUN)
	var/confirm = tgui_alert(user, LANG("datum.be968efe", null), LANG("datum.3c1da715", null), list("Yes", "No"))
	if(confirm != "Yes")
		return
	log_admin("[key_name(user)] used gibself.")
	message_admins(span_adminnotice("[key_name_admin(user)] used gibself."))
	BLACKBOX_LOG_ADMIN_VERB("Gib Self")

	var/mob/living/ourself = user.mob
	if (istype(ourself))
		ourself.gib()

ADMIN_VERB(dust_self, R_ADMIN, "自我化尘", "Give yourself the same treatment you give others.", ADMIN_CATEGORY_FUN)
	var/confirm = tgui_alert(user, LANG("datum.be968efe", null), LANG("datum.3c1da715", null), list("Yes", "No"))
	if(confirm != "Yes")
		return
	log_admin("[key_name(user)] used dustself.")
	message_admins(span_adminnotice("[key_name_admin(user)] used dustself."))
	BLACKBOX_LOG_ADMIN_VERB("Dust Self")

	var/mob/living/ourself = user.mob
	if (istype(ourself))
		ourself.dust(just_ash = FALSE, drop_items = FALSE, force = TRUE)

ADMIN_VERB(everyone_random, R_SERVER, "随机化所有人", "Make everyone have a random appearance.", ADMIN_CATEGORY_FUN)
	if(SSticker.HasRoundStarted())
		to_chat(user, LANG("datum.a664b0ea", null), confidential = TRUE)
		return

	var/frn = CONFIG_GET(flag/force_random_names)
	if(frn)
		CONFIG_SET(flag/force_random_names, FALSE)
		message_admins("Admin [key_name_admin(user)] has disabled \"Everyone is Special\" mode.")
		to_chat(user, LANG("datum.84c2128f", null), confidential = TRUE)
		return

	var/notifyplayers = tgui_alert(user, LANG("datum.e17f07cf", null), LANG("datum.9cb8b820", null), list("Yes", "No", "Cancel")) || "Cancel"
	if(notifyplayers == "Cancel")
		return

	log_admin("Admin [key_name(user)] has forced the players to have random appearances.")
	message_admins("Admin [key_name_admin(user)] has forced the players to have random appearances.")

	if(notifyplayers == "Yes")
		to_chat(world, span_adminnotice(LANG("datum.0d6bc22a", list(user.key))), confidential = TRUE)

	to_chat(user, LANG("datum.dd5a22eb", null), confidential = TRUE)

	CONFIG_SET(flag/force_random_names, TRUE)
	BLACKBOX_LOG_ADMIN_VERB("Make Everyone Random")

ADMIN_VERB(mass_zombie_infection, R_ADMIN, "大规模僵尸感染", "Infects all humans with a latent organ that will zombify them on death.", ADMIN_CATEGORY_FUN)
	var/confirm = tgui_alert(user, LANG("datum.89c2830d", null), LANG("datum.05c2b009", null), list("Yes", "No"))
	if(confirm != "Yes")
		return

	for(var/i in GLOB.human_list)
		var/mob/living/carbon/human/H = i
		new /obj/item/organ/zombie_infection/nodamage(H)

	message_admins("[key_name_admin(user)] added a latent zombie infection to all humans.")
	log_admin("[key_name(user)] added a latent zombie infection to all humans.")
	BLACKBOX_LOG_ADMIN_VERB("Mass Zombie Infection")

ADMIN_VERB(mass_zombie_cure, R_ADMIN, "大规模僵尸解药", "Removes the zombie infection from all humans, returning them to normal.", ADMIN_CATEGORY_FUN)
	var/confirm = tgui_alert(user, LANG("datum.aad26d25", null), LANG("datum.24acebd6", null), list("Yes", "No"))
	if(confirm != "Yes")
		return

	for(var/obj/item/organ/zombie_infection/nodamage/I in GLOB.zombie_infection_list)
		qdel(I)

	message_admins("[key_name_admin(user)] cured all zombies.")
	log_admin("[key_name(user)] cured all zombies.")
	BLACKBOX_LOG_ADMIN_VERB("Mass Zombie Cure")

ADMIN_VERB(polymorph_all, R_ADMIN, "全体变形", "Applies the effects of the bolt of change to every single mob.", ADMIN_CATEGORY_FUN)
	var/confirm = tgui_alert(user, LANG("datum.38e59b16", null), LANG("datum.8dd47e18", null), list("Yes", "No"))
	if(confirm != "Yes")
		return

	var/list/mobs = shuffle(GLOB.alive_mob_list.Copy()) // might change while iterating
	var/who_did_it = key_name_admin(user)

	message_admins("[key_name_admin(user)] started polymorphed all living mobs.")
	log_admin("[key_name(user)] polymorphed all living mobs.")
	BLACKBOX_LOG_ADMIN_VERB("Polymorph All")

	for(var/mob/living/M in mobs)
		CHECK_TICK

		if(!M)
			continue

		M.audible_message(span_hear(LANG("datum.f507a8a3", null)))
		playsound(M.loc, 'sound/effects/magic/staff_change.ogg', 50, TRUE, -1)

		M.wabbajack()

	message_admins("Mass polymorph started by [who_did_it] is complete.")

/// Allow admin to mass add or remove a trait across all mobs
ADMIN_VERB(mass_modify_traits, R_FUN, "批量修改特质", "Adds or removes a trait from every mob.", ADMIN_CATEGORY_FUN)

	var/choice = tgui_alert(user, LANG("datum.f96d316f", null), LANG("datum.271c7b93", null), list("Add", "Remove"))
	if(isnull(choice))
		return
	var/is_add = (choice == "Add")
	var/lower_choice = LOWER_TEXT(choice)

	// Build list of valid traits that can be applied to mobs
	var/list/available_traits = list()
	for(var/key in GLOB.admin_visible_traits)
		if(ispath(/mob, key)) // so we get atom and atom/movable traits too, which doing (istype(key, /mob)) would skip
			available_traits += GLOB.admin_visible_traits[key]
	if(!length(available_traits))
		return

	available_traits = sort_list(available_traits, GLOBAL_PROC_REF(cmp_typepaths_asc)) // sort alphabetically

	var/mob_trait = tgui_input_list(user, LANG("datum.327cf921", list(lower_choice)), LANG("datum.e4888064", list(choice)), available_traits)
	if(isnull(mob_trait))
		return
	mob_trait = available_traits[mob_trait]

	var/target_scope = tgui_alert(user, LANG("datum.71815cab", list(choice, lower_choice == "add" ? "to" : "from")), LANG("datum.4947bf34", null), list("All", "Cliented"))
	if(!target_scope)
		return
	var/cliented_only = (target_scope == "Cliented")

	// So we get readable trait name to display in the uis
	if(!GLOB.admin_trait_name_map)
		GLOB.admin_trait_name_map = generate_admin_trait_name_map()
	var/trait_name = GLOB.admin_trait_name_map[mob_trait] || mob_trait

	// Ask for confirmation first
	var/action_word = is_add ? "to" : "from"
	var/confirm = tgui_alert(
		user,
		LANG("datum.51eff0b4", list(lower_choice, trait_name, action_word, cliented_only ? "cliented" : "")),
		LANG("datum.3c150c7e", list(choice)),
		list("Yes", "No")
	)
	if(confirm != "Yes")
		return

	// Perform operation
	var/affected = 0
	if(is_add) // Adding trait
		var/needs_movetype = GLOB.movement_type_trait_to_flag[mob_trait]
		for(var/mob/mob_to_modify as anything in GLOB.alive_mob_list)
			if(cliented_only && !mob_to_modify.client)
				continue
			if(needs_movetype)
				mob_to_modify.AddElement(/datum/element/movetype_handler)
			ADD_TRAIT(mob_to_modify, mob_trait, TRAIT_ADMIN_GRANTED)
			affected++

	else // Removing trait
		var/source = null
		var/remove_mode = tgui_alert(user, LANG("datum.f0dd0e6d", null), LANG("datum.233d7511", null), list("All", "Admin-Granted Traits", "Specific"))
		if(isnull(remove_mode))
			return

		switch(remove_mode)
			if("Admin-Granted Traits") source = TRAIT_ADMIN_GRANTED
			if("Specific")
				source = LOWER_TEXT(tgui_input_text(user, "Enter source", "Mass Remove Trait", max_length = MAX_NAME_LEN))
				if(isnull(source))
					return

		for(var/mob/mob_to_modify as anything in GLOB.alive_mob_list)
			if(cliented_only && !mob_to_modify.client)
				continue
			REMOVE_TRAIT(mob_to_modify, mob_trait, source)
			affected++

	if(affected)
		var/plural = affected == 1 ? "mob" : "mobs"
		var/log_msg = "[key_name_admin(user)] mass [lower_choice][is_add ? "ed" : "d"] [trait_name] [action_word] [affected] [plural]."
		message_admins(log_msg)
		log_admin(log_msg)

/// Returns only traits that apply to mobs
/proc/get_mob_admin_traits()
	var/list/out = list()
	for(var/key in GLOB.admin_visible_traits)
		if(ispath(key, /mob)) // key is a mob type or subtype
			out += GLOB.admin_visible_traits[key]
	return out

ADMIN_VERB_AND_CONTEXT_MENU(admin_smite, R_ADMIN|R_FUN, "惩戒", "Smite a player with divine power.", ADMIN_CATEGORY_FUN, /mob/living)
	VERB_ARG_TYPED(target, VERB_ARG_TYPE_MOB, VERB_ARG_SOURCE_WORLD, /mob/living)
	var/punishment = tgui_input_list(user, LANG("datum.60db9e8f", null), LANG("datum.9d9602b1", null), GLOB.smites)

	if(QDELETED(target) || !punishment)
		return

	var/smite_path = GLOB.smites[punishment]
	var/datum/smite/smite = new smite_path
	var/configuration_success = smite.configure(user)
	if (configuration_success == FALSE)
		return
	smite.do_effect(user, target)

/// "Turns" people into objects. Really, we just add them to the contents of the item.
/proc/objectify(atom/movable/target, path_or_instance)
	var/atom/tomb
	if(ispath(path_or_instance))
		tomb = new path_or_instance(get_turf(target))
	else
		tomb = path_or_instance
	target.forceMove(tomb)
	target.AddComponent(/datum/component/itembound, tomb)

/**
 * firing_squad is a proc for the :B:erforate smite to shoot each individual bullet at them, so that we can add actual delays without sleep() nonsense
 *
 * Hilariously, if you drag someone away mid smite, the bullets will still chase after them from the original spot, possibly hitting other people. Too funny to fix imo
 *
 * Arguments:
 * * target- guy we're shooting obviously
 * * source_turf- where the bullet begins, preferably on a turf next to the target
 * * body_zone- which bodypart we're aiming for, if there is one there
 * * wound_bonus- the wounding power we're assigning to the bullet, since we don't care about the base one
 * * damage- the damage we're assigning to the bullet, since we don't care about the base one
 */
/proc/firing_squad(mob/living/carbon/target, turf/source_turf, body_zone, wound_bonus, damage)
	if(!target.get_bodypart(body_zone))
		return
	playsound(target, 'sound/items/weapons/gun/revolver/shot.ogg', 100)
	var/obj/projectile/bullet/smite/divine_wrath = new(source_turf)
	divine_wrath.damage = damage
	divine_wrath.wound_bonus = wound_bonus
	divine_wrath.original = target
	divine_wrath.def_zone = body_zone
	divine_wrath.spread = 0
	divine_wrath.aim_projectile(target, source_turf)
	divine_wrath.fire()

/client/proc/punish_log(whom, punishment)
	var/msg = "[key_name_admin(src)] punished [key_name_admin(whom)] with [punishment]."
	message_admins(msg)
	admin_ticket_log(whom, msg)
	log_admin("[key_name(src)] punished [key_name(whom)] with [punishment].")
