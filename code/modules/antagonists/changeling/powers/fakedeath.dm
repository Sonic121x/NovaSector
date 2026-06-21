/datum/action/changeling/fakedeath
	name = "复苏停滞"
	desc = "使我们进入假死停滞状态，允许我们欺骗敌人与稍后重生. 使用消耗15化学点"
	button_icon_state = "fake_death"
	chemical_cost = 15
	dna_cost = CHANGELING_POWER_INNATE
	req_dna = 1
	req_stat = DEAD
	ignores_fakedeath = TRUE
	disabled_by_fire = FALSE

	/// How long it takes for revival to ready upon entering stasis.
	/// The changeling can opt to stay in fakedeath for longer, though.
	var/fakedeath_duration = 40 SECONDS
	/// If TRUE, we're ready to revive and can click the button to heal.
	var/revive_ready = FALSE

//Fake our own death and fully heal. You will appear to be dead but regenerate fully after a short delay.
/datum/action/changeling/fakedeath/sting_action(mob/living/user)
	..()
	if(revive_ready)
		INVOKE_ASYNC(src, PROC_REF(revive), user)
		return TRUE

	var/death_duration_mod = 1
	if(user.has_status_effect(/datum/status_effect/gutted))
		death_duration_mod *= 8 // Anti-megafauna cheese

	if(!enable_fakedeath(user, duration_modifier = death_duration_mod))
		CRASH("Changeling revive failed to enter fakedeath when it should have been in a valid state to.")

	to_chat(user, span_changeling("我们开始进入停滞状态，积蓄能量以待重生。"))
	if(death_duration_mod > 1)
		to_chat(user, span_changeling(span_bold("我们的身体遭受了严重损伤，再生将需要 [death_duration_mod >= 5 ? "far ":""]更长的时间。")))
	return TRUE

/// Used to enable fakedeath and register relevant signals / start timers
/datum/action/changeling/fakedeath/proc/enable_fakedeath(mob/living/changeling, duration_modifier = 1)
	if(revive_ready || HAS_TRAIT_FROM(changeling, TRAIT_DEATHCOMA, CHANGELING_TRAIT))
		return

	changeling.fakedeath(CHANGELING_TRAIT)
	ADD_TRAIT(changeling, TRAIT_STASIS, CHANGELING_TRAIT)
	addtimer(CALLBACK(src, PROC_REF(ready_to_regenerate), changeling), fakedeath_duration * duration_modifier, TIMER_UNIQUE)
	// Basically, these let the ling exit stasis without giving away their ling-y-ness if revived through other means
	RegisterSignal(changeling, SIGNAL_REMOVETRAIT(TRAIT_DEATHCOMA), PROC_REF(fakedeath_reset))
	RegisterSignal(changeling, COMSIG_MOB_STATCHANGE, PROC_REF(on_stat_change))
	return TRUE

/// Removes the signals for fakedeath and listening for hapless doctors
/// healing a changeling who went into stasis after actually dying, and
/// also removes changeling stasis
/datum/action/changeling/fakedeath/proc/disable_stasis_and_fakedeath(mob/living/changeling)
	REMOVE_TRAIT(changeling, TRAIT_STASIS, CHANGELING_TRAIT)
	UnregisterSignal(changeling, SIGNAL_REMOVETRAIT(TRAIT_DEATHCOMA))
	UnregisterSignal(changeling, COMSIG_MOB_STATCHANGE)

/// This proc is called to reset the chemical cost of the revival
/// as well as the revive ready flag and button states.
/datum/action/changeling/fakedeath/proc/reset_chemical_cost()
	chemical_cost = 15
	revive_ready = FALSE
	build_all_button_icons(UPDATE_BUTTON_NAME|UPDATE_BUTTON_ICON)

/// Sets [revive_ready] to TRUE and updates the button icons.
/datum/action/changeling/fakedeath/proc/enable_revive(mob/living/changeling)
	if(revive_ready)
		return

	chemical_cost = 0
	revive_ready = TRUE
	build_all_button_icons(UPDATE_BUTTON_NAME|UPDATE_BUTTON_ICON)

