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
	name = "Imaginary Friend-现象的朋友 (特殊)"
	/// Who are we going to add to your head today?
	var/list/friend_candidates
	/// Do we randomise friend appearances or not?
	var/random_appearance

/datum/smite/custom_imaginary_friend/configure(client/user)
	var/appearance_choice = tgui_alert(user,
		"你希望幻想朋友与其当前选择的角色偏好共享名称和外观吗？",
		"幻想朋友外观？",
		list(CHOICE_PREFS_APPEARANCE, CHOICE_RANDOM_APPEARANCE, CHOICE_CANCEL))
	if (isnull(appearance_choice) || appearance_choice == CHOICE_CANCEL)
		return FALSE
	random_appearance = appearance_choice == CHOICE_RANDOM_APPEARANCE

	var/picked_client = tgui_input_list(user, "选择要由哪位玩家控制", "新的幻想朋友", list(CHOICE_POLL_GHOSTS) + sort_list(GLOB.clients))
	if(isnull(picked_client))
		return FALSE

	if(picked_client == CHOICE_POLL_GHOSTS)
		return poll_ghosts(user)

	var/client/friend_candidate_client = picked_client
	if(QDELETED(friend_candidate_client))
		to_chat(user, span_warning("所选玩家已失去客户端连接，操作中止。"))
		return FALSE

	if(isliving(friend_candidate_client.mob) && (tgui_alert(user, "该玩家已有一个存活的生物（[friend_candidate_client.mob]）。你仍然想将其变为幻想朋友吗？", "将玩家移出生物？", list("Do it!", "Cancel")) != "Do it!"))
		return FALSE

	if(QDELETED(friend_candidate_client))
		to_chat(user, span_warning("所选玩家已失去客户端连接，操作中止。"))
		return FALSE

	friend_candidates = list(friend_candidate_client)
	return TRUE

/// Try to offer the role to ghosts
/datum/smite/custom_imaginary_friend/proc/poll_ghosts(client/user)
	var/how_many = tgui_input_number(user, "要添加多少个幻想朋友？", "幻想朋友数量", default = 1, min_value = 1)
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
		to_chat(user, span_warning("没有候选者响应，操作中止。"))
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
		to_chat(user, span_warning("目标生物已不存在，操作中止。"))
		return

	if(!length(friend_candidates))
		to_chat(user, span_warning("未提供幻想朋友候选者，操作中止。"))
		return

	var/list/final_clients = list()
	for (var/client/client as anything in friend_candidates)
		if (QDELETED(client))
			continue
		final_clients += client

	if(!length(final_clients))
		to_chat(user, span_warning("提供的幻想朋友候选者均无客户端连接，操作中止。"))
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
