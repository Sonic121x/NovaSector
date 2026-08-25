// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/*
 * Component for items that are used by cultists to conduct rituals.
 *
 * - Draws runes, including the rune to summon Nar'sie.
 * - Purges cultists of holy water on attack.
 * - (Un/re)anchors cult structures when hit.
 * - Instantly destroys cult girders on hit.
 */
/datum/component/cult_ritual_item
	/// Whether we are currently being used to draw a rune.
	var/drawing_a_rune = FALSE
	/// The message displayed when the parent is examined, if supplied.
	var/examine_message
	/// A list of turfs that we scribe runes at double speed on.
	var/list/turfs_that_boost_us
	/// A list of all shields surrounding us while drawing certain runes (Nar'sie).
	var/list/obj/structure/emergency_shield/cult/narsie/shields
	/// Weakref to an action added to our parent item that allows for quick drawing runes
	var/datum/weakref/linked_action_ref

/datum/component/cult_ritual_item/Initialize(
	examine_message,
	action = /datum/action/item_action/cult_dagger,
	turfs_that_boost_us = /turf/open/floor/engine/cult,
	)

	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE

	src.examine_message = examine_message

	if(islist(turfs_that_boost_us))
		src.turfs_that_boost_us = turfs_that_boost_us
	else if(ispath(turfs_that_boost_us))
		src.turfs_that_boost_us = list(turfs_that_boost_us)

	if(ispath(action))
		var/obj/item/item_parent = parent
		var/datum/action/added_action = item_parent.add_item_action(action)
		linked_action_ref = WEAKREF(added_action)

/datum/component/cult_ritual_item/Destroy(force)
	cleanup_shields()
	QDEL_NULL(linked_action_ref)
	return ..()

/datum/component/cult_ritual_item/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ITEM_ATTACK_SELF, PROC_REF(try_scribe_rune))
	RegisterSignal(parent, COMSIG_ITEM_ATTACK, PROC_REF(try_purge_holywater))
	RegisterSignal(parent, COMSIG_ITEM_ATTACK_ATOM, PROC_REF(try_hit_object))
	RegisterSignal(parent, COMSIG_ITEM_ATTACK_EFFECT, PROC_REF(try_clear_rune))

	if(examine_message)
		RegisterSignal(parent, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))

/datum/component/cult_ritual_item/UnregisterFromParent()
	UnregisterSignal(parent, list(
		COMSIG_ITEM_ATTACK_SELF,
		COMSIG_ITEM_ATTACK,
		COMSIG_ITEM_ATTACK_ATOM,
		COMSIG_ITEM_ATTACK_EFFECT,
		COMSIG_ATOM_EXAMINE,
		))

/*
 * Signal proc for [COMSIG_ATOM_EXAMINE].
 * Gives the examiner, if they're a cultist, our set examine message.
 * Usually, this will include various instructions on how to use the thing.
 */
/datum/component/cult_ritual_item/proc/on_examine(datum/source, mob/examiner, list/examine_text)
	SIGNAL_HANDLER

	if(!IS_CULTIST(examiner))
		return

	examine_text += examine_message

/*
 * Signal proc for [COMSIG_ITEM_ATTACK_SELF].
 * Allows the user to begin scribing runes.
 */
/datum/component/cult_ritual_item/proc/try_scribe_rune(datum/source, mob/user)
	SIGNAL_HANDLER

	if(!isliving(user))
		return

	if(!can_scribe_rune(source, user))
		return

	if(drawing_a_rune)
		to_chat(user, span_warning(LANG("datum.ed2aeac44098a791", null)))
		return

	INVOKE_ASYNC(src, PROC_REF(start_scribe_rune), source, user)

	return COMPONENT_CANCEL_ATTACK_CHAIN

/*
 * Signal proc for [COMSIG_ITEM_ATTACK].
 * Allows for a cultist (user) to hit another cultist (target)
 * to purge them of all holy water in their system, transforming it into unholy water.
 */
/datum/component/cult_ritual_item/proc/try_purge_holywater(datum/source, mob/living/target, mob/living/user)
	SIGNAL_HANDLER

	if(!IS_CULTIST(user) || !IS_CULTIST(target))
		return

	. = COMPONENT_CANCEL_ATTACK_CHAIN // No hurting other cultists.

	if(!target.has_reagent(/datum/reagent/water/holywater))
		return

	INVOKE_ASYNC(src, PROC_REF(do_purge_holywater), target, user)

