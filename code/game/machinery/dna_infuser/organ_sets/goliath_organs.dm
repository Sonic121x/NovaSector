#define GOLIATH_ORGAN_COLOR "#875652"
#define GOLIATH_SCLERA_COLOR "#ac0f32"
#define GOLIATH_PUPIL_COLOR COLOR_RED
#define GOLIATH_COLORS GOLIATH_ORGAN_COLOR + GOLIATH_SCLERA_COLOR + GOLIATH_PUPIL_COLOR

/datum/status_effect/organ_set_bonus/goliath
	id = "organ_set_bonus_goliath"
	organs_needed = 4
	bonus_activate_text = span_notice("歌利亚巨兽的DNA已深深融入你体内！你现在可以忍受在熔岩上行走了！")
	bonus_deactivate_text = span_notice("你感觉肌肉萎缩，皮肤周围的触须枯萎。你的歌利亚DNA基本消失了，在熔岩中生存的能力也随之而去。")
	bonus_traits = list(TRAIT_LAVA_IMMUNE)

///goliath eyes, simple night vision
/obj/item/organ/eyes/night_vision/goliath
	name = "歌利亚之眼"
	desc = "歌利亚DNA被注入到曾经是普通眼睛的器官中。"

	iris_overlay = null
	icon = 'icons/map_icons/items/_item.dmi'
	icon_state = "/obj/item/organ/eyes/night_vision/goliath"
	post_init_icon_state = "eyes"
	greyscale_config = /datum/greyscale_config/mutant_organ
	greyscale_colors = GOLIATH_COLORS

	eye_color_left = COLOR_RED
	eye_color_right = COLOR_RED

	low_light_cutoff = list(15, 0, 8)
	medium_light_cutoff = list(35, 15, 25)
	high_light_cutoff = list(50, 10, 40)
	organ_traits = list(TRAIT_UNNATURAL_RED_GLOWY_EYES)

/obj/item/organ/eyes/night_vision/goliath/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/noticable_organ, "%PRONOUN_Their eyes are blood red and stone-like.", BODY_ZONE_PRECISE_EYES)
	AddElement(/datum/element/organ_set_bonus, /datum/status_effect/organ_set_bonus/goliath)

///goliath lungs! You can breathe lavaland air mix but can't breath pure O2 from a tank anymore.
/obj/item/organ/lungs/lavaland/goliath
	name = "变异歌利亚肺"
	desc = "歌利亚DNA被注入到曾经是普通肺部的器官中。"

	icon = 'icons/map_icons/items/_item.dmi'
	icon_state = "/obj/item/organ/lungs/lavaland/goliath"
	post_init_icon_state = "lungs"
	greyscale_config = /datum/greyscale_config/mutant_organ
	greyscale_colors = GOLIATH_COLORS

/obj/item/organ/lungs/lavaland/goliath/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/noticable_organ, "%PRONOUN_Their back is covered in small tendrils.", BODY_ZONE_CHEST)
	AddElement(/datum/element/organ_set_bonus, /datum/status_effect/organ_set_bonus/goliath)

///goliath brain. you can't use gloves but one of your arms becomes a tendril hammer that can be used to mine!
/obj/item/organ/brain/goliath
	name = "变异歌利亚脑"
	desc = "歌利亚DNA被注入到曾经是普通大脑的器官中。"

	icon = 'icons/map_icons/items/_item.dmi'
	icon_state = "/obj/item/organ/brain/goliath"
	post_init_icon_state = "brain"
	greyscale_config = /datum/greyscale_config/mutant_organ
	greyscale_colors = GOLIATH_COLORS
	can_smoothen_out = FALSE
	shade_color = "garnet"

	var/obj/item/goliath_infuser_hammer/hammer

/obj/item/organ/brain/goliath/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/noticable_organ, "%PRONOUN_Their arm is just a mass of plate and tendrils.", BODY_ZONE_CHEST)
	AddElement(/datum/element/organ_set_bonus, /datum/status_effect/organ_set_bonus/goliath)

/obj/item/organ/brain/goliath/on_mob_insert(mob/living/carbon/brain_owner)
	. = ..()
	if(!ishuman(brain_owner))
		return
	var/mob/living/carbon/human/human_receiver = brain_owner
	if(!human_receiver.can_mutate())
		return
	var/datum/species/rec_species = human_receiver.dna.species
	rec_species.update_no_equip_flags(brain_owner, rec_species.no_equip_flags | ITEM_SLOT_GLOVES)
	hammer = new/obj/item/goliath_infuser_hammer
	brain_owner.put_in_hands(hammer)

