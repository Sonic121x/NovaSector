// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
//The hunters!!
/datum/antagonist/fugitive_hunter
	name = "Fugitive Hunter"
	roundend_category = "Fugitive"
	silent = TRUE //greet called by the spawn
	show_in_antagpanel = FALSE
	show_to_ghosts = TRUE
	antagpanel_category = ANTAG_GROUP_HUNTERS
	antag_hud_name = "fugitive_hunter"
	suicide_cry = "FOR GLORY!!"
	antag_flags = ANTAG_SKIP_GLOBAL_LIST
	var/datum/team/fugitive_hunters/hunter_team
	var/backstory = "error"

/datum/antagonist/fugitive_hunter/on_gain()
	forge_objectives()
	. = ..()

/datum/antagonist/fugitive_hunter/forge_objectives() //this isn't an actual objective because it's about round end rosters
	var/datum/objective/capture = new /datum/objective
	capture.owner = owner
	capture.explanation_text = "Capture the fugitives in the station and put them into the bluespace capture machine on your ship."
	objectives += capture

/datum/antagonist/fugitive_hunter/greet()
	switch(backstory)
		if(HUNTER_PACK_COPS)
			to_chat(owner, span_bolddanger(LANG("datum.59f6d0292216b44f", null)))
			to_chat(owner, LANG("datum.31887a63c2d5b4a4", null))
			to_chat(owner, LANG("datum.e7644c13adec013c", null))
		if(HUNTER_PACK_RUSSIAN)
			to_chat(owner, span_danger(LANG("datum.0c8cc70d8cbf210e", null)))
			to_chat(owner, span_danger(LANG("datum.0e1b3b4efa97e3fa", null)))
			to_chat(owner, span_danger(LANG("datum.16d4ced5ec62fa31", null)))
			to_chat(owner, span_danger(LANG("datum.494c671fc468c85f", null)))
		if(HUNTER_PACK_BOUNTY)
			to_chat(owner, span_danger(LANG("datum.f26347bb8ff94622", null)))
			to_chat(owner, span_danger(LANG("datum.03bfc551da5f384e", null)))
			to_chat(owner, span_danger(LANG("datum.6c776ea52e93679a", null)))
		if(HUNTER_PACK_PSYKER)
			to_chat(owner, span_danger(LANG("datum.32ef982970c6d75f", null)))
			to_chat(owner, span_danger(LANG("datum.3f343787c826d315", null)))
			to_chat(owner, span_danger(LANG("datum.36059edb98133ae4", null)))
		if(HUNTER_PACK_MI13)
			to_chat(owner, span_danger(LANG("datum.e71dfab3a151fbf2", null)))
			to_chat(owner, span_danger(LANG("datum.38175b4a4b255a08", null)))
			to_chat(owner, span_danger(LANG("datum.3afea83f77bfd6da", null)))

	to_chat(owner, span_bolddanger(LANG("datum.9453e6598131136b", null)))
	owner.announce_objectives()

/datum/antagonist/fugitive_hunter/create_team(datum/team/fugitive_hunters/new_team)
	if(!new_team)
		for(var/datum/antagonist/fugitive_hunter/H in GLOB.antagonists)
			if(!H.owner)
				continue
			if(H.hunter_team)
				hunter_team = H.hunter_team
				return
		hunter_team = new /datum/team/fugitive_hunters
		hunter_team.backstory = backstory
		hunter_team.update_objectives()
		return
	if(!istype(new_team))
		stack_trace("Wrong team type passed to [type] initialization.")
	hunter_team = new_team

/datum/antagonist/fugitive_hunter/get_team()
	return hunter_team

/datum/antagonist/fugitive_hunter/apply_innate_effects(mob/living/mob_override)
	add_team_hud(mob_override || owner.current)
	if(backstory == HUNTER_PACK_RUSSIAN)
		var/mob/living/owner_mob = mob_override || owner.current
		owner_mob.grant_language(/datum/language/spinwarder, source = LANGUAGE_BOUNTYHUNTER)
		owner_mob.set_active_language(/datum/language/spinwarder)

/datum/antagonist/fugitive_hunter/remove_innate_effects(mob/living/mob_override)
	var/mob/living/owner_mob = mob_override || owner.current
	owner_mob.remove_language(/datum/language/spinwarder, source = LANGUAGE_BOUNTYHUNTER)

/datum/team/fugitive_hunters
	var/backstory = "error"

/datum/team/fugitive_hunters/proc/update_objectives(initial = FALSE)
	objectives = list()
	var/datum/objective/O = new()
	O.team = src
	objectives += O

/datum/team/fugitive_hunters/proc/assemble_fugitive_results()
	var/list/fugitives_counted = list()
	var/list/fugitives_dead = list()
	var/list/fugitives_captured = list()
	for(var/datum/antagonist/fugitive/A in GLOB.antagonists)
		if(!A.owner)
			stack_trace("Antagonist datum without owner in GLOB.antagonists: [A]")
			continue
		fugitives_counted += A
		if(A.owner.current.stat == DEAD)
			fugitives_dead += A
		if(A.is_captured)
			fugitives_captured += A
	. = list(fugitives_counted, fugitives_dead, fugitives_captured) //okay, check out how cool this is.

