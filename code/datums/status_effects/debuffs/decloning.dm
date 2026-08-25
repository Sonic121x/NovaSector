// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/// The amount of mutadone we can process for strike recovery at once.
#define MUTADONE_HEAL 1

/datum/status_effect/decloning
	id = "decloning"
	tick_interval = 3 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/decloning
	remove_on_fullheal = TRUE

	/// How many strikes our status effect holder has left before they are dusted.
	var/strikes_left = 100

/datum/status_effect/decloning/on_apply()
	if(owner.has_reagent(/datum/reagent/medicine/mutadone))
		return FALSE
	to_chat(owner, span_userdanger(LANG("datum.d0f4a9b65c96f872", null)))
	return TRUE

/datum/status_effect/decloning/on_remove()
	if(!QDELETED(owner)) // bigger problems to worry about
		owner.remove_movespeed_modifier(/datum/movespeed_modifier/decloning)

/datum/status_effect/decloning/tick(seconds_between_ticks)
	if(owner.has_reagent(/datum/reagent/medicine/mutadone, MUTADONE_HEAL * seconds_between_ticks))
		var/strike_restore = MUTADONE_HEAL * seconds_between_ticks

		if(strikes_left <= 50 && strikes_left + strike_restore > 50)
			to_chat(owner, span_notice(LANG("datum.234e2b4806076044", null)))
			owner.remove_movespeed_modifier(/datum/movespeed_modifier/decloning)
		else if(SPT_PROB(5, seconds_between_ticks))
			to_chat(owner, span_warning(LANG("datum.44c655ec7825334d", null)))

		strikes_left = min(strikes_left + strike_restore, 100)

		owner.reagents.remove_reagent(/datum/reagent/medicine/mutadone, MUTADONE_HEAL * seconds_between_ticks)

		if(strikes_left == 100)
			qdel(src)

		return

	if(!SPT_PROB(5, seconds_between_ticks))
		return

	var/strike_reduce = 3
	if(strikes_left > 50 && strikes_left - strike_reduce <= 50)
		to_chat(owner, span_danger(LANG("datum.f8aab29b4baf3396", null)))
		owner.add_movespeed_modifier(/datum/movespeed_modifier/decloning)

	strikes_left = max(strikes_left - strike_reduce, 0)

	if(prob(50))
		to_chat(owner, span_danger(pick(
			"Your body is giving in.",
			"You feel some muscles twitching.",
			"Your skin feels sandy.",
			"You feel your limbs shifting around.",
		)))
	else if(prob(33))
		to_chat(owner, span_danger(LANG("datum.c57cd2ac7d8d3112", null)))
		owner.set_jitter_if_lower(30 SECONDS)

	if(strikes_left == 0)
		owner.visible_message(span_danger(LANG("datum.4134b29778560156", list(owner))), span_boldwarning(LANG("datum.5a99cf6c1fa16f23", null)))
		owner.dust()
		return

/datum/status_effect/decloning/get_examine_text(mob/examiner)
	switch(strikes_left)
		if(68 to 100)
			return span_warning("[owner.p_Their()] body looks a bit deformed.")
		if(34 to 67)
			return span_warning("[owner.p_Their()] body looks <b>very</b> deformed.")
		if(-INFINITY to 33)
			return span_boldwarning("[owner.p_Their()] body looks severely deformed!")

/atom/movable/screen/alert/status_effect/decloning
	name = "Cellular Meltdown"
	desc = "Your body is deforming, and doesn't feel like it's going to hold up much longer. You are going to need treatment soon."
	use_user_hud_icon = USER_HUD_STYLE_INHERIT
	overlay_state = "dna_melt"

/datum/movespeed_modifier/decloning
	multiplicative_slowdown = 0.7
	blacklisted_movetypes = (FLYING|FLOATING)

#undef MUTADONE_HEAL
