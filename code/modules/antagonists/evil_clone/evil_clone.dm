/// Antag datum associated with the experimental cloner
/datum/antagonist/evil_clone
	name = "\improper 邪恶克隆体"
	stinger_sound = 'sound/music/antag/hypnotized.ogg'
	pref_flag = ROLE_EVIL_CLONE
	roundend_category = "evil clones"
	show_in_antagpanel = TRUE
	antagpanel_category = ANTAG_GROUP_CREW
	show_name_in_check_antagonists = TRUE
	antag_flags = ANTAG_SKIP_GLOBAL_LIST

/datum/antagonist/evil_clone/on_gain()
	if (owner.current)
		name = "[owner.current.real_name] 原体"
	forge_objectives()
	return ..()

/datum/antagonist/evil_clone/greet()
	if(silent)
		return
	play_stinger()
	var/mob/living/current_mob = owner.current
	if (current_mob)
		to_chat(current_mob, span_big("你是 [current_mob.real_name]。"))
		to_chat(current_mob, span_hypnophrase("你是<b>唯一</b>的[current_mob.real_name]。"))
		to_chat(current_mob, span_boldwarning("任何其他冒充[current_mob.real_name]的人都必须受到惩罚。"))
	owner.announce_objectives()

/datum/antagonist/evil_clone/forge_objectives()
	var/datum/objective/accept_no_substitutes/objective = new
	objective.owner = owner
	objective.set_target_name(owner.current?.real_name)
	objectives += objective

/// Kill everyone with the same name as you
/datum/objective/accept_no_substitutes
	name = "杀死所有克隆体"
	explanation_text = "Ensure that nobody with a particular name that you don't remember remains alive."
	admin_grantable = TRUE
	/// What name do we want to expunge?
	var/target_name

/// Set the name to check for
/datum/objective/accept_no_substitutes/proc/set_target_name(new_name)
	target_name = new_name
	explanation_text = "Ensure that nobody with the name [target_name] remains alive."

/datum/objective/accept_no_substitutes/check_completion()
	if (!target_name)
		return FALSE // Well we forgot to check for a name

	for (var/mob/living/someone as anything in GLOB.player_list) // We will generously not include people who logged out or ghosted
		if (!istype(someone))
			continue
		if (someone.stat == DEAD)
			continue
		if (someone == owner.current)
			continue
		if (someone.real_name == target_name)
			return FALSE

	return TRUE

/datum/objective/accept_no_substitutes/admin_edit(mob/admin)
	admin_simple_target_pick(admin)
	if (target.current)
		set_target_name(target.current.real_name)
