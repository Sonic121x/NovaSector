// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/disease/anxiety
	name = "Severe Anxiety"
	form = "Condition"
	max_stages = 4
	spread_text = "Skin contact"
	spread_flags = DISEASE_SPREAD_BLOOD | DISEASE_SPREAD_CONTACT_SKIN | DISEASE_SPREAD_CONTACT_FLUIDS
	cure_text = /datum/reagent/consumable/ethanol::name + " (Liquid Courage)"
	cures = list(/datum/reagent/consumable/ethanol)
	agent = "Excess Lepidopticides"
	viable_mobtypes = list(/mob/living/carbon/human)
	desc = "A well documented condition leading to 'butterflies in the stomach' in a literal sense, which are often regurgitated."
	severity = DISEASE_SEVERITY_MINOR


/datum/disease/anxiety/stage_act(seconds_per_tick)
	. = ..()
	if(!.)
		return

	switch(stage)
		if(2) //also changes say, see say.dm
			if(SPT_PROB(2.5, seconds_per_tick))
				to_chat(affected_mob, span_notice(LANG("datum.459e6703366077de", null)))
		if(3)
			if(SPT_PROB(5, seconds_per_tick))
				to_chat(affected_mob, span_notice(LANG("datum.fd6f04319e8a5d0b", null)))
			if(SPT_PROB(2.5, seconds_per_tick))
				to_chat(affected_mob, span_notice(LANG("datum.68dc6663cb51e0e1", null)))
			if(SPT_PROB(1, seconds_per_tick))
				to_chat(affected_mob, span_danger(LANG("datum.1f4fe26e118f145e", null)))
				affected_mob.adjust_confusion(rand(2 SECONDS, 3 SECONDS))
		if(4)
			if(SPT_PROB(5, seconds_per_tick))
				to_chat(affected_mob, span_danger(LANG("datum.8c61d67c6bd19836", null)))
			if(SPT_PROB(2.5, seconds_per_tick))
				affected_mob.visible_message(span_danger(LANG("datum.e375ad11a144e0c5", list(affected_mob))), \
												span_userdanger(LANG("datum.c143250a5a409fe4", null)))
				affected_mob.adjust_confusion(rand(6 SECONDS, 8 SECONDS))
				affected_mob.adjust_jitter(rand(12 SECONDS, 16 SECONDS))
			if(SPT_PROB(1, seconds_per_tick))
				affected_mob.visible_message(span_danger(LANG("datum.b0ba4d5f0fcc6545", list(affected_mob))), \
													span_userdanger(LANG("datum.bde0880fcdc342b0", null)))
				new /mob/living/basic/butterfly(affected_mob.loc)
				new /mob/living/basic/butterfly(affected_mob.loc)
