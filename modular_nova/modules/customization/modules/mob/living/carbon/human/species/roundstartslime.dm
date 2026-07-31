#define SLIME_ACTIONS_ICON_FILE 'modular_nova/master_files/icons/mob/actions/actions_slime.dmi'
/// This is the level of waterstacks that start doing noteworthy bloodloss to a slimeperson.
#define DAMAGE_WATER_STACKS 5
/// This is the level of waterstacks that prevent a slimeperson from regenerating, doing minimal bloodloss in the process.
#define REGEN_WATER_STACKS 1
// For their passive healing
#define SPECIES_SLIME_PASSIVE_REGEN_BRUTE 0.6
#define SPECIES_SLIME_PASSIVE_REGEN_BURN 0.5

/datum/species/jelly
	hair_alpha = 160 //a notch brighter so it blends better.
	facial_hair_alpha = 160
	mutantliver = /obj/item/organ/liver/slime
	mutantstomach = /obj/item/organ/stomach/slime
	mutantbrain = /obj/item/organ/brain/slime
	mutantears = /obj/item/organ/ears/jelly
	mutantappendix = null // Slimes have no Appendix
	inherent_traits = list(
		TRAIT_MUTANT_COLORS,
		TRAIT_TOXINLOVER,
		TRAIT_EASYDISMEMBER,
	)
	/// Ability to allow them to shapeshift their body around.
	var/datum/action/innate/alter_form/alter_form
	/// Ability to allow them to clean themselves and their stuff.
	var/datum/action/cooldown/spell/slime_washing/slime_washing
	/// Ability to allow them to resist the effects of water.
	var/datum/action/cooldown/spell/slime_hydrophobia/slime_hydrophobia
	/// Ability to allow them to turn their core's GPS on or off.
	var/datum/action/innate/core_signal/core_signal

/datum/species/jelly/on_species_gain(mob/living/carbon/new_jellyperson, datum/species/old_species, pref_load, regenerate_icons)
	. = ..()
	if(ishuman(new_jellyperson))
		alter_form = new
		alter_form.Grant(new_jellyperson)
		slime_washing = new
		slime_washing.Grant(new_jellyperson)
		slime_hydrophobia = new
		slime_hydrophobia.Grant(new_jellyperson)
		core_signal = new
		core_signal.Grant(new_jellyperson)
	RegisterSignal(new_jellyperson, COMSIG_LIVING_LIFE, PROC_REF(on_life))

/datum/species/jelly/on_species_loss(mob/living/carbon/former_jellyperson, datum/species/new_species, pref_load)
	. = ..()
	if(alter_form)
		alter_form.Remove(former_jellyperson)
	if(slime_washing)
		slime_washing.Remove(former_jellyperson)
	if(slime_hydrophobia)
		slime_hydrophobia.Remove(former_jellyperson)
	if(core_signal)
		core_signal.Remove(former_jellyperson)
	UnregisterSignal(former_jellyperson, COMSIG_LIVING_LIFE)

/datum/species/jelly/get_default_mutant_bodyparts()
	return list(
		FEATURE_TAIL = MUTPART_BLUEPRINT(SPRITE_ACCESSORY_NONE, is_randomizable = FALSE),
		FEATURE_SNOUT = MUTPART_BLUEPRINT(SPRITE_ACCESSORY_NONE, is_randomizable = FALSE),
		FEATURE_EARS = MUTPART_BLUEPRINT(SPRITE_ACCESSORY_NONE, is_randomizable = FALSE),
		FEATURE_LEGS = MUTPART_BLUEPRINT(NORMAL_LEGS, is_randomizable = FALSE, is_feature = TRUE),
		FEATURE_TAUR = MUTPART_BLUEPRINT(SPRITE_ACCESSORY_NONE, is_randomizable = FALSE),
		FEATURE_WINGS = MUTPART_BLUEPRINT(SPRITE_ACCESSORY_NONE, is_randomizable = FALSE),
		FEATURE_HORNS = MUTPART_BLUEPRINT(SPRITE_ACCESSORY_NONE, is_randomizable = FALSE),
		FEATURE_SPINES = MUTPART_BLUEPRINT(SPRITE_ACCESSORY_NONE, is_randomizable = FALSE),
		FEATURE_FRILLS = MUTPART_BLUEPRINT(SPRITE_ACCESSORY_NONE, is_randomizable = FALSE),
	)

/datum/species/jelly/gain_oversized_organs(mob/living/carbon/human/human_holder, datum/quirk/oversized/oversized_quirk)
	if(isnull(human_holder.loc))
		return // preview characters don't need funny organs, prevents a runtime

	var/obj/item/organ/brain/slime/oversized/new_slime_brain = new
	var/obj/item/organ/stomach/slime/oversized/new_slime_stomach = new //YOU LOOK HUGE! THAT MUST MEAN YOU HAVE HUGE golgi apparatus! RIP AND TEAR YOUR HUGE golgi apparatus!

	var/obj/item/organ/brain/slime/old_brain = human_holder.get_organ_slot(ORGAN_SLOT_BRAIN)
	var/obj/item/organ/stomach/slime/old_stomach = human_holder.get_organ_slot(ORGAN_SLOT_STOMACH)
	oversized_quirk.old_organs = list(
		old_brain,
		old_stomach,
	)

	// To prevent ghosting. We have to do this manually here because TG has replace_into() hardcoded to qdel the old brain no matter what and there is no way around it.
	old_brain.Remove(human_holder, special = TRUE, movement_flags = NO_ID_TRANSFER)

	new_slime_brain.Insert(human_holder, special = TRUE, movement_flags = NO_ID_TRANSFER)
	to_chat(human_holder, span_warning(LANG("datum.91ce5813", null)))
	if(old_brain)
		old_brain.moveToNullspace()
		STOP_PROCESSING(SSobj, old_brain)
	if(old_stomach.is_oversized) // don't override augments that are already oversized
		oversized_quirk.old_organs -= old_stomach
		qdel(new_slime_stomach)
		return
	new_slime_stomach.Insert(human_holder, special = TRUE)
	to_chat(human_holder, span_warning(LANG("datum.c15bf254", null)))
	if(old_stomach)
		old_stomach.moveToNullspace()
		STOP_PROCESSING(SSobj, old_stomach)

/obj/item/organ/eyes/jelly
	name = "photosensitive eyespots"
	zone = BODY_ZONE_CHEST
	organ_flags = ORGAN_ORGANIC | ORGAN_UNREMOVABLE

/obj/item/organ/eyes/roundstartslime
	name = "photosensitive eyespots"
	zone = BODY_ZONE_CHEST
	organ_flags = ORGAN_ORGANIC | ORGAN_UNREMOVABLE

/obj/item/organ/ears/jelly
	name = "core audiosomes"
	zone = BODY_ZONE_CHEST
	organ_flags = ORGAN_ORGANIC | ORGAN_UNREMOVABLE

/obj/item/organ/tongue/jelly
	zone = BODY_ZONE_CHEST
	organ_flags = ORGAN_ORGANIC | ORGAN_UNREMOVABLE

