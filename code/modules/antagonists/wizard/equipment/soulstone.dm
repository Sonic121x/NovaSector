// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/item/soulstone
	name = "soulstone shard"
	icon = 'icons/obj/mining_zones/artefacts.dmi'
	icon_state = "soulstone"
	inhand_icon_state = "electronic"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	layer = HIGH_OBJ_LAYER
	desc = "A fragment of the legendary treasure known simply as the 'Soul Stone'. The shard still flickers with a fraction of the full artefact's power."
	w_class = WEIGHT_CLASS_TINY
	slot_flags = ITEM_SLOT_BELT
	/// The base name of the soulstone, set to the initial name by default. Used in name updating
	var/base_name
	/// if TRUE, we can only be used once.
	var/one_use = FALSE
	/// Only used if one_use is TRUE. Whether it's used.
	var/spent = FALSE
	/// if TRUE, our soulstone will work on mobs which are in crit. if FALSE, the mob must be dead.
	var/grab_sleeping = TRUE
	/// This controls the color of the soulstone as well as restrictions for who can use it.
	/// THEME_CULT is red and is the default of cultist
	/// THEME_WIZARD is purple and is the default of wizard
	/// THEME_HOLY is for purified soul stone
	var/theme = THEME_CULT
	/// Role check, if any needed
	var/required_role = /datum/antagonist/cult

/obj/item/soulstone/Initialize(mapload)
	. = ..()
	if(theme != THEME_HOLY)
		RegisterSignal(src, COMSIG_BIBLE_SMACKED, PROC_REF(on_bible_smacked))
	if(!base_name)
		base_name = initial(name)
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/mod_core_soul)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/soulstone/grind_results()
	return list(/datum/reagent/hauntium = 25, /datum/reagent/silicon = 10) //can be ground into hauntium

/obj/item/soulstone/update_appearance(updates)
	. = ..()
	for(var/mob/living/basic/shade/sharded_shade in src)
		switch(theme)
			if(THEME_HOLY)
				sharded_shade.name = "Purified [sharded_shade.real_name]"
			else
				sharded_shade.name = sharded_shade.real_name
		sharded_shade.theme = theme
		sharded_shade.update_appearance(UPDATE_ICON_STATE)

/obj/item/soulstone/update_icon_state()
	. = ..()
	switch(theme)
		if(THEME_HOLY)
			icon_state = "purified_soulstone"
		if(THEME_CULT)
			icon_state = "soulstone"
		if(THEME_WIZARD)
			icon_state = "mystic_soulstone"

	if(contents.len)
		icon_state = "[icon_state]2"

/obj/item/soulstone/update_name(updates)
	. = ..()
	name = base_name
	if(spent)
		// "dull soulstone"
		name = "dull [name]"

	var/mob/living/basic/shade/shade = locate() in src
	if(shade)
		// "(dull) soulstone: Urist McCaptain"
		name = "[name]: [shade.real_name]"

/obj/item/soulstone/update_desc(updates)
	. = ..()
	if(spent)
		desc = LANG("obj.d4c1a629685f0752", null)

///signal called whenever a soulstone is smacked by a bible
/obj/item/soulstone/proc/on_bible_smacked(datum/source, mob/living/user, ...)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(attempt_exorcism), user)

/**
 * attempt_exorcism: called from on_bible_smacked, takes time and if successful
 * resets the item to a pre-possessed state
 *
 * Arguments:
 * * exorcist: user who is attempting to remove the spirit
 */
/obj/item/soulstone/proc/attempt_exorcism(mob/exorcist)
	if(IS_CULTIST(exorcist) || theme == THEME_HOLY)
		return
	balloon_alert(exorcist, LANG("obj.833ce5de64242087", null))
	playsound(src, 'sound/effects/hallucinations/veryfar_noise.ogg', 40, TRUE)
	if(!do_after(exorcist, 4 SECONDS, target = src))
		return
	playsound(src, 'sound/effects/pray_chaplain.ogg', 60, TRUE)
	required_role = null
	theme = THEME_HOLY

	update_appearance()
	for(var/mob/shade_to_deconvert in contents)
		assign_master(shade_to_deconvert, exorcist)

	exorcist.visible_message(span_notice(LANG("obj.453de01c95323b6c", list(exorcist, src))))
	UnregisterSignal(src, COMSIG_BIBLE_SMACKED)

