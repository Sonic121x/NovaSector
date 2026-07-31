#define MILLSTONE_STAMINA_MINIMUM 50 //What is the amount of stam damage that we prevent mill use at
#define MILLSTONE_STAMINA_USE 100 //How much stam damage is given to people when the mill is used

/obj/structure/millstone
	name = "millstone"
	desc = "Two big disks of something heavy and tough. Put a plant between them and spin, and you'll end up with seeds and a really ground up plant."
	icon = 'modular_nova/modules/primitive_cooking_additions/icons/millstone.dmi'
	icon_state = "millstone"
	density = TRUE
	anchored = TRUE
	max_integrity = 200
	pass_flags = PASSTABLE
	custom_materials = list(
		/datum/material/stone = SHEET_MATERIAL_AMOUNT  * 6,
	)
	drag_slowdown = 2

	/// The maximum number of items this structure can store
	var/maximum_contained_items = 10

/obj/structure/millstone/examine(mob/user)
	. = ..()

	. += span_notice(LANG("obj.fdec676b", list(length(contents), maximum_contained_items)))
	. += span_notice(LANG("obj.a0cbffb8", list(src)))
	. += span_notice(LANG("obj.71ecf662", null))

	if(length(contents))
		. += span_notice(LANG("obj.0cd99d60", null))
		var/list/stuff_inside = list()
		for(var/obj/thing as anything in contents)
			stuff_inside[thing.type] += 1

		for(var/obj/thing as anything in stuff_inside)
			. += span_notice(LANG("obj.8102b6d1", list(stuff_inside[thing], initial(thing.name))))

		. += span_notice(LANG("obj.507ea0f0", list(maximum_contained_items - length(contents))))

	else
		. += span_notice(LANG("obj.7b62c90e", list(maximum_contained_items)))

	. += span_notice(LANG("obj.191eddbb", list(anchored ? "un" : "", src)))
	. += span_notice(LANG("obj.0f938112", list(src)))

/obj/structure/millstone/Destroy()
	drop_everything_contained()
	return ..()

/obj/structure/millstone/atom_deconstruct(disassembled)
	var/obj/item/stack/sheet/mineral/stone/stone = new(drop_location(), 6)
	transfer_fingerprints_to(stone)
	return ..()

/obj/structure/millstone/click_alt(mob/user)
	if(!length(contents))
		balloon_alert(user, LANG("obj.c2ebeaa8", null))
		return CLICK_ACTION_BLOCKING

	drop_everything_contained()
	balloon_alert(user, LANG("obj.35edb25f", null))
	return CLICK_ACTION_SUCCESS

/obj/structure/millstone/click_ctrl_shift(mob/user)
	set_anchored(!anchored)
	balloon_alert(user, "[anchored ? "secured" : "unsecured"]")

/// Drops all contents at the mortar
/obj/structure/millstone/proc/drop_everything_contained()
	if(!length(contents))
		return

	for(var/obj/target_item as anything in contents)
		target_item.forceMove(get_turf(src))

/obj/structure/millstone/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return

	if(!can_interact(user) || !user.can_perform_action(src))
		return

	mill_it_up(user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/structure/millstone/crowbar_act(mob/living/user, obj/item/tool)
	. = ..()
	balloon_alert_to_viewers(LANG("obj.b5ba9871", null))
	if(!do_after(user, 2 SECONDS, src))
		return

	deconstruct(TRUE)

/obj/structure/millstone/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/storage/bag))
		if(length(contents) >= maximum_contained_items)
			balloon_alert(user, LANG("obj.e3949c3a", null))
			return ITEM_INTERACT_SUCCESS

		if(!length(tool.contents))
			balloon_alert(user, LANG("obj.7e39eb37", null))
			return ITEM_INTERACT_SUCCESS

		for(var/obj/item/food/grown/target_item in tool.contents)
			if(length(contents) >= maximum_contained_items)
				break

			target_item.forceMove(src)

		if (length(contents) >= maximum_contained_items)
			balloon_alert(user, LANG("obj.f5ddc80d", null))

		else
			balloon_alert(user, LANG("obj.1ce4361d", null))

		return ITEM_INTERACT_SUCCESS

	if(!(istype(tool, /obj/item/food/grown) || istype(tool, /obj/item/grown)))
		balloon_alert(user, LANG("obj.24f71cd2", null))
		return ..()

	if(length(contents) >= maximum_contained_items)
		balloon_alert(user, LANG("obj.e3949c3a", null))
		return ITEM_INTERACT_BLOCKING

	tool.forceMove(src)
	balloon_alert(user, LANG("obj.5567b4ed", list(tool)))
	return ITEM_INTERACT_SUCCESS

/// Takes the content's seeds and spits them out on the turf, as well as grinding whatever the contents may be
/obj/structure/millstone/proc/mill_it_up(mob/living/carbon/human/user)
	if(!length(contents))
		balloon_alert(user, LANG("obj.13bdb106", null))
		return

	if(user.get_stamina_loss() > MILLSTONE_STAMINA_MINIMUM)
		balloon_alert(user, LANG("obj.1401aa77", null))
		return

	if(!length(contents) || !in_range(src, user))
		return

	balloon_alert_to_viewers(LANG("obj.c87262cc", null))

	flick("millstone_spin", src)
	playsound(src, 'sound/effects/stonedoor_openclose.ogg', 50, TRUE)

	user.adjust_stamina_loss(MILLSTONE_STAMINA_USE) // Prevents spamming it

	var/skill_modifier = user.mind?.get_skill_modifier(/datum/skill/primitive, SKILL_SPEED_MODIFIER)
	if(!do_after(user, 5 SECONDS * skill_modifier, target = src))
		balloon_alert_to_viewers(LANG("obj.2e115f54", null))
		return

	for(var/target_item in contents)
		seedify(target_item, t_max = 1)

	balloon_alert_to_viewers(LANG("obj.b03db55e", null))
	user.mind?.adjust_experience(/datum/skill/primitive, 5)

#undef MILLSTONE_STAMINA_MINIMUM
#undef MILLSTONE_STAMINA_USE