/obj/item/organ/lungs/slime
	zone = BODY_ZONE_CHEST
	organ_flags = ORGAN_ORGANIC | ORGAN_UNREMOVABLE

/obj/item/organ/liver/slime
	name = "endoplasmic reticulum"
	zone = BODY_ZONE_CHEST
	organ_flags = ORGAN_ORGANIC | ORGAN_UNREMOVABLE

// CHEMICAL HANDLING
// Here's where slimes heal off plasma and where they hate drinking water.
/obj/item/organ/liver/slime/handle_chemical(mob/living/carbon/organ_owner, datum/reagent/chem, seconds_per_tick)
	. = ..()
	if(. & COMSIG_MOB_STOP_REAGENT_TICK)
		return
	// slimes use plasma to fix wounds, and if they have enough blood, organs
	var/static/list/organs_we_mend = list(
		ORGAN_SLOT_BRAIN,
		ORGAN_SLOT_LUNGS,
		ORGAN_SLOT_LIVER,
		ORGAN_SLOT_STOMACH,
		ORGAN_SLOT_EYES,
		ORGAN_SLOT_EARS,
	)
	if(chem.type == /datum/reagent/toxin/plasma || chem.type == /datum/reagent/toxin/hot_ice)
		for(var/datum/wound/iter_wound as anything in organ_owner.all_wounds)
			iter_wound.on_xadone(2 * seconds_per_tick)
			organ_owner.reagents.remove_reagent(chem.type, min(chem.volume * 0.22, 10))
		if(organ_owner.get_blood_volume() > BLOOD_VOLUME_SLIME_SPLIT)
			organ_owner.adjust_organ_loss(
				pick(organs_we_mend),
				- 2 * seconds_per_tick,
			)
		if(SPT_PROB(5, seconds_per_tick))
			to_chat(organ_owner, span_purple(LANG("obj.9ebc9628", null)))

	if(chem.type == /datum/reagent/water)
		if (HAS_TRAIT(organ_owner, TRAIT_SLIME_HYDROPHOBIA) || HAS_TRAIT(organ_owner, TRAIT_WATER_BREATHING))
			return

		organ_owner.adjust_blood_volume(-3 * seconds_per_tick)
		organ_owner.reagents.remove_reagent(chem.type, min(chem.volume * 0.22, 10))
		if(SPT_PROB(1, seconds_per_tick))
			to_chat(organ_owner, span_warning(LANG("obj.68ac02fb", null)))
		return COMSIG_MOB_STOP_REAGENT_TICK

/obj/item/organ/stomach/slime
	name = "golgi apparatus"
	zone = BODY_ZONE_CHEST
	organ_flags = ORGAN_ORGANIC | ORGAN_UNREMOVABLE

/obj/item/organ/brain/slime
	name = "core"
	desc = "The central core of a slimeperson, technically their 'extract.' Where the cytoplasm, membrane, and organelles come from; perhaps this is also a mitochondria?"
	zone = BODY_ZONE_CHEST
	/// This is the VFX for what happens when they melt and die.
	var/obj/effect/death_melt_type = /obj/effect/temp_visual/wizard/out
	/// Color of the slimeperson's 'core' brain, defaults to white.
	var/core_color = COLOR_WHITE
	icon = 'modular_nova/master_files/icons/obj/surgery.dmi'
	icon_state = "slime_core"
	/// This tracks whether their core has been ejected or not after they die.
	var/core_ejected = FALSE
	/// This tracks whether their GPS microchip is enabled or not, only becomes TRUE on activation of the below ability /datum/action/innate/core_signal.
	var/gps_active = FALSE
	throw_range = 9 //Oh! That's a baseball!
	throw_speed = 0.5
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | LAVA_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF

/obj/item/organ/brain/slime/Initialize(mapload, mob/living/carbon/organ_owner, list/examine_list)
	. = ..()
	AddComponent(/datum/component/bubble_icon_override, "slime", BUBBLE_ICON_PRIORITY_ORGAN)
	colorize()

/obj/item/organ/brain/slime/examine()
	. = ..()
	if(gps_active)
		. += span_notice(LANG("obj.aa31eb1a", null))
		. += span_red(LANG("obj.a2d21aa5", null))
	. += span_hypnophrase(LANG("obj.4b1d2628", null))

/obj/item/organ/brain/slime/attack_self(mob/living/user) // Allows a player (presumably an antag) to deactivate the GPS signal on a slime core
	if(!(gps_active))
		return
	user.visible_message(span_warning(LANG("obj.3c0f539e", list(user, user.p_their()))),
	span_notice(LANG("obj.55e6dfc3", null)),
	span_notice(LANG("obj.a3a10a91", null))
	)
	playsound(user, 'sound/items/handling/surgery/organ1.ogg', 80, TRUE)

	if(!do_after(user, 30 SECONDS, src))
		user.visible_message(span_warning(LANG("obj.8af75bd6", list(user, user.p_they()))),
		span_warning(LANG("obj.b4e3b9f8", null)),
		span_notice(LANG("obj.6619863a", null))
		)
		return

	user.visible_message(span_warning(LANG("obj.348c75bd", list(user))),
	span_notice(LANG("obj.800ce2fd", null)),
	span_notice(LANG("obj.fce3336c", null)))
	playsound(user, 'sound/effects/wounds/crackandbleed.ogg', 80, TRUE)
	gps_active = FALSE
	qdel(GetComponent(/datum/component/gps))

/obj/item/organ/brain/slime/on_mob_insert(mob/living/carbon/organ_owner, special = FALSE, movement_flags)
	. = ..()
	colorize()
	core_ejected = FALSE
	RegisterSignal(organ_owner, COMSIG_LIVING_DEATH, PROC_REF(on_slime_death))

/obj/item/organ/brain/slime/on_mob_remove(mob/living/carbon/organ_owner)
	. = ..()
	UnregisterSignal(organ_owner, list(COMSIG_LIVING_DEATH, COMSIG_MOB_LOGIN))

/**
* Colors the slime's core (their brain) the same as their first mutant color.
*/
/obj/item/organ/brain/slime/proc/colorize()
	if(owner && isjellyperson(owner))
		core_color = owner.dna.features[FEATURE_MUTANT_COLOR]
		add_atom_colour(core_color, FIXED_COLOUR_PRIORITY)

/**
* Handling for tracking when the slime in question dies (except through gibbing), which then segues into the core ejection proc.
*/
/obj/item/organ/brain/slime/proc/on_slime_death(mob/living/victim, gibbed)
	SIGNAL_HANDLER
	UnregisterSignal(victim, COMSIG_LIVING_DEATH)

	if(gibbed)
		core_ejection(victim)
		return

	addtimer(CALLBACK(src, PROC_REF(core_ejection), victim), 0) // explode them after the current proc chain ends, to avoid weirdness

