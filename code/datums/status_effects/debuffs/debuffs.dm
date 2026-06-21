/// The damage healed per tick while sleeping without any modifiers
#define HEALING_SLEEP_DEFAULT 0.2
/// The sleep healing multiplier for organ passive healing (since organs heal slowly)
#define HEALING_SLEEP_ORGAN_MULTIPLIER 5
/// The sleep multiplier for fitness xp conversion
#define SLEEP_QUALITY_WORKOUT_MULTIPLER 10

//Largely negative status effects go here, even if they have small beneficial effects
//STUN EFFECTS
/datum/status_effect/incapacitating
	id = STATUS_EFFECT_ID_ABSTRACT
	tick_interval = STATUS_EFFECT_NO_TICK
	status_type = STATUS_EFFECT_REPLACE
	alert_type = null
	processing_speed = STATUS_EFFECT_PRIORITY
	remove_on_fullheal = TRUE
	heal_flag_necessary = HEAL_CC_STATUS
	var/needs_update_stat = FALSE
	/// Suffixes attached to the force_say when applied, uses the "hurt" suffixes by default
	var/list/alter_phrases

/datum/status_effect/incapacitating/on_creation(mob/living/new_owner, set_duration)
	if(isnum(set_duration))
		duration = set_duration
	. = ..()
	if(!.)
		return
	if(needs_update_stat || issilicon(owner))
		owner.update_stat()

/datum/status_effect/incapacitating/on_remove()
	if(needs_update_stat || issilicon(owner)) //silicons need stat updates in addition to normal canmove updates
		owner.update_stat()
	return ..()

/datum/status_effect/incapacitating/on_apply()
	SHOULD_CALL_PARENT(TRUE)
	. = ..()
	if(!.)
		return

	force_say()

/datum/status_effect/incapacitating/proc/force_say()
	SHOULD_CALL_PARENT(TRUE)

	var/mob/living/carbon/human/human = owner
	if(istype(human))
		human.force_say(alter_phrases, immediate = TRUE)

//STUN
/datum/status_effect/incapacitating/stun
	id = "stun"

/datum/status_effect/incapacitating/stun/on_apply()
	. = ..()
	if(!.)
		return
	owner.add_traits(list(TRAIT_INCAPACITATED, TRAIT_IMMOBILIZED, TRAIT_HANDS_BLOCKED), TRAIT_STATUS_EFFECT(id))

/datum/status_effect/incapacitating/stun/on_remove()
	owner.remove_traits(list(TRAIT_INCAPACITATED, TRAIT_IMMOBILIZED, TRAIT_HANDS_BLOCKED), TRAIT_STATUS_EFFECT(id))
	return ..()

//KNOCKDOWN
/datum/status_effect/incapacitating/knockdown
	id = "knockdown"

/datum/status_effect/incapacitating/knockdown/on_apply()
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_FLOORED, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/incapacitating/knockdown/on_remove()
	REMOVE_TRAIT(owner, TRAIT_FLOORED, TRAIT_STATUS_EFFECT(id))
	return ..()


//IMMOBILIZED
/datum/status_effect/incapacitating/immobilized
	id = "immobilized"

/datum/status_effect/incapacitating/immobilized/on_apply()
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_IMMOBILIZED, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/incapacitating/immobilized/on_remove()
	REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, TRAIT_STATUS_EFFECT(id))
	return ..()


//PARALYZED
/datum/status_effect/incapacitating/paralyzed
	id = "paralyzed"
	alter_phrases = list("") // "Why am I about to be froz-"

/datum/status_effect/incapacitating/paralyzed/on_apply()
	. = ..()
	if(!.)
		return
	owner.add_traits(list(TRAIT_INCAPACITATED, TRAIT_IMMOBILIZED, TRAIT_FLOORED, TRAIT_HANDS_BLOCKED), TRAIT_STATUS_EFFECT(id))

/datum/status_effect/incapacitating/paralyzed/on_remove()
	owner.remove_traits(list(TRAIT_INCAPACITATED, TRAIT_IMMOBILIZED, TRAIT_FLOORED, TRAIT_HANDS_BLOCKED), TRAIT_STATUS_EFFECT(id))
	return ..()

//INCAPACITATED
/// This status effect represents anything that leaves a character unable to perform basic tasks (interrupting do-afters, for example), but doesn't incapacitate them further than that (no stuns etc..)
/datum/status_effect/incapacitating/incapacitated
	id = "incapacitated"

// What happens when you get the incapacitated status. You get TRAIT_INCAPACITATED added to you for the duration of the status effect.
/datum/status_effect/incapacitating/incapacitated/on_apply()
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_INCAPACITATED, TRAIT_STATUS_EFFECT(id))

// When the status effect runs out, your TRAIT_INCAPACITATED is removed.
/datum/status_effect/incapacitating/incapacitated/on_remove()
	REMOVE_TRAIT(owner, TRAIT_INCAPACITATED, TRAIT_STATUS_EFFECT(id))
	return ..()


//UNCONSCIOUS
/datum/status_effect/incapacitating/unconscious
	id = "unconscious"
	needs_update_stat = TRUE

/datum/status_effect/incapacitating/unconscious/on_apply()
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_KNOCKEDOUT, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/incapacitating/unconscious/on_remove()
	REMOVE_TRAIT(owner, TRAIT_KNOCKEDOUT, TRAIT_STATUS_EFFECT(id))
	return ..()

/datum/status_effect/incapacitating/unconscious/tick(seconds_between_ticks)
	if(owner.get_stamina_loss())
		owner.adjust_stamina_loss(-0.3) //reduce stamina loss by 0.3 per tick, 6 per 2 seconds


//SLEEPING
/datum/status_effect/incapacitating/sleeping
	id = "sleeping"
	alert_type = /atom/movable/screen/alert/status_effect/asleep
	needs_update_stat = TRUE
	tick_interval = 2 SECONDS
	alter_phrases = list("Zzz...", "ZZz...", "ZZZ...", "zzZ...", "zZZ...", "ZzZ...", "zzz...", "zZz...", "mimimimimimi...")

/datum/status_effect/incapacitating/sleeping/on_apply()
	. = ..()
	if(!.)
		return
	if(HAS_TRAIT(owner, TRAIT_SLEEPIMMUNE))
		tick_interval = STATUS_EFFECT_NO_TICK
	else
		ADD_TRAIT(owner, TRAIT_KNOCKEDOUT, TRAIT_STATUS_EFFECT(id))
	RegisterSignal(owner, SIGNAL_ADDTRAIT(TRAIT_SLEEPIMMUNE), PROC_REF(on_owner_insomniac))
	RegisterSignal(owner, SIGNAL_REMOVETRAIT(TRAIT_SLEEPIMMUNE), PROC_REF(on_owner_sleepy))

/datum/status_effect/incapacitating/sleeping/on_remove()
	UnregisterSignal(owner, list(SIGNAL_ADDTRAIT(TRAIT_SLEEPIMMUNE), SIGNAL_REMOVETRAIT(TRAIT_SLEEPIMMUNE)))
	if(!HAS_TRAIT(owner, TRAIT_SLEEPIMMUNE))
		REMOVE_TRAIT(owner, TRAIT_KNOCKEDOUT, TRAIT_STATUS_EFFECT(id))
		tick_interval = initial(tick_interval)
	return ..()

