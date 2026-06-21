/// Caused by dirty food. Makes you vomit stars.
/datum/disease/nebula_nausea
	name = "星云眩晕症"
	desc = "你无法将宇宙的斑斓之美容纳于体内。"
	form = "Condition"
	agent = "Stars"
	cure_text = /datum/reagent/space_cleaner::name
	spread_text = "None"
	cures = list(/datum/reagent/space_cleaner)
	viable_mobtypes = list(/mob/living/carbon/human)
	spread_flags = DISEASE_SPREAD_NON_CONTAGIOUS
	severity = DISEASE_SEVERITY_MEDIUM
	required_organ = ORGAN_SLOT_STOMACH
	max_stages = 5

/datum/disease/advance/nebula_nausea/stage_act(seconds_per_tick)
	. = ..()
	if(!.)
		return

	switch(stage)
		if(2)
			if(SPT_PROB(1, seconds_per_tick) && affected_mob.stat == CONSCIOUS)
				to_chat(affected_mob, span_warning("宇宙的斑斓之美似乎影响了你的平衡感。"))
		if(3)
			if(SPT_PROB(1, seconds_per_tick) && affected_mob.stat == CONSCIOUS)
				to_chat(affected_mob, span_warning("你的胃里翻涌着人类肉眼无法看见的色彩。"))
		if(4)
			if(SPT_PROB(1, seconds_per_tick) && affected_mob.stat == CONSCIOUS)
				to_chat(affected_mob, span_warning("感觉就像漂浮在一片由天体色彩构成的漩涡之中。"))
		if(5)
			if(SPT_PROB(1, seconds_per_tick) && affected_mob.stat == CONSCIOUS)
				to_chat(affected_mob, span_warning("你的胃已经变成一个汹涌的星云，翻腾着万花筒般的图案。"))
			else
				affected_mob.vomit(vomit_flags = (MOB_VOMIT_MESSAGE | MOB_VOMIT_HARM), vomit_type = /obj/effect/decal/cleanable/vomit/nebula, lost_nutrition = 10, distance = 2)
