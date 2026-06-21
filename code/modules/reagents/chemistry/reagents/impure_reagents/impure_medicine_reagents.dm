//Reagents produced by metabolising/reacting fermichems suboptimally these specifically are for medicines
//Inverse = Splitting
//Invert = Whole conversion
//Failed = End reaction below purity_min

//START SUBTYPES

//We don't want these to hide - they're helpful!
/datum/reagent/impurity/healing
	name = "Healing Impure Reagent-提纯的不纯试剂"
	description = "并非所有不纯试剂都是有害的！有时你可能特意想制造这些！"
	chemical_flags = NONE
	addiction_types = list(/datum/addiction/medicine = 350)
	liver_damage = 0

/datum/reagent/inverse/healing
	name = "Healing Inverse Reagent-提纯的逆向试剂"
	description = "并非所有不纯试剂都是有害的！有时你可能特意想制造这些！"
	chemical_flags = NONE
	addiction_types = list(/datum/addiction/medicine = 400)
	tox_damage = 0

// END SUBTYPES

////////////////////MEDICINES///////////////////////////

//Catch all failed reaction for medicines - supposed to be non punishing
/datum/reagent/impurity/healing/medicine_failure
	name = "Insolvent Medicinal Precipitate-药物沉积物"
	description = "各种药物的粘稠混合物。会随机治愈一种伤害类型"
	metabolization_rate = 2.5 * REAGENTS_METABOLISM
	addiction_types = list(/datum/addiction/medicine = 400)
	ph = 11
	affected_biotype = MOB_ORGANIC | MOB_MINERAL | MOB_PLANT // no healing ghosts
	affected_respiration_type = ALL

