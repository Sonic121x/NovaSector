// Category 2 medicines are medicines that have an ill effect regardless of volume/OD to dissuade doping. Mostly used as emergency chemicals OR to convert damage (and heal a bit in the process). The type is used to prompt borgs that the medicine is harmful.
/datum/reagent/medicine/c2
	abstract_type = /datum/reagent/medicine/c2
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	inverse_chem = null //Some of these use inverse chems - we're just defining them all to null here to avoid repetition, eventually this will be moved up to parent
	creation_purity = REAGENT_STANDARD_PURITY//All sources by default are 0.75 - reactions are primed to resolve to roughly the same with no intervention for these.
	purity = REAGENT_STANDARD_PURITY
	inverse_chem_val = 0
	inverse_chem = null
	chemical_flags = REAGENT_SPLITRETAINVOL

/******BRUTE******/
/*Suffix: -bital*/

/datum/reagent/medicine/c2/helbital //kinda a C2 only if you're not in hardcrit.
	name = "Helbital-赫尔比塔尔"
	description = "Named after the Norse goddess Hel, this medicine heals the patient's bruises the closer they are to death. Patients will find the medicine 'aids' their healing if not near death by causing asphyxiation."
	color = "#9400D3"
	taste_description = "cold and lifeless"
	ph = 8
	overdose_threshold = 35
	inverse_chem_val = 0.3
	inverse_chem = /datum/reagent/inverse/helgrasp
	var/helbent = FALSE
	var/reaping = FALSE
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/medicine/c2/helbital/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/death_is_coming = (affected_mob.get_tox_loss() + affected_mob.get_oxy_loss() + affected_mob.get_fire_loss() + affected_mob.get_brute_loss())*normalise_creation_purity()
	var/thou_shall_heal = 0
	var/good_kind_of_healing = FALSE
	var/need_mob_update = FALSE
	switch(affected_mob.stat)
		if(CONSCIOUS) //bad
			thou_shall_heal = max(death_is_coming/20, 3)
			need_mob_update += affected_mob.adjust_oxy_loss(2 * metabolization_ratio * seconds_per_tick, TRUE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type)
		if(SOFT_CRIT) //meh convert
			thou_shall_heal = round(death_is_coming/13,0.1)
			need_mob_update += affected_mob.adjust_oxy_loss(1 * metabolization_ratio * seconds_per_tick, TRUE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type)
			good_kind_of_healing = TRUE
		else //no convert
			thou_shall_heal = round(death_is_coming/10, 0.1)
			good_kind_of_healing = TRUE
	need_mob_update += affected_mob.adjust_brute_loss(-1 * thou_shall_heal * metabolization_ratio * seconds_per_tick, FALSE, required_bodytype = affected_bodytype)
	if(need_mob_update)
		. = UPDATE_MOB_HEALTH

	if(good_kind_of_healing && !reaping && SPT_PROB(0.005, seconds_per_tick)) //janken with the grim reaper!
		notify_ghosts(
			"[affected_mob.real_name] has entered a game of rock-paper-scissors with death!",
			source = affected_mob,
			header = "Who Will Win?",
		)
		reaping = TRUE
		if(affected_mob.apply_status_effect(/datum/status_effect/necropolis_curse, CURSE_BLINDING))
			helbent = TRUE
		to_chat(affected_mob, span_hierophant("Malevolent spirits appear before you, bartering your life in a 'friendly' game of rock, paper, scissors. Which do you choose?"))
		var/timeisticking = world.time
		var/RPSchoice = tgui_alert(affected_mob, "猜拳时间！你有60秒时间选择！", "石头剪刀布", list("rock" , "paper" , "scissors"), 60)
		if(QDELETED(affected_mob) || (timeisticking+(1.1 MINUTES) < world.time))
			reaping = FALSE
			return //good job, you ruined it
		if(!RPSchoice)
			to_chat(affected_mob, span_hierophant("你决定不再碰运气，但恶灵仍然存在……希望它们很快就会离开。"))
			reaping = FALSE
			return
		switch(rand(1,3))
			if(1) //You Tied!
				to_chat(affected_mob, span_hierophant("你打平了，恶灵消失了……暂时如此。"))
				reaping = FALSE
			if(2) //You lost!
				to_chat(affected_mob, span_hierophant("你输了，恶灵们阴森地冷笑着包围了你的身体。"))
				affected_mob.investigate_log("has lost rock paper scissors with the grim reaper and been dusted.", INVESTIGATE_DEATHS)
				affected_mob.dust()
				return
			if(3) //VICTORY ROYALE
				to_chat(affected_mob, span_hierophant("你赢了，恶灵和你的伤口一同消退了。"))
				affected_mob.client.give_award(/datum/award/achievement/jobs/helbitaljanken, affected_mob)
				affected_mob.revive(HEAL_ALL & ~HEAL_REFRESH_ORGANS)
				holder.del_reagent(type)
				return

