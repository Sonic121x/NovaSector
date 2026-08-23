// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
// Terror effect handlers

/// Macro to scale a base value from 0x to ?x based on the current terror level, clamped to the base value
#define FEAR_SCALING(base, min, max) clamp(base * (terror_buildup - min) / (max - min), 0, base)

/// Causes mild jittering, scaling with current terror level
/datum/terror_handler/jittering
	handler_type = TERROR_HANDLER_EFFECT
	default = TRUE
	COOLDOWN_DECLARE(message_cd)

/datum/terror_handler/jittering/tick(seconds_per_tick, terror_buildup)
	. = ..()
	if (IS_UNCONSCIOUS(owner))
		return

	if (terror_buildup < TERROR_BUILDUP_FEAR)
		return

	// If we're terrified, keep constant jittering and dizzyness
	if (terror_buildup > TERROR_BUILDUP_TERROR)
		owner.adjust_dizzy_up_to(10 SECONDS * seconds_per_tick, 10 SECONDS)
		owner.adjust_jitter_up_to(10 SECONDS * seconds_per_tick, 10 SECONDS)
		return

	if (!SPT_PROB(1 + FEAR_SCALING(4, TERROR_BUILDUP_FEAR, TERROR_BUILDUP_TERROR), seconds_per_tick)) // 1% to 5% chance
		return

	if (COOLDOWN_FINISHED(src, message_cd) && !owner.has_status_effect(/datum/status_effect/jitter)) // Don't display the message if we're already shaking
		to_chat(owner, span_warning(LANG("datum.49a14aaaa3eb75c4", null)))
		COOLDOWN_START(src, message_cd, TERROR_MESSAGE_CD)

	owner.set_jitter_if_lower(20 SECONDS)
	owner.set_dizzy_if_lower(20 SECONDS)

/// Stutter when afraid
/datum/terror_handler/stuttering
	handler_type = TERROR_HANDLER_EFFECT
	default = TRUE

/datum/terror_handler/stuttering/tick(seconds_per_tick, terror_buildup)
	. = ..()
	if (IS_UNCONSCIOUS(owner))
		return

	if (terror_buildup < TERROR_BUILDUP_FEAR)
		return

	if (terror_buildup > TERROR_BUILDUP_TERROR || SPT_PROB(1 + FEAR_SCALING(4, TERROR_BUILDUP_FEAR, TERROR_BUILDUP_TERROR), seconds_per_tick))
		owner.set_stutter_if_lower(10 SECONDS)

/// Can randomly give you some oxyloss, and cause a heart attack past TERROR_BUILDUP_HEART_ATTACK
/datum/terror_handler/heart_problems
	handler_type = TERROR_HANDLER_EFFECT
	default = TRUE
	COOLDOWN_DECLARE(message_cd)

/datum/terror_handler/heart_problems/tick(seconds_per_tick, terror_buildup)
	. = ..()
	if (IS_UNCONSCIOUS(owner))
		return

	if (terror_buildup < TERROR_BUILDUP_FEAR)
		return

	if (!SPT_PROB(1 + FEAR_SCALING(4, TERROR_BUILDUP_FEAR, TERROR_BUILDUP_PANIC), seconds_per_tick)) // 1% to 5% chance
		return

	if (terror_buildup < TERROR_BUILDUP_HEART_ATTACK || !prob(15))
		owner.adjust_oxy_loss(8)
		if (!COOLDOWN_FINISHED(src, message_cd))
			return
		COOLDOWN_START(src, message_cd, TERROR_MESSAGE_CD)
		if (terror_buildup < TERROR_BUILDUP_FEAR)
			to_chat(owner, span_warning(LANG("datum.9cfe197bbd44ec99", null)))
		else
			to_chat(owner, span_userdanger(LANG("datum.006209003f3c3fc4", null)))
		return

	owner.visible_message(
		span_warning(LANG("datum.9290185c2767d1d5", list(owner, owner.p_their()))),
		span_alert(LANG("datum.c57c064ddf500c2d", null)),
		span_hear(LANG("datum.a632fb775dfeed9a", null)),
	)
	owner.apply_status_effect(/datum/status_effect/heart_attack)
	owner.Unconscious(20 SECONDS)

