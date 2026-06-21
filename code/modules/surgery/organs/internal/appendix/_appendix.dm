// A 10% chance that out of a group of 25 people, one person will get appendicitis in 1 hour.
#define APPENDICITIS_PROB 100 * (0.1 * (1 / 25) / 3600)
#define INFLAMATION_ADVANCEMENT_PROB 2

/obj/item/organ/appendix
	name = "阑尾"
	icon_state = "appendix"
	base_icon_state = "appendix"

	zone = BODY_ZONE_PRECISE_GROIN
	slot = ORGAN_SLOT_APPENDIX
	food_reagents = list(/datum/reagent/consumable/nutriment/organ_tissue = 5, /datum/reagent/toxin/bad_food = 5)
	healing_factor = STANDARD_ORGAN_HEALING
	decay_factor = STANDARD_ORGAN_DECAY

	now_failing = span_warning("你的右下腹爆发出一阵剧痛！")
	now_fixed = span_info("你腹部的疼痛已经消退。")
	visual = FALSE

	var/inflamation_stage = 0

/obj/item/organ/appendix/grind_results()
	return list(/datum/reagent/toxin/bad_food = 5)

/obj/item/organ/appendix/update_name()
	. = ..()
	name = "[inflamation_stage ? "inflamed " : null][initial(name)]"

/obj/item/organ/appendix/update_icon_state()
	icon_state = "[base_icon_state][inflamation_stage ? "inflamed" : ""]"
	return ..()

/obj/item/organ/appendix/on_life(seconds_per_tick)
	. = ..()
	if(!owner)
		return

	if(organ_flags & ORGAN_FAILING)
		// forced to ensure people don't use it to gain tox as slime person
		owner.adjust_tox_loss(2 * seconds_per_tick, forced = TRUE)
	else if(inflamation_stage)
		inflamation(seconds_per_tick)
	else if(SPT_PROB(APPENDICITIS_PROB, seconds_per_tick) && !HAS_TRAIT(owner, TRAIT_TEMPORARY_BODY))
		become_inflamed()

/obj/item/organ/appendix/proc/become_inflamed()
	inflamation_stage = 1
	update_appearance()
	if(isnull(owner))
		return
	ADD_TRAIT(owner, TRAIT_DISEASELIKE_SEVERITY_MEDIUM, type)
	owner.med_hud_set_status()
	RegisterSignal(owner, COMSIG_LIVING_POST_FULLY_HEAL, PROC_REF(on_fully_heal))
	if(isnull(owner.client))
		return
	notify_ghosts(
		"[owner.real_name] has developed spontaneous appendicitis!",
		source = owner,
		header = "Whoa, Sick!",
	)

/obj/item/organ/appendix/proc/inflamation(seconds_per_tick)
	var/mob/living/carbon/organ_owner = owner
	if(inflamation_stage < 3 && SPT_PROB(INFLAMATION_ADVANCEMENT_PROB, seconds_per_tick))
		inflamation_stage += 1

	switch(inflamation_stage)
		if(1)
			if(SPT_PROB(2.5, seconds_per_tick))
				organ_owner.emote("cough")
		if(2)
			if(SPT_PROB(1.5, seconds_per_tick))
				to_chat(organ_owner, span_warning("你感到腹部一阵刺痛！"))
				organ_owner.adjust_organ_loss(ORGAN_SLOT_APPENDIX, 5)
				organ_owner.Stun(rand(40, 60))
				organ_owner.adjust_tox_loss(1, forced = TRUE)
		if(3)
			if(SPT_PROB(0.5, seconds_per_tick))
				organ_owner.vomit(VOMIT_CATEGORY_DEFAULT, lost_nutrition = 95)
				organ_owner.adjust_organ_loss(ORGAN_SLOT_APPENDIX, 15)

/obj/item/organ/appendix/feel_for_damage(self_aware)
	var/effective_stage = floor(inflamation_stage + (damage / maxHealth))
	switch(effective_stage)
		if(1)
			return span_warning("你的[self_aware ? "appendix" : "lower abdomen"]感觉有点不对劲。")
		if(2)
			return span_warning("你的[self_aware ? "appendix" : "lower right abdomen"]感觉疼痛。")
		if(3 to INFINITY)
			return span_boldwarning("你的[self_aware ? "appendix" : "lower right abdomen"]感觉像着火了一样！")

/obj/item/organ/appendix/get_availability(datum/species/owner_species, mob/living/owner_mob)
	return owner_species.mutantappendix

/obj/item/organ/appendix/on_mob_remove(mob/living/carbon/organ_owner)
	. = ..()
	UnregisterSignal(organ_owner, COMSIG_LIVING_POST_FULLY_HEAL)
	REMOVE_TRAIT(organ_owner, TRAIT_DISEASELIKE_SEVERITY_MEDIUM, type)
	organ_owner.med_hud_set_status()

/obj/item/organ/appendix/on_mob_insert(mob/living/carbon/organ_owner)
	. = ..()
	if(!inflamation_stage)
		return
	ADD_TRAIT(organ_owner, TRAIT_DISEASELIKE_SEVERITY_MEDIUM, type)
	organ_owner.med_hud_set_status()
	RegisterSignal(organ_owner, COMSIG_LIVING_POST_FULLY_HEAL, PROC_REF(on_fully_heal))

/obj/item/organ/appendix/proc/on_fully_heal(datum/source, heal_flags)
	SIGNAL_HANDLER

	if (!(heal_flags & HEAL_ORGANS))
		return

	inflamation_stage = 0
	update_appearance()
	UnregisterSignal(owner, COMSIG_LIVING_POST_FULLY_HEAL)
	REMOVE_TRAIT(owner, TRAIT_DISEASELIKE_SEVERITY_MEDIUM, type)
	owner.med_hud_set_status()

/obj/item/organ/appendix/get_status_text(advanced, add_tooltips, colored)
	if(!(organ_flags & ORGAN_FAILING) && inflamation_stage)
		return conditional_tooltip("<font color='#ff9933'>Inflamed</font>", "Remove surgically.", add_tooltips)
	return ..()

/obj/item/organ/appendix/pod
	name = "荚果小东西"
	desc = "你见过的最奇怪的沙拉。"
	foodtype_flags = PODPERSON_ORGAN_FOODTYPES
	color = COLOR_LIME

/obj/item/organ/appendix/pod/Initialize(mapload)
	. = ..()
	// this could be anything... anything. still useless though
	name = pick("荚果内质网", "荚果高尔基体", "荚果质体", "荚果囊泡")

/obj/item/organ/appendix/pod/become_inflamed()
	return

#undef APPENDICITIS_PROB
#undef INFLAMATION_ADVANCEMENT_PROB
