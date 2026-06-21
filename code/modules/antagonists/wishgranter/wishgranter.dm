/datum/antagonist/wishgranter
	name = "\improper 许愿者化身"
	show_in_antagpanel = FALSE
	show_name_in_check_antagonists = TRUE
	hijack_speed = 2 //You literally are here to do nothing else. Might as well be fast about it.
	suicide_cry = "HAHAHAHAHA!!"

/datum/antagonist/wishgranter/forge_objectives()
	var/datum/objective/hijack/hijack = new
	hijack.owner = owner
	objectives += hijack

/datum/antagonist/wishgranter/on_gain()
	forge_objectives()
	. = ..()
	give_powers()

/datum/antagonist/wishgranter/greet()
	. = ..()
	to_chat(owner, "<B>你的抑制力被一扫而空，忠诚的纽带已然断裂，你现在可以随心所欲地杀戮了！</B>")
	owner.announce_objectives()

/datum/antagonist/wishgranter/proc/give_powers()
	var/mob/living/carbon/human/H = owner.current
	if(!istype(H))
		return
	H.dna.add_mutation(/datum/mutation/hulk, MUTATION_SOURCE_WISHGRANTER)
	H.dna.add_mutation(/datum/mutation/xray, MUTATION_SOURCE_WISHGRANTER)
	H.dna.add_mutation(/datum/mutation/adaptation/pressure, MUTATION_SOURCE_WISHGRANTER)
	H.dna.add_mutation(/datum/mutation/telekinesis, MUTATION_SOURCE_WISHGRANTER)
