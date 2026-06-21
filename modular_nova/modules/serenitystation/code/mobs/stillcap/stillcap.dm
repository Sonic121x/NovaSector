/mob/living/basic/mining/stillcap
	name = "静帽菇"
	desc = "一种奇怪、难以捉摸的生物，似乎总是凭空出现。"
	icon = 'modular_nova/modules/serenitystation/icons/newfauna_wide.dmi'
	icon_state = "stillcap_red"
	icon_living = "stillcap_red"
	base_icon_state = "stillcap_red"
	icon_dead = "stillcap_red_dead"
	pixel_x = -12
	base_pixel_x = -12
	mob_biotypes = MOB_ORGANIC|MOB_BEAST

	maxHealth = 180
	health = 180
	speed = 5
	obj_damage = 15
	melee_damage_lower = 15
	melee_damage_upper = 15
	attack_vis_effect = ATTACK_EFFECT_BITE
	melee_attack_cooldown = 1.2 SECONDS

	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	death_message = "collapses in a muted thud."
	pass_flags_self = PASSMOB

	attack_sound = 'sound/items/weapons/bite.ogg'
	move_force = MOVE_FORCE_WEAK
	move_resist = MOVE_FORCE_WEAK
	pull_force = MOVE_FORCE_WEAK
	ai_controller = /datum/ai_controller/basic_controller/stillcap


/mob/living/basic/mining/stillcap/Initialize(mapload)
	. = ..()

	AddElement(/datum/element/can_hide/basic, list(/turf/open/misc/asteroid/forest/mushroom))
	AddElement(/datum/element/ai_flee_while_injured)
	AddElement(/datum/element/ai_retaliate)

/mob/living/basic/mining/stillcap/red
	name = "红色静帽菇"
	desc = parent_type::desc + "这只看起来是红色的。"
	icon_state = "stillcap_red"
	icon_living = "stillcap_red"
	base_icon_state = "stillcap_red"
	icon_dead = "stillcap_red_dead"


/mob/living/basic/mining/stillcap/blue
	name = "蓝色静帽菇"
	desc = parent_type::desc + "这只看起来是蓝色的。"
	icon_state = "stillcap_blue"
	icon_living = "stillcap_blue"
	base_icon_state = "stillcap_blue"
	icon_dead = "stillcap_blue_dead"


/mob/living/basic/mining/stillcap/green
	name = "绿色静帽菇"
	desc = parent_type::desc + "这只看起来是绿色的。"
	icon_state = "stillcap_green"
	icon_living = "stillcap_green"
	base_icon_state = "stillcap_green"
	icon_dead = "stillcap_green_dead"
