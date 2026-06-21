/mob/living/basic/mining/megadeer
	name = "巨鹿"
	desc = "普通鹿的后代，因土地的严酷而变成了愤怒的野兽。"
	icon = 'modular_nova/modules/serenitystation/icons/newfauna_wide.dmi'
	icon_state = "megadeer"
	icon_living = "megadeer"
	icon_dead = "megadeer_dead"
	pixel_x = -12
	base_pixel_x = -12
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	mouse_opacity = MOUSE_OPACITY_ICON
	speak_emote = list("flutes")

	butcher_results = list(
		/obj/item/food/meat/slab = 2,
		/obj/item/stack/sheet/sinew/deer = 2,
		/obj/item/stack/sheet/bone = 2
	)
	crusher_loot = /obj/item/crusher_trophy/deer_fur

	maxHealth = 180
	health = 180
	obj_damage = 15
	melee_damage_lower = 15
	melee_damage_upper = 15
	attack_vis_effect = ATTACK_EFFECT_BITE
	melee_attack_cooldown = 1.2 SECONDS

	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	death_message = "lets out a fluting cry and collapses."

	attack_sound = 'sound/items/weapons/bite.ogg'
	move_force = MOVE_FORCE_WEAK
	move_resist = MOVE_FORCE_WEAK
	pull_force = MOVE_FORCE_WEAK

	ai_controller = /datum/ai_controller/basic_controller/megadeer

	var/can_tame = FALSE

/mob/living/basic/mining/megadeer/Initialize(mapload)
	. = ..()

	AddElement(/datum/element/footstep, FOOTSTEP_MOB_CLAW)
	AddElement(/datum/element/ai_flee_while_injured)
	AddElement(/datum/element/ai_retaliate)

/obj/item/crusher_trophy/deer_fur
	name = "鹿毛"
	desc = "这是巨鹿的毛皮。"
	icon = 'modular_nova/modules/serenitystation/icons/misc.dmi'
	icon_state = "deer_fur"
	denied_type = /obj/item/crusher_trophy/deer_fur

/obj/item/crusher_trophy/deer_fur/effect_desc()
	return "mark detonation to gain a slight speed boost temporarily"

/obj/item/crusher_trophy/deer_fur/on_mark_detonation(mob/living/target, mob/living/user)
	. = ..()
	user.apply_status_effect(/datum/status_effect/speed_boost, 1 SECONDS)

//sinew re-flavor for megadeers
/obj/item/stack/sheet/sinew/deer
	name = "鹿筋"
	singular_name = "deer sinew"
	merge_type = /obj/item/stack/sheet/sinew/deer

