
//////////////////////////Poison stuff (Toxins & Acids)///////////////////////

/datum/reagent/toxin
	name = "Toxin-毒素"
	description = "一种有毒化学品。"
	color = "#CF3600" // rgb: 207, 54, 0
	taste_description = "bitterness"
	taste_mult = 1.2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	///The amount of toxin damage this will cause when metabolized (also used to calculate liver damage)
	var/toxpwr = 1.5
	///The amount to multiply the liver damage this toxin does by (Handled solely in liver code)
	var/liver_damage_multiplier = 1
	///The multiplier of the liver toxin tolerance, below which any amount toxin will be simply metabolized out with no effect.
	var/liver_tolerance_multiplier = 1
	///won't produce a pain message when processed by liver/life() if there isn't another non-silent toxin present if true
	var/silent_toxin = FALSE
	///The afflicted must be above this health value in order for the toxin to deal damage
	var/health_required = -100

// Are you a bad enough dude to poison your own plants?
/datum/reagent/toxin/on_hydroponics_apply(obj/machinery/hydroponics/mytray, mob/user)
	mytray.adjust_toxic(round(volume * 2))

/datum/reagent/toxin/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(toxpwr && affected_mob.health > health_required)
		if(affected_mob.adjust_tox_loss(METABOLIZE_FREE_CONSTANT(0.5) * toxpwr * normalise_creation_purity() * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype))
			return UPDATE_MOB_HEALTH

/datum/reagent/toxin/amatoxin
	name = "Amatoxin-鹅膏菌毒"
	description = "一种从某些蘑菇物种中提取的强效毒药。"
	color = "#792300" // rgb: 121, 35, 0
	toxpwr = 2.5
	taste_description = "mushroom"
	ph = 13
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/toxin/mutagen
	name = "Unstable Mutagen-不稳定诱变剂"
	description = "可能导致不可预测的突变。请远离儿童。"
	color = COLOR_VIBRANT_LIME
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	toxpwr = 0
	taste_description = "slime"
	taste_mult = 0.9
	ph = 2.3
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/toxin/mutagen/expose_mob(mob/living/carbon/exposed_mob, methods=TOUCH, reac_volume, show_message = TRUE, touch_protection = 0)
	. = ..()
	if(!exposed_mob.can_mutate())
		return  //No robots, AIs, aliens, Ians or other mobs should be affected by this.

	if((methods & (PATCH|INGEST|INJECT|INHALE)) || ((methods & (VAPOR|TOUCH)) && prob(min(reac_volume,100)*(1 - touch_protection))))
		exposed_mob.random_mutate_unique_identity()
		exposed_mob.random_mutate_unique_features()
		if(prob(98))
			exposed_mob.easy_random_mutate(NEGATIVE+MINOR_NEGATIVE)
		else
			exposed_mob.easy_random_mutate(POSITIVE)
		exposed_mob.updateappearance()
		exposed_mob.domutcheck()

/datum/reagent/toxin/mutagen/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(affected_mob.adjust_tox_loss(0.25 * seconds_per_tick * metabolization_ratio, required_biotype = affected_biotype))
		return UPDATE_MOB_HEALTH

/datum/reagent/toxin/mutagen/on_hydroponics_apply(obj/machinery/hydroponics/mytray, mob/user)
	mytray.radioactive_exposure(modifier = volume * 0.1)
	mytray.myseed?.adjust_instability(round(volume * 0.2))

/datum/reagent/toxin/mutagen/used_on_fish(obj/item/fish/fish)
	ADD_TRAIT(fish, TRAIT_FISH_MUTAGENIC, type)
	addtimer(TRAIT_CALLBACK_REMOVE(fish, TRAIT_FISH_MUTAGENIC, type), fish.feeding_frequency * 0.8, TIMER_UNIQUE|TIMER_OVERRIDE)
	return TRUE

#define LIQUID_PLASMA_BP (50+T0C)
#define LIQUID_PLASMA_IG (325+T0C)
#define LIQUID_PLASMA_CHARGE_COEFF 2.7
#define LIQUID_PLASMA_VOLUME_POWER_CAP 7

/datum/reagent/toxin/plasma
	name = "Plasma"
	description = "等离子体的液态形式。"
	taste_description = "bitterness"
	specific_heat = SPECIFIC_HEAT_PLASMA
	taste_mult = 1.5
	color = "#8228A0"
	toxpwr = 3
	material = /datum/material/plasma
	penetrates_skin = NONE
	ph = 4
	burning_temperature = 4500//plasma is hot!!
	burning_volume = 0.3//But burns fast
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/toxin/plasma/on_new(data)
	. = ..()
	RegisterSignal(holder, COMSIG_REAGENTS_TEMP_CHANGE, PROC_REF(on_temp_change))

/datum/reagent/toxin/plasma/Destroy()
	UnregisterSignal(holder, COMSIG_REAGENTS_TEMP_CHANGE)
	return ..()

/datum/reagent/toxin/plasma/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(holder.has_reagent(/datum/reagent/medicine/epinephrine))
		holder.remove_reagent(/datum/reagent/medicine/epinephrine, 1 * metabolization_ratio * seconds_per_tick)
	affected_mob.adjustPlasma(10 * metabolization_ratio * seconds_per_tick)

/datum/reagent/toxin/plasma/on_mob_metabolize(mob/living/carbon/affected_mob)
	. = ..()
	if(HAS_TRAIT(affected_mob, TRAIT_PLASMA_LOVER_METABOLISM)) // sometimes mobs can temporarily metabolize plasma (e.g. plasma fixation disease symptom)
		toxpwr = 0

/datum/reagent/toxin/plasma/on_mob_end_metabolize(mob/living/carbon/affected_mob)
	. = ..()
	toxpwr = initial(toxpwr)

/// Handles plasma boiling.
/datum/reagent/toxin/plasma/proc/on_temp_change(datum/reagents/_holder, old_temp)
	SIGNAL_HANDLER
	if(holder.chem_temp < LIQUID_PLASMA_BP)
		return
	if(!holder.my_atom)
		return
	if((holder.flags & SEALED_CONTAINER) && (holder.chem_temp < LIQUID_PLASMA_IG))
		return
	var/atom/A = holder.my_atom
	A.atmos_spawn_air("[GAS_PLASMA]=[volume];[TURF_TEMPERATURE(holder.chem_temp)]")
	holder.del_reagent(type)

/datum/reagent/toxin/plasma/expose_turf(turf/open/exposed_turf, reac_volume)
	if(!istype(exposed_turf))
		return
	var/temp = holder ? holder.chem_temp : T20C
	if(temp >= LIQUID_PLASMA_BP)
		exposed_turf.atmos_spawn_air("[GAS_PLASMA]=[reac_volume];[TURF_TEMPERATURE(temp)]")
	return ..()


// Splashing people with plasma is stronger than fuel!
/datum/reagent/toxin/plasma/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)
	. = ..()
	if(methods & (TOUCH|VAPOR))
		exposed_mob.adjust_fire_stacks(reac_volume / 5)
		return

/datum/reagent/toxin/plasma/on_spark_act(power_charge, spark_flags)
	// Tape up your plasma IEDs
	if ((spark_flags & SPARK_ACT_WEAKEN_COMMON) && !(spark_flags & SPARK_ACT_ENCLOSED))
		if(holder.chem_temp < LIQUID_PLASMA_BP)
			return NONE
		var/turf/holder_turf = get_turf(holder)
		if (holder_turf)
			holder_turf.atmos_spawn_air("[GAS_PLASMA]=[volume];[TURF_TEMPERATURE(holder.chem_temp)]")
		return SPARK_ACT_NON_DESTRUCTIVE

	// If we have any stabilizing agent in the mix, we need 0.2% of a standard cell value per mol of agent to be spent at once to blow
	// This should allow for some more creative traps to be made with plasma
	var/agent_volume = holder.get_reagent_amount(/datum/reagent/stabilizing_agent)
	if (agent_volume && power_charge < agent_volume * 0.002 * STANDARD_CELL_CHARGE)
		return NONE

	// Plasma explosions become stronger with higher current, and don't care about if they're enclosed or not
	var/power_modifier = max(0, round(sqrt(power_charge / STANDARD_CELL_CHARGE) * LIQUID_PLASMA_CHARGE_COEFF, 1) - 1)
	var/strengthdiv = 5
	if (spark_flags & SPARK_ACT_WEAKEN_COMMON)
		strengthdiv *= 3 // Stronger than waterpot, weaker than methbombs
	var/current_limit = round(volume / LIQUID_PLASMA_VOLUME_POWER_CAP, 1)
	// High current can only get you so far before you get a sharp dropoff
	if (power_modifier > current_limit)
		power_modifier = round(current_limit + log(power_modifier - current_limit + 1), 1)
	reagent_explode(holder, volume, modifier = power_modifier, strengthdiv = strengthdiv, clear_holder_reagents = FALSE, flame_factor = 1)
	return SPARK_ACT_DESTRUCTIVE | SPARK_ACT_CLEAR_ALL

#undef LIQUID_PLASMA_BP
#undef LIQUID_PLASMA_IG
#undef LIQUID_PLASMA_CHARGE_COEFF
#undef LIQUID_PLASMA_VOLUME_POWER_CAP

