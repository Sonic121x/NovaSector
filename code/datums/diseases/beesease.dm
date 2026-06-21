/datum/disease/beesease
	name = "蜂群症"
	form = "Parasite"
	max_stages = 4
	spread_text = "Skin contact"
	spread_flags = DISEASE_SPREAD_BLOOD | DISEASE_SPREAD_CONTACT_SKIN | DISEASE_SPREAD_CONTACT_FLUIDS
	cure_text = /datum/reagent/consumable/sugar::name
	cures = list(/datum/reagent/consumable/sugar)
	agent = "Apidae Infection"
	viable_mobtypes = list(/mob/living/carbon/human)
	desc = "A strange disease that leads to the gestation of bees in the subject's stomach, which are often regurgitated."
	severity = DISEASE_SEVERITY_MEDIUM
	infectable_biotypes = MOB_ORGANIC|MOB_UNDEAD //bees nesting in corpses


/datum/disease/beesease/stage_act(seconds_per_tick)
	. = ..()
	if(!.)
		return

	switch(stage)
		if(2) //also changes say, see say.dm
			if(SPT_PROB(1, seconds_per_tick))
				to_chat(affected_mob, span_notice("你尝到了嘴里的蜂蜜味。"))
		if(3)
			if(SPT_PROB(5, seconds_per_tick))
				to_chat(affected_mob, span_notice("你的肚子咕咕作响。"))
			if(SPT_PROB(1, seconds_per_tick))
				to_chat(affected_mob, span_danger("你的胃部传来刺痛。"))
				if(prob(20))
					affected_mob.adjust_tox_loss(2)
		if(4)
			if(SPT_PROB(5, seconds_per_tick))
				affected_mob.visible_message(span_danger("[affected_mob] 嗡嗡作响。"), \
												span_userdanger("你的胃部剧烈地嗡嗡震动！"))
			if(SPT_PROB(2.5, seconds_per_tick))
				to_chat(affected_mob, span_danger("你感觉喉咙里有东西在动。"))
			if(SPT_PROB(0.5, seconds_per_tick))
				affected_mob.visible_message(span_danger("[affected_mob] 咳出了一群蜜蜂！"), \
													span_userdanger("你咳出了一群蜜蜂！"))
				new /mob/living/basic/bee(affected_mob.loc)