/obj/item/organ/brain/goliath/on_mob_remove(mob/living/carbon/brain_owner)
	. = ..()
	UnregisterSignal(brain_owner)
	if(!ishuman(brain_owner))
		return
	var/mob/living/carbon/human/human_receiver = brain_owner
	if(!human_receiver.can_mutate())
		return
	var/datum/species/rec_species = human_receiver.dna.species
	rec_species.update_no_equip_flags(brain_owner, initial(rec_species.no_equip_flags))
	if(hammer)
		brain_owner.visible_message(span_warning("\The [hammer] 瓦解了！"))
		QDEL_NULL(hammer)

/obj/item/goliath_infuser_hammer
	name = "触须之锤"
	desc = "一团由触须固定的板状物取代了一条手臂。"
	icon = 'icons/obj/weapons/goliath_hammer.dmi'
	icon_state = "goliath_hammer"
	inhand_icon_state = "goliath_hammer"
	icon_angle = -90
	lefthand_file = 'icons/mob/inhands/weapons/goliath_hammer_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/goliath_hammer_righthand.dmi'
	item_flags = ABSTRACT | DROPDEL
	resistance_flags = LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	w_class = WEIGHT_CLASS_HUGE
	force = 20
	throwforce = 0
	throw_range = 0
	throw_speed = 0
	attack_verb_continuous = list("smashes", "bashes", "hammers", "crunches", "punches")
	attack_verb_simple = list("smash", "bash", "hammer", "crunch")
	hitsound = 'sound/effects/bamf.ogg'
	tool_behaviour = TOOL_MINING
	toolspeed = 0.1
	/// Amount of damage we deal to the mining and boss factions.
	var/mining_bonus_force = 80
	/// Our cooldown declare for our special knockback hit
	COOLDOWN_DECLARE(tendril_hammer_cd)

/obj/item/goliath_infuser_hammer/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, HAND_REPLACEMENT_TRAIT)

/obj/item/goliath_infuser_hammer/examine(mob/user)
	. = ..()
	. += "You can use your tendril hammer arm to deliver a devastating blow against mining fauna, but only once every two seconds."

/obj/item/goliath_infuser_hammer/attack(mob/living/target, mob/living/carbon/human/user, list/modifiers, list/attack_modifiers)
	. = ..()

	//If we're on cooldown, we'll do a normal attack.
	if(!COOLDOWN_FINISHED(src, tendril_hammer_cd))
		return

	//do a normal attack if our target isn't living, since we're gonna define them after this.
	if(!isliving(target))
		return

	var/mob/living/fresh_pancake = target

	// Check for nemesis factions on the target.
	if(!fresh_pancake.has_faction(list(FACTION_MINING, FACTION_BOSS)))
		// Target is not a nemesis, so attack normally.
		return

	// Apply nemesis-specific effects.
	nemesis_effects(user, fresh_pancake)

	// Target is a nemesis, and so now we do the extra big damage and go on cooldown
	fresh_pancake.apply_damage(mining_bonus_force, damtype) //smush
	COOLDOWN_START(src, tendril_hammer_cd, 2 SECONDS)

/obj/item/goliath_infuser_hammer/proc/nemesis_effects(mob/living/user, mob/living/target)
	if(istype(target, /mob/living/simple_animal/hostile/asteroid/elite))
		return
	///we obtain the relative direction from the bat itself to the target
	if(!QDELETED(target))
		target.throw_at(get_edge_target_turf(target, get_cardinal_dir(src, target)), rand(1, 2), prob(60) ? 1 : 4, user)

/// goliath heart gives you the ability to survive ash storms.
/obj/item/organ/heart/goliath
	name = "变异歌利亚心脏"
	desc = "歌利亚DNA被注入到曾经是普通心脏的器官中。"

	icon = 'icons/map_icons/items/_item.dmi'
	icon_state = "/obj/item/organ/heart/goliath"
	post_init_icon_state = "heart"
	greyscale_config = /datum/greyscale_config/mutant_organ
	greyscale_colors = GOLIATH_COLORS

	organ_traits = list(TRAIT_ASHSTORM_IMMUNE)

/obj/item/organ/heart/goliath/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/noticable_organ, "%PRONOUN_Their skin has visible hard plates growing from within.", BODY_ZONE_CHEST)
	AddElement(/datum/element/organ_set_bonus, /datum/status_effect/organ_set_bonus/goliath)
	AddElement(/datum/element/update_icon_blocker)

#undef GOLIATH_ORGAN_COLOR
#undef GOLIATH_SCLERA_COLOR
#undef GOLIATH_PUPIL_COLOR
#undef GOLIATH_COLORS