/*
 * Signal proc for [COMSIG_ITEM_ATTACK_ATOM].
 * Allows the ritual items to unanchor cult buildings or destroy rune girders.
 */
/datum/component/cult_ritual_item/proc/try_hit_object(datum/source, obj/structure/target, mob/cultist)
	SIGNAL_HANDLER

	if(!isliving(cultist) || !IS_CULTIST(cultist))
		return

	if(istype(target, /obj/structure/girder/cult))
		INVOKE_ASYNC(src, PROC_REF(do_destroy_girder), target, cultist)
		return COMPONENT_NO_AFTERATTACK


	if(istype(target, /obj/structure/destructible/cult))
		INVOKE_ASYNC(src, PROC_REF(do_unanchor_structure), target, cultist)
		return COMPONENT_NO_AFTERATTACK

/*
 * Signal proc for [COMSIG_ITEM_ATTACK_EFFECT].
 * Allows the ritual items to remove runes.
 */
/datum/component/cult_ritual_item/proc/try_clear_rune(datum/source, obj/effect/target, mob/living/cultist, params)
	SIGNAL_HANDLER

	if(!isliving(cultist) || !IS_CULTIST(cultist))
		return

	if(istype(target, /obj/effect/rune))
		INVOKE_ASYNC(src, PROC_REF(do_scrape_rune), target, cultist)
		return COMPONENT_NO_AFTERATTACK


/*
 * Actually go through and remove all holy water from [target] and convert it to unholy water.
 *
 * target - the target being hit, and having their holywater converted
 * cultist - the target doing the hitting, can be the same as target
 */
/datum/component/cult_ritual_item/proc/do_purge_holywater(mob/living/target, mob/living/cultist)
	// Allows cultists to be rescued from the clutches of ordained religion
	to_chat(cultist, span_cult(LANG("datum.762d7211b3986909", list(target, parent))))
	var/holy_to_unholy = target.reagents.get_reagent_amount(/datum/reagent/water/holywater)
	target.reagents.del_reagent(/datum/reagent/water/holywater)
	// For carbonss we also want to clear out the stomach of any holywater
	if(iscarbon(target))
		var/mob/living/carbon/carbon_target = target
		var/obj/item/organ/stomach/belly = carbon_target.get_organ_slot(ORGAN_SLOT_STOMACH)
		if(belly)
			holy_to_unholy += belly.reagents.get_reagent_amount(/datum/reagent/water/holywater)
			belly.reagents.del_reagent(/datum/reagent/water/holywater)
	target.reagents.add_reagent(/datum/reagent/fuel/unholywater, holy_to_unholy)
	log_combat(cultist, target, "smacked", parent, " removing the holy water from them")

/*
 * Destoys the target cult girder [cult_girder], acted upon by [cultist].
 *
 * cult_girder - the girder being destoyed
 * cultist - the mob doing the destroying
 */
/datum/component/cult_ritual_item/proc/do_destroy_girder(obj/structure/girder/cult/cult_girder, mob/living/cultist)
	playsound(cult_girder, 'sound/items/weapons/resonator_blast.ogg', 40, TRUE, ignore_walls = FALSE)
	cultist.visible_message(
		span_warning(LANG("datum.2acc8ee385edbc14", list(cultist, cult_girder, parent))),
		span_notice(LANG("datum.f8d2422dcedce062", list(cult_girder)))
		)
	new /obj/item/stack/sheet/runed_metal(cult_girder.drop_location())
	qdel(cult_girder)

/*
 * Unanchors the target cult building.
 *
 * cult_structure - the structure being unanchored or reanchored.
 * cultist - the mob doing the unanchoring.
 */
/datum/component/cult_ritual_item/proc/do_unanchor_structure(obj/structure/cult_structure, mob/living/cultist)
	playsound(cult_structure, 'sound/items/deconstruct.ogg', 30, TRUE, ignore_walls = FALSE)
	cult_structure.set_anchored(!cult_structure.anchored)
	to_chat(cultist, span_notice(LANG("datum.56831bbdda53f530", list(cult_structure.anchored ? "":"un", cult_structure, cult_structure.anchored ? "to":"from"))))

/*
 * Removes the targeted rune. If the rune is important, asks for confirmation and logs it.
 *
 * rune - the rune being deleted. Instance of a rune.
 * cultist - the mob deleting the rune
 */