//Random healing of the 4 main groups
/datum/reagent/impurity/healing/medicine_failure/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/need_mob_update
	var/pick = pick("brute", "burn", "tox", "oxy")
	switch(pick)
		if("brute")
			need_mob_update = affected_mob.adjust_brute_loss(-0.2 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
		if("burn")
			need_mob_update = affected_mob.adjust_fire_loss(-0.2 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
		if("tox")
			need_mob_update = affected_mob.adjust_tox_loss(-0.2 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype)
		if("oxy")
			need_mob_update = affected_mob.adjust_oxy_loss(-0.2 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

// C2 medications
// Helbital
//Inverse:
/datum/reagent/inverse/helgrasp
	name = "Helgrasp-海尔唤剂"
	description = "这种稀有且被禁止的混合物被认为能让你更接近北欧女神海尔的掌控。"
	metabolization_rate = 2.5 * REAGENTS_METABOLISM
	tox_damage = 0.25
	ph = 14
	//Compensates for seconds_per_tick lag by spawning multiple hands at the end
	var/lag_remainder = 0
	//Keeps track of the hand timer so we can cleanup on removal
	var/list/timer_ids

//Warns you about the impenting hands
/datum/reagent/inverse/helgrasp/on_mob_add(mob/living/affected_mob, amount)
	. = ..()
	to_chat(affected_mob, span_hierophant("你听到笑声，恶毒的手在你面前显现，渴望将你拖入地狱……！小心！"))
	playsound(affected_mob.loc, 'sound/effects/chemistry/ahaha.ogg', 80, TRUE, -1) //Very obvious tell so people can be ready

//Sends hands after you for your hubris
/*
How it works:
Standard seconds_per_tick for a reagent is 2s - and volume consumption is equal to the volume * seconds_per_tick.
In this chem, I want to consume 0.5u for 1 hand created (since 1*REM is 0.5) so on a single tick I create a hand and set up a callback for another one in 1s from now. But since delta time can vary, I want to be able to create more hands for when the delay is longer.

Initally I round seconds_per_tick to the nearest whole number, and take the part that I am rounding down from (i.e. the decimal numbers) and keep track of them. If the decimilised numbers go over 1, then the number is reduced down and an extra hand is created that tick.

Then I attempt to calculate the how many hands to created based off the current seconds_per_tick, since I can't know the delay to the next one it assumes the next will be in 2s.
I take the 2s interval period and divide it by the number of hands I want to make (i.e. the current seconds_per_tick) and I keep track of how many hands I'm creating (since I always create one on a tick, then I start at 1 hand). For each hand I then use this time value multiplied by the number of hands. Since we're spawning one now, and it checks to see if hands is less than, but not less than or equal to, seconds_per_tick, no hands will be created on the next expected tick.
Basically, we fill the time between now and 2s from now with hands based off the current lag.
*/
/datum/reagent/inverse/helgrasp/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	spawn_hands(affected_mob)
	lag_remainder += seconds_per_tick - floor(seconds_per_tick)
	seconds_per_tick = floor(seconds_per_tick)
	if(lag_remainder >= 1)
		seconds_per_tick += 1
		lag_remainder -= 1
	var/hands = 1
	var/time = 2 / seconds_per_tick
	while(hands < seconds_per_tick) //we already made a hand now so start from 1
		LAZYADD(timer_ids, addtimer(CALLBACK(src, PROC_REF(spawn_hands), affected_mob), (time*hands) SECONDS, TIMER_STOPPABLE)) //keep track of all the timers we set up
		hands += time

/datum/reagent/inverse/helgrasp/proc/spawn_hands(mob/living/carbon/affected_mob)
	if(!affected_mob && iscarbon(holder.my_atom))//Catch timer
		affected_mob = holder.my_atom
	fire_curse_hand(affected_mob)

//At the end, we clear up any loose hanging timers just in case and spawn any remaining lag_remaining hands all at once.
/datum/reagent/inverse/helgrasp/on_mob_delete(mob/living/affected_mob)
	. = ..()
	var/hands = 0
	while(lag_remainder > hands)
		spawn_hands(affected_mob)
		hands++
	for(var/id in timer_ids) // So that we can be certain that all timers are deleted at the end.
		deltimer(id)
	timer_ids.Cut()

/datum/reagent/inverse/helgrasp/heretic
	name = "Grasp of the Mansus-漫宿之握"
	description = "曼萨斯之手已扼住你的咽喉。"
	metabolization_rate = 2.5 * REAGENTS_METABOLISM
	tox_damage = 0

//libital
//Inverse:
//Simply reduces your alcohol tolerance, kinda simular to prohol
/datum/reagent/inverse/libitoil
	name = "Libitoil-抑酒解剂"
	description = "暂时干扰患者处理酒精的能力。"
	chemical_flags = NONE
	ph = 13.5
	addiction_types = list(/datum/addiction/medicine = 300)
	tox_damage = 0

/datum/reagent/inverse/libitoil/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.adjust_organ_loss(ORGAN_SLOT_LIVER, 0.05 * metabolization_ratio * seconds_per_tick)

/datum/reagent/inverse/libitoil/on_mob_add(mob/living/affected_mob, amount)
	. = ..()
	var/mob/living/carbon/consumer = affected_mob
	if(!consumer)
		return
	RegisterSignal(consumer, COMSIG_CARBON_GAIN_ORGAN, PROC_REF(on_gained_organ))
	RegisterSignal(consumer, COMSIG_CARBON_LOSE_ORGAN, PROC_REF(on_removed_organ))
	var/obj/item/organ/liver/this_liver = consumer.get_organ_slot(ORGAN_SLOT_LIVER)
	this_liver.alcohol_tolerance *= 2

/datum/reagent/inverse/libitoil/proc/on_gained_organ(mob/prev_owner, obj/item/organ/organ)
	SIGNAL_HANDLER
	if(!istype(organ, /obj/item/organ/liver))
		return
	var/obj/item/organ/liver/this_liver = organ
	this_liver.alcohol_tolerance *= 2

/datum/reagent/inverse/libitoil/proc/on_removed_organ(mob/prev_owner, obj/item/organ/organ)
	SIGNAL_HANDLER
	if(!istype(organ, /obj/item/organ/liver))
		return
	var/obj/item/organ/liver/this_liver = organ
	this_liver.alcohol_tolerance /= 2

/datum/reagent/inverse/libitoil/on_mob_delete(mob/living/affected_mob)
	. = ..()
	var/mob/living/carbon/consumer = affected_mob
	UnregisterSignal(consumer, COMSIG_CARBON_LOSE_ORGAN)
	UnregisterSignal(consumer, COMSIG_CARBON_GAIN_ORGAN)
	var/obj/item/organ/liver/this_liver = consumer.get_organ_slot(ORGAN_SLOT_LIVER)
	if(!this_liver)
		return
	this_liver.alcohol_tolerance /= 2


//probital
/datum/reagent/impurity/probital_failed//Basically crashed out failed metafactor
	name = "Metabolic Inhibition-慢性新陈代谢"
	description = "这种酶会催化崩溃，将营养食物转化为治疗性肽。"
	metabolization_rate = 0.0625  * REAGENTS_METABOLISM //slow metabolism rate so the patient can self heal with food even after the troph has metabolized away for amazing reagent efficency.
	color = "#b3ff00"
	overdose_threshold = 10
	ph = 1
	// this one is rather misleading due to it changing metabolism rate in overdose
	addiction_types = list(/datum/addiction/medicine = 15)
	liver_damage = 0

/datum/reagent/impurity/probital_failed/overdose_start(mob/living/carbon/M, metabolization_ratio)
	. = ..()
	metabolization_rate = 4  * REAGENTS_METABOLISM

/datum/reagent/peptides_failed
	name = "Prion Peptides-肽朊病毒"
	taste_description = "spearmint frosting"
	description = "这些抑制性肽会消耗营养并对患者造成脑损伤！"
	ph = 2.1

/datum/reagent/peptides_failed/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(affected_mob.adjust_organ_loss(ORGAN_SLOT_BRAIN, 0.125 * metabolization_ratio * seconds_per_tick, 170))
		. = UPDATE_MOB_HEALTH
	affected_mob.adjust_nutrition(-2.5 * metabolization_ratio * seconds_per_tick)

//Lenturi
//inverse
/datum/reagent/inverse/lentslurri //Okay maybe I should outsource names for these
	name = "Lentslurri-弛肌宁"//This is a really bad name please replace
	description = "一种高度成瘾的肌肉松弛剂，在伦图里反应出错时产生，会导致患者移动缓慢。"
	addiction_types = list(/datum/addiction/medicine = 150)
	tox_damage = 0

/datum/reagent/inverse/lentslurri/on_mob_metabolize(mob/living/carbon/affected_mob)
	. = ..()
	affected_mob.add_movespeed_modifier(/datum/movespeed_modifier/reagent/lenturi)

/datum/reagent/inverse/lentslurri/on_mob_end_metabolize(mob/living/carbon/affected_mob)
	. = ..()
	affected_mob.remove_movespeed_modifier(/datum/movespeed_modifier/reagent/lenturi)

//Aiuri
//inverse
/datum/reagent/inverse/aiuri
	name = "Aivime-败目剂"
	description = "已知该试剂会干扰患者的视力。"
	ph = 3.1
	addiction_types = list(/datum/addiction/medicine = 800)
	///The amount of blur applied per second. Given the average on_life interval is 2 seconds, that'd be 2.5s.
	var/amount_of_blur_applied = 1.25 SECONDS
	tox_damage = 0

/datum/reagent/inverse/aiuri/on_mob_life(mob/living/carbon/owner, seconds_per_tick, metabolization_ratio)
	owner.adjust_organ_loss(ORGAN_SLOT_EYES, 0.05 * metabolization_ratio * seconds_per_tick)
	owner.adjust_eye_blur(amount_of_blur_applied * seconds_per_tick)
	. = ..()
	return TRUE

//Hercuri
//inverse
/datum/reagent/inverse/hercuri
	name = "Herignis-体热素"
	description = "该试剂会导致患者体温急剧升高。过量使用会使效果更强并造成严重的肝脏损伤。"
	ph = 0.8
	tox_damage = 0
	color = "#ff1818"
	overdose_threshold = 25
	reagent_weight = 0.6
	taste_description = "heat! Ouch!"
	addiction_types = list(/datum/addiction/medicine = 480)

/datum/reagent/inverse/hercuri/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/heating = 0.5 * rand(5, 25) * creation_purity * metabolization_ratio * seconds_per_tick
	var/datum/reagents/mob_reagents = affected_mob.reagents
	if(mob_reagents)
		mob_reagents.expose_temperature(mob_reagents.chem_temp + heating, 1)
	affected_mob.adjust_bodytemperature(heating * TEMPERATURE_DAMAGE_COEFFICIENT)
	if(!ishuman(affected_mob))
		return
	var/mob/living/carbon/human/human = affected_mob
	human.adjust_coretemperature(heating * TEMPERATURE_DAMAGE_COEFFICIENT)

/datum/reagent/inverse/hercuri/expose_mob(mob/living/carbon/exposed_mob, methods=VAPOR, reac_volume)
	. = ..()
	if(!(methods & VAPOR))
		return

	exposed_mob.adjust_bodytemperature(reac_volume * TEMPERATURE_DAMAGE_COEFFICIENT)
	exposed_mob.adjust_fire_stacks(reac_volume / 2)

/datum/reagent/inverse/hercuri/overdose_process(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(affected_mob.adjust_organ_loss(ORGAN_SLOT_LIVER, 1 * metabolization_ratio * seconds_per_tick, required_organ_flag = affected_organ_flags)) //Makes it so you can't abuse it with pyroxadone very easily (liver dies from 25u unless it's fully upgraded)
		. = UPDATE_MOB_HEALTH
	var/heating = 5 * creation_purity * metabolization_ratio * seconds_per_tick * TEMPERATURE_DAMAGE_COEFFICIENT
	affected_mob.adjust_bodytemperature(heating) //hot hot
	if(ishuman(affected_mob))
		var/mob/living/carbon/human/human = affected_mob
		human.adjust_coretemperature(heating)

/datum/reagent/inverse/healing/tirimol
	name = "Super Melatonin-超级褪黑素"//It's melatonin, but super!
	description = "这会使患者进入睡眠状态，并提升所有已施用试剂的疗效。"
	ph = 12.5 //sleeping is a basic need of all lifeformsa
	self_consuming = TRUE //No pesky liver shenanigans
	chemical_flags = REAGENT_DEAD_PROCESS
	var/cached_reagent_list = list()
	addiction_types = list(/datum/addiction/medicine = 240)

//Makes patients fall asleep, then boosts the purirty of their medicine reagents if they're asleep
/datum/reagent/inverse/healing/tirimol/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	switch(current_cycle)
		if(2 to 11)//same delay as chloral hydrate
			if(prob(50))
				affected_mob.emote("yawn")
		if(11 to INFINITY)
			affected_mob.Sleeping(40)
			. = 1
			if(affected_mob.IsSleeping())
				for(var/datum/reagent/reagent as anything in affected_mob.reagents.reagent_list)
					if(reagent in cached_reagent_list)
						continue
					if(!istype(reagent, /datum/reagent/medicine))
						continue
					reagent.creation_purity *= 1.25
					cached_reagent_list += reagent

			else if(!affected_mob.IsSleeping() && length(cached_reagent_list))
				for(var/datum/reagent/reagent as anything in cached_reagent_list)
					if(!reagent)
						continue
					reagent.creation_purity *= 0.8
				cached_reagent_list = list()

/datum/reagent/inverse/healing/tirimol/on_mob_delete(mob/living/affected_mob)
	. = ..()
	if(affected_mob.IsSleeping())
		affected_mob.visible_message(span_notice("[icon2html(affected_mob, viewers(DEFAULT_MESSAGE_RANGE, src))] [affected_mob]发出了一声响亮的鼾声！"))//small way of letting people know the supersnooze is ended
	for(var/datum/reagent/reagent as anything in cached_reagent_list)
		if(!reagent)
			continue
		reagent.creation_purity *= 0.8
	cached_reagent_list = list()

//convermol
//inverse
/datum/reagent/inverse/healing/convermol
	name = "Coveroli-肺温定"
	description = "已知该试剂会覆盖患者肺部内壁，提供更强的对冷热空气的防护。"
	ph = 3.82
	tox_damage = 0
	addiction_types = list(/datum/addiction/medicine = 520)
	//The heat damage levels of lungs when added (i.e. heat_level_1_threshold on lungs)
	var/cached_heat_level_1
	var/cached_heat_level_2
	var/cached_heat_level_3
	//The cold damage levels of lungs when added (i.e. cold_level_1_threshold on lungs)
	var/cached_cold_level_1
	var/cached_cold_level_2
	var/cached_cold_level_3

/datum/reagent/inverse/healing/convermol/on_mob_add(mob/living/affected_mob, amount)
	. = ..()
	RegisterSignal(affected_mob, COMSIG_CARBON_GAIN_ORGAN, PROC_REF(on_gained_organ))
	RegisterSignal(affected_mob, COMSIG_CARBON_LOSE_ORGAN, PROC_REF(on_removed_organ))
	var/obj/item/organ/lungs/lungs = affected_mob.get_organ_slot(ORGAN_SLOT_LUNGS)
	if(!lungs)
		return
	apply_lung_levels(lungs)

/datum/reagent/inverse/healing/convermol/proc/on_gained_organ(mob/prev_owner, obj/item/organ/organ)
	SIGNAL_HANDLER
	if(!istype(organ, /obj/item/organ/lungs))
		return
	var/obj/item/organ/lungs/lungs = organ
	apply_lung_levels(lungs)

/datum/reagent/inverse/healing/convermol/proc/apply_lung_levels(obj/item/organ/lungs/lungs)
	cached_heat_level_1 = lungs.heat_level_1_threshold
	cached_heat_level_2 = lungs.heat_level_2_threshold
	cached_heat_level_3 = lungs.heat_level_3_threshold
	cached_cold_level_1 = lungs.cold_level_1_threshold
	cached_cold_level_2 = lungs.cold_level_2_threshold
	cached_cold_level_3 = lungs.cold_level_3_threshold
	//Heat threshold is increased
	lungs.heat_level_1_threshold *= creation_purity * 1.5
	lungs.heat_level_2_threshold *= creation_purity * 1.5
	lungs.heat_level_3_threshold *= creation_purity * 1.5
	//Cold threshold is decreased
	lungs.cold_level_1_threshold *= creation_purity * 0.5
	lungs.cold_level_2_threshold *= creation_purity * 0.5
	lungs.cold_level_3_threshold *= creation_purity * 0.5

/datum/reagent/inverse/healing/convermol/proc/on_removed_organ(mob/prev_owner, obj/item/organ/organ)
	SIGNAL_HANDLER
	if(!istype(organ, /obj/item/organ/lungs))
		return
	var/obj/item/organ/lungs/lungs = organ
	restore_lung_levels(lungs)

/datum/reagent/inverse/healing/convermol/proc/restore_lung_levels(obj/item/organ/lungs/lungs)
	lungs.heat_level_1_threshold = cached_heat_level_1
	lungs.heat_level_2_threshold = cached_heat_level_2
	lungs.heat_level_3_threshold = cached_heat_level_3
	lungs.cold_level_1_threshold = cached_cold_level_1
	lungs.cold_level_2_threshold = cached_cold_level_2
	lungs.cold_level_3_threshold = cached_cold_level_3

/datum/reagent/inverse/healing/convermol/on_mob_delete(mob/living/affected_mob)
	. = ..()
	UnregisterSignal(affected_mob, COMSIG_CARBON_LOSE_ORGAN)
	UnregisterSignal(affected_mob, COMSIG_CARBON_GAIN_ORGAN)
	var/obj/item/organ/lungs/lungs = affected_mob.get_organ_slot(ORGAN_SLOT_LUNGS)
	if(!lungs)
		return
	restore_lung_levels(lungs)

//seiver
//Inverse
//Allows the scanner to detect organ health to the nearest 1% (similar use to irl) and upgrates the scan to advanced
/datum/reagent/inverse/technetium
	name = "Technetium 99-锝9"
	description = "一种放射性示踪剂，可增强扫描仪检测内脏损伤的能力。存在时会缓慢毒害患者，建议使用后进行清除或使用低剂量。"
	metabolization_rate = 0.75 * REAGENTS_METABOLISM
	chemical_flags = NONE //Do show this on scanner
	tox_damage = 0
	var/time_until_next_poison = 0
	var/poison_interval = (9 SECONDS)

/datum/reagent/inverse/technetium/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	time_until_next_poison -= seconds_per_tick * (1 SECONDS)
	if (time_until_next_poison <= 0)
		time_until_next_poison = poison_interval
		if(affected_mob.adjust_tox_loss(1.34 * creation_purity * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype))
			return UPDATE_MOB_HEALTH

//Kind of a healing effect, Presumably you're using syrinver to purge so this helps that
/datum/reagent/inverse/healing/syriniver
	name = "Syrinifergus-全效补"
	description = "该试剂会降低患者体内所有非药物试剂的杂质，减少其负面影响。"
	self_consuming = TRUE //No pesky liver shenanigans
	chemical_flags = REAGENT_DEAD_PROCESS
	///The list of reagents we've affected
	var/cached_reagent_list = list()
	addiction_types = list(/datum/addiction/medicine = 685)

/datum/reagent/inverse/healing/syriniver/on_mob_add(mob/living/affected_mob, amount)
	if(!(iscarbon(affected_mob)))
		return ..()
	var/mob/living/carbon/affected_carbon = affected_mob
	for(var/datum/reagent/reagent as anything in affected_carbon.reagents.reagent_list)
		if(reagent in cached_reagent_list)
			continue
		if(istype(reagent, /datum/reagent/medicine))
			continue
		reagent.creation_purity *= 0.8
		cached_reagent_list += reagent
	..()

/datum/reagent/inverse/healing/syriniver/on_mob_delete(mob/living/affected_mob)
	. = ..()
	if(!(iscarbon(affected_mob)))
		return
	if(!cached_reagent_list)
		return
	for(var/datum/reagent/reagent as anything in cached_reagent_list)
		if(!reagent)
			continue
		reagent.creation_purity *= 1.25
	cached_reagent_list = null

//Multiver
//Inverse
//Reaction product when between 0.2 and 0.35 purity.
/datum/reagent/inverse/healing/monover
	name = "Monover-独释清"
	description = "一种毒素治疗试剂，仅在它是患者体内唯一的试剂时才有效。"
	ph = 0.5
	addiction_types = list(/datum/addiction/medicine = 350)

//Heals toxins if it's the only thing present - kinda the oposite of multiver! Maybe that's why it's inverse!
/datum/reagent/inverse/healing/monover/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/need_mob_update
	if(length(affected_mob.reagents.reagent_list) > 1)
		need_mob_update = affected_mob.adjust_organ_loss(ORGAN_SLOT_LUNGS, 0.5 * seconds_per_tick, required_organ_flag = affected_organ_flags) //Hey! It's everyone's favourite drawback from multiver!
	else
		need_mob_update = affected_mob.adjust_tox_loss(-1 * metabolization_ratio * creation_purity * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

///Can bring a corpse back to life temporarily (if heart is intact)
///Makes wounds bleed more, if it brought someone back, they take additional brute and heart damage
///They can't die during this, but if they're past crit then take increasing stamina damage
///If they're past fullcrit, their movement is slowed by half
///If they OD, their heart explodes (if they were brought back from the dead)
/datum/reagent/inverse/penthrite
	name = "Nooartrium-濒心剂"
	description = "一种已知能刺激死者心脏的试剂，能以心脏的巨大代价暂时复活刚死亡的患者。"
	ph = 14
	metabolization_rate = 0.125 * REAGENTS_METABOLISM
	// this one is also slightly misleading due to changing metabolism rate
	addiction_types = list(/datum/addiction/medicine = 12.5)
	overdose_threshold = 20
	self_consuming = TRUE //No pesky liver shenanigans
	chemical_flags = REAGENT_DEAD_PROCESS
	affected_organ_flags = NONE
	///If we brought someone back from the dead
	var/back_from_the_dead = FALSE
	/// List of trait buffs to give to the affected mob, and remove as needed.
	var/static/list/trait_buffs = list(
		TRAIT_NOCRITDAMAGE,
		TRAIT_NOCRITOVERLAY,
		TRAIT_NODEATH,
		TRAIT_NOHARDCRIT,
		TRAIT_NOSOFTCRIT,
		TRAIT_STABLEHEART,
		TRAIT_NO_OXYLOSS_PASSOUT,
	)

/datum/reagent/inverse/penthrite/on_mob_dead(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if (HAS_TRAIT(affected_mob, TRAIT_SUICIDED))
		return
	var/obj/item/organ/heart/heart = affected_mob.get_organ_slot(ORGAN_SLOT_HEART)
	if(!heart || heart.organ_flags & ORGAN_FAILING)
		return
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	affected_mob.add_traits(trait_buffs, type)
	affected_mob.set_stat(CONSCIOUS) //This doesn't touch knocked out
	affected_mob.updatehealth()
	affected_mob.update_sight()
	REMOVE_TRAIT(affected_mob, TRAIT_KNOCKEDOUT, STAT_TRAIT)
	REMOVE_TRAIT(affected_mob, TRAIT_KNOCKEDOUT, CRIT_HEALTH_TRAIT) //Because these are normally updated using set_health() - but we don't want to adjust health, and the addition of NOHARDCRIT blocks it being added after, but doesn't remove it if it was added before
	REMOVE_TRAIT(affected_mob, TRAIT_KNOCKEDOUT, OXYLOSS_TRAIT) //As above, removes unconsciousness if it was added before the reagent was administered
	affected_mob.set_resting(FALSE) //Please get up, no one wants a deaththrows juggernaught that lies on the floor all the time
	affected_mob.SetAllImmobility(0)
	affected_mob.grab_ghost(force = FALSE) //Shoves them back into their freshly reanimated corpse.
	back_from_the_dead = TRUE
	affected_mob.emote("gasp")
	affected_mob.playsound_local(affected_mob, 'sound/effects/health/fastbeat.ogg', 65)

/datum/reagent/inverse/penthrite/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(!back_from_the_dead)
		return
	//Following is for those brought back from the dead only
	var/creation_impurity = 1 - creation_purity
	REMOVE_TRAIT(affected_mob, TRAIT_KNOCKEDOUT, CRIT_HEALTH_TRAIT)
	REMOVE_TRAIT(affected_mob, TRAIT_KNOCKEDOUT, OXYLOSS_TRAIT)
	for(var/datum/wound/iter_wound as anything in affected_mob.all_wounds)
		iter_wound.adjust_blood_flow(4 * creation_impurity * metabolization_ratio * seconds_per_tick)
	var/need_mob_update
	need_mob_update = affected_mob.adjust_brute_loss(20 * creation_impurity * metabolization_ratio * seconds_per_tick, required_bodytype = affected_bodytype)
	need_mob_update += affected_mob.adjust_organ_loss(ORGAN_SLOT_HEART, 4 * ((1 + creation_impurity) * metabolization_ratio * seconds_per_tick), required_organ_flag = affected_organ_flags)
	if(affected_mob.health < HEALTH_THRESHOLD_CRIT)
		affected_mob.add_movespeed_modifier(/datum/movespeed_modifier/reagent/nooartrium)
	if(affected_mob.health < HEALTH_THRESHOLD_FULLCRIT)
		affected_mob.add_actionspeed_modifier(/datum/actionspeed_modifier/nooartrium)
	var/obj/item/organ/heart/heart = affected_mob.get_organ_slot(ORGAN_SLOT_HEART)
	if(!heart || heart.organ_flags & ORGAN_FAILING)
		remove_buffs(affected_mob)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/inverse/penthrite/on_mob_delete(mob/living/carbon/affected_mob)
	. = ..()
	remove_buffs(affected_mob)
	var/obj/item/organ/heart/heart = affected_mob.get_organ_slot(ORGAN_SLOT_HEART)
	if(affected_mob.health < -500 || heart.organ_flags & ORGAN_FAILING)//Honestly commendable if you get -500
		explosion(affected_mob, light_impact_range = 1, explosion_cause = src)
		qdel(heart)
		affected_mob.visible_message(span_boldwarning("[affected_mob]的心脏爆炸了！"))

/datum/reagent/inverse/penthrite/overdose_start(mob/living/carbon/affected_mob, metabolization_ratio)
	. = ..()
	if(!back_from_the_dead)
		return ..()
	var/obj/item/organ/heart/heart = affected_mob.get_organ_slot(ORGAN_SLOT_HEART)
	if(!heart) //No heart? No life!
		REMOVE_TRAIT(affected_mob, TRAIT_NODEATH, type)
		affected_mob.stat = DEAD
		return ..()
	explosion(affected_mob, light_impact_range = 1, explosion_cause = src)
	qdel(heart)
	affected_mob.visible_message(span_boldwarning("[affected_mob]的心脏爆炸了！"))
	return..()

/datum/reagent/inverse/penthrite/proc/remove_buffs(mob/living/carbon/affected_mob)
	affected_mob.remove_traits(trait_buffs, type)
	affected_mob.remove_movespeed_modifier(/datum/movespeed_modifier/reagent/nooartrium)
	affected_mob.remove_actionspeed_modifier(/datum/actionspeed_modifier/nooartrium)
	affected_mob.update_sight()

/*				Non c2 medicines 				*/

/datum/reagent/impurity/mannitol
	name = "Mannitoil-异语素"
	description = "使患者暂时出现言语障碍。"
	color = "#CDCDFF"
	addiction_types = list(/datum/addiction/medicine = 240)
	ph = 12.4
	liver_damage = 0
	///The speech we're forcing on the affected mob
	var/speech_option

/datum/reagent/impurity/mannitol/on_mob_add(mob/living/affected_mob, amount)
	. = ..()
	if(!iscarbon(affected_mob))
		return
	var/mob/living/carbon/affected_carbon = affected_mob
	if(!affected_carbon.dna)
		return
	var/list/speech_options = list(
		/datum/mutation/swedish,
		/datum/mutation/unintelligible,
		/datum/mutation/stoner,
		/datum/mutation/medieval,
		/datum/mutation/wacky,
		/datum/mutation/piglatin,
		/datum/mutation/nervousness,
		/datum/mutation/mute,
		)
	speech_options = shuffle(speech_options)
	for(var/option in speech_options)
		if(affected_carbon.dna.get_mutation(option, MUTATION_SOURCE_MANNITOIL))
			continue
		affected_carbon.dna.add_mutation(option, MUTATION_SOURCE_MANNITOIL)
		speech_option = option
		return

/datum/reagent/impurity/mannitol/on_mob_delete(mob/living/affected_mob)
	. = ..()
	if(!iscarbon(affected_mob))
		return
	var/mob/living/carbon/carbon = affected_mob
	carbon.dna?.remove_mutation(speech_option, MUTATION_SOURCE_MANNITOIL)

/datum/reagent/inverse/neurine
	name = "Neruwhine-异脑素"
	description = "通过重定向神经元活动，在患者体内诱发暂时性脑创伤。"
	color = "#DCDCAA"
	ph = 13.4
	addiction_types = list(/datum/addiction/medicine = 10)
	metabolization_rate = 0.0625 * REAGENTS_METABOLISM
	tox_damage = 0
	//The temporary trauma passed to the affected mob
	var/datum/brain_trauma/temp_trauma

/datum/reagent/inverse/neurine/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(temp_trauma)
		return
	if(!(SPT_PROB(creation_purity * 10, seconds_per_tick)))
		return
	var/static/list/traumalist
	if (!traumalist)
		traumalist = subtypesof(/datum/brain_trauma)

		// Don't add these to the list because they're abstract category types
		var/list/abstracttraumas = list(
			/datum/brain_trauma/magic,
			/datum/brain_trauma/mild,
			/datum/brain_trauma/severe,
			/datum/brain_trauma/special,
		)

		// Don't give out these traumas or any of their descendants
		var/list/forbiddentraumas = list(
			/datum/brain_trauma/severe/split_personality, // Uses a ghost, I don't want to use a ghost for a temp thing
			/datum/brain_trauma/special/imaginary_friend, // Same as above
			/datum/brain_trauma/special/obsessed, // Obsessed sets the affected_mob as an antag - I presume this will lead to problems, so we'll remove it
			/datum/brain_trauma/hypnosis, // Hypnosis, same reason as obsessed, plus a bug makes it remain even after the neruwhine purges and then turn into "nothing" on the med reading upon a second application
			/datum/brain_trauma/severe/hypnotic_stupor, // These apply the above blacklisted trauma
			/datum/brain_trauma/severe/hypnotic_trigger,
			/datum/brain_trauma/special/honorbound, // Designed to be chaplain exclusive
			/datum/brain_trauma/voided, // Voidwalker exclusive and more of a magical status effect than a trauma
		)
		forbiddentraumas += typesof(/datum/brain_trauma/very_special) // NOVA EDIT ADDITION - No very special (lewd) quirks gained by inverse neurine

		// Do give out these traumas but not any of their subtypes, usually because the trauma replaces itself with a subtype
		var/list/forbiddensubtypes = list(
			/datum/brain_trauma/mild/phobia,
			/datum/brain_trauma/severe/paralysis,
			/datum/brain_trauma/special/psychotic_brawling,
		)

		traumalist -= abstracttraumas
		for (var/type in forbiddentraumas)
			traumalist -= typesof(type)
		for (var/type in forbiddensubtypes)
			traumalist -= subtypesof(type)

	traumalist = shuffle(traumalist)
	var/obj/item/organ/brain/brain = affected_mob.get_organ_slot(ORGAN_SLOT_BRAIN)
	for(var/trauma in traumalist)
		temp_trauma = brain.brain_gain_trauma(trauma, TRAUMA_RESILIENCE_MAGIC)
		if(temp_trauma)
			return

/datum/reagent/inverse/neurine/on_mob_delete(mob/living/carbon/affected_mob)
	. = ..()
	if(!temp_trauma)
		return
	if(istype(temp_trauma, /datum/brain_trauma/special/imaginary_friend))//Good friends stay by you, no matter what
		return
	qdel(temp_trauma)
	temp_trauma = null

/datum/reagent/inverse/corazargh
	name = "Corazargh-心悸异" //It's what you yell! Though, if you've a better name feel free. Also an homage to an older chem
	description = "干扰身体的天然起搏器，迫使患者手动维持心跳。"
	color = "#5F5F5F"
	self_consuming = TRUE
	ph = 13.5
	addiction_types = list(/datum/addiction/medicine = 1200)
	metabolization_rate = 2.5 * REAGENTS_METABOLISM
	chemical_flags = REAGENT_DEAD_PROCESS
	tox_damage = 0

///Give the victim the manual heart beating component.
/datum/reagent/inverse/corazargh/on_mob_metabolize(mob/living/affected_mob)
	. = ..()
	if(!iscarbon(affected_mob))
		return
	var/mob/living/carbon/carbon_mob = affected_mob
	var/obj/item/organ/heart/affected_heart = carbon_mob.get_organ_slot(ORGAN_SLOT_HEART)
	if(isnull(affected_heart))
		return
	carbon_mob.AddComponent(/datum/component/manual_heart)
	return ..()

///We're done - remove the curse
/datum/reagent/inverse/corazargh/on_mob_end_metabolize(mob/living/affected_mob)
	qdel(affected_mob.GetComponent(/datum/component/manual_heart))
	..()

/datum/reagent/inverse/antihol
	name = "促醇"
	description = "促进患者体内的酒精物质，使其效果更加强烈。"
	taste_description = "alcohol" //mostly for sneaky slips
	chemical_flags = REAGENT_INVISIBLE
	metabolization_rate = 0.125 * REAGENTS_METABOLISM
	addiction_types = list(/datum/addiction/medicine = 30)
	color = "#4C8000"
	tox_damage = 0

/datum/reagent/inverse/antihol/on_mob_life(mob/living/carbon/C, seconds_per_tick, metabolization_ratio)
	. = ..()
	for(var/datum/reagent/consumable/ethanol/alcohol in C.reagents.reagent_list)
		alcohol.boozepwr += 8 * metabolization_ratio * seconds_per_tick

/datum/reagent/inverse/oculine
	name = "Oculater-异视素"
	description = "暂时致盲患者。"
	color = "#DDDDDD"
	addiction_types = list(/datum/addiction/medicine = 400)
	taste_description = "funky toxin"
	ph = 13
	tox_damage = 0
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	///Did we get a headache?
	var/headache = FALSE

/datum/reagent/inverse/oculine/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(headache)
		return ..()
	if(SPT_PROB(100 * creation_purity, seconds_per_tick))
		affected_mob.become_blind(IMPURE_OCULINE)
		to_chat(affected_mob, span_danger("你的视力剧烈波动，突然感到一阵剧烈的头痛。"))
		headache = TRUE

/datum/reagent/inverse/oculine/on_mob_end_metabolize(mob/living/affected_mob)
	. = ..()
	affected_mob.cure_blind(IMPURE_OCULINE)
	if(headache)
		to_chat(affected_mob, span_notice("你的头痛消失了！"))

/datum/reagent/impurity/inacusiate
	name = "Tinacusiate-异听素"
	description = "让患者的听力暂时变得古怪。"
	addiction_types = list(/datum/addiction/medicine = 20)
	color = "#DDDDFF"
	taste_description = "the heat evaporating from your mouth."
	ph = 1
	liver_damage = 0.1
	metabolization_rate = 0.1 * REAGENTS_METABOLISM
	///The random span we start hearing in
	var/random_span

/datum/reagent/impurity/inacusiate/on_mob_metabolize(mob/living/affected_mob, seconds_per_tick)
	. = ..()
	random_span = pick("clown", "small", "big", "hypnophrase", "alien", "cult", "alert", "danger", "emote", "yell", "brass", "sans", "papyrus", "robot", "his_grace", "phobia")
	RegisterSignal(affected_mob, COMSIG_MOVABLE_HEAR, PROC_REF(owner_hear))
	to_chat(affected_mob, span_warning("你的听力似乎有点不对劲[!HAS_TRAIT(affected_mob, TRAIT_DEAF) ? "!" : " - wait, that's normal."]"))

/datum/reagent/impurity/inacusiate/on_mob_end_metabolize(mob/living/affected_mob)
	. = ..()
	UnregisterSignal(affected_mob, COMSIG_MOVABLE_HEAR)
	to_chat(affected_mob, span_notice("You start hearing things normally again[!HAS_TRAIT(affected_mob, TRAIT_DEAF) ? "" : " - no, wait, no you don't"]."))

/datum/reagent/impurity/inacusiate/proc/owner_hear(mob/living/owner, list/hearing_args)
	SIGNAL_HANDLER

	// don't skip messages that the owner says or can't understand (since they still make sounds)
	if(HAS_TRAIT(owner, TRAIT_DEAF))
		return
	// not technically hearing
	var/atom/movable/speaker = hearing_args[HEARING_SPEAKER]
	if(!isnull(speaker) && HAS_TRAIT(speaker, TRAIT_SIGN_LANG))
		return

	var/list/spans = hearing_args[HEARING_SPANS]
	var/list/copied_spans = spans.Copy()
	copied_spans |= random_span
	hearing_args[HEARING_SPANS] = copied_spans

/datum/reagent/inverse/sal_acid
	name = "苯甲酸"
	description = "强效肥料，为植物生命提供相当广泛的好处。"
	taste_description = "flowers"
	color = "#e6c843"
	ph = 3.4
	tox_damage = 0

/datum/reagent/inverse/sal_acid/on_hydroponics_apply(obj/machinery/hydroponics/mytray, mob/user)
	mytray.adjust_plant_health(round(volume * 0.5))
	mytray.myseed?.adjust_production(-round(volume * 0.2))
	mytray.myseed?.adjust_potency(round(volume * 0.25))
	mytray.myseed?.adjust_yield(round(volume * 0.2))

/datum/reagent/inverse/oxandrolone
	name = "羟甲烯龙"
	description = "促进运动期间和之后肌肉生长的合成代谢类固醇。"
	color = "#520c23"
	taste_description = "sweat"
	overdose_threshold = 25
	ph = 12.2
	tox_damage = 0

/datum/reagent/inverse/oxandrolone/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/high_message = pick("You feel unstoppable.", "Giving it EVERYTHING!!", "You feel ready for anything.", "You feel like doing a thousand jumping jacks!")
	if(SPT_PROB(2, seconds_per_tick))
		to_chat(affected_mob, span_notice("[high_message]"))

/datum/reagent/inverse/oxandrolone/overdose_process(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(SPT_PROB(25, seconds_per_tick))
		affected_mob.adjust_bodytemperature(15 * TEMPERATURE_DAMAGE_COEFFICIENT * metabolization_ratio)
		affected_mob.set_jitter_if_lower(3 SECONDS)
		affected_mob.adjust_stamina_loss(2.5 * metabolization_ratio)
	else if(SPT_PROB(5, seconds_per_tick))
		affected_mob.vomit(VOMIT_CATEGORY_BLOOD, lost_nutrition = 0, distance = 3)
		affected_mob.Paralyze(3 SECONDS)

/datum/reagent/inverse/salbutamol
	name = "巴美生"
	description = "血液稀释剂，会大幅增加受到流血伤口的几率。"
	color = "#ecd4d6"
	taste_description = "paint thinner"
	ph = 4.5
	metabolization_rate = 0.2 * REAGENTS_METABOLISM
	tox_damage = 0
	metabolized_traits = list(TRAIT_EASYBLEED)

/datum/reagent/inverse/pen_acid
	name = "喷地肽"
	description = "清除基础毒素治疗药物，并加剧辐射中毒的严重程度。"
	color = "#09ff00"
	ph = 3.7
	taste_description = "venom"
	metabolization_rate = 0.0625 * REAGENTS_METABOLISM
	tox_damage = 0

/datum/reagent/inverse/pen_acid/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	holder.remove_reagent(/datum/reagent/medicine/c2/seiver, 40 * metabolization_ratio * seconds_per_tick)
	holder.remove_reagent(/datum/reagent/medicine/potass_iodide, 40 * metabolization_ratio * seconds_per_tick)
	holder.remove_reagent(/datum/reagent/medicine/c2/multiver, 40 * metabolization_ratio * seconds_per_tick)

	. = ..()
	if(HAS_TRAIT(affected_mob, TRAIT_IRRADIATED))
		affected_mob.set_jitter_if_lower(10 SECONDS)
		affected_mob.adjust_disgust(2.4 * metabolization_ratio * seconds_per_tick)
		if(SPT_PROB(2.5, seconds_per_tick))
			to_chat(affected_mob, span_warning("一阵可怕的疼痛在你体内蔓延！"))
			affected_mob.adjust_confusion_up_to(10 SECONDS, 15 SECONDS)

/datum/reagent/inverse/atropine
	name = "莨菪胺"
	description = "缓慢再生所有受损器官，但无法恢复功能丧失的器官。"
	color = "#273333"
	ph = 13.6
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	tox_damage = 0
	overdose_threshold = 40

/datum/reagent/inverse/atropine/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/need_mob_update
	need_mob_update = affected_mob.adjust_organ_loss(ORGAN_SLOT_STOMACH, -1 * metabolization_ratio * seconds_per_tick)
	need_mob_update += affected_mob.adjust_organ_loss(ORGAN_SLOT_HEART, -1 * metabolization_ratio * seconds_per_tick)
	if(affected_mob.get_tox_loss() <= 25)
		need_mob_update = affected_mob.adjust_tox_loss(-0.5, updating_health = FALSE, required_biotype = affected_biotype)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/inverse/atropine/overdose_process(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/static/list/possible_organs = list(
		ORGAN_SLOT_HEART,
		ORGAN_SLOT_LIVER,
		ORGAN_SLOT_LUNGS,
		ORGAN_SLOT_STOMACH,
		ORGAN_SLOT_EYES,
		ORGAN_SLOT_EARS,
		ORGAN_SLOT_BRAIN,
		ORGAN_SLOT_APPENDIX,
		ORGAN_SLOT_TONGUE,
	)
	affected_mob.adjust_organ_loss(pick(possible_organs) ,2 * seconds_per_tick)
	affected_mob.reagents.remove_reagent(type, 1 * metabolization_ratio * seconds_per_tick)

/datum/reagent/inverse/ammoniated_mercury
	name = "氨化污泥"
	description = "一种看起来可怕的汞副产品。会引起躁狂性歇斯底里的发作。"
	color = "#353535"
	ph = 10.2
	tox_damage = 0

/datum/reagent/inverse/ammoniated_mercury/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(SPT_PROB(7.5, seconds_per_tick))
		affected_mob.emote("scream")
		affected_mob.say(pick("AAAAAAAHHHHH!!","OOOOH NOOOOOO!!","GGGUUUUHHHHH!!","AIIIIIEEEEEE!!","HAHAHAHAHAAAAAA!!","OORRRGGGHHH!!","AAAAAAAJJJJJJJJJ!!"), forced = type)

/datum/reagent/inverse/rezadone
	name = "因雷齐尼弗"
	description = "让使用者对一切与鱼相关的事物产生极度恐惧。"
	color = "#c92eb4"
	ph = 13.9
	metabolization_rate = 0.125 * REAGENTS_METABOLISM
	tox_damage = 0

/datum/reagent/inverse/rezadone/on_mob_metabolize(mob/living/carbon/affected_mob)
	. = ..()
	affected_mob.gain_trauma(/datum/brain_trauma/mild/phobia/fish, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/reagent/inverse/rezadone/on_mob_end_metabolize(mob/living/carbon/affected_mob)
	. = ..()
	affected_mob.cure_trauma_type(/datum/brain_trauma/mild/phobia/fish, resilience = TRAUMA_RESILIENCE_ABSOLUTE)

/datum/reagent/inverse/spaceacillin
	name = "败血症林"
	description = "削弱免疫系统，加速细菌、病毒和寄生虫的影响，同时抵消免疫增强剂的效果。" //it's like spacacillin but evil muahaha
	color = "#002f06" //Gross green-black. Seemed fitting.
	ph = 8.1
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	tox_damage = 0
	metabolized_traits = list(TRAIT_IMMUNODEFICIENCY)

/datum/reagent/inverse/krokodil
	name = "哌莫尼"
	description = "强效镇静剂，能为疼痛管理和手术提供最佳效果。极易上瘾。"
	color = "#15b5dd55"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	overdose_threshold = 20
	ph = 2.5
	addiction_types = list(/datum/addiction/opioids = 10)
	metabolized_traits = list(TRAIT_ANALGESIA)
	tox_damage = 0

/datum/reagent/inverse/krokodil/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)
	. = ..()
	if(!(methods & (TOUCH|VAPOR|PATCH)))
		return

	exposed_mob.add_surgery_speed_mod(type, 0.7, min(reac_volume * 1 MINUTES, 5 MINUTES))

/datum/reagent/inverse/krokodil/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.add_mood_event("smacked out", /datum/mood_event/narcotic_heavy)

/datum/reagent/inverse/krokodil/overdose_process(mob/living/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.set_jitter_if_lower(10 SECONDS)
	affected_mob.set_dizzy_if_lower(5 SECONDS)
	if(SPT_PROB(10, seconds_per_tick))
		affected_mob.emote("drool")
	if(SPT_PROB(5, seconds_per_tick))
		to_chat(affected_mob, span_warning("你短暂地失去了对双腿的控制！"))
		affected_mob.Knockdown(5 SECONDS)
	if(SPT_PROB(5, seconds_per_tick))
		to_chat(affected_mob, span_warning("你手臂的肌肉不听使唤了！"))
		affected_mob.drop_all_held_items()

/datum/reagent/inverse/bath_salts
	name = "猴尘"
	description = "呜噗 啊克 奇 啊克 伊克 奇。伊克 啊克 呜噗 奇 呜噗 啊克 啊克！！"
	color = "#7e3900"
	ph = 14
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	tox_damage = 0
	/// The martial art we teach (to monkies)
	var/datum/martial_art/jungle_arts/jungle_arts

/datum/reagent/inverse/bath_salts/on_mob_metabolize(mob/living/carbon/affected_mob)
	. = ..()
	if(is_simian(affected_mob))
		affected_mob.gain_trauma(/datum/brain_trauma/special/primal_instincts, TRAUMA_RESILIENCE_ABSOLUTE)
		affected_mob.add_traits(list(TRAIT_STUNIMMUNE, TRAIT_SLEEPIMMUNE, TRAIT_ANALGESIA, TRAIT_STIMULATED), type)
		if(jungle_arts)
			return
		jungle_arts = new(src)
		jungle_arts.locked_to_use = TRUE
		jungle_arts.teach(affected_mob)

/datum/reagent/inverse/bath_salts/on_mob_end_metabolize(mob/living/carbon/affected_mob)
	. = ..()
	QDEL_NULL(jungle_arts)
	affected_mob.remove_traits(list(TRAIT_STUNIMMUNE, TRAIT_SLEEPIMMUNE, TRAIT_ANALGESIA, TRAIT_STIMULATED), type)
	affected_mob.Sleeping(30 SECONDS)
	if(is_simian(affected_mob))
		affected_mob.cure_trauma_type(/datum/brain_trauma/special/primal_instincts, resilience = TRAUMA_RESILIENCE_ABSOLUTE)


/datum/reagent/inverse/bath_salts/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(holder.has_reagent(/datum/reagent/drug/bath_salts))
		holder.remove_reagent(type, volume)
		return

	if(is_simian(affected_mob))
		var/need_mob_update
		need_mob_update = affected_mob.adjust_organ_loss(ORGAN_SLOT_BRAIN, 5 * metabolization_ratio * seconds_per_tick, required_organ_flag = affected_organ_flags)

		if(holder.has_reagent(/datum/reagent/consumable/monkey_energy))
			need_mob_update += affected_mob.adjust_organ_loss(ORGAN_SLOT_BRAIN, 5 * metabolization_ratio * seconds_per_tick, required_organ_flag = affected_organ_flags)

		if(need_mob_update)
			. = UPDATE_MOB_HEALTH
		return

	if(SPT_PROB(10, seconds_per_tick))
		affected_mob.emote(pick("screech","scratch","jump","look"))

	QDEL_NULL(jungle_arts)
	affected_mob.remove_traits(list(TRAIT_STUNIMMUNE, TRAIT_SLEEPIMMUNE, TRAIT_ANALGESIA, TRAIT_STIMULATED), type)

/datum/reagent/inverse/aranesp
	name = "促红素α"
	description = "Synthetic medication that induces blood regeneration and wound clotting in patients. \
		Causes adverse side effects, including arterial damage and migraines when excessively used over time."
	color = "#dee4ff"
	metabolization_rate = 0.625 * REAGENTS_METABOLISM
	overdose_threshold = 20
	ph = 6.1
	tox_damage = 0

/datum/reagent/inverse/aranesp/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(overdosed)
		return

	affected_mob.coagulant_effect(0.08 * metabolization_ratio * seconds_per_tick)
	affected_mob.adjust_blood_volume(1.6 * metabolization_ratio * seconds_per_tick, maximum = BLOOD_VOLUME_NORMAL)
	affected_mob.adjust_organ_loss(ORGAN_SLOT_HEART, 0.16 * metabolization_ratio * seconds_per_tick)

	switch(current_cycle)
		if(10)
			to_chat(affected_mob, span_warning("你感觉偏头痛要发作了..."))
			affected_mob.adjust_eye_blur(0.16 SECONDS * metabolization_ratio * seconds_per_tick)

		if(15 to 30)
			if(SPT_PROB(5, seconds_per_tick))
				to_chat(affected_mob, span_warning("你的头阵阵作痛，视线变得模糊。"))
				affected_mob.adjust_eye_blur(4 SECONDS * metabolization_ratio)
			if(SPT_PROB(5, seconds_per_tick))
				to_chat(affected_mob, span_warning("你的脸因头部突发的剧痛而扭曲。"))
				affected_mob.Stun(1 SECONDS)

		if(31 to 45)
			if(SPT_PROB(5, seconds_per_tick))
				to_chat(affected_mob, span_warning("你的头部感受到强烈的压迫感，几乎看不清东西！"))
				affected_mob.adjust_eye_blur(8 SECONDS * metabolization_ratio)
				affected_mob.adjust_confusion_up_to(5 SECONDS, 20 SECONDS)
				affected_mob.adjust_hallucinations(10 SECONDS)
			if(SPT_PROB(5, seconds_per_tick))
				to_chat(affected_mob, span_warning("你失去了焦点，茫然地凝视着前方。"))
				affected_mob.Stun(3 SECONDS)
				affected_mob.emote(pick("stare","drool","moan","look"))
			if(SPT_PROB(5, seconds_per_tick))
				to_chat(affected_mob, span_warning("你的吸气变得费力，呼吸越来越困难！"))
				holder.add_reagent(/datum/reagent/toxin/histamine, 3.2 * metabolization_ratio)

		if(46 to INFINITY)
			if(SPT_PROB(5, seconds_per_tick))
				to_chat(affected_mob, span_warning("感觉你的头快要内爆了！"))
				affected_mob.adjust_eye_blur(8 SECONDS * metabolization_ratio)
				affected_mob.adjust_confusion_up_to(10 SECONDS, 20 SECONDS)
				affected_mob.adjust_hallucinations(30 SECONDS)
			if(SPT_PROB(5, seconds_per_tick))
				to_chat(affected_mob, span_warning("你根本无法集中精神！"))
				affected_mob.Stun(5 SECONDS)
				affected_mob.emote(pick("stare","drool","tremble","shake"))
			if(SPT_PROB(5, seconds_per_tick))
				to_chat(affected_mob, span_warning("你的呼吸变得微弱而嘶哑，几乎无法保持清醒！"))
				holder.add_reagent(/datum/reagent/toxin/histamine, 4.8 * metabolization_ratio)
				affected_mob.losebreath += 3

/datum/reagent/inverse/aranesp/overdose_process(mob/living/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/need_mob_update
	if(SPT_PROB(10, seconds_per_tick))
		to_chat(affected_mob, span_warning("It feels like your head is going to implode!"))
		affected_mob.adjust_eye_blur(8 SECONDS * metabolization_ratio)
		affected_mob.adjust_confusion_up_to(10 SECONDS, 20 SECONDS)
		affected_mob.adjust_hallucinations(30 SECONDS)
	if(SPT_PROB(10, seconds_per_tick))
		to_chat(affected_mob, span_warning("你根本无法集中精神！"))
		affected_mob.Stun(50)
		affected_mob.emote(pick("stare","drool","tremble","shake"))
	if(SPT_PROB(10, seconds_per_tick))
		to_chat(affected_mob, span_warning("你的呼吸变得微弱而嘶哑，几乎无法保持清醒！"))
		holder.add_reagent(/datum/reagent/toxin/histamine, 4.8 * metabolization_ratio)
		affected_mob.losebreath += 3
		need_mob_update = TRUE

	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/inverse/happiness
	name = "悲伤"
	description = "导致使用者出现严重的抑郁行为，并会主动清除其他抗抑郁药。"
	color = "#0004ff"
	ph = 12
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	tox_damage = 0
	penetrates_skin = TOUCH|VAPOR

/datum/reagent/inverse/happiness/on_mob_metabolize(mob/living/carbon/affected_mob)
	. = ..()
	affected_mob.add_mood_event("sadness_inverse", /datum/mood_event/sadness_inverse)
	switch(volume)
		if(1 to INFINITY) // prevents microdosing from repeating this line
			affected_mob.say("What?? No... NO...", forced = type)

/datum/reagent/inverse/happiness/on_mob_end_metabolize(mob/living/carbon/affected_mob)
	. = ..()
	affected_mob.clear_mood_event("sadness_inverse")

/datum/reagent/inverse/happiness/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)
	. = ..()
	if(methods & (TOUCH|VAPOR))
		exposed_mob.emote("cry")
		return

/datum/reagent/inverse/happiness/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(affected_mob.mob_mood?.has_mood_of_category("friendly_hug") && !HAS_TRAIT(affected_mob, TRAIT_BADTOUCH))
		holder.remove_reagent(type, volume)
		return

	holder.remove_reagent(/datum/reagent/drug/happiness, 10 * metabolization_ratio * seconds_per_tick)
	holder.remove_reagent(/datum/reagent/medicine/psicodine, 10 * metabolization_ratio * seconds_per_tick)

	affected_mob.mob_mood.adjust_sanity(-13 * metabolization_ratio * seconds_per_tick, minimum = SANITY_INSANE)
	if(affected_mob.mob_mood != null && affected_mob.mob_mood.sanity < (SANITY_CRAZY))
		affected_mob.adjust_drowsiness_up_to(5 SECONDS, 30 SECONDS)
		if(SPT_PROB(25, seconds_per_tick))
			affected_mob.emote(pick("cry","frown","pout","whimper","sigh"))
		if(SPT_PROB(3, seconds_per_tick))
			affected_mob.say(pick("Why are we still here? Just to suffer?","To live is to suffer!","Life is suffering. It is the nature of existence!","Each day we wake up is another day closer to death.","Sometimes I can hear my bones straining under the weight of all the lives I'm not living.","There are no beautiful surfaces without a terrible depth."), forced = type)

/datum/reagent/inverse/baldium
	name = "恼火素"
	description = "强效精神药物，会导致使用者产生强烈的愤怒情绪。"
	color = "#ff0000"
	ph = 1
	tox_damage = 0
	var/delayed_burn_damage = 0

/datum/reagent/inverse/baldium/on_mob_metabolize(mob/living/carbon/affected_mob)
	. = ..()
	affected_mob.add_shared_particles(/particles/smoke/steam/mald)
	affected_mob.manual_emote("inhales sharply.")
	to_chat(affected_mob, span_warning("你发现自己看什么都更恼火了。"))

/datum/reagent/inverse/baldium/on_mob_end_metabolize(mob/living/carbon/affected_mob)
	. = ..()
	affected_mob.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, "#fe0000")
	affected_mob.remove_shared_particles(/particles/smoke/steam/mald)
	affected_mob.manual_emote("exhales sharply.")
	to_chat(affected_mob, span_warning("随着怒气消退，你感到一阵强烈的灼烧感！"))

/datum/reagent/inverse/baldium/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	delayed_burn_damage += (seconds_per_tick * 1)
	if(holder.has_reagent(/datum/reagent/consumable/salt))
		holder.remove_reagent(/datum/reagent/inverse/baldium, 1.5 * metabolization_ratio * seconds_per_tick)
		holder.remove_reagent(/datum/reagent/consumable/salt, 0.5 * metabolization_ratio * seconds_per_tick)

	switch(current_cycle)
		if(5)
			affected_mob.add_atom_colour("#fe0000", TEMPORARY_COLOUR_PRIORITY)
			if(!HAS_TRAIT(affected_mob, TRAIT_PACIFISM))
				var/turf/angery_blast = get_turf(affected_mob)
				goonchem_vortex(angery_blast, 1, 4)
				to_chat(affected_mob, span_warning("你无法控制自己，愤怒地大喊起来！！"))
				affected_mob.emote("scream")
				affected_mob.say(pick("RAGE!! UNLEASH THE RAGE!!","I'M SO ANGRY!!","WHY I OUGHTA...","AAARRRGGHH!!"), forced = type)
			else
				to_chat(affected_mob, span_warning("你平静而坚定地表达了自己的不满。"))
				affected_mob.say(pick("Aaahhhh...","Rage, woo yeah...","I'm slightly upset...",), forced = type)

		if(6 to INFINITY)
			if(SPT_PROB(10, seconds_per_tick))
				affected_mob.manual_emote(pick("breathes rapidly!","huffs, and puffs...","stares MENACINGLY!","sighs AGGRESSIVELY!","sheds a tear ANGRILY!"))

/datum/reagent/inverse/baldium/on_mob_delete(mob/living/affected_mob)
	. = ..()
	affected_mob.log_message("has taken [delayed_burn_damage] burn damage from maldium's aftereffects", LOG_ATTACK)
	affected_mob.adjust_fire_loss(delayed_burn_damage, updating_health = TRUE, required_bodytype = affected_bodytype)

/datum/reagent/inverse/colorful_reagent
	name = "黯淡试剂"
	description = "极其单调的着色颜料，深受那些希望最大化痛苦的公司青睐。"
	color = COLOR_GRAY
	ph = 10
	metabolization_rate = REAGENTS_METABOLISM
	tox_damage = 0
	/// Whenever this reagent can color mob limbs and organs upon exposure
	var/can_color_mobs = TRUE
	/// Whenever this reagent can color mob equipment when they're exposed to it externally
	var/can_color_clothing = TRUE
	/// Whenever this reagent can color mob organs when taken internally, false by default as this would cause chaotic flickering of victim's eyes
	var/can_color_organs = FALSE
	/// Stores the original color after reagent wears off
	var/datum/callback/color_callback
	/// Used when applying colors on valid things
	var/list/random_color_list = list("#1a1a1a","#2e2e2e","#424242","#565656","#6a6a6a","#7e7e7e","#929292","#a6a6a6","#bababa","#cecece")

/datum/reagent/inverse/colorful_reagent/New()
	color_callback = CALLBACK(src, PROC_REF(UpdateColor))
	SSticker.OnRoundstart(color_callback)
	return ..()

/datum/reagent/inverse/colorful_reagent/Destroy()
	LAZYREMOVE(SSticker.round_end_events, color_callback)
	color_callback = null
	return ..()

/datum/reagent/inverse/colorful_reagent/overdose_start(mob/living/affected_mob)
	. = ..()
	metabolization_rate = 0.1 * REAGENTS_METABOLISM

/datum/reagent/inverse/colorful_reagent/on_mob_metabolize(mob/living/carbon/affected_mob)
	. = ..()
	affected_mob.gain_trauma(/datum/brain_trauma/mild/color_blindness, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/reagent/inverse/colorful_reagent/on_mob_end_metabolize(mob/living/carbon/affected_mob)
	. = ..()
	affected_mob.cure_trauma_type(/datum/brain_trauma/mild/color_blindness, resilience = TRAUMA_RESILIENCE_ABSOLUTE)

/datum/reagent/inverse/colorful_reagent/proc/UpdateColor()
	color_callback = null
	color = pick(random_color_list)

/datum/reagent/inverse/colorful_reagent/expose_mob(mob/living/exposed_mob, methods, reac_volume, show_message, touch_protection)
	. = ..()
	var/picked_color = pick(random_color_list)
	var/color_filter = color_transition_filter(picked_color, SATURATION_OVERRIDE)
	if (can_color_clothing && (methods & (TOUCH|VAPOR|INHALE)))
		var/include_flags = INCLUDE_HELD|INCLUDE_ACCESSORIES|INCLUDE_PROSTHETICS|INCLUDE_ABSTRACT
		if (methods & (VAPOR|INHALE) || touch_protection >= 1)
			include_flags |= INCLUDE_POCKETS
		for (var/obj/item/to_color in exposed_mob.get_equipped_items(include_flags))
			to_color.add_atom_colour(color_filter, WASHABLE_COLOUR_PRIORITY)

	if (ishuman(exposed_mob))
		var/mob/living/carbon/human/exposed_human = exposed_mob
		exposed_human.set_facial_haircolor(picked_color, update = FALSE)
		exposed_human.set_haircolor(picked_color)

	if (!can_color_mobs)
		return

	if (!iscarbon(exposed_mob))
		exposed_mob.add_atom_colour(color_filter, WASHABLE_COLOUR_PRIORITY)
		return

	var/mob/living/carbon/exposed_carbon = exposed_mob

	for (var/obj/item/organ/organ as anything in exposed_carbon.organs)
		organ.add_atom_colour(color_filter, WASHABLE_COLOUR_PRIORITY)

	for (var/obj/item/bodypart/part as anything in exposed_carbon.get_bodyparts())
		part.add_atom_colour(color_filter, WASHABLE_COLOUR_PRIORITY)

/datum/reagent/inverse/colorful_reagent/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()

	if (!iscarbon(affected_mob))
		if (can_color_mobs)
			affected_mob.add_atom_colour(color_transition_filter(pick(random_color_list), SATURATION_OVERRIDE), WASHABLE_COLOUR_PRIORITY)
		return

	if(!can_color_organs)
		return

	var/mob/living/carbon/carbon_mob = affected_mob
	var/color_priority = WASHABLE_COLOUR_PRIORITY
	if (current_cycle >= 30)
		color_priority = FIXED_COLOUR_PRIORITY

	for (var/obj/item/organ/organ as anything in carbon_mob.organs)
		organ.add_atom_colour(color_transition_filter(pick(random_color_list), SATURATION_OVERRIDE), color_priority)

/datum/reagent/inverse/colorful_reagent/expose_atom(atom/exposed_atom, reac_volume)
	. = ..()
	if(!isliving(exposed_atom))
		exposed_atom.add_atom_colour(color_transition_filter(pick(random_color_list), SATURATION_OVERRIDE), WASHABLE_COLOUR_PRIORITY)

/datum/reagent/inverse/gravitum
	name = "牛顿素"
	description = "实验性试剂，会对使用者产生强烈的重力动力学效应。"
	color = "#4b0082"
	ph = 2.3
	metabolization_rate = 2.5 * REAGENTS_METABOLISM
	overdose_threshold = 30
	tox_damage = 0

/datum/reagent/inverse/gravitum/on_mob_metabolize(mob/living/affected_mob)
	. = ..()
	affected_mob.AddElement(/datum/element/forced_gravity, gravity = 5, ignore_turf_gravity = TRUE, can_override = FALSE)

/datum/reagent/inverse/gravitum/on_mob_end_metabolize(mob/living/affected_mob)
	. = ..()
	affected_mob.RemoveElement(/datum/element/forced_gravity, gravity = 5, ignore_turf_gravity = TRUE, can_override = FALSE)

/datum/reagent/inverse/gravitum/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()

	switch(current_cycle)
		if(10)
			for(var/obj/item/bodypart/leg/leg in affected_mob.get_bodyparts())
				affected_mob.cause_wound_of_type_and_severity(WOUND_BLUNT, leg, WOUND_SEVERITY_MODERATE)
			to_chat(affected_mob, span_warning("你的双腿开始因无法承受的引力而向内塌陷！"))

		if(20)
			for(var/obj/item/bodypart/leg/leg in affected_mob.get_bodyparts())
				affected_mob.cause_wound_of_type_and_severity(WOUND_BLUNT, leg, WOUND_SEVERITY_SEVERE)
			to_chat(affected_mob, span_warning("你的骨头在重力的猛烈捶打下可怕地碎裂了！"))

		if(30)
			for(var/obj/item/bodypart/leg/leg in affected_mob.get_bodyparts())
				affected_mob.cause_wound_of_type_and_severity(WOUND_BLUNT, leg, WOUND_SEVERITY_CRITICAL)
			to_chat(affected_mob, span_warning("这严峻的形势让你的骨头像冰棒棍一样咔嚓折断！"))

/datum/reagent/inverse/gravitum/overdose_start(mob/living/carbon/affected_mob, metabolization_ratio)
	. = ..()
	affected_mob.AddElement(/datum/element/squish, 120 SECONDS)
	for(var/obj/item/bodypart/leg/leg in affected_mob.get_bodyparts())
		affected_mob.cause_wound_of_type_and_severity(WOUND_SLASH, leg, WOUND_SEVERITY_SEVERE)
