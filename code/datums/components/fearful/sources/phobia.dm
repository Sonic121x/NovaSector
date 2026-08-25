// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/// Complex terror source that increases buildup whenever the owner hears, sees, or tries to say something they're afraid of
/datum/terror_handler/phobia_source
	handler_type = TERROR_HANDLER_SOURCE
	bespoke = TRUE
	/// Last time we got scared shitless for passive increase in fear
	/// Regex for words that set the phobia off
	var/regex/trigger_regex
	// NOVA EDIT ADDITION START - i18n: 本地化触发词的第二条正则（中文等无词边界语言）
	/// 本地化触发词正则。英文表用 \b 词边界，中文字符两侧都不是 \w、产生不了边界，只能另建一条
	/// 无边界正则并列匹配。分组布局与 trigger_regex 一致，故两者可互换使用（见 matching_regex）。
	var/regex/trigger_regex_localized
	// NOVA EDIT ADDITION END
	// Instead of cycling every atom, only cycle the relevant types
	var/list/trigger_mobs
	/// Includes mob equipment
	var/list/trigger_objs
	var/list/trigger_turfs
	var/list/trigger_species
	/// What mood event to apply when we see the thing & freak out.
	var/mood_event_type = /datum/mood_event/phobia
	/// Cooldown for proximity checks so we don't spam a range 7 view every two seconds.
	COOLDOWN_DECLARE(check_cooldown)
	/// Cooldown for the actual scare effect so chat spam won't instantly send us spiraling
	COOLDOWN_DECLARE(scare_cooldown)