/datum/status_effect/incapacitating/sleeping/force_say()
	if(!HAS_TRAIT(owner, TRAIT_SLEEPIMMUNE))
		..()

///If the mob is sleeping and gain the TRAIT_SLEEPIMMUNE we remove the TRAIT_KNOCKEDOUT and stop the tick() from happening
/datum/status_effect/incapacitating/sleeping/proc/on_owner_insomniac(mob/living/source)
	SIGNAL_HANDLER
	REMOVE_TRAIT(owner, TRAIT_KNOCKEDOUT, TRAIT_STATUS_EFFECT(id))
	tick_interval = STATUS_EFFECT_NO_TICK

///If the mob has the TRAIT_SLEEPIMMUNE but somehow looses it we make him sleep and restart the tick()
/datum/status_effect/incapacitating/sleeping/proc/on_owner_sleepy(mob/living/source)
	SIGNAL_HANDLER
	ADD_TRAIT(owner, TRAIT_KNOCKEDOUT, TRAIT_STATUS_EFFECT(id))
	tick_interval = initial(tick_interval)

/datum/status_effect/incapacitating/sleeping/tick(seconds_between_ticks)
	if(owner.maxHealth)
		var/health_ratio = owner.health / owner.maxHealth
		var/sleep_quality = HEALING_SLEEP_DEFAULT

		// having high spirits helps us recover
		if(owner.mob_mood)
			switch(owner.mob_mood.sanity_level)
				if(SANITY_LEVEL_GREAT)
					sleep_quality = 0.2
				if(SANITY_LEVEL_NEUTRAL)
					sleep_quality = 0.1
				if(SANITY_LEVEL_DISTURBED)
					sleep_quality = 0
				if(SANITY_LEVEL_UNSTABLE)
					sleep_quality = 0
				if(SANITY_LEVEL_CRAZY)
					sleep_quality = -0.1
				if(SANITY_LEVEL_INSANE)
					sleep_quality = -0.2

		var/turf/rest_turf = get_turf(owner)
		var/is_sleeping_in_darkness = rest_turf.get_lumcount() <= LIGHTING_TILE_IS_DARK

		// sleeping with a blindfold or in the dark helps us rest
		if(owner.is_blind_from(EYES_COVERED) || is_sleeping_in_darkness)
			sleep_quality += 0.1

		// sleeping in silence is always better
		if(HAS_TRAIT(owner, TRAIT_DEAF))
			sleep_quality += 0.1

		// check for beds
		if((locate(/obj/structure/bed) in owner.loc))
			sleep_quality += 0.2
		else if((locate(/obj/structure/table) in owner.loc))
			sleep_quality += 0.1

		// don't forget the bedsheet
		if(locate(/obj/item/bedsheet) in owner.loc)
			sleep_quality += 0.1

		// you forgot the pillow
		if(locate(/obj/item/pillow) in owner.loc)
			sleep_quality += 0.1

		var/need_mob_update = FALSE
		if(sleep_quality > 0)
			if(iscarbon(owner))
				var/mob/living/carbon/carbon_owner = owner
				for(var/obj/item/organ/target_organ as anything in carbon_owner.organs)
					// no healing boost for robotic or dying organs
					if(IS_ROBOTIC_ORGAN(target_organ) || !target_organ.damage || target_organ.organ_flags & ORGAN_FAILING)
						continue

					// organ regeneration is very low so we crank up the healing rate to give a good bonus
					var/healing_bonus = target_organ.healing_factor * sleep_quality * HEALING_SLEEP_ORGAN_MULTIPLIER
					target_organ.apply_organ_damage(-healing_bonus * target_organ.maxHealth)

				var/datum/status_effect/exercised/exercised = carbon_owner.has_status_effect(/datum/status_effect/exercised)
				if(exercised && carbon_owner.mind)
					// the better you sleep, the more xp you gain
					carbon_owner.mind.adjust_experience(/datum/skill/athletics, seconds_between_ticks * sleep_quality * SLEEP_QUALITY_WORKOUT_MULTIPLER)
					carbon_owner.adjust_timed_status_effect(-1 * seconds_between_ticks * sleep_quality * SLEEP_QUALITY_WORKOUT_MULTIPLER, /datum/status_effect/exercised)
					if(prob(2))
						to_chat(carbon_owner, span_notice("你感觉自己的健康状况正在改善！"))

			if(health_ratio > 0.8) // only heals minor physical damage
				need_mob_update += owner.adjust_brute_loss(-0.4 * sleep_quality * seconds_between_ticks, updating_health = FALSE, required_bodytype = BODYTYPE_ORGANIC)
				need_mob_update += owner.adjust_fire_loss(-0.4 * sleep_quality * seconds_between_ticks, updating_health = FALSE, required_bodytype = BODYTYPE_ORGANIC)
				need_mob_update += owner.adjust_tox_loss(-0.2 * sleep_quality * seconds_between_ticks, updating_health = FALSE, forced = TRUE, required_biotype = MOB_ORGANIC)
		need_mob_update += owner.adjust_stamina_loss(min(-0.4 * sleep_quality * seconds_between_ticks, -0.4 * HEALING_SLEEP_DEFAULT * seconds_between_ticks), updating_stamina = FALSE)
		if(need_mob_update)
			owner.updatehealth()
	// Drunkenness gets reduced by 0.3% per tick (6% per 2 seconds)
	owner.set_drunk_effect(owner.get_drunk_amount() * 0.997)

	if(iscarbon(owner))
		var/mob/living/carbon/carbon_owner = owner
		carbon_owner.handle_dreams()

	if(prob(8) && owner.health > owner.crit_threshold)
		owner.emote("snore")

/atom/movable/screen/alert/status_effect/asleep
	name = "入睡"
	desc = "You've fallen asleep. Wait a bit and you should wake up. Unless you don't, considering how helpless you are."
	use_user_hud_icon = USER_HUD_STYLE_INHERIT
	overlay_state = "asleep"

//STASIS
/datum/status_effect/grouped/stasis
	id = "stasis"
	duration = STATUS_EFFECT_PERMANENT
	alert_type = /atom/movable/screen/alert/status_effect/stasis
	var/last_dead_time

/datum/status_effect/grouped/stasis/proc/update_time_of_death()
	if(last_dead_time)
		var/delta = world.time - last_dead_time
		var/new_timeofdeath = owner.timeofdeath + delta
		owner.timeofdeath = new_timeofdeath
		owner.station_timestamp_timeofdeath = round_timestamp(wtime=new_timeofdeath)
		last_dead_time = null
	if(owner.stat == DEAD)
		last_dead_time = world.time

/datum/status_effect/grouped/stasis/on_creation(mob/living/new_owner, set_duration)
	. = ..()
	if(.)
		update_time_of_death()
		owner.reagents?.end_metabolization(owner, FALSE)