/**
 * corrupt: turns the soulstone into a cult one and turns the occupant shade, if any, into a cultist
 */
/obj/item/soulstone/proc/corrupt()
	if(theme == THEME_CULT)
		return FALSE

	required_role = /datum/antagonist/cult
	theme = THEME_CULT
	update_appearance()
	for(var/mob/shade_to_convert in contents)
		if(IS_CULTIST(shade_to_convert))
			continue
		shade_to_convert.mind?.add_antag_datum(/datum/antagonist/cult/shade)

	RegisterSignal(src, COMSIG_BIBLE_SMACKED)
	return TRUE

/// Checks if the passed mob has the required antag datum set on the soulstone.
/obj/item/soulstone/proc/role_check(mob/who)
	return required_role ? (who.mind && who.mind.has_antag_datum(required_role, TRUE)) : TRUE

/// Called whenever the soulstone releases a shade from it.
/obj/item/soulstone/proc/on_release_spirits()
	if(!one_use)
		return

	spent = TRUE
	update_appearance()

/obj/item/soulstone/pickup(mob/living/user)
	..()
	if(!role_check(user))
		to_chat(user, span_danger(LANG("obj.b53e4fc9c674002a", list(src))))

/obj/item/soulstone/examine(mob/user)
	. = ..()
	if(role_check(user) || isobserver(user))
		if(!grab_sleeping)
			. += span_cult(LANG("obj.e1ae6ee10e53f8b0", null))
		else
			. += span_cult(LANG("obj.d99e3a93031446d0", null))
		. += span_cult(LANG("obj.333eb1336db694a6", null))
		if(spent)
			. += span_cult(LANG("obj.fc474f0f5ad3d9cb", null))

/obj/item/soulstone/examine_more(mob/user)
	. = ..()
	if(!isliving(user) || isnull(user.mind))
		return

/obj/item/soulstone/Destroy() //Stops the shade from being qdel'd immediately and their ghost being sent back to the arrival shuttle.
	for(var/mob/living/basic/shade/shade in src)
		INVOKE_ASYNC(shade, TYPE_PROC_REF(/mob/living, death))
	return ..()

/obj/item/soulstone/proc/hot_potato(mob/living/user)
	to_chat(user, span_userdanger(LANG("obj.558bea3c14278ee3", list(src))))
	user.apply_damage(10, BURN, user.get_active_hand())
	user.emote("scream")
	user.update_damage_overlays()
	user.dropItemToGround(src)

//////////////////////////////Capturing////////////////////////////////////////////////////////

/obj/item/soulstone/attack(mob/living/carbon/human/M, mob/living/user)
	if(!role_check(user))
		user.Unconscious(10 SECONDS)
		to_chat(user, span_userdanger(LANG("obj.29802e49f7c6ba9f", null)))
		return
	if(spent)
		to_chat(user, span_warning(LANG("obj.a125b8de39a248ec", list(src))))
		return
	if(!ishuman(M))//If target is not a human.
		return ..()
	if(M == user)
		return
	if(IS_CULTIST(M) && IS_CULTIST(user))
		to_chat(user, span_cult_large(LANG("obj.22edd2e3943b47a0", null)))
		return
	if(theme == THEME_HOLY && IS_CULTIST(user))
		hot_potato(user)
		return
	if(HAS_TRAIT(M, TRAIT_NO_SOUL))
		to_chat(user, span_warning(LANG("obj.91a8a3de39f9904e", null)))
		return
	// NOVA EDIT START
	if(!do_after(user, 5 SECONDS, M))
		to_chat(user, span_warning(LANG("obj.e941a517f20175c4", null)))
		return
	// NOVA EDIT END
	log_combat(user, M, "captured [M.name]'s soul", src)
	capture_soul(M, user)

/obj/item/soulstone/suicide_act(mob/living/user)
	. = ..()
	user.visible_message(span_suicide(LANG("obj.b90e5d22d86d4b66", list(user, user.p_their(), src, user.p_theyre()))))
	return capture_soul(user, null, TRUE) ? MANUAL_SUICIDE : BRUTELOSS

///////////////////Options for using captured souls///////////////////////////////////////