/datum/reagent/medicine/c2/helbital/overdose_process(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(!helbent)
		affected_mob.apply_necropolis_curse(CURSE_WASTING | CURSE_BLINDING)
		helbent = TRUE

/datum/reagent/medicine/c2/helbital/on_mob_delete(mob/living/affected_mob)
	. = ..()
	if(helbent)
		affected_mob.remove_status_effect(/datum/status_effect/necropolis_curse)

/datum/reagent/medicine/c2/helbital/on_mob_end_metabolize(mob/living/affected_mob)
	. = ..()
	if(current_cycle >= 50) //greater than 10u in the system
		affected_mob.AddComponent(/datum/component/omen, incidents_left = min(round(current_cycle/51), 3)) //no more than 3 bad incidents for dropping more than 10u
		to_chat(affected_mob, span_hierophant_warning("随着物质离开你的身体，你感到一种沉重的恐惧和严重的不幸降临。"))

/datum/reagent/medicine/c2/libital //messes with your liber
	name = "Libital-利比特"
	description = "一种瘀伤缓解剂。会造成轻微的肝脏损伤。"
	color = "#ECEC8D" // rgb: 236 236 141
	ph = 8.2
	taste_description = "bitter with a hint of alcohol"
	inverse_chem_val = 0.3
	inverse_chem = /datum/reagent/inverse/libitoil
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/medicine/c2/libital/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/need_mob_update
	need_mob_update = affected_mob.adjust_organ_loss(ORGAN_SLOT_LIVER, 0.3 * metabolization_ratio * seconds_per_tick, required_organ_flag = affected_organ_flags)
	need_mob_update += affected_mob.adjust_brute_loss(-3 * normalise_creation_purity() * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/medicine/c2/probital
	name = "Probital-普罗比妥"
	description = "最初是作为寻求快速锻炼恢复者的健身房补充剂原型开发的，这种口服药物能快速修复受损的肌肉组织，但会导致乳酸堆积，使患者疲劳。过量服用会引起极度嗜睡。营养物质的涌入能进一步促进肌肉修复。"
	color = "#FFFF6B"
	ph = 5.5
	overdose_threshold = 20
	inverse_chem_val = 0.5//Though it's tough to get
	inverse_chem = /datum/reagent/medicine/metafactor //Seems thematically intact
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/medicine/c2/probital/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/need_mob_update
	need_mob_update = affected_mob.adjust_brute_loss(-3 * metabolization_ratio * normalise_creation_purity() * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
	var/ooo_youaregettingsleepy = 3.5
	switch(round(affected_mob.get_stamina_loss()))
		if(10 to 40)
			ooo_youaregettingsleepy = 3
		if(41 to 60)
			ooo_youaregettingsleepy = 2.5
		if(61 to 200) //you really can only go to 120
			ooo_youaregettingsleepy = 2
	need_mob_update += affected_mob.adjust_stamina_loss(1 * ooo_youaregettingsleepy * metabolization_ratio * seconds_per_tick, updating_stamina = FALSE)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/medicine/c2/probital/overdose_process(mob/living/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/need_mob_update
	need_mob_update = affected_mob.adjust_stamina_loss(3 * metabolization_ratio * seconds_per_tick, updating_stamina = FALSE)
	if(affected_mob.get_stamina_loss() >= 80)
		affected_mob.adjust_drowsiness(2 SECONDS * metabolization_ratio * seconds_per_tick)
	if(affected_mob.get_stamina_loss() >= 100)
		to_chat(affected_mob,span_warning("你感觉比平时更累，也许该闭上眼睛休息一会儿……"))
		need_mob_update += affected_mob.adjust_stamina_loss(-100, updating_stamina = FALSE) // Don't add the biotype parameter here as it results in infinite sleep and chat spam.
		affected_mob.Sleeping(10 SECONDS)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/medicine/c2/probital/expose_mob(mob/living/exposed_mob, methods, reac_volume, show_message, touch_protection)
	. = ..()
	if(!(methods & INGEST) || !iscarbon(exposed_mob))
		return

	var/datum/reagents/mob_reagents = exposed_mob.reagents
	mob_reagents.remove_reagent(/datum/reagent/medicine/c2/probital, reac_volume * 0.05)
	mob_reagents.add_reagent(/datum/reagent/medicine/metafactor, reac_volume * 0.25)

/******BURN******/
/*Suffix: -uri*/
/datum/reagent/medicine/c2/lenturi
	name = "Lenturi-类淳利"
	description = "用于治疗烧伤。离开你的系统时会造成胃部损伤。"
	color = "#6171FF"
	ph = 4.7
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	inverse_chem_val = 0.4
	inverse_chem = /datum/reagent/inverse/lentslurri

/datum/reagent/medicine/c2/lenturi/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/need_mob_update
	need_mob_update = affected_mob.adjust_fire_loss(-3.75 * metabolization_ratio * normalise_creation_purity() * seconds_per_tick, required_bodytype = affected_bodytype)
	need_mob_update += affected_mob.adjust_organ_loss(ORGAN_SLOT_STOMACH, 0.4 * metabolization_ratio * seconds_per_tick, required_organ_flag = affected_organ_flags)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/medicine/c2/aiuri
	name = "Aiuri-艾尤里"
	description = "用于治疗烧伤。会造成轻微的眼部损伤。"
	color = "#8C93FF"
	ph = 4
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	inverse_chem_val = 0.35
	inverse_chem = /datum/reagent/inverse/aiuri

/datum/reagent/medicine/c2/aiuri/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/need_mob_update
	need_mob_update = affected_mob.adjust_fire_loss(-2 * normalise_creation_purity() * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
	need_mob_update += affected_mob.adjust_organ_loss(ORGAN_SLOT_EYES, 0.25 * metabolization_ratio * seconds_per_tick, required_organ_flag = affected_organ_flags)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/medicine/c2/hercuri
	name = "Hercuri-赫库里"
	description = "不要与元素汞混淆，这种药物擅长逆转危险高温环境的影响。长时间接触可能导致体温过低。"
	color = "#F7FFA5"
	overdose_threshold = 25
	reagent_weight = 0.6
	ph = 8.9
	inverse_chem = /datum/reagent/inverse/hercuri
	inverse_chem_val = 0.3
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	process_flags = REAGENT_ORGANIC | REAGENT_SYNTHETIC // NOVA EDIT ADDITION - Lets hercuri process in synths

/datum/reagent/medicine/c2/hercuri/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/need_mob_update
	/* // NOVA EDIT REMOVAL START - Original
	if(affected_mob.get_fire_loss() > 50)
		need_mob_update = affected_mob.adjust_fire_loss(-3 * metabolization_ratio * seconds_per_tick * normalise_creation_purity(), updating_health = FALSE, required_bodytype = affected_bodytype)
	else
		need_mob_update = affected_mob.adjust_fire_loss(-2.25 * metabolization_ratio * seconds_per_tick * normalise_creation_purity(), updating_health = FALSE, required_bodytype = affected_bodytype)
	*/ // NOVA EDIT REMOVAL END
	// NOVA EDIT ADDITION START -- Adds check for owner_flags; indented the get_fire_loss check and everything under it, so synths can get cooled down
	var/owner_flags = affected_mob.dna.species.reagent_flags
	if (owner_flags & PROCESS_ORGANIC)
		if(affected_mob.get_fire_loss() > 50)
			need_mob_update = affected_mob.adjust_fire_loss(-3 * metabolization_ratio * seconds_per_tick * normalise_creation_purity(), updating_health = FALSE, required_bodytype = affected_bodytype)
		else
			need_mob_update = affected_mob.adjust_fire_loss(-2.25 * metabolization_ratio * seconds_per_tick * normalise_creation_purity(), updating_health = FALSE, required_bodytype = affected_bodytype)
	// NOVA EDIT ADDITION END
	affected_mob.adjust_bodytemperature(rand(-25,-5) * TEMPERATURE_DAMAGE_COEFFICIENT * metabolization_ratio * seconds_per_tick, 50)
	if(ishuman(affected_mob))
		var/mob/living/carbon/human/humi = affected_mob
		humi.adjust_coretemperature(1 * rand(-25,-5) * TEMPERATURE_DAMAGE_COEFFICIENT * metabolization_ratio * seconds_per_tick, 50)
	affected_mob.reagents?.chem_temp += (-10 * metabolization_ratio * seconds_per_tick)
	affected_mob.adjust_fire_stacks(-1 * metabolization_ratio * seconds_per_tick)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/medicine/c2/hercuri/expose_mob(mob/living/carbon/exposed_mob, methods=VAPOR, reac_volume)
	. = ..()
	if(!(methods & VAPOR))
		return

	exposed_mob.adjust_bodytemperature(-reac_volume * TEMPERATURE_DAMAGE_COEFFICIENT, 50)
	exposed_mob.adjust_fire_stacks(reac_volume / -2)
	if(reac_volume >= metabolization_rate)
		exposed_mob.extinguish_mob()

/datum/reagent/medicine/c2/hercuri/overdose_process(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.adjust_bodytemperature(-10 * TEMPERATURE_DAMAGE_COEFFICIENT * metabolization_ratio * seconds_per_tick, 50) //chilly chilly
	if(ishuman(affected_mob))
		var/mob/living/carbon/human/humi = affected_mob
		humi.adjust_coretemperature(-10 * TEMPERATURE_DAMAGE_COEFFICIENT * metabolization_ratio * seconds_per_tick, 50)


/******OXY******/
/*Suffix: -mol*/
#define CONVERMOL_RATIO 5 //# Oxygen damage to result in 1 tox

/datum/reagent/medicine/c2/convermol
	name = "Convermol-肯尔莫"
	description = "恢复缺氧状态，同时产生少量有毒副产物。两者均随药物暴露量和当前缺氧程度而变化。过量服用时，无论是否缺氧都会产生有毒副产物。"
	color = "#FF6464"
	overdose_threshold = 35 // at least 2 full syringes +some, this stuff is nasty if left in for long
	ph = 5.6
	inverse_chem_val = 0.5
	inverse_chem = /datum/reagent/inverse/healing/convermol
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/medicine/c2/convermol/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/oxycalc = 2.5 * metabolization_ratio * (current_cycle-1)
	if(!overdosed)
		oxycalc = min(oxycalc, affected_mob.get_oxy_loss() + 0.5) //if NOT overdosing, we lower our toxdamage to only the damage we actually healed with a minimum of 0.1*current_cycle. IE if we only heal 10 oxygen damage but we COULD have healed 20, we will only take toxdamage for the 10. We would take the toxdamage for the extra 10 if we were overdosing.
	var/need_mob_update
	need_mob_update = affected_mob.adjust_oxy_loss(-2 * oxycalc * normalise_creation_purity() * metabolization_ratio * seconds_per_tick , FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type)
	need_mob_update += affected_mob.adjust_tox_loss(2 * oxycalc * metabolization_ratio * seconds_per_tick / CONVERMOL_RATIO, updating_health = FALSE, required_biotype = affected_biotype)
	if(SPT_PROB((current_cycle-1) / 2, seconds_per_tick) && affected_mob.losebreath)
		affected_mob.losebreath--
		need_mob_update = TRUE
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/medicine/c2/convermol/overdose_process(mob/living/carbon/human/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	metabolization_rate += 2.5 * REAGENTS_METABOLISM

#undef CONVERMOL_RATIO

/datum/reagent/medicine/c2/tirimol
	name = "Tirimol-蒂里姆尔"
	description = "一种会导致疲劳的缺氧治疗药物。长时间暴露会使患者在药物代谢后陷入睡眠。"
	color = "#FF6464"
	ph = 5.6
	inverse_chem = /datum/reagent/inverse/healing/tirimol
	inverse_chem_val = 0.25
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

	/// A cooldown for spacing bursts of stamina damage
	COOLDOWN_DECLARE(drowsycd)

/datum/reagent/medicine/c2/tirimol/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/need_mob_update
	need_mob_update = affected_mob.adjust_oxy_loss(-4.5 * metabolization_ratio * seconds_per_tick * normalise_creation_purity(), updating_health = FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type)
	need_mob_update += affected_mob.adjust_stamina_loss(2 * metabolization_ratio * seconds_per_tick, updating_stamina = FALSE, required_biotype = affected_biotype)
	if(drowsycd && COOLDOWN_FINISHED(src, drowsycd))
		affected_mob.adjust_drowsiness(20 SECONDS)
		COOLDOWN_START(src, drowsycd, 45 SECONDS)
	else if(!drowsycd)
		COOLDOWN_START(src, drowsycd, 15 SECONDS)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/medicine/c2/tirimol/on_mob_end_metabolize(mob/living/affected_mob)
	. = ..()
	if(current_cycle > 21)
		affected_mob.Sleeping(10 SECONDS)

/******TOXIN******/
/*Suffix: -iver*/

/datum/reagent/medicine/c2/seiver //a bit of a gray joke
	name = "Seiver-温辐疗"
	description = "一种根据温度改变功能的药物。温度越高，解毒效果越强；温度越低，解毒量越大，但仅在患者受到辐射时有效。会损伤心脏。" //CHEM HOLDER TEMPS, NOT AIR TEMPS
	inverse_chem_val = 0.3
	ph = 3.7
	inverse_chem = /datum/reagent/inverse/technetium
	inverse_chem_val = 0.45
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	/// Temperatures below this number give radiation healing.
	var/rads_heal_threshold = 100

/datum/reagent/medicine/c2/seiver/on_mob_metabolize(mob/living/carbon/affected_mob)
	. = ..()
	rads_heal_threshold = rand(rads_heal_threshold - 50, rads_heal_threshold + 50) // Basically this means 50K and below will always give the radiation heal, and upto 150K could. Calculated once.

/datum/reagent/medicine/c2/seiver/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/chemtemp = min(holder.chem_temp, 1000)
	chemtemp = chemtemp ? chemtemp : T0C //why do you have null sweaty
	var/healypoints = 0 //5 healypoints = 1 heart damage; 5 rads = 1 tox damage healed for the purpose of healypoints

	//you're hot
	var/toxcalc = min(1 * round(5 + ((chemtemp-1000)/175), 0.1), 5) * metabolization_ratio * seconds_per_tick * normalise_creation_purity() //max 2.5 tox healing per second
	var/need_mob_update
	if(toxcalc > 0)
		need_mob_update = affected_mob.adjust_tox_loss(-toxcalc, updating_health = FALSE, required_biotype = affected_biotype)
		healypoints += toxcalc

	//and you're cold
	var/radcalc = 1 * round((T0C-chemtemp) / 6, 0.1) * metabolization_ratio * seconds_per_tick //max ~45 rad loss unless you've hit below 0K. if so, wow.
	if(radcalc > 0 && HAS_TRAIT(affected_mob, TRAIT_IRRADIATED))
		radcalc *= normalise_creation_purity()
		// extra rad healing if you are SUPER cold
		if(chemtemp < rads_heal_threshold*0.1)
			need_mob_update += affected_mob.adjust_tox_loss(-radcalc * 0.9, updating_health = FALSE, required_biotype = affected_biotype)
		else if(chemtemp < rads_heal_threshold)
			need_mob_update += affected_mob.adjust_tox_loss(-radcalc * 0.75, updating_health = FALSE, required_biotype = affected_biotype)
		healypoints += (radcalc / 5)

	//you're yes and... oh no!
	healypoints = round(healypoints, 0.1)
	affected_mob.adjust_organ_loss(ORGAN_SLOT_HEART, healypoints / 5, required_organ_flag = affected_organ_flags)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/medicine/c2/multiver //enhanced with MULTIple medicines
	name = "Multiver-木太尔"
	description = "一种化学净化剂，存在的独特药物越多，效果越强。能轻微解毒但会造成肺部损伤（可通过独特药物缓解）。"
	inverse_chem = /datum/reagent/inverse/healing/monover
	inverse_chem_val = 0.35
	ph = 9.2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/medicine/c2/multiver/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/medibonus = 0 //it will always have itself which makes it REALLY start @ 1
	for(var/r in affected_mob.reagents.reagent_list)
		var/datum/reagent/the_reagent = r
		if(istype(the_reagent, /datum/reagent/medicine))
			medibonus += 1
	if(creation_purity >= 1) //Perfectly pure multivers gives a bonus of 2!
		medibonus += 1
	var/need_mob_update
	need_mob_update = affected_mob.adjust_tox_loss(-0.5 * min(medibonus, 6 * normalise_creation_purity()) * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype) //not great at healing but if you have nothing else it will work
	need_mob_update += affected_mob.adjust_organ_loss(ORGAN_SLOT_LUNGS, 0.5 * metabolization_ratio * seconds_per_tick, required_organ_flag = affected_organ_flags) //kills at 40u
	if(!holder.has_reagent(/datum/reagent/toxin/anacea))
		for(var/datum/reagent/second_reagent as anything in affected_mob.reagents.reagent_list)
			if(second_reagent == src)
				continue
			if(medibonus >= 3 && istype(second_reagent, /datum/reagent/medicine)) //3 unique meds (2+multiver) | (1 + pure multiver) will make it not purge medicines
				continue
			affected_mob.reagents.remove_reagent(second_reagent.type, 3 * second_reagent.purge_multiplier * metabolization_ratio * seconds_per_tick)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

// Antitoxin binds plants pretty well. So the tox goes significantly down
/datum/reagent/medicine/c2/multiver/on_hydroponics_apply(obj/machinery/hydroponics/mytray, mob/user)
	mytray.adjust_toxic(-(round(volume * 2)*normalise_creation_purity())) //0-2.66, 2 by default (0.75 purity).

#define issyrinormusc(A) (istype(A,/datum/reagent/medicine/c2/syriniver) || istype(A,/datum/reagent/medicine/c2/musiver)) //musc is metab of syrin so let's make sure we're not purging either

/datum/reagent/medicine/c2/syriniver //Inject >> SYRINge
	name = "Syriniver-塞维尔"
	description = "一种治疗指数狭窄、用于静脉注射的强效解毒剂，被认为是musiver的活性前体药物。"
	color = "#8CDF24" // heavy saturation to make the color blend better
	metabolization_rate = 0.75 * REAGENTS_METABOLISM
	overdose_threshold = 6
	ph = 8.6
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	var/conversion_amount

/datum/reagent/medicine/c2/syriniver/expose_mob(mob/living/carbon/exposed_mob, methods, trans_volume, show_message, touch_protection)
	. = ..()
	if(!(methods & INJECT) || !iscarbon(exposed_mob))
		return

	if(trans_volume >= 0.4) //prevents cheesing with ultralow doses.
		exposed_mob.adjust_tox_loss((-1.5 * min(2, trans_volume)) * normalise_creation_purity(), required_biotype = affected_biotype) //This is to promote iv pole use for that chemotherapy feel.
	var/obj/item/organ/liver/L = exposed_mob.organs_slot[ORGAN_SLOT_LIVER]
	if(!L || L.organ_flags & ORGAN_FAILING)
		return
	conversion_amount = (trans_volume * (min(100 -exposed_mob.get_organ_loss(ORGAN_SLOT_LIVER), 80) / 100)*normalise_creation_purity()) //the more damaged the liver the worse we metabolize.

	var/datum/reagents/mob_reagents = exposed_mob.reagents
	mob_reagents.remove_reagent(/datum/reagent/medicine/c2/syriniver, conversion_amount)
	mob_reagents.add_reagent(/datum/reagent/medicine/c2/musiver, conversion_amount)

/datum/reagent/medicine/c2/syriniver/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/need_mob_update
	need_mob_update = affected_mob.adjust_organ_loss(ORGAN_SLOT_LIVER, 0.54 * metabolization_ratio * seconds_per_tick, required_organ_flag = affected_organ_flags)
	need_mob_update += affected_mob.adjust_tox_loss(-1.34 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype)
	for(var/datum/reagent/R in affected_mob.reagents.reagent_list)
		if(issyrinormusc(R))
			continue
		R.volume -= 0.27 * metabolization_ratio * seconds_per_tick
	affected_mob.reagents.update_total()

	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/medicine/c2/syriniver/overdose_process(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(affected_mob.adjust_organ_loss(ORGAN_SLOT_LIVER, 1 * metabolization_ratio * seconds_per_tick, required_organ_flag = affected_organ_flags))
		. = UPDATE_MOB_HEALTH
	affected_mob.adjust_disgust(2 * metabolization_ratio * seconds_per_tick)
	affected_mob.reagents.add_reagent(/datum/reagent/medicine/c2/musiver, 0.15 * metabolization_ratio * seconds_per_tick)

/datum/reagent/medicine/c2/musiver //MUScles
	name = "Musiver-穆西弗"
	description = "syriniver的活性代谢物。过量会导致肌肉无力。"
	color = "#DFD54E"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	overdose_threshold = 25
	ph = 9.1
	var/datum/brain_trauma/mild/muscle_weakness/trauma
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_NO_RANDOM_RECIPE
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/medicine/c2/musiver/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/need_mob_update
	need_mob_update = affected_mob.adjust_organ_loss(ORGAN_SLOT_LIVER, 0.2 * metabolization_ratio * seconds_per_tick, required_organ_flag = affected_organ_flags)
	need_mob_update += affected_mob.adjust_tox_loss(-3 * normalise_creation_purity() * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype)
	for(var/datum/reagent/reagent as anything in affected_mob.reagents.reagent_list)
		if(issyrinormusc(reagent))
			continue
		affected_mob.reagents.remove_reagent(reagent.type, 0.4 * reagent.purge_multiplier * metabolization_ratio * seconds_per_tick)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/medicine/c2/musiver/overdose_start(mob/living/carbon/affected_mob, metabolization_ratio)
	. = ..()
	trauma = new()
	affected_mob.gain_trauma(trauma, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/reagent/medicine/c2/musiver/on_mob_delete(mob/living/affected_mob)
	. = ..()
	if(trauma)
		QDEL_NULL(trauma)

/datum/reagent/medicine/c2/musiver/overdose_process(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(affected_mob.adjust_organ_loss(ORGAN_SLOT_LIVER, 3 * metabolization_ratio * seconds_per_tick, required_organ_flag = affected_organ_flags))
		. = UPDATE_MOB_HEALTH
	affected_mob.adjust_disgust(6 * metabolization_ratio * seconds_per_tick)

#undef issyrinormusc
/******COMBOS******/
/*Suffix: Combo of healing, prob gonna get wack REAL fast*/
/datum/reagent/medicine/c2/synthflesh
	name = "Synthflesh-合成肉"
	description = "以毒性为代价（治疗伤害的66%）治疗钝器伤和烧伤。仅限贴片、泼洒和喷雾使用。60单位纯合成肉或100单位较低纯度的合成肉可以修复因烧伤而焦化的尸体。"
	color = "#FFEBEB"
	ph = 7.2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/medicine/c2/synthflesh/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume, show_message = TRUE, touch_protection = 0)
	. = ..()
	if(!iscarbon(exposed_mob))
		return
	var/mob/living/carbon/carbies = exposed_mob
	if(!(methods & (PATCH|TOUCH|VAPOR)))
		return

	var/current_bruteloss = carbies.get_brute_loss() // because this will be changed after calling adjust_brute_loss()
	var/current_fireloss = carbies.get_fire_loss() // because this will be changed after calling adjust_fire_loss()
	var/touch_protection_interference = (1 - touch_protection)
	if(!touch_protection_interference)
		return
	var/harmies = clamp(carbies.adjust_brute_loss(-1.25 * reac_volume * touch_protection_interference, updating_health = FALSE, required_bodytype = affected_bodytype), 0, current_bruteloss)
	var/burnies = clamp(carbies.adjust_fire_loss(-1.25 * reac_volume * touch_protection_interference, updating_health = FALSE, required_bodytype = affected_bodytype), 0, current_fireloss)
	for(var/i in carbies.all_wounds)
		var/datum/wound/iter_wound = i
		iter_wound.on_synthflesh(reac_volume)
	var/need_mob_update = harmies + burnies
	need_mob_update = carbies.adjust_tox_loss((harmies + burnies)*(0.5 + (0.25*(1-creation_purity))), updating_health = FALSE, required_biotype = affected_biotype) || need_mob_update //0.5 - 0.75

	if(need_mob_update)
		carbies.updatehealth()
		if(show_message)
			carbies.visible_message(span_nicegreen("一种橡胶状的液体部分覆盖了 [carbies] 的烧伤处。"))
			if(carbies.stat != DEAD)
				to_chat(carbies, span_danger("你感觉你的烧伤和瘀伤正在愈合！疼得要命！"))
				carbies.add_mood_event("painful_medicine", /datum/mood_event/painful_medicine)

	//don't unhusked non husked mobs
	if (!HAS_TRAIT_FROM(exposed_mob, TRAIT_HUSK, BURN))
		return

	//don't try to unhusk mobs above burn damage threshold
	if(carbies.get_fire_loss() > UNHUSK_DAMAGE_THRESHOLD)
		if(show_message && !need_mob_update)
			carbies.visible_message(span_minoralert("液体无法在[carbies]上有效附着。需要先修复[carbies]的烧伤！"))
		return

	var/datum/reagent/synthflesh = carbies.reagents.has_reagent(/datum/reagent/medicine/c2/synthflesh)
	var/current_volume = synthflesh ? synthflesh.volume : 0
	var/current_purity = synthflesh ? synthflesh.purity : 0

	if (methods & TOUCH)	//touch does not apply chems to blood, we want to combine the two volumes before attempting to unhusk
		current_purity = current_volume > 0 ? (current_volume * current_purity + reac_volume * creation_purity) / (current_volume + reac_volume) : creation_purity
		current_volume += reac_volume

	//when purity = 100%, 60u to unhusk, when purity = 60%, 100u to unhusk.
	if(current_volume >= SYNTHFLESH_UNHUSK_MAX || current_volume * current_purity >= SYNTHFLESH_UNHUSK_AMOUNT)
		carbies.cure_husk(BURN)
		carbies.reagents.remove_reagent(/datum/reagent/medicine/c2/synthflesh, current_volume) // consume the synthflesh, it won't do anything in their blood
		//we're avoiding using the phrases "burnt flesh" and "burnt skin" here because carbies could be a skeleton or a golem or something
		carbies.visible_message(span_nicegreen("一种橡胶状的液体覆盖了 [carbies] 的烧伤处。[carbies] 看起来健康多了！"))
	else if(show_message && !need_mob_update)
		// if they are laying in a pool of synthflesh, we don't want it sending a message every tick
		if(methods & TOUCH)
			if(TIMER_COOLDOWN_RUNNING(carbies, REF(carbies)))
				return
			TIMER_COOLDOWN_START(carbies, REF(carbies), 16 SECONDS)
			carbies.visible_message(span_boldnotice("液体无法在[carbies]身上有效附着。剂量不足以解除外壳化！"))
		else
			carbies.visible_message(span_nicegreen("一种橡胶状液体部分修复了[carbies]……似乎需要更多剂量才能完全解除外壳化！"))

/******ORGAN HEALING******/
/*Suffix: -rite*/
/*
*How this medicine works:
*Penthrite if you are not in crit only stabilizes your heart.
*As soon as you pass crit threshold its special effects kick in. Penthrite forces your heart to beat preventing you from entering
*soft and hard crit, but there is a catch. During this you will be healed and you will sustain
*heart damage that will not imapct you as long as penthrite is in your system.
*If you reach the threshold of -60 HP penthrite stops working and you get a heart attack, penthrite is flushed from your system in that very moment,
*causing you to loose your soft crit, hard crit and heart stabilization effects.
*Overdosing on penthrite also causes a heart failure.
*/
/datum/reagent/medicine/c2/penthrite
	name = "Penthrite-四硝酸酯"
	description = "一种昂贵的药物，即使没有心脏也能帮助血液在体内循环，并防止心脏减速。与肾上腺素或阿托品混合会引起爆炸。"
	color = "#F5F5F5"
	overdose_threshold = 50
	ph = 12.7
	inverse_chem = /datum/reagent/inverse/penthrite
	inverse_chem_val = 0.25
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	/// List of traits to add/remove from our subject when we are in their system
	var/static/list/subject_traits = list(
		TRAIT_STABLEHEART,
		TRAIT_NOHARDCRIT,
		TRAIT_NOSOFTCRIT,
		TRAIT_NOCRITDAMAGE,
	)

/atom/movable/screen/alert/penthrite
	name = "强劲心跳"
	desc = "你的心脏正有力地搏动着！"
	use_user_hud_icon = USER_HUD_STYLE_INHERIT
	overlay_icon = 'icons/obj/medical/syringe.dmi'
	overlay_state = "luxpen"

/datum/reagent/medicine/c2/penthrite/on_mob_metabolize(mob/living/user)
	. = ..()
	send_alert(user)
	user.add_traits(subject_traits, type)

/datum/reagent/medicine/c2/penthrite/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/need_mob_update
	need_mob_update = affected_mob.adjust_stamina_loss(-12.5 * REM * seconds_per_tick, updating_stamina = FALSE) // NOVA EDIT ADDITION - COMBAT - makes your heart beat faster, fills you with energy. For miners
	need_mob_update = affected_mob.adjust_organ_loss(ORGAN_SLOT_STOMACH, 0.25 * metabolization_ratio * seconds_per_tick, required_organ_flag = affected_organ_flags)
	if(affected_mob.health <= HEALTH_THRESHOLD_CRIT && affected_mob.health > (affected_mob.crit_threshold + HEALTH_THRESHOLD_FULLCRIT * (2 * normalise_creation_purity()))) //we cannot save someone below our lowered crit threshold.

		need_mob_update += affected_mob.adjust_tox_loss(-2 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype)
		need_mob_update += affected_mob.adjust_brute_loss(-2 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
		need_mob_update += affected_mob.adjust_fire_loss(-2 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
		need_mob_update += affected_mob.adjust_oxy_loss(-6 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type)

		affected_mob.losebreath = 0

		need_mob_update += affected_mob.adjust_organ_loss(ORGAN_SLOT_HEART, 1 * max(volume/10, 1) * metabolization_ratio * seconds_per_tick, required_organ_flag = affected_organ_flags) // your heart is barely keeping up!

		affected_mob.set_jitter_if_lower(1 * rand(0 SECONDS, 4 SECONDS) * metabolization_ratio * seconds_per_tick)
		affected_mob.set_dizzy_if_lower(1 * rand(0 SECONDS, 4 SECONDS) * metabolization_ratio * seconds_per_tick)

		if(SPT_PROB(18, seconds_per_tick))
			to_chat(affected_mob,span_danger("你的身体试图放弃，但你的心脏仍在跳动！"))

	if(affected_mob.health <= (affected_mob.crit_threshold + HEALTH_THRESHOLD_FULLCRIT*(2*normalise_creation_purity()))) //certain death below this threshold
		REMOVE_TRAIT(affected_mob, TRAIT_STABLEHEART, type) //we have to remove the stable heart trait before we give them a heart attack
		affected_mob.remove_traits(subject_traits, type)
		to_chat(affected_mob, span_danger("你感觉胸腔内有东西破裂了！"))
		if(!HAS_TRAIT(affected_mob, TRAIT_ANALGESIA))
			affected_mob.emote("scream")
		affected_mob.set_heartattack(TRUE)
		volume = 0
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/medicine/c2/penthrite/on_mob_end_metabolize(mob/living/affected_mob)
	. = ..()
	remove_alert(affected_mob)
	affected_mob.remove_traits(subject_traits, type)

/datum/reagent/medicine/c2/penthrite/overdose_process(mob/living/carbon/human/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	REMOVE_TRAIT(affected_mob, TRAIT_STABLEHEART, type)
	var/need_mob_update
	need_mob_update = affected_mob.adjust_stamina_loss(10 * metabolization_ratio * seconds_per_tick, updating_stamina = FALSE, required_biotype = affected_biotype)
	need_mob_update += affected_mob.adjust_organ_loss(ORGAN_SLOT_HEART, 10 * metabolization_ratio * seconds_per_tick, required_organ_flag = affected_organ_flags)
	need_mob_update += affected_mob.set_heartattack(TRUE)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/medicine/c2/penthrite/proc/send_alert(mob/living/affected_mob)
	affected_mob.throw_alert("penthrite", /atom/movable/screen/alert/penthrite)

/datum/reagent/medicine/c2/penthrite/proc/remove_alert(mob/living/affected_mob)
	affected_mob.clear_alert("penthrite")

/******NICHE******/
//todo
