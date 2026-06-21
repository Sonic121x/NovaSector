/obj/item/reagent_containers/chem_pack
	name = "静脉注射医疗袋"
	desc = "一个塑料压力袋，或“化学注射袋”，用于静脉给药。它配有热封条。"
	icon = 'icons/obj/medical/bloodpack.dmi'
	icon_state = "chempack"
	volume = 100
	initial_reagent_flags = OPENCONTAINER
	obj_flags = UNIQUE_RENAME
	resistance_flags = ACID_PROOF
	fill_icon_thresholds = list(10, 20, 30, 40, 50, 60, 70, 80, 90, 100)
	has_variable_transfer_amount = FALSE
	interaction_flags_click = NEED_DEXTERITY

/obj/item/reagent_containers/chem_pack/click_alt(mob/living/user)
	if(reagents.flags & SEALED_CONTAINER)
		balloon_alert(user, "已经密封好了！")
		return CLICK_ACTION_BLOCKING

	if(iscarbon(user) && (HAS_TRAIT(user, TRAIT_CLUMSY) && prob(50)))
		to_chat(user, span_warning("呃……糟糕！你不小心把袋子里的东西洒在了自己身上。"))
		splash_reagents(user, user, allow_closed_splash = TRUE)
		return CLICK_ACTION_BLOCKING

	update_container_flags(SEALED_CONTAINER | DRAWABLE | INJECTABLE)
	balloon_alert(user, "已密封")
	return CLICK_ACTION_SUCCESS

/obj/item/reagent_containers/chem_pack/examine()
	. = ..()
	if(reagents.flags & SEALED_CONTAINER)
		. += span_notice("袋子已被密封。")
	else
		. += span_notice("按Alt键点击以密封它。")