/datum/team/fugitive_hunters/proc/all_hunters_dead()
	var/dead_boys = 0
	for(var/I in members)
		var/datum/mind/hunter_mind = I
		if(!(ishuman(hunter_mind.current) || (hunter_mind.current.stat == DEAD)))
			dead_boys++
	return dead_boys >= members.len

/datum/team/fugitive_hunters/proc/get_result()
	var/list/fugitive_results = assemble_fugitive_results()
	var/list/fugitives_counted = fugitive_results[1]
	var/list/fugitives_dead = fugitive_results[2]
	var/list/fugitives_captured = fugitive_results[3]
	var/hunters_dead = all_hunters_dead()
	//this gets a little confusing so follow the comments if it helps
	if(!fugitives_counted.len)
		return
	if(fugitives_captured.len)//any captured
		if(fugitives_captured.len == fugitives_counted.len)//if the hunters captured all the fugitives, there's a couple special wins
			if(!fugitives_dead)//specifically all of the fugitives alive
				return FUGITIVE_RESULT_BADASS_HUNTER
			else if(hunters_dead)//specifically all of the hunters died (while capturing all the fugitives)
				return FUGITIVE_RESULT_POSTMORTEM_HUNTER
			else//no special conditional wins, so just the normal major victory
				return FUGITIVE_RESULT_MAJOR_HUNTER
		else if(!hunters_dead)//so some amount captured, and the hunters survived.
			return FUGITIVE_RESULT_HUNTER_VICTORY
		else//so some amount captured, but NO survivors.
			return FUGITIVE_RESULT_MINOR_HUNTER
	else//from here on out, hunters lost because they did not capture any fugitive dead or alive. there are different levels of getting beat though:
		if(!fugitives_dead)//all fugitives survived
			return FUGITIVE_RESULT_MAJOR_FUGITIVE
		else if(fugitives_dead < fugitives_counted)//at least ANY fugitive lived
			return FUGITIVE_RESULT_FUGITIVE_VICTORY
		else if(!hunters_dead)//all fugitives died, but none were taken in by the hunters. minor win
			return FUGITIVE_RESULT_MINOR_FUGITIVE
		else//all fugitives died, all hunters died, nobody brought back. seems weird to not give fugitives a victory if they managed to kill the hunters but literally no progress to either goal should lead to a nobody wins situation
			return FUGITIVE_RESULT_STALEMATE

/datum/team/fugitive_hunters/roundend_report() //shows the number of fugitives, but not if they won in case there is no security
	if(!members.len)
		return

	var/list/result = list()

	result += "<div class='panel redborder'>...And <B>[members.len]</B> [backstory]s tried to hunt them down!"

	for(var/datum/mind/M in members)
		result += "<b>[printplayer(M)]</b>"

	switch(get_result())
		if(FUGITIVE_RESULT_BADASS_HUNTER)//use defines
			result += "<span class='greentext big'>Badass [capitalize(backstory)] Victory!</span>"
			result += "<B>The [backstory]s managed to capture every fugitive, alive!</B>"
		if(FUGITIVE_RESULT_POSTMORTEM_HUNTER)
			result += "<span class='greentext big'>Postmortem [capitalize(backstory)] Victory!</span>"
			result += "<B>The [backstory]s managed to capture every fugitive, but all of them died! Spooky!</B>"
		if(FUGITIVE_RESULT_MAJOR_HUNTER)
			result += "<span class='greentext big'>Major [capitalize(backstory)] Victory</span>"
			result += "<B>The [backstory]s managed to capture every fugitive, dead or alive.</B>"
		if(FUGITIVE_RESULT_HUNTER_VICTORY)
			result += "<span class='greentext big'>[capitalize(backstory)] Victory</span>"
			result += "<B>The [backstory]s managed to capture a fugitive, dead or alive.</B>"
		if(FUGITIVE_RESULT_MINOR_HUNTER)
			result += "<span class='greentext big'>Minor [capitalize(backstory)] Victory</span>"
			result += "<B>All the [backstory]s died, but managed to capture a fugitive, dead or alive.</B>"
		if(FUGITIVE_RESULT_STALEMATE)
			result += "<span class='neutraltext big'>Bloody Stalemate</span>"
			result += "<B>Everyone died, and no fugitives were recovered!</B>"
		if(FUGITIVE_RESULT_MINOR_FUGITIVE)
			result += "<span class='redtext big'>Minor Fugitive Victory</span>"
			result += "<B>All the fugitives died, but none were recovered!</B>"
		if(FUGITIVE_RESULT_FUGITIVE_VICTORY)
			result += "<span class='redtext big'>Fugitive Victory</span>"
			result += "<B>A fugitive survived, and no bodies were recovered by the [backstory]s.</B>"
		if(FUGITIVE_RESULT_MAJOR_FUGITIVE)
			result += "<span class='redtext big'>Major Fugitive Victory</span>"
			result += "<B>All of the fugitives survived and avoided capture!</B>"
		else //get_result returned null- either bugged or no fugitives showed
			result += "<span class='neutraltext big'>Prank Call!</span>"
			result += "<B>[capitalize(backstory)]s were called, yet there were no fugitives...?</B>"

	result += "</div>"

	return result.Join("<br>")
