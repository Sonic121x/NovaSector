// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/antagonist/heartbreaker
	name = "\improper Heartbreaker"
	roundend_category = "valentines"
	show_in_antagpanel = FALSE
	show_name_in_check_antagonists = TRUE
	suicide_cry = "FOR LONELINESS!!"

/datum/antagonist/heartbreaker/forge_objectives()
	var/datum/objective/martyr/normiesgetout = new
	normiesgetout.owner = owner
	objectives += normiesgetout

/datum/antagonist/heartbreaker/on_gain()
	forge_objectives()
	. = ..()

/datum/antagonist/heartbreaker/greet()
	. = ..()
	to_chat(owner, span_boldwarning(LANG("datum.87144542703d6494", null)))
	owner.announce_objectives()
