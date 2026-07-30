// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
// This file contains the proc we use for revenant harvesting because it is a very long and bulky proc that takes up a lot of space elsewhere

/// Container proc for `harvest()`, handles the pre-checks as well as potential early-exits for any reason.
/// Will return FALSE if we can't execute `harvest()`, or will otherwise the result of `harvest()`: a boolean value.
/mob/living/basic/revenant/proc/attempt_harvest(mob/living/carbon/human/target)
	if(LAZYFIND(drained_mobs, REF(target)))
		to_chat(src, span_revenwarning(LANG("mob.d5c3424a", list(target))))
		return FALSE

	if(!cast_check(0))
		return FALSE

	if(draining)
		to_chat(src, span_revenwarning(LANG("mob.d3329021", null)))
		return FALSE

	if(target.flags_1 & HOLOGRAM_1)
		target.balloon_alert(src, LANG("mob.706c83c6", null)) // it's a machine generated visual
		return

	draining = TRUE
	var/value_to_return = harvest_soul(target)
	if(!value_to_return)
		log_combat(src, target, "stopped the harvest of")
	draining = FALSE

	return value_to_return

/// Harvest; activated by clicking a target, will try to drain their essence. Handles all messages and handling of the target.
/// Returns FALSE if we exit out of the harvest, TRUE if it is fully done.
/mob/living/basic/revenant/proc/harvest_soul(mob/living/carbon/human/target) // this isn't in the main revenant code file because holyyyy shit it's long
	if(QDELETED(target)) // what
		return FALSE

	// cache pronouns in case they get deleted as well as be a nice micro-opt due to the multiple times we use them
	var/target_their = target.p_their()
	var/target_Their = target.p_Their()
	var/target_Theyre = target.p_Theyre()
	var/target_They_have = "[target.p_They()] [target.p_have()]"

	if(!IS_UNCONSCIOUS_OR_CRIT(target))
		to_chat(src, span_revennotice(LANG("mob.06f14de0", list(target_Their))))
		if(prob(10))
			to_chat(target, span_revennotice(LANG("mob.8e99b5a2", null)))
		return FALSE

	log_combat(src, target, "started to harvest")
	face_atom(target)
	var/essence_drained = rand(15, 20)

	to_chat(src, span_revennotice(LANG("mob.a713eacd", list(target))))

	if(!do_after(src, (rand(10, 20) DECISECONDS), target, timed_action_flags = IGNORE_HELD_ITEM)) //did they get deleted in that second?
		return FALSE

	var/target_has_client = !isnull(target.client)
	if(target_has_client || target.ckey) // any target that has been occupied with a ckey is considered "intelligent"
		to_chat(src, span_revennotice(LANG("mob.8bff636f", list(target_Their))))
		essence_drained += rand(20, 30)

	if(target.stat != DEAD && !HAS_TRAIT(target, TRAIT_WEAK_SOUL))
		to_chat(src, span_revennotice(LANG("mob.3c3d4b34", list(target_Their))))
		essence_drained += rand(40, 50)

	if(!target_has_client && HAS_TRAIT(target, TRAIT_WEAK_SOUL))
		to_chat(src, span_revennotice(LANG("mob.b1c5d34c", list(target_Their))))
		essence_drained = 5

	to_chat(src, span_revennotice(LANG("mob.e6f4c2f2", list(target_Their))))

	if(!do_after(src, (rand(15, 20) DECISECONDS), target, timed_action_flags = IGNORE_HELD_ITEM))
		to_chat(src, span_revennotice(LANG("mob.53b22301", null)))
		return FALSE

	switch(essence_drained)
		if(1 to 30)
			to_chat(src, span_revennotice(LANG("mob.57c0a392", list(target))))
		if(30 to 70)
			to_chat(src, span_revennotice(LANG("mob.9bf81dae", list(target))))
		if(70 to 90)
			to_chat(src, span_revenboldnotice(LANG("mob.92833fd0", list(target))))
		if(90 to INFINITY)
			to_chat(src, span_revenbignotice(LANG("mob.1271f729", list(target))))

	if(!do_after(src, (rand(15, 25) DECISECONDS), target, timed_action_flags = IGNORE_HELD_ITEM)) //how about now
		to_chat(src, span_revenwarning(LANG("mob.bcf6fa71", list(target ? "[target]'s" : "[target_their]"))))
		return FALSE

	if(!IS_UNCONSCIOUS_OR_CRIT(target))
		to_chat(src, span_revenwarning(LANG("mob.19eab391", list(target_Theyre))))
		to_chat(target, span_bolddanger(LANG("mob.a7981ec3", null))) //hey, wait a minute...
		return FALSE

	to_chat(src, span_revenminor(LANG("mob.c0dc69c6", list(target))))
	if(target.stat != DEAD)
		to_chat(target, span_warning(LANG("mob.9bf26099", null)))
	if(target.stat == SOFT_CRIT)
		target.Stun(4.6 SECONDS)

	apply_status_effect(/datum/status_effect/revenant/revealed, 5 SECONDS)
	apply_status_effect(/datum/status_effect/incapacitating/paralyzed/revenant, 5 SECONDS)

	target.visible_message(span_warning(LANG("mob.a0d2e872", list(target, target_their))))

	if(target.can_block_magic(MAGIC_RESISTANCE_HOLY))
		to_chat(src, span_revenminor(LANG("mob.c9211b98", list(target))))
		target.visible_message(
			span_warning(LANG("mob.ca7c6bf1", list(target))),
			span_revenwarning(LANG("mob.4b327eec", null)),
		)
		return FALSE

	var/datum/beam/draining_beam = Beam(target, icon_state = "drain_life")
	if(!do_after(src, 4.6 SECONDS, target, timed_action_flags = (IGNORE_HELD_ITEM | IGNORE_INCAPACITATED))) //As one cannot prove the existence of ghosts, ghosts cannot prove the existence of the target they were draining.
		to_chat(src, span_revenwarning(LANG("mob.dc233f8f", list(target ? "[target]'s soul has" : "[target_They_have]"))))
		if(target)
			target.visible_message(
				span_warning(LANG("mob.ca7c6bf1", list(target))),
				span_revenwarning(LANG("mob.4b327eec", null)),
			)
		qdel(draining_beam)
		return FALSE

	change_essence_amount(essence_drained, FALSE, target)

	if(essence_drained <= 90 && target.stat != DEAD && !HAS_TRAIT(target, TRAIT_WEAK_SOUL))
		max_essence += 5
		to_chat(src, span_revenboldnotice(LANG("mob.1dd900c5", list(target, max_essence))))

	if(essence_drained > 90)
		max_essence += 15
		perfectsouls++
		to_chat(src, span_revenboldnotice(LANG("mob.abc98246", list(target, max_essence))))

	to_chat(src, span_revennotice(LANG("mob.2816985d", list(target))))
	target.visible_message(
		span_warning(LANG("mob.ca7c6bf1", list(target))),
		span_revenwarning(LANG("mob.979ffd67", null)),
	)

	LAZYADD(drained_mobs, REF(target))
	if(target.stat != DEAD)
		target.investigate_log("has died from revenant harvest.", INVESTIGATE_DEATHS)
	target.death(FALSE)

	qdel(draining_beam)
	return TRUE