/datum/reagent/toxin/hot_ice
	name = "Hot Ice Slush-可燃冰浆"
	description = "冷冻等离子体，对合适的人来说，其价值堪比黄金。"
	color = "#724cb8" // rgb: 114, 76, 184
	taste_description = "thick and smokey"
	specific_heat = SPECIFIC_HEAT_PLASMA
	toxpwr = 3
	material = /datum/material/hot_ice
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/toxin/hot_ice/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(holder.has_reagent(/datum/reagent/medicine/epinephrine))
		holder.remove_reagent(/datum/reagent/medicine/epinephrine, 1 * metabolization_ratio * seconds_per_tick)
	affected_mob.adjustPlasma(10 * metabolization_ratio * seconds_per_tick)
	affected_mob.adjust_bodytemperature(-3.5 * TEMPERATURE_DAMAGE_COEFFICIENT * metabolization_ratio * seconds_per_tick, affected_mob.get_body_temp_normal())
	if(ishuman(affected_mob))
		var/mob/living/carbon/human/humi = affected_mob
		humi.adjust_coretemperature(-3.5 * metabolization_ratio * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, affected_mob.get_body_temp_normal())

/datum/reagent/toxin/hot_ice/on_mob_metabolize(mob/living/carbon/affected_mob)
	. = ..()
	if(HAS_TRAIT(affected_mob, TRAIT_PLASMA_LOVER_METABOLISM))
		toxpwr = 0

/datum/reagent/toxin/hot_ice/on_mob_end_metabolize(mob/living/carbon/affected_mob)
	. = ..()
	toxpwr = initial(toxpwr)

/datum/reagent/toxin/lexorin
	name = "Lexorin-莱克索林"
	description = "一种用于阻止呼吸的强效毒药。"
	color = "#7DC3A0"
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	toxpwr = 0
	taste_description = "acid"
	ph = 1.2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/toxin/lexorin/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(!HAS_TRAIT(affected_mob, TRAIT_NOBREATH))
		affected_mob.adjust_oxy_loss(2.5 * normalise_creation_purity() * metabolization_ratio * seconds_per_tick, FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type)
		affected_mob.losebreath += 1 * normalise_creation_purity() * metabolization_ratio * seconds_per_tick
		. = UPDATE_MOB_HEALTH
		if(SPT_PROB(10, seconds_per_tick))
			affected_mob.emote("gasp")

/datum/reagent/toxin/lexorin/on_mob_metabolize(mob/living/affected_mob)
	. = ..()
	RegisterSignal(affected_mob, COMSIG_CARBON_ATTEMPT_BREATHE, PROC_REF(block_breath))

/datum/reagent/toxin/lexorin/on_mob_end_metabolize(mob/living/affected_mob)
	. = ..()
	UnregisterSignal(affected_mob, COMSIG_CARBON_ATTEMPT_BREATHE, PROC_REF(block_breath))

/datum/reagent/toxin/lexorin/proc/block_breath(mob/living/source)
	SIGNAL_HANDLER
	return COMSIG_CARBON_BLOCK_BREATH

/datum/reagent/toxin/carnivorousblood
	name = "Carnivorous Blood"
	description = "An Interdyne-developed biological agent that consumes any blood similar to the blood it was trained on."
	color ="#C80000"
	toxpwr = 0
	taste_description = "carbonated blood"
	ph = 7.4
	metabolization_rate = 1.5 * REAGENTS_METABOLISM
	chemical_flags = REAGENT_DEAD_PROCESS
	self_consuming = TRUE
	// Will hold up to three DNA unique enzymes
	data = list()

/datum/reagent/toxin/carnivorousblood/expose_mob(mob/living/exposed_mob, methods, reac_volume, show_message, touch_protection)
	. = ..()
	if(methods & INHALE)
		data = list() // Being vaporized is generally undesirable for living creatures

/datum/reagent/toxin/carnivorousblood/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(!CAN_HAVE_BLOOD(affected_mob) || affected_mob.blood_volume == 0)
		affected_mob.reagents.remove_reagent(/datum/reagent/toxin/carnivorousblood, volume)
		return
	var/multiplier = 1
	if(affected_mob.stat == DEAD)
		multiplier *= 2
	if(affected_mob.dna.unique_enzymes in data)
		multiplier *= 3
	affected_mob.adjust_blood_volume(-2 * multiplier * seconds_per_tick)
	if(SPT_PROB(10, seconds_per_tick))
		to_chat(affected_mob, span_danger("Your blood is writhing in your veins!"))
		if(SPT_PROB(25, seconds_per_tick))
			affected_mob.emote("scream")
	return UPDATE_MOB_HEALTH

/datum/reagent/toxin/carnivorousblood/on_merge(list/mix_data, amount)
	. = ..()
	feed_dna_list(mix_data)

/// Given a list of DNA keys, adds new keys up to the limit of three distinct sequences.
/datum/reagent/toxin/carnivorousblood/proc/feed_dna_list(list/adding_list)
	for(var/dna in adding_list)
		if(data.len >= 3)
			return
		if(dna in data)
			continue
		data += dna

/datum/reagent/toxin/slimejelly
	name = "Slime Jelly-史莱姆果冻"
	description = "一种由现存最致命生命形式之一产生的粘稠半液体。如此真实。"
	color = "#a6959d"
	toxpwr = 0
	taste_description = "slime"
	taste_mult = 1.3
	ph = 10
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/toxin/slimejelly/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(SPT_PROB(5, seconds_per_tick))
		to_chat(affected_mob, span_danger("你的内脏在燃烧！"))
		if(affected_mob.adjust_tox_loss(rand(20, 60) * metabolization_ratio, updating_health = FALSE, required_biotype = affected_biotype))
			return UPDATE_MOB_HEALTH
	else if(SPT_PROB(23, seconds_per_tick))
		if(affected_mob.heal_bodypart_damage(5))
			return UPDATE_MOB_HEALTH

/datum/reagent/toxin/carpotoxin
	name = "Carpotoxin-鲤鱼毒"
	description = "一种由可怕的太空鲤鱼产生的致命神经毒素。"
	silent_toxin = TRUE
	color = "#003333" // rgb: 0, 51, 51
	toxpwr = 1
	taste_description = "fish"
	ph = 12
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/toxin/carpotoxin/on_mob_add(mob/living/affected_mob, amount)
	. = ..()
	if (HAS_TRAIT(affected_mob, TRAIT_CARPOTOXIN_IMMUNE))
		toxpwr = 0

/datum/reagent/toxin/zombiepowder
	name = "Zombie Powder-尸粉"
	description = "一种强效神经毒素，能使患者进入类似死亡的状态。"
	silent_toxin = TRUE
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	color = "#669900" // rgb: 102, 153, 0
	toxpwr = 0.5
	taste_description = "death"
	penetrates_skin = NONE
	ph = 13
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/toxin/zombiepowder/expose_mob(mob/living/exposed_mob, methods, reac_volume, show_message, touch_protection)
	. = ..()
	if(!isliving(exposed_mob) || !(methods & (INGEST|INHALE)))
		return

	LAZYINITLIST(data)
	data["method"] |= methods

	//the stomach handles INGEST via on_mob_metabolize() we only deal with INHALE
	//also means vapour works much faster which is realistic
	if(methods & INHALE)
		zombify(exposed_mob)
/**
 * Does the fake death & oxy loss on the mob
 *
 * Arguments
 * * mob/living/holder_mob - the mob we are zombifying
*/
/datum/reagent/toxin/zombiepowder/proc/zombify(mob/living/holder_mob)
	PRIVATE_PROC(TRUE)

	holder_mob.adjust_oxy_loss(0.25, FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type)
	if((data?["method"] & (INGEST|INHALE)) && holder_mob.stat != DEAD)
		holder_mob.apply_status_effect(/datum/status_effect/reagent_effect/fakedeath, type)

/datum/reagent/toxin/zombiepowder/on_mob_metabolize(mob/living/holder_mob)
	. = ..()
	zombify(holder_mob)

/datum/reagent/toxin/zombiepowder/on_mob_end_metabolize(mob/living/affected_mob)
	. = ..()
	affected_mob.remove_status_effect(/datum/status_effect/reagent_effect/fakedeath)

