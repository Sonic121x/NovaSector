// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
// This spell exists mainly for debugging purposes, and also to show how casting works
/datum/action/cooldown/spell/basic_heal
	name = "Lesser Heal"
	desc = "Heals a small amount of brute and burn damage to the caster."

	sound = 'sound/effects/magic/staff_healing.ogg'
	school = SCHOOL_RESTORATION
	cooldown_time = 10 SECONDS
	cooldown_reduction_per_rank = 1.25 SECONDS
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC|SPELL_REQUIRES_HUMAN

	invocation = "Victus sano!"
	invocation_type = INVOCATION_WHISPER

	/// Amount of brute to heal to the spell caster on cast
	var/brute_to_heal = 10
	/// Amount of burn to heal to the spell caster on cast
	var/burn_to_heal = 10

/datum/action/cooldown/spell/basic_heal/is_valid_target(atom/cast_on)
	return isliving(cast_on)

/datum/action/cooldown/spell/basic_heal/cast(mob/living/cast_on)
	. = ..()
	cast_on.visible_message(
		span_warning(LANG("datum.9c6e1068c02a3220", list(cast_on))),
		span_notice(LANG("datum.ed1e1eb37623f900", null)),
	)
	var/need_mob_update = FALSE
	need_mob_update += cast_on.adjust_brute_loss(-brute_to_heal, updating_health = FALSE)
	need_mob_update += cast_on.adjust_fire_loss(-burn_to_heal, updating_health = FALSE)
	if(need_mob_update)
		cast_on.updatehealth()
