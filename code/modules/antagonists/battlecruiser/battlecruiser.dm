// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/team/battlecruiser
	name = "\improper Battlecruiser Crew"
	member_name = "crewmember"
	/// The central objective of this battlecruiser
	var/core_objective = /datum/objective/nuclear
	/// The assigned nuke of this team
	var/obj/machinery/nuclearbomb/nuke

/datum/team/battlecruiser/proc/update_objectives()
	if(core_objective)
		var/datum/objective/objective = new core_objective()
		objective.team = src
		objectives += objective

/datum/antagonist/battlecruiser
	name = "Battlecruiser Crewmember"
	show_to_ghosts = TRUE
	roundend_category = "battlecruiser syndicate operatives"
	suicide_cry = "FOR THE SYNDICATE!!!"
	antag_hud_name = "battlecruiser_crew"
	antagpanel_category = ANTAG_GROUP_SYNDICATE
	pref_flag = ROLE_BATTLECRUISER_CREW
	stinger_sound = 'sound/music/antag/ops.ogg'
	/// Team to place the crewmember on.
	var/datum/team/battlecruiser/battlecruiser_team

/datum/antagonist/battlecruiser/get_team()
	return battlecruiser_team

/datum/antagonist/battlecruiser/greet()
	play_stinger()
	to_chat(owner, span_big(LANG("datum.3542c37f0820e564", list(name))))
	owner.announce_objectives()

/datum/antagonist/battlecruiser/ally
	name = "Battlecruiser Ally"
	show_to_ghosts = FALSE

/datum/antagonist/battlecruiser/captain
	name = "Battlecruiser Captain"
	antag_hud_name = "battlecruiser_lead"
	pref_flag = ROLE_BATTLECRUISER_CAPTAIN

/datum/antagonist/battlecruiser/create_team(datum/team/battlecruiser/team)
	if(!team)
		return
	if(!istype(team))
		stack_trace("Wrong team type passed to [type] initialization.")
	battlecruiser_team = team

/datum/antagonist/battlecruiser/apply_innate_effects(mob/living/mob_override)
	add_team_hud(mob_override || owner.current, /datum/antagonist/battlecruiser)

/datum/antagonist/battlecruiser/on_gain()
	if(!battlecruiser_team)
		return ..()

	objectives |= battlecruiser_team.objectives
	if(battlecruiser_team.nuke)
		var/obj/machinery/nuclearbomb/nuke = battlecruiser_team.nuke
		antag_memory += "<B>[nuke] Code</B>: [nuke.r_code]<br>"
		owner.add_memory(/datum/memory/key/nuke_code, nuclear_code = nuke.r_code)
		to_chat(owner, LANG("datum.f9a759edec481427", list(nuke.r_code)))
	return ..()
