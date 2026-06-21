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
	name = "吸取受害者"
	desc = "从你被动抓取的任何碳基受害者身上吸取血液。"


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
		hemophage.balloon_alert(hemophage, "没有拉住任何有效目标！")
		return FALSE

	var/mob/living/carbon/victim = hemophage.pulling
	if(hemophage.get_blood_volume() >= BLOOD_VOLUME_MAXIMUM)
		hemophage.balloon_alert(hemophage, "已经饱了！")
		return FALSE

	if(victim.stat == DEAD)
		hemophage.balloon_alert(hemophage, "需要一个活着的受害者！")
		return FALSE

	if(!victim.get_blood_volume() || (victim.dna && ((HAS_TRAIT(victim, TRAIT_NOBLOOD)) || (victim.get_blood_reagent() != hemophage.get_blood_reagent()))))
		hemophage.balloon_alert(hemophage, "[victim]没有合适的血液！")
		return FALSE

	if(victim.can_block_magic(MAGIC_RESISTANCE_HOLY, charge_cost = 0))
		victim.show_message(span_warning("[hemophage] 试图咬你，但在碰到你之前停住了！"))
		to_chat(hemophage, span_warning("[victim] 受到了祝福！你及时停住，避免了引火上身。"))
		return FALSE

	if(victim.has_reagent(/datum/reagent/consumable/garlic))
		victim.show_message(span_warning("[hemophage] 试图咬你，但厌恶地退缩了！"))
		to_chat(hemophage, span_warning("[victim] 散发着大蒜味！你无法让自己去吸取这种被污染的血液。"))
		return FALSE

	if(ismonkey(victim) && (hemophage.get_blood_volume() >= BLOOD_VOLUME_NORMAL))
		hemophage.balloon_alert(hemophage, "他们低劣的血液无法再满足你了！")
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
		hemophage.balloon_alert(hemophage, "停止进食")
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
	victim.show_message(span_danger("[hemophage] 吸取了你的一些血液！"))

	if(horrible_feeding)
		if(istype(victim, /mob/living/carbon/human/species/monkey))
			to_chat(hemophage, span_notice("你试探性地从 [victim] 身上吸取血液，每一口都充满了臭氧味和一种奇怪的人工刺激感。"))
		else
			to_chat(hemophage, span_warning("你强咽下从 [victim] 身上吸取的几口温热的恶臭血液。那味道简直令人作呕。"))
	else
		to_chat(hemophage, span_notice("You pull greedy gulps of precious lifeblood from [victim]'s veins![is_target_human_with_client ? " That tasted particularly good!" : ""]"))

	playsound(hemophage, 'sound/items/drink.ogg', 30, TRUE, -2)

	// just let the hemophage know they're capped out on blood if they're trying to go for an exsanguinate and wondering why it isn't working
	if(drained_blood != HEMOPHAGE_DRAIN_AMOUNT && hemophage.get_blood_volume() >= (BLOOD_VOLUME_MAXIMUM - HEMOPHAGE_DRAIN_AMOUNT))
		to_chat(hemophage, span_boldnotice("你的饥渴暂时得到了缓解，目前无法再消化更多新鲜血液。"))

	if(victim.get_blood_volume() <= BLOOD_VOLUME_OKAY)
		to_chat(hemophage, span_warning("这肯定让他们看起来脸色苍白..."))
		to_chat(victim, span_warning("一阵呻吟般的倦怠感悄然渗入你的肌肉，你开始感到皮肤有些湿冷...")) //let the victim know too

	if(is_target_human_with_client)
		hemophage.apply_status_effect(/datum/status_effect/blood_thirst_satiated)
		hemophage.add_mood_event("drank_human_blood", /datum/mood_event/hemophage_feed_human) // absolutely scrumptious
		hemophage.clear_mood_event("gross_food") // it's a real palate cleanser, you know
		hemophage.disgust *= 0.85 //also clears a little bit of disgust too

	// for this to ever occur, the hemophage actually has to be decently hungry, otherwise they'll cap their own blood reserves and be unable to pull it off.
	if(!victim.get_blood_volume() || victim.get_blood_volume() <= BLOOD_VOLUME_SURVIVE)
		to_chat(hemophage, span_boldwarning("随着你可怕的饥渴几乎将他们彻底榨干，[victim]萎缩的血管中淌出了最后一丝微弱的血流。"))
	else if((victim.get_blood_volume() - HEMOPHAGE_DRAIN_AMOUNT) <= BLOOD_VOLUME_SURVIVE)
		to_chat(hemophage, span_warning("一股犹豫感啃噬着你：你确切地知道，再从[victim]身上抽取更多血液，他们必死无疑。<b>……但你的另一部分只看到了机会。</b>"))


#undef HEMOPHAGE_DRAIN_AMOUNT
#undef BLOOD_DRAIN_MULTIPLIER_CKEY
