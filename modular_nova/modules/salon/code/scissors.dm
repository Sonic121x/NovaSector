/obj/item/scissors
	name = "理发剪刀"
	desc = "有人说理发师最好的工具是电动剃须刀，其实不然。这些剪刀才是专业理发的方式！"
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
		to_chat(user, span_warning("你停下来，低头看着手里的东西，暗自思忖：“这大概是用在头发或胡须上的。”"))
		return

	if(target_human.hairstyle == "Bald" && target_human.facial_hairstyle == "Shaved")
		balloon_alert(user, "没有毛发！")
		return

	if(user.zone_selected != BODY_ZONE_HEAD)
		return ..()

	var/selected_part = tgui_alert(user, "请选择你想为[target_human]修剪哪个部位！", "修剪时间到！", list("Hair", "Facial Hair", "Cancel"))

	if(!selected_part || selected_part == "Cancel")
		return

	if(selected_part == "Hair")
		if(!target_human.hairstyle == "Bald" && target_human.head)
			balloon_alert(user, "没有毛发可剪！")
			return

		var/hair_id = tgui_input_list(user, "请选择你想修剪成什么发型！", "选择杰作", SSaccessories.hairstyles_list)
		if(!hair_id)
			return

		if(hair_id == "Bald")
			to_chat(target_human, span_danger("[user] 似乎要把你所有的头发都剪掉！"))

		to_chat(user, span_notice("你开始娴熟地修剪 [target_human] 的头发！"))

		playsound(target_human, 'modular_nova/modules/salon/sound/haircut.ogg', 100)

		if(HAS_TRAIT(user, TRAIT_HAIR_EXPERT))
			if(do_after(user, haircut_duration_expert, target_human))
				target_human.set_hairstyle(hair_id, update = TRUE)
				user.visible_message(span_notice("[user] 熟练地剪好了 [target_human] 的头发！"), span_notice("你熟练地剪好了 [target_human] 的头发！"))
		else
			if(do_after(user, haircut_duration, target_human))
				target_human.set_hairstyle(hair_id, update = TRUE)
				user.visible_message(span_notice("[user] 成功剪好了 [target_human] 的头发！"), span_notice("你成功剪好了 [target_human] 的头发！"))
				new /obj/effect/decal/cleanable/hair(get_turf(src))
	else
		if(!target_human.facial_hairstyle == "Shaved" && target_human.wear_mask)
			balloon_alert(user, "没有毛发可剪！")
			return

		var/facial_hair_id = tgui_input_list(user, "请选择你想修剪成什么面部毛发造型！", "选择杰作", SSaccessories.facial_hairstyles_list)
		if(!facial_hair_id)
			return

		if(facial_hair_id == "Shaved")
			to_chat(target_human, span_danger("[user] 似乎要把你所有的胡须都刮掉！"))

		to_chat(user, "你开始娴熟地修剪 [target_human] 的胡须！")

		playsound(target_human, 'modular_nova/modules/salon/sound/haircut.ogg', 100)

		if(HAS_TRAIT(user, TRAIT_HAIR_EXPERT))
			if(do_after(user, facial_haircut_duration_expert, target_human))
				target_human.set_facial_hairstyle(facial_hair_id, update = TRUE)
				user.visible_message(span_notice("[user] 熟练地修剪了 [target_human] 的胡须！"), span_notice("你熟练地修剪了 [target_human] 的胡须！"))
		else
			if(do_after(user, facial_haircut_duration, target_human))
				target_human.set_facial_hairstyle(facial_hair_id, update = TRUE)
				user.visible_message(span_notice("[user] 成功修剪了 [target_human] 的胡须！"), span_notice("你成功修剪了 [target_human] 的胡须！"))
				new /obj/effect/decal/cleanable/hair(get_turf(src))
