/obj/item/straight_razor
	name = "straight razor"
	desc = "A very sharp blade, mostly used for shaving faces..."
	icon = 'modular_nova/modules/salon/icons/items.dmi'
	icon_state = "straight_razor"
	force = 12
	throw_speed = 3
	throw_range = 9
	w_class = WEIGHT_CLASS_TINY
	attack_verb_simple = list("cut", "stabbed", "chebbed")
	sharpness = SHARP_EDGED
	hitsound = 'sound/items/weapons/bladeslice.ogg'
	wound_bonus = 10
	exposed_wound_bonus = 15
	tool_behaviour = TOOL_KNIFE
	// How long do we take to shave someone's facial hair?
	var/shaving_time = 10 SECONDS

/obj/item/straight_razor/proc/shave(mob/living/carbon/human/target_human)
	target_human.facial_hairstyle = "Shaved"
	target_human.update_body_parts()
	playsound(loc, 'sound/items/unsheath.ogg', 20, TRUE)

/obj/item/straight_razor/attack(mob/attacked_mob, mob/living/user)
	if(ishuman(attacked_mob))
		var/mob/living/carbon/human/target_human = attacked_mob
		var/location = user.zone_selected
		if(!(location in list(BODY_ZONE_PRECISE_MOUTH)) && !user.combat_mode)
			to_chat(user, span_warning(LANG("obj.36405fbb8ae0243f", null)))
			return
		if(location == BODY_ZONE_PRECISE_MOUTH && !target_human.get_bodypart(BODY_ZONE_HEAD))
			to_chat(user, span_warning(LANG("obj.618bead4579c1526", list(target_human))))
			return
		if(location == BODY_ZONE_PRECISE_MOUTH)
			var/obj/item/bodypart/head/noggin = target_human.get_bodypart(BODY_ZONE_HEAD)
			if(!(noggin.head_flags & HEAD_FACIAL_HAIR))
				to_chat(user, span_warning(LANG("obj.f4b1d28669ff6554", null)))
				return
			var/covering = target_human.is_mouth_covered()
			if(covering)
				to_chat(user, span_warning(LANG("obj.f4935eb907e08bb0", list(covering))))
				return
			if(target_human.facial_hairstyle == "Shaved")
				to_chat(user, span_warning(LANG("obj.ca2845a9f1916c0c", null)))
				return

			var/self_shaving = target_human == user // Shaving yourself?
			user.visible_message(span_notice(LANG("obj.519fbfd398a7eb20", list(user, self_shaving ? user.p_their() : "[target_human]'s", src))), \
				span_notice(LANG("obj.4bdf607a858f312a", list(self_shaving ? "your" : "[target_human]'s", src))))
			if(do_after(user, shaving_time, target = target_human))
				user.visible_message(span_notice(LANG("obj.cd26529e549f2289", list(user, self_shaving ? user.p_their() : "[target_human]'s", src))), \
					span_notice(LANG("obj.69264ffa0492d523", list(self_shaving ? "" : " [target_human]'s facial hair", src))))
				shave(target_human)

		else
			..()
	else
		..()
