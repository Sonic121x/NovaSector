#define LARGE_MORTAR_STAMINA_MINIMUM 50 //What is the amount of stam damage that we prevent mortar use at
#define LARGE_MORTAR_STAMINA_USE 70 //How much stam damage is given to people when the mortar is used

/obj/structure/large_mortar
	name = "large mortar"
	desc = "A large bowl perfect for grinding or juicing a large number of things at once."
	icon = 'modular_nova/modules/primitive_cooking_additions/icons/cooking_structures.dmi'
	icon_state = "big_mortar"
	density = TRUE
	anchored = TRUE
	max_integrity = 100
	pass_flags = PASSTABLE
	resistance_flags = FLAMMABLE
	custom_materials = list(
		/datum/material/wood = SHEET_MATERIAL_AMOUNT  * 10,
	)
	/// The maximum number of items this structure can store
	var/maximum_contained_items = 10

/obj/structure/large_mortar/Initialize(mapload)
	. = ..()
	create_reagents(200, OPENCONTAINER)

	AddElement(/datum/element/falling_hazard, damage = 20, wound_bonus = 5, hardhat_safety = TRUE, crushes = FALSE)

/obj/structure/large_mortar/examine(mob/user)
	. = ..()
	. += span_notice(LANG("obj.fdec676b9c1661e3", list(length(contents), maximum_contained_items)))
	. += span_notice(LANG("obj.48a3e387c72052ad", null))
	. += span_notice(LANG("obj.71ecf66287778829", null))

/obj/structure/large_mortar/Destroy()
	drop_everything_contained()
	return ..()

/obj/structure/large_mortar/click_alt(mob/user)
	if(!length(contents))
		balloon_alert(user, LANG("obj.1c3a27a165608d55", null))
		return CLICK_ACTION_BLOCKING

	drop_everything_contained()
	balloon_alert(user, LANG("obj.35edb25f79ae774e", null))
	return CLICK_ACTION_SUCCESS

/// Drops all contents at the mortar
/obj/structure/large_mortar/proc/drop_everything_contained()
	if(!length(contents))
		return

	for(var/obj/target_item as anything in contents)
		target_item.forceMove(get_turf(src))

/obj/structure/large_mortar/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return

	if(!can_interact(user) || !user.can_perform_action(src))
		return

	set_anchored(!anchored)
	balloon_alert_to_viewers(anchored ? "secured" : "unsecured")
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/structure/large_mortar/item_interaction(mob/living/user, obj/item/tool, list/modifiers, is_right_clicking)
	. = ..()

	if(. || user.combat_mode || tool.is_refillable())
		return .

	if(istype(tool, /obj/item/storage/bag))
		if(length(contents) >= maximum_contained_items)
			balloon_alert(user, LANG("obj.e28c7f55e1d974b1", null))
			return ITEM_INTERACT_BLOCKING

		if(!length(tool.contents))
			balloon_alert(user, LANG("obj.7e39eb3741bf83f2", null))
			return ITEM_INTERACT_BLOCKING

		for(var/obj/item/target_item in tool.contents)
			if(length(contents) >= maximum_contained_items)
				break

			if(target_item.juice_typepath() || target_item.grind_results())
				target_item.forceMove(src)

		if (length(contents) >= maximum_contained_items)
			balloon_alert(user, LANG("obj.24e1316745ee6537", null))

		else
			balloon_alert(user, LANG("obj.1ce4361d9c08aad1", null))

		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/pestle))
		if(!anchored)
			balloon_alert(user, LANG("obj.801f0be9a529882b", null))
			return ITEM_INTERACT_BLOCKING

		if(!length(contents) && reagents.total_volume == 0)
			balloon_alert(user, LANG("obj.39b5d6cdb676a212", null))
			return ITEM_INTERACT_BLOCKING

		var/list/choose_options = list(
			"Grind" = image(icon = 'icons/hud/radial.dmi', icon_state = "radial_grind"),
			"Juice" = image(icon = 'icons/hud/radial.dmi', icon_state = "radial_juice"),
			"Mix" = image(icon = 'icons/hud/radial.dmi', icon_state = "radial_mix"),
		)
		var/picked_option = show_radial_menu(user, src, choose_options, radius = 38, require_near = TRUE)

		if(user.get_stamina_loss() > LARGE_MORTAR_STAMINA_MINIMUM)
			balloon_alert(user, LANG("obj.6ba63ace20a73a48", null))
			return ITEM_INTERACT_BLOCKING

		if(!in_range(src, user) || !user.is_holding(tool) || !picked_option)
			return ITEM_INTERACT_BLOCKING

		var/act_verb = LOWER_TEXT(picked_option)
		var/act_verb_ing
		if(act_verb == "juice")
			act_verb_ing = "juicing"

		else
			act_verb_ing = "[act_verb]ing"

		var/has_resource
		if(picked_option == "Mix")
			has_resource = reagents.total_volume > 0

		else
			has_resource = length(contents) > 0

		if(!has_resource)
			balloon_alert(user, LANG("obj.90aa33129bf16ccb", list(act_verb)))
			return ITEM_INTERACT_BLOCKING

		balloon_alert_to_viewers("[act_verb_ing]...")
		var/skill_modifier = user.mind?.get_skill_modifier(/datum/skill/primitive, SKILL_SPEED_MODIFIER)
		if(!do_after(user, 5 SECONDS * skill_modifier, target = src))
			balloon_alert_to_viewers(LANG("obj.a2a87f6e6b60ed51", list(act_verb_ing)))
			return ITEM_INTERACT_BLOCKING

		user.adjust_stamina_loss(LARGE_MORTAR_STAMINA_USE) //This is a bit more tiring than a normal sized mortar and pestle
		switch(picked_option)
			if("Juice")
				for(var/obj/item/target_item as anything in contents)
					if (reagents.total_volume >= reagents.maximum_volume)
						balloon_alert(user, LANG("obj.509afd4b61a9d333", null))
						break

					if(target_item.juice_typepath())
						juice_target_item(target_item, user)

					else
						grind_target_item(target_item, user)

			if("Grind")
				for(var/obj/item/target_item as anything in contents)
					if (reagents.total_volume >= reagents.maximum_volume)
						balloon_alert(user, LANG("obj.509afd4b61a9d333", null))
						break

					if(target_item.grind_results() || target_item.reagents?.total_volume)
						grind_target_item(target_item, user)

					else
						juice_target_item(target_item, user)
			if("Mix")
				mix()

		return ITEM_INTERACT_SUCCESS

	if(!tool.grind_results() && !tool.juice_typepath() && !tool.reagents?.total_volume)
		balloon_alert(user, LANG("obj.4cd150fff7630cfc", null))
		return ITEM_INTERACT_BLOCKING

	if(length(contents) >= maximum_contained_items)
		balloon_alert(user, LANG("obj.e28c7f55e1d974b1", null))
		return ITEM_INTERACT_BLOCKING

	tool.forceMove(src)
	return ITEM_INTERACT_SUCCESS

