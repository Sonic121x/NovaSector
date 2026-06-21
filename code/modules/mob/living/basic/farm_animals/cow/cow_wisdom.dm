///Wisdom cow, gives XP to a random skill and speaks wisdoms
/mob/living/basic/cow/wisdom
	name = "智慧奶牛"
	desc = "以智慧著称，与众人共享。"
	gold_core_spawnable = FALSE
	ai_controller = /datum/ai_controller/basic_controller/cow/wisdom
	///The type of wisdom this cow will grant
	var/granted_wisdom
	///How much experience this cow will grant.
	var/granted_experience

/mob/living/basic/cow/wisdom/Initialize(mapload, granted_wisdom, granted_experience = 500, milked_reagent = null)
	src.milked_reagent = milked_reagent
	. = ..()
	src.granted_wisdom = granted_wisdom
	if(!granted_wisdom)
		src.granted_wisdom = pick(GLOB.skill_types)
	src.granted_experience = granted_experience
	if(granted_experience < 0)
		name = "不明智的牛"

/mob/living/basic/cow/wisdom/setup_eating()
	return //cannot tame me! and I don't care about eatin' nothing, neither!

/mob/living/basic/cow/wisdom/setup_udder()
	if (isnull(milked_reagent))
		milked_reagent = get_random_reagent_id()
	return ..()

/datum/ai_controller/basic_controller/cow/wisdom
	//don't give a targeting strategy
	blackboard = list(
		BB_BASIC_MOB_TIP_REACTING = FALSE,
		BB_BASIC_MOB_TIPPER = null,
	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/tip_reaction,
		/datum/ai_planning_subtree/random_speech/cow/wisdom,
	)

///Give intense wisdom to the attacker if they're being friendly about it
/mob/living/basic/cow/wisdom/attack_hand(mob/living/carbon/user, list/modifiers)
	if(!stat && !user.combat_mode)
		to_chat(user, span_nicegreen("[src] 向你低语了一些深刻的智慧，然后消失了！"))
		user.mind?.adjust_experience(granted_wisdom, granted_experience)
		do_smoke(1, src, get_turf(src))
		qdel(src)
		return
	return ..()
