/obj/item/reagent_containers/dropper
	name = "滴管"
	desc = "一个可容纳 5u 的滴灌"
	icon = 'icons/obj/medical/chemical.dmi'
	icon_state = "dropper0"
	inhand_icon_state = "dropper"
	worn_icon_state = "pen"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(1, 2, 3, 4, 5)
	volume = 5
	initial_reagent_flags = TRANSPARENT
	custom_price = PAYCHECK_CREW
	custom_materials = list(/datum/material/glass = SHEET_MATERIAL_AMOUNT)

/obj/item/reagent_containers/dropper/interact_with_atom(atom/target, mob/living/user, list/modifiers)
	if(!target.reagents)
		return NONE

	if(reagents.total_volume > 0)
		if(target.reagents.holder_full())
			to_chat(user, span_notice("[target] 已满。"))
			return ITEM_INTERACT_BLOCKING

		if(!target.is_injectable(user))
			to_chat(user, span_warning("你无法将试剂转移到 [target]！"))
			return ITEM_INTERACT_BLOCKING

		var/trans = 0
		var/fraction = min(amount_per_transfer_from_this / reagents.total_volume, 1)

		if(ismob(target))
			user.changeNext_move(CLICK_CD_MELEE)
			if(ishuman(target))
				var/mob/living/carbon/human/victim = target
				var/obj/item/safe_thing = victim.is_eyes_covered()

				if(safe_thing)
					if(!safe_thing.reagents)
						safe_thing.create_reagents(100)

					trans = round(reagents.trans_to(safe_thing, amount_per_transfer_from_this, transferred_by = user, methods = TOUCH), CHEMICAL_VOLUME_ROUNDING)

					target.visible_message(span_danger("[user] 试图将什么东西挤进 [target] 的眼睛，但失败了！"), \
											span_userdanger("[user] 试图将什么东西挤进你的眼睛，但失败了！"))
					if(trans)
						to_chat(user, span_notice("你转移了[trans] unit\s 的溶液。"))
					update_appearance()
					return ITEM_INTERACT_BLOCKING

			else if(isalien(target)) //hiss-hiss has no eyes!
				to_chat(target, span_danger("[target] 似乎没有眼睛！"))
				return ITEM_INTERACT_BLOCKING

			target.visible_message(
				span_danger("[user] 将什么东西挤进了 [target] 的眼睛！"),
				span_userdanger("[user] 将什么东西挤进了你的眼睛！"),
			)
			SEND_SIGNAL(target, COMSIG_MOB_REAGENTS_DROPPED_INTO_EYES, user, src, reagents, fraction)
			reagents.expose(target, TOUCH, fraction)
			var/mob/M = target
			log_combat(user, M, "squirted", reagents.get_reagent_log_string())

		trans = round(reagents.trans_to(target, amount_per_transfer_from_this, transferred_by = user), CHEMICAL_VOLUME_ROUNDING)
		if(trans)
			to_chat(user, span_notice("你转移了[trans] unit\s 的溶液。"))
		update_appearance()
		target.update_appearance()
		return ITEM_INTERACT_SUCCESS

	if(!target.is_drawable(user, FALSE)) //No drawing from mobs here
		to_chat(user, span_warning("你无法直接从 [target] 移除试剂！"))
		return ITEM_INTERACT_BLOCKING

	if(!target.reagents.total_volume)
		to_chat(user, span_warning("[target] 是空的！"))
		return ITEM_INTERACT_BLOCKING

	var/trans = round(target.reagents.trans_to(src, amount_per_transfer_from_this, transferred_by = user), CHEMICAL_VOLUME_ROUNDING)
	if(trans)
		to_chat(user, span_notice("你向[src]中注入了[trans] unit\s 的溶液。"))

	update_appearance()
	target.update_appearance()
	return ITEM_INTERACT_SUCCESS

/obj/item/reagent_containers/dropper/update_overlays()
	. = ..()
	if(!reagents.total_volume)
		return
	var/mutable_appearance/filling = mutable_appearance('icons/obj/medical/reagent_fillings.dmi', "dropper")
	filling.color = mix_color_from_reagents(reagents.reagent_list)
	. += filling