/**
* CORE EJECTION PROC -
* Makes it so that when a slime dies, their core ejects and their body is qdel'd.
*/
/obj/item/organ/brain/slime/proc/core_ejection(mob/living/victim, new_stat, turf/loc_override)
	if(core_ejected)
		return
	core_ejected = TRUE

	var/atom/death_loc = victim.drop_location()
	if(!death_loc)
		death_loc = get_turf(victim) // Fallback to avoid the Slime core showing up in Nullspace.

	// Drop their equipment, Brain/Core, and implants to the floor.
	victim.unequip_everything()
	src.Remove(victim, special = TRUE) // Brain/Core
	for(var/obj/item/implant/implants in victim) // Implants
		implants.forceMove(death_loc)

	// Move the Brain/Core, and implants to the death location.
	if(death_loc)
		forceMove(death_loc)

	// Cleans up spilled organs - When a mob is attacked, it has a chance to spill all its organs on the ground upon death, for slime people we do not need their organs as they regain them when they get revived.
	for(var/obj/item/organ/spilled_organ in death_loc)
		if(istype(spilled_organ, /obj/item/organ/brain) || istype(spilled_organ, /obj/item/implant))
			continue
		else
			qdel(spilled_organ)

	src.wash(CLEAN_WASH)
	new death_melt_type(death_loc, victim.dir)

	do_steam_effects(death_loc)
	playsound(death_loc, 'sound/effects/blob/blobattack.ogg', 80, TRUE)

	if(gps_active) // adding the gps signal if they have activated the ability
		AddComponent(/datum/component/gps, "[victim]'s Core")

	// Message the victim and the surrounding area that they have died.
	victim.visible_message(span_warning(LANG("obj.c7e30e8b", list(victim))), span_notice(LANG("obj.94d10721", null)), span_notice(LANG("obj.e2a17a4f", null)))
	qdel(victim) // Remove the Body.
	UnregisterSignal(victim, COMSIG_LIVING_DEATH)

/**
* Procs the ethereal jaunt liquid effect when the slime dissolves on death.
*/
/obj/item/organ/brain/slime/proc/do_steam_effects(turf/loc)
	var/datum/effect_system/basic/steam_spread/steam = new(loc, 10, FALSE)
	steam.start()

/**
* CHECK FOR REPAIR SECTION
* Makes it so that when a slime's core has plasma poured on it, it builds a new body and moves the brain into it.
*/
/obj/item/organ/brain/slime/check_for_repair(obj/item/item, mob/user)
	if(!item.is_drainable() || item.reagents.get_reagent_amount(/datum/reagent/toxin/plasma) < 100)
		return FALSE
	user.visible_message(
		span_notice(LANG("obj.0f5d3e98", list(user, item, src))),
		span_notice(LANG("obj.07336e74", list(item, src)))
	)
	brainmob?.notify_revival("You are being revived!", sound = null, source = src) // no sound since it's a whopping 60 second wait time after this
	if(!do_after(user, 15 SECONDS, src))
		to_chat(user, span_warning(LANG("obj.6c40dd89", list(item, src))))
		return FALSE

	user.visible_message(
		span_notice(LANG("obj.ab769762", list(user, item, src))),
		span_notice(LANG("obj.d05535be", list(item, src)))
	)
	if(isnull(brainmob))
		user.balloon_alert(user, LANG("obj.4af1ada2", null))
		return FALSE
	brainmob.grab_ghost()
	if(isnull(brainmob.stored_dna))
		user.balloon_alert(user, LANG("obj.6423b615", null))
		return FALSE
	if(isnull(brainmob.client))
		user.balloon_alert(user, LANG("obj.6602fdbf", null))
		return FALSE

	item.reagents.remove_reagent(/datum/reagent/toxin/plasma, 100) // Consumes the plasma
	regenerate()
	return TRUE

/**
* SLIME REVIVE PROC
* This heals the core/brain, and creates a new body which we move the player/client into.
*/
/obj/item/organ/brain/slime/proc/regenerate()
	//we have the plasma. we can rebuild them.
	set_organ_damage(-maxHealth) //fully heals the brain
	if(gps_active) // making sure the gps signal is removed if it's active on revival
		gps_active = FALSE
		qdel(GetComponent(/datum/component/gps))

	// Create a new body and spawn it on the Brain/Core, than register the signal for the player to be inserted into the new body.
	var/mob/living/carbon/human/body = new(src.drop_location())
	RegisterSignal(body, COMSIG_MOB_LOGIN, PROC_REF(on_gained_client))

	// Move the brain/core back into the body.
	src.replace_into(body)

	// Notify the player that their body has been rebuilt
	body.visible_message(span_warning(LANG("obj.6889a589", list(body, body.p_their()))))
	to_chat(owner, span_purple(LANG("obj.25459c26", null)))
	return TRUE

/**
* APPLY PREFRENCES & QUIRKS AND OTHER EDITS
* When we gain a client, apply the prefrences, and apply quirks without spawning items.
* In addition Remove their underwear, their non-chest limbs, and give them some extra blood for slime limb regen.
*/
/obj/item/organ/brain/slime/proc/on_gained_client(mob/living/source)
	SIGNAL_HANDLER
	if(!source.client)
		return

	// Handle Prefrences & Quirks.
	var/datum/preferences/prefs = source.client.prefs || source.mind?.current?.client.prefs
	if(prefs)
		prefs.apply_prefs_to(source)
		// Handle Quirks without spawning items.
		for(var/quirks in prefs.all_quirks)
			var/datum/quirk/quirk_path = SSquirks.quirks[quirks]
			if(quirk_path)
				source.add_quirk(quirk_path, add_unique = FALSE)

	var/mob/living/carbon/human/body = source
	// Ensure they appear fully nude when revived, since slimes don't regrow clothes.
	body.underwear = "Nude"
	body.bra = "Nude"
	body.undershirt = "Nude"
	body.socks = "Nude"

	// Handle Blood, We give them extra blood so they can regenerate their limbs as soon as they are revived.
	body.set_blood_volume(BLOOD_VOLUME_SAFE + 60)

	// Remove non-chest limbs, they can use their regenerate ability to regain their limbs.
	for(var/obj/item/bodypart/part in body.bodyparts)
		if(part.body_zone == BODY_ZONE_CHEST)
			continue
		part.drop_limb(TRUE)

	UnregisterSignal(source, COMSIG_MOB_LOGIN)

