// Badnana Spider

/datum/reagent/toxin/laughjuice
	name = "Laughin' Juice"
	description = "Don't drink too much or it you might die of laughter!"
	color = "#FF4DD2"
	metabolization_rate = 1.5 * REAGENTS_METABOLISM
	toxpwr = 1
	taste_mult = 2
	taste_description = "uncanny sweetness"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/toxin/laughjuice/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(affected_mob.adjust_oxy_loss(1 * seconds_per_tick * metabolization_ratio, FALSE, updating_health = FALSE, required_biotype = affected_biotype))
		affected_mob.visible_message(span_danger(LANG("datum.93015b7db7b4ef9e", list(affected_mob))), span_userdanger(LANG("datum.c9168707eaef4491", null)))
		affected_mob.Stun(5)
		affected_mob.emote("laugh")
		affected_mob.add_mood_event("chemical_laughter", /datum/mood_event/chemical_laughter)
		return UPDATE_MOB_HEALTH
