/mob/living/basic/construct/wraith
	name = "怨灵"
	real_name = "Wraith"
	desc = "一种邪恶的带爪外壳构造体，旨在刺杀敌人并在敌后制造混乱。"
	icon_state = "wraith"
	icon_living = "wraith"
	maxHealth = 65
	health = 65
	melee_damage_lower = 20
	melee_damage_upper = 20
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/items/weapons/bladeslice.ogg'
	attack_vis_effect = ATTACK_EFFECT_SLASH
	construct_spells = list(
		/datum/action/cooldown/spell/jaunt/ethereal_jaunt/shift,
		/datum/action/innate/cult/create_rune/tele,
	)
	playstyle_string = span_bold("你是怨灵。虽然相对脆弱，但你速度快、致命，并能穿墙而过。你的攻击会减少穿墙的冷却时间，致命一击效果更甚。")

/mob/living/basic/construct/wraith/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_SEE_BLESSED_TILES, INNATE_TRAIT)
	var/datum/action/cooldown/spell/jaunt/ethereal_jaunt/shift/jaunt = locate() in actions
	if(isnull(jaunt))
		return .
	AddComponent(/datum/component/recharging_attacks, recharged_action = jaunt)

/// Hostile NPC version. Attempts to kill the lowest-health mob it can see.
/mob/living/basic/construct/wraith/hostile
	ai_controller = /datum/ai_controller/basic_controller/wraith
	melee_attack_cooldown = 1.5 SECONDS

// Alternate wraith themes
/mob/living/basic/construct/wraith/angelic
	faction = list(FACTION_HOLY)
	theme = THEME_HOLY
	construct_spells = list(
		/datum/action/cooldown/spell/jaunt/ethereal_jaunt/shift/angelic,
		/datum/action/innate/cult/create_rune/tele,
	)

/mob/living/basic/construct/wraith/angelic/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_ANGELIC, INNATE_TRAIT)

/mob/living/basic/construct/wraith/mystic
	faction = list(ROLE_WIZARD)
	theme = THEME_WIZARD
	construct_spells = list(
		/datum/action/cooldown/spell/jaunt/ethereal_jaunt/shift/mystic,
		/datum/action/innate/cult/create_rune/tele,
	)
