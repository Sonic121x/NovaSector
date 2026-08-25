// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
// Currently unused
/datum/action/cooldown/spell/touch/mad_touch
	name = "Touch of Madness"
	desc = "A touch spell that drains your enemy's sanity and knocks them down."
	background_icon_state = "bg_heretic"
	overlay_icon_state = "bg_heretic_border"
	button_icon = 'icons/mob/actions/actions_ecult.dmi'
	button_icon_state = "mad_touch"

	school = SCHOOL_FORBIDDEN
	cooldown_time = 15 SECONDS
	invocation_type = INVOCATION_NONE
	spell_requirements = NONE
	antimagic_flags = MAGIC_RESISTANCE_MOON

/datum/action/cooldown/spell/touch/mad_touch/is_valid_target(atom/cast_on)
	if(!ishuman(cast_on))
		return FALSE
	var/mob/living/carbon/human/human_cast_on = cast_on
	if(!human_cast_on.mind || !human_cast_on.mob_mood || IS_HERETIC_OR_MONSTER(human_cast_on))
		return FALSE
	return TRUE

/datum/action/cooldown/spell/touch/mad_touch/on_antimagic_triggered(obj/item/melee/touch_attack/hand, atom/victim, mob/living/carbon/caster)
	victim.visible_message(
		span_danger(LANG("datum.44d911f352202ac7", list(victim))),
		span_danger(LANG("datum.f092e989ec79f08e", null)),
	)

/datum/action/cooldown/spell/touch/mad_touch/cast_on_hand_hit(obj/item/melee/touch_attack/hand, mob/living/carbon/human/victim, mob/living/carbon/caster)
	to_chat(caster, span_warning(LANG("datum.a1b0007c1aa45f58", list(victim.name))))
	victim.add_mood_event("gates_of_mansus", /datum/mood_event/gates_of_mansus)
	return TRUE
