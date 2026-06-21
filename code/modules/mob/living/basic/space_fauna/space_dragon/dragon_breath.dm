/// A space dragon's fire breath, toasts lunch AND buffs your friends
/datum/action/cooldown/mob_cooldown/fire_breath/carp
	desc = "太空龙的灼热吐息不仅能烧焦敌人，还能为太空鲤鱼注入活力。"
	fire_damage = 30
	mech_damage = 50
	fire_range = 20
	fire_temperature = 700 // Even hotter than a megafauna for some reason
	shared_cooldown = NONE

/datum/action/cooldown/mob_cooldown/fire_breath/carp/on_burn_mob(mob/living/barbecued, mob/living/source)
	if (!source.faction_check_atom(barbecued))
		return ..()
	to_chat(barbecued, span_notice("[source]的火焰吐息让你充满了能量！"))
	barbecued.apply_status_effect(/datum/status_effect/carp_invigoration)

/// Makes you run faster for the duration
/datum/status_effect/carp_invigoration
	id = "carp_invigorated"
	alert_type = null
	duration = 8 SECONDS

/datum/status_effect/carp_invigoration/on_apply()
	. = ..()
	if (!.)
		return
	owner.add_filter("anger_glow", 3, list("type" = "outline", "color" = COLOR_CARP_RIFT_RED, "size" = 2))
	owner.add_movespeed_modifier(/datum/movespeed_modifier/dragon_rage)

/datum/status_effect/carp_invigoration/on_remove()
	owner.remove_filter("anger_glow")
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/dragon_rage)