/obj/item/soulstone/attack_self(mob/living/user)
	if(!in_range(src, user))
		return
	if(!role_check(user))
		user.Unconscious(100)
		to_chat(user, span_userdanger(LANG("obj.29802e49f7c6ba9f", null)))
		return
	if(theme == THEME_HOLY && IS_CULTIST(user))
		hot_potato(user)
		return
	release_shades(user)

/obj/item/soulstone/proc/release_shades(mob/user, silent = FALSE)
	for(var/mob/living/basic/shade/captured_shade in src)
		captured_shade.forceMove(get_turf(user))
		captured_shade.cancel_camera()
		update_appearance()
		if(!silent)
			if(IS_CULTIST(user))
				to_chat(captured_shade, span_bold(LANG("obj.82f5e413cadaf63a", null)))

			else if(role_check(user))
				to_chat(captured_shade, span_bold(LANG("obj.c2f20c021fb82ddf", list(user.real_name, user.p_them(), user.p_their()))))
		var/datum/antagonist/cult/shade/shade_datum = captured_shade.mind?.has_antag_datum(/datum/antagonist/cult/shade)
		if(shade_datum)
			shade_datum.release_time = world.time
		on_release_spirits()

/obj/item/soulstone/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	var/mob/living/basic/shade/occupant = locate() in src
	var/obj/item/storage/toolbox/mechanical/target_toolbox = interacting_with
	if(isnull(occupant) || !istype(target_toolbox) || target_toolbox.has_soul)
		return NONE

	if(theme == THEME_HOLY && IS_CULTIST(user))
		hot_potato(user)
		return ITEM_INTERACT_BLOCKING
	if(!role_check(user))
		user.Unconscious(10 SECONDS)
		to_chat(user, span_userdanger(LANG("obj.29802e49f7c6ba9f", null)))
		return ITEM_INTERACT_BLOCKING

	user.visible_message(span_notice(LANG("obj.cb2c91c4a5487c45", list(user, src, user.p_their(), target_toolbox))), \
		span_notice(LANG("obj.72e96cff006487e1", list(src, target_toolbox, occupant))), ignored_mobs = occupant)
	to_chat(occupant, span_userdanger(LANG("obj.f64835d2d722252a", list(user, target_toolbox))))
	to_chat(occupant, span_deadsay(LANG("obj.e2eada4ee1e5685c", null)))

	occupant.client?.give_award(/datum/award/achievement/misc/toolbox_soul, occupant)
	occupant.death_message = "shrieks out in unholy pain as [occupant.p_their()] soul is absorbed into [target_toolbox]!"
	release_shades(user, TRUE)
	occupant.death()

	target_toolbox.name = "soulful toolbox"
	target_toolbox.icon = 'icons/obj/storage/toolbox.dmi'
	target_toolbox.icon_state = "toolbox_blue_old"
	target_toolbox.has_soul = TRUE
	target_toolbox.has_latches = FALSE
	return ITEM_INTERACT_SUCCESS

///////////////////////////Transferring to constructs/////////////////////////////////////////////////////
/obj/structure/constructshell
	name = "empty shell"
	icon = 'icons/mob/shells.dmi'
	icon_state = "construct_cult"
	desc = "A wicked machine used by those skilled in magical arts. It is inactive."
	var/extra_desc = span_cult("A construct shell, used to house bound souls from a soulstone.\n\
		Placing a soulstone with a soul into this shell allows you to produce your choice of the following:\n\
		An <b>Artificer</b>, which can produce <b>more shells and soulstones</b>, as well as fortifications.\n\
		A <b>Wraith</b>, which does high damage and can jaunt through walls, though it is quite fragile.\n\
		A <b>Juggernaut</b>, which is very hard to kill and can produce temporary walls, but is slow.")

/obj/structure/constructshell/examine(mob/user)
	. = ..()
	if(IS_CULTIST(user) || HAS_MIND_TRAIT(user, TRAIT_MAGICALLY_GIFTED) || user.stat == DEAD)
		. += extra_desc