/datum/component/cult_ritual_item/proc/do_scrape_rune(obj/effect/rune/rune, mob/living/cultist)
	if(rune.log_when_erased)
		var/confirm = tgui_alert(cultist, LANG("datum.eebcd33ae9e14c28", list(rune.cultist_name)), LANG("datum.ef2f5224994263f4", list(rune.cultist_name)), list("Proceed", "Abort"))
		if(confirm != "Proceed")
			return

		// Gee, good thing we made sure cultists can't input stall to grief their team and get banned anyway
		if(!can_scrape_rune(rune, cultist))
			return

	SEND_SOUND(cultist, 'sound/items/sheath.ogg')
	if(!do_after(cultist, rune.erase_time, target = rune))
		return

	if(!can_scrape_rune(rune, cultist))
		return

	if(rune.log_when_erased)
		cultist.log_message("erased a [rune.cultist_name] rune with [parent].", LOG_GAME)
		message_admins("[ADMIN_LOOKUPFLW(cultist)] erased a [rune.cultist_name] rune with [parent].")

	to_chat(cultist, span_notice(LANG("datum.2d4f53694abfcae6", list(LOWER_TEXT(rune.cultist_name)))))
	qdel(rune)

/*
 * Wraps the entire act of [/proc/do_scribe_rune] to ensure it properly enables or disables [var/drawing_a_rune].)
 *
 * tool - the parent, source of the signal - the item inscribing the rune, casted to item.
 * cultist - the mob scribing the rune
 */
/datum/component/cult_ritual_item/proc/start_scribe_rune(obj/item/tool, mob/living/cultist)
	drawing_a_rune = TRUE
	do_scribe_rune(tool, cultist)
	drawing_a_rune = FALSE

/*
 * Actually give the user input to begin scribing a rune.
 * Creates the new instance of the rune if successful.
 *
 * tool - the parent, source of the signal - the item inscribing the rune, casted to item.
 * cultist - the mob scribing the rune
 */
