#define GONDOLA_ORGAN_COLOR "#7a503d"
#define GONDOLA_SCLERA_COLOR COLOR_BLACK
#define GONDOLA_PUPIL_COLOR COLOR_BLACK
#define GONDOLA_COLORS GONDOLA_ORGAN_COLOR + GONDOLA_SCLERA_COLOR + GONDOLA_PUPIL_COLOR

/*
Fluoride Stare: After someone says 5 words, blah blah blah...
*/

///bonus of the observing gondola: you can ignore environmental hazards
/datum/status_effect/organ_set_bonus/gondola
	id = "organ_set_bonus_gondola"
	organs_needed = 3
	bonus_activate_text = span_notice("冈多拉DNA已深深融入你的身体！你成为了终极的观察者，对周围环境漠不关心……")
	bonus_deactivate_text = span_notice("你的DNA不再宁静如冈多拉，于是你开始想起呼吸这件事，嗯，挺重要的……")
	bonus_traits = list(TRAIT_RESISTHEAT, TRAIT_RESISTCOLD, TRAIT_NOBREATH, TRAIT_RESISTLOWPRESSURE, TRAIT_RESISTHIGHPRESSURE)

/// makes you a pacifist and turns most mobs neutral towards you
/obj/item/organ/heart/gondola
	name = "变异冈多拉心脏"
	desc = "冈多拉DNA被注入到曾经是普通心脏的器官中。"

	icon = 'icons/map_icons/items/_item.dmi'
	icon_state = "/obj/item/organ/heart/gondola"
	post_init_icon_state = "heart"
	greyscale_config = /datum/greyscale_config/mutant_organ
	greyscale_colors = GONDOLA_COLORS
	organ_traits = list(TRAIT_PACIFISM)
	///keeps track of whether the receiver actually gained factions
	var/list/factions_to_remove

/obj/item/organ/heart/gondola/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/organ_set_bonus, /datum/status_effect/organ_set_bonus/gondola)
	AddElement(/datum/element/noticable_organ, "%PRONOUN_They radiate%PRONOUN_s an aura of serenity.")
	AddElement(/datum/element/update_icon_blocker)

/obj/item/organ/heart/gondola/on_mob_insert(mob/living/carbon/receiver, special, movement_flags)
	. = ..()
	if(!receiver.has_faction(FACTION_HOSTILE))
		LAZYADD(factions_to_remove, FACTION_HOSTILE)
	if(!receiver.has_faction(FACTION_MINING))
		LAZYADD(factions_to_remove, FACTION_MINING)
	receiver.add_faction(list(FACTION_HOSTILE, FACTION_MINING))

/obj/item/organ/heart/gondola/on_mob_remove(mob/living/carbon/heartless, special, movement_flags)
	. = ..()
	if(LAZYLEN(factions_to_remove))
		heartless.remove_faction(factions_to_remove)

/// Zen (tounge): You can no longer speak, but get a powerful positive moodlet
/obj/item/organ/tongue/gondola
	name = "变异冈多拉舌头"
	desc = "冈多拉DNA被注入到曾经是普通舌头的器官中。"
	icon = 'icons/map_icons/items/_item.dmi'
	icon_state = "/obj/item/organ/tongue/gondola"
	post_init_icon_state = "tongue"
	greyscale_config = /datum/greyscale_config/mutant_organ
	greyscale_colors = GONDOLA_COLORS
	speakable_with = FALSE
	organ_traits = list(TRAIT_MUTE)

/obj/item/organ/tongue/gondola/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/noticable_organ, "%PRONOUN_Their mouth is permanently affixed into a relaxed smile.", BODY_ZONE_PRECISE_MOUTH)
	AddElement(/datum/element/organ_set_bonus, /datum/status_effect/organ_set_bonus/gondola)

/obj/item/organ/tongue/gondola/on_mob_insert(mob/living/carbon/tongue_owner, special, movement_flags)
	. = ..()
	tongue_owner.add_mood_event("gondola_zen", /datum/mood_event/gondola_serenity)

/obj/item/organ/tongue/gondola/on_mob_remove(mob/living/carbon/tongue_owner, special, movement_flags)
	tongue_owner.clear_mood_event("gondola_zen")
	return ..()