/obj/structure/constructshell/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/soulstone))
		return NONE

	var/obj/item/soulstone/whispering_gem = tool
	if(!IS_CULTIST(user) && !HAS_MIND_TRAIT(user, TRAIT_MAGICALLY_GIFTED) && whispering_gem.theme != THEME_HOLY)
		to_chat(user, span_danger(LANG("obj.fd1e6ae4163ff17f", list(whispering_gem))))
		user.set_dizzy_if_lower(1 MINUTES)
		return ITEM_INTERACT_BLOCKING

	if(whispering_gem.theme == THEME_HOLY && IS_CULTIST(user))
		whispering_gem.hot_potato(user)
		return ITEM_INTERACT_BLOCKING

	whispering_gem.transfer_to_construct(src, user)
	return ITEM_INTERACT_SUCCESS

/// Procs for moving soul in and out off stone

/// Transfer the mind of a carbon mob (which is then dusted) into a shade mob inside src.
/// If forced, sacrificial and stat checks are skipped.
/obj/item/soulstone/proc/capture_soul(mob/living/carbon/victim, mob/user, forced = FALSE)
	if(!iscarbon(victim)) //TODO: Add sacrifice stoning for non-organics, just because you have no body doesn't mean you don't have a soul
		return FALSE
	if(contents.len)
		return FALSE

	if(!forced)
		var/datum/antagonist/cult/cultist = GET_CULTIST(user)
		if(cultist)
			var/datum/team/cult/cult_team = cultist.get_team()
			if(victim.mind && cult_team.is_sacrifice_target(victim.mind))
				to_chat(user, span_cult(LANG("obj.59d7e41b8aeeaf88", null)))
				return FALSE

		if(grab_sleeping ? !IS_UNCONSCIOUS_OR_CRIT(victim) : victim.stat != DEAD)
			to_chat(user, span_userdanger(LANG("obj.9f9feb89e767288b", null)))
			to_chat(user, span_danger(LANG("obj.b13070360ef32c23", null)))
			return FALSE

	victim.grab_ghost()
	if(victim.client)
		init_shade(victim, user)
		return TRUE

	to_chat(user, span_userdanger(LANG("obj.9f9feb89e767288b", null)))
	to_chat(user, span_warning(LANG("obj.e3c10a493bf5b161", null)))
	var/mob/chosen_one = SSpolling.poll_ghosts_for_target(
		check_jobban = ROLE_CULTIST,
		poll_time = 20 SECONDS,
		checked_target = src,
		ignore_category = POLL_IGNORE_SHADE,
		alert_pic = /mob/living/basic/shade,
		jump_target = src,
		role_name_text = "a shade",
		chat_text_border_icon = /mob/living/basic/shade,
	)
	on_poll_concluded(user, victim, chosen_one)
	return TRUE //it'll probably get someone ;)

///captures a shade that was previously released from a soulstone.
/obj/item/soulstone/proc/capture_shade(mob/living/basic/shade/shade, mob/living/user)
	if(isliving(user) && !role_check(user))
		user.Unconscious(10 SECONDS)
		to_chat(user, span_userdanger(LANG("obj.29802e49f7c6ba9f", null)))
		return
	if(contents.len)
		to_chat(user, span_userdanger(LANG("obj.9f9feb89e767288b", null)))
		to_chat(user, span_danger(LANG("obj.fb2dd9889c2eef2d", list(src))))
		return FALSE
	shade.AddComponent(/datum/component/soulstoned, src)
	update_appearance()

	to_chat(shade, span_notice(LANG("obj.62696d214aa9fe03", list(src))))

	var/datum/antagonist/cult/shade/shade_datum = shade.mind?.has_antag_datum(/datum/antagonist/cult/shade)
	if(shade_datum)
		shade_datum.release_time = null

	if(user != shade)
		to_chat(user, LANG("obj.c8ae41e77e49d330", list(span_info("<b>Capture successful!</b>:"), shade.real_name, src)))
		assign_master(shade, user)

	return TRUE

///transfer the mind of the shade to a construct mob selected by the user, then deletes both the shade and src.
/obj/item/soulstone/proc/transfer_to_construct(obj/structure/constructshell/shell, mob/user)
	var/mob/living/basic/shade/shade = locate() in src
	if(!shade)
		to_chat(user, LANG("obj.816798f8ef683785", list(span_userdanger("Creation failed!"), src)))
		return FALSE
	var/construct_class = show_radial_menu(user, src, GLOB.construct_radial_images, custom_check = CALLBACK(src, PROC_REF(check_menu), user, shell), require_near = TRUE, tooltips = TRUE)
	if(QDELETED(shell) || !construct_class)
		return FALSE
	shade.mind?.remove_antag_datum(/datum/antagonist/cult)
	make_new_construct_from_class(construct_class, theme, shade, user, FALSE, shell.loc)
	qdel(shell)
	qdel(src)
	return TRUE

