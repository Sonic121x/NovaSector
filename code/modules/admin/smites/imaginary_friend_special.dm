// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
#define CHOICE_RANDOM_APPEARANCE "Random"
#define CHOICE_PREFS_APPEARANCE "Look-a-like"
#define CHOICE_POLL_GHOSTS "Offer to ghosts"
#define CHOICE_CANCEL "Cancel"

/**
 * Custom imaginary friend.
 *
 * Allows the admin to select the ckey to put into the imaginary friend and whether the imaginary friend looks like the
 * ckey's character.
 *
 * Is not tied to the brain trauma and can be used on all mobs, technically. Including cyborgs and simple/basic mobs.
 *
 * Warranty void if used on AI eyes or other imaginary friends. Please smite responsibly.
 **/
/datum/smite/custom_imaginary_friend
	name = "Imaginary Friend (Special)"
	/// Who are we going to add to your head today?
	var/list/friend_candidates
	/// Do we randomise friend appearances or not?
	var/random_appearance

/datum/smite/custom_imaginary_friend/configure(client/user)
	var/appearance_choice = tgui_alert(user,
		LANG("datum.eb8d3645a325586d", null),
		LANG("datum.0eb2ecaa8e6cc65c", null),
		list(CHOICE_PREFS_APPEARANCE, CHOICE_RANDOM_APPEARANCE, CHOICE_CANCEL))
	if (isnull(appearance_choice) || appearance_choice == CHOICE_CANCEL)
		return FALSE
	random_appearance = appearance_choice == CHOICE_RANDOM_APPEARANCE

	var/picked_client = tgui_input_list(user, LANG("datum.1d4472f0a52a7e21", null), LANG("datum.e5575a41321158a5", null), list(CHOICE_POLL_GHOSTS) + sort_list(GLOB.clients))
	if(isnull(picked_client))
		return FALSE

	if(picked_client == CHOICE_POLL_GHOSTS)
		return poll_ghosts(user)

	var/client/friend_candidate_client = picked_client
	if(QDELETED(friend_candidate_client))
		to_chat(user, span_warning(LANG("datum.80b653a8873b088d", null)))
		return FALSE

	if(isliving(friend_candidate_client.mob) && (tgui_alert(user, LANG("datum.3d155d6e19838c8a", list(friend_candidate_client.mob)), LANG("datum.a0c5cb311eb123dd", null), list("Do it!", "Cancel")) != "Do it!"))
		return FALSE

	if(QDELETED(friend_candidate_client))
		to_chat(user, span_warning(LANG("datum.80b653a8873b088d", null)))
		return FALSE

	friend_candidates = list(friend_candidate_client)
	return TRUE

/// Try to offer the role to ghosts
/datum/smite/custom_imaginary_friend/proc/poll_ghosts(client/user)
	var/how_many = tgui_input_number(user, LANG("datum.7475eb5fa08318be", null), LANG("datum.8507aafb50c9a6a5", null), default = 1, min_value = 1)
	if (isnull(how_many) || how_many < 1)
		return FALSE

	var/list/volunteers = SSpolling.poll_ghost_candidates(
		check_jobban = ROLE_PAI,
		poll_time = 10 SECONDS,
		ignore_category = POLL_IGNORE_IMAGINARYFRIEND,
		role_name_text = "imaginary friend",
	)
	var/volunteer_count = length(volunteers)
	if (volunteer_count == 0)
		to_chat(user, span_warning(LANG("datum.b6513cb8a1d808e9", null)))
		return FALSE

	shuffle_inplace(volunteers)
	friend_candidates = list()
	while (how_many > 0 && length(volunteers) > 0)
		var/mob/dead/observer/lucky_ghost = pop(volunteers)
		if (!lucky_ghost.client)
			continue
		how_many--
		friend_candidates += lucky_ghost.client
	return TRUE

/datum/smite/custom_imaginary_friend/effect(client/user, mob/living/target)
	. = ..()

	if(QDELETED(target))
		to_chat(user, span_warning(LANG("datum.ecf8d7a0a13d1244", null)))
		return

	if(!length(friend_candidates))
		to_chat(user, span_warning(LANG("datum.9103ec22cffe1eb0", null)))
		return

	var/list/final_clients = list()
	for (var/client/client as anything in friend_candidates)
		if (QDELETED(client))
			continue
		final_clients += client

	if(!length(final_clients))
		to_chat(user, span_warning(LANG("datum.5c5e6c70d867ed9c", null)))
		return

	for (var/client/friend_candidate_client as anything in final_clients)
		var/mob/client_mob = friend_candidate_client.mob
		if(isliving(client_mob))
			client_mob.ghostize()

		var/mob/eye/imaginary_friend/friend_mob = client_mob.change_mob_type(
			new_type = /mob/eye/imaginary_friend,
			location = get_turf(client_mob),
			delete_old_mob = TRUE,
		)
		friend_mob.attach_to_owner(target)
		friend_mob.setup_appearance(random_appearance ? null : friend_candidate_client.prefs)

#undef CHOICE_RANDOM_APPEARANCE
#undef CHOICE_PREFS_APPEARANCE
#undef CHOICE_POLL_GHOSTS
#undef CHOICE_CANCEL