/datum/status_effect/grouped/stasis/on_apply()
	. = ..()
	if(!.)
		return
	owner.add_traits(list(TRAIT_IMMOBILIZED, TRAIT_HANDS_BLOCKED, TRAIT_STASIS, TRAIT_TUMOR_SUPPRESSED, TRAIT_ANALGESIA), TRAIT_STATUS_EFFECT(id)) // NOVA EDIT CHANGE - ORIGINAL: owner.add_traits(list(TRAIT_IMMOBILIZED, TRAIT_HANDS_BLOCKED, TRAIT_STASIS, TRAIT_TUMOR_SUPPRESSED), TRAIT_STATUS_EFFECT(id))
	owner.add_filter("stasis_status_ripple", 2, list("type" = "ripple", "flags" = WAVE_BOUNDED, "radius" = 0, "size" = 2))
	var/filter = owner.get_filter("stasis_status_ripple")
	animate(filter, radius = 0, time = 0.2 SECONDS, size = 2, easing = JUMP_EASING, loop = -1, flags = ANIMATION_PARALLEL)
	animate(radius = 32, time = 1.5 SECONDS, size = 0)
	if(iscarbon(owner))
		var/mob/living/carbon/carbon_owner = owner
		carbon_owner.update_bodypart_bleed_overlays()

/datum/status_effect/grouped/stasis/tick(seconds_between_ticks)
	update_time_of_death()
	// NOVA EDIT ADDITION START - STASIS KEEPS SLEEP GOING
	if(owner.stat >= UNCONSCIOUS)
		owner.Sleeping(15 SECONDS)
	//NOVA EDIT ADDITION END

/datum/status_effect/grouped/stasis/on_remove()
	owner.remove_traits(list(TRAIT_IMMOBILIZED, TRAIT_HANDS_BLOCKED, TRAIT_STASIS, TRAIT_TUMOR_SUPPRESSED, TRAIT_ANALGESIA), TRAIT_STATUS_EFFECT(id)) // NOVA EDIT CHANGE - ORIGINAL: owner.remove_traits(list(TRAIT_IMMOBILIZED, TRAIT_HANDS_BLOCKED, TRAIT_STASIS, TRAIT_TUMOR_SUPPRESSED), TRAIT_STATUS_EFFECT(id))
	owner.remove_filter("stasis_status_ripple")
	update_time_of_death()
	if(iscarbon(owner))
		var/mob/living/carbon/carbon_owner = owner
		carbon_owner.update_bodypart_bleed_overlays()
	return ..()

/atom/movable/screen/alert/status_effect/stasis
	name = "停滞"
	desc = "你的生理机能已经停止。这样你可以永远活下去，但相当无聊。"
	use_user_hud_icon = USER_HUD_STYLE_INHERIT
	overlay_state = "stasis"

/datum/status_effect/his_wrath //does minor damage over time unless holding His Grace
	id = "his_wrath"
	duration = STATUS_EFFECT_PERMANENT
	tick_interval = 0.4 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/his_wrath

/datum/status_effect/his_wrath/on_creation(mob/living/new_owner, His, Him)
	. = ..()
	linked_alert.name = "[His] 之怒"
	linked_alert.desc = "你逃离了[His]的恩典而非供养[Him]，现在你受苦了。"
	linked_alert.icon_state = "[LOWER_TEXT(His)]_grace"

/atom/movable/screen/alert/status_effect/his_wrath
	name = "祂之怒"
	desc = "你逃离了祂的恩典而非供养祂，现在你受苦了。"
	icon_state = "his_grace"
	alerttooltipstyle = "hisgrace"

/datum/status_effect/his_wrath/tick(seconds_between_ticks)
	for(var/obj/item/his_grace/HG in owner.held_items)
		qdel(src)
		return
	var/need_mob_update
	need_mob_update = owner.adjust_brute_loss(0.04 * seconds_between_ticks, updating_health = FALSE)
	need_mob_update += owner.adjust_fire_loss(0.04 * seconds_between_ticks, updating_health = FALSE)
	need_mob_update += owner.adjust_tox_loss(0.08 * seconds_between_ticks, updating_health = FALSE, forced = TRUE)
	if(need_mob_update)
		owner.updatehealth()

/datum/status_effect/cultghost //is a cult ghost and can't use manifest runes
	id = "cult_ghost"
	duration = STATUS_EFFECT_PERMANENT
	alert_type = null

/datum/status_effect/cultghost/on_apply()
	owner.set_invis_see(SEE_INVISIBLE_OBSERVER)

/datum/status_effect/cultghost/tick(seconds_between_ticks)
	if(owner.reagents)
		owner.reagents.del_reagent(/datum/reagent/water/holywater) //can't be deconverted

/datum/status_effect/crusher_mark
	id = "crusher_mark"
	duration = 300 //if you leave for 30 seconds you lose the mark, deal with it
	status_type = STATUS_EFFECT_REFRESH
	alert_type = null
	/// The bubble that is added to the mob as a visual
	var/obj/effect/abstract/crusher_mark/marked_underlay
	/// If the projectile that applies this was boosted, the mark will also be boosted
	var/boosted = FALSE
	/// How long before the mark is ready to be detonated. Used for both the visual overlay and to determine when it's ready
	var/ready_delay = 0.8 SECONDS

/datum/status_effect/crusher_mark/on_creation(mob/living/new_owner, was_boosted)
	. = ..()
	boosted = was_boosted

/datum/status_effect/crusher_mark/on_apply()
	if(owner.mob_size < MOB_SIZE_LARGE || HAS_TRAIT(owner, TRAIT_OVERSIZED)) // NOVA EDIT CHANGE - Original: if(owner.mob_size < MOB_SIZE_LARGE)
		return FALSE

	marked_underlay = new()
	marked_underlay.pixel_w = -(owner.base_pixel_x + owner.base_pixel_w)
	marked_underlay.pixel_z = -(owner.base_pixel_y + owner.base_pixel_z)
	marked_underlay.transform *= 0.5
	owner.vis_contents += marked_underlay
	animate(marked_underlay, ready_delay, transform = matrix() * 1.2, flags = CIRCULAR_EASING | EASE_IN)
	addtimer(CALLBACK(src, PROC_REF(scale_back)), ready_delay) // Animate chains do not function with vis_contents
	return TRUE

/datum/status_effect/crusher_mark/proc/scale_back()
	animate(marked_underlay, time = 0.1 SECONDS, transform = matrix(), flags = CUBIC_EASING | EASE_OUT)

/datum/status_effect/crusher_mark/Destroy()
	if(owner)
		owner.underlays -= marked_underlay
	QDEL_NULL(marked_underlay)
	return ..()

// Object used to apply a underlay to the mob that gets this status applied
/obj/effect/abstract/crusher_mark
	name = "粉碎者标记底层"
	icon = 'icons/effects/effects.dmi'
	icon_state = "shield"
	appearance_flags = TILE_BOUND|LONG_GLIDE|RESET_COLOR|PIXEL_SCALE|KEEP_APART
	vis_flags = VIS_UNDERLAY
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/datum/status_effect/stacking/saw_bleed
	id = "saw_bleed"
	tick_interval = 0.6 SECONDS
	delay_before_decay = 5
	stack_threshold = 10
	max_stacks = 10
	overlay_file = 'icons/effects/bleed.dmi'
	overlay_state = "bleed"
	var/bleed_damage = 200

