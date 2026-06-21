/datum/status_effect/tower_of_babel
	id = "tower_of_babel"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/tower_of_babel
	var/trait_source

/datum/status_effect/tower_of_babel/on_creation(mob/living/new_owner, duration = 15 SECONDS)
	src.duration = duration
	if(isnull(trait_source))
		trait_source = TRAIT_STATUS_EFFECT(id)
	return ..()

/datum/status_effect/tower_of_babel/on_apply()
	var/random_language = pick(GLOB.all_languages)
	owner.grant_language(random_language, source = LANGUAGE_BABEL)
	// block every language except the randomized one
	owner.add_blocked_language(GLOB.all_languages - random_language, source = LANGUAGE_BABEL)
	// this lets us bypass tongue language restrictions except for people who have stuff like mute,
	// no tongue, tongue tied, etc. curse of babel shouldn't let people who have a tongue disability speak
	if(owner.mind)
		ADD_TRAIT(owner.mind, TRAIT_TOWER_OF_BABEL, trait_source)
	owner.add_mood_event(id, /datum/mood_event/tower_of_babel)
	return ..()

/datum/status_effect/tower_of_babel/on_remove()
	owner.clear_mood_event(id)
	// if user is affected by tower of babel, we remove the blocked languages
	owner.remove_blocked_language(GLOB.all_languages, source = LANGUAGE_BABEL)
	owner.remove_all_languages(source = LANGUAGE_BABEL)
	if(owner.mind)
		REMOVE_TRAIT(owner.mind, TRAIT_TOWER_OF_BABEL, trait_source)
	return ..()

// Used by wizard magic and tower of babel event
/datum/status_effect/tower_of_babel/magical
	id = "tower_of_babel_magic" // do we need a new id?
	duration = STATUS_EFFECT_PERMANENT
	trait_source = TRAUMA_TRAIT

/datum/status_effect/tower_of_babel/magical/on_apply()
	. = ..()
	if(!.)
		return

	owner.emote("mumble")
	owner.playsound_local(get_turf(owner), 'sound/effects/magic/magic_block_mind.ogg', 75, vary = TRUE) // sound of creepy whispers
	to_chat(owner, span_reallybig(span_hypnophrase("你感觉到一股魔法力量正在影响你的说话方式！")))

/datum/status_effect/tower_of_babel/magical/on_remove()
	. = ..()
	if(!.)
		return

	to_chat(owner, span_reallybig(span_hypnophrase("你感觉到影响你说话方式的魔法力量逐渐消退了...")))

/atom/movable/screen/alert/status_effect/tower_of_babel
	name = "巴别塔"
	desc = "你似乎在用一种奇怪的语言胡言乱语..."
	use_user_hud_icon = USER_HUD_STYLE_INHERIT
	overlay_state = "mind_control"