/// Low chance to vomit when terrified, increases significantly during panic attacks
/datum/terror_handler/vomiting
	handler_type = TERROR_HANDLER_EFFECT

/datum/terror_handler/vomiting/tick(seconds_per_tick, terror_buildup)
	. = ..()
	if (IS_UNCONSCIOUS(owner))
		return

	if (terror_buildup < TERROR_BUILDUP_TERROR)
		return

	if (SPT_PROB((terror_buildup >= TERROR_BUILDUP_PANIC) ? 3 : 1, seconds_per_tick))
		to_chat(owner, span_warning(LANG("datum.7220d46a9dd730c6", null)))
		// Vomit blood if we're *really* freaking out
		addtimer(CALLBACK(owner, TYPE_PROC_REF(/mob/living/carbon, vomit), terror_buildup >= TERROR_BUILDUP_PASSIVE_MAXIMUM), 5 SECONDS)

/// Causes tunnel vision, blurry eyes and periodic panic attacks when panicking
/datum/terror_handler/panic
	handler_type = TERROR_HANDLER_EFFECT
	default = TRUE
	/// Has the panic message been shown yet?
	var/active = FALSE
	/// Are we in a state of a panic attack currently? Only really used for tracking our breath loop
	var/active_attack = FALSE
	/// Breath loop used during a panic attack
	var/datum/looping_sound/breathing/breath_loop
	/// Timer that will stop our panic attack
	var/panic_end_timer = null

/datum/terror_handler/panic/New(mob/living/new_owner, datum/component/fearful/new_component)
	. = ..()
	breath_loop = new(owner, _direct = TRUE)

/datum/terror_handler/panic/Destroy(force)
	owner.remove_fov_trait(type, FOV_270_DEGREES)
	QDEL_NULL(breath_loop)
	deltimer(panic_end_timer)
	return ..()

/datum/terror_handler/panic/tick(seconds_per_tick, terror_buildup)
	. = ..()
	if (IS_UNCONSCIOUS(owner))
		stop_panic_attack()
		active = FALSE
		owner.remove_fov_trait(type, FOV_270_DEGREES)
		return

	if (terror_buildup < TERROR_BUILDUP_PANIC)
		if (active_attack) // No you don't
			return TERROR_BUILDUP_PANIC - terror_buildup
		active = FALSE
		owner.remove_fov_trait(type, FOV_270_DEGREES)
		return

	if (!active)
		active = TRUE
		to_chat(owner, span_userdanger(LANG("datum.90ff785f00310735", null)))
		owner.add_fov_trait(type, FOV_270_DEGREES) // Terror induced tunnel vision

	owner.playsound_local(owner, 'sound/effects/health/slowbeat.ogg', 40, FALSE, channel = CHANNEL_HEARTBEAT, use_reverb = FALSE)
	if (SPT_PROB(5, seconds_per_tick))
		owner.set_eye_blur_if_lower(10 SECONDS)

	if (active_attack)
		owner.losebreath += 0.25 // Miss 1/4 breaths
		return

	if (SPT_PROB(2 + FEAR_SCALING(3, TERROR_BUILDUP_PANIC, TERROR_BUILDUP_MAXIMUM), seconds_per_tick))
		. += panic_attack(terror_buildup)

/datum/terror_handler/panic/proc/panic_attack(terror_buildup)
	active_attack = TRUE
	owner.emote("gasp")
	owner.Knockdown(0.5 SECONDS)
	breath_loop.start()
	panic_end_timer = addtimer(CALLBACK(src, PROC_REF(stop_panic_attack)), rand(3 SECONDS, 5 SECONDS), TIMER_UNIQUE|TIMER_STOPPABLE)
	owner.visible_message(span_warning(LANG("datum.10e292a504029c5b", list(owner))), span_alert(LANG("datum.9cdc8d0a5ac16902", null)))
	return PANIC_ATTACK_TERROR_AMOUNT

/datum/terror_handler/panic/proc/stop_panic_attack()
	breath_loop.stop()
	active_attack = FALSE
	deltimer(panic_end_timer)
	panic_end_timer = null

