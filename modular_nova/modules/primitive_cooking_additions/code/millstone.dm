#define MILLSTONE_STAMINA_MINIMUM 50 //What is the amount of stam damage that we prevent mill use at
#define MILLSTONE_STAMINA_USE 100 //How much stam damage is given to people when the mill is used

/obj/structure/millstone
	name = "磨石"
	desc = "两个由某种沉重坚硬材料制成的大圆盘。把植物放在它们之间旋转，你就能得到种子和磨得粉碎的植物。"
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

	. += span_notice("它目前包含<b>[length(contents)]/[maximum_contained_items]</b>件物品。")
	. += span_notice("你可以用<b>右键点击</b>来处理[src]的内容")
	. += span_notice("你可以用<b>Alt 点击</b>清空其中的所有物品")

	if(length(contents))
		. += span_notice("里面，你可以看到：")
		var/list/stuff_inside = list()
		for(var/obj/thing as anything in contents)
			stuff_inside[thing.type] += 1

		for(var/obj/thing as anything in stuff_inside)
			. += span_notice("&bull; [stuff_inside[thing]] [initial(thing.name)]\s")

		. += span_notice("并且它还能再容纳<b>[maximum_contained_items - length(contents)]</b>件物品。")

	else
		. += span_notice("它可以容纳<b>[maximum_contained_items]</b>件物品，目前里面空无一物。")

	. += span_notice("你可以用<b>CTRL-Shift-Click</b>来[anchored ? "un" : ""]固定[src]。")
	. += span_notice("用某种<b>撬棍工具</b>，你可以把[src]拆开。")

/obj/structure/millstone/Destroy()
	drop_everything_contained()
	return ..()

/obj/structure/millstone/atom_deconstruct(disassembled)
	var/obj/item/stack/sheet/mineral/stone/stone = new(drop_location(), 6)
	transfer_fingerprints_to(stone)
	return ..()

/obj/structure/millstone/click_alt(mob/user)
	if(!length(contents))
		balloon_alert(user, "里面没有东西！")
		return CLICK_ACTION_BLOCKING

	drop_everything_contained()
	balloon_alert(user, "已移除所有物品")
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
	balloon_alert_to_viewers("disassembling...")
	if(!do_after(user, 2 SECONDS, src))
		return

	deconstruct(TRUE)

/obj/structure/millstone/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers)
	if(istype(attacking_item, /obj/item/storage/bag))
		if(length(contents) >= maximum_contained_items)
			balloon_alert(user, "已经满了")
			return TRUE

		if(!length(attacking_item.contents))
			balloon_alert(user, "没有东西可转移！")
			return TRUE

		for(var/obj/item/food/grown/target_item in attacking_item.contents)
			if(length(contents) >= maximum_contained_items)
				break

			target_item.forceMove(src)

		if (length(contents) >= maximum_contained_items)
			balloon_alert(user, "已装满！")

		else
			balloon_alert(user, "已转移")

		return TRUE

	if(!(istype(attacking_item, /obj/item/food/grown) || istype(attacking_item, /obj/item/grown)))
		balloon_alert(user, "只能研磨植物")
		return ..()

	if(length(contents) >= maximum_contained_items)
		balloon_alert(user, "已经满了")
		return

	attacking_item.forceMove(src)
	balloon_alert(user, "已转移 [attacking_item]")
	return TRUE

/// Takes the content's seeds and spits them out on the turf, as well as grinding whatever the contents may be
/obj/structure/millstone/proc/mill_it_up(mob/living/carbon/human/user)
	if(!length(contents))
		balloon_alert(user, "没有东西可研磨")
		return

	if(user.get_stamina_loss() > MILLSTONE_STAMINA_MINIMUM)
		balloon_alert(user, "太累了")
		return

	if(!length(contents) || !in_range(src, user))
		return

	balloon_alert_to_viewers("grinding...")

	flick("millstone_spin", src)
	playsound(src, 'sound/effects/stonedoor_openclose.ogg', 50, TRUE)

	user.adjust_stamina_loss(MILLSTONE_STAMINA_USE) // Prevents spamming it

	var/skill_modifier = user.mind?.get_skill_modifier(/datum/skill/primitive, SKILL_SPEED_MODIFIER)
	if(!do_after(user, 5 SECONDS * skill_modifier, target = src))
		balloon_alert_to_viewers("stopped grinding")
		return

	for(var/target_item in contents)
		seedify(target_item, t_max = 1)

	balloon_alert_to_viewers("finished grinding")
	user.mind?.adjust_experience(/datum/skill/primitive, 5)

#undef MILLSTONE_STAMINA_MINIMUM
#undef MILLSTONE_STAMINA_USE
