
/datum/action/cooldown/spell/pointed/abyssal_gaze
	name = "Abyssal Gaze-深渊凝视"
	desc = "这个咒语会给你的目标灌输一种深深的恐惧，使其暂时变冷并致盲。"
	ranged_mousepointer = 'icons/effects/mouse_pointers/cult_target.dmi'
	background_icon_state = "bg_demon"
	overlay_icon_state = "bg_demon_border"

	button_icon = 'icons/mob/actions/actions_cult.dmi'
	button_icon_state = "abyssal_gaze"

	school = SCHOOL_EVOCATION
	cooldown_time = 75 SECONDS
	invocation_type = INVOCATION_NONE
	spell_requirements = NONE
	antimagic_flags = MAGIC_RESISTANCE|MAGIC_RESISTANCE_HOLY|MAGIC_RESISTANCE_MIND

	cast_range = 5
	active_msg = "You prepare to instill a deep terror in a target..."

	/// The duration of the blind on our target
	var/blind_duration = 4 SECONDS
	/// The amount of temperature we take from our target
	var/amount_to_cool = 200

/datum/action/cooldown/spell/pointed/abyssal_gaze/is_valid_target(atom/cast_on)
	return iscarbon(cast_on)

/datum/action/cooldown/spell/pointed/abyssal_gaze/cast(mob/living/carbon/cast_on)
	. = ..()
	if(cast_on.can_block_magic(antimagic_flags))
		to_chat(owner, span_warning("法术没有效果！"))
		to_chat(cast_on, span_warning("你感到一股刺骨的黑暗正在逼近，但它迅速消散了。"))
		return FALSE

	to_chat(cast_on, span_userdanger("一股刺骨的黑暗包围了你……"))
	cast_on.playsound_local(get_turf(cast_on), 'sound/effects/hallucinations/i_see_you1.ogg', 50, 1)
	owner.playsound_local(get_turf(owner), 'sound/effects/ghost2.ogg', 50, 1)
	cast_on.adjust_temp_blindness(blind_duration)
	if(ishuman(cast_on))
		var/mob/living/carbon/human/human_cast_on = cast_on
		human_cast_on.adjust_coretemperature(-amount_to_cool)
	cast_on.adjust_bodytemperature(-amount_to_cool)
