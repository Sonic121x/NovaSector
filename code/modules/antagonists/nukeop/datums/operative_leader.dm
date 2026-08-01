// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/antagonist/nukeop/leader
	name = "Nuclear Operative Leader"
	nukeop_outfit = /datum/outfit/syndicate/leader
	/// Whether to spawn the infiltrator
	var/spawn_ship = TRUE
	/// Randomly chosen honorific, for distinction
	var/title
	/// The nuclear challenge remote we will spawn this player with.
	var/challengeitem = /obj/item/nuclear_challenge

/datum/antagonist/nukeop/leader/memorize_code()
	. = ..()
	var/obj/item/paper/nuke_code_paper = new(get_turf(owner.current))
	nuke_code_paper.add_raw_text(LANG("datum.80679267", list(nuke_team.memorized_code)))
	nuke_code_paper.name = "nuclear bomb code"
	nuke_code_paper.update_appearance()
	owner.current.put_in_hands(nuke_code_paper)

/datum/antagonist/nukeop/leader/give_alias()
	title ||= pick("Czar", "Boss", "Commander", "Chief", "Kingpin", "Director", "Overlord")
	. = ..()
	if(ishuman(owner.current))
		owner.current.fully_replace_character_name(owner.current.real_name, "[title] [owner.current.real_name]")
	else
		owner.current.fully_replace_character_name(owner.current.real_name, "[nuke_team.syndicate_name] [title]")

/datum/antagonist/nukeop/leader/greet()
	play_stinger()
	to_chat(owner, LANG("datum.cb8902e8", list(title)))
	to_chat(owner, LANG("datum.3c440342", null))
	if(!CONFIG_GET(flag/disable_warops))
		to_chat(owner, LANG("datum.27effbcf", null))
	owner.announce_objectives()

/datum/antagonist/nukeop/leader/on_gain()
	. = ..()
	if(!CONFIG_GET(flag/disable_warops))
		var/mob/living/carbon/human/leader = owner.current
		var/obj/item/war_declaration = new challengeitem(leader.drop_location())
		leader.put_in_hands(war_declaration)
		nuke_team.war_button_ref = WEAKREF(war_declaration)
	addtimer(CALLBACK(src, PROC_REF(nuketeam_name_assign)), 0.1 SECONDS)

/datum/antagonist/nukeop/leader/proc/nuketeam_name_assign()
	if(!nuke_team)
		return
	nuke_team.rename_team(ask_name())

/datum/antagonist/nukeop/leader/proc/ask_name()
	var/randomname = pick(GLOB.last_names)
	var/newname = tgui_input_text(
		owner.current,
		LANG("datum.232cff57", list(title)),
		LANG("datum.b4bf4c54", null),
		randomname,
		max_length = MAX_NAME_LEN,
	)
	if (!newname)
		newname = randomname
	else
		newname = reject_bad_name(newname)
		if(!newname)
			newname = randomname

	return capitalize(newname)

/datum/antagonist/nukeop/leader/create_team(datum/team/nuclear/new_team)
	if(spawn_ship)
		spawn_infiltrator()
	if(new_team)
		return ..()
	// Leaders always make new teams
	nuke_team = new /datum/team/nuclear()