/datum/status_effect/stacking/saw_bleed/fadeout_effect()
	new /obj/effect/temp_visual/bleed(get_turf(owner))

/datum/status_effect/stacking/saw_bleed/threshold_cross_effect()
	owner.adjust_brute_loss(bleed_damage)
	new /obj/effect/temp_visual/bleed/explode(get_turf(owner))
	for(var/splatter_dir in GLOB.alldirs)
		owner.create_splatter(splatter_dir)
	playsound(owner, SFX_DESECRATION, 100, TRUE, -1)

/datum/status_effect/stacking/saw_bleed/bloodletting
	id = "bloodletting"
	stack_threshold = 7
	max_stacks = 7
	bleed_damage = 20

/datum/status_effect/neck_slice
	id = "neck_slice"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = null
	duration = STATUS_EFFECT_PERMANENT

/datum/status_effect/neck_slice/on_apply()
	if(!ishuman(owner))
		return FALSE
	if(!owner.get_bodypart(BODY_ZONE_HEAD))
		return FALSE
	return TRUE

/datum/status_effect/neck_slice/tick(seconds_between_ticks)
	var/obj/item/bodypart/throat = owner.get_bodypart(BODY_ZONE_HEAD)
	if(owner.stat == DEAD || !throat) // they can lose their head while it's going.
		qdel(src)
		return

	var/still_bleeding = FALSE
	for(var/datum/wound/bleeding_thing as anything in throat.wounds)
		var/datum/wound_pregen_data/pregen_data = GLOB.all_wound_pregen_data[bleeding_thing.type]

		if(pregen_data.wounding_types_valid(WOUND_SLASH) && bleeding_thing.severity > WOUND_SEVERITY_MODERATE && bleeding_thing.blood_flow > 0)
			still_bleeding = TRUE
			break
	if(!still_bleeding)
		qdel(src)
		return

	if(prob(10))
		owner.emote(pick("gasp", "gag", "choke"))

/datum/status_effect/neck_slice/get_examine_text()
	return span_warning("[owner.p_Their()]的脖子被割开，正在大量出血！")

/// Applies a curse with various possible effects
/mob/living/proc/apply_necropolis_curse(set_curse)
	var/datum/status_effect/necropolis_curse/curse = has_status_effect(/datum/status_effect/necropolis_curse)
	if(!set_curse)
		set_curse = pick(CURSE_BLINDING, CURSE_WASTING, CURSE_GRASPING)
	if(QDELETED(curse))
		apply_status_effect(/datum/status_effect/necropolis_curse, set_curse)
	else
		curse.apply_curse(set_curse)
		curse.duration += 5 MINUTES //time added by additional curses
	return curse

/// A curse that does up to three nasty things to you
/datum/status_effect/necropolis_curse
	id = "necrocurse"
	duration = 10 MINUTES //you're cursed for 10 minutes have fun
	tick_interval = 5 SECONDS
	alert_type = null
	/// Which nasty things are we doing? [CURSE_BLINDING / CURSE_WASTING / CURSE_GRASPING]]
	var/curse_flags = NONE
	/// When should we next throw hands?
	var/effect_next_activation = 0
	/// How long between throwing hands?
	var/effect_cooldown = 10 SECONDS
	/// Visuals for the wasting effect
	var/obj/effect/temp_visual/curse/wasting_effect

/datum/status_effect/necropolis_curse/on_creation(mob/living/new_owner, set_curse)
	. = ..()
	if(.)
		apply_curse(set_curse)

/datum/status_effect/necropolis_curse/Destroy()
	if(!QDELETED(wasting_effect))
		qdel(wasting_effect)
		wasting_effect = null
	return ..()

/datum/status_effect/necropolis_curse/on_remove()
	remove_curse(curse_flags)

/datum/status_effect/necropolis_curse/proc/apply_curse(set_curse)
	curse_flags |= set_curse
	if(curse_flags & CURSE_BLINDING)
		owner.overlay_fullscreen("curse", /atom/movable/screen/fullscreen/curse, 1)
	if(curse_flags & CURSE_WASTING && !wasting_effect)
		wasting_effect = new

/datum/status_effect/necropolis_curse/proc/remove_curse(remove_curse)
	if(remove_curse & CURSE_BLINDING)
		owner.clear_fullscreen("curse", 50)
	curse_flags &= ~remove_curse

/datum/status_effect/necropolis_curse/tick(seconds_between_ticks)
	if(owner.stat == DEAD)
		return

	if(curse_flags & CURSE_WASTING)
		wasting_effect.forceMove(owner.loc)
		wasting_effect.setDir(owner.dir)
		wasting_effect.transform = owner.transform //if the owner has been stunned the overlay should inherit that position
		wasting_effect.alpha = 255
		animate(wasting_effect, alpha = 0, time = 32)
		playsound(owner, 'sound/effects/curse/curse5.ogg', 20, TRUE, -1)
		owner.adjust_fire_loss(0.75)

	if(curse_flags & CURSE_GRASPING)
		if(effect_next_activation > world.time)
			return
		effect_next_activation = world.time + effect_cooldown
		fire_curse_hand(owner, range = 5, projectile_type = /obj/projectile/curse_hand) // This one stuns people

/obj/effect/temp_visual/curse
	icon_state = "curse"

/obj/effect/temp_visual/curse/Initialize(mapload)
	. = ..()
	deltimer(timerid)


/datum/status_effect/gonbola_pacify
	id = "gonbolaPacify"
	status_type = STATUS_EFFECT_MULTIPLE
	tick_interval = STATUS_EFFECT_NO_TICK
	alert_type = null

/datum/status_effect/gonbola_pacify/on_apply()
	. = ..()
	owner.add_traits(list(TRAIT_PACIFISM, TRAIT_MUTE), REF(src))
	owner.add_mood_event(REF(src), /datum/mood_event/gondola)
	to_chat(owner, span_notice("你突然感到平静，觉得没有任何必要做出任何突然或轻率的行动……"))

/datum/status_effect/gonbola_pacify/on_remove()
	owner.remove_traits(list(TRAIT_PACIFISM, TRAIT_MUTE), REF(src))
	owner.clear_mood_event(REF(src))
	return ..()

/datum/status_effect/trance
	id = "trance"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 300
	tick_interval = 1 SECONDS
	var/stun = TRUE
	alert_type = /atom/movable/screen/alert/status_effect/trance

/atom/movable/screen/alert/status_effect/trance
	name = "恍惚"
	desc = "一切都感觉如此遥远，你能感觉到自己的思绪在脑海中循环……"
	use_user_hud_icon = USER_HUD_STYLE_INHERIT
	overlay_state = "high"

/datum/status_effect/trance/tick(seconds_between_ticks)
	if(stun)
		owner.Stun(6 SECONDS, TRUE)
	owner.set_dizzy(40 SECONDS)

