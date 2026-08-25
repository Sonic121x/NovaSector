#define MAXIMUM_MARAUDERS 2

/datum/scripture/marauder
	name = "Summon Clockwork Marauder"
	desc = "Summons a Clockwork Marauder, a powerful warrior that can deflect ranged attacks. Requires 100 vitality."
	tip = "Use Clockwork Marauders as a powerful soldier to send into combat when the fighting gets rough."
	button_icon_state = "Clockwork Marauder"
	power_cost = 2000
	vitality_cost = 100
	invocation_time = 30 SECONDS
	invocation_text = list("Through the fires and flames...", "nothing outshines Eng'Ine!")
	category = SPELLTYPE_PRESERVATION
	cogs_required = 6
	invokers_required = 3
	// Ref to the selected observer
	var/mob/dead/observer/selected


/datum/scripture/marauder/Destroy(force)
	selected = null
	return ..()


/datum/scripture/marauder/invoke()
	var/list/candidates = SSpolling.poll_ghost_candidates(
		"Do you want to play as a Clockwork Marauder?",
		role = ROLE_PAI,
		check_jobban = FALSE,
		poll_time = 10 SECONDS,
		ignore_category = POLL_IGNORE_CONSTRUCT,
		alert_pic = /obj/item/clockwork/clockwork_slab,
		role_name_text = "clockwork marauder",
	)
	if(length(candidates))
		selected = pick(candidates)

	if(!selected)
		to_chat(invoker, span_brass(LANG("datum.55e31e60f0925e08", null)))
		invoke_fail()

		if(invocation_chant_timer)
			deltimer(invocation_chant_timer)
			invocation_chant_timer = null

		end_invoke()
		return
	return ..()


/datum/scripture/marauder/invoke_success()
	var/mob/living/basic/clockwork_marauder/new_mob = new (get_turf(invoker))
	new_mob.visible_message(span_notice(LANG("datum.85df479e2d0b2d1d", list(new_mob))))
	new_mob.PossessByPlayer(selected.key)
	to_chat(new_mob, span_brass(LANG("datum.8504fe2798a10e5a", list(new_mob.shield_health))))
	selected = null


/datum/scripture/marauder/check_special_requirements(mob/user)
	. = ..()
	if(!.)
		return FALSE

	if(length(GLOB.clockwork_marauders) >= MAXIMUM_MARAUDERS)
		to_chat(user, span_brass(LANG("datum.abea725a58fd6093", list(MAXIMUM_MARAUDERS))))
		return FALSE

	return TRUE

#undef MAXIMUM_MARAUDERS
