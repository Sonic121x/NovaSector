/// Turn pur target to stone, forever
/datum/smite/petrify
	name = "石化"

/datum/smite/petrify/effect(client/user, mob/living/target)
	. = ..()

	if(!ishuman(target))
		to_chat(user, span_warning("此功能必须对人类亚型使用。"), confidential = TRUE)
		return
	var/mob/living/carbon/human/human_target = target
	human_target.petrify(statue_timer = INFINITY, save_brain = FALSE)

/datum/smite/petrify/divine
	name = "石化（神圣）"
	smite_flags = SMITE_DIVINE|SMITE_DELAY|SMITE_STUN