/// Signal proc to stop the revival process if the changeling exits their stasis early.
/datum/action/changeling/fakedeath/proc/fakedeath_reset(mob/living/source)
	SIGNAL_HANDLER

	if(HAS_TRAIT_FROM(source, TRAIT_DEATHCOMA, CHANGELING_TRAIT))
		return

	disable_stasis_and_fakedeath(source)

/// Signal proc to exit fakedeath early if we're revived from being previously dead
/datum/action/changeling/fakedeath/proc/on_stat_change(mob/living/source, new_stat, old_stat)
	SIGNAL_HANDLER

	if(old_stat != DEAD)
		return

	source.cure_fakedeath(CHANGELING_TRAIT)
	to_chat(source, span_changeling("我们提前结束了停滞状态。"))
	reset_chemical_cost()

/datum/action/changeling/fakedeath/proc/revive(mob/living/carbon/user)
	if(!istype(user))
		return
	if(!HAS_TRAIT_FROM(user, TRAIT_DEATHCOMA, CHANGELING_TRAIT))
		return

	user.cure_fakedeath(CHANGELING_TRAIT)
	// Heal all damage and some minor afflictions,
	var/flags_to_heal = (HEAL_DAMAGE|HEAL_BODY|HEAL_STATUS|HEAL_CC_STATUS)
	// but leave out limbs so we can do it specially
	user.revive(flags_to_heal & ~HEAL_LIMBS)
	to_chat(user, span_changeling("我们已经复活了自己。"))

	var/static/list/dont_regenerate = list(BODY_ZONE_HEAD) // headless changelings are funny
	if(!length(user.get_missing_limbs() - dont_regenerate))
		return

	playsound(user, 'sound/effects/magic/demon_consume.ogg', 50, TRUE)
	user.visible_message(
		span_warning("[user]缺失的肢体重新生长，发出响亮而怪异的声响！"),
		span_userdanger("你的肢体正在再生，发出响亮的嘎吱声并带来巨大的痛苦！"),
		span_hear("你听到有机物质撕裂的声音！"),
	)
	user.emote("scream")
	// Manually call this (outside of revive/fullheal) so we can pass our blacklist
	user.regenerate_limbs(dont_regenerate)

/datum/action/changeling/fakedeath/proc/ready_to_regenerate(mob/user)
	if(QDELETED(src) || QDELETED(user))
		return

	var/datum/antagonist/changeling/ling = IS_CHANGELING(user)
	if(QDELETED(ling) || !(src in (ling.innate_powers + ling.purchased_powers))) // checking both innate and purchased for full coverage
		return
	if(!HAS_TRAIT_FROM(user, TRAIT_DEATHCOMA, CHANGELING_TRAIT))
		return

	to_chat(user, span_changeling("我们已准备好复活。"))
	enable_revive(user)

/datum/action/changeling/fakedeath/can_sting(mob/living/user)
	if(revive_ready)
		return ..()

	if(!can_enter_stasis(user))
		return
	//Confirmation for living changelings if they want to fake their death
	if(user.stat != DEAD)
		if(tgui_alert(user, "我们确定要假死吗？", "假死", list("Yes", "No")) != "Yes")
			return
		if(QDELETED(user) || QDELETED(src) || !can_enter_stasis(user))
			return

	return ..()

/// We wait until after we actually deduct chemical cost (or don't deduct
/// if it's the 0 cost we get for revival) before we reset the chemical cost
/datum/action/changeling/fakedeath/try_to_sting(mob/living/user)
	. = ..()
	if (!. || !revive_ready)
		return
	reset_chemical_cost()

/datum/action/changeling/fakedeath/proc/can_enter_stasis(mob/living/user)
	if(HAS_TRAIT_FROM(user, TRAIT_DEATHCOMA, CHANGELING_TRAIT))
		user.balloon_alert(user, "已在复活中！")
		return FALSE
	return TRUE

/datum/action/changeling/fakedeath/update_button_name(atom/movable/screen/movable/action_button/button, force)
	if(revive_ready)
		name = "复苏"
		desc = "我们再次复活"
	else
		name = "复苏停滞"
		desc = "使我们进入假死停滞状态，允许我们欺骗敌人与稍后重生"
	return ..()

/datum/action/changeling/fakedeath/apply_button_icon(atom/movable/screen/movable/action_button/current_button, force)
	button_icon_state = revive_ready ? "revive" : "fake_death"
	return ..()