/datum/status_effect/trance/on_apply()
	if(!iscarbon(owner))
		return FALSE
	RegisterSignal(owner, COMSIG_MOVABLE_HEAR, PROC_REF(hypnotize))
	ADD_TRAIT(owner, TRAIT_MUTE, TRAIT_STATUS_EFFECT(id))
	owner.add_client_colour(/datum/client_colour/monochrome, REF(src))
	owner.visible_message("[stun ? span_warning("[owner] stands still as [owner.p_their()] eyes seem to focus on a distant point.") : ""]", \
	span_warning(pick("你感觉自己的思绪慢了下来……", "你突然感到极度眩晕……", "你感觉自己像是在梦境之中……","你感到无比放松……")))
	return TRUE

/datum/status_effect/trance/on_creation(mob/living/new_owner, _duration, _stun = TRUE)
	duration = _duration
	stun = _stun
	return ..()

/datum/status_effect/trance/on_remove()
	UnregisterSignal(owner, COMSIG_MOVABLE_HEAR)
	REMOVE_TRAIT(owner, TRAIT_MUTE, TRAIT_STATUS_EFFECT(id))
	owner.remove_status_effect(/datum/status_effect/dizziness)
	owner.remove_client_colour(REF(src))
	to_chat(owner, span_warning("你从恍惚中惊醒！"))

/datum/status_effect/trance/get_examine_text()
	return span_warning("[owner.p_They()]看起来[owner.p_s()]迟缓且注意力不集中。")

/datum/status_effect/trance/proc/hypnotize(datum/source, list/hearing_args)
	SIGNAL_HANDLER

	if(HAS_TRAIT(owner, TRAIT_DEAF) || owner == hearing_args[HEARING_SPEAKER])
		return

	var/mob/hearing_speaker = hearing_args[HEARING_SPEAKER]
	var/mob/living/carbon/C = owner
	C.cure_trauma_type(/datum/brain_trauma/hypnosis, TRAUMA_RESILIENCE_SURGERY) //clear previous hypnosis
	// The brain trauma itself does its own set of logging, but this is the only place the source of the hypnosis phrase can be found.
	hearing_speaker.log_message("hypnotised [key_name(C)] with the phrase '[hearing_args[HEARING_RAW_MESSAGE]]'", LOG_ATTACK, color="red")
	C.log_message("has been hypnotised by the phrase '[hearing_args[HEARING_RAW_MESSAGE]]' spoken by [key_name(hearing_speaker)]", LOG_VICTIM, color="orange", log_globally = FALSE)
	addtimer(CALLBACK(C, TYPE_PROC_REF(/mob/living/carbon, gain_trauma), /datum/brain_trauma/hypnosis, TRAUMA_RESILIENCE_SURGERY, hearing_args[HEARING_RAW_MESSAGE]), 1 SECONDS)
	addtimer(CALLBACK(C, TYPE_PROC_REF(/mob/living, Stun), 60, TRUE, TRUE), 15) //Take some time to think about it
	qdel(src)

/datum/status_effect/spasms
	id = "spasms"
	status_type = STATUS_EFFECT_MULTIPLE
	alert_type = null

/datum/status_effect/spasms/tick(seconds_between_ticks)
	if(owner.stat >= UNCONSCIOUS || owner.incapacitated || HAS_TRAIT(owner, TRAIT_HANDS_BLOCKED) || HAS_TRAIT(owner, TRAIT_IMMOBILIZED))
		return
	if(!prob(15))
		return
	switch(rand(1,5))
		if(1)
			if((owner.mobility_flags & MOBILITY_MOVE) && isturf(owner.loc))
				to_chat(owner, span_warning("你的腿痉挛了！"))
				step(owner, pick(GLOB.cardinals))
		if(2)
			var/obj/item/held_item = owner.get_active_held_item()
			if(!held_item)
				return
			to_chat(owner, span_warning("你的手指痉挛了！"))
			owner.log_message("used [held_item] due to a Muscle Spasm", LOG_ATTACK)
			held_item.attack_self(owner)
		if(3)
			owner.set_combat_mode(TRUE)

			var/range = 1
			if(istype(owner.get_active_held_item(), /obj/item/gun)) //get targets to shoot at
				range = 7

			var/list/mob/living/targets = list()
			for(var/mob/living/nearby_mobs in oview(owner, range))
				targets += nearby_mobs
			if(LAZYLEN(targets))
				to_chat(owner, span_warning("你的手臂痉挛了！"))
				owner.log_message(" attacked someone due to a Muscle Spasm", LOG_ATTACK) //the following attack will log itself
				owner.ClickOn(pick(targets))
			owner.set_combat_mode(FALSE)
		if(4)
			owner.set_combat_mode(TRUE)
			to_chat(owner, span_warning("你的手臂痉挛了！"))
			owner.log_message("attacked [owner.p_them()]self to a Muscle Spasm", LOG_ATTACK)
			owner.ClickOn(owner)
			owner.set_combat_mode(FALSE)
		if(5)
			var/obj/item/held_item = owner.get_active_held_item()
			var/list/turf/targets = list()
			for(var/turf/nearby_turfs in oview(owner, 3))
				targets += nearby_turfs
			if(LAZYLEN(targets) && held_item)
				to_chat(owner, span_warning("你的手臂痉挛了！"))
				owner.log_message("threw [held_item] due to a Muscle Spasm", LOG_ATTACK)
				owner.throw_item(pick(targets))

/datum/status_effect/convulsing
	id = "convulsing"
	duration = 150
	status_type = STATUS_EFFECT_REFRESH
	alert_type = /atom/movable/screen/alert/status_effect/convulsing
	show_duration = TRUE

/datum/status_effect/convulsing/on_creation(mob/living/zappy_boy)
	. = ..()
	to_chat(zappy_boy, span_boldwarning("你感到一股电流穿过身体！你的手开始颤抖！"))

/datum/status_effect/convulsing/tick(seconds_between_ticks)
	var/mob/living/carbon/H = owner
	if(prob(40))
		var/obj/item/I = H.get_active_held_item()
		if(I && H.dropItemToGround(I))
			H.visible_message(
				span_notice("[H]的手抽搐了一下，他们丢掉了手中的[I.name]！"),
				span_userdanger("你的手剧烈抽搐，你丢掉了手里的东西！"),
			)
			H.adjust_jitter(10 SECONDS)

/atom/movable/screen/alert/status_effect/convulsing
	name = "颤抖之手"
	desc = "你被什么东西电到了，手抖个不停！你似乎什么都拿不稳。"
	use_user_hud_icon = USER_HUD_STYLE_INHERIT
	overlay_state = "convulsing"

/datum/status_effect/dna_melt
	id = "dna_melt"
	duration = 600
	status_type = STATUS_EFFECT_REPLACE
	alert_type = /atom/movable/screen/alert/status_effect/dna_melt
	var/kill_either_way = FALSE //no amount of removing mutations is gonna save you now

/datum/status_effect/dna_melt/on_creation(mob/living/new_owner, set_duration)
	. = ..()
	to_chat(new_owner, span_boldwarning("我的身体承受不了这些突变！我得赶紧移除突变！"))

