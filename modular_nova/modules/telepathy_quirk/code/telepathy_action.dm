/datum/mutation/telepathy
	power_path = /datum/action/cooldown/spell/pointed/telepathy

/datum/action/cooldown/spell/pointed/telepathy
	name = "Telepathic Communication"
	desc = "<b>Left click</b>: point target to project a thought to them. <b>Right click</b>: project to your last thought target, if in range."
	button_icon = 'icons/mob/actions/actions_revenant.dmi'
	button_icon_state = "r_transmit"
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC
	antimagic_flags = MAGIC_RESISTANCE_MIND
	cooldown_time = 1 SECONDS
	cast_range = 7
	/// What's the last mob we point-targeted with this ability?
	var/datum/weakref/last_target_ref
	/// The message we send
	var/message
	/// Are we blocking casts?
	var/blocked = FALSE

/datum/action/cooldown/spell/pointed/telepathy/is_valid_target(atom/cast_on)
	. = ..()
	if (!.)
		return FALSE

	if (!isliving(cast_on))
		to_chat(owner, span_warning(LANG("datum.86d94ab73c1ea485", null)))
		owner.balloon_alert(owner, LANG("datum.54c4ac3501ebe84b", null))
		return FALSE

	var/mob/living/living_target = cast_on
	if (living_target.stat == DEAD)
		to_chat(owner, span_warning(LANG("datum.d4f4d012f1ea7fc4", null)))
		owner.balloon_alert(owner, LANG("datum.db17d585ff1e76ee", null))
		return FALSE

	if (get_dist(living_target, owner) > cast_range)
		owner.balloon_alert(owner, LANG("datum.a462ee7cec0ddb47", null))
		return FALSE

	return TRUE

/datum/action/cooldown/spell/pointed/telepathy/before_cast(atom/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST || blocked)
		return

	message = autopunct_bare(capitalize(tgui_input_text(owner, LANG("datum.39b36bd335a62961", list(cast_on)), "[src]", max_length = MAX_MESSAGE_LEN)))
	if(QDELETED(src) || QDELETED(owner) || QDELETED(cast_on) || !can_cast_spell())
		return . | SPELL_CANCEL_CAST

	if(get_dist(cast_on, owner) > cast_range)
		owner.balloon_alert(owner, LANG("datum.d000a673ca4d930e", null))
		return . | SPELL_CANCEL_CAST

	if(!message || length(message) == 0)
		reset_spell_cooldown()
		return . | SPELL_CANCEL_CAST

/datum/action/cooldown/spell/pointed/telepathy/Trigger(trigger_flags, atom/target)
	if (trigger_flags & TRIGGER_SECONDARY_ACTION)
		var/mob/living/last_target = last_target_ref?.resolve()

		if(isnull(last_target))
			last_target_ref = null
			owner.balloon_alert(owner, LANG("datum.15c94c57136b17c3", null))
			return
		else if(get_dist(last_target, owner) > cast_range)
			owner.balloon_alert(owner, LANG("datum.d8fecc167f13b0d3", list(last_target)))
			return

		blocked = TRUE

		message = autopunct_bare(capitalize(tgui_input_text(owner, LANG("datum.39b36bd335a62961", list(last_target)), "[src]", null, max_length = MAX_MESSAGE_LEN, multiline = TRUE)))
		if(QDELETED(src) || QDELETED(owner) || QDELETED(last_target) || !can_cast_spell())
			blocked = FALSE
			return
		send_thought(owner, last_target, message)
		src.StartCooldown()
		blocked = FALSE
		return

	return ..()

/datum/action/cooldown/spell/pointed/telepathy/cast(mob/living/cast_on)
	. = ..()
	owner.visible_message(
		span_warning(LANG("datum.f7ffc2f37d231f36", list(owner, cast_on))),
		ignored_mobs = owner,
	)
	send_thought(owner, cast_on, message)

/datum/action/cooldown/spell/pointed/telepathy/proc/send_thought(mob/living/caster, mob/living/target, message)
	log_directed_talk(caster, target, message, LOG_SAY, tag = "telepathy")

	last_target_ref = WEAKREF(target)

	to_chat(owner, span_boldnotice(LANG("datum.db13527cc2930cae", list(target, span_purple(message)))))
	// flub a runechat chat message, do something with the language later
	if(owner.client?.prefs.read_preference(/datum/preference/toggle/enable_runechat))
		owner.create_chat_message(owner, owner.get_selected_language(), message, list("italics"))
	if(!target.can_block_magic(antimagic_flags, charge_cost = 0) && target.client && !(HAS_TRAIT(target, TRAIT_PSIONIC_DAMPENER))) //make sure we've got a client before we bother sending anything
		//different messaging if the target has the telepathy mutation themselves themselves
		if (ishuman(caster))
			var/mob/living/carbon/human/human_caster = caster
			var/datum/mutation/telepathy/tele_mut = human_caster.dna.get_mutation(/datum/mutation/telepathy)

			if (tele_mut)
				to_chat(target, span_boldnotice(LANG("datum.4660e348b28d8e0e", list(span_purple(message)))))
			else
				to_chat(target, span_boldnotice(LANG("datum.2c5cb7b9feb0b25d", list(caster, span_purple(message)))))

		if(target.client?.prefs.read_preference(/datum/preference/toggle/enable_runechat))
			target.create_chat_message(target, target.get_selected_language(), message, list("italics")) // it appears over them since they hear it in their head
	else
		owner.balloon_alert(owner, LANG("datum.072288c904000437", null))
		to_chat(owner, span_warning(LANG("datum.3719244803f34715", null)))
		return

	// send to ghosts as well i guess
	for(var/mob/dead/ghost as anything in GLOB.dead_mob_list)
		if(!isobserver(ghost))
			continue

		var/from_link = FOLLOW_LINK(ghost, owner)
		var/from_mob_name = span_boldnotice("[owner]")
		var/to_link = FOLLOW_LINK(ghost, target)
		var/to_mob_name = span_name("[target]")

		to_chat(ghost, "[from_link] " + span_purple("<b>\[Telepathy\]</b> [from_mob_name] transmits, \"[message]\"") + " to [to_mob_name] [to_link]")
