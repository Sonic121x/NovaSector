// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/disease/beesease
	name = "Beesease"
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
				to_chat(affected_mob, span_notice(LANG("datum.20db2db29b5afbce", null)))
		if(3)
			if(SPT_PROB(5, seconds_per_tick))
				to_chat(affected_mob, span_notice(LANG("datum.200b6fea99986e8f", null)))
			if(SPT_PROB(1, seconds_per_tick))
				to_chat(affected_mob, span_danger(LANG("datum.9946fd2eef6801b4", null)))
				if(prob(20))
					affected_mob.adjust_tox_loss(2)
		if(4)
			if(SPT_PROB(5, seconds_per_tick))
				affected_mob.visible_message(span_danger(LANG("datum.9f1f2989394f9812", list(affected_mob))), \
												span_userdanger(LANG("datum.6296b531c28cfbdf", null)))
			if(SPT_PROB(2.5, seconds_per_tick))
				to_chat(affected_mob, span_danger(LANG("datum.cc67bbbf9c2a7c3f", null)))
			if(SPT_PROB(0.5, seconds_per_tick))
				affected_mob.visible_message(span_danger(LANG("datum.0573fed1f62ca5a6", list(affected_mob))), \
													span_userdanger(LANG("datum.001949bff9ed5612", null)))
				new /mob/living/basic/bee(affected_mob.loc)