/datum/status_effect/dna_melt/on_remove()
	if(!ishuman(owner))
		owner.gib(DROP_ALL_REMAINS) //fuck you in particular
		return
	var/mob/living/carbon/human/H = owner
	INVOKE_ASYNC(H, TYPE_PROC_REF(/mob/living/carbon/human, something_horrible), kill_either_way)

/atom/movable/screen/alert/status_effect/dna_melt
	name = "基因崩溃"
	desc = "I don't feel so good. Your body can't handle the mutations! You have one minute to remove your mutations, or you will be met with a horrible fate."
	use_user_hud_icon = USER_HUD_STYLE_INHERIT
	overlay_state = "dna_melt"

/datum/status_effect/go_away
	id = "go_away"
	duration = 10 SECONDS
	status_type = STATUS_EFFECT_REPLACE
	tick_interval = 0.2 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/go_away
	var/direction

/datum/status_effect/go_away/on_creation(mob/living/new_owner, set_duration)
	. = ..()
	direction = pick(NORTH, SOUTH, EAST, WEST)
	new_owner.setDir(direction)
	owner.add_traits(list(TRAIT_NO_FLOATING_ANIM, TRAIT_MOVE_FLYING), TRAIT_STATUS_EFFECT(id)) //I believe I can fly!

/datum/status_effect/go_away/tick(seconds_between_ticks)
	owner.AdjustStun(1, ignore_canstun = TRUE)
	var/turf/turf = get_step(owner, direction)
	if(!turf)
		qdel(src)
		return
	owner.forceMove(turf)

/datum/status_effect/go_away/on_remove()
	. = ..()
	owner.remove_traits(list(TRAIT_NO_FLOATING_ANIM, TRAIT_MOVE_FLYING), TRAIT_STATUS_EFFECT(id))

///Subtype of the go away effect (phases the mob in one direction) that deletes the owner on z-level change or when the time's up.
/datum/status_effect/go_away/deletes_mob
	id = "go_away_deletes_mob"
	duration = 30 SECONDS
	/// Timer that tracks when we should vanish
	var/deletion_timer

/datum/status_effect/go_away/deletes_mob/on_creation(mob/living/new_owner, set_duration)
	. = ..()
	deletion_timer = addtimer(CALLBACK(src, PROC_REF(wipe_bozo)), duration - 5 SECONDS, TIMER_STOPPABLE | TIMER_DELETE_ME)
	ADD_TRAIT(owner, TRAIT_IMMOBILIZED, REF(src))
	RegisterSignals(new_owner, list(COMSIG_MOVABLE_Z_CHANGED, COMSIG_LIVING_DEATH), PROC_REF(wipe_bozo))

/datum/status_effect/go_away/deletes_mob/proc/wipe_bozo()
	deltimer(deletion_timer)
	owner.fade_into_nothing()
	UnregisterSignal(owner, list(COMSIG_MOVABLE_Z_CHANGED, COMSIG_LIVING_DEATH))

/datum/status_effect/go_away/deletes_mob/on_remove()
	. = ..()
	deltimer(deletion_timer)
	REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, REF(src))
	UnregisterSignal(owner, list(COMSIG_MOVABLE_Z_CHANGED, COMSIG_LIVING_DEATH))

/atom/movable/screen/alert/status_effect/go_away
	name = "冲向星辰与远方！"
	desc = "我必须走了，我的人民需要我！"
	use_user_hud_icon = USER_HUD_STYLE_INHERIT
	overlay_state = "high"

/datum/status_effect/fake_virus
	id = "fake_virus"
	duration = 3 MINUTES //3 minutes
	status_type = STATUS_EFFECT_REPLACE
	tick_interval = 0.2 SECONDS
	alert_type = null
	var/msg_stage = 0//so you don't get the most intense messages immediately

/datum/status_effect/fake_virus/on_apply()
	if(HAS_TRAIT(owner, TRAIT_VIRUSIMMUNE))
		return FALSE
	if(owner.stat != CONSCIOUS)
		return FALSE
	return TRUE

/datum/status_effect/fake_virus/tick(seconds_between_ticks)
	var/fake_msg = ""
	var/fake_emote = ""
	switch(msg_stage)
		if(0 to 300)
			if(prob(1))
				fake_msg = pick(
				span_warning(pick("你的头很痛。", "你的头阵阵作痛。")),
				span_warning(pick("你呼吸困难。", "你的呼吸变得沉重。")),
				span_warning(pick("你感到头晕。", "你的头在发晕。")),
				span_warning(pick("你咽下了多余的黏液。", "你轻轻咳嗽了一下。")),
				span_warning(pick("你的头很痛。", "你的大脑空白了一瞬。")),
				span_warning(pick("你的喉咙很痛。", "你清了清嗓子。")))
		if(301 to 600)
			if(prob(2))
				fake_msg = pick(
				span_warning(pick("你的头很痛。", "你的头在不停地抽痛。")),
				span_warning(pick("你的气管感觉像根吸管。", "你的呼吸变得异常困难。")),
				span_warning("你感到非常[pick("dizzy","woozy","faint")]。"),
				span_warning(pick("你听到耳边传来一阵耳鸣。", "你的耳朵感到一阵鼓胀。")),
				span_warning("你打了个盹。"))
		else
			if(prob(3))
				if(prob(50))// coin flip to throw a message or an emote
					fake_msg = pick(
					span_userdanger(pick("你的头好痛！", "你感觉有把灼热的刀子在脑子里搅动！", "一阵剧痛充斥你的脑海！")),
					span_userdanger(pick("你的肺好痛！", "呼吸好痛！")),
					span_warning(pick("你感到恶心。", "你觉得快要吐出来了！")))
				else
					if(prob(40))
						fake_emote = "cough"
					else
						fake_emote = "sneeze"

	if(fake_emote)
		owner.emote(fake_emote)
	else if(fake_msg)
		to_chat(owner, fake_msg)

	msg_stage++

//Deals with ants covering someone.
/datum/status_effect/ants
	id = "ants"
	status_type = STATUS_EFFECT_REFRESH
	alert_type = /atom/movable/screen/alert/status_effect/ants
	duration = 2 MINUTES //Keeping the normal timer makes sure people can't somehow dump 300+ ants on someone at once so they stay there for like 30 minutes. Max w/ 1 dump is 57.6 brute.
	processing_speed = STATUS_EFFECT_NORMAL_PROCESS
	/// Will act as the main timer as well as changing how much damage the ants do.
	var/ants_remaining = 0
	/// Amount of damage done per ant on the victim
	var/damage_per_ant = 0.0016
	/// Common phrases people covered in ants scream
	var/static/list/ant_debuff_speech = list(
		"GET THEM OFF ME!!",
		"OH GOD THE ANTS!!",
		"MAKE IT END!!",
		"THEY'RE EVERYWHERE!!",
		"GET THEM OFF!!",
		"SOMEBODY HELP ME!!"
	)

/datum/status_effect/ants/on_creation(mob/living/new_owner, amount_left)
	if(isnum(amount_left) && new_owner.stat < HARD_CRIT)
		if(new_owner.stat < UNCONSCIOUS) // Unconscious people won't get messages
			to_chat(new_owner, span_userdanger("你浑身都是蚂蚁！"))
		ants_remaining += amount_left
		RegisterSignal(new_owner, COMSIG_COMPONENT_CLEAN_ACT, PROC_REF(ants_washed))
	. = ..()

