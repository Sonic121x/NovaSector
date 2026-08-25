// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/item/reagent_containers/chem_pack
	name = "intravenous medicine bag"
	desc = "A plastic pressure bag, or 'chem pack', for IV administration of drugs. It is fitted with a thermosealing strip."
	icon = 'icons/obj/medical/bloodpack.dmi'
	icon_state = "chempack"
	volume = 100
	initial_reagent_flags = OPENCONTAINER
	obj_flags = UNIQUE_RENAME
	resistance_flags = ACID_PROOF
	fill_icon_thresholds = list(10, 20, 30, 40, 50, 60, 70, 80, 90, 100)
	has_variable_transfer_amount = FALSE
	interaction_flags_click = NEED_DEXTERITY
	custom_materials = list(/datum/material/plastic = SHEET_MATERIAL_AMOUNT)

/obj/item/reagent_containers/chem_pack/click_alt(mob/living/user)
	if(reagents.flags & SEALED_CONTAINER)
		balloon_alert(user, LANG("obj.7274a41d88d49d17", null))
		return CLICK_ACTION_BLOCKING

	if(iscarbon(user) && (HAS_TRAIT(user, TRAIT_CLUMSY) && prob(50)))
		to_chat(user, span_warning(LANG("obj.3c4214b48272b678", null)))
		splash_reagents(user, user, allow_closed_splash = TRUE)
		return CLICK_ACTION_BLOCKING

	update_container_flags(SEALED_CONTAINER | DRAWABLE | INJECTABLE)
	balloon_alert(user, LANG("obj.0d96a9278b4c0ecc", null))
	return CLICK_ACTION_SUCCESS

/obj/item/reagent_containers/chem_pack/examine()
	. = ..()
	if(reagents.flags & SEALED_CONTAINER)
		. += span_notice(LANG("obj.3e382fa17092c522", null))
	else
		. += span_notice(LANG("obj.2ac1d1fbb39f4f15", null))
