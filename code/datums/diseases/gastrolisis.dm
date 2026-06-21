/datum/disease/gastrolosis
	name = "侵袭性胃螺病"
	desc = "A bizarre disease that causes the host to grow snail-like features, eventually turning into a human-snail hybrid."
	max_stages = 4
	spread_text = "None"
	spread_flags = DISEASE_SPREAD_SPECIAL
	cure_text = /datum/reagent/consumable/salt::name + " & " + /datum/reagent/medicine/mutadone::name
	agent = "Agent S and DNA Restructuring"
	viable_mobtypes = list(/mob/living/carbon/human)
	stage_prob = 0.5
	disease_flags = CURABLE
	cures = list(/datum/reagent/consumable/salt,  /datum/reagent/medicine/mutadone)
	bypasses_immunity = TRUE


/datum/disease/gastrolosis/stage_act(seconds_per_tick)
	. = ..()
	if(!.)
		return

	if(is_species(affected_mob, /datum/species/snail))
		cure()
		return FALSE

	switch(stage)
		if(2)
			if(SPT_PROB(1, seconds_per_tick))
				affected_mob.emote("gag")
			if(SPT_PROB(0.5, seconds_per_tick))
				var/turf/open/OT = get_turf(affected_mob)
				if(isopenturf(OT))
					OT.MakeSlippery(TURF_WET_LUBE, 40)
		if(3)
			if(SPT_PROB(2.5, seconds_per_tick))
				affected_mob.emote("gag")
			if(SPT_PROB(2.5, seconds_per_tick))
				var/turf/open/OT = get_turf(affected_mob)
				if(isopenturf(OT))
					OT.MakeSlippery(TURF_WET_LUBE, 100)
		if(4)
			var/obj/item/organ/eyes/eyes = locate(/obj/item/organ/eyes/snail) in affected_mob.organs
			if(!eyes && SPT_PROB(2.5, seconds_per_tick))
				var/obj/item/organ/eyes/snail/new_eyes = new()
				new_eyes.Insert(affected_mob)
				affected_mob.visible_message(span_warning("[affected_mob]的眼睛掉了出来，取而代之的是蜗牛的眼睛！"), \
				span_userdanger("你痛苦地尖叫，因为你的新蜗牛眼睛把你的眼睛挤了出来！"))
				affected_mob.emote("scream")
				return

			var/obj/item/shell = affected_mob.get_item_by_slot(ITEM_SLOT_BACK)
			if(!istype(shell, /obj/item/storage/backpack/snail))
				shell = null
			if(!shell && SPT_PROB(2.5, seconds_per_tick))
				if(affected_mob.dropItemToGround(affected_mob.get_item_by_slot(ITEM_SLOT_BACK)))
					affected_mob.equip_to_slot_or_del(new /obj/item/storage/backpack/snail(affected_mob), ITEM_SLOT_BACK)
					affected_mob.visible_message(span_warning("[affected_mob]的背上长出了一个怪异的壳！"), \
					span_userdanger("你痛苦地尖叫，一个壳从你的皮肤下挤了出来！"))
					affected_mob.emote("scream")
					return

			var/obj/item/organ/tongue/tongue = locate(/obj/item/organ/tongue/snail) in affected_mob.organs
			if(!tongue && SPT_PROB(2.5, seconds_per_tick))
				var/obj/item/organ/tongue/snail/new_tongue = new()
				new_tongue.Insert(affected_mob)
				to_chat(affected_mob, span_userdanger("你感觉自己的语速变慢了..."))
				return

			if(shell && eyes && tongue && SPT_PROB(2.5, seconds_per_tick))
				affected_mob.set_species(/datum/species/snail)
				affected_mob.client?.give_award(/datum/award/achievement/jobs/snail, affected_mob)
				affected_mob.visible_message(span_warning("[affected_mob]变成了一只蜗牛！"), \
				span_boldnotice("你变成了蜗牛人！你感到一股想要爬行蠕动（cccRRRaaaawwwlll...）的冲动..."))
				cure()
				return FALSE

			if(SPT_PROB(5, seconds_per_tick))
				affected_mob.emote("gag")
			if(SPT_PROB(5, seconds_per_tick))
				var/turf/open/OT = get_turf(affected_mob)
				if(isopenturf(OT))
					OT.MakeSlippery(TURF_WET_LUBE, 100)


/datum/disease/gastrolosis/cure(add_resistance = TRUE)
	. = ..()
	if(affected_mob && !is_species(affected_mob, /datum/species/snail)) //undo all the snail fuckening
		var/mob/living/carbon/human/H = affected_mob
		var/obj/item/organ/tongue/tongue = locate(/obj/item/organ/tongue/snail) in H.organs
		if(tongue)
			var/obj/item/organ/tongue/new_tongue = new H.dna.species.mutanttongue ()
			new_tongue.Insert(H)
		var/obj/item/organ/eyes/eyes = locate(/obj/item/organ/eyes/snail) in H.organs
		if(eyes)
			var/obj/item/organ/eyes/new_eyes = new H.dna.species.mutanteyes ()
			new_eyes.Insert(H)
		var/obj/item/storage/backpack/bag = H.get_item_by_slot(ITEM_SLOT_BACK)
		if(istype(bag, /obj/item/storage/backpack/snail))
			bag.emptyStorage()
			H.temporarilyRemoveItemFromInventory(bag, TRUE)
			qdel(bag)