/datum/terror_handler/startle
	handler_type = TERROR_HANDLER_EFFECT
	COOLDOWN_DECLARE(startle_cd)

/datum/terror_handler/startle/tick(seconds_per_tick, terror_buildup)
	. = ..()
	if (IS_UNCONSCIOUS(owner) || !COOLDOWN_FINISHED(src, startle_cd))
		return

	if (terror_buildup < TERROR_BUILDUP_FEAR || terror_buildup - component.last_tick_buildup < TERROR_STARTLE_MINIMUM_DIFFERENCE)
		return

	// The more scared we are, and the more fear we acquired at once last tick, the higher the probability of us being startled is
	// Not SPT_PROB or FEAR_SCALING because this is only triggered during ticks when we actually acquire fear
	if (!prob(15 * (terror_buildup - component.last_tick_buildup) / TERROR_STARTLE_MINIMUM_DIFFERENCE * terror_buildup / TERROR_BUILDUP_FEAR))
		return

	COOLDOWN_START(src, startle_cd, TERROR_STARTLE_COOLDOWN)
	switch (rand(1, 3))
		if (1)
			to_chat(owner, span_warning(LANG("datum.c2110630c1348441", null)))
			owner.emote("jump")
			owner.Immobilize(0.1 SECONDS * (terror_buildup / TERROR_BUILDUP_FEAR))

		if (2)
			owner.emote("scream")
			owner.say(LANG("datum.3aaaabb4c817ca48", null), forced = "phobia")
			if (!prob(15 * (terror_buildup / TERROR_BUILDUP_FEAR)))
				return
			var/held_item = owner.get_active_held_item()
			if (owner.dropItemToGround(held_item))
				owner.visible_message(
					span_danger(LANG("datum.654b172517839dcc", list(owner.name, held_item))),
					span_warning(LANG("datum.bbdacc315fa5700b", list(held_item))), null, COMBAT_MESSAGE_RANGE)

		if (3)
			to_chat(owner, span_warning(LANG("datum.03e28c7a09820428", null)))
			owner.adjust_staggered_up_to(2 SECONDS * (terror_buildup / TERROR_BUILDUP_FEAR), 20 SECONDS)
			owner.add_movespeed_modifier(/datum/movespeed_modifier/status_effect/spooked)
			addtimer(CALLBACK(src, PROC_REF(speed_up)), 3 SECONDS, TIMER_STOPPABLE | TIMER_DELETE_ME)

/datum/terror_handler/startle/proc/speed_up()
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/status_effect/spooked)

/// Forces you to stop, drop, and roll when on fire and sufficiently panicked
/datum/terror_handler/force_stop_drop_roll
	handler_type = TERROR_HANDLER_EFFECT

/datum/terror_handler/force_stop_drop_roll/tick(seconds_per_tick, terror_buildup)
	if (terror_buildup < TERROR_BUILDUP_FEAR || !owner.on_fire || !owner.can_resist())
		return 0

	if (!SPT_PROB(5 + FEAR_SCALING(10, TERROR_BUILDUP_FEAR, TERROR_BUILDUP_MAXIMUM), seconds_per_tick)) // 5% to 15% chance
		return 0

	// basically forces you to stop, drop, and roll, and prevents you from cancelling it
	var/forced_roll_duration = FEAR_SCALING(67.5 SECONDS, TERROR_BUILDUP_FEAR, TERROR_BUILDUP_MAXIMUM)
	owner.Immobilize(forced_roll_duration)
	owner.Knockdown(forced_roll_duration)
	if(owner.has_status_effect(/datum/status_effect/stop_drop_roll))
		to_chat(owner, span_warning(LANG("datum.69d9cd1d0246fa03", null)))
	else
		to_chat(owner, span_warning(LANG("datum.9cb78ee344599882", null)))
		owner.apply_status_effect(/datum/status_effect/stop_drop_roll, TRUE)

	return -1 * TERROR_BUILDUP_PASSIVE_DECREASE // + immediate terror decrease because you think it's helping!

#undef FEAR_SCALING
