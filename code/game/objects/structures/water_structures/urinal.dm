/obj/structure/urinal
	name = "小便池"
	desc = "HU-452，一款实验性小便池。配有实验性小便池芳香块。"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "urinal"
	density = FALSE
	anchored = TRUE
	/// Can you currently put an item inside
	var/exposed = FALSE
	/// What's in the urinal
	var/obj/item/hidden_item

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/urinal, 32)

/obj/structure/urinal/Initialize(mapload)
	. = ..()
	if(mapload)
		hidden_item = new /obj/item/food/urinalcake(src)
		find_and_mount_on_atom()

/obj/structure/urinal/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == hidden_item)
		hidden_item = null

/obj/structure/urinal/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return

	if(user.pulling && isliving(user.pulling))
		var/mob/living/grabbed_mob = user.pulling
		if(user.grab_state >= GRAB_AGGRESSIVE)
			if(grabbed_mob.loc != get_turf(src))
				to_chat(user, span_notice("[grabbed_mob.name]需要在[src]上。"))
				return
			user.changeNext_move(CLICK_CD_MELEE)
			user.visible_message(span_danger("[user]将[grabbed_mob]猛撞进[src]！"), span_danger("你将[grabbed_mob]猛撞进[src]！"))
			grabbed_mob.emote("scream")
			grabbed_mob.adjust_brute_loss(8)
		else
			to_chat(user, span_warning("你需要抓得更紧些！"))
		return

	if(exposed)
		if(hidden_item)
			to_chat(user, span_notice("你从排水槽里捞出了[hidden_item]。"))
			user.put_in_hands(hidden_item)
		else
			to_chat(user, span_warning("排水槽里什么都没有！"))
		return
	return ..()

/obj/structure/urinal/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers)
	if(exposed)
		if(hidden_item)
			to_chat(user, span_warning("排水槽里已经有东西了！"))
			return
		if(attacking_item.w_class > WEIGHT_CLASS_TINY)
			to_chat(user, span_warning("[attacking_item]太大了，放不进排水槽。"))
			return
		if(!user.transferItemToLoc(attacking_item, src))
			to_chat(user, span_warning("[attacking_item]粘在你手上了，你无法把它放进排水槽！"))
			return
		hidden_item = attacking_item
		to_chat(user, span_notice("你将[attacking_item]放入了排水槽中。"))
		return
	return ..()

/obj/structure/urinal/screwdriver_act(mob/living/user, obj/item/I)
	if(..())
		return TRUE
	to_chat(user, span_notice("You start to [exposed ? "screw the cap back into place" : "unscrew the cap to the drain protector"]..."))
	playsound(loc, 'sound/effects/stonedoor_openclose.ogg', 50, TRUE)
	if(I.use_tool(src, user, 20))
		user.visible_message(span_notice("[user] [exposed ? "screws the cap back into place" : "unscrew the cap to the drain protector"]!"),
			span_notice("You [exposed ? "screw the cap back into place" : "unscrew the cap on the drain"]!"),
			span_hear("你听到了金属和挤压的声音。"))
		exposed = !exposed
	return TRUE

/obj/structure/urinal/wrench_act_secondary(mob/living/user, obj/item/tool)
	tool.play_tool_sound(user)
	deconstruct(TRUE)
	balloon_alert(user, "移除了小便池")
	return ITEM_INTERACT_SUCCESS

/obj/structure/urinal/atom_deconstruct(disassembled = TRUE)
	new /obj/item/wallframe/urinal(loc)
	hidden_item?.forceMove(drop_location())

/obj/item/wallframe/urinal
	name = "小便池框架"
	desc = "一个未安装的小便池。将其固定在墙上即可使用。"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "urinal"
	result_path = /obj/structure/urinal
	pixel_shift = 32

/obj/item/food/urinalcake
	name = "小便池芳香块"
	desc = "高贵的小便池芳香块，保护着空间站的管道免受空间站尿液的侵蚀。请勿食用。"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "urinalcake"
	w_class = WEIGHT_CLASS_TINY
	food_reagents = list(
		/datum/reagent/chlorine = 3,
		/datum/reagent/ammonia = 1,
	)
	foodtypes = TOXIC | GROSS
	preserved_food = TRUE

/obj/item/food/urinalcake/attack_self(mob/living/user)
	user.visible_message(span_notice("[user]捏扁了[src]！"), span_notice("你捏扁了[src]。"), "<i>你听到一声挤压声。</i>")
	icon_state = "urinalcake_squish"
	addtimer(VARSET_CALLBACK(src, icon_state, "urinalcake"), 0.8 SECONDS)
