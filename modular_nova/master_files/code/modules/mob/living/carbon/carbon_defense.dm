#define PERSONAL_SPACE_DAMAGE 2
#define ASS_SLAP_EXTRA_RANGE -1

// Emotes
/mob/living/carbon/disarm(mob/living/carbon/target)
	if(zone_selected == BODY_ZONE_PRECISE_MOUTH)
		var/target_on_help_and_unarmed = !target.combat_mode && !target.get_active_held_item()
		if(target_on_help_and_unarmed || HAS_TRAIT(target, TRAIT_RESTRAINED))
			do_slap_animation(target)
			playsound(target.loc, 'sound/items/weapons/slap.ogg', 50, TRUE, -1)
			visible_message(LANG("mob.9d2c8ef8f40491f7", list(src, target)),
				LANG("mob.8a0b09fc2ef67ce5", list(target)),\
			LANG("mob.977bc0690fa19d32", null))
			target.unwag_tail()
			return
	if(zone_selected == BODY_ZONE_PRECISE_GROIN && target.dir == src.dir)
		if(HAS_TRAIT(target, TRAIT_PERSONALSPACE) && !IS_UNCONSCIOUS(target) && (!target.handcuffed)) //You need to be conscious and uncuffed to use Personal Space
			if(target.combat_mode && (!HAS_TRAIT(target, TRAIT_PACIFISM))) //Being pacified prevents violent counters
				var/obj/item/bodypart/affecting = src.get_bodypart(BODY_ZONE_HEAD)
				if(affecting?.receive_damage(PERSONAL_SPACE_DAMAGE))
					src.update_damage_overlays()
				visible_message(span_danger(LANG("mob.5c9798e03be6c865", list(src, target))),
				span_danger(LANG("mob.0b9b9807a388db72", list(target))),
				LANG("mob.977bc0690fa19d32", null), ignored_mobs = list(target))
				playsound(target.loc, 'sound/effects/snap.ogg', 50, TRUE, ASS_SLAP_EXTRA_RANGE)
				to_chat(target, span_danger(LANG("mob.070c4b69dc247f4d", list(src))))
				return
			else
				visible_message(span_danger(LANG("mob.d2f98dd8380d4b10", list(src, target))),
				span_danger(LANG("mob.87ffdab3e0aec595", list(target))),
				LANG("mob.977bc0690fa19d32", null), ignored_mobs = list(target))
				playsound(target.loc, 'sound/items/weapons/thudswoosh.ogg', 50, TRUE, ASS_SLAP_EXTRA_RANGE)
				to_chat(target, span_danger(LANG("mob.83a01671b82f9c4b", list(src))))
				return
		else
			do_ass_slap_animation(target)
			playsound(target.loc, 'sound/items/weapons/slap.ogg', 50, TRUE, ASS_SLAP_EXTRA_RANGE)
			visible_message(LANG("mob.6f21ff2df0d85fbc", list(src, target)),\
				LANG("mob.88ff6e0bd5786a61", list(target)),\
				LANG("mob.977bc0690fa19d32", null), ignored_mobs = list(target))
			to_chat(target, LANG("mob.49d20886f376a80e", list(src)))
			return
	return ..()

#undef PERSONAL_SPACE_DAMAGE
#undef ASS_SLAP_EXTRA_RANGE
