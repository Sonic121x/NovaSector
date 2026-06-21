#define LARGE_MORTAR_STAMINA_MINIMUM 50 //What is the amount of stam damage that we prevent mortar use at
#define LARGE_MORTAR_STAMINA_USE 70 //How much stam damage is given to people when the mortar is used

/obj/structure/large_mortar
	name = "大型研钵"
	desc = "一个适合一次性研磨或榨取大量物品的大碗。"
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
	. += span_notice("它目前装有 <b>[length(contents)]/[maximum_contained_items]</b> 件物品。")
	. += span_notice("可以用 <b>右键点击</b> 来（解除）固定它")
	. += span_notice("你可以用 <b>Alt+点击</b> 清空其中的所有物品")

/obj/structure/large_mortar/Destroy()
	drop_everything_contained()
	return ..()

/obj/structure/large_mortar/click_alt(mob/user)
	if(!length(contents))
		balloon_alert(user, "里面是空的")
		return CLICK_ACTION_BLOCKING

	drop_everything_contained()
	balloon_alert(user, "已移除所有物品")
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

/obj/structure/large_mortar/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers)
	if(attacking_item.is_refillable())
		return

/obj/structure/large_mortar/item_interaction(mob/living/user, obj/item/tool, list/modifiers, is_right_clicking)
	. = ..()

	if(. || user.combat_mode || tool.is_refillable())
		return .

	if(istype(tool, /obj/item/storage/bag))
		if(length(contents) >= maximum_contained_items)
			balloon_alert(user, "已经满了！")
			return ITEM_INTERACT_BLOCKING

		if(!length(tool.contents))
			balloon_alert(user, "没有东西可转移！")
			return ITEM_INTERACT_BLOCKING

		for(var/obj/item/target_item in tool.contents)
			if(length(contents) >= maximum_contained_items)
				break

			if(target_item.juice_typepath() || target_item.grind_results())
				target_item.forceMove(src)

		if (length(contents) >= maximum_contained_items)
			balloon_alert(user, "已填满")

		else
			balloon_alert(user, "已转移")

		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/pestle))
		if(!anchored)
			balloon_alert(user, "未固定！")
			return ITEM_INTERACT_BLOCKING

		if(!length(contents) && reagents.total_volume == 0)
			balloon_alert(user, "研钵是空的！")
			return ITEM_INTERACT_BLOCKING

		var/list/choose_options = list(
			"Grind" = image(icon = 'icons/hud/radial.dmi', icon_state = "radial_grind"),
			"Juice" = image(icon = 'icons/hud/radial.dmi', icon_state = "radial_juice"),
			"Mix" = image(icon = 'icons/hud/radial.dmi', icon_state = "radial_mix"),
		)
		var/picked_option = show_radial_menu(user, src, choose_options, radius = 38, require_near = TRUE)

		if(user.get_stamina_loss() > LARGE_MORTAR_STAMINA_MINIMUM)
			balloon_alert(user, "太累了！")
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
			balloon_alert(user, "没有东西可[act_verb]！")
			return ITEM_INTERACT_BLOCKING

		balloon_alert_to_viewers("[act_verb_ing]...")
		var/skill_modifier = user.mind?.get_skill_modifier(/datum/skill/primitive, SKILL_SPEED_MODIFIER)
		if(!do_after(user, 5 SECONDS * skill_modifier, target = src))
			balloon_alert_to_viewers("stopped [act_verb_ing]")
			return ITEM_INTERACT_BLOCKING

		user.adjust_stamina_loss(LARGE_MORTAR_STAMINA_USE) //This is a bit more tiring than a normal sized mortar and pestle
		switch(picked_option)
			if("Juice")
				for(var/obj/item/target_item as anything in contents)
					if (reagents.total_volume >= reagents.maximum_volume)
						balloon_alert(user, "溢出了！")
						break

					if(target_item.juice_typepath())
						juice_target_item(target_item, user)

					else
						grind_target_item(target_item, user)

			if("Grind")
				for(var/obj/item/target_item as anything in contents)
					if (reagents.total_volume >= reagents.maximum_volume)
						balloon_alert(user, "溢出了！")
						break

					if(target_item.grind_results() || target_item.reagents?.total_volume)
						grind_target_item(target_item, user)

					else
						juice_target_item(target_item, user)
			if("Mix")
				mix()

		return ITEM_INTERACT_SUCCESS

	if(!tool.grind_results() && !tool.juice_typepath() && !tool.reagents?.total_volume)
		balloon_alert(user, "无法研磨这个！")
		return ITEM_INTERACT_BLOCKING

	if(length(contents) >= maximum_contained_items)
		balloon_alert(user, "已经满了！")
		return ITEM_INTERACT_BLOCKING

	tool.forceMove(src)
	return ITEM_INTERACT_SUCCESS

///Juices the passed target item, and transfers any contained chems to the mortar as well
/obj/structure/large_mortar/proc/juice_target_item(obj/item/to_be_juiced, mob/living/carbon/human/user)
	if(to_be_juiced.flags_1 & HOLOGRAM_1)
		to_chat(user, span_notice("你试图榨取[to_be_juiced]的汁液，但它却消失了！"))
		qdel(to_be_juiced)
		return

	if(!to_be_juiced.juice(src.reagents, user))
		to_chat(user, span_danger("你没能榨出[to_be_juiced]的汁液。"))

	to_chat(user, span_notice("你将[to_be_juiced]榨成了液体。"))
	user.mind?.adjust_experience(/datum/skill/primitive, 2)
	QDEL_NULL(to_be_juiced)

///Grinds the passed target item, and transfers any contained chems to the mortar as well
/obj/structure/large_mortar/proc/grind_target_item(obj/item/to_be_ground, mob/living/carbon/human/user)
	if(to_be_ground.flags_1 & HOLOGRAM_1)
		to_chat(user, span_notice("你试图研磨[to_be_ground]，但它却消失了！"))
		qdel(to_be_ground)
		return

	if(!to_be_ground.grind(src.reagents, user))
		if(isstack(to_be_ground))
			to_chat(user, span_notice("[src] 试图尽可能多地研磨 [to_be_ground] 的碎片。"))

		else
			to_chat(user, span_danger("你没能研磨[to_be_ground]。"))

	to_chat(user, span_notice("你将[to_be_ground]研磨成了细粉。"))
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
