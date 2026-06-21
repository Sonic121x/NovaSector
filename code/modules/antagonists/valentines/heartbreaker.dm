/datum/antagonist/heartbreaker
	name = "\improper 碎心者"
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
	to_chat(owner, span_boldwarning("你没有约会对象！他们都在开心玩耍，却把你晾在一边！你会让他们好看的……"))
	owner.announce_objectives()
