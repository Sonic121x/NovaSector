/datum/status_effect/woozy
	id = "woozy"
	tick_interval = STATUS_EFFECT_NO_TICK
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/woozy

/datum/status_effect/woozy/nextmove_modifier()
	return 1.5

/atom/movable/screen/alert/status_effect/woozy
	name = "眩晕"
	desc = "你感觉比平时慢了一点，似乎用手做事比平时花的时间更长。"
	use_user_hud_icon = USER_HUD_STYLE_INHERIT
	overlay_state = "woozy"

/datum/status_effect/high_blood_pressure
	id = "high_blood_pressure"
	tick_interval = STATUS_EFFECT_NO_TICK
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/high_blood_pressure

/datum/status_effect/high_blood_pressure/on_apply()
	if(!ishuman(owner))
		return FALSE

	var/mob/living/carbon/human/human_owner = owner
	human_owner.physiology.bleed_mod *= 1.25
	return TRUE

/datum/status_effect/high_blood_pressure/on_remove()
	if(!ishuman(owner))
		return

	var/mob/living/carbon/human/human_owner = owner
	human_owner.physiology.bleed_mod /= 1.25

/atom/movable/screen/alert/status_effect/high_blood_pressure
	name = "高血压"
	desc = "你的血压现在非常高……你可能会像被刺中的猪一样流血不止。"
	use_user_hud_icon = USER_HUD_STYLE_INHERIT
	overlay_state = "highbloodpressure"

/datum/status_effect/seizure
	id = "seizure"
	tick_interval = STATUS_EFFECT_NO_TICK
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/seizure

/datum/status_effect/seizure/on_apply()
	if(!iscarbon(owner))
		return FALSE
	var/amplitude = rand(1 SECONDS, 3 SECONDS)
	duration = amplitude
	owner.set_jitter_if_lower(100 SECONDS)
	owner.Paralyze(duration)
	owner.visible_message(span_warning("[owner] 摔倒在地，[owner.p_they()] 的身体开始抽搐。"), \
	span_warning("[pick("You can't collect your thoughts...", "You suddenly feel extremely dizzy...", "You can't think straight...","You can't move your face properly anymore...")]"))
	return TRUE

/atom/movable/screen/alert/status_effect/seizure
	name = "癫痫发作"
	desc = "FJOIWEHUWQEFGYUWDGHUIWHUIDWEHUIFDUWGYSXQHUIODSDBNJKVBNKDML <--- 这就是你现在的状态"
	use_user_hud_icon = USER_HUD_STYLE_INHERIT
	overlay_state = "paralysis"

/datum/status_effect/stoned
	id = "stoned"
	duration = 10 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/stoned
	status_type = STATUS_EFFECT_REFRESH

/datum/status_effect/stoned/on_apply()
	if(!ishuman(owner))
		return FALSE
	var/mob/living/carbon/human/human_owner = owner
	human_owner.add_movespeed_modifier(/datum/movespeed_modifier/reagent/cannabis) //slows you down
	human_owner.add_eye_color(BLOODCULT_EYE, EYE_COLOR_WEED_PRIORITY) //makes cult eyes less obvious
	human_owner.add_traits(list(TRAIT_CLUMSY, TRAIT_BLOODSHOT_EYES), TRAIT_STATUS_EFFECT(id)) // impairs motor coordination and dilates blood vessels in eyes
	human_owner.add_mood_event("stoned", /datum/mood_event/stoned) //improves mood
	human_owner.sound_environment_override = SOUND_ENVIRONMENT_DRUGGED //not realistic but very immersive
	return TRUE

/datum/status_effect/stoned/on_remove()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/human_owner = owner
	human_owner.remove_movespeed_modifier(/datum/movespeed_modifier/reagent/cannabis)
	human_owner.remove_eye_color(EYE_COLOR_WEED_PRIORITY)
	human_owner.remove_traits(list(TRAIT_CLUMSY, TRAIT_BLOODSHOT_EYES), TRAIT_STATUS_EFFECT(id))
	human_owner.clear_mood_event("stoned")
	human_owner.sound_environment_override = SOUND_ENVIRONMENT_NONE

/atom/movable/screen/alert/status_effect/stoned
	name = "恍惚"
	desc = "大麻正在损害你的速度、运动技能和心智认知。"
	icon_state = "stoned"
