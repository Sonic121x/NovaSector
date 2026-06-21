/// How much terror is applied upon first cast of Terrify
#define TERROR_INITIAL_AMOUNT 100
/// Amount of terror caused by subsequent casting of the Terrify spell.
#define STACK_TERROR_AMOUNT 135

/datum/status_effect/terrified
	id = "terrified"
	status_type = STATUS_EFFECT_REFRESH
	remove_on_fullheal = TRUE
	alert_type = /atom/movable/screen/alert/status_effect/terrified

/datum/status_effect/terrified/on_apply()
	to_chat(owner, span_alert("黑暗向你逼近，阴影在你视野边缘舞动……感觉有什么东西在注视着你！"))
	owner.emote("scream")
	owner.AddComponentFrom("terrified", /datum/component/fearful, list(/datum/terror_handler/simple_source/nyctophobia/terrified), TERROR_INITIAL_AMOUNT)
	return TRUE

/datum/status_effect/terrified/on_remove()
	owner.RemoveComponentSource("terrified", /datum/component/fearful)

/datum/status_effect/terrified/refresh(effect, ...)
	// Jank way of adding terror to the existing component
	owner.AddComponentFrom("terrified", /datum/component/fearful, null, STACK_TERROR_AMOUNT)

/// The status effect popup for the terror status effect
/atom/movable/screen/alert/status_effect/terrified
	name = "惊恐！"
	desc = "你感到一股超自然的黑暗笼罩了你，恐慌将你淹没！快躲到光里去！"
	use_user_hud_icon = USER_HUD_STYLE_INHERIT
	overlay_state = "terrified"

#undef TERROR_INITIAL_AMOUNT
#undef STACK_TERROR_AMOUNT
