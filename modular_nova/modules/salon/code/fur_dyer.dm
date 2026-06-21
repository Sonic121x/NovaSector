#define COLOR_MODE_SPECIFIC "Specific Marking"
#define COLOR_MODE_GENERAL "General Color"

/obj/item/fur_dyer
	name = "电动皮毛染色器"
	desc = "一种能够以近乎永久的方式重新着色皮毛的染料。"
	icon = 'modular_nova/modules/salon/icons/items.dmi'
	icon_state = "fur_sprayer"
	w_class = WEIGHT_CLASS_TINY

	var/mode = COLOR_MODE_SPECIFIC

/obj/item/fur_dyer/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cell)

/obj/item/fur_dyer/attack_self(mob/user, modifiers)
	. = ..()
	if(mode == COLOR_MODE_SPECIFIC)
		mode = COLOR_MODE_GENERAL
	else
		mode = COLOR_MODE_SPECIFIC

	balloon_alert(user, "设置为[mode]！")

/obj/item/fur_dyer/attack(mob/living/M, mob/living/user, params)
	if(!ishuman(M))
		return ..()

	var/mob/living/carbon/human/target_human = M

	switch(mode)
		if(COLOR_MODE_SPECIFIC)
			dye_marking(target_human, user)
		if(COLOR_MODE_GENERAL)
			dye_general(target_human, user)

/obj/item/fur_dyer/proc/dye_general(mob/living/carbon/human/target_human, mob/living/user)
	var/selected_mutant_color = tgui_alert(user, "请选择你想要更改的哪种突变体颜色", "选择颜色", list("One", "Two", "Three"))

	if(!selected_mutant_color)
		return

	if(!(item_use_power(power_use_amount, user, TRUE) & COMPONENT_POWER_SUCCESS))
		to_chat(user, span_danger("红灯闪烁！"))
		return

	var/selected_color = tgui_color_picker(
			user,
			"Select marking color",
			null,
			COLOR_WHITE,
		)

	if(!selected_color)
		return

	selected_color = sanitize_hexcolor(selected_color)

	visible_message(span_notice("[user]开始熟练地为[target_human]上色！"))

	if(do_after(user, 20 SECONDS, target_human))
		switch(selected_mutant_color)
			if("One")
				target_human.dna.features[FEATURE_MUTANT_COLOR] = selected_color
			if("Two")
				target_human.dna.features[FEATURE_MUTANT_COLOR_TWO] = selected_color
			if("Three")
				target_human.dna.features[FEATURE_MUTANT_COLOR_THREE] = selected_color

		target_human.regenerate_icons()
		item_use_power(power_use_amount, user)

		visible_message(span_notice("[user]完成了对[target_human]的上色！"))

		playsound(src.loc, 'sound/effects/spray2.ogg', 50, TRUE)


/obj/item/fur_dyer/proc/dye_marking(mob/living/carbon/human/target_human, mob/living/user)

	var/list/list/current_markings = target_human.dna.body_markings.Copy()

	if(!current_markings.len)
		to_chat(user, span_danger("[target_human]没有斑纹！"))
		return

	if(!(item_use_power(power_use_amount, user, TRUE) & COMPONENT_POWER_SUCCESS))
		to_chat(user, span_danger("红灯闪烁！"))
		return

	var/selected_marking_area = user.zone_selected

	if(!current_markings[selected_marking_area])
		to_chat(user, span_danger("[target_human]的这个肢体上没有身体斑纹！"))
		return

	var/selected_marking_id = tgui_input_list(user, "请选择你想要染色的标记！", "选择标记", current_markings[selected_marking_area])

	if(!selected_marking_id)
		return

	var/selected_color = tgui_color_picker(
			user,
			"Select marking color",
			null,
			COLOR_WHITE,
		)

	if(!selected_color)
		return

	selected_color = sanitize_hexcolor(selected_color)

	visible_message(span_notice("[user]开始熟练地为[target_human]上色！"))

	if(do_after(user, 20 SECONDS, target_human))
		current_markings[selected_marking_area][selected_marking_id] = selected_color

		target_human.dna.body_markings = current_markings.Copy()

		target_human.regenerate_icons()

		item_use_power(power_use_amount, user)

		visible_message(span_notice("[user]完成了对[target_human]的上色！"))

		playsound(src.loc, 'sound/effects/spray2.ogg', 50, TRUE)

#undef COLOR_MODE_SPECIFIC
#undef COLOR_MODE_GENERAL
