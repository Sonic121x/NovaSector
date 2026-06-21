/datum/chemical_reaction/heroin
	results = list(/datum/reagent/drug/opium/heroin = 4)
	required_reagents = list(/datum/reagent/drug/opium = 2, /datum/reagent/acetone = 2)
	reaction_tags = REACTION_TAG_CHEMICAL
	required_temp = 480
	optimal_ph_min = 8
	optimal_ph_max = 12
	H_ion_release = -0.04
	rate_up_lim = 12.5
	purity_min = 0.5

/datum/chemical_reaction/powder_heroin
	is_cold_recipe = TRUE
	required_reagents = list(/datum/reagent/drug/opium/heroin = 8)
	required_temp = 250 //freeze it
	reaction_flags = REACTION_INSTANT
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_CHEMICAL
	mix_message = "The solution freezes into a powder!"

/datum/chemical_reaction/powder_heroin/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i in 1 to created_volume)
		new /obj/item/reagent_containers/heroin(location)

/obj/item/reagent_containers/heroin
	name = "海洛因"
	desc = "来上一口，给自己放个假吧，伙计。"
	icon = 'modular_nova/modules/morenarcotics/icons/crack.dmi'
	icon_state = "heroin"
	volume = 4
	has_variable_transfer_amount = FALSE
	list_reagents = list(/datum/reagent/drug/opium/heroin = 4)

/obj/item/reagent_containers/heroin/proc/snort(mob/living/user)
	if(!iscarbon(user))
		return
	var/covered = ""
	if(user.is_mouth_covered(ITEM_SLOT_HEAD))
		covered = "headgear"
	else if(user.is_mouth_covered(ITEM_SLOT_MASK))
		covered = "mask"
	if(covered)
		to_chat(user, span_warning("你得先取下你的 [covered]！"))
		return
	var/obj/item/organ/lungs/lungs = user.get_organ_slot(ORGAN_SLOT_LUNGS)
	if(isnull(lungs) || istype(lungs, /obj/item/organ/lungs/synth))
		to_chat(user, span_warning("你必须能呼吸才能吸食海洛因！"))
		return
	user.visible_message(span_notice("[user] 开始吸食 [src]。"))
	if(do_after(user, 30))
		to_chat(user, span_notice("你吸食完了 [src]。"))
		if(reagents.total_volume)
			reagents.trans_to(user, reagents.total_volume, transferred_by = user, methods = INGEST)
		qdel(src)

/obj/item/reagent_containers/heroin/attack_self(mob/user)
		snort(user)

/obj/item/reagent_containers/heroin/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return

	. = SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	if(!in_range(user, src) || user.get_active_held_item())
		return

	snort(user)

	return

/obj/item/reagent_containers/heroinbrick
	name = "海洛因砖"
	desc = "一块海洛因砖。便于运输！"
	icon = 'modular_nova/modules/morenarcotics/icons/crack.dmi'
	icon_state = "heroinbrick"
	volume = 20
	has_variable_transfer_amount = FALSE
	list_reagents = list(/datum/reagent/drug/opium/heroin = 20)


/obj/item/reagent_containers/heroinbrick/attack_self(mob/user)
	user.visible_message(span_notice("[user] 开始拆解 [src]。"))
	if(do_after(user,10))
		to_chat(user, span_notice("你拆解完了 [src]。"))
		for(var/i = 1 to 5)
			new /obj/item/reagent_containers/heroin(user.loc)
		qdel(src)

/datum/crafting_recipe/heroinbrick
	name = "海洛因砖"
	result = /obj/item/reagent_containers/heroinbrick
	reqs = list(/obj/item/reagent_containers/heroin = 5)
	parts = list(/obj/item/reagent_containers/heroin = 5)
	time = 20
	category = CAT_CHEMISTRY

/atom/movable/screen/fullscreen/color_vision/heroin_color
	color = "#444444"

/datum/reagent/drug/opium
	name = "鸦片"
	description = "从罂粟中提取的物质。能让使用者进入轻微的欣快状态。"
	color = "#ffe669"
	overdose_threshold = 30
	ph = 8
	taste_description = "flowers"
	addiction_types = list(/datum/addiction/opioids = 30)
	metabolization_rate = 0

