
/*
	Muscle wounds. There is a chance to roll a muscle wound instead of others while doing brute damage
*/

/datum/wound/muscle
	name = "肌肉创伤"
	sound_effect = 'sound/effects/wounds/blood1.ogg'
	wound_flags = (ACCEPTS_GAUZE | SPLINT_OVERLAY)

	processes = TRUE
	/// How much do we need to regen. Will regen faster if we're splinted and or laying down
	var/regen_ticks_needed
	/// Our current counter for healing
	var/regen_ticks_current = 0

	can_scar = FALSE

/datum/wound_pregen_data/muscle
	abstract = TRUE

	viable_zones = list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
	required_limb_biostate = BIO_FLESH

	required_wounding_type = WOUND_BRUTE

	wound_series = WOUND_SERIES_MUSCLE_DAMAGE

	weight = 3 // very low chance to replace a normal wound. this is about 4.5%

/*
	Overwriting of base procs
*/
/datum/wound/muscle/wound_injury(datum/wound/old_wound = null, attack_direction)
	var/obj/item/held_item = victim.get_item_for_held_index(limb.held_index || 0)
	if(held_item && (disabling || prob(30 * severity)))
		if(istype(held_item, /obj/item/offhand))
			held_item = victim.get_inactive_held_item()

		if(held_item && victim.dropItemToGround(held_item))
			victim.visible_message(span_danger("[victim] 因震惊而丢下了 [held_item]！"), \
			span_warning("<b>你[parse_zone(limb.body_zone)]受到的冲击让你丢掉了[held_item]！</b>"), vision_distance=COMBAT_MESSAGE_RANGE)

	return ..()

/datum/wound/muscle/set_victim(new_victim)
	if (victim)
		UnregisterSignal(victim, COMSIG_LIVING_EARLY_UNARMED_ATTACK)

	if (new_victim)
		RegisterSignal(new_victim, COMSIG_LIVING_EARLY_UNARMED_ATTACK, PROC_REF(attack_with_hurt_hand))

	return ..()

/datum/wound/muscle/remove_wound(ignore_limb, replaced, destroying)
	limp_slowdown = 0
	return ..()

/datum/wound/muscle/handle_process()
	. = ..()

	regen_ticks_current++
	if(victim.body_position == LYING_DOWN)
		if(prob(50))
			regen_ticks_current += 0.5
		if(victim.IsSleeping())
			regen_ticks_current += 0.5

	regen_ticks_current += 1 - limb.get_splint_factor()

	if(regen_ticks_current > regen_ticks_needed)
		if(!victim || !limb)
			qdel(src)
			return
		to_chat(victim, span_green("你的[parse_zone(limb.body_zone)]肌肉已经再生了！"))
		remove_wound()

/// If we're a human who's punching something with a broken arm, we might hurt ourselves doing so
/datum/wound/muscle/proc/attack_with_hurt_hand(mob/M, atom/target, proximity)
	SIGNAL_HANDLER

	if(victim.get_active_hand() != limb || !victim.combat_mode || !ismob(target) || severity <= WOUND_SEVERITY_MODERATE)
		return

	// 15% of 30% chance to proc pain on hit
	if(prob(severity * 15))
		// And you have a 70% or 50% chance to actually land the blow, respectively
		if(prob(70 - 20 * severity))
			to_chat(victim, span_userdanger("当你攻击[target]时，你[parse_zone(limb.body_zone)]受损的肌肉传来一阵剧痛！"))
			limb.receive_damage(brute=rand(1,5))
		else
			victim.visible_message(span_danger("[victim]用[victim.p_their()]肿胀的[parse_zone(limb.body_zone)]虚弱地击打[target]，因疼痛而退缩！"), \
			span_userdanger("你未能击中[target]，因为你[parse_zone(limb.body_zone)]的骨折处燃起了难以忍受的剧痛！"), vision_distance=COMBAT_MESSAGE_RANGE)
			INVOKE_ASYNC(victim, TYPE_PROC_REF(/mob, emote), "scream")
			victim.Stun(0.5 SECONDS)
			limb.receive_damage(brute=rand(3,7))
			return COMPONENT_CANCEL_ATTACK_CHAIN

/// Moderate (Muscle Tear)
/datum/wound/muscle/moderate
	name = "肌肉撕裂"
	desc = "患者肌肉撕裂，导致严重疼痛和肢体功能下降。"
	treat_text = "A tight splint on the affected limb, as well as plenty of rest and sleep."
	examine_desc = "appears unnaturallly red and swollen"
	occur_text = "swells up, its skin turning red"
	severity = WOUND_SEVERITY_MODERATE
	interaction_efficiency_penalty = 1.5
	limp_slowdown = 2
	limp_chance = 30
	threshold_penalty = 15
	status_effect_type = /datum/status_effect/wound/muscle/moderate
	regen_ticks_needed = 90

/datum/wound_pregen_data/muscle/tear
	abstract = FALSE

	wound_path_to_generate = /datum/wound/muscle/moderate
	threshold_minimum = 35

/*
	Severe (Ruptured Tendon)
*/

/datum/wound/muscle/severe
	name = "肌腱断裂"
	sound_effect = 'sound/effects/wounds/blood2.ogg'
	desc = "患者肌腱被切断，导致剧烈疼痛且肢体几乎无法使用。"
	treat_text = "A tight splint on the affected limb, as well as plenty of rest and sleep."
	examine_desc = "is limp and awkwardly twitching, skin swollen and red"
	occur_text = "twists in pain and goes limp, its tendon ruptured"
	severity = WOUND_SEVERITY_SEVERE
	interaction_efficiency_penalty = 2
	limp_slowdown = 5
	limp_chance = 40
	threshold_penalty = 35
	disabling = TRUE
	status_effect_type = /datum/status_effect/wound/muscle/severe
	regen_ticks_needed = 150

/datum/wound_pregen_data/muscle/tendon
	abstract = FALSE

	wound_path_to_generate = /datum/wound/muscle/severe
	threshold_minimum = 80

// muscle
/datum/status_effect/wound/muscle/moderate
	id = "torn muscle"
/datum/status_effect/wound/muscle/severe
	id = "ruptured tendon"

/datum/status_effect/wound/muscle/robotic/moderate
	id = "worn servo"

/datum/status_effect/wound/muscle/robotic/severe
	id = "severed hydraulic"