/datum/reagent/toxin/zombiepowder/on_mob_life(mob/living/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(HAS_TRAIT(affected_mob, TRAIT_FAKEDEATH) && HAS_TRAIT(affected_mob, TRAIT_DEATHCOMA))
		return
	var/need_mob_update
	switch(current_cycle)
		if(2 to 6)
			affected_mob.adjust_confusion(0.5 SECONDS * metabolization_ratio * seconds_per_tick)
			affected_mob.adjust_drowsiness(1 SECONDS * metabolization_ratio * seconds_per_tick)
			affected_mob.adjust_slurring(3 SECONDS * metabolization_ratio * seconds_per_tick)
		if(6 to 9)
			need_mob_update = affected_mob.adjust_stamina_loss(20 * metabolization_ratio * seconds_per_tick, updating_stamina = FALSE)
		if(10 to INFINITY)
			if(affected_mob.stat != DEAD)
				affected_mob.apply_status_effect(/datum/status_effect/reagent_effect/fakedeath, type)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/toxin/ghoulpowder
	name = "Ghoul Powder-尸鬼粉"
	description = "一种强效神经毒素，能将新陈代谢减缓至类似死亡的状态，同时让患者保持完全清醒。使用过久会导致毒素积累。"
	color = "#664700" // rgb: 102, 71, 0
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	toxpwr = 0.8
	taste_description = "death"
	ph = 14.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	metabolized_traits = list(TRAIT_FAKEDEATH)

/datum/reagent/toxin/ghoulpowder/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(affected_mob.adjust_oxy_loss(0.5 * metabolization_ratio * seconds_per_tick, FALSE, updating_health = FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type))
		return UPDATE_MOB_HEALTH

/datum/reagent/toxin/mindbreaker
	name = "Mindbreaker Toxin-失智毒素"
	description = "一种强效致幻剂，不可乱用。然而，对于一些精神疾病患者，它反而能抵消其症状，将他们锚定在现实中。"
	color = "#B31008" // rgb: 139, 166, 233
	toxpwr = 0
	taste_description = "sourness"
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	ph = 11
	inverse_chem = /datum/reagent/impurity/rosenol
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	addiction_types = list(/datum/addiction/hallucinogens = 60)
	metabolized_traits = list(TRAIT_RDS_SUPPRESSED)

/datum/reagent/toxin/mindbreaker/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	// mindbreaker toxin assuages hallucinations in those plagued with it, mentally
	if(affected_mob.has_trauma_type(/datum/brain_trauma/mild/hallucinations))
		affected_mob.remove_status_effect(/datum/status_effect/hallucination)

	// otherwise it creates hallucinations. truly a miracle medicine.
	else
		affected_mob.adjust_hallucinations(5 SECONDS * metabolization_ratio * seconds_per_tick)

/datum/reagent/toxin/mindbreaker/fish
	name = "水母致幻剂"
	description = "一种在结构上与精神破坏毒素相似的致幻剂，但分子键较弱，使其容易被热降解。"

/datum/reagent/toxin/mindbreaker/fish/on_new(data)
	. = ..()
	if(holder?.my_atom)
		RegisterSignals(holder.my_atom, list(COMSIG_ITEM_FRIED, COMSIG_ITEM_BARBEQUE_GRILLED), PROC_REF(on_atom_cooked))

/datum/reagent/toxin/mindbreaker/fish/proc/on_atom_cooked(datum/source, cooking_time)
	SIGNAL_HANDLER
	holder.del_reagent(type)

/datum/reagent/toxin/plantbgone
	name = "Plant-B-Gone-百草枯"
	description = "一种用于杀死植物的有害有毒混合物。请勿摄入！"
	color = "#49002E" // rgb: 73, 0, 46
	toxpwr = 1
	taste_mult = 1
	penetrates_skin = NONE
	ph = 2.7
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

// Plant-B-Gone is just as bad
/datum/reagent/toxin/plantbgone/on_hydroponics_apply(obj/machinery/hydroponics/mytray, mob/user)
	mytray.adjust_plant_health(-round(volume * 10))
	mytray.adjust_toxic(round(volume * 6))
	mytray.adjust_weedlevel(-rand(4,8))

/datum/reagent/toxin/plantbgone/expose_obj(obj/exposed_obj, reac_volume, methods=TOUCH, show_message=TRUE)
	. = ..()
	if(istype(exposed_obj, /obj/structure/alien/weeds))
		var/obj/structure/alien/weeds/alien_weeds = exposed_obj
		alien_weeds.take_damage(rand(15, 35), BRUTE, 0) // Kills alien weeds pretty fast
	if(istype(exposed_obj, /obj/structure/alien/resin/flower_bud))
		var/obj/structure/alien/resin/flower_bud/flower = exposed_obj
		flower.take_damage(rand(30, 50), BRUTE, 0)
	else if(istype(exposed_obj, /obj/structure/glowshroom)) //even a small amount is enough to kill it
		qdel(exposed_obj)
	else if(istype(exposed_obj, /obj/structure/spacevine))
		var/obj/structure/spacevine/SV = exposed_obj
		SV.on_chem_effect(src)

/datum/reagent/toxin/plantbgone/expose_mob(mob/living/exposed_mob, methods = TOUCH, reac_volume)
	. = ..()
	var/damage = min(round(0.4 * reac_volume, 0.1), 10)
	if(exposed_mob.mob_biotypes & MOB_PLANT)
		// spray bottle emits 5u so it's dealing ~15 dmg per spray
		if(exposed_mob.adjust_tox_loss(damage * 20, required_biotype = affected_biotype))
			return

	if(!(methods & VAPOR) || !iscarbon(exposed_mob))
		return

	var/mob/living/carbon/exposed_carbon = exposed_mob
	if(!exposed_carbon.wear_mask)
		exposed_carbon.adjust_tox_loss(damage, required_biotype = affected_biotype)

/datum/reagent/toxin/plantbgone/weedkiller
	name = "Weed Killer-除草剂"
	description = "一种用于杀死杂草的有害有毒混合物。请勿摄入！"
	color = "#4B004B" // rgb: 75, 0, 75
	ph = 3
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

//Weed Spray
/datum/reagent/toxin/plantbgone/weedkiller/on_hydroponics_apply(obj/machinery/hydroponics/mytray, mob/user)
	mytray.adjust_toxic(round(volume * 0.5))
	mytray.adjust_weedlevel(-rand(1,2))

/datum/reagent/toxin/pestkiller
	name = "Pest Killer-杀虫剂"
	description = "一种用于杀死害虫的有害有毒混合物。请勿摄入！"
	color = "#4B004B" // rgb: 75, 0, 75
	toxpwr = 1
	ph = 3.2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/toxin/pestkiller/on_new(data)
	. = ..()
	AddElement(/datum/element/bugkiller_reagent)

/datum/reagent/toxin/pestkiller/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(affected_mob.adjust_tox_loss(1 * toxpwr * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_biotype = MOB_BUG))
		return UPDATE_MOB_HEALTH

//Pest Spray
/datum/reagent/toxin/pestkiller/on_hydroponics_apply(obj/machinery/hydroponics/mytray, mob/user)
	mytray.adjust_toxic(round(volume))
	mytray.adjust_pestlevel(-rand(1,2))

/datum/reagent/toxin/pestkiller/organic
	name = "Natural Pest Killer-天然杀虫剂"
	description = "一种用于杀死害虫的有机混合物，副作用较少。请勿摄入！"
	color = "#4b2400" // rgb: 75, 0, 75
	toxpwr = 1
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

//Pest Spray
/datum/reagent/toxin/pestkiller/organic/on_hydroponics_apply(obj/machinery/hydroponics/mytray, mob/user)
	mytray.adjust_toxic(round(volume * 0.1))
	mytray.adjust_pestlevel(-rand(1,2))

/datum/reagent/toxin/spore
	name = "Spore Toxin-孢子毒素"
	description = "一种由团块孢子产生的天然毒素，摄入后会抑制视力。"
	color = "#9ACD32"
	toxpwr = 1
	ph = 11
	liver_damage_multiplier = 0.7
	taste_description = "spores"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/toxin/spore/expose_mob(mob/living/spore_lung_victim, methods, reac_volume, show_message, touch_protection)
	. = ..()

	if(!(methods & INHALE))
		return
	if(!(spore_lung_victim.mob_biotypes & (MOB_HUMANOID | MOB_BEAST)))
		return

	if(prob(min(reac_volume * 10, 80)))
		to_chat(spore_lung_victim, span_danger("[pick("You have a coughing fit!", "You hack and cough!", "Your lungs burn!")]"))
		spore_lung_victim.Stun(1 SECONDS)
		spore_lung_victim.emote("cough")

/datum/reagent/toxin/spore/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.damageoverlaytemp = 60
	affected_mob.update_damage_hud()
	affected_mob.set_eye_blur_if_lower(3 SECONDS * metabolization_ratio * seconds_per_tick)

/datum/reagent/toxin/spore_burning
	name = "Burning Spore Toxin-燃孢毒素"
	description = "一种由团块孢子产生的天然毒素，会引燃受害者。"
	color = "#9ACD32"
	toxpwr = 0.5
	taste_description = "burning"
	ph = 13
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/toxin/spore_burning/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.adjust_fire_stacks(1 * metabolization_ratio * seconds_per_tick)
	affected_mob.ignite_mob()

/datum/reagent/toxin/chloralhydrate
	name = "Chloral Hydrate-水合氯醛"
	description = "一种强效镇静剂，在使目标入睡前会引发混乱和困倦。"
	silent_toxin = TRUE
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	color = "#000067" // rgb: 0, 0, 103
	toxpwr = 0
	metabolization_rate = 1.5 * REAGENTS_METABOLISM
	ph = 11
	inverse_chem = /datum/reagent/impurity/chloralax
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/toxin/chloralhydrate/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	switch(current_cycle)
		if(2 to 11)
			affected_mob.adjust_confusion(0.67 SECONDS * normalise_creation_purity() * metabolization_ratio * seconds_per_tick)
			affected_mob.adjust_drowsiness(1.34 SECONDS * normalise_creation_purity() * metabolization_ratio * seconds_per_tick)
		if(11 to 51)
			affected_mob.Sleeping(13.34 * normalise_creation_purity() * metabolization_ratio * seconds_per_tick)
		if(52 to INFINITY)
			affected_mob.Sleeping(13.34 * normalise_creation_purity() * metabolization_ratio * seconds_per_tick)
			if(affected_mob.adjust_tox_loss(0.34 * (current_cycle - 51) * normalise_creation_purity() * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype))
				return UPDATE_MOB_HEALTH

/datum/reagent/toxin/fakebeer //disguised as normal beer for use by emagged brobots
	name = "B33r-卑酉"
	description = "一种伪装成啤酒的特制镇静剂。它能立即让目标陷入睡眠。"
	color = "#664300" // rgb: 102, 67, 0
	metabolization_rate = 1.5 * REAGENTS_METABOLISM
	taste_description = "piss water"
	ph = 2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/glass_style/drinking_glass/fakebeer
	required_drink_type = /datum/reagent/toxin/fakebeer

/datum/glass_style/drinking_glass/fakebeer/New()
	. = ..()
	// Copy styles from the beer drinking glass datum
	var/datum/glass_style/copy_from = /datum/glass_style/drinking_glass/beer
	name = initial(copy_from.name)
	desc = initial(copy_from.desc)
	icon = initial(copy_from.icon)
	icon_state = initial(copy_from.icon_state)

/datum/reagent/toxin/fakebeer/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	switch(current_cycle)
		if(2 to 51)
			affected_mob.Sleeping(13.34 * metabolization_ratio * seconds_per_tick)
		if(52 to INFINITY)
			affected_mob.Sleeping(13.34 * metabolization_ratio * seconds_per_tick)
			if(affected_mob.adjust_tox_loss(0.34 * (current_cycle - 50) * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype))
				return UPDATE_MOB_HEALTH

/datum/reagent/toxin/coffeepowder
	name = "Coffee Grounds-咖啡渣"
	description = "研磨精细的咖啡豆，用于制作咖啡。"
	color = "#5B2E0D" // rgb: 91, 46, 13
	toxpwr = 0.5
	ph = 4.2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	metabolized_traits = list(TRAIT_STIMULATED)

/datum/reagent/toxin/teapowder
	name = "Ground Tea Leaves-碎茶叶"
	description = "切碎的茶叶，用于泡茶。"
	color = "#7F8400" // rgb: 127, 132, 0
	toxpwr = 0.1
	taste_description = "green tea"
	ph = 4.9
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	metabolized_traits = list(TRAIT_STIMULATED)

/datum/reagent/toxin/mushroom_powder
	name = "Mushroom Powder-蘑菇粉"
	description = "研磨精细的多孔菌蘑菇，准备在水中浸泡以制作蘑菇茶。"
	color = "#67423A" // rgb: 127, 132, 0
	toxpwr = 0.1
	taste_description = "mushrooms"
	ph = 8.0
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/toxin/mutetoxin //the new zombie powder.
	name = "Mute Toxin-失语毒素"
	description = "一种非致命毒药，能抑制受害者的言语能力。"
	silent_toxin = TRUE
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	color = "#F0F8FF" // rgb: 240, 248, 255
	toxpwr = 0
	taste_description = "silence"
	ph = 12.2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/toxin/mutetoxin/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	// Gain approximately 12 seconds * creation purity seconds of silence every metabolism tick.
	affected_mob.set_silence_if_lower(3 SECONDS * metabolization_ratio * normalise_creation_purity() * seconds_per_tick)

/datum/reagent/toxin/staminatoxin
	name = "Tirizene-脱力剂"
	description = "一种非致命毒药，会导致受害者极度疲劳和虚弱。"
	silent_toxin = TRUE
	color = "#6E2828"
	data = 15
	toxpwr = 0
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/toxin/staminatoxin/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(affected_mob.adjust_stamina_loss(0.5 * data * metabolization_ratio * seconds_per_tick, updating_stamina = FALSE))
		. = UPDATE_MOB_HEALTH
	data = max(data - 1, 3)

/datum/reagent/toxin/polonium
	name = "Polonium-钋"
	description = "一种液态的强放射性物质。摄入会导致致命的辐射伤害。"
	color = "#787878"
	metabolization_rate = 0.125 * REAGENTS_METABOLISM
	toxpwr = 0
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	/// How radioactive is this reagent
	var/rad_power = 3

/datum/reagent/toxin/polonium/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(!HAS_TRAIT(affected_mob, TRAIT_IRRADIATED) && SSradiation.can_irradiate_basic(affected_mob))
		var/chance = min(volume / (20 - rad_power * 5), rad_power)
		if(SPT_PROB(chance, seconds_per_tick)) // ignore rad protection calculations bc it's inside of us
			affected_mob.AddComponent(/datum/component/irradiated)
	else
		if(affected_mob.adjust_tox_loss(4 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype))
			return UPDATE_MOB_HEALTH

/datum/reagent/toxin/polonium/expose_obj(obj/exposed_obj, reac_volume, methods=TOUCH, show_message=TRUE)
	. = ..()

	if(!SSradiation.can_irradiate_basic(exposed_obj))
		return

	radiation_pulse(
		source = exposed_obj,
		max_range = 0,
		threshold = RAD_VERY_LIGHT_INSULATION,
		chance = (min(reac_volume * rad_power, CALCULATE_RAD_MAX_CHANCE(rad_power))),
	)

/datum/reagent/toxin/polonium/expose_mob(mob/living/exposed_mob, methods, reac_volume)
	. = ..()

	if(!SSradiation.can_irradiate_basic(exposed_mob))
		return

	if(ishuman(exposed_mob) && SSradiation.wearing_rad_protected_clothing(exposed_mob))
		return

	if(!(methods & (TOUCH|VAPOR)))
		return

	radiation_pulse(
		source = exposed_mob,
		max_range = 0,
		threshold = RAD_VERY_LIGHT_INSULATION,
		chance = (min(reac_volume * rad_power, CALCULATE_RAD_MAX_CHANCE(rad_power))),
	)

/datum/reagent/toxin/histamine
	name = "Histamine-组胺"
	description = "组胺的效果根据剂量大小而变得更加危险，范围从轻微恼人到极其致命。"
	silent_toxin = TRUE
	color = "#FA6464"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	overdose_threshold = 30
	toxpwr = 0
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/toxin/histamine/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(SPT_PROB(30, seconds_per_tick))
		switch(pick(1, 2, 3, 4))
			if(1)
				to_chat(affected_mob, span_danger("你几乎看不见了！"))
				affected_mob.set_eye_blur_if_lower(6 SECONDS)
			if(2)
				affected_mob.emote("cough")
			if(3)
				affected_mob.emote("sneeze")
			if(4)
				if(prob(75))
					to_chat(affected_mob, span_danger("你抓挠着一处痒处。"))
					if(affected_mob.adjust_brute_loss(4 * metabolization_ratio, updating_health = FALSE, required_bodytype = affected_bodytype))
						return UPDATE_MOB_HEALTH

/datum/reagent/toxin/histamine/overdose_process(mob/living/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/heal = 4 * metabolization_ratio * seconds_per_tick
	var/need_mob_update
	need_mob_update = affected_mob.adjust_oxy_loss(heal, updating_health = FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type)
	need_mob_update += affected_mob.adjust_brute_loss(heal, updating_health = FALSE, required_bodytype = affected_bodytype)
	need_mob_update += affected_mob.adjust_tox_loss(heal, updating_health = FALSE, required_biotype = affected_biotype)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/toxin/formaldehyde
	name = "Formaldehyde-甲醛"
	description = "A fairly weak toxin that helps prevent organ decay in dead bodies. \
		It will slowly decay into Histamine over time."
	silent_toxin = TRUE
	color = "#B4004B"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	toxpwr = 1
	ph = 2.0
	inverse_chem = /datum/reagent/impurity/methanol
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/toxin/formaldehyde/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	var/obj/item/organ/liver/liver = affected_mob.get_organ_slot(ORGAN_SLOT_LIVER)
	if(liver && HAS_TRAIT(liver, TRAIT_CORONER_METABOLISM)) //mmmm, the forbidden pickle juice
		if(affected_mob.adjust_tox_loss(-1 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype)) //it counteracts its own toxin damage.
			return UPDATE_MOB_HEALTH
		return
	else if(SPT_PROB(2.5, seconds_per_tick))
		holder.add_reagent(/datum/reagent/toxin/histamine, pick(5,15))
		holder.remove_reagent(/datum/reagent/toxin/formaldehyde, 2.4 * metabolization_ratio * seconds_per_tick)
	return ..()

/datum/reagent/toxin/venom
	name = "Venom-毒液"
	description = "一种从剧毒动物中提取的异域毒药。根据剂量造成不同程度的毒素伤害和瘀伤。通常会衰变成组胺。"
	color = "#F0FFF0"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	toxpwr = 0
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	///Mob Size of the current mob sprite.
	var/current_size = RESIZE_DEFAULT_SIZE

/datum/reagent/toxin/venom/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	var/newsize = 1.1 * RESIZE_DEFAULT_SIZE
	affected_mob.update_transform(newsize/current_size)
	current_size = newsize
	toxpwr = 0.1 * volume

	if(affected_mob.adjust_brute_loss(2 * (0.3 * volume) * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype))
		. = UPDATE_MOB_HEALTH

	// chance to either decay into histamine or go the normal route of toxin metabolization
	if(SPT_PROB(8, seconds_per_tick))
		holder.add_reagent(/datum/reagent/toxin/histamine, pick(5, 10))
		holder.remove_reagent(/datum/reagent/toxin/venom, 1.1)
	else
		return ..() || .

/datum/reagent/toxin/venom/on_mob_end_metabolize(mob/living/affected_mob)
	. = ..()
	affected_mob.update_transform(RESIZE_DEFAULT_SIZE/current_size)
	current_size = RESIZE_DEFAULT_SIZE

/datum/reagent/toxin/fentanyl
	name = "Fentanyl-芬太尼"
	description = "抑制大脑功能并造成毒素伤害，最终使病人昏迷。"
	color = "#64916E"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	toxpwr = 0
	ph = 9
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	addiction_types = list(/datum/addiction/opioids = 25)

/datum/reagent/toxin/fentanyl/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/need_mob_update
	need_mob_update = affected_mob.adjust_organ_loss(ORGAN_SLOT_BRAIN, 3 * metabolization_ratio * normalise_creation_purity() * seconds_per_tick, 150)
	if(affected_mob.toxloss <= 60)
		need_mob_update += affected_mob.adjust_tox_loss(1 * metabolization_ratio * normalise_creation_purity() * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype)
	if(current_cycle > 4)
		affected_mob.add_mood_event("smacked out", /datum/mood_event/narcotic_heavy, name)
	if(current_cycle > 18)
		affected_mob.Sleeping(40 * metabolization_ratio * normalise_creation_purity() * seconds_per_tick)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/toxin/cyanide
	name = "Cyanide-氰化物"
	description = "一种因其在暗杀中的使用而臭名昭著的毒药。造成少量毒素伤害，并有小概率造成氧气伤害或击晕。"
	color = "#00B4FF"
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	metabolization_rate = 0.125 * REAGENTS_METABOLISM
	toxpwr = 1.25
	ph = 9.3
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/toxin/cyanide/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/need_mob_update = FALSE
	if(SPT_PROB(2.5, seconds_per_tick))
		affected_mob.losebreath += 1
		need_mob_update = TRUE
	if(SPT_PROB(4, seconds_per_tick))
		to_chat(affected_mob, span_danger("你感到极度虚弱！"))
		affected_mob.Stun(40)
		need_mob_update += affected_mob.adjust_tox_loss(8 * normalise_creation_purity() * metabolization_ratio, updating_health = FALSE, required_biotype = affected_biotype)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/toxin/bad_food
	name = "Bad Food-坏食物"
	description = "某种烹饪怪物的产物，食物糟糕到有毒。"
	color = "#d6d6d8"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	toxpwr = 0.5
	taste_description = "bad cooking"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/toxin/itching_powder
	name = "Itching Powder-痒粉"
	description = "一种接触皮肤会引起瘙痒的粉末。导致受害者抓挠痒处，并有极低概率降解为组胺。"
	silent_toxin = TRUE
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	color = "#C8C8C8"
	metabolization_rate = 0.4 * REAGENTS_METABOLISM
	toxpwr = 0
	ph = 7
	penetrates_skin = TOUCH|VAPOR
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/toxin/itching_powder/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	var/scratched = FALSE
	var/scratch_damage = 0.25 * metabolization_ratio
	var/obj/item/bodypart/head = affected_mob.get_bodypart(BODY_ZONE_HEAD)
	if(!isnull(head) && SPT_PROB(8, seconds_per_tick))
		scratched = affected_mob.itch(damage = scratch_damage, target_part = head)

	var/obj/item/bodypart/leg = affected_mob.get_bodypart(pick(BODY_ZONE_L_LEG,BODY_ZONE_R_LEG))
	if(!isnull(leg) && SPT_PROB(8, seconds_per_tick))
		scratched = affected_mob.itch(damage = scratch_damage, target_part = leg, silent = scratched) || scratched

	var/obj/item/bodypart/arm = affected_mob.get_bodypart(pick(BODY_ZONE_L_ARM,BODY_ZONE_R_ARM))
	if(!isnull(arm) && SPT_PROB(8, seconds_per_tick))
		scratched = affected_mob.itch(damage = scratch_damage, target_part = arm, silent = scratched) || scratched

	if(SPT_PROB(1.5, seconds_per_tick))
		holder.add_reagent(/datum/reagent/toxin/histamine,rand(1,3))
		holder.remove_reagent(/datum/reagent/toxin/itching_powder, 1.2)
		return
	else
		return ..() || .

/datum/reagent/toxin/initropidril
	name = "Initropidril-心急停"
	description = "一种具有隐伏效应的强效毒药。可导致眩晕、致命的呼吸衰竭和心脏骤停。"
	silent_toxin = TRUE
	color = "#7F10C0"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	toxpwr = 2.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/toxin/initropidril/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(!SPT_PROB(13, seconds_per_tick))
		return
	var/picked_option = rand(1,3)
	var/need_mob_update
	switch(picked_option)
		if(1)
			affected_mob.Paralyze(60)
		if(2)
			affected_mob.losebreath += 10
			affected_mob.adjust_oxy_loss(2 * rand(5,25) * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type)
			need_mob_update = TRUE
		if(3)
			if(!affected_mob.undergoing_cardiac_arrest() && affected_mob.can_heartattack())
				affected_mob.set_heartattack(TRUE)
				if(affected_mob.stat == CONSCIOUS)
					affected_mob.visible_message(span_userdanger("[affected_mob] 紧抓着 [affected_mob.p_their()] 胸口，仿佛 [affected_mob.p_their()] 心脏停止了跳动！"))
			else
				affected_mob.losebreath += 10
				need_mob_update = affected_mob.adjust_oxy_loss(rand(5,25), updating_health = FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/toxin/pancuronium
	name = "Pancuronium-泮库溴铵"
	description = "一种难以察觉的毒素，能迅速使受害者丧失行动能力。也可能导致呼吸衰竭。"
	silent_toxin = TRUE
	color = "#195096"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	toxpwr = 0
	taste_mult = 0 // undetectable, I guess?
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/toxin/pancuronium/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(current_cycle > 10)
		affected_mob.Stun(80 * metabolization_ratio * seconds_per_tick)
	if(SPT_PROB(10, seconds_per_tick))
		affected_mob.losebreath += 4
		return UPDATE_MOB_HEALTH

/datum/reagent/toxin/sodium_thiopental
	name = "Sodium Thiopental-硫喷妥钠"
	description = "硫喷妥钠会导致目标严重虚弱并失去意识。"
	silent_toxin = TRUE
	color = LIGHT_COLOR_BLUE
	metabolization_rate = 0.75 * REAGENTS_METABOLISM
	toxpwr = 0
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	added_traits = list(TRAIT_ANTICONVULSANT)

/datum/reagent/toxin/sodium_thiopental/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(current_cycle > 10)
		affected_mob.Sleeping(26.67 * metabolization_ratio * seconds_per_tick)
	if(affected_mob.adjust_stamina_loss(0.67 * metabolization_ratio * seconds_per_tick, updating_stamina = FALSE))
		return UPDATE_MOB_HEALTH

/datum/reagent/toxin/sulfonal
	name = "Sulfonal-磺醛"
	description = "一种隐秘的毒药，造成轻微毒素伤害并最终使目标陷入沉睡。"
	silent_toxin = TRUE
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	color = "#7DC3A0"
	metabolization_rate = 0.125 * REAGENTS_METABOLISM
	toxpwr = 0.5
	ph = 6
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/toxin/sulfonal/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(current_cycle > 22)
		affected_mob.Sleeping(160 * normalise_creation_purity() * metabolization_ratio * seconds_per_tick)

/datum/reagent/toxin/amanitin
	name = "Amanitin-鹅膏菌素"
	description = "一种非常强效的延迟性毒素。完全代谢后，将根据其在受害者血液中存在的时间造成大量毒素伤害。"
	silent_toxin = TRUE
	color = COLOR_WHITE
	toxpwr = 0
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	var/delayed_toxin_damage = 0

/datum/reagent/toxin/amanitin/on_mob_life(mob/living/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	delayed_toxin_damage += 6 * metabolization_ratio * seconds_per_tick

/datum/reagent/toxin/amanitin/on_mob_delete(mob/living/affected_mob)
	. = ..()
	affected_mob.log_message("has taken [delayed_toxin_damage] toxin damage from amanitin toxin", LOG_ATTACK)
	affected_mob.adjust_tox_loss(delayed_toxin_damage, required_biotype = affected_biotype)

/datum/reagent/toxin/lipolicide
	name = "Lipolicide-杀脂剂"
	description = "一种强效毒素，会破坏脂肪细胞，在短时间内大幅降低体重。对体内没有营养物的人是致命的。"
	silent_toxin = TRUE
	taste_description = "mothballs"
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	color = "#F0FFF0"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	toxpwr = 0
	ph = 6
	inverse_chem = /datum/reagent/impurity/ipecacide
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/toxin/lipolicide/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(affected_mob.nutrition <= NUTRITION_LEVEL_STARVING)
		if(affected_mob.adjust_tox_loss(1 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype))
			. = UPDATE_MOB_HEALTH
	affected_mob.adjust_nutrition(-3 * normalise_creation_purity() * metabolization_ratio * seconds_per_tick) // making the chef more valuable, one meme trap at a time
	affected_mob.overeatduration = 0

/datum/reagent/toxin/coniine
	name = "Coniine-毒芹碱"
	description = "毒芹碱代谢极慢，但会造成大量毒素伤害并停止呼吸。"
	color = "#7DC3A0"
	metabolization_rate = 0.06 * REAGENTS_METABOLISM
	toxpwr = 1.75
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/toxin/coniine/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(affected_mob.losebreath < 5)
		affected_mob.losebreath = min(affected_mob.losebreath + 41.67 * metabolization_ratio * seconds_per_tick, 5)
		return UPDATE_MOB_HEALTH

/datum/reagent/toxin/spewium
	name = "Spewium-喷吐素"
	description = "一种强效催吐剂，引起无法控制的呕吐。高剂量可能导致呕吐出器官。"
	color = "#2f6617" //A sickly green color
	overdose_threshold = 29
	toxpwr = 0
	taste_description = "vomit"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/toxin/spewium/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(current_cycle > 11 && SPT_PROB(min(31, current_cycle), seconds_per_tick))
		affected_mob.vomit(10, prob(10), prob(50), rand(0,4), TRUE)
		var/constructed_flags = (MOB_VOMIT_MESSAGE | MOB_VOMIT_HARM)
		if(prob(10))
			constructed_flags |= MOB_VOMIT_BLOOD
		if(prob(50))
			constructed_flags |= MOB_VOMIT_STUN
		affected_mob.vomit(vomit_flags = constructed_flags, distance = rand(0,4))
		for(var/datum/reagent/toxin/reagent in affected_mob.reagents.reagent_list)
			if(reagent != src)
				affected_mob.reagents.remove_reagent(reagent.type, 0.5 * reagent.purge_multiplier * metabolization_ratio * seconds_per_tick)

/datum/reagent/toxin/spewium/overdose_process(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(current_cycle > 33 && SPT_PROB(7.5, seconds_per_tick))
		affected_mob.spew_organ()
		affected_mob.vomit(VOMIT_CATEGORY_BLOOD, lost_nutrition = 0, distance = 4)
		to_chat(affected_mob, span_userdanger("你呕吐时感觉有块状物涌了上来。"))

/datum/reagent/toxin/curare
	name = "Curare-箭毒"
	description = "造成轻微毒素伤害，随后是连锁眩晕和缺氧伤害。"
	color = "#191919"
	metabolization_rate = 0.125 * REAGENTS_METABOLISM
	toxpwr = 1
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/toxin/curare/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(current_cycle > 11)
		affected_mob.Paralyze(240 * metabolization_ratio * seconds_per_tick)
	if(affected_mob.adjust_oxy_loss(2 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type))
		return UPDATE_MOB_HEALTH

/datum/reagent/toxin/heparin //Based on a real-life anticoagulant. I'm not a doctor, so this won't be realistic.
	name = "Heparin-肝素"
	description = "A powerful anticoagulant. All open cut wounds on the patient will open up and bleed much faster. \
		Counters coagulants like Sanguirite, purging them."
	silent_toxin = TRUE
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	color = "#C8C8C8" //RGB: 200, 200, 200
	metabolization_rate = 0.2 * REAGENTS_METABOLISM
	toxpwr = 0
	ph = 11.6
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	metabolized_traits = list(TRAIT_BLOOD_FOUNTAIN)

/datum/reagent/toxin/heparin/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	if(holder.has_reagent(/datum/reagent/medicine/coagulant)) //Directly purges coagulants from the system. Get rid of the heparin BEFORE attempting to use coagulants.
		holder.remove_reagent(/datum/reagent/medicine/coagulant, 5 * metabolization_ratio * seconds_per_tick)
	return ..()

/datum/reagent/toxin/rotatium //Rotatium. Fucks up your rotation and is hilarious
	name = "Rotatium-旋转剂"
	description = "一种不断旋转、颜色奇异的流体。会导致患者的方向感和手眼协调能力变得混乱。"
	silent_toxin = TRUE
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	color = "#AC88CA" //RGB: 172, 136, 202
	metabolization_rate = 0.6 * REAGENTS_METABOLISM
	toxpwr = 0.5
	ph = 6.2
	taste_description = "spinning"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/toxin/rotatium/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(!affected_mob.hud_used || (current_cycle < 20 || (current_cycle % 20) == 0))
		return
	var/atom/movable/plane_master_controller/pm_controller = affected_mob.hud_used.plane_master_controllers[PLANE_MASTERS_GAME]

	var/rotation = min(round(current_cycle/20), 89) // By this point the player is probably puking and quitting anyway
	for(var/atom/movable/screen/plane_master/plane as anything in pm_controller.get_planes())
		animate(plane, transform = matrix(rotation, MATRIX_ROTATE), time = 5, easing = QUAD_EASING, loop = -1)
		animate(transform = matrix(-rotation, MATRIX_ROTATE), time = 5, easing = QUAD_EASING)

/datum/reagent/toxin/rotatium/on_mob_end_metabolize(mob/living/affected_mob)
	. = ..()
	if(affected_mob?.hud_used)
		var/atom/movable/plane_master_controller/pm_controller = affected_mob.hud_used.plane_master_controllers[PLANE_MASTERS_GAME]
		for(var/atom/movable/screen/plane_master/plane as anything in pm_controller.get_planes())
			animate(plane, transform = matrix(), time = 5, easing = QUAD_EASING)

/datum/reagent/toxin/anacea
	name = "Anacea-天竺葵素"
	description = "一种能快速清除药物且代谢极慢的毒素。"
	color = "#3C5133"
	metabolization_rate = 0.08 * REAGENTS_METABOLISM
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	toxpwr = 0.15
	ph = 8
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/toxin/anacea/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	var/remove_amt = 5
	if(holder.has_reagent(/datum/reagent/medicine/calomel) || holder.has_reagent(/datum/reagent/medicine/pen_acid))
		remove_amt = 0.5
	. = ..()
	for(var/datum/reagent/medicine/reagent in affected_mob.reagents.reagent_list)
		reagent.volume -= 6.25 * remove_amt * reagent.purge_multiplier * normalise_creation_purity() * metabolization_ratio * seconds_per_tick
	affected_mob.reagents.update_total()

//ACID

/datum/reagent/toxin/acid
	name = "Sulfuric Acid-硫酸"
	description = "一种分子式为H2SO4的强矿物酸。"
	color = "#00FF32"
	toxpwr = 1
	taste_description = "acid"
	self_consuming = TRUE
	ph = 2.75
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	var/acidpwr = 10 //the amount of protection removed from the armour

// ...Why? I mean, clearly someone had to have done this and thought, well,
// acid doesn't hurt plants, but what brought us here, to this point?
/datum/reagent/toxin/acid/on_hydroponics_apply(obj/machinery/hydroponics/mytray, mob/user)
	mytray.adjust_plant_health(-round(volume))
	mytray.adjust_toxic(round(volume * 1.5))
	mytray.adjust_weedlevel(-rand(1,2))

/datum/reagent/toxin/acid/expose_mob(mob/living/carbon/exposed_carbon, methods=TOUCH, reac_volume)
	. = ..()
	if(!istype(exposed_carbon))
		return
	var/obj/item/organ/liver/liver = exposed_carbon.get_organ_slot(ORGAN_SLOT_LIVER)
	if(liver && HAS_TRAIT(liver, TRAIT_HUMAN_AI_METABOLISM))
		return
	reac_volume = round(reac_volume,0.1)
	if(methods & (INGEST|INHALE))
		exposed_carbon.adjust_brute_loss(min(6*toxpwr, reac_volume * toxpwr), required_bodytype = affected_bodytype)
		return
	if(methods & INJECT)
		exposed_carbon.adjust_brute_loss(1.5 * min(6*toxpwr, reac_volume * toxpwr), required_bodytype = affected_bodytype)
		return
	exposed_carbon.acid_act(acidpwr, reac_volume)

/datum/reagent/toxin/acid/expose_obj(obj/exposed_obj, reac_volume, methods=TOUCH, show_message=TRUE)
	. = ..()
	if(ismob(exposed_obj.loc)) //handled in human acid_act()
		return
	reac_volume = round(reac_volume,0.1)
	exposed_obj.acid_act(acidpwr, reac_volume)

/datum/reagent/toxin/acid/expose_turf(turf/exposed_turf, reac_volume)
	. = ..()
	if (!istype(exposed_turf))
		return
	reac_volume = round(reac_volume,0.1)
	exposed_turf.acid_act(acidpwr, reac_volume)

/datum/reagent/toxin/acid/fluacid
	name = "Fluorosulfuric Acid-氟硫酸"
	description = "一种极具腐蚀性的化学物质。"
	color = "#5050FF"
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	toxpwr = 2
	acidpwr = 42.0
	ph = 0.0
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

// SERIOUSLY
/datum/reagent/toxin/acid/fluacid/on_hydroponics_apply(obj/machinery/hydroponics/mytray, mob/user)
	mytray.adjust_plant_health(-round(volume * 2))
	mytray.adjust_toxic(round(volume * 3))
	mytray.adjust_weedlevel(-rand(1,4))

/datum/reagent/toxin/acid/fluacid/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(affected_mob.adjust_fire_loss(0.5 * ((current_cycle-1)/15) * metabolization_ratio * normalise_creation_purity() * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype))
		return UPDATE_MOB_HEALTH

/datum/reagent/toxin/acid/nitracid
	name = "Nitric Acid-硝酸"
	description = "一种极具腐蚀性的化学物质，会与活体有机组织发生剧烈反应。"
	color = "#5050FF"
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	toxpwr = 3
	acidpwr = 5.0
	ph = 1.3
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/toxin/acid/nitracid/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(affected_mob.adjust_fire_loss(0.5 * (volume/10) * metabolization_ratio * normalise_creation_purity() * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)) //here you go nervar
		return UPDATE_MOB_HEALTH

/datum/reagent/toxin/delayed
	name = "Toxin Microcapsules-毒素微囊"
	description = "在短暂的不活动期后会造成严重的毒素伤害。"
	metabolization_rate = 0 //stays in the system until active.
	toxpwr = 0
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/toxin/delayed/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(current_cycle <= 31)
		return
	if(holder)
		holder.remove_reagent(type, REAGENTS_METABOLISM * affected_mob.metabolism_efficiency * seconds_per_tick)
	if(affected_mob.adjust_tox_loss(0.5 * 5 * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype))
		. = UPDATE_MOB_HEALTH
	if(SPT_PROB(5, seconds_per_tick))
		affected_mob.Paralyze(20)

/datum/reagent/toxin/mimesbane
	name = "Mime's Bane-灭默剂"
	description = "一种非致命的神经毒素，会干扰受害者的手势表达能力。"
	silent_toxin = TRUE
	color = "#F0F8FF" // rgb: 240, 248, 255
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	toxpwr = 0
	ph = 1.7
	taste_description = "stillness"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	metabolized_traits = list(TRAIT_EMOTEMUTE)

/datum/reagent/toxin/bonehurtingjuice //oof ouch
	name = "Bone Hurting Juice-骨痛汁"
	description = "一种看起来很像水的奇怪物质。喝下它的诱惑力出奇地大。哎哟好痛。"
	silent_toxin = TRUE //no point spamming them even more.
	color = "#AAAAAA77" //RGBA: 170, 170, 170, 77
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	toxpwr = 0
	ph = 3.1
	taste_description = "bone hurting"
	overdose_threshold = 50
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/toxin/bonehurtingjuice/on_mob_add(mob/living/carbon/affected_mob)
	. = ..()
	affected_mob.say("oof ouch my bones", forced = /datum/reagent/toxin/bonehurtingjuice)

/datum/reagent/toxin/bonehurtingjuice/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(affected_mob.adjust_stamina_loss(3.25 * metabolization_ratio * seconds_per_tick, updating_stamina = FALSE))
		. = UPDATE_MOB_HEALTH
	if(!SPT_PROB(10, seconds_per_tick))
		return
	switch(rand(1, 3))
		if(1)
			affected_mob.say(pick("oof.", "ouch.", "my bones.", "oof ouch.", "oof ouch my bones."), forced = /datum/reagent/toxin/bonehurtingjuice)
		if(2)
			affected_mob.manual_emote(pick("oofs silently.", "looks like [affected_mob.p_their()] bones hurt.", "grimaces, as though [affected_mob.p_their()] bones hurt."))
		if(3)
			to_chat(affected_mob, span_warning("你的骨头好痛！"))

/datum/reagent/toxin/bonehurtingjuice/overdose_process(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(SPT_PROB(2, seconds_per_tick) && iscarbon(affected_mob)) //big oof
		var/selected_part = pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG) //God help you if the same limb gets picked twice quickly.
		var/obj/item/bodypart/BP = affected_mob.get_bodypart(selected_part)
		if(BP)
			playsound(affected_mob, SFX_DESECRATION, 50, TRUE, -1)
			affected_mob.visible_message(span_warning("[affected_mob] 的骨头痛得受不了！！"), span_danger("你的骨头痛得受不了！！"))
			affected_mob.say("OOF!!", forced = type)
			affected_mob.apply_damage(20, BRUTE, BP, wound_bonus = rand(30, 130))

		else //SUCH A LUST FOR REVENGE!!!
			to_chat(affected_mob, span_warning("幻肢在痛！"))
			affected_mob.say("Why are we still here, just to suffer?", forced = type)

/datum/reagent/toxin/bonehurtingjuice/used_on_fish(obj/item/fish/fish)
	if(HAS_TRAIT(fish, TRAIT_FISH_MADE_OF_BONE))
		fish.damage_fish(30)
		return TRUE

/datum/reagent/toxin/bungotoxin
	name = "Bungotoxin-巴古毒"
	description = "一种可怕的心脏毒素，用于保护不起眼的邦戈果核。"
	silent_toxin = TRUE
	color = "#EBFF8E"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	toxpwr = 0
	taste_description = "tannin"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/toxin/bungotoxin/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(affected_mob.adjust_organ_loss(ORGAN_SLOT_HEART, 3 * metabolization_ratio * seconds_per_tick))
		. = UPDATE_MOB_HEALTH

	// If our mob's currently dizzy from anything else, we will also gain confusion
	var/mob_dizziness = affected_mob.get_timed_status_effect_duration(/datum/status_effect/dizziness)
	if(mob_dizziness > 0)
		// Gain confusion equal to about half the duration of our current dizziness
		affected_mob.set_confusion(mob_dizziness / 2)

	if(current_cycle >= 13 && SPT_PROB(4, seconds_per_tick))
		var/tox_message = pick("You feel your heart spasm in your chest.", "You feel faint.","You feel you need to catch your breath.","You feel a prickle of pain in your chest.")
		to_chat(affected_mob, span_notice("[tox_message]"))

/datum/reagent/toxin/leadacetate
	name = "Lead Acetate-醋酸铅"
	description = "数百年前曾被用作甜味剂，后来人们才发现它剧毒无比。"
	color = "#2b2b2b" // rgb: 127, 132, 0
	toxpwr = 0.5
	taste_mult = 1.3
	taste_description = "sugary sweetness"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/toxin/leadacetate/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/need_mob_update
	need_mob_update = affected_mob.adjust_organ_loss(ORGAN_SLOT_EARS, 0.5 * metabolization_ratio * seconds_per_tick)
	need_mob_update += affected_mob.adjust_organ_loss(ORGAN_SLOT_BRAIN, 0.5 * metabolization_ratio * seconds_per_tick)
	if(need_mob_update)
		. = UPDATE_MOB_HEALTH
	if(SPT_PROB(0.5, seconds_per_tick))
		to_chat(affected_mob, span_notice("啊，那是什么？你好像听到了什么……"))
		affected_mob.adjust_confusion(5 SECONDS)

/datum/reagent/toxin/hunterspider
	name = "Spider Toxin-蜘蛛毒素"
	description = "蜘蛛为削弱猎物而产生的一种有毒化学物质。"
	health_required = 40
	liver_damage_multiplier = 0

/datum/reagent/toxin/viperspider
	name = "Viper Spider Toxin-蝰蛇蛛毒素"
	toxpwr = 5
	description = "由罕见的毒蛇蜘蛛产生的剧毒化学物质。能使猎物濒临死亡并引发幻觉。"
	health_required = 10
	liver_damage_multiplier = 0

/datum/reagent/toxin/viperspider/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.adjust_hallucinations(5 SECONDS * metabolization_ratio * seconds_per_tick)

/datum/reagent/toxin/tetrodotoxin
	name = "河豚毒素"
	description = "一种无色、无味、无嗅的神经毒素，通常存在于四齿鲀目动物的肝脏中。"
	silent_toxin = TRUE
	color = COLOR_VERY_LIGHT_GRAY
	metabolization_rate = 0.1 * REAGENTS_METABOLISM
	liver_tolerance_multiplier = 0.1
	liver_damage_multiplier = 1.25
	purge_multiplier = 0.15
	toxpwr = 0
	taste_mult = 0
	chemical_flags = REAGENT_NO_RANDOM_RECIPE|REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	var/list/traits_not_applied = list(
		TRAIT_PARALYSIS_L_ARM = BODY_ZONE_L_ARM,
		TRAIT_PARALYSIS_R_ARM = BODY_ZONE_R_ARM,
		TRAIT_PARALYSIS_L_LEG = BODY_ZONE_L_LEG,
		TRAIT_PARALYSIS_R_LEG = BODY_ZONE_R_LEG,
	)

/datum/reagent/toxin/tetrodotoxin/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/need_mob_update
	if(HAS_TRAIT(affected_mob, TRAIT_TETRODOTOXIN_HEALING))
		toxpwr = 0
		liver_tolerance_multiplier = 0
		silent_toxin = TRUE
		remove_paralysis(affected_mob)
		need_mob_update += affected_mob.adjust_oxy_loss(-3.5 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type)
		need_mob_update = affected_mob.adjust_tox_loss(-3.25 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype)
		need_mob_update += affected_mob.adjust_brute_loss(-6 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
		need_mob_update += affected_mob.adjust_fire_loss(-6.75 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
		return need_mob_update ? UPDATE_MOB_HEALTH : .

	liver_tolerance_multiplier = initial(liver_tolerance_multiplier)

	//be ready for a cocktail of symptoms, including:
	//numbness, nausea, vomit, breath loss, weakness, paralysis and nerve damage/impairment and eventually a heart attack if enough time passes.
	switch(current_cycle)
		if(7 to 13)
			if(SPT_PROB(20, seconds_per_tick))
				affected_mob.set_jitter_if_lower(5 * rand(2 SECONDS, 3 SECONDS) * metabolization_ratio)
			if(SPT_PROB(5, seconds_per_tick))
				var/obj/item/organ/tongue/tongue = affected_mob.get_organ_slot(ORGAN_SLOT_TONGUE)
				if(tongue)
					to_chat(affected_mob, span_warning("你的 [tongue.name] 感觉麻木了……"))
				affected_mob.set_slurring_if_lower(25 SECONDS * metabolization_ratio)
			affected_mob.adjust_disgust(17.5 * metabolization_ratio * seconds_per_tick)
		if(13 to 21)
			silent_toxin = FALSE
			toxpwr = 0.5
			need_mob_update = affected_mob.adjust_stamina_loss(12.5 * metabolization_ratio * seconds_per_tick, updating_stamina = FALSE)
			if(SPT_PROB(20, seconds_per_tick))
				affected_mob.losebreath += 5 * metabolization_ratio
				need_mob_update = TRUE
			if(SPT_PROB(40, seconds_per_tick))
				affected_mob.set_jitter_if_lower(5 * rand(2 SECONDS, 3 SECONDS) * metabolization_ratio)
			affected_mob.adjust_disgust(15 * metabolization_ratio * seconds_per_tick)
			affected_mob.set_slurring_if_lower(5 SECONDS * metabolization_ratio * seconds_per_tick)
			affected_mob.adjust_stamina_loss(10 * metabolization_ratio * seconds_per_tick, updating_stamina = FALSE)
			if(SPT_PROB(4, seconds_per_tick))
				paralyze_limb(affected_mob)
				need_mob_update = TRUE
			if(SPT_PROB(10, seconds_per_tick))
				affected_mob.adjust_confusion(rand(6 SECONDS, 8 SECONDS))
		if(21 to 29)
			toxpwr = 1
			need_mob_update = affected_mob.adjust_organ_loss(ORGAN_SLOT_BRAIN, 0.5)
			need_mob_update = affected_mob.adjust_organ_loss(ORGAN_SLOT_LUNGS, 0.7)
			if(SPT_PROB(40, seconds_per_tick))
				affected_mob.losebreath += 10 * metabolization_ratio
				need_mob_update = TRUE
			affected_mob.adjust_disgust(15 * metabolization_ratio * seconds_per_tick)
			affected_mob.set_slurring_if_lower(15 SECONDS * metabolization_ratio * seconds_per_tick)
			if(SPT_PROB(5, seconds_per_tick))
				to_chat(affected_mob, span_danger("你感到极度虚弱。"))
			need_mob_update += affected_mob.adjust_stamina_loss(25 * metabolization_ratio * seconds_per_tick, updating_stamina = FALSE)
			if(SPT_PROB(8, seconds_per_tick))
				paralyze_limb(affected_mob)
				need_mob_update = TRUE
			if(SPT_PROB(10, seconds_per_tick))
				affected_mob.adjust_confusion(rand(6 SECONDS, 8 SECONDS))
		if(29 to INFINITY)
			toxpwr = 1.5
			need_mob_update = affected_mob.adjust_organ_loss(ORGAN_SLOT_BRAIN, 1, BRAIN_DAMAGE_DEATH)
			need_mob_update = affected_mob.adjust_organ_loss(ORGAN_SLOT_LUNGS, 1.4)
			affected_mob.set_silence_if_lower(15 SECONDS * metabolization_ratio * seconds_per_tick)
			need_mob_update += affected_mob.adjust_stamina_loss(25 * metabolization_ratio * seconds_per_tick, updating_stamina = FALSE)
			affected_mob.adjust_disgust(10 * metabolization_ratio * seconds_per_tick)
			if(SPT_PROB(15, seconds_per_tick))
				paralyze_limb(affected_mob)
				need_mob_update = TRUE
			if(SPT_PROB(20, seconds_per_tick))
				affected_mob.adjust_confusion(rand(6 SECONDS, 8 SECONDS))

	if(current_cycle > 38 && !length(traits_not_applied) && SPT_PROB(5, seconds_per_tick) && !affected_mob.undergoing_cardiac_arrest())
		affected_mob.set_heartattack(TRUE)
		to_chat(affected_mob, span_bolddanger("你感到一阵灼痛蔓延至整个胸腔！"))

	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/toxin/tetrodotoxin/proc/paralyze_limb(mob/living/affected_mob)
	if(!length(traits_not_applied))
		return
	var/added_trait = pick_n_take(traits_not_applied)
	ADD_TRAIT(affected_mob, added_trait, REF(src))

/datum/reagent/toxin/tetrodotoxin/on_mob_add(mob/living/affected_mob)
	. = ..()
	if(HAS_TRAIT(affected_mob, TRAIT_TETRODOTOXIN_HEALING))
		liver_tolerance_multiplier = 0

/datum/reagent/toxin/tetrodotoxin/on_mob_metabolize(mob/living/affected_mob)
	. = ..()
	RegisterSignal(affected_mob, COMSIG_CARBON_ATTEMPT_BREATHE, PROC_REF(block_breath))

/datum/reagent/toxin/tetrodotoxin/on_mob_end_metabolize(mob/living/affected_mob)
	. = ..()
	UnregisterSignal(affected_mob, COMSIG_CARBON_ATTEMPT_BREATHE, PROC_REF(block_breath))
	remove_paralysis(affected_mob)

/datum/reagent/toxin/tetrodotoxin/proc/remove_paralysis(mob/living/affected_mob)
	// the initial() proc doesn't work for lists.
	var/list/initial_list = list(
		TRAIT_PARALYSIS_L_ARM = BODY_ZONE_L_ARM,
		TRAIT_PARALYSIS_R_ARM = BODY_ZONE_R_ARM,
		TRAIT_PARALYSIS_L_LEG = BODY_ZONE_L_LEG,
		TRAIT_PARALYSIS_R_LEG = BODY_ZONE_R_LEG,
	)
	affected_mob.remove_traits(initial_list, REF(src))
	traits_not_applied = initial_list

/datum/reagent/toxin/tetrodotoxin/proc/block_breath(mob/living/source)
	SIGNAL_HANDLER
	if(current_cycle > 28 && !HAS_TRAIT(source, TRAIT_TETRODOTOXIN_HEALING))
		return COMSIG_CARBON_BLOCK_BREATH

/datum/reagent/toxin/gatfruit
	name = "植物毒素"
	description = "一种由稀有且难以捉摸的加特果植物产生的毒素。"
	liver_damage_multiplier = 0
	toxpwr = 1

#define CRITICAL_CAPACITY 45

/datum/reagent/toxin/acid/industrial_waste
	name = "Industrial Waste"
	description = "Industrial Waste produced as a side effect of efficient boulder refining. Highly toxic, corrosive, and hard to get rid of."
	color = "#1eff00"
	penetrates_skin = TOUCH|VAPOR
	creation_purity = REAGENT_STANDARD_PURITY
	purity = REAGENT_STANDARD_PURITY
	toxpwr = 2
	acidpwr = 30.0
	ph = 0.0

/datum/reagent/toxin/acid/industrial_waste/on_new(data)
	. = ..()
	if(istype(holder.my_atom, /obj/machinery/plumbing/disposer))
		RegisterSignal(holder, COMSIG_REAGENTS_HOLDER_UPDATED, PROC_REF(pre_disposal))

/datum/reagent/toxin/acid/industrial_waste/on_merge(list/mix_data, amount)
	. = ..()
	var/merged_total = amount + volume
	if(merged_total >= CRITICAL_CAPACITY)
		spew_waste(round(volume / WASTE_REACTION_THRESHOLD * 2)) //Sure as HELL can't store it.
		var/atom/container = holder.my_atom
		var/damage_mult = 1
		if(ismachinery(container))
			damage_mult = 2
		container.take_damage(round(merged_total * damage_mult / WASTE_REACTION_THRESHOLD), BURN, BIO) //It's an unusual combination of damage type and flags, but we need to intentionally bypass beakers acid immunity.


/datum/reagent/toxin/acid/industrial_waste/burn(datum/reagents/holder)
	. = ..()
	spew_waste(2) //Can't burn it...

/datum/reagent/toxin/acid/industrial_waste/on_spark_act(power_charge, spark_flags)
	if((spark_flags & SPARK_ACT_ENCLOSED) && !ismob(holder.my_atom))
		return
	spew_waste(2) //Can't electrify it...

/datum/reagent/toxin/acid/industrial_waste/expose_obj(obj/exposed_obj, reac_volume)
	if(reac_volume < WASTE_REACTION_THRESHOLD)
		return // There's too little waste to do anything.
	if(istype(exposed_obj, /obj/effect/decal/cleanable/greenglow/waste))
		var/obj/effect/decal/cleanable/greenglow/waste/goo = exposed_obj
		goo.visible_message(span_warning("The new waste reactivates [goo]!"))
		goo.pre_dissolve(FALSE)
	return ..()

/datum/reagent/toxin/acid/industrial_waste/expose_turf(turf/exposed_turf, reac_volume)
	var/obj/effect/decal/cleanable/greenglow/waste/goo = exposed_turf.spawn_unique_cleanable(/obj/effect/decal/cleanable/greenglow/waste) //Following similar logic to how ants spawn their cleanables.
	if(QDELETED(goo))
		return

	goo.decal_reagent = type
	var/rounded_volume = round(reac_volume, 1)
	goo.reagent_amount = rounded_volume

	if(goo.lazy_init_reagents())
		goo.reagents.maximum_volume = min(goo.reagents.maximum_volume + rounded_volume, 300)
		goo.reagents.add_reagent(type, rounded_volume)
	if(goo.reagents.has_reagent(type, WASTE_REACTION_THRESHOLD))
		goo.pre_dissolve()
		return // Otherwise there's too little waste to do anything.
	return ..()

/datum/reagent/toxin/acid/industrial_waste/proc/pre_disposal()
	SIGNAL_HANDLER
	var/atom/disaster_zone = holder?.my_atom
	if(!disaster_zone)
		return
	if(prob(10))
		disaster_zone.balloon_alert_to_viewers("hissssssss!")
	spew_waste(5) //You can't just dump the industrial waste down the kitchen sink. High range to disincentivize using the chem disposaler.

/**
 * Pick a random turf in the spew range and split our total amount of waste there.
 */
/datum/reagent/toxin/acid/industrial_waste/proc/spew_waste(spew_range = 1)
	if(!spew_range)
		return

	var/atom/atom_holder = holder.my_atom
	var/turf/dropturf = get_turf(atom_holder)
	if(!dropturf)
		return //Check for at least an inital turf to start
	var/obj/effect/particle_effect/fluid/smoke/quick/greenboy = new(dropturf)
	greenboy.color = "#00ff00"
	var/list/turf/turfs = list()
	for(var/turf/open/floors in oview(spew_range, dropturf))
		if(isgroundlessturf(floors))
			continue
		turfs += floors

	if(!length(turfs))
		return
	dropturf = pick(turfs)

	expose_turf(dropturf, volume/2)
	volume = round(volume/2, 0.01)

#undef CRITICAL_CAPACITY

/// Gibs you (lol), after an easily curable disease because WERE COWARDS
/datum/reagent/toxin/gibbium
	name = "Gibbium"
	description = "Guess what this does."
	silent_toxin = TRUE
	color = "#ff0000"
	metabolization_rate = 4 * REAGENTS_METABOLISM
	toxpwr = 0
	taste_description = "regret"
	chemical_flags = REAGENT_NO_RANDOM_RECIPE
	randomized_spawns = REAGENT_SPAWN_MAINTENANCE_PILL
	/// On what cycle to gib the person
	var/gib_cycle = 5

/datum/reagent/toxin/gibbium/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()

	if(current_cycle >= gib_cycle)
		affected_mob.ForceContractDisease(new /datum/disease/gbs/no_transmission ())

/datum/reagent/toxin/spider_serum
	name = "Spider Serum"
	description = "A horrible mutagen that transmutes flesh into spiders."
	color = "#000000"
	taste_description = "unending nightmares"
	chemical_flags = REAGENT_NO_RANDOM_RECIPE
	randomized_spawns = REAGENT_SPAWN_MAINTENANCE_PILL
	toxpwr = 0
	/// The cycle for when to do the "transformation"
	var/transformation_cycle = 30

/datum/reagent/toxin/spider_serum/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()

	if(prob(10))
		new /mob/living/basic/spider/growing/spiderling (get_turf(affected_mob))
		affected_mob.vomit(VOMIT_CATEGORY_BLOOD, lost_nutrition = 20)
		to_chat(affected_mob, span_warning("You feel tiny legs climbing up your throat."))

	if(current_cycle >= transformation_cycle)
		affected_mob.mind?.add_antag_datum(/datum/antagonist/spider)
		affected_mob.change_mob_type(/mob/living/basic/spider/giant, delete_old_mob = TRUE)
