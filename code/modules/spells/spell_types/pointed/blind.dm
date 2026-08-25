// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/action/cooldown/spell/pointed/blind
	name = "Blind"
	desc = "This spell temporarily blinds a single target."
	button_icon_state = "blind"
	ranged_mousepointer = 'icons/effects/mouse_pointers/blind_target.dmi'

	sound = 'sound/effects/magic/blind.ogg'
	school = SCHOOL_TRANSMUTATION
	cooldown_time = 30 SECONDS
	cooldown_reduction_per_rank = 6.25 SECONDS

	invocation = "STI KALY."
	invocation_type = INVOCATION_WHISPER
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC

	active_msg = "You prepare to blind a target..."

	/// The amount of blind to apply
	var/eye_blind_duration = 20 SECONDS
	/// The amount of blurriness to apply
	var/eye_blur_duration = 40 SECONDS

/datum/action/cooldown/spell/pointed/blind/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	if(!ishuman(cast_on))
		return FALSE

	var/mob/living/carbon/human/human_target = cast_on
	return !human_target.is_blind()

/datum/action/cooldown/spell/pointed/blind/cast(mob/living/carbon/human/cast_on)
	. = ..()
	if(cast_on.can_block_magic(antimagic_flags))
		to_chat(cast_on, span_notice(LANG("datum.b977530cb30ca62f", null)))
		to_chat(owner, span_warning(LANG("datum.2ce7047e239a5e7e", null)))
		return FALSE

	to_chat(cast_on, span_warning(LANG("datum.ba5ddcea549be34b", null)))
	cast_on.adjust_temp_blindness(eye_blind_duration)
	cast_on.set_eye_blur_if_lower(eye_blur_duration)
	return TRUE
