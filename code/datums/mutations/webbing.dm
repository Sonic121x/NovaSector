//spider webs
/datum/mutation/webbing
	name = "蛛网生成"
	desc = "允许使用者铺设蛛网，并可在其中穿行。"
	quality = POSITIVE
	text_gain_indication = span_notice("你的皮肤感觉黏糊糊的。")
	instability = POSITIVE_INSTABILITY_MODERATE // useful until you're lynched
	power_path = /datum/action/cooldown/mob_cooldown/lay_web/genetic
	energy_coeff = 1

/datum/mutation/webbing/setup()
	. = ..()
	var/datum/action/cooldown/mob_cooldown/lay_web/genetic/to_modify = .

	if(!istype(to_modify)) // null or invalid
		return

	if(GET_MUTATION_ENERGY(src) == 1) // Energetic chromosome outputs a value less than 1 when present, 1 by default
		to_modify.webbing_time = initial(to_modify.webbing_time)
		return
	to_modify.webbing_time = 2 SECONDS // Spin webs faster but not more often

/datum/mutation/webbing/on_acquiring(mob/living/carbon/human/owner)
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_WEB_WEAVER, GENETIC_MUTATION)

/datum/mutation/webbing/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	REMOVE_TRAIT(owner, TRAIT_WEB_WEAVER, GENETIC_MUTATION)
