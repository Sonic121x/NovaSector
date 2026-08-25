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
	name = "heroin"
	desc = "Take a line and take some time off, man."
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
		// NOVA EDIT CHANGE START - i18n: 拆成两条整句模板。原写法把 "headgear"/"mask" 当 LANG 实参，
		// 而它们是**单 token 局部量** —— LANG 实参的多词闸门按设计不收（单 token 实参里 act/黑板键
		// 浓度极高），于是模板译好了、槽里漏出英文（玩家看到「你必须先取下你的headgear！」）。
		// 整条走模板既绕开那道闸门，也让中文语序自己排。所有格代词经 lang_pronoun 走语法表。
		// ORIGINAL: to_chat(user, span_warning(LANG("obj.9f5fad6f715a086d", list(covered))))
		if(covered == "headgear")
			to_chat(user, span_warning(LANG("obj.892b7338f1a82533", list(lang_pronoun("your")))))
		else
			to_chat(user, span_warning(LANG("obj.725be70e424818d6", list(lang_pronoun("your")))))
		// NOVA EDIT CHANGE END
		return
	var/obj/item/organ/lungs/lungs = user.get_organ_slot(ORGAN_SLOT_LUNGS)
	if(isnull(lungs) || istype(lungs, /obj/item/organ/lungs/synth))
		to_chat(user, span_warning(LANG("obj.6ac4f04db78702e0", null)))
		return
	user.visible_message(span_notice(LANG("obj.b9527ba8243b7661", list(user, src))))
	if(do_after(user, 30))
		to_chat(user, span_notice(LANG("obj.88742f4661dfff78", list(src))))
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
	name = "heroin brick"
	desc = "A brick of heroin. Good for transport!"
	icon = 'modular_nova/modules/morenarcotics/icons/crack.dmi'
	icon_state = "heroinbrick"
	volume = 20
	has_variable_transfer_amount = FALSE
	list_reagents = list(/datum/reagent/drug/opium/heroin = 20)


/obj/item/reagent_containers/heroinbrick/attack_self(mob/user)
	user.visible_message(span_notice(LANG("obj.2c94b9cac2485db3", list(user, src))))
	if(do_after(user,10))
		to_chat(user, span_notice(LANG("obj.eb1bbccb3849e180", list(src))))
		for(var/i = 1 to 5)
			new /obj/item/reagent_containers/heroin(user.loc)
		qdel(src)

/datum/crafting_recipe/heroinbrick
	name = "heroin brick"
	result = /obj/item/reagent_containers/heroinbrick
	reqs = list(/obj/item/reagent_containers/heroin = 5)
	parts = list(/obj/item/reagent_containers/heroin = 5)
	time = 20
	category = CAT_CHEMISTRY

/atom/movable/screen/fullscreen/color_vision/heroin_color
	color = "#444444"

/datum/reagent/drug/opium
	name = "opium"
	description = "A extract from opium poppies. Puts the user in a slightly euphoric state."
	color = "#ffe669"
	overdose_threshold = 30
	ph = 8
	taste_description = "flowers"
	addiction_types = list(/datum/addiction/opioids = 30)

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
	name = "heroin"
	description = "She's like heroin to me, she's like heroin to me! She cannot... miss a vein!"
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
	name = "black tar heroin"
	description = "An impure, freebase form of heroin. Probably not a good idea to take this..."
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
	name = "liquid black tar heroin"

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
