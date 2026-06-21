#define CLIMAX_VAGINA "Vagina"
#define CLIMAX_PENIS "Penis"
#define CLIMAX_BOTH "Both"

#define CLIMAX_ON_FLOOR "On the floor"
#define CLIMAX_IN_OR_ON "Climax in or on someone"
#define CLIMAX_OPEN_CONTAINER "Fill reagent container"

/mob/living/carbon/human
	/// Used to prevent nightmare scenarios.
	var/refractory_period

/mob/living/carbon/human/proc/climax(manual = TRUE)
	if (CONFIG_GET(flag/disable_erp_preferences))
		return

	if(!client?.prefs?.read_preference(/datum/preference/toggle/erp/autocum) && !manual)
		return
	if(refractory_period > REALTIMEOFDAY)
		return
	refractory_period = REALTIMEOFDAY + 30 SECONDS
	if(has_status_effect(/datum/status_effect/climax_cooldown) || !client?.prefs?.read_preference(/datum/preference/toggle/erp))
		return

	if(HAS_TRAIT(src, TRAIT_NEVERBONER) || has_status_effect(/datum/status_effect/climax_cooldown) || (!has_vagina() && !has_penis()))
		visible_message(span_purple("[src] 抽搐着，试图射精，但毫无结果。"), \
			span_purple("你无法达到高潮！"), pref_to_check = /datum/preference/toggle/erp)
		return TRUE

	// Reduce pop-ups and make it slightly more frictionless (lewd).
	var/climax_choice = has_penis() ? CLIMAX_PENIS : CLIMAX_VAGINA

	if(manual)
		var/list/genitals = list()
		if(has_vagina())
			genitals.Add(CLIMAX_VAGINA)
			if(has_penis())
				genitals.Add(CLIMAX_PENIS)
				genitals.Add(CLIMAX_BOTH)
		else if(has_penis())
			genitals.Add(CLIMAX_PENIS)
		climax_choice = tgui_alert(src, "你正在高潮，请选择用哪个生殖器高潮。", "生殖器偏好！", genitals)

	switch(gender)
		if(MALE)
			playsound_if_pref(get_turf(src), pick('modular_nova/modules/modular_items/lewd_items/sounds/final_m1.ogg',
										'modular_nova/modules/modular_items/lewd_items/sounds/final_m2.ogg',
										'modular_nova/modules/modular_items/lewd_items/sounds/final_m3.ogg'), 50, TRUE, pref_to_check = /datum/preference/toggle/erp/sounds)
		if(FEMALE)
			playsound_if_pref(get_turf(src), pick('modular_nova/modules/modular_items/lewd_items/sounds/final_f1.ogg',
										'modular_nova/modules/modular_items/lewd_items/sounds/final_f2.ogg',
										'modular_nova/modules/modular_items/lewd_items/sounds/final_f3.ogg'), 50, TRUE, pref_to_check = /datum/preference/toggle/erp/sounds)

	var/self_orgasm = FALSE
	var/self_their = p_their()

	if(climax_choice == CLIMAX_PENIS || climax_choice == CLIMAX_BOTH)
		var/obj/item/organ/genital/penis/penis = get_organ_slot(ORGAN_SLOT_PENIS)
		if(!get_organ_slot(ORGAN_SLOT_TESTICLES)) //If we have no god damn balls, we can't cum anywhere... GET BALLS!
			visible_message(span_userlove("[src] 高潮了，但[self_their]阴茎里什么也没射出来！"), \
				span_userlove("你高潮了，感觉很棒，但你的阴茎里什么也没流出来！"), pref_to_check = /datum/preference/toggle/erp)

		else if(is_wearing_condom())
			var/obj/item/clothing/sextoy/condom/condom = src.penis
			condom.condom_use()
			visible_message(span_userlove("[src] 将[self_their]精液射进了[condom]，把它填满了！"), \
				span_userlove("你将浓稠的精液射进了[condom]里，它全部接住了！"), pref_to_check = /datum/preference/toggle/erp)

		else if(!is_bottomless() && penis.visibility_preference != GENITAL_ALWAYS_SHOW)
			visible_message(span_userlove("[src] 射在了[self_their]衣服里！"), \
				span_userlove("你射了出来，但你没脱衣服，所以弄脏了你的衣服！"), pref_to_check = /datum/preference/toggle/erp)
			self_orgasm = TRUE

		else
			var/list/interactable_inrange_humans = list()
			var/list/interactable_inrange_open_containers = list()

			// Unfortunately prefs can't be checked here, because byond/tgstation moment.
			for(var/mob/living/carbon/human/iterating_human in (view(1, src) - src))
				interactable_inrange_humans[iterating_human.name] = iterating_human

			// this should be making a list of cups(?)
			for(var/obj/item/reagent_containers/cup/iterating_open_container in (view(1, src)))
				if(!iterating_open_container.is_refillable() || !iterating_open_container.is_drainable())
					continue
				interactable_inrange_open_containers[iterating_open_container.name] = iterating_open_container

			var/list/buttons = list(CLIMAX_ON_FLOOR)
			if(interactable_inrange_humans.len)
				buttons += CLIMAX_IN_OR_ON

			if(interactable_inrange_open_containers.len)
				buttons += CLIMAX_OPEN_CONTAINER

			var/penis_climax_choice = tgui_alert(src, "选择将精液射到哪里。", "精液偏好！", buttons)

			var/create_cum_decal = FALSE

			if(isnull(penis_climax_choice) || penis_climax_choice == CLIMAX_ON_FLOOR)
				create_cum_decal = TRUE
				visible_message(span_userlove("[src] 将[self_their]黏稠的精液射到了地板上！"), \
					span_userlove("你射出一股又一股滚烫的精液，打在了地板上！"), pref_to_check = /datum/preference/toggle/erp)

			else if(penis_climax_choice == CLIMAX_OPEN_CONTAINER)
				var/target_choice = tgui_input_list(src, "选择一个容器射进去。", "选择目标！", interactable_inrange_open_containers)
				if(isnull(target_choice))
					create_cum_decal = TRUE
					visible_message(span_userlove("[src] 将[self_their]黏稠的精液射到了地板上！"), \
						span_userlove("你决定就这么干了，射出一股又一股滚烫的精液，打在了地板上！"), pref_to_check = /datum/preference/toggle/erp)
				else
					var/obj/item/reagent_containers/cup/target_open_container = interactable_inrange_open_containers[target_choice]
					if(target_open_container.is_refillable() && target_open_container.is_drainable())
						var/obj/item/organ/genital/testicles/src_testicles = src.get_organ_slot(ORGAN_SLOT_TESTICLES)
						var/load_volume = src_testicles.genital_size * 10
						playsound_if_pref(get_turf(src), SFX_DESECRATION, 50, TRUE, pref_to_check = /datum/preference/toggle/erp/sounds)
						if(target_open_container.reagents.holder_full())
							// reagent container is full
							add_cum_splatter_floor(get_turf(target_open_container))
							visible_message(span_userlove("[src] 试图射进[target_open_container]里，但它已经满了，滚烫的精液洒到了地板上！"), \
								span_userlove("你试图射进[target_open_container]里，但它已经满了，所以全都打在了地板上！"), pref_to_check = /datum/preference/toggle/erp)
						else
							target_open_container.reagents.add_reagent(/datum/reagent/consumable/cum, load_volume)
							if((load_volume + target_open_container.reagents.total_volume) > target_open_container.volume)
								// the chalice overfloweth
								add_cum_splatter_floor(get_turf(target_open_container))
								visible_message(span_userlove("[src] 将[self_their]黏稠的精液射进了[target_open_container]里，但它太满了以至于溢了出来！"), \
									span_userlove("你将一股又一股滚烫的精液射进[target_open_container]里，让它溢了出来！"), pref_to_check = /datum/preference/toggle/erp)
							else
								visible_message(span_userlove("[src] 将[self_their]黏稠的精液射进了[target_open_container]里！"), \
									span_userlove("你将一股又一股滚烫的精液射进[target_open_container]里！"), pref_to_check = /datum/preference/toggle/erp)
					else
						// somehow the reagents changed while we were deciding where to go
						create_cum_decal = TRUE
						visible_message(span_userlove("[src] 将[self_their]黏稠的精液射到了地板上！"), \
							span_userlove("你射出一股又一股滚烫的精液，打在了地板上！"), pref_to_check = /datum/preference/toggle/erp)

			else
				var/target_choice = tgui_input_list(src, "选择一个人射在里面或上面。", "选择目标！", interactable_inrange_humans)
				if(!target_choice)
					create_cum_decal = TRUE
					visible_message(span_userlove("[src] 将[self_their]黏稠的精液射到了地板上！"), \
						span_userlove("你射出一股又一股滚烫的精液，打在了地板上！"), pref_to_check = /datum/preference/toggle/erp)
				else
					var/mob/living/carbon/human/target_human = interactable_inrange_humans[target_choice]
					var/target_human_them = target_human.p_them()

					var/list/target_buttons = list()

					if(!target_human.wear_mask)
						target_buttons += "mouth"
					if(target_human.has_vagina(REQUIRE_GENITAL_EXPOSED))
						target_buttons += ORGAN_SLOT_VAGINA
					if(target_human.has_anus(REQUIRE_GENITAL_EXPOSED))
						target_buttons += "asshole"
					if(target_human.has_penis(REQUIRE_GENITAL_EXPOSED))
						var/obj/item/organ/genital/penis/other_penis = target_human.get_organ_slot(ORGAN_SLOT_PENIS)
						if(other_penis.sheath != SPRITE_ACCESSORY_NONE)
							target_buttons += "sheath"
					target_buttons += "On [target_human_them]"

					var/climax_into_choice = tgui_input_list(src, "你希望在[target_human]的哪个位置或里面射精？", "最终边界！", target_buttons)

					if(!climax_into_choice)
						create_cum_decal = TRUE
						visible_message(span_userlove("[src] 将他们的黏稠精液射到了地板上！"), \
							span_userlove("你射出一股又一股滚烫的精液，打在了地板上！"), pref_to_check = /datum/preference/toggle/erp)
					else if(climax_into_choice == "On [target_human_them]")
						create_cum_decal = TRUE
						visible_message(span_userlove("[src] 将他们的黏稠精液射到了[target_human]身上！"), \
							span_userlove("你将一股又一股滚烫的精液射到了[target_human]身上！"), pref_to_check = /datum/preference/toggle/erp)
					else
						visible_message(span_userlove("[src]将[self_their]的肉棒深深插入[target_human]的[climax_into_choice]中，将精液射入[target_human_them]体内！"), \
							span_userlove("你将肉棒深深插入[target_human]的[climax_into_choice]中，将精液射入[target_human_them]体内！"), pref_to_check = /datum/preference/toggle/erp)
						to_chat(target_human, span_userlove("你的[climax_into_choice]被温热的精液充满，因为[src]将[self_their]的精华射入了其中。"))

			var/obj/item/organ/genital/testicles/testicles = get_organ_slot(ORGAN_SLOT_TESTICLES)
			testicles.transfer_internal_fluid(null, testicles.internal_fluid_count * 0.6) // yep. we are sending semen to nullspace
			if(create_cum_decal)
				add_cum_splatter_floor(get_turf(src))

		try_lewd_autoemote("moan")
		if(climax_choice == CLIMAX_PENIS)
			apply_status_effect(/datum/status_effect/climax)
			apply_status_effect(/datum/status_effect/climax_cooldown)
			if(self_orgasm)
				add_mood_event("orgasm", /datum/mood_event/climaxself)
			return TRUE

	if(climax_choice == CLIMAX_VAGINA || climax_choice == CLIMAX_BOTH)
		var/obj/item/organ/genital/vagina/vagina = get_organ_slot(ORGAN_SLOT_VAGINA)
		if(is_bottomless() || vagina.visibility_preference == GENITAL_ALWAYS_SHOW)
			visible_message(span_userlove("[src]抽搐着呻吟，因为[p_they()]从阴道达到了高潮！"), span_userlove("你抽搐着呻吟，因为你从阴道达到了高潮！"), pref_to_check = /datum/preference/toggle/erp)
			add_cum_splatter_floor(get_turf(src), female = TRUE)
		else
			visible_message(span_userlove("[src]从[self_their]的阴道射在了[self_their]的内裤里！"), \
						span_userlove("你从阴道射在了自己的内裤里！呃。"), pref_to_check = /datum/preference/toggle/erp)
			self_orgasm = TRUE

	apply_status_effect(/datum/status_effect/climax)
	apply_status_effect(/datum/status_effect/climax_cooldown)
	if(self_orgasm)
		add_mood_event("orgasm", /datum/mood_event/climaxself)
	return TRUE

#undef CLIMAX_VAGINA
#undef CLIMAX_PENIS
#undef CLIMAX_BOTH
#undef CLIMAX_ON_FLOOR
#undef CLIMAX_IN_OR_ON
#undef CLIMAX_OPEN_CONTAINER
