// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
///a heretic that got soultrapped by cultists. does nothing, other than signify they suck
/datum/antagonist/soultrapped_heretic
	name = "\improper Soultrapped Heretic"
	roundend_category = "Heretics"
	antagpanel_category = "Heretic"
	pref_flag = ROLE_HERETIC
	antag_moodlet = /datum/mood_event/soultrapped_heretic
	antag_hud_name = "heretic"

// Will never show up because they're shades inside a sword
/datum/mood_event/soultrapped_heretic
	description = "They trapped me! I can't escape!"
	mood_change = -20

// always failure obj
/datum/objective/heretic_trapped
	name = "soultrapped failure"
	explanation_text = "Help the cult. Kill the cult. Help the crew. Kill the crew. Help your wielder. Kill your wielder. Kill everyone. Rattle your chains. Break your bindings."

/datum/antagonist/soultrapped_heretic/on_gain()
	..()
	var/policy = get_policy(ROLE_SOULTRAPPED_HERETIC)
	if(policy)
		to_chat(owner, policy)
	else
		to_chat(owner, span_ghostalert(LANG("datum.f8bd3527e18c3f6c", null)))
	owner.current.log_message("was sacrificed to Nar'sie as a Heretic, and sealed inside a longsword.", LOG_GAME)
	var/datum/objective/epic_fail = new /datum/objective/heretic_trapped()
	epic_fail.completed = FALSE
	objectives += epic_fail
