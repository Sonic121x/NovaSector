#define COLOR_MODE_SPECIFIC "Specific Marking"
#define COLOR_MODE_GENERAL "General Color"

/obj/item/fur_dyer
	name = "electric fur dyer"
	desc = "Dye that is capable of recoloring fur in a mostly permanent way."
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

	balloon_alert(user, LANG("obj.0b6ad75c9e056bff", list(mode)))

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
	var/selected_mutant_color = tgui_alert(user, LANG("obj.6b5bdf745605ae09", null), LANG("obj.42c123ce667bc93c", null), list("One", "Two", "Three"))

	if(!selected_mutant_color)
		return

	if(!(item_use_power(power_use_amount, user, TRUE) & COMPONENT_POWER_SUCCESS))
		to_chat(user, span_danger(LANG("obj.ec147c844f9fb696", null)))
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

	visible_message(span_notice(LANG("obj.2f57fad5d2776bb8", list(user, target_human))))

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

		visible_message(span_notice(LANG("obj.14416cbebcf22931", list(user, target_human))))

		playsound(src.loc, 'sound/effects/spray2.ogg', 50, TRUE)


/obj/item/fur_dyer/proc/dye_marking(mob/living/carbon/human/target_human, mob/living/user)

	var/list/list/current_markings = target_human.dna.body_markings.Copy()

	if(!current_markings.len)
		to_chat(user, span_danger(LANG("obj.6cefc3fd3c269f71", list(target_human))))
		return

	if(!(item_use_power(power_use_amount, user, TRUE) & COMPONENT_POWER_SUCCESS))
		to_chat(user, span_danger(LANG("obj.ec147c844f9fb696", null)))
		return

	var/selected_marking_area = user.zone_selected

	if(!current_markings[selected_marking_area])
		to_chat(user, span_danger(LANG("obj.c00e7ad55ccf49f2", list(target_human))))
		return

	var/selected_marking_id = tgui_input_list(user, LANG("obj.a756a3440f15134b", null), LANG("obj.7ae3b525b6d3c1e5", null), current_markings[selected_marking_area])

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

	visible_message(span_notice(LANG("obj.2f57fad5d2776bb8", list(user, target_human))))

	if(do_after(user, 20 SECONDS, target_human))
		current_markings[selected_marking_area][selected_marking_id] = selected_color

		target_human.dna.body_markings = current_markings.Copy()

		target_human.regenerate_icons()

		item_use_power(power_use_amount, user)

		visible_message(span_notice(LANG("obj.14416cbebcf22931", list(user, target_human))))

		playsound(src.loc, 'sound/effects/spray2.ogg', 50, TRUE)

#undef COLOR_MODE_SPECIFIC
#undef COLOR_MODE_GENERAL
