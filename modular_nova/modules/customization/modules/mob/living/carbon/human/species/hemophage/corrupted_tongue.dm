/// Maximum an Hemophage will drain, they will drain less if they hit their cap.
#define HEMOPHAGE_DRAIN_AMOUNT 50
/// The multiplier for blood received by Hemophages out of humans with ckeys.
#define BLOOD_DRAIN_MULTIPLIER_CKEY 1.15

/datum/component/organ_corruption/tongue
	corruptable_organ_type = /obj/item/organ/tongue
	corrupted_icon_state = "tongue"


/datum/component/organ_corruption/tongue/corrupt_organ(obj/item/organ/corruption_target)
	. = ..()

	if(!.)
		return

	var/obj/item/organ/tongue/corrupted_tongue = corruption_target
	corrupted_tongue.liked_foodtypes = BLOODY
	corrupted_tongue.disliked_foodtypes = NONE

	var/datum/action/cooldown/hemophage/drain_victim/tongue_action = /datum/action/cooldown/hemophage/drain_victim
	for (var/datum/action/action as anything in corrupted_tongue.actions) // go through our actions and make sure we don't already have it
		if(action.type == tongue_action)
			return

	tongue_action = corruption_target.add_item_action(tongue_action)
	tongue_action.Grant(corruption_target.owner)


/datum/action/cooldown/hemophage/drain_victim
	name = "Drain Victim"
	desc = "Leech blood from any carbon victim you are passively grabbing."


/datum/action/cooldown/hemophage/drain_victim/Activate(atom/target)
	if(!iscarbon(owner))
		return

	var/mob/living/carbon/hemophage = owner

	if(!has_valid_target(hemophage))
		return

	// By now, we know that they're pulling a carbon.
	drain_victim(hemophage, hemophage.pulling)


/**
 * Handles the first checks to see if the target is eligible to be drained.
 *
 * Arguments:
 * * hemophage - The person that's trying to drain something or someone else.
 *
 * Returns `TRUE` if the target is eligible to be drained, `FALSE` if not.
 */
/datum/action/cooldown/hemophage/drain_victim/proc/has_valid_target(mob/living/carbon/hemophage)
	if(!hemophage.pulling || !iscarbon(hemophage.pulling) || isalien(hemophage.pulling))
		hemophage.balloon_alert(hemophage, LANG("datum.bc764ad9c7a7141b", null))
		return FALSE

	var/mob/living/carbon/victim = hemophage.pulling
	if(hemophage.get_blood_volume() >= BLOOD_VOLUME_MAXIMUM)
		hemophage.balloon_alert(hemophage, LANG("datum.e28c7f55e1d974b1", null))
		return FALSE

	if(victim.stat == DEAD)
		hemophage.balloon_alert(hemophage, LANG("datum.3b30952e983f73e4", null))
		return FALSE

	if(!victim.get_blood_volume() || (victim.dna && ((HAS_TRAIT(victim, TRAIT_NOBLOOD)) || (victim.get_blood_reagent() != hemophage.get_blood_reagent()))))
		hemophage.balloon_alert(hemophage, LANG("datum.110f98805ee89b6d", list(victim)))
		return FALSE

	if(victim.can_block_magic(MAGIC_RESISTANCE_HOLY, charge_cost = 0))
		victim.show_message(span_warning("[hemophage] tries to bite you, but stops before touching you!"))
		to_chat(hemophage, span_warning(LANG("datum.135f1a2f23cab109", list(victim))))
		return FALSE

	if(victim.has_reagent(/datum/reagent/consumable/garlic))
		victim.show_message(span_warning("[hemophage] tries to bite you, but recoils in disgust!"))
		to_chat(hemophage, span_warning(LANG("datum.d0f6c84c4327b5af", list(victim))))
		return FALSE

	if(ismonkey(victim) && (hemophage.get_blood_volume() >= BLOOD_VOLUME_NORMAL))
		hemophage.balloon_alert(hemophage, LANG("datum.8d41f73303dee2ab", null))
		return FALSE

	return TRUE


/**
 * The proc that actually handles draining the victim. Assumes that all the
 * pre-requesite checks were made, and as such will not make any more checks
 * outside of a `do_after` of three seconds.
 *
 * Arguments:
 * * hemophage - The feeder.
 * * victim - The one that's being drained.
 */
