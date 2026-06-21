///Status effect applied when casting a fishing rod at someone, provided the attached fishing hook allows it.
/datum/status_effect/grouped/hooked
	id = "hooked"
	duration = STATUS_EFFECT_PERMANENT
	tick_interval = STATUS_EFFECT_NO_TICK
	status_type = STATUS_EFFECT_MULTIPLE
	alert_type = /atom/movable/screen/alert/status_effect/hooked

/datum/status_effect/grouped/hooked/proc/try_unhook()
	return do_after(owner, 2 SECONDS, timed_action_flags = IGNORE_USER_LOC_CHANGE, extra_checks = CALLBACK(src, PROC_REF(still_exists)), interaction_key = DOAFTER_SOURCE_REMOVING_HOOK)

/datum/status_effect/grouped/hooked/proc/still_exists()
	return !QDELETED(src)

/datum/status_effect/grouped/hooked/source_added(datum/beam/fishing_line/source)
	RegisterSignal(source, COMSIG_QDELETING, PROC_REF(on_fishing_line_deleted))

/datum/status_effect/grouped/hooked/proc/on_fishing_line_deleted(datum/source)
	SIGNAL_HANDLER
	owner.remove_status_effect(type, source)

/atom/movable/screen/alert/status_effect/hooked
	name = "被钩子钩住"
	desc = "你正像条鱼一样被某个混蛋钓着！点击以安全取下钩子，或者移动足够远的距离将其扯断。"
	use_user_hud_icon = USER_HUD_STYLE_INHERIT
	overlay_state = "hooked"
	clickable_glow = TRUE

/atom/movable/screen/alert/status_effect/hooked/Click()
	. = ..()
	if(!.)
		return
	if(!owner.can_resist())
		return
	owner.balloon_alert(owner, "正在移除钩子……")
	var/datum/status_effect/grouped/hooked/effect = owner.has_status_effect(attached_effect.type)
	if(!effect.try_unhook())
		return
	owner.balloon_alert(owner, "钩子已移除")
	var/datum/beam/fishing_line/rand_source = pick(effect.sources)
	qdel(rand_source)

///Version used by the jawed fishing hook, which also applies slowdown
/datum/status_effect/grouped/hooked/jaws
	id = "hooked_jaws"
	alert_type = /atom/movable/screen/alert/status_effect/hooked/jaws

/datum/status_effect/grouped/hooked/jaws/on_apply()
	. = ..()
	owner.add_movespeed_modifier(/datum/movespeed_modifier/hook_jawed)

/datum/status_effect/grouped/hooked/jaws/on_remove()
	. = ..()
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/hook_jawed)

/datum/status_effect/grouped/hooked/jaws/try_unhook()
	return do_after(owner, 10 SECONDS, extra_checks = CALLBACK(src, PROC_REF(still_exists)), interaction_key = DOAFTER_SOURCE_REMOVING_HOOK)

/atom/movable/screen/alert/status_effect/hooked/jaws
	name = "被颚夹钩住"
	desc = "你被某种捕兽夹兼钓鱼钩的玩意儿钩住了！点击以安全取下钩子，或者移动足够远的距离将其扯断。"
	use_user_hud_icon = USER_HUD_STYLE_INHERIT
	overlay_state = "hooked_jaws"