/datum/component/cult_ritual_item/proc/do_scribe_rune(obj/item/tool, mob/living/cultist)
	var/turf/our_turf = get_turf(cultist)
	var/obj/effect/rune/rune_to_scribe
	var/entered_rune_name
	var/chosen_keyword

	var/datum/antagonist/cult/user_antag = cultist.mind.has_antag_datum(/datum/antagonist/cult, TRUE)
	var/datum/team/cult/user_team = user_antag?.get_team()
	if(!user_antag || !user_team)
		stack_trace("[type] - [cultist] attempted to scribe a rune, but did not have an associated [user_antag ? "cult team":"cult antag datum"]!")
		return FALSE

	if(!LAZYLEN(GLOB.rune_types))
		to_chat(cultist, span_cult(LANG("datum.1d881f20b4e80a94", null)))
		stack_trace("[type] - [cultist] attempted to scribe a rune, but the global rune list is empty!")
		return FALSE

	entered_rune_name = tgui_input_list(cultist, LANG("datum.c98ec0400153f6a8", null), LANG("datum.7e07427ae1c1f298", null), GLOB.rune_types)
	if(isnull(entered_rune_name))
		return FALSE
	if(!can_scribe_rune(tool, cultist))
		return FALSE

	rune_to_scribe = GLOB.rune_types[entered_rune_name]
	if(!ispath(rune_to_scribe))
		stack_trace("[type] - [cultist] attempted to scribe a rune, but did not find a path from the global rune list!")
		return FALSE

	if(initial(rune_to_scribe.req_keyword))
		chosen_keyword = tgui_input_text(cultist, LANG("datum.faea84a16429dd45", null), LANG("datum.bf4a41cdcda96daa", null), max_length = MAX_NAME_LEN)
		if(!chosen_keyword)
			drawing_a_rune = FALSE
			start_scribe_rune(tool, cultist)
			return FALSE

	our_turf = get_turf(cultist) //we may have moved. adjust as needed...

	if(!can_scribe_rune(tool, cultist))
		return FALSE

	if(ispath(rune_to_scribe, /obj/effect/rune/summon) && (!is_station_level(our_turf.z) || istype(get_area(cultist), /area/space)))
		to_chat(cultist, span_cult_italic(LANG("datum.12fa5225ddc846e0", null)))
		return

	if(ispath(rune_to_scribe, /obj/effect/rune/apocalypse))
		if((world.time - SSticker.round_start_time) <= 6000)
			var/wait = 6000 - (world.time - SSticker.round_start_time)
			to_chat(cultist, span_cult_italic(LANG("datum.baf7409400f4b895", list(DisplayTimeText(wait)))))
			return
		if(!check_if_in_ritual_site(cultist, user_team, TRUE))
			return

	if(ispath(rune_to_scribe, /obj/effect/rune/narsie))
		if(!scribe_narsie_rune(cultist, user_team))
			return
		our_turf = get_turf(cultist) //we may have moved. adjust as needed...

	var/can_have_blood = CAN_HAVE_BLOOD(cultist)

	cultist.visible_message(
		span_warning("[cultist] [can_have_blood ? "cuts open [cultist.p_their()] arm and begins writing in [cultist.p_their()] own blood":"begins sketching out a strange design"]!"),
		span_cult(LANG("datum.623460378eba29df", list(can_have_blood ? "slice open your arm and ":"")))
		)

	if(can_have_blood)
		cultist.apply_damage(initial(rune_to_scribe.scribe_damage), BRUTE, pick(GLOB.arm_zones), wound_bonus = CANT_WOUND) // *cuts arm* *bone explodes* ever have one of those days?

	var/scribe_mod = initial(rune_to_scribe.scribe_delay)
	if(!initial(rune_to_scribe.no_scribe_boost) && (our_turf.type in turfs_that_boost_us))
		scribe_mod *= 0.5

	var/scribe_started = initial(rune_to_scribe.started_creating)
	var/scribe_failed = initial(rune_to_scribe.failed_to_create)
	if(scribe_started)
		var/datum/callback/startup = CALLBACK(GLOBAL_PROC, scribe_started)
		startup.Invoke()
	var/datum/callback/failed
	if(scribe_failed)
		failed = CALLBACK(GLOBAL_PROC, scribe_failed)

	SEND_SOUND(cultist, sound('sound/items/weapons/slice.ogg', 0, 1, 10))
	if(!do_after(cultist, scribe_mod, target = get_turf(cultist), timed_action_flags = IGNORE_SLOWDOWNS))
		cleanup_shields()
		failed?.Invoke()
		return FALSE
	if(!can_scribe_rune(tool, cultist))
		cleanup_shields()
		failed?.Invoke()
		return FALSE

	cultist.visible_message(
		span_warning(LANG("datum.7d95df5f97829d79", list(cultist, can_have_blood ? " in [cultist.p_their()] own blood":""))),
		span_cult(LANG("datum.242fd3d3485b2738", null))
		)

	cleanup_shields()
	var/obj/effect/rune/made_rune = new rune_to_scribe(our_turf, chosen_keyword)
	made_rune.add_mob_blood(cultist)

	to_chat(cultist, span_cult(LANG("datum.964bf51ea60289fc", list(LOWER_TEXT(made_rune.cultist_name), made_rune.cultist_desc))))
	cultist.log_message("scribed \a [LOWER_TEXT(made_rune.cultist_name)] rune using [parent] ([parent.type])", LOG_GAME)
	SSblackbox.record_feedback("tally", "cult_runes_scribed", 1, made_rune.cultist_name)

	return TRUE

/*
 * The process of scribing the nar'sie rune.
 *
 * cultist - the mob placing the rune
 * cult_team - the team of the mob placing the rune
 */
/datum/component/cult_ritual_item/proc/scribe_narsie_rune(mob/living/cultist, datum/team/cult/cult_team)
	var/datum/objective/eldergod/summon_objective = locate() in cult_team.objectives
	var/datum/objective/sacrifice/sac_objective = locate() in cult_team.objectives
	if(!check_if_in_ritual_site(cultist, cult_team))
		return FALSE
	if(sac_objective && !sac_objective.check_completion())
		to_chat(cultist, span_warning(LANG("datum.62a29c69bd6306cd", null)))
		return FALSE
	if(summon_objective.check_completion())
		to_chat(cultist, span_cult_large(LANG("datum.eadbfcf8c3631fef", null)))
		return FALSE
	var/confirm_final = tgui_alert(cultist, LANG("datum.a1364cbf4af983bb", null), LANG("datum.31a81d6482544b32", null), list("My life for Nar'Sie!", "No"))
	if(confirm_final == "No")
		to_chat(cultist, span_cult(LANG("datum.0f232fbd4c137a14", null)))
		return
	if(!check_if_in_ritual_site(cultist, cult_team))
		return FALSE
	var/area/summon_location = get_area(cultist)
	var/static/cult_music_played = FALSE
	priority_announce(
		text = LANG("datum.683a137cb1d09eb5", list(cultist.real_name, summon_location.get_original_area_name())),
		sound = cult_music_played ? 'sound/announcer/notice/notice3.ogg' : 'sound/music/antag/bloodcult/bloodcult_scribe.ogg',
		sender_override = "[command_name()] Higher Dimensional Affairs",
		has_important_message = TRUE,
	)
	cult_music_played = TRUE
	for(var/shielded_turf in spiral_range_turfs(1, cultist, 1))
		LAZYADD(shields, new /obj/structure/emergency_shield/cult/narsie(shielded_turf))

	notify_ghosts(
		LANG("datum.4e5acbb7e82b38d8", list(cultist.real_name)),
		source = cultist,
		header = "Maranax Infirmux!",
		notify_flags = NOTIFY_CATEGORY_NOFLASH,
	)

	return TRUE

