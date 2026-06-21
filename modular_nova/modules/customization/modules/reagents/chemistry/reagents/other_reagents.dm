/datum/reagent/iron
	chemical_flags_nova = REAGENT_BLOOD_REGENERATING

/datum/reagent/blood
	chemical_flags_nova = REAGENT_BLOOD_REGENERATING // For Hemophages to be able to drink it without any issue.

/datum/reagent/blood/on_new(list/data)
	. = ..()

	if(!src.data["blood_type"])
		src.data["blood_type"] = random_human_blood_type() // This is so we don't get blood without a blood type spawned from something that doesn't explicitly set the blood type.

// Catnip
/datum/reagent/pax/catnip
	name = "猫薄荷"
	taste_description = "grass"
	description = "一种无色液体，能让人更平和，让猫科动物更快乐。"
	metabolization_rate = 1.75 * REAGENTS_METABOLISM

/datum/reagent/pax/catnip/on_mob_life(mob/living/carbon/M, seconds_per_tick, metabolization_ratio)
	if(isfeline(M))
		if(prob(20))
			M.emote("nya")
		if(prob(20))
			to_chat(M, span_notice("[pick("Headpats feel nice.", "Backrubs would be nice.", "Mew")]"))
	else
		to_chat(M, span_notice("[pick("I feel oddly calm.", "I feel relaxed.", "Mew?")]"))
	..()

#define DERMAGEN_SCAR_FIX_AMOUNT 10

/datum/reagent/medicine/dermagen
	name = "皮肤再生剂"
	description = "涂抹时可治愈过去物理创伤形成的疤痕。至少需要10单位，仅局部涂抹有效。"
	color = "#FFEBEB"
	ph = 6
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/medicine/dermagen/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume, show_message = TRUE)
	. = ..()
	if(!iscarbon(exposed_mob))
		return
	if(!(methods & (PATCH|TOUCH|VAPOR)))
		return
	var/mob/living/carbon/scarred = exposed_mob
	if(scarred.stat == DEAD)
		show_message = FALSE
	if(show_message)
		to_chat(scarred, span_danger("你身上的疤痕开始褪色并消失。"))
	if(reac_volume >= DERMAGEN_SCAR_FIX_AMOUNT)
		QDEL_LAZYLIST(scarred.all_scars)

#undef DERMAGEN_SCAR_FIX_AMOUNT

/datum/reagent/medicine/taste_suppressor
	name = "味觉抑制剂"
	description = "一种无色药物，旨在钝化服用者的味觉，只要它还在其体内。"
	color = "#AAAAAA77"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	chemical_flags_nova = REAGENT_BLOOD_REGENERATING // It has REAGENT_BLOOD_REGENERATING only because it makes it so Hemophages can safely drink it, which makes complete sense considering this is meant to suppress their tumor's reactiveness to anything that doesn't regenerate blood.


/datum/reagent/medicine/taste_suppressor/on_mob_metabolize(mob/living/affected_mob)
	. = ..()

	ADD_TRAIT(affected_mob, TRAIT_AGEUSIA, TRAIT_REAGENT)


/datum/reagent/medicine/taste_suppressor/on_mob_end_metabolize(mob/living/affected_mob)
	. = ..()

	REMOVE_TRAIT(affected_mob, TRAIT_AGEUSIA, TRAIT_REAGENT)
