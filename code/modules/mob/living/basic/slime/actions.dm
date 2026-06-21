/datum/action/innate/slime
	check_flags = AB_CHECK_CONSCIOUS
	button_icon = 'icons/mob/actions/actions_slime.dmi'
	background_icon_state = "bg_alien"
	overlay_icon_state = "bg_alien_border"
	///Does the ability require a specific slime lifestage?
	var/life_stage_required
	///Does the ability requires the slime to hit max growth?
	var/needs_growth = FALSE
	///Does the ability cost nutrition?
	var/nutrition_cost = 0

/datum/action/innate/slime/IsAvailable(feedback = FALSE)
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/basic/slime/slime_owner = owner

	if(!isnull(life_stage_required) && slime_owner.life_stage != life_stage_required)
		return FALSE

	if(slime_owner.nutrition < nutrition_cost)
		return FALSE

	if(needs_growth && slime_owner.amount_grown < SLIME_EVOLUTION_THRESHOLD)
		return FALSE
	return TRUE

//Evolving

/datum/action/innate/slime/evolve
	name = "进化"
	button_icon_state = "slimegrow"
	desc = "这将让你从史莱姆幼体进化为成体。"
	life_stage_required = SLIME_LIFE_STAGE_BABY
	needs_growth = TRUE
	nutrition_cost = SLIME_EVOLUTION_COST

///Turns a baby slime into an adult slime
/datum/action/innate/slime/evolve/Activate()
	var/mob/living/basic/slime/slime_owner = owner

	if(slime_owner.stat)
		slime_owner.balloon_alert(slime_owner, "失去意识！")
		return
	if(slime_owner.life_stage == SLIME_LIFE_STAGE_ADULT)
		slime_owner.balloon_alert(slime_owner, "已经是成年体了！")
		return
	if(slime_owner.amount_grown < SLIME_EVOLUTION_THRESHOLD)
		slime_owner.balloon_alert(slime_owner, "需要成长！")
		return
	if(slime_owner.nutrition < nutrition_cost)
		slime_owner.balloon_alert(slime_owner, "需要食物！")
		return

	slime_owner.adjust_nutrition(-nutrition_cost)

	slime_owner.set_life_stage(SLIME_LIFE_STAGE_ADULT)
	slime_owner.update_name()
	slime_owner.regenerate_icons()

	slime_owner.amount_grown = 0

//Reproduction

/datum/action/innate/slime/reproduce
	name = "繁殖"
	button_icon_state = "slimesplit"
	desc = "这将使你分裂成四个史莱姆。"
	life_stage_required = SLIME_LIFE_STAGE_ADULT
	needs_growth = TRUE

/datum/action/innate/slime/reproduce/Activate()
	var/mob/living/basic/slime/slime_owner = owner
	slime_owner.reproduce()

///Splits the slime into multiple children if possible
/mob/living/basic/slime/proc/reproduce()

	if(stat != CONSCIOUS)
		balloon_alert(src, "没有意识！")
		return

	if(!isopenturf(loc))
		balloon_alert(src, "不能在这里！")

	if(life_stage != SLIME_LIFE_STAGE_ADULT)
		balloon_alert(src, "不是成年体！")
		return

	if(amount_grown < SLIME_EVOLUTION_THRESHOLD)
		balloon_alert(src, "需要成长！")
		return

	var/list/friends_list = list()
	for(var/mob/living/basic/slime/friend in loc)
		if(QDELETED(friend))
			continue
		if(friend == src)
			continue
		friends_list += friend

	overcrowded = length(friends_list) >= SLIME_OVERCROWD_AMOUNT
	if(overcrowded)
		balloon_alert(src, "过于拥挤！")
		return

	var/new_nutrition = floor(nutrition * 0.9)
	var/new_powerlevel = floor(powerlevel * 0.25)
	var/turf/drop_loc = drop_location()

	var/list/created_slimes = list(src)
	var/list/slime_friends = list()
	for(var/faction_member in get_faction())
		var/mob/living/possible_friend = locate(faction_member) in GLOB.mob_living_list
		if(QDELETED(possible_friend))
			continue
		slime_friends += possible_friend

	for(var/i in 1 to 3)
		var/mob/living/basic/slime/baby = new(drop_loc, get_random_mutation())
		created_slimes += baby
		for(var/slime_friend in slime_friends)
			baby.befriend(slime_friend)

		SSblackbox.record_feedback("tally", "slime_babies_born", 1, baby.slime_type.colour)
		step_away(baby, src)

	set_nutrition(SLIME_STARTING_NUTRITION)
	for(var/mob/living/basic/slime/baby as anything in created_slimes)
		if(ckey) // Player slimes are more robust at spliting. Once an oversight of poor copypasta, now a feature!
			baby.set_nutrition(new_nutrition)
		baby.powerlevel = new_powerlevel
		if(mutation_chance)
			baby.mutation_chance = clamp(mutation_chance + rand(-5, 5), 0, 100)
		else
			baby.mutation_chance = 0

	set_life_stage(SLIME_LIFE_STAGE_BABY)
	set_slime_type(get_random_mutation())
	amount_grown = 0
	mutator_used = FALSE

/mob/living/basic/slime/proc/get_random_mutation()
	if(mutation_chance >= 100)
		return /datum/slime_type/rainbow
	else if(prob(mutation_chance))
		return pick_weight(slime_type.mutations)
	else
		return slime_type.type