// HEALING SECTION
// Handles passive healing and water damage for slimes and water-breathing variants.
/datum/species/jelly/proc/on_life(mob/living/carbon/human/slime, seconds_per_tick)
	SIGNAL_HANDLER

	// Skip if unconscious
	if(IS_UNCONSCIOUS_OR_CRIT(slime))
		return

	var/healing = TRUE

	// Get wetness effect if it exists
	var/datum/status_effect/fire_handler/wet_stacks/wetness = locate() in slime.status_effects
	var/wetness_amount = 0
	if(istype(wetness))
		wetness_amount = wetness.stacks

	// Skip if hydrophobic
	if(HAS_TRAIT(slime, TRAIT_SLIME_HYDROPHOBIA))
		return

	// Determine if water-breathing logic should be inverted
	var/inverted = HAS_TRAIT(slime, TRAIT_WATER_BREATHING)
	var/blood_units_to_lose = 0

	if(inverted)
		// Water-breathing slimes: damaged when dry, heal only when wet
		if(wetness_amount <= REGEN_WATER_STACKS)
			blood_units_to_lose = 2 * seconds_per_tick
			healing = FALSE
			if(SPT_PROB(25, seconds_per_tick))
				slime.visible_message(
					span_danger(LANG("datum.9420f814", list(slime))),
					span_warning(LANG("datum.7b41fefc", null)),
				)

	else
		// Normal slimes: damaged when too wet, cannot heal if too wet
		if(wetness_amount > DAMAGE_WATER_STACKS)
			blood_units_to_lose += 2 * seconds_per_tick
			if(SPT_PROB(25, seconds_per_tick))
				slime.visible_message(
					span_danger(LANG("datum.96f776e1", list(slime))),
					span_warning(LANG("datum.6ff37823", null)),
				)
		if(wetness_amount > REGEN_WATER_STACKS)
			healing = FALSE
			blood_units_to_lose += 1 * seconds_per_tick
			if(SPT_PROB(1, seconds_per_tick))
				to_chat(slime, span_warning(LANG("datum.f1cfa42c", null)))

	slime.adjust_blood_volume(-blood_units_to_lose)

	// PASSIVE HEALING
	if(slime.get_blood_volume() >= BLOOD_VOLUME_NORMAL && healing)
		if(IS_UNCONSCIOUS_OR_CRIT(slime))
			return
		var/need_mob_update
		need_mob_update += slime.heal_overall_damage(brute = SPECIES_SLIME_PASSIVE_REGEN_BRUTE * seconds_per_tick, burn = SPECIES_SLIME_PASSIVE_REGEN_BURN * seconds_per_tick, updating_health = FALSE, required_bodytype = BODYTYPE_ORGANIC)
		need_mob_update += slime.adjust_oxy_loss(-1 * seconds_per_tick, updating_health = FALSE)
		if(need_mob_update)
			slime.updatehealth()
		if(slime.health < slime.maxHealth)
			new /obj/effect/temp_visual/heal(get_turf(slime), COLOR_EFFECT_HEAL_RED)

/**
* SLIME CLEANING ABILITY -
* When toggled, slimes clean themselves and their equipment.
*/
/datum/action/cooldown/spell/slime_washing
	name = "Toggle Slime Cleaning"
	desc = "Filter grime through your outer membrane, cleaning yourself and your equipment for sustenance. Also cleans the floor, providing your feet are uncovered. For sustenance."
	button_icon = 'icons/mob/actions/actions_silicon.dmi'
	button_icon_state = "activate_wash"

	cooldown_time = 1 SECONDS
	spell_requirements = NONE

/datum/action/cooldown/spell/slime_washing/cast(mob/living/carbon/human/user = usr)
	. = ..()

	if(user.has_status_effect(/datum/status_effect/slime_washing))
		slime_washing_deactivate(user)
		return

	user.apply_status_effect(/datum/status_effect/slime_washing)
	user.visible_message(span_purple(LANG("datum.16c42ded", list(user, user.p_their()))), span_purple(LANG("datum.fb262fdc", null)))

/**
* Called when you activate it again after casting the ability-- turning it off, so to say.
*/
/datum/action/cooldown/spell/slime_washing/proc/slime_washing_deactivate(mob/living/carbon/human/user)
	if(!user.has_status_effect(/datum/status_effect/slime_washing))
		return

	user.remove_status_effect(/datum/status_effect/slime_washing)
	user.visible_message(span_notice(LANG("datum.e9972be8", list(user, user.p_their()))), span_notice(LANG("datum.6fea04cc", null)))

/datum/status_effect/slime_washing
	id = "slime_washing"
	alert_type = null
	status_type = STATUS_EFFECT_UNIQUE

/datum/status_effect/slime_washing/tick(seconds_between_ticks, seconds_per_tick)
	if(ishuman(owner))
		var/mob/living/carbon/human/slime_person = owner

		slime_person.wash(CLEAN_WASH) // Wash ourselves and all uncovered clothing

		if((slime_person.wear_suit?.body_parts_covered | slime_person.w_uniform?.body_parts_covered | slime_person.shoes?.body_parts_covered) & FEET)
			return
		else
			var/turf/open/open_turf = get_turf(slime_person)
			if(istype(open_turf))
				open_turf.wash(CLEAN_WASH)
				return TRUE
			if(SPT_PROB(5, seconds_per_tick))
				slime_person.adjust_nutrition((rand(5,25)))

/datum/status_effect/slime_washing/get_examine_text()
	return span_notice("[owner.p_Their()] outer layer is pulling in grime, filth sinking inside of [owner.p_their()] body and vanishing.")

/*
* HYDROPHOBIA SPELL
* Makes it so that slimes are waterproof, but slower, and they don't regenerate.
*/
/datum/action/cooldown/spell/slime_hydrophobia
	name = "Toggle Hydrophobia"
	desc = "Develop an oily layer on your outer membrane, repelling water at the cost of lower viscosity."
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "bci_shield"

	cooldown_time = 1 MINUTES
	spell_requirements = NONE

/datum/action/cooldown/spell/slime_hydrophobia/cast(mob/living/carbon/human/user = usr)
	. = ..()

	if(user.has_status_effect(/datum/status_effect/slime_hydrophobia))
		slime_hydrophobia_deactivate(user)
		return

	ADD_TRAIT(user, TRAIT_SLIME_HYDROPHOBIA, ACTION_TRAIT)
	user.apply_status_effect(/datum/status_effect/slime_hydrophobia)
	user.visible_message(span_purple(LANG("datum.21b99687", list(user, owner.p_their()))), span_purple(LANG("datum.d5999846", null)))

/**
* Called when you activate it again after casting the ability-- turning it off, so to say.
*/
/datum/action/cooldown/spell/slime_hydrophobia/proc/slime_hydrophobia_deactivate(mob/living/carbon/human/user)
	if(!user.has_status_effect(/datum/status_effect/slime_hydrophobia))
		return

	REMOVE_TRAIT(user, TRAIT_SLIME_HYDROPHOBIA, ACTION_TRAIT)
	user.remove_status_effect(/datum/status_effect/slime_hydrophobia)
	user.visible_message(span_purple(LANG("datum.c8afeadf", list(user, owner.p_their()))), span_purple(LANG("datum.ac76ad39", null)))

/datum/movespeed_modifier/status_effect/slime_hydrophobia
	multiplicative_slowdown = 1.5

/datum/status_effect/slime_hydrophobia
	id = "slime_hydrophobia"
	alert_type = null
	status_type = STATUS_EFFECT_UNIQUE

/datum/status_effect/slime_hydrophobia/on_apply()
	. = ..()
	owner.add_movespeed_modifier(/datum/movespeed_modifier/status_effect/slime_hydrophobia, update=TRUE)

/datum/status_effect/slime_hydrophobia/on_remove()
	. = ..()
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/status_effect/slime_hydrophobia, update=TRUE)

/datum/status_effect/slime_hydrophobia/get_examine_text()
	return span_notice("[owner.p_They()] is oozing out an oily coating onto [owner.p_their()] outer membrane, water rolling right off.")

/datum/species/jelly/get_species_description()
	return placeholder_description