/datum/action/cooldown/hemophage/drain_victim/proc/drain_victim(mob/living/carbon/hemophage, mob/living/carbon/victim)
	var/blood_volume_difference = BLOOD_VOLUME_MAXIMUM - hemophage.get_blood_volume() //How much capacity we have left to absorb blood
	// We start by checking that the victim is a human and they have a client, so we can give them the
	// beneficial status effect for drinking higher-quality blood.
	var/is_target_human_with_client = istype(victim, /mob/living/carbon/human) && victim.client
	var/horrible_feeding = FALSE

	if(ismonkey(victim))
		is_target_human_with_client = FALSE // Sorry, not going to get the status effect from monkeys, even if they have a client in them.
		hemophage.add_mood_event("gross_food", /datum/mood_event/disgust/hemophage_feed_monkey) // drinking from a monkey is inherently gross, like, REALLY gross
		hemophage.adjust_disgust(TUMOR_DISLIKED_FOOD_DISGUST, TUMOR_DISLIKED_FOOD_DISGUST)
		blood_volume_difference = BLOOD_VOLUME_NORMAL - hemophage.get_blood_volume()
		horrible_feeding = TRUE

	if(istype(victim, /mob/living/carbon/human/species/monkey))
		is_target_human_with_client = FALSE // yep you're still not getting the status effect from humonkeys either. your tumour knows.
		hemophage.add_mood_event("gross_food", /datum/mood_event/disgust/hemophage_feed_humonkey)
		hemophage.adjust_disgust(DISGUST_LEVEL_GROSS / 4, TUMOR_DISLIKED_FOOD_DISGUST) // it's still gross but nowhere near as bad, though.
		horrible_feeding = TRUE

	StartCooldown()

	if(!do_after(hemophage, 3 SECONDS, target = victim))
		hemophage.balloon_alert(hemophage, LANG("datum.4b403578f7a3c3f0", null))
		return

	var/drained_blood = min(victim.get_blood_volume(), HEMOPHAGE_DRAIN_AMOUNT, blood_volume_difference)
	// if you drained from a human with a client, congrats
	var/drained_multiplier = (is_target_human_with_client ? BLOOD_DRAIN_MULTIPLIER_CKEY : 1)

	// Drain the victim's blood volume
	// Tries to transfer blood to the user's stomach, otherwise adjusts volume directly
	var/obj/item/organ/stomach/hemophage/stomach_reference = hemophage.get_organ_slot(ORGAN_SLOT_STOMACH)
	if(isnull(stomach_reference))
		victim.adjust_blood_volume(-drained_blood, 0, BLOOD_VOLUME_MAXIMUM)
	else if(!victim.transfer_blood_to(stomach_reference, drained_blood, ignore_low_blood = TRUE))
		victim.adjust_blood_volume(-drained_blood, 0, BLOOD_VOLUME_MAXIMUM)
	// Increase the user's blood volume
	hemophage.adjust_blood_volume(drained_blood * drained_multiplier, 0, BLOOD_VOLUME_MAXIMUM)

	log_combat(hemophage, victim, "drained [drained_blood]u of blood from", addition = " (NEW BLOOD VOLUME: [victim.get_blood_volume()] cL)")
	victim.show_message(span_danger("[hemophage] drains some of your blood!"))

	if(horrible_feeding)
		if(istype(victim, /mob/living/carbon/human/species/monkey))
			to_chat(hemophage, span_notice(LANG("datum.dc66a46c5fe9c4de", list(victim))))
		else
			to_chat(hemophage, span_warning(LANG("datum.5183194218c0e78e", list(victim))))
	else
		to_chat(hemophage, span_notice(LANG("datum.6919eec60171778a", list(victim, is_target_human_with_client ? " That tasted particularly good!" : ""))))

	playsound(hemophage, 'sound/items/drink.ogg', 30, TRUE, -2)

	// just let the hemophage know they're capped out on blood if they're trying to go for an exsanguinate and wondering why it isn't working
	if(drained_blood != HEMOPHAGE_DRAIN_AMOUNT && hemophage.get_blood_volume() >= (BLOOD_VOLUME_MAXIMUM - HEMOPHAGE_DRAIN_AMOUNT))
		to_chat(hemophage, span_boldnotice(LANG("datum.f87d1b8ec0b28adb", null)))

	if(victim.get_blood_volume() <= BLOOD_VOLUME_OKAY)
		to_chat(hemophage, span_warning(LANG("datum.81d3402329750eb0", null)))
		to_chat(victim, span_warning(LANG("datum.c97e0799e8a4db2e", null))) //let the victim know too

	if(is_target_human_with_client)
		hemophage.apply_status_effect(/datum/status_effect/blood_thirst_satiated)
		hemophage.add_mood_event("drank_human_blood", /datum/mood_event/hemophage_feed_human) // absolutely scrumptious
		hemophage.clear_mood_event("gross_food") // it's a real palate cleanser, you know
		hemophage.disgust *= 0.85 //also clears a little bit of disgust too

	// for this to ever occur, the hemophage actually has to be decently hungry, otherwise they'll cap their own blood reserves and be unable to pull it off.
	if(!victim.get_blood_volume() || victim.get_blood_volume() <= BLOOD_VOLUME_SURVIVE)
		to_chat(hemophage, span_boldwarning(LANG("datum.2045668c1ec92baa", list(victim))))
	else if((victim.get_blood_volume() - HEMOPHAGE_DRAIN_AMOUNT) <= BLOOD_VOLUME_SURVIVE)
		to_chat(hemophage, span_warning(LANG("datum.34d6cc6f8cd0b032", list(victim))))


#undef HEMOPHAGE_DRAIN_AMOUNT
#undef BLOOD_DRAIN_MULTIPLIER_CKEY
