/datum/borer_focus
	/// Name of the focus
	var/name = ""
	/// Cost of the focus
	var/cost = 5
	/// Traits to add/remove
	var/list/traits = list()

/// Effects to take when the focus is added
/datum/borer_focus/proc/on_add(mob/living/carbon/human/host, mob/living/basic/cortical_borer/borer)
	SHOULD_CALL_PARENT(TRUE)
	for(var/trait in traits)
		if(HAS_TRAIT(host, trait))
			continue
		ADD_TRAIT(host, trait, REF(borer))

/// Effects to take when the focus is removed
/datum/borer_focus/proc/on_remove(mob/living/carbon/human/host, mob/living/basic/cortical_borer/borer)
	SHOULD_CALL_PARENT(TRUE)
	for(var/trait in traits)
		if(!HAS_TRAIT_FROM(host, trait, REF(borer)))
			continue
		REMOVE_TRAIT(host, trait, REF(borer))

/datum/borer_focus/head
	name = "头部专注"
	traits = list(TRAIT_NOFLASH, TRAIT_TRUE_NIGHT_VISION, TRAIT_KNOW_ENGI_WIRES)

/datum/borer_focus/head/on_add(mob/living/carbon/human/host, mob/living/basic/cortical_borer/borer)
	to_chat(host, span_notice("你的眼睛开始感觉有些奇怪..."))
	return ..()

/datum/borer_focus/head/on_remove(mob/living/carbon/human/host, mob/living/basic/cortical_borer/borer)
	to_chat(host, span_notice("你的眼睛开始恢复正常..."))
	host.update_sight()
	return ..()

/datum/borer_focus/chest
	name = "胸部专注"
	traits = list(TRAIT_NOBREATH, TRAIT_NOHUNGER, TRAIT_STABLEHEART)

/datum/borer_focus/chest/on_add(mob/living/carbon/human/host, mob/living/basic/cortical_borer/borer)
	to_chat(host, span_notice("你的胸膛开始放缓..."))
	host.nutrition = NUTRITION_LEVEL_WELL_FED
	return ..()

/datum/borer_focus/chest/on_remove(mob/living/carbon/human/host, mob/living/basic/cortical_borer/borer)
	to_chat(host, span_notice("你的胸膛又开始起伏了..."))
	return ..()

/datum/borer_focus/arms
	name = "手臂专注"
	traits = list(TRAIT_QUICKER_CARRY, TRAIT_QUICK_BUILD, TRAIT_SHOCKIMMUNE)

/datum/borer_focus/arms/on_add(mob/living/carbon/human/host, mob/living/basic/cortical_borer/borer)
	to_chat(host, span_notice("你的手臂开始感觉怪怪的..."))
	borer.human_host.add_actionspeed_modifier(/datum/actionspeed_modifier/focus_speed)
	return ..()

/datum/borer_focus/arms/on_remove(mob/living/carbon/human/host, mob/living/basic/cortical_borer/borer)
	to_chat(host, span_notice("你的手臂开始恢复正常感觉..."))
	borer.human_host.remove_actionspeed_modifier(ACTIONSPEED_ID_BORER)
	return ..()

/datum/borer_focus/legs
	name = "腿部专注"
	traits = list(TRAIT_LIGHT_STEP, TRAIT_FREERUNNING, TRAIT_SILENT_FOOTSTEPS)

/datum/borer_focus/legs/on_add(mob/living/carbon/human/host, mob/living/basic/cortical_borer/borer)
	to_chat(host, span_notice("你感觉更快了..."))
	host.add_movespeed_modifier(/datum/movespeed_modifier/focus_speed)
	return ..()

/datum/borer_focus/legs/on_remove(mob/living/carbon/human/host, mob/living/basic/cortical_borer/borer)
	to_chat(host, span_notice("你感觉变慢了..."))
	host.remove_movespeed_modifier(/datum/movespeed_modifier/focus_speed)
	return ..()