/// Loving arms: your hands become unable to hold much of anything but your hugs now infuse the subject with pax.
/obj/item/organ/liver/gondola
	name = "变异冈多拉肝脏"
	desc = "冈多拉DNA被注入到曾经是普通肝脏的器官中。"
	icon = 'icons/map_icons/items/_item.dmi'
	icon_state = "/obj/item/organ/liver/gondola"
	post_init_icon_state = "liver"
	greyscale_config = /datum/greyscale_config/mutant_organ
	greyscale_colors = GONDOLA_COLORS

/obj/item/organ/liver/gondola/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/organ_set_bonus, /datum/status_effect/organ_set_bonus/gondola)
	AddElement(/datum/element/noticable_organ, "%PRONOUN_Their left arm has small needles breaching the skin all over it.", BODY_ZONE_L_ARM)
	AddElement(/datum/element/noticable_organ, "%PRONOUN_Their right arm has small needles breaching the skin all over it.", BODY_ZONE_R_ARM)

/obj/item/organ/liver/gondola/on_mob_insert(mob/living/carbon/liver_owner, special, movement_flags)
	. = ..()
	var/has_left = liver_owner.has_left_hand(check_disabled = FALSE)
	var/has_right = liver_owner.has_right_hand(check_disabled = FALSE)
	if(has_left && has_right)
		to_chat(liver_owner, span_warning("你的双臂变得异常虚弱，上面长满了细小的针状刺痛！"))
	else if(has_left || has_right)
		to_chat(liver_owner, span_warning("你的手臂变得异常虚弱，上面长满了细小的针状刺痛！"))
	else
		to_chat(liver_owner, span_warning("你觉得此刻你的手臂似乎要发生什么变化……如果你还有手臂的话。"))
	to_chat(liver_owner, span_notice("拥抱目标会使其平静下来，但你再也拿不动多少东西了。"))
	RegisterSignal(liver_owner, COMSIG_HUMAN_EQUIPPING_ITEM, PROC_REF(on_owner_equipping_item))
	RegisterSignal(liver_owner, COMSIG_LIVING_TRY_PULL, PROC_REF(on_owner_try_pull))
	RegisterSignal(liver_owner, COMSIG_CARBON_HELPED, PROC_REF(on_hug))

/obj/item/organ/liver/gondola/on_mob_remove(mob/living/carbon/liver_owner, special, movement_flags)
	. = ..()
	UnregisterSignal(liver_owner, list(COMSIG_HUMAN_EQUIPPING_ITEM, COMSIG_LIVING_TRY_PULL, COMSIG_CARBON_HELPED))

/// signal sent when prompting if an item can be equipped
/obj/item/organ/liver/gondola/proc/on_owner_equipping_item(mob/living/carbon/human/owner, obj/item/equip_target, slot)
	SIGNAL_HANDLER
	if(equip_target.w_class > WEIGHT_CLASS_TINY)
		equip_target.balloon_alert(owner, "太弱了，拿不动这个！")
		return COMPONENT_BLOCK_EQUIP

/// signal sent when owner tries to pull an item
/obj/item/organ/liver/gondola/proc/on_owner_try_pull(mob/living/carbon/owner, atom/movable/target, force)
	SIGNAL_HANDLER
	if(isliving(target))
		var/mob/living/living_target = target
		if(living_target.mob_size > MOB_SIZE_TINY)
			living_target.balloon_alert(owner, "太弱了，拉不动这个！")
			return COMSIG_LIVING_CANCEL_PULL
	if(isitem(target))
		var/obj/item/item_target = target
		if(item_target.w_class > WEIGHT_CLASS_TINY)
			item_target.balloon_alert(owner, "太弱了，拉不动这个！")
			return COMSIG_LIVING_CANCEL_PULL

/obj/item/organ/liver/gondola/proc/on_hug(mob/living/carbon/human/source, mob/living/carbon/hugged)
	SIGNAL_HANDLER

	var/list/covered_body_zones = source.get_covered_body_zones()
	var/pax_injected = 4
	if(BODY_ZONE_L_ARM in covered_body_zones)
		pax_injected -= 2
	if(BODY_ZONE_R_ARM in covered_body_zones)
		pax_injected -= 2
	if(pax_injected > 0 && hugged.reagents?.add_reagent(/datum/reagent/pax, pax_injected))
		to_chat(hugged, span_warning("你感到一阵轻微的刺痛！"))

#undef GONDOLA_ORGAN_COLOR
#undef GONDOLA_SCLERA_COLOR
#undef GONDOLA_PUPIL_COLOR
#undef GONDOLA_COLORS
