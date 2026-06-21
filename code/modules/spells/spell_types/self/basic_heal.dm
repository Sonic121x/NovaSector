// This spell exists mainly for debugging purposes, and also to show how casting works
/datum/action/cooldown/spell/basic_heal
	name = "Lesser Heal-小回复术"
	desc = "治疗施法者少量的暴力伤和烧伤。"

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
		span_warning("一道柔和的光环拂过[cast_on]！"),
		span_notice("你将治愈之光环绕于自身！"),
	)
	var/need_mob_update = FALSE
	need_mob_update += cast_on.adjust_brute_loss(-brute_to_heal, updating_health = FALSE)
	need_mob_update += cast_on.adjust_fire_loss(-burn_to_heal, updating_health = FALSE)
	if(need_mob_update)
		cast_on.updatehealth()