/datum/reagent/drug/opium/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	var/high_message = pick("You feel euphoric.", "You feel on top of the world.")
	if(SPT_PROB(2.5, seconds_per_tick))
		to_chat(affected_mob, span_notice("[high_message]"))
	affected_mob.add_mood_event("smacked out", /datum/mood_event/narcotic_heavy, name)
	var/need_mob_update
	need_mob_update += affected_mob.adjust_brute_loss(-0.1 * seconds_per_tick * metabolization_ratio, updating_health = FALSE) //can be used as a (shitty) painkiller
	need_mob_update += affected_mob.adjust_fire_loss(-0.1 * seconds_per_tick * metabolization_ratio, updating_health = FALSE)
	if(need_mob_update)
		. = UPDATE_MOB_HEALTH
	affected_mob.overlay_fullscreen("heroin_euphoria", /atom/movable/screen/fullscreen/color_vision/heroin_color)
	return ..() || .

/datum/reagent/drug/opium/overdose_process(mob/living/affected_mob, seconds_per_tick, metabolization_ratio)
	affected_mob.adjust_organ_loss(ORGAN_SLOT_BRAIN, 0.5 * seconds_per_tick * metabolization_ratio, required_organ_flag = affected_organ_flags)
	affected_mob.adjust_tox_loss(1 * seconds_per_tick * metabolization_ratio, updating_health = FALSE, required_biotype = affected_biotype)
	affected_mob.adjust_drowsiness(1 SECONDS * normalise_creation_purity() * seconds_per_tick * metabolization_ratio)
	return TRUE

/datum/reagent/drug/opium/on_mob_metabolize(mob/living/metabolizer)
	. = ..()
	metabolizer.apply_status_effect(/datum/status_effect/grouped/screwy_hud/fake_healthy, type)

/datum/reagent/drug/opium/on_mob_end_metabolize(mob/living/metabolizer)
	. = ..()
	metabolizer.remove_status_effect(/datum/status_effect/grouped/screwy_hud/fake_healthy, type)
	metabolizer.clear_fullscreen("heroin_euphoria")

/datum/reagent/drug/opium/heroin
	name = "海洛因"
	description = "她对我而言就像海洛因，她对我而言就像海洛因！她绝不会……错过我的血管！"
	color = "#ffe669"
	overdose_threshold = 20
	ph = 6
	taste_description = "flowers"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	inverse_chem = /datum/reagent/drug/opium/blacktar/liquid

/datum/reagent/drug/opium/heroin/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/high_message = pick("You feel like nothing can stop you.", "You feel like God.")
	if(SPT_PROB(2.5, seconds_per_tick))
		to_chat(affected_mob, span_notice("[high_message]"))
	var/need_mob_update = affected_mob.adjust_brute_loss(-0.4 * seconds_per_tick * metabolization_ratio, , updating_health = FALSE) //more powerful as a painkiller, possibly actually useful to medical now
	need_mob_update += affected_mob.adjust_fire_loss(-0.4 * seconds_per_tick * metabolization_ratio, , updating_health = FALSE)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/drug/opium/blacktar
	name = "黑焦油海洛因"
	description = "一种不纯的海洛因游离碱形态。服用这个可能不是个好主意……"
	color = "#242423"
	overdose_threshold = 10 //more easy to overdose on
	ph = 8
	taste_description = "flowers"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/drug/opium/blacktar/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/high_message = pick("You feel like tar.", "The blood in your veins feel like syrup.")
	if(SPT_PROB(2.5, seconds_per_tick))
		to_chat(affected_mob, span_notice("[high_message]"))

	affected_mob.set_drugginess(20 SECONDS * seconds_per_tick * metabolization_ratio)
	if(affected_mob.adjust_tox_loss(0.5 * seconds_per_tick * metabolization_ratio, updating_health = FALSE, required_biotype = affected_biotype))
		return UPDATE_MOB_HEALTH

/datum/reagent/drug/opium/blacktar/liquid //prevents self-duplication by going one step down when mixed
	name = "液态黑焦油海洛因"

/datum/chemical_reaction/blacktar
	required_reagents = list(/datum/reagent/drug/opium/blacktar/liquid = 5)
	required_temp = 480
	reaction_flags = REACTION_INSTANT
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_CHEMICAL

/datum/chemical_reaction/blacktar/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i in 1 to created_volume)
		new /obj/item/reagent_containers/blacktar(location)

//Exports
/datum/export/heroin
	cost = CARGO_CRATE_VALUE * 0.5
	unit_name = "heroin"
	export_types = list(/obj/item/reagent_containers/heroin)
	include_subtypes = FALSE

/datum/export/heroinbrick
	cost = CARGO_CRATE_VALUE * 2.5
	unit_name = "heroin brick"
	export_types = list(/obj/item/reagent_containers/heroinbrick)
	include_subtypes = FALSE

/datum/export/blacktar
	cost = CARGO_CRATE_VALUE * 0.4
	unit_name = "black tar heroin"
	export_types = list(/obj/item/reagent_containers/blacktar)
	include_subtypes = FALSE