/datum/species/jelly/get_species_lore()
	return list(placeholder_lore)

/datum/species/jelly/roundstartslime
	name = "Xenobiological Slime Hybrid"
	id = SPECIES_SLIMESTART
	examine_limb_id = SPECIES_SLIMEPERSON
	coldmod = 3
	heatmod = 1
	specific_alpha = 155
	markings_alpha = 130 //This is set lower than the other so that the alpha values don't stack on top of each other so much
	mutanteyes = /obj/item/organ/eyes/roundstartslime
	mutanttongue = /obj/item/organ/tongue/jelly

	bodypart_overrides = list( //Overriding jelly bodyparts
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/jelly/slime/roundstart,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/jelly/slime/roundstart,
		BODY_ZONE_HEAD = /obj/item/bodypart/head/jelly/slime/roundstart,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/jelly/slime/roundstart,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/jelly/slime/roundstart,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/jelly/slime/roundstart,
	)

/datum/species/jelly/roundstartslime/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "scissors",
			SPECIES_PERK_NAME = LANG("datum.6c59985a", null),
			SPECIES_PERK_DESC = LANG("datum.a3761f0c", null),
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "circle",
			SPECIES_PERK_NAME = LANG("datum.33cb6963", null),
			SPECIES_PERK_DESC = LANG("datum.1b47ae9d", null),
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "notes-medical",
			SPECIES_PERK_NAME = LANG("datum.a911d5ba", null),
			SPECIES_PERK_DESC = LANG("datum.f1fe17b1", null),
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "droplet-slash",
			SPECIES_PERK_NAME = LANG("datum.72927f15", null),
			SPECIES_PERK_DESC = LANG("datum.1359f561", null),
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "hand-holding-droplet",
			SPECIES_PERK_NAME = LANG("datum.b9b1a1ea", null),
			SPECIES_PERK_DESC = LANG("datum.97228a5b", null),
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "person-swimming",
			SPECIES_PERK_NAME = LANG("datum.7d4f88a6", null),
			SPECIES_PERK_DESC = LANG("datum.b0926c88", null),
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "person-booth",
			SPECIES_PERK_NAME = LANG("datum.05db1dd9", null),
			SPECIES_PERK_DESC = LANG("datum.b1aa5166", null),
		),
	)

	return to_add

/datum/species/jelly/roundstartslime/apply_supplementary_body_changes(mob/living/carbon/human/target, datum/preferences/preferences, visuals_only = FALSE)
	if(preferences.read_preference(/datum/preference/toggle/allow_mismatched_hair_color))
		target.dna.species.hair_color_mode = null

/**
 * Alter Form is the ability of slimes to edit many of their character attributes at will
 * This covers most thing about their character, from body size or colour, to adding new wings, tails, ears, etc, to changing the presence of their genitalia
 * There are some balance concerns with some of these (looking at you, body size), but nobody has abused it Yet:tm:, and it would be exceedingly obvious if they did
 */
/datum/action/innate/alter_form
	name = "Alter Form"
	check_flags = AB_CHECK_CONSCIOUS
	button_icon_state = "alter_form"
	button_icon = SLIME_ACTIONS_ICON_FILE
	background_icon_state = "bg_alien"
	/// Do you need to be a slime-person to use this ability?
	var/slime_restricted = TRUE
	///Is the person using this ability oversized?
	var/oversized_user = FALSE
	///What text is shown to others when the person uses the ability?
	var/shapeshift_text = "gains a look of concentration while standing perfectly still. Their body seems to shift and starts getting more goo-like."
	///List containing all of the available parts
	var/static/list/available_choices
	/// Icon for "Body Colors" alteration button.
	var/bodycolours_icon
	/// Icon for "DNA" alteration button.
	var/dna_icon
	/// Icon for "Hair" alteration button.
	var/hair_icon
	/// Icon for "Markings" alteration button.
	var/markings_icon
	/// Icon for "Primary Colour" alteration button.
	var/primarycolour_icon
	/// Icon for "Secondary Colour" alteration button.
	var/secondarycolour_icon
	/// Icon for "Tertiary Colour" alteration button.
	var/tertiarycolour_icon
	/// Icon for "All Colours" alteration button.
	var/allcolours_icon
	/// Icon for "Facial Hair" alteration button.
	var/facialhair_icon
	/// Icon for "Hair Colour" alteration button.
	var/haircolour_icon

/datum/action/innate/alter_form/proc/generate_radial_icons()
	bodycolours_icon = image(icon = SLIME_ACTIONS_ICON_FILE, icon_state = "slime_rainbow")
	dna_icon = image(icon = SLIME_ACTIONS_ICON_FILE, icon_state = "dna")
	hair_icon = image(icon = SLIME_ACTIONS_ICON_FILE, icon_state = "scissors")
	markings_icon = image(icon = SLIME_ACTIONS_ICON_FILE, icon_state = "rainbow_spraycan")
	primarycolour_icon = image(icon = SLIME_ACTIONS_ICON_FILE, icon_state = "slime_red")
	secondarycolour_icon = image(icon = SLIME_ACTIONS_ICON_FILE, icon_state = "slime_green")
	tertiarycolour_icon = image(icon = SLIME_ACTIONS_ICON_FILE, icon_state = "slime_blue")
	allcolours_icon = image(icon = SLIME_ACTIONS_ICON_FILE, icon_state = "slime_rainbow")
	facialhair_icon = image(icon = SLIME_ACTIONS_ICON_FILE, icon_state = "straight_razor")
	haircolour_icon = image(icon = SLIME_ACTIONS_ICON_FILE, icon_state = "rainbow_spraycan")

/datum/action/innate/alter_form/New(Target)
	. = ..()

	generate_radial_icons()

	if(length(available_choices))
		return

	available_choices = deep_copy_list(SSaccessories.sprite_accessories)
	for(var/parts_list in available_choices)
		for(var/parts in available_choices[parts_list])
			var/datum/sprite_accessory/part = available_choices[parts_list][parts]
			if(part.locked)
				available_choices[parts_list] -= parts

/datum/action/innate/alter_form/unrestricted
	slime_restricted = FALSE

/datum/action/innate/alter_form/Activate()
	var/mob/living/carbon/human/alterer = owner
	if(slime_restricted && !isjellyperson(alterer))
		return
	alterer.visible_message(
		span_notice("[owner] [shapeshift_text]"),
		span_notice(LANG("datum.77be045a", null))
	)
	change_form(alterer)

/**
 * Change form is the initial proc when using the alter form action
 * It brings up a radial menu to allow you to pick what about your character it is that you want to edit
 * Each of these radial menus should be kept from being too long where possible, really
 */
/datum/action/innate/alter_form/proc/change_form(mob/living/carbon/human/alterer)
	var/selected_alteration = show_radial_menu(
		alterer,
		alterer,
		list(
			"Body Colours" = bodycolours_icon,
			"DNA" = dna_icon,
			"Hair" = hair_icon,
			"Markings" = markings_icon,
		),
		tooltips = TRUE,
	)
	if(!selected_alteration)
		return
	switch(selected_alteration)
		if("Body Colours")
			if(HAS_TRAIT(alterer, TRAIT_USES_SKINTONES))
				alter_skin_colours(alterer)
			else
				alter_colours(alterer)
		if("DNA")
			alter_dna(alterer)
		if("Hair")
			alter_hair(alterer)
		if("Markings")
			alter_markings(alterer)

