/// Gives the target fake scars
/datum/smite/scarify
	name = "Scarify-划破"

/datum/smite/scarify/effect(client/user, mob/living/target)
	. = ..()
	if(!iscarbon(target))
		to_chat(user, span_warning("这必须对碳基生物使用。"), confidential = TRUE)
		return
	var/mob/living/carbon/dude = target
	dude.generate_fake_scars(rand(1, 4))
	to_chat(dude, span_warning("你感到身体变得疲惫不堪、伤痕累累..."))