/datum/terror_handler/phobia_source/New(mob/living/new_owner, datum/component/fearful/new_component)
	. = ..()
	RegisterSignal(new_owner, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	RegisterSignal(new_owner, COMSIG_MOVABLE_HEAR, PROC_REF(handle_hearing))

/datum/terror_handler/phobia_source/Destroy(force)
	UnregisterSignal(owner, list(COMSIG_MOB_SAY, COMSIG_MOVABLE_HEAR))
	return ..()

// NOVA EDIT ADDITION START - i18n: 英文/本地化两条触发正则并列匹配
/// 返回命中 `text` 的那条触发正则（未命中返回 null）。
/// 依赖 `regex.Find()` 的副作用：命中后 `.group` 已填好，调用方可直接用 `.group[2]` / `.Replace($2)`。
/datum/terror_handler/phobia_source/proc/matching_regex(text)
	if(trigger_regex?.Find(text))
		return trigger_regex
	if(trigger_regex_localized?.Find(text))
		return trigger_regex_localized
	return null
// NOVA EDIT ADDITION END

/datum/terror_handler/phobia_source/proc/can_trigger()
	return !HAS_TRAIT(owner, TRAIT_FEARLESS) && !HAS_TRAIT(owner, TRAIT_MIND_TEMPORARILY_GONE) && !IS_UNCONSCIOUS(owner)

/datum/terror_handler/phobia_source/tick(seconds_per_tick, terror_buildup)
	. = ..()
	if (!can_trigger())
		return

	// If we're still scared from the last trigger, keep adding just a tiiiiny buildup to prevent it from fading away
	if (!COOLDOWN_FINISHED(src, scare_cooldown))
		return 0.01

	if(!COOLDOWN_FINISHED(src, check_cooldown) || owner.is_blind())
		return

	COOLDOWN_START(src, check_cooldown, PHOBIA_CHECK_DELAY)
	if(LAZYLEN(trigger_objs))
		for (var/obj/seen_thing in view(owner.client?.view || world.view, owner))
			if(is_scary_item(seen_thing))
				return freak_out(seen_thing)

	if(LAZYLEN(trigger_turfs))
		for(var/turf/checked in view(owner.client?.view || world.view, owner))
			if(is_type_in_typecache(checked, trigger_turfs))
				return freak_out(checked)

	if(LAZYLEN(trigger_mobs) || LAZYLEN(trigger_species) || LAZYLEN(trigger_objs))
		for(var/mob/living/checked in view(owner.client?.view || world.view, owner))
			if (checked != owner && is_scary_mob(checked))
				return freak_out(checked)

/// Returns true if this item should be scary to us
/datum/terror_handler/phobia_source/proc/is_scary_item(obj/checked)
	if (QDELETED(checked) || !is_type_in_typecache(checked, trigger_objs) || checked.invisibility > owner.see_invisible)
		return FALSE

	if (!isitem(checked) || !ismob(checked.loc) || HAS_TRAIT(checked.loc, TRAIT_UNKNOWN_APPEARANCE))
		return TRUE

	var/obj/item/checked_item = checked
	return !HAS_TRAIT(checked_item, TRAIT_EXAMINE_SKIP)

/datum/terror_handler/phobia_source/proc/is_scary_mob(mob/living/checked)
	if (checked.invisibility > owner.see_invisible || checked.alpha == 0)
		return FALSE

	if (is_type_in_typecache(checked, trigger_mobs))
		return TRUE

	if (!ishuman(checked))
		return FALSE

	var/mob/living/carbon/human/as_human = checked
	if (LAZYLEN(trigger_species))
		// Can't be racist(?) if you can't see their face
		if (is_type_in_typecache(as_human.dna?.species, trigger_species) && !as_human.is_face_obscured())
			return TRUE

	if (!LAZYLEN(trigger_objs))
		return FALSE

	for (var/obj/item/equipped as anything in as_human.get_visible_items())
		if (is_scary_item(equipped))
			return TRUE

	return FALSE

/datum/terror_handler/phobia_source/proc/handle_hearing(datum/source, list/hearing_args)
	SIGNAL_HANDLER

	if (!can_trigger() || !COOLDOWN_FINISHED(src, scare_cooldown))
		return

	// Words can't trigger you if you can't hear them *taps head*
	if(HAS_TRAIT(owner, TRAIT_DEAF) || owner == hearing_args[HEARING_SPEAKER] || !owner.has_language(hearing_args[HEARING_LANGUAGE]))
		return

	// NOVA EDIT CHANGE START - i18n: 走 matching_regex 以兼顾本地化触发词
	var/regex/hit = matching_regex(hearing_args[HEARING_RAW_MESSAGE])
	if(hit)
		// To react AFTER the chat message
		addtimer(CALLBACK(src, PROC_REF(freak_out), null, hit.group[2]), 1 SECONDS)
		hearing_args[HEARING_RAW_MESSAGE] = hit.Replace(hearing_args[HEARING_RAW_MESSAGE], "[span_phobia("$2")]$3")
	// NOVA EDIT CHANGE END

/datum/terror_handler/phobia_source/proc/handle_speech(datum/source, list/speech_args)
	SIGNAL_HANDLER

	if (!can_trigger())
		return

	// NOVA EDIT CHANGE START - i18n: 走 matching_regex 以兼顾本地化触发词 - ORIGINAL: if (trigger_regex.Find(speech_args[SPEECH_MESSAGE]) == 0)
	var/regex/hit = matching_regex(speech_args[SPEECH_MESSAGE])
	if (isnull(hit))
		return
	// NOVA EDIT CHANGE END

	var/stutter = prob(50)
	var/whisper = prob(30)

	if (!stutter && !whisper)
		return

	if (whisper)
		speech_args[SPEECH_SPANS] |= SPAN_SMALL_VOICE
	if (stutter)
		owner.set_stutter_if_lower(4 SECONDS)
	to_chat(owner, span_warning(LANG("datum.1bc8e353256d52c6", list(span_phobia("[hit.group[2]]"))))) // NOVA EDIT CHANGE - i18n - ORIGINAL: ...trigger_regex.group[2]...

/datum/terror_handler/phobia_source/proc/freak_out(reason)
	COOLDOWN_START(src, scare_cooldown, 12 SECONDS)
	var/message = pick("spooks you to the bone", "shakes you up", "terrifies you", "sends you into a panic", "sends chills down your spine")
	if(istext(reason))
		to_chat(owner, span_bolddanger(LANG("datum.e05ad8d83ce57b84", list(span_phobia(reason), message))))
		owner.add_mood_event("phobia_minor", /datum/mood_event/startled)
		// Because this is called from a signal and not the main process, we need to add the buildup by hand
		if (component.terror_buildup < TERROR_BUILDUP_PASSIVE_MAXIMUM)
			component.terror_buildup = min(component.terror_buildup + PHOBIA_WORD_TERROR_BUILDUP, TERROR_BUILDUP_PASSIVE_MAXIMUM)
		return

	if(mood_event_type)
		owner.add_mood_event("phobia", mood_event_type)

	if(isatom(reason))
		var/atom/as_atom = reason
		to_chat(owner, span_bolddanger(LANG("datum.567b92a917d4f7d3", list(span_phobia("[as_atom.name]"), message))))
	else
		to_chat(owner, span_bolddanger(LANG("datum.52e199c8868a438c", list(message))))
	return PHOBIA_FREAKOUT_TERROR_BUILDUP

/datum/terror_handler/phobia_source/on_hug(mob/living/hugger)
	if (is_scary_mob(hugger))
		return HUG_TERROR_AMOUNT
	return 0

/// Snowflake handler for hemophobia which triggers on bloodied items and mobs
/datum/terror_handler/phobia_source/blood

/datum/terror_handler/phobia_source/blood/is_scary_item(obj/checked)
	if (GET_ATOM_BLOOD_DNA_LENGTH(checked))
		return TRUE
	return ..()

/datum/terror_handler/phobia_source/blood/is_scary_mob(mob/living/checked)
	if (GET_ATOM_BLOOD_DNA_LENGTH(checked))
		return TRUE
	return ..()