/obj/item/soulstone/proc/check_menu(mob/user, obj/structure/constructshell/shell)
	if(!istype(user))
		return FALSE
	if(user.incapacitated || !user.is_holding(src) || !shell.IsReachableBy(user, reach))
		return FALSE
	return TRUE

/**
 * Creates a new shade mob to inhabit the stone.
 *
 * victim - the body that's being shaded
 * user - the person doing the shading. Optional.
 * message_user - if TRUE, we send the user (if present) a message that a shade has been created / captured.
 * shade_controller - the mob (usually, a ghost) that will take over control of the victim / new shade. Optional, if not passed the victim itself will take control.
 */
/obj/item/soulstone/proc/init_shade(mob/living/carbon/human/victim, mob/user, message_user = FALSE, mob/shade_controller)
	if(!shade_controller)
		shade_controller = victim
	victim.stop_sound_channel(CHANNEL_HEARTBEAT)
	var/mob/living/basic/shade/soulstone_spirit = new /mob/living/basic/shade(src)
	soulstone_spirit.AddComponent(/datum/component/soulstoned, src)
	soulstone_spirit.name = "Shade of [victim.real_name]"
	soulstone_spirit.real_name = "Shade of [victim.real_name]"
	soulstone_spirit.PossessByPlayer(shade_controller.key)
	soulstone_spirit.copy_languages(victim, LANGUAGE_MIND)//Copies the old mobs languages into the new mob holder.
	if(user)
		soulstone_spirit.copy_languages(user, LANGUAGE_MASTER)
	soulstone_spirit.get_language_holder().omnitongue = TRUE //Grants omnitongue
	if(user)
		soulstone_spirit.add_ally(user) //Add the master as a faction, allowing inter-mob cooperation
		if(IS_CULTIST(user))
			soulstone_spirit.mind.add_antag_datum(/datum/antagonist/cult/shade)
			SSblackbox.record_feedback("tally", "cult_shade_created", 1)

	soulstone_spirit.cancel_camera()
	update_appearance()
	if(user)
		if(IS_CULTIST(user))
			to_chat(soulstone_spirit, span_bold(LANG("obj.ffef12b2855ea29a", null)))
		else if(role_check(user))
			to_chat(soulstone_spirit, span_bold(LANG("obj.5eed4a77515d4928", list(user.real_name, user.p_them(), user.p_their()))))
			assign_master(soulstone_spirit, user)

		if(message_user)
			to_chat(user, LANG("obj.7ff52b6363f18e64", list(span_info("<b>Capture successful!</b>:"), victim.real_name, victim.p_their(), src)))

	victim.dust(drop_items = TRUE)

/**
 * Assigns the bearer as the new master of a shade.
 */
/obj/item/soulstone/proc/assign_master(mob/shade, mob/user)
	if (!shade || !user || !shade.mind)
		return

	// Cult shades get cult datum
	if (user.mind.has_antag_datum(/datum/antagonist/cult))
		shade.mind.remove_antag_datum(/datum/antagonist/shade_minion)
		shade.mind.add_antag_datum(/datum/antagonist/cult/shade)
		return

	// Only blessed soulstones can de-cult shades
	if(theme == THEME_HOLY)
		shade.mind.remove_antag_datum(/datum/antagonist/cult)

	var/datum/antagonist/shade_minion/shade_datum = shade.mind.has_antag_datum(/datum/antagonist/shade_minion)
	if (!shade_datum)
		shade_datum = shade.mind.add_antag_datum(/datum/antagonist/shade_minion)
	shade_datum.update_master(user.real_name)