///Juices the passed target item, and transfers any contained chems to the mortar as well
/obj/structure/large_mortar/proc/juice_target_item(obj/item/to_be_juiced, mob/living/carbon/human/user)
	if(to_be_juiced.flags_1 & HOLOGRAM_1)
		to_chat(user, span_notice(LANG("obj.89badf16da556d7a", list(to_be_juiced))))
		qdel(to_be_juiced)
		return

	if(!to_be_juiced.juice(src.reagents, user))
		to_chat(user, span_danger(LANG("obj.9d6b7d5a879b8fcb", list(to_be_juiced))))

	to_chat(user, span_notice(LANG("obj.b2cacd3ebd8dc838", list(to_be_juiced))))
	user.mind?.adjust_experience(/datum/skill/primitive, 2)
	QDEL_NULL(to_be_juiced)

///Grinds the passed target item, and transfers any contained chems to the mortar as well
/obj/structure/large_mortar/proc/grind_target_item(obj/item/to_be_ground, mob/living/carbon/human/user)
	if(to_be_ground.flags_1 & HOLOGRAM_1)
		to_chat(user, span_notice(LANG("obj.2708cfa5091c138b", list(to_be_ground))))
		qdel(to_be_ground)
		return

	if(!to_be_ground.grind(src.reagents, user))
		if(isstack(to_be_ground))
			to_chat(user, span_notice(LANG("obj.10d463a7660f5ddc", list(src, to_be_ground))))

		else
			to_chat(user, span_danger(LANG("obj.b0102c6717af1327", list(to_be_ground))))

	to_chat(user, span_notice(LANG("obj.095775cc216baf01", list(to_be_ground))))
	user.mind?.adjust_experience(/datum/skill/primitive, 2)
	QDEL_NULL(to_be_ground)

///Mixes contained reagents, creating butter/mayo/whipped cream
/obj/structure/large_mortar/proc/mix(mob/user)
	//Recipe to make Butter
	var/butter_amt = floor(reagents.get_reagent_amount(/datum/reagent/consumable/milk) / MILK_TO_BUTTER_COEFF)
	var/purity = reagents.get_reagent_purity(/datum/reagent/consumable/milk)
	reagents.remove_reagent(/datum/reagent/consumable/milk, MILK_TO_BUTTER_COEFF * butter_amt)
	for(var/i in 1 to butter_amt)
		var/obj/item/food/butter/tasty_butter = new(drop_location())
		tasty_butter.reagents.set_all_reagents_purity(purity)
		user.mind?.adjust_experience(/datum/skill/primitive, 2)

	//Recipe to make Mayonnaise
	if (reagents.has_reagent(/datum/reagent/consumable/eggyolk))
		reagents.convert_reagent(/datum/reagent/consumable/eggyolk, /datum/reagent/consumable/mayonnaise)
		user.mind?.adjust_experience(/datum/skill/primitive, 2)

	//Recipe to make whipped cream
	if (reagents.has_reagent(/datum/reagent/consumable/cream))
		reagents.convert_reagent(/datum/reagent/consumable/cream, /datum/reagent/consumable/whipped_cream)
		user.mind?.adjust_experience(/datum/skill/primitive, 2)

#undef LARGE_MORTAR_STAMINA_MINIMUM
#undef LARGE_MORTAR_STAMINA_USE