/*
 * Helper to check if a rune can be scraped by a cultist.
 * Used in between inputs of [do_scrape_rune] for sanity checking.
 *
 * rune - the rune being deleted. Instance of a rune.
 * cultist - the mob deleting the rune
 */
/datum/component/cult_ritual_item/proc/can_scrape_rune(obj/effect/rune/rune, mob/living/cultist)
	if(!IS_CULTIST(cultist))
		return FALSE

	if(!cultist.is_holding(parent))
		return FALSE

	if(!rune.Adjacent(cultist))
		return FALSE

	if(cultist.incapacitated)
		return FALSE

	if(cultist.stat == DEAD)
		return FALSE

	return TRUE

/*
 * Helper to check if a rune can be scribed by a cultist.
 * Used in between inputs of [do_scribe_rune] for sanity checking.
 *
 * tool - the parent - the item being used to scribe the rune, casted to item
 * cultist - the mob making the rune
 */
/datum/component/cult_ritual_item/proc/can_scribe_rune(obj/item/tool, mob/living/cultist)
	if(!IS_CULTIST(cultist))
		to_chat(cultist, span_warning(LANG("datum.89345f393758bba6", list(tool))))
		return FALSE

	if(QDELETED(tool) || !cultist.is_holding(tool))
		return FALSE

	if(cultist.incapacitated || cultist.stat == DEAD)
		to_chat(cultist, span_warning(LANG("datum.d184999678f6cbc8", null)))
		return FALSE

	if(!check_rune_turf(get_turf(cultist), cultist))
		return FALSE

	return TRUE

/*
 * Checks if a turf is valid for having a rune placed there.
 *
 * target - the turf being checked
 * cultist - the mob placing the rune
 */
/datum/component/cult_ritual_item/proc/check_rune_turf(turf/target, mob/living/cultist)
	if(isspaceturf(target))
		to_chat(cultist, span_warning(LANG("datum.c9d99de1f0feaddf", null)))
		return FALSE

	if(locate(/obj/effect/rune) in target)
		to_chat(cultist, span_cult(LANG("datum.99666d98038522f5", null)))
		return FALSE

	var/area/our_area = get_area(target)
	if((!is_station_level(target.z) && !is_mining_level(target.z)) || (our_area && !(our_area.area_flags & CULT_PERMITTED)))
		to_chat(cultist, span_warning(LANG("datum.44b6eb55a6cd519e", null)))
		return FALSE

	return TRUE

/*
 * Helper to check a cultist is located in one of the ritual / summoning sites.
 *
 * cultist - the mob making the rune
 * cult_team - the team of the mob making the rune
 * fail_if_last_site - whether the check fails if it's the last site in the summoning list.
 */
/datum/component/cult_ritual_item/proc/check_if_in_ritual_site(mob/living/cultist, datum/team/cult/cult_team, fail_if_last_site = FALSE)
	var/datum/objective/eldergod/summon_objective = locate() in cult_team.objectives
	var/area/our_area = get_area(cultist)
	if(!summon_objective)
		to_chat(cultist, span_warning(LANG("datum.519ddbbc6d40e3e0", null)))
		return FALSE

	if(!(our_area in summon_objective.summon_spots))
		to_chat(cultist, span_warning(LANG("datum.a30db5434d720aac", list(lang_english_list(summon_objective.summon_spots)))))
		return FALSE

	if(fail_if_last_site && length(summon_objective.summon_spots) <= 1)
		to_chat(cultist, span_warning(LANG("datum.3683b960b3f9d784", null)))
		return FALSE

	return TRUE

/*
 * Removes all shields from the shields list.
 */
/datum/component/cult_ritual_item/proc/cleanup_shields()
	for(var/obj/structure/emergency_shield/cult/narsie/shield as anything in shields)
		LAZYREMOVE(shields, shield)
		if(!QDELETED(shield))
			qdel(shield)