/// Called when a ghost is chosen to become a shade.
/obj/item/soulstone/proc/on_poll_concluded(mob/living/master, mob/living/victim, mob/dead/observer/ghost)
	if(isnull(victim) || master.incapacitated || !master.is_holding(src) || !victim.IsReachableBy(master, reach))
		return FALSE
	if(isnull(ghost?.client))
		to_chat(master, span_danger(LANG("obj.b1074db901e67df1", null)))
		return FALSE
	if(length(contents)) //If they used the soulstone on someone else in the meantime
		return FALSE
	to_chat(master, LANG("obj.3e6d3007513903ea", list(span_info("<b>Capture successful!</b>:"), src, victim)))
	init_shade(victim, master, shade_controller = ghost)

	return TRUE

/proc/make_new_construct_from_class(construct_class, theme, mob/target, mob/creator, cultoverride, loc_override)
	switch(construct_class)
		if(CONSTRUCT_JUGGERNAUT)
			if(IS_CULTIST(creator))
				make_new_construct(/mob/living/basic/construct/juggernaut, target, creator, cultoverride, loc_override) // ignore themes, the actual giving of cult info is in the make_new_construct proc
				SSblackbox.record_feedback("tally", "cult_shade_to_jugger", 1)
				return
			switch(theme)
				if(THEME_WIZARD)
					make_new_construct(/mob/living/basic/construct/juggernaut/mystic, target, creator, cultoverride, loc_override)
				if(THEME_HOLY)
					make_new_construct(/mob/living/basic/construct/juggernaut/angelic, target, creator, cultoverride, loc_override)
				if(THEME_CULT)
					make_new_construct(/mob/living/basic/construct/juggernaut, target, creator, cultoverride, loc_override)
		if(CONSTRUCT_WRAITH)
			if(IS_CULTIST(creator))
				make_new_construct(/mob/living/basic/construct/wraith, target, creator, cultoverride, loc_override) // ignore themes, the actual giving of cult info is in the make_new_construct proc
				SSblackbox.record_feedback("tally", "cult_shade_to_wraith", 1)
				return
			switch(theme)
				if(THEME_WIZARD)
					make_new_construct(/mob/living/basic/construct/wraith/mystic, target, creator, cultoverride, loc_override)
				if(THEME_HOLY)
					make_new_construct(/mob/living/basic/construct/wraith/angelic, target, creator, cultoverride, loc_override)
				if(THEME_CULT)
					make_new_construct(/mob/living/basic/construct/wraith, target, creator, cultoverride, loc_override)
		if(CONSTRUCT_ARTIFICER)
			if(IS_CULTIST(creator))
				make_new_construct(/mob/living/basic/construct/artificer, target, creator, cultoverride, loc_override) // ignore themes, the actual giving of cult info is in the make_new_construct proc
				SSblackbox.record_feedback("tally", "cult_shade_to_arti", 1)
				return
			switch(theme)
				if(THEME_WIZARD)
					make_new_construct(/mob/living/basic/construct/artificer/mystic, target, creator, cultoverride, loc_override)
				if(THEME_HOLY)
					make_new_construct(/mob/living/basic/construct/artificer/angelic, target, creator, cultoverride, loc_override)
				if(THEME_CULT)
					make_new_construct(/mob/living/basic/construct/artificer/noncult, target, creator, cultoverride, loc_override)
		if(CONSTRUCT_HARVESTER)
			if(IS_HERETIC_OR_MONSTER(creator))
				make_new_construct(/mob/living/basic/construct/harvester/heretic, target, creator, cultoverride, loc_override)
			else
				make_new_construct(/mob/living/basic/construct/harvester, target, creator, cultoverride, loc_override)