/**
 * Alter skin colours handles the changing of skintone colours
 * This affects skin tone only.
 */
/datum/action/innate/alter_form/proc/alter_skin_colours(mob/living/carbon/human/alterer)
	var/skintone_string = tgui_input_list(
		alterer,
		LANG("datum.dfb6cc1e", null),
		LANG("datum.7aaef146", null),
		GLOB.skin_tone_names
	)

	if(!skintone_string)
		return

	var/skintone_index = GLOB.skin_tone_names.Find(skintone_string)

	if(!skintone_index)
		return

	var/selected_skintone = GLOB.skin_tones[skintone_index]

	alterer.skin_tone = selected_skintone
	alterer.dna.features[FEATURE_SKIN_COLOR] = skintone2hex(selected_skintone)
	alterer.dna.update_uf_block(/datum/dna_block/feature/mutant_color/skin_color)
	alterer.update_body(is_creating = TRUE)

/**
 * Alter colours handles the changing of mutant colours
 * This affects skin tone primarily, though has the option to change hair, markings, and mutant body parts to match
 */
/datum/action/innate/alter_form/proc/alter_colours(mob/living/carbon/human/alterer)
	var/color_choice = show_radial_menu(
		alterer,
		alterer,
		list(
			"Primary" = primarycolour_icon,
			"Secondary" = secondarycolour_icon,
			"Tertiary" = tertiarycolour_icon,
			"All" = allcolours_icon,
		),
		tooltips = TRUE,
	)
	if(!color_choice)
		return
	var/color_target
	switch(color_choice)
		if("Primary", "All")
			color_target = FEATURE_MUTANT_COLOR
		if("Secondary")
			color_target = FEATURE_MUTANT_COLOR_TWO
		if("Tertiary")
			color_target = FEATURE_MUTANT_COLOR_THREE

	var/new_mutant_colour = tgui_color_picker(
		alterer,
		"Choose your character's new [color_choice = "All" ? "" : LOWER_TEXT(color_choice)] color:",
		"Form Alteration",
		alterer.dna.features[color_target]
	)
	if(!new_mutant_colour)
		return

	var/marking_reset = tgui_alert(
		alterer,
		LANG("datum.1b099a27", null),
		LANG("datum.9439a802", null),
		list("Yes", "No"),
	)
	var/mutant_part_reset = tgui_alert(
		alterer,
		LANG("datum.69e2f7b0", null),
		LANG("datum.78c4118f", null),
		list("Yes", "No"),
	)
	var/hair_reset = tgui_alert(
		alterer,
		LANG("datum.d9a5dee1", null),
		LANG("datum.9ced8c05", null),
		list("Hair", "Facial Hair", "Both", SPRITE_ACCESSORY_NONE),
	)

	if(color_choice == "All")
		alterer.dna.features[FEATURE_MUTANT_COLOR] = sanitize_hexcolor(new_mutant_colour)
		alterer.dna.features[FEATURE_MUTANT_COLOR_TWO] = sanitize_hexcolor(new_mutant_colour)
		alterer.dna.features[FEATURE_MUTANT_COLOR_THREE] = sanitize_hexcolor(new_mutant_colour)
		alterer.dna.update_uf_block(/datum/dna_block/feature/mutant_color)
		alterer.dna.update_uf_block(/datum/dna_block/feature/mutant_color/two)
		alterer.dna.update_uf_block(/datum/dna_block/feature/mutant_color/three)
	else
		alterer.dna.features[color_target] = sanitize_hexcolor(new_mutant_colour)
		switch(color_target)
			if(FEATURE_MUTANT_COLOR)
				alterer.dna.update_uf_block(/datum/dna_block/feature/mutant_color)
			if(FEATURE_MUTANT_COLOR_TWO)
				alterer.dna.update_uf_block(/datum/dna_block/feature/mutant_color/two)
			if(FEATURE_MUTANT_COLOR_THREE)
				alterer.dna.update_uf_block(/datum/dna_block/feature/mutant_color/three)

	if(marking_reset == "Yes")
		for(var/zone in alterer.dna.body_markings)
			for(var/key in alterer.dna.body_markings[zone])
				var/datum/body_marking/iterated_marking = GLOB.body_markings[key]
				if(iterated_marking.always_color_customizable)
					continue
				alterer.dna.body_markings[zone][key] = iterated_marking.get_default_color(alterer.dna.features, alterer.dna.species)

	if(mutant_part_reset == "Yes")
		alterer.mutant_renderkey = "" //Just in case
		for(var/mutant_key, mutant_bodypart in alterer.dna.mutant_bodyparts)
			var/datum/mutant_bodypart/bodypart = mutant_bodypart
			var/datum/sprite_accessory/changed_accessory = SSaccessories.sprite_accessories[mutant_key][bodypart.name]
			bodypart.set_colors(changed_accessory.get_default_color(alterer.dna.features, alterer.dna.species))

	if(hair_reset)
		switch(hair_reset)
			if("Hair")
				alterer.hair_color = sanitize_hexcolor(new_mutant_colour)
				alterer.update_hair()
			if("Facial Hair")
				alterer.facial_hair_color = sanitize_hexcolor(new_mutant_colour)
				alterer.update_hair()
			if("Both")
				alterer.hair_color = sanitize_hexcolor(new_mutant_colour)
				alterer.facial_hair_color = sanitize_hexcolor(new_mutant_colour)
				alterer.update_hair()

	alterer.update_body(is_creating = TRUE)

/**
 * Alter hair lets you adjust both the hair on your head as well as your facial hair
 * You can adjust the style of either
 */
/datum/action/innate/alter_form/proc/alter_hair(mob/living/carbon/human/alterer)
	var/target_hair = show_radial_menu(
		alterer,
		alterer,
		list(
			"Hair" = hair_icon,
			"Facial Hair" = facialhair_icon,
			"Hair Color" = haircolour_icon,
		),
		tooltips = TRUE,
	)
	if(!target_hair)
		return
	switch(target_hair)
		if("Hair")
			var/new_style = tgui_input_list(owner, LANG("datum.2e464f6c", null), LANG("datum.68c7fd08", null), SSaccessories.hairstyles_list)
			if(new_style)
				alterer.set_hairstyle(new_style, update = TRUE)
		if("Facial Hair")
			var/new_style = tgui_input_list(alterer, LANG("datum.df720244", null), LANG("datum.68c7fd08", null), SSaccessories.facial_hairstyles_list)
			if(new_style)
				alterer.set_facial_hairstyle(new_style, update = TRUE)
		if("Hair Color")
			var/hair_area = tgui_alert(alterer, LANG("datum.a2fbdd01", null), LANG("datum.acfbf5c7", null), list("Hairstyle", "Facial Hair", "Both"))
			if(!hair_area)
				return
			var/new_hair_color = tgui_color_picker(alterer, "Select your new hair color", "Hair Color Alterations", alterer.dna.features[FEATURE_MUTANT_COLOR])
			if(!new_hair_color)
				return

			switch(hair_area)

				if("Hairstyle")
					alterer.set_haircolor(sanitize_hexcolor(new_hair_color), update = TRUE)
				if("Facial Hair")
					alterer.set_facial_haircolor(sanitize_hexcolor(new_hair_color), update = TRUE)
				if("Both")
					alterer.set_haircolor(sanitize_hexcolor(new_hair_color), update = FALSE)
					alterer.set_facial_haircolor(sanitize_hexcolor(new_hair_color), update = TRUE)