/datum/status_effect/ants/refresh(effect, amount_left)
	var/mob/living/carbon/human/victim = owner
	if(isnum(amount_left) && ants_remaining >= 1 && victim.stat < HARD_CRIT)
		if(victim.stat < UNCONSCIOUS) // Unconscious people won't get messages
			if(!prob(1)) // 99%
				to_chat(victim, span_userdanger("你身上爬了更多的蚂蚁！"))
			else // 1%
				victim.say("AAHH! THIS SITUATION HAS ONLY BEEN MADE WORSE WITH THE ADDITION OF YET MORE ANTS!!", forced = /datum/status_effect/ants)
		ants_remaining += amount_left
	. = ..()

/datum/status_effect/ants/on_remove()
	ants_remaining = 0
	to_chat(owner, span_notice("所有的蚂蚁都从你身上掉下来了！"))
	UnregisterSignal(owner, COMSIG_COMPONENT_CLEAN_ACT)
	. = ..()

/datum/status_effect/ants/proc/ants_washed()
	SIGNAL_HANDLER

	. = NONE

	if(owner.remove_status_effect(/datum/status_effect/ants))
		return COMPONENT_CLEANED|COMPONENT_CLEANED_GAIN_XP

/datum/status_effect/ants/get_examine_text()
	return span_warning("[owner.p_They()] [owner.p_are()] 浑身都是蚂蚁！")

/datum/status_effect/ants/tick(seconds_between_ticks)
	var/mob/living/carbon/human/victim = owner
	victim.apply_damage(max(0.1, round((ants_remaining * damage_per_ant), 0.1)) * seconds_between_ticks, BRUTE, spread_damage = TRUE) //Scales with # of ants (lowers with time). Roughly 10 brute over 50 seconds.
	if(victim.stat <= SOFT_CRIT) //Makes sure people don't scratch at themselves while they're in a critical condition
		if(prob(15))
			switch(rand(1,2))
				if(1)
					victim.say(pick(ant_debuff_speech), forced = /datum/status_effect/ants)
				if(2)
					victim.emote("scream")
		if(prob(50)) // Most of the damage is done through random chance. When tested yielded an average 100 brute with 200u ants.
			switch(rand(1,50))
				if (1 to 8) //16% Chance
					to_chat(victim, span_danger("你抓挠着头皮上的蚂蚁！。"))
					owner.apply_damage(0.4 * seconds_between_ticks, BRUTE, BODY_ZONE_HEAD)
				if (9 to 29) //40% chance
					to_chat(victim, span_danger("你抓挠着手臂上的蚂蚁！"))
					owner.apply_damage(1.2 * seconds_between_ticks, BRUTE, pick(GLOB.arm_zones))
				if (30 to 49) //38% chance
					to_chat(victim, span_danger("你抓挠着腿上的蚂蚁！"))
					owner.apply_damage(1.2 * seconds_between_ticks, BRUTE, pick(GLOB.leg_zones))
				if(50) // 2% chance
					to_chat(victim, span_danger("你擦掉了一些眼睛周围的蚂蚁！"))
					victim.set_eye_blur_if_lower(6 SECONDS)
					ants_remaining -= 5 // To balance out the blindness, it'll be a little shorter.
	ants_remaining--
	if(ants_remaining <= 0 || victim.stat >= HARD_CRIT)
		qdel(src) //If this person has no more ants on them or are dead, they are no longer affected.

/atom/movable/screen/alert/status_effect/ants
	name = "蚂蚁！"
	desc = span_warning("我操他妈的耶稣！点击把这些东西弄掉！")
	use_user_hud_icon = USER_HUD_STYLE_INHERIT
	overlay_state = "antalert"
	clickable_glow = TRUE

/atom/movable/screen/alert/status_effect/ants/Click()
	. = ..()
	if(!.)
		return
	var/mob/living/living = owner
	if(!istype(living) || !living.can_resist() || living != owner)
		return
	to_chat(living, span_notice("你开始把蚂蚁抖掉！"))
	if(!do_after(living, 2 SECONDS, target = living))
		return
	for (var/datum/status_effect/ants/ant_covered in living.status_effects)
		to_chat(living, span_notice("你成功弄掉了一些蚂蚁！"))
		ant_covered.ants_remaining -= 10 // 5 Times more ants removed per second than just waiting in place

/datum/status_effect/ants/fire
	id = "fire_ants"
	alert_type = /atom/movable/screen/alert/status_effect/ants/fire
	damage_per_ant = 0.0064

/atom/movable/screen/alert/status_effect/ants/fire
	name = "火蚁！"
	desc = span_warning("我操他妈的耶稣好烫！点击把这些东西弄掉！")

/datum/status_effect/rebuked
	id = "rebuked"
	status_type = STATUS_EFFECT_REFRESH
	duration = 30 SECONDS
	tick_interval = 1 SECONDS
	alert_type = null
	/// By how much we should increase the attack cooldown
	var/cd_increase = 2.5

/datum/status_effect/rebuked/on_apply()
	owner.next_move_modifier *= 2
	if(ishostile(owner))
		var/mob/living/simple_animal/hostile/simple_owner = owner
		simple_owner.ranged_cooldown_time *= cd_increase
	return TRUE

/datum/status_effect/rebuked/on_remove()
	. = ..()
	if(QDELETED(owner))
		return
	owner.next_move_modifier *= 0.5
	if(ishostile(owner))
		var/mob/living/simple_animal/hostile/simple_owner = owner
		simple_owner.ranged_cooldown_time /= cd_increase

/datum/status_effect/freezing_blast
	id = "freezing_blast"
	alert_type = /atom/movable/screen/alert/status_effect/freezing_blast
	duration = 5 SECONDS
	status_type = STATUS_EFFECT_REPLACE

/atom/movable/screen/alert/status_effect/freezing_blast
	name = "冰冻冲击"
	desc = "你被一道寒冰冲击击中了！你的身体移动得更慢了！"
	icon_state = "frozen"

/datum/status_effect/freezing_blast/on_apply()
	owner.add_movespeed_modifier(/datum/movespeed_modifier/freezing_blast, update = TRUE)
	return ..()

/datum/status_effect/freezing_blast/on_remove()
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/freezing_blast, update = TRUE)

/datum/movespeed_modifier/freezing_blast
	multiplicative_slowdown = 1

/datum/status_effect/discoordinated
	id = "discoordinated"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/discoordinated

/atom/movable/screen/alert/status_effect/discoordinated
	name = "动作失调"
	desc = "你似乎无法正常使用任何东西..."
	use_user_hud_icon = USER_HUD_STYLE_INHERIT
	overlay_state = "convulsing"

/datum/status_effect/discoordinated/on_apply()
	ADD_TRAIT(owner, TRAIT_DISCOORDINATED_TOOL_USER, TRAIT_STATUS_EFFECT(id))
	return ..()

