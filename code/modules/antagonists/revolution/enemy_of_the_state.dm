// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md

/**
 * When the station wins, any remaining living headrevs become Enemies of the State, a small solo antagonist.
 * They either have the choice to fuck off and do their own thing, or try and regain their honor with a hijack.
 */
/datum/antagonist/enemy_of_the_state
	name = "\improper Enemy of the State"
	show_in_antagpanel = FALSE
	show_name_in_check_antagonists = TRUE
	hijack_speed = 2 //not like they have much to do
	suicide_cry = "FOR THE ETERNAL REVOLUTION!!"

/datum/antagonist/enemy_of_the_state/forge_objectives()
	var/datum/objective/exile/exile_choice = new
	exile_choice.owner = owner
	exile_choice.objective_name = "Choice"
	objectives += exile_choice

	var/datum/objective/hijack/hijack_choice = new
	hijack_choice.owner = owner
	hijack_choice.objective_name = "Choice"
	objectives += hijack_choice

/datum/antagonist/enemy_of_the_state/on_gain()
	owner.add_memory(/datum/memory/revolution_rev_defeat)
	// LAZYADD(owner.special_statuses, "Exiled Head Revolutionary")
	forge_objectives()
	. = ..()

/datum/antagonist/enemy_of_the_state/greet()
	. = ..()
	to_chat(owner, span_userdanger(LANG("datum.c5424bb61900a9e1", null)))
	to_chat(owner, span_bolddanger(LANG("datum.b224d6eff5506a5a", null)))
	to_chat(owner, LANG("datum.a81d043ae69d2d97", null))
	owner.announce_objectives()

/datum/antagonist/enemy_of_the_state/roundend_report()
	var/list/report = list()

	if(!owner)
		CRASH("Antagonist datum without owner")

	report += printplayer(owner)

	//needs to complete only one objective, not all

	var/option_chosen = FALSE
	var/badass = FALSE
	if(objectives.len)
		report += printobjectives(objectives)
		for(var/datum/objective/objective in objectives)
			if(objective.check_completion())
				option_chosen = TRUE
				if(istype(objective, /datum/objective/hijack))
					badass = TRUE
				break

	if(objectives.len == 0 || option_chosen)
		if(badass)
			report += "<span class='greentext big'>Major [name] Victory</span>"
			report += "<B>[name] chose the badass option, and hijacked the shuttle!</B>"
		else
			report += "<span class='greentext big'>Minor [name] Victory</span>"
			report += "<B>[name] has survived as an exile!</B>"
	else
		report += "<span class='redtext big'>The [name] has failed!</span>"

	return report.Join("<br>")