/**
 * Alter DNA is an intermediary proc for the most part
 * It lets you pick between a few options for DNA specifics
 */
/datum/action/innate/alter_form/proc/alter_dna(mob/living/carbon/human/alterer)
	var/list/key_list = list("Body Size", "Genitals", "Mutant Parts")
	if(CONFIG_GET(flag/disable_erp_preferences))
		key_list.Remove("Genitals")
	var/dna_alteration = tgui_input_list(
		alterer,
		LANG("datum.00f45ca3", null),
		LANG("datum.a351df4f", null),
		key_list,
	)
	if(!dna_alteration)
		return
	switch(dna_alteration)
		if("Body Size")
			if(oversized_user && !HAS_TRAIT(alterer, TRAIT_OVERSIZED))
				var/reset_size = tgui_alert(alterer, LANG("datum.ad188441", null), LANG("datum.0eaf6f27", null), list("Yes", "No"))
				if(reset_size == "Yes")
					alterer.add_quirk(/datum/quirk/oversized)
					return

			var/new_body_size = tgui_input_number(
				alterer,
				LANG("datum.768912b9", list(BODY_SIZE_MIN * 100, BODY_SIZE_MAX * 100)),
				LANG("datum.0eaf6f27", null),
				default = min(alterer.dna.features["body_size"] * 100, BODY_SIZE_MAX * 100),
				max_value = BODY_SIZE_MAX * 100,
				min_value = BODY_SIZE_MIN * 100,
			)
			if(!new_body_size)
				return

			if(HAS_TRAIT(alterer, TRAIT_OVERSIZED))
				oversized_user = TRUE
				alterer.remove_quirk(/datum/quirk/oversized)

			new_body_size = new_body_size * 0.01
			alterer.dna.features["body_size"] = new_body_size
			alterer.dna.update_body_size()

		if("Genitals")
			alter_genitals(alterer)
		if("Mutant Parts")
			alter_parts(alterer)

	alterer.mutant_renderkey = "" //Just in case
	alterer.update_body_parts()

/**
 * Alter parts lets you adjust mutant bodyparts
 * This can be adding (or removing) things like ears, tails, wings, et cetera.
 */
/datum/action/innate/alter_form/proc/alter_parts(mob/living/carbon/human/alterer)
	var/list/mutant_part_list = list()
	for(var/datum/dna_block/feature/mutant/block as anything in subtypesof(/datum/dna_block/feature/mutant))
		if(CONFIG_GET(flag/disable_erp_preferences) && (block::feature_key in ORGAN_ERP_LIST))
			continue
		mutant_part_list[block::feature_key] = block
	var/chosen_key = tgui_input_list(
		alterer,
		LANG("datum.1afe48a5", null),
		LANG("datum.20a1aa5c", null),
		mutant_part_list,
	)
	if(!chosen_key)
		return

	var/choice_list = available_choices[chosen_key]
	var/chosen_name_key = tgui_input_list(
		alterer,
		LANG("datum.a3da619c", null),
		LANG("datum.20a1aa5c", null),
		choice_list,
	)
	if(!chosen_name_key)
		return

	var/datum/sprite_accessory/selected_sprite_accessory = SSaccessories.sprite_accessories[chosen_key][chosen_name_key]
	alterer.mutant_renderkey = "" //Just in case
	if(!selected_sprite_accessory.factual)
		if(selected_sprite_accessory.organ_type)
			var/obj/item/organ/organ_path = selected_sprite_accessory.organ_type
			var/slot = initial(organ_path.slot)
			var/obj/item/organ/got_organ = alterer.get_organ_slot(slot)
			if(got_organ)
				got_organ.Remove(alterer)
				qdel(got_organ)
		else
			var/obj/item/organ/got_organ = alterer.get_organ_slot(chosen_key)
			if(got_organ)
				got_organ.Remove(alterer)
				qdel(got_organ)
			else
				alterer.dna.mutant_bodyparts -= chosen_key
	else if(chosen_key == FEATURE_LEGS)
		alterer.dna.features[FEATURE_LEGS] = chosen_name_key
		alterer.update_body()
		alterer.dna.species.replace_body(alterer, alterer.dna.species) // TODO: Replace this with something less stupidly expensive.
	else
		if(selected_sprite_accessory.organ_type)
			var/robot_organs = HAS_TRAIT(alterer, TRAIT_ROBOTIC_DNA_ORGANS)

			var/obj/item/organ/organ_path = selected_sprite_accessory.organ_type
			var/slot = initial(organ_path.slot)
			var/obj/item/organ/got_organ = alterer.get_organ_slot(slot)
			if(got_organ)
				got_organ.Remove(alterer)
				qdel(got_organ)

			var/obj/item/organ/replacement_organ = SSwardrobe.provide_type(selected_sprite_accessory.organ_type)
			replacement_organ.sprite_accessory_flags = selected_sprite_accessory.flags_for_organ

			var/datum/mutant_bodypart/new_mutant_bodypart = build_mutant_part(
				selected_sprite_accessory.name,
				selected_sprite_accessory.get_default_color(alterer.dna.features, alterer.dna.species)
			)
			alterer.dna.mutant_bodyparts[chosen_key] = new_mutant_bodypart

			if(robot_organs)
				replacement_organ.organ_flags |= ORGAN_ROBOTIC
			replacement_organ.build_from_dna(alterer.dna, chosen_key)
			replacement_organ.Insert(alterer, special = TRUE, movement_flags = DELETE_IF_REPLACED)
		else
			var/datum/mutant_bodypart/new_mutant_bodypart = build_mutant_part(
				selected_sprite_accessory.name,
				selected_sprite_accessory.get_default_color(alterer.dna.features, alterer.dna.species)
			)
			alterer.dna.mutant_bodyparts[chosen_key] = new_mutant_bodypart

		alterer.dna.update_uf_block(mutant_part_list[chosen_key])
	alterer.update_body_parts()
	alterer.update_clothing(ALL) // for any clothing that has alternate versions (e.g. muzzled masks)

/**
 * Alter markings lets you add a particular body marking
 */
/datum/action/innate/alter_form/proc/alter_markings(mob/living/carbon/human/alterer)
	var/list/candidates = GLOB.body_marking_sets
	var/chosen_name = tgui_input_list(
		alterer,
		LANG("datum.c46516be", null),
		LANG("datum.9c8eed2d", null),
		candidates,
	)
	if(!chosen_name)
		return
	var/datum/body_marking_set/marking_set = GLOB.body_marking_sets[chosen_name]
	alterer.dna.body_markings = assemble_body_markings_from_set(marking_set, alterer.dna.features, alterer.dna.species)
	alterer.update_body(is_creating = TRUE)

