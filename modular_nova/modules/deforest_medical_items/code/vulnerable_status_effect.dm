/atom/movable/screen/alert/status_effect/vulnerable_to_damage
	name = "易受伤害状态"
	desc = "在你的身体从自我修复中恢复期间，你将承受比正常情况下更多的伤害！"
	icon_state = "terrified"

/datum/status_effect/vulnerable_to_damage
	id = "vulnerable_to_damage"
	duration = 5 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/vulnerable_to_damage
	remove_on_fullheal = TRUE
	/// The percentage damage modifier we give the mob we're applied to
	var/damage_resistance_subtraction = 50
	/// How much extra bleeding the mob is given
	var/bleed_modifier_addition = 1

/datum/status_effect/vulnerable_to_damage/on_apply()
	to_chat(owner, span_userdanger("你的身体突然感到虚弱和脆弱！"))
	var/mob/living/carbon/human/carbon_owner = owner
	carbon_owner.physiology.damage_resistance -= damage_resistance_subtraction
	carbon_owner.physiology.bleed_mod += bleed_modifier_addition
	return ..()

/datum/status_effect/vulnerable_to_damage/on_remove()
	to_chat(owner, span_notice("你似乎已经从非自然的脆弱状态中恢复了！"))
	var/mob/living/carbon/human/carbon_recoverer = owner
	carbon_recoverer.physiology.damage_resistance += damage_resistance_subtraction
	carbon_recoverer.physiology.bleed_mod -= bleed_modifier_addition
	return ..()
