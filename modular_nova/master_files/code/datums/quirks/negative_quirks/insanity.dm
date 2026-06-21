/datum/quirk/insanity
	mob_trait = TRAIT_INSANITY
	mail_goodies = list(/obj/item/storage/pill_bottle/lsdpsych/quirk)
	species_quirks = list(/datum/species/synthetic = /datum/quirk/insanity/synth)
	///The medication given when the quirk is added
	var/insanity_medication = /obj/item/storage/pill_bottle/lsdpsych/quirk

/datum/quirk/insanity/add_unique(client/client_source)
	give_item_to_holder_nova(
		insanity_medication,
		list(
			LOCATION_LPOCKET,
			LOCATION_RPOCKET,
			LOCATION_BACKPACK,
			LOCATION_HANDS,
		),
		flavour_text = "这些药片能稳定你的大脑，直到你获得稳定的药物供应。",
		notify_player = TRUE,
	)

// Override of insanity quirk for synthetic humanoids
/datum/quirk/insanity/synth
	name = "Sensory Processing Fault"
	medical_record_text = "Patient is malfunctioning in a manner similar to Reality Dissociation Syndrome and experiences vivid hallucinations, and may have trouble speaking."
	mail_goodies = list(/obj/item/storage/box/flat/neuroware/mindbreaker)
	insanity_medication = /obj/item/storage/box/flat/neuroware/mindbreaker
	abstract_type = /datum/quirk/insanity/synth
