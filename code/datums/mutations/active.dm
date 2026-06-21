/datum/mutation/adrenaline_rush
	name = "肾上腺素激增"
	desc = "允许宿主自主触发身体的肾上腺素反应。"
	quality = POSITIVE
	text_gain_indication = span_notice("你感觉精力充沛！")
	instability = POSITIVE_INSTABILITY_MODERATE
	power_path = /datum/action/cooldown/adrenaline

	energy_coeff = 1
	synchronizer_coeff = 1
	power_coeff = 1

/datum/mutation/adrenaline_rush/setup()
	. = ..()
	var/datum/action/cooldown/adrenaline/to_modify = .
	if(!istype(to_modify)) // null or invalid
		return

	to_modify.adrenaline_amount = 10 * GET_MUTATION_POWER(src)
	to_modify.comedown_amount = 7 / GET_MUTATION_SYNCHRONIZER(src)

/datum/action/cooldown/adrenaline
	name = "肾上腺素！"
	desc = "激发自己，将身体推向极限！"
	button_icon = 'icons/mob/actions/actions_genetic.dmi'
	button_icon_state = "adrenaline"

	cooldown_time = 2 MINUTES
	check_flags = AB_CHECK_CONSCIOUS
	/// How many units of each positive reagent injected during adrenaline.
	var/adrenaline_amount = 10
	/// How many units of each negative reagent injected after comedown.
	var/comedown_amount = 7


/datum/action/cooldown/adrenaline/Activate(mob/living/carbon/cast_on)
	. = ..()
	to_chat(cast_on, span_userdanger("你感觉精力充沛！是时候行动了！"))
	cast_on.reagents.add_reagent(/datum/reagent/drug/pumpup, adrenaline_amount)
	cast_on.reagents.add_reagent(/datum/reagent/medicine/synaptizine, adrenaline_amount)
	cast_on.reagents.add_reagent(/datum/reagent/determination, adrenaline_amount)
	addtimer(CALLBACK(src, PROC_REF(get_tired), cast_on), 25 SECONDS, TIMER_UNIQUE|TIMER_OVERRIDE)
	return TRUE

/datum/action/cooldown/adrenaline/proc/get_tired(mob/living/carbon/cast_on)
	to_chat(cast_on, span_danger("你的肾上腺素激增让位给一阵恶心和肌肉深处的疲惫感。"))
	cast_on.reagents.add_reagent(/datum/reagent/peaceborg/tire, comedown_amount)
	cast_on.reagents.add_reagent(/datum/reagent/peaceborg/confuse, comedown_amount)
	cast_on.set_dizzy_if_lower(10 SECONDS)
