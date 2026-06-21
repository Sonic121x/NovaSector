/// Drugginess / "high" effect, makes your screen rainbow
/datum/status_effect/drugginess
	id = "drugged"
	alert_type = /atom/movable/screen/alert/status_effect/high
	remove_on_fullheal = TRUE

/datum/status_effect/drugginess/on_creation(mob/living/new_owner, duration = 10 SECONDS)
	src.duration = duration
	return ..()

/datum/status_effect/drugginess/on_apply()
	RegisterSignal(owner, COMSIG_LIVING_DEATH, PROC_REF(remove_drugginess))

	owner.add_mood_event(id, /datum/mood_event/high)
	owner.overlay_fullscreen(id, /atom/movable/screen/fullscreen/high)
	owner.sound_environment_override = SOUND_ENVIRONMENT_DRUGGED
	owner.grant_language(/datum/language/beachbum, source = id)
	return TRUE

/datum/status_effect/drugginess/on_remove()
	UnregisterSignal(owner, COMSIG_LIVING_DEATH)

	owner.clear_mood_event(id)
	owner.clear_fullscreen(id)
	if(owner.sound_environment_override == SOUND_ENVIRONMENT_DRUGGED)
		owner.sound_environment_override = SOUND_ENVIRONMENT_NONE
	owner.remove_language(/datum/language/beachbum, source = id)

/// Removes all of our drugginess (self delete) on signal
/datum/status_effect/drugginess/proc/remove_drugginess(datum/source, admin_revive)
	SIGNAL_HANDLER

	qdel(src)

/// The status effect for "drugginess"
/atom/movable/screen/alert/status_effect/high
	name = "嗨了"
	desc = "哇哦老兄，你嗨过头了！小心别上瘾……如果你还没上的话。"
	use_user_hud_icon = USER_HUD_STYLE_INHERIT
	overlay_state = "high"