/proc/make_new_construct(mob/living/basic/construct/ctype, mob/target, mob/stoner = null, cultoverride = FALSE, loc_override = null, ghost_activated = FALSE)
	if(QDELETED(target))
		return
	var/mob/living/basic/construct/newstruct = new ctype(loc_override || get_turf(target))
	var/makeicon = newstruct.icon_state
	var/theme = newstruct.theme
	flick("make_[makeicon][theme]", newstruct)
	playsound(newstruct, 'sound/effects/constructform.ogg', 50)
	if(stoner)
		newstruct.add_ally(stoner)
		newstruct.construct_master = stoner
		var/datum/action/innate/seek_master/seek_master = new
		seek_master.Grant(newstruct)

	if(ghost_activated)
		if(isnull(target.mind))
			newstruct.PossessByPlayer(target.ckey)
		else
			target.mind.transfer_to(newstruct, force_key_move = TRUE)

	else if (!target.ckey || isnull(target.mind) || is_banned_from(target.ckey, ROLE_CULTIST))
		to_chat(stoner, span_userdanger(LANG("_root.8a5d84ad19ef2844", null)))
		to_chat(stoner, span_warning(LANG("_root.e3c10a493bf5b161", null)))
		target = SSpolling.poll_ghosts_for_target(
			"Do you want to play as [span_danger(newstruct.real_name)]?",
			check_jobban = ROLE_CULTIST,
			role = ROLE_CULTIST,
			poll_time = 10 SECONDS,
			checked_target = newstruct,
			alert_pic = newstruct,
			role_name_text = "inactive construct",
			ignore_category = POLL_IGNORE_SHADE
		)

		if (QDELETED(newstruct))
			return

		if (!target?.client)
			if (!QDELETED(stoner))
				to_chat(stoner, span_danger(LANG("_root.2814330cade8056a", null)))
			new /obj/structure/constructshell(newstruct.drop_location())
			qdel(newstruct)
			return

		if (!QDELETED(stoner))
			to_chat(stoner, span_notice(LANG("_root.98c8e2065f0450cb", list(newstruct))))
		newstruct.PossessByPlayer(target.ckey)
	else
		target.mind.transfer_to(newstruct, force_key_move = TRUE)

	var/atom/movable/screen/alert/bloodsense/sense_alert
	if(newstruct.mind && !IS_CULTIST(newstruct) && ((stoner && IS_CULTIST(stoner)) || cultoverride) && SSticker.HasRoundStarted())
		newstruct.mind.add_antag_datum(/datum/antagonist/cult/construct)
	if(cultoverride || (stoner && IS_CULTIST(stoner)))
		to_chat(newstruct, span_cult_bold(LANG("_root.28172a6ccaa188de", list(stoner ? " and [stoner]" : "", stoner?.p_their() || "their", stoner?.p_them() || "them", stoner?.p_their() || "their"))))
	else if(stoner)
		to_chat(newstruct, span_boldwarning(LANG("_root.42ebee1cc43f7178", list(stoner, stoner.p_their(), stoner.p_them(), stoner.p_their()))))
	newstruct.clear_alert("bloodsense")
	sense_alert = newstruct.throw_alert("bloodsense", /atom/movable/screen/alert/bloodsense)
	if(sense_alert)
		sense_alert.construct_owner = newstruct
	newstruct.cancel_camera()

/obj/item/soulstone/anybody
	required_role = null

/obj/item/ectoplasm
	name = "ectoplasm"
	desc = "Spooky."
	gender = PLURAL
	icon = 'icons/effects/magic.dmi'
	icon_state = "ectoplasm"

/obj/item/ectoplasm/grind_results()
	return list(/datum/reagent/hauntium = 25)

/obj/item/ectoplasm/suicide_act(mob/living/user)
	user.visible_message(span_suicide(LANG("obj.64bdc72d0d95d39e", list(user, src, user.p_theyre()))))
	return OXYLOSS

/obj/item/soulstone/mystic
	icon_state = "mystic_soulstone"
	theme = THEME_WIZARD
	required_role = /datum/antagonist/wizard

/obj/item/ectoplasm/mystic
	icon_state = "mysticplasm"

/obj/item/soulstone/anybody/revolver
	one_use = TRUE
	grab_sleeping = FALSE

/obj/item/soulstone/anybody/purified
	icon_state = "purified_soulstone"
	theme = THEME_HOLY

/obj/item/ectoplasm/angelic
	icon = 'icons/effects/magic.dmi'
	icon_state = "angelplasm"

/obj/item/soulstone/anybody/chaplain
	name = "mysterious old shard"
	one_use = TRUE
	grab_sleeping = FALSE

/obj/item/soulstone/anybody/chaplain/sparring
	name = "divine punishment"
	desc = "A prison for those who lost a divine game."
	icon_state = "purified_soulstone"
	theme = THEME_HOLY

/obj/item/soulstone/anybody/chaplain/sparring/Initialize(mapload)
	. = ..()
	name = "[GLOB.deity]'s punishment"
	base_name = name
	desc = LANG("obj.f9a21314c1094dc1", list(GLOB.deity))

/obj/item/soulstone/anybody/mining
	grab_sleeping = FALSE
