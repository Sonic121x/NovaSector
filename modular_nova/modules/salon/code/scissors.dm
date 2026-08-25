/obj/item/scissors
	name = "barber's scissors"
	desc = "Some say a barbers best tool is his electric razor, that is not the case. These are used to cut hair in a professional way!"
	icon = 'modular_nova/modules/salon/icons/items.dmi'
	icon_state = "scissors"
	w_class = WEIGHT_CLASS_TINY
	sharpness = SHARP_EDGED
	// How long does it take to change someone's hairstyle?
	var/haircut_duration = 1 MINUTES
	// How long does it take to change someone's facial hair style?
	var/facial_haircut_duration = 20 SECONDS
	// Same as above, but for those with the hair expert trait
	var/haircut_duration_expert = 45 SECONDS
	var/facial_haircut_duration_expert = 15 SECONDS

/obj/item/scissors/attack(mob/living/attacked_mob, mob/living/user, params)
	if(!ishuman(attacked_mob))
		return

	var/mob/living/carbon/human/target_human = attacked_mob

	var/location = user.zone_selected
	if(!(location in list(BODY_ZONE_PRECISE_MOUTH, BODY_ZONE_HEAD)) && !user.combat_mode)
		to_chat(user, span_warning(LANG("obj.d6bb17074b83e7e0", null)))
		return

	if(target_human.hairstyle == "Bald" && target_human.facial_hairstyle == "Shaved")
		balloon_alert(user, LANG("obj.6754061ce2d983a8", null))
		return

	if(user.zone_selected != BODY_ZONE_HEAD)
		return ..()

	var/selected_part = tgui_alert(user, LANG("obj.0b4ef4b8c17ca8b9", list(target_human)), LANG("obj.e455fc28e6cda30c", null), list("Hair", "Facial Hair", "Cancel"))

	if(!selected_part || selected_part == "Cancel")
		return

	if(selected_part == "Hair")
		if(!target_human.hairstyle == "Bald" && target_human.head)
			balloon_alert(user, LANG("obj.5df368526defb500", null))
			return

		var/hair_id = tgui_input_list(user, LANG("obj.b89bab7d678c189b", null), LANG("obj.f7de00bf4d0a17f5", null), SSaccessories.hairstyles_list)
		if(!hair_id)
			return

		if(hair_id == "Bald")
			to_chat(target_human, span_danger(LANG("obj.f8bef301578d9dad", list(user))))

		to_chat(user, span_notice(LANG("obj.85380f506708eff0", list(target_human))))

		playsound(target_human, 'modular_nova/modules/salon/sound/haircut.ogg', 100)

		if(HAS_TRAIT(user, TRAIT_HAIR_EXPERT))
			if(do_after(user, haircut_duration_expert, target_human))
				target_human.set_hairstyle(hair_id, update = TRUE)
				user.visible_message(span_notice(LANG("obj.a69b67eb3421bc60", list(user, target_human))), span_notice(LANG("obj.9e851773499f45b5", list(target_human))))
		else
			if(do_after(user, haircut_duration, target_human))
				target_human.set_hairstyle(hair_id, update = TRUE)
				user.visible_message(span_notice(LANG("obj.7e424815ea3210d0", list(user, target_human))), span_notice(LANG("obj.29a95f7fc7403eb5", list(target_human))))
				new /obj/effect/decal/cleanable/hair(get_turf(src))
	else
		if(!target_human.facial_hairstyle == "Shaved" && target_human.wear_mask)
			balloon_alert(user, LANG("obj.5df368526defb500", null))
			return

		var/facial_hair_id = tgui_input_list(user, LANG("obj.c5cd9badbbe070d3", null), LANG("obj.f7de00bf4d0a17f5", null), SSaccessories.facial_hairstyles_list)
		if(!facial_hair_id)
			return

		if(facial_hair_id == "Shaved")
			to_chat(target_human, span_danger(LANG("obj.77ac974bf13c3cf2", list(user))))

		to_chat(user, LANG("obj.3c55989dfbfa4f08", list(target_human)))

		playsound(target_human, 'modular_nova/modules/salon/sound/haircut.ogg', 100)

		if(HAS_TRAIT(user, TRAIT_HAIR_EXPERT))
			if(do_after(user, facial_haircut_duration_expert, target_human))
				target_human.set_facial_hairstyle(facial_hair_id, update = TRUE)
				user.visible_message(span_notice(LANG("obj.a5f4bee341a39297", list(user, target_human))), span_notice(LANG("obj.bbf701272927f4c4", list(target_human))))
		else
			if(do_after(user, facial_haircut_duration, target_human))
				target_human.set_facial_hairstyle(facial_hair_id, update = TRUE)
				user.visible_message(span_notice(LANG("obj.6d1cf7323e88f548", list(user, target_human))), span_notice(LANG("obj.184b944a82580ca7", list(target_human))))
				new /obj/effect/decal/cleanable/hair(get_turf(src))