/**
 * Alter genitals lets you adjust the size or functionality of genitalia
 * If you don't own the genital you try to adjust, it'll ask you if you want to add it first
 */
/datum/action/innate/alter_form/proc/alter_genitals(mob/living/carbon/human/alterer)
	var/list/genital_list
	if(alterer.get_organ_slot(ORGAN_SLOT_BREASTS))
		genital_list += list("Breasts Lactation", "Breasts Size")
	if(alterer.get_organ_slot(ORGAN_SLOT_PENIS))
		genital_list += list("Penis Girth", "Penis Length", "Penis Sheath", "Penis Taur Mode")
	if(alterer.get_organ_slot(ORGAN_SLOT_TESTICLES))
		genital_list += list("Testicles Size")
	if(!length(genital_list))
		alterer.balloon_alert(alterer, LANG("datum.e52cb7eb", null))

	var/dna_alteration = tgui_input_list(
		alterer,
		LANG("datum.be2e024f", null),
		LANG("datum.0954ca9b", null),
		genital_list
	)
	if(!dna_alteration)
		return
	switch(dna_alteration)
		if("Breasts Lactation")
			var/obj/item/organ/genital/breasts/melons = alterer.get_organ_slot(ORGAN_SLOT_BREASTS)
			alterer.dna.features["breasts_lactation"] = !alterer.dna.features["breasts_lactation"]
			melons.lactates = alterer.dna.features["breasts_lactation"]
			alterer.balloon_alert(alterer, "[alterer.dna.features["breasts_lactation"] ? "lactating" : "not lactating"]")

		if("Breasts Size")
			var/obj/item/organ/genital/breasts/melons = alterer.get_organ_slot(ORGAN_SLOT_BREASTS)
			var/new_size = tgui_input_list(
				alterer,
				LANG("datum.2fbf9488", null),
				LANG("datum.a351df4f", null),
				GLOB.breast_size_to_number,
			)
			if(!new_size)
				return
			alterer.dna.features["breasts_size"] = melons.breasts_cup_to_size(new_size)
			melons.set_size(alterer.dna.features["breasts_size"])

		if("Penis Girth")
			var/obj/item/organ/genital/penis/sausage = alterer.get_organ_slot(ORGAN_SLOT_PENIS)
			var/max_girth = PENIS_MAX_GIRTH
			if(alterer.dna.features["penis_size"] >= max_girth)
				max_girth = alterer.dna.features["penis_size"]
			var/new_girth = tgui_input_number(
				alterer,
				LANG("datum.761a4cc3", list(max_girth)),
				LANG("datum.78f80c29", null),
				max_value = max_girth,
				min_value = 1
			)
			if(new_girth)
				alterer.dna.features["penis_girth"] = new_girth
				sausage.girth = alterer.dna.features["penis_girth"]

		if("Penis Length")
			var/obj/item/organ/genital/penis/wang = alterer.get_organ_slot(ORGAN_SLOT_PENIS)
			var/new_length = tgui_input_number(
				alterer,
				LANG("datum.577a274c", list(PENIS_MIN_LENGTH, PENIS_MAX_LENGTH)),
				LANG("datum.a351df4f", null),
				max_value = PENIS_MAX_LENGTH,
				min_value = PENIS_MIN_LENGTH,
			)
			if(!new_length)
				return
			alterer.dna.features["penis_size"] = new_length
			if(alterer.dna.features["penis_girth"] >= new_length)
				alterer.dna.features["penis_girth"] = new_length - 1
				wang.girth = alterer.dna.features["penis_girth"]
			wang.set_size(alterer.dna.features["penis_size"])

		if("Penis Sheath")
			var/obj/item/organ/genital/penis/schlong = alterer.get_organ_slot(ORGAN_SLOT_PENIS)
			if(isnull(schlong))
				to_chat(alterer, span_warning(LANG("datum.26c7b6f4", null)))
				return
			var/datum/bodypart_overlay/mutant/genital/penis/our_overlay = schlong.bodypart_overlay
			var/datum/sprite_accessory/genital/penis/shaft = our_overlay?.shaft_datum
			if(!shaft?.can_have_sheath)
				to_chat(alterer, span_warning(LANG("datum.a39b5480", null)))
				return
			var/new_sheath = tgui_input_list(
				alterer,
				LANG("datum.a6d8073a", null),
				LANG("datum.a351df4f", null),
				assoc_to_keys(SSaccessories.sprite_accessories[FEATURE_SHEATH]),
			)
			if(!new_sheath)
				return
			alterer.dna.features["penis_sheath"] = new_sheath
			schlong.refresh_sheath()

		if("Penis Taur Mode")
			alterer.dna.features["penis_taur_mode"] = !alterer.dna.features["penis_taur_mode"]
			alterer.balloon_alert(alterer, "[alterer.dna.features["penis_taur_mode"] ? "using taur penis" : "not using taur penis"]")

		if("Testicles Size")
			var/obj/item/organ/genital/testicles/avocados = alterer.get_organ_slot(ORGAN_SLOT_TESTICLES)
			var/new_size = tgui_input_list(
				alterer,
				LANG("datum.4c74bfeb", null),
				LANG("datum.78f80c29", null),
				GLOB.preference_balls_sizes,
			)
			if(new_size)
				alterer.dna.features["balls_size"] = avocados.balls_description_to_size(new_size)
				avocados.set_size(alterer.dna.features["balls_size"])

/**
 * Toggle Death Signal simply adds and removes the trait required for slimepeople to transmit a GPS signal upon core ejection.
 */
/datum/action/innate/core_signal
	name = "Toggle Core Signal"
	desc = "Interface with the microchip placed in your core, modifying if it emits a GPS signal or not; due to how thick your liquid body is, the signal won't reach out until your core is outside of it."
	check_flags = AB_CHECK_CONSCIOUS
	button_icon = 'modular_nova/master_files/icons/obj/surgery.dmi'
	button_icon_state = "slime_core"
	background_icon_state = "bg_alien"
	/// Do you need to be a slime-person to use this ability?
	var/slime_restricted = TRUE

/datum/action/innate/core_signal/Activate()
	var/mob/living/carbon/human/slime = owner
	var/obj/item/organ/brain/slime/core = slime.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(slime_restricted && !isjellyperson(slime))
		return
	if(core.gps_active)
		to_chat(owner,span_notice(LANG("datum.a93c22e1", null)))
		core.gps_active = FALSE
	else
		to_chat(owner, span_notice(LANG("datum.ad1151d7", null)))
		core.gps_active = TRUE

#undef SLIME_ACTIONS_ICON_FILE
#undef DAMAGE_WATER_STACKS
#undef REGEN_WATER_STACKS
#undef SPECIES_SLIME_PASSIVE_REGEN_BRUTE
#undef SPECIES_SLIME_PASSIVE_REGEN_BURN