/datum/status_effect/discoordinated/on_remove()
	REMOVE_TRAIT(owner, TRAIT_DISCOORDINATED_TOOL_USER, TRAIT_STATUS_EFFECT(id))
	return ..()

///Maddly teleports the victim around all of space for 10 seconds
/datum/status_effect/teleport_madness
	id = "teleport_madness"
	duration = 10 SECONDS
	status_type = STATUS_EFFECT_REPLACE
	tick_interval = 0.2 SECONDS
	alert_type = null

/datum/status_effect/teleport_madness/tick(seconds_between_ticks)
	dump_in_space(owner)

/datum/status_effect/careful_driving
	id = "careful_driving"
	alert_type = /atom/movable/screen/alert/status_effect/careful_driving
	duration = 5 SECONDS
	status_type = STATUS_EFFECT_REPLACE

/datum/status_effect/careful_driving/on_apply()
	. = ..()
	owner.add_movespeed_modifier(/datum/movespeed_modifier/careful_driving, update = TRUE)

/datum/status_effect/careful_driving/on_remove()
	. = ..()
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/careful_driving, update = TRUE)

/atom/movable/screen/alert/status_effect/careful_driving
	name = "小心驾驶"
	desc = "好险！你差点就撞到那个了！"
	use_user_hud_icon = USER_HUD_STYLE_INHERIT
	overlay_state = "paralysis"

/datum/movespeed_modifier/careful_driving
	multiplicative_slowdown = 3

/datum/status_effect/midas_blight
	id = "midas_blight"
	alert_type = /atom/movable/screen/alert/status_effect/midas_blight
	status_type = STATUS_EFFECT_REPLACE
	tick_interval = 0.2 SECONDS
	remove_on_fullheal = TRUE

	/// The visual overlay state, helps tell both you and enemies how much gold is in your system
	var/midas_state = "midas_1"
	/// How fast the gold in a person's system scales.
	var/goldscale = 30 // x2.8 - Gives ~ 15u for 1 second

/datum/status_effect/midas_blight/on_creation(mob/living/new_owner, duration = 1)
	// Duration is already input in SECONDS
	src.duration = duration
	RegisterSignal(new_owner, COMSIG_ATOM_UPDATE_OVERLAYS, PROC_REF(on_update_overlays))
	return ..()

/atom/movable/screen/alert/status_effect/midas_blight
	name = "迈达斯灾厄"
	desc = "你的血液正在变成黄金，减缓了你的行动！"
	use_user_hud_icon = USER_HUD_STYLE_INHERIT
	overlay_state = "midas_blight"

/datum/status_effect/midas_blight/tick(seconds_between_ticks)
	var/mob/living/carbon/human/victim = owner
	// We're transmuting blood, time to lose some.
	victim.adjust_blood_volume(-5 * seconds_between_ticks, minimum = BLOOD_VOLUME_SURVIVE + 50)
	// This has been hell to try and balance so that you'll actually get anything out of it
	victim.reagents.add_reagent(/datum/reagent/gold/cursed, amount = seconds_between_ticks * goldscale, no_react = TRUE)
	var/current_gold_amount = victim.reagents.get_reagent_amount(/datum/reagent/gold, type_check = REAGENT_SUB_TYPE)
	switch(current_gold_amount)
		if(-INFINITY to 50)
			victim.add_movespeed_modifier(/datum/movespeed_modifier/status_effect/midas_blight/soft, update = TRUE)
			victim.add_actionspeed_modifier(/datum/actionspeed_modifier/status_effect/midas_blight/soft, update = TRUE)
			midas_state = "midas_1"
		if(50 to 100)
			victim.add_movespeed_modifier(/datum/movespeed_modifier/status_effect/midas_blight/medium, update = TRUE)
			victim.add_actionspeed_modifier(/datum/actionspeed_modifier/status_effect/midas_blight/medium, update = TRUE)
			midas_state = "midas_2"
		if(100 to 200)
			victim.add_movespeed_modifier(/datum/movespeed_modifier/status_effect/midas_blight/hard, update = TRUE)
			victim.add_actionspeed_modifier(/datum/actionspeed_modifier/status_effect/midas_blight/hard, update = TRUE)
			midas_state = "midas_3"
		if(200 to INFINITY)
			victim.add_movespeed_modifier(/datum/movespeed_modifier/status_effect/midas_blight/gold, update = TRUE)
			victim.add_actionspeed_modifier(/datum/actionspeed_modifier/status_effect/midas_blight/gold, update = TRUE)
			midas_state = "midas_4"
	victim.update_icon()
	if(victim.stat == DEAD)
		qdel(src) // Dead people stop being turned to gold. Don't want people sitting on dead bodies.

/datum/status_effect/midas_blight/proc/on_update_overlays(atom/parent_atom, list/overlays)
	SIGNAL_HANDLER

	if(midas_state)
		var/mutable_appearance/midas_overlay = mutable_appearance('icons/mob/effects/debuff_overlays.dmi', midas_state)
		midas_overlay.blend_mode = BLEND_MULTIPLY
		overlays += midas_overlay

/datum/status_effect/midas_blight/on_remove()
	owner.remove_movespeed_modifier(MOVESPEED_ID_MIDAS_BLIGHT, update = TRUE)
	owner.remove_actionspeed_modifier(ACTIONSPEED_ID_MIDAS_BLIGHT, update = TRUE)
	UnregisterSignal(owner, COMSIG_ATOM_UPDATE_OVERLAYS)
	owner.update_icon()

// Desginated Target - Applied typically by Flare lasers

/atom/movable/screen/alert/status_effect/designated_target
	name = "指定目标"
	desc = "你被某种明亮的能量标记了！洗掉它来摆脱标记，否则你会更容易被击中！"
	use_user_hud_icon = USER_HUD_STYLE_INHERIT
	overlay_state = "designated_target"

/datum/status_effect/designated_target
	id = "designated_target"
	duration = 2 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/designated_target
	status_type = STATUS_EFFECT_REFRESH
	/// Dummy lighting object for our flare attached to our mob
	var/obj/effect/dummy/lighting_obj/moblight/mob_flare

/datum/status_effect/designated_target/on_apply()
	mob_flare = owner.mob_light(3, 15, LIGHT_COLOR_FLARE)
	ADD_TRAIT(owner, TRAIT_DESIGNATED_TARGET, id)
	owner.add_filter("designated_target", 3, list("type" = "outline", "color" = COLOR_RED, "size" = 1))
	return TRUE

/datum/status_effect/designated_target/tick(seconds_between_ticks)
	// If we are ever wet, remove our flare status effect
	var/datum/status_effect/fire_handler/wet_stacks/splashed_with_water = locate() in owner.status_effects
	if(istype(splashed_with_water))
		qdel(src)

/datum/status_effect/designated_target/on_remove()
	QDEL_NULL(mob_flare)
	owner.remove_filter("designated_target")
	REMOVE_TRAIT(owner, TRAIT_DESIGNATED_TARGET, id)

#undef HEALING_SLEEP_DEFAULT
#undef HEALING_SLEEP_ORGAN_MULTIPLIER
#undef SLEEP_QUALITY_WORKOUT_MULTIPLER
