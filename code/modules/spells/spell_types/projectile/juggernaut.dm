/datum/action/cooldown/spell/basic_projectile/juggernaut
	name = "Gauntlet Echo-长手回响"
	desc = "将能量注入你的护手之中——使其核心力量缓慢释放，从而发动一场威力巨大的攻击。"
	button_icon = 'icons/mob/actions/actions_cult.dmi'
	button_icon_state = "cultfist"
	background_icon_state = "bg_demon"
	overlay_icon_state = "bg_demon_border"

	sound = 'sound/items/weapons/resonator_blast.ogg'

	cooldown_time = 35 SECONDS
	spell_requirements = NONE

	projectile_type = /obj/projectile/magic/aoe/juggernaut

/datum/action/cooldown/spell/basic_projectile/juggernaut/fire_projectile(atom/target, mob/caster)
	var/obj/projectile/magic/aoe/juggernaut/to_fire = ..()
	SET_FACTION_AND_ALLIES_FROM(to_fire, caster)
	return to_fire
