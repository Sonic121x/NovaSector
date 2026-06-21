#define GET_RECIPE(input_thing) LAZYACCESS(processor_inputs[/obj/machinery/processor], input_thing.type)

/obj/item/cutting_board
	name = "砧板"
	desc = "在电力普及前处理食物的方式，因为你完全可以在旁边的桌子上进行常规切割，对吧？"
	icon = 'modular_nova/modules/primitive_cooking_additions/icons/cooking_structures.dmi'
	icon_state = "cutting_board"
	force = 5
	throwforce = 7 //Imagine someone just throws the entire fucking cutting board at you
	w_class = WEIGHT_CLASS_NORMAL
	pass_flags = PASSTABLE
	layer = BELOW_OBJ_LAYER //So newly spawned food appears on top of the board rather than under it
	resistance_flags = FLAMMABLE
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 5)
	///List containg list of possible inputs and resulting recipe items, taken from processor.dm and processor_recipes.dm
	var/static/list/processor_inputs

/obj/item/cutting_board/Initialize(mapload)
	. = ..()
	if(processor_inputs)
		return

	processor_inputs = list()
	for(var/datum/food_processor_process/recipe as anything in subtypesof(/datum/food_processor_process)) //this is how tg food processors do it just in case this is digusting
		if(!initial(recipe.input))
			continue

		recipe = new recipe
		var/list/typecache = list()
		var/list/bad_types

		for(var/bad_type in recipe.blacklist)
			LAZYADD(bad_types, typesof(bad_type))

		for(var/input_type in typesof(recipe.input) - bad_types)
			typecache[input_type] = recipe

		for(var/machine_type in typesof(recipe.required_machine))
			LAZYADD(processor_inputs[machine_type], typecache)

/obj/item/cutting_board/update_appearance()
	. = ..()
	cut_overlays()
	if(!length(contents))
		return
	var/image/overlayed_item = image(icon = contents[1].icon, icon_state = contents[1].icon_state, pixel_y = 2)
	add_overlay(overlayed_item)

/obj/item/cutting_board/examine(mob/user)
	. = ..()
	. += span_notice("你可以通过将食物放在这上面并用<b>刀</b>处理，来类似食品加工机那样加工食物。")
	. += span_notice("可以用<b>右键点击</b>来（解）固定它")
	. += span_notice("你可以用<b>Alt+点击</b>让它放下上面的物品")
	if(length(contents))
		. += span_notice("上面放着[contents[1]]。")

/obj/item/cutting_board/Destroy()
	drop_everything_contained()
	return ..()

/obj/item/cutting_board/click_alt(mob/user)
	if(!length(contents))
		balloon_alert(user, "砧板上没有东西")
		return CLICK_ACTION_BLOCKING

	drop_everything_contained()
	balloon_alert(user, "清空了砧板")
	return CLICK_ACTION_SUCCESS

///Drops all contents at the turf of the item
/obj/item/cutting_board/proc/drop_everything_contained()
	if(!length(contents))
		return

	for(var/obj/target_item as anything in contents)
		target_item.forceMove(get_turf(src))

/obj/item/cutting_board/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return

	if(!can_interact(user) || !user.can_perform_action(src))
		return

	set_anchored(!anchored)
	balloon_alert_to_viewers(anchored ? "secured" : "unsecured")
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

///Takes the given obj (processed thing) and gets its results from the recipe list, spawning the results and deleting the original obj
/obj/item/cutting_board/proc/process_food(datum/food_processor_process/recipe, obj/processed_thing)
	if(!recipe.output || !loc || QDELETED(src))
		return

	var/food_multiplier = recipe.food_multiplier
	for(var/i in 1 to food_multiplier)
		var/obj/new_food_item = new recipe.output(drop_location())
		new_food_item.pixel_x = rand(-6, 6)
		new_food_item.pixel_y = rand(-6, 6)

		if(!processed_thing.reagents) //backup in case we really fuck up
			continue

		processed_thing.reagents.trans_to(new_food_item, processed_thing.reagents.total_volume, multiplier = 1 / food_multiplier, copy_only = TRUE)

	qdel(processed_thing)
	update_appearance()

/obj/item/cutting_board/attackby(obj/item/attacking_item, mob/living/user, list/modifiers, list/attack_modifiers)
	if(user.combat_mode)
		return ..()

	if(attacking_item.tool_behaviour == TOOL_KNIFE)
		if(!length(contents))
			balloon_alert(user, "没有东西可处理")
			return

		var/datum/food_processor_process/item_process_recipe = GET_RECIPE(contents[1])
		if(!item_process_recipe)
			log_admin("DEBUG: [src] (cutting board item) just tried to process [contents[1]] but wasn't able to get a recipe somehow, this should not be able to happen.")
			return

		playsound(src, 'sound/effects/butcher.ogg', 50, TRUE)
		balloon_alert_to_viewers("cutting...")
		if(!do_after(user, 3 SECONDS, target = src))
			balloon_alert_to_viewers("stopped cutting")
			return

		process_food(item_process_recipe, contents[1])
		return

	var/datum/food_processor_process/gotten_recipe = GET_RECIPE(attacking_item)
	if(gotten_recipe)
		if(length(contents))
			balloon_alert(user, "砧板已满")
			return

		attacking_item.forceMove(src)
		balloon_alert(user, "将[attacking_item]放到了砧板上")
		update_appearance()
		return

	if(IS_EDIBLE(attacking_item)) //We may have failed but the user wants some feedback on why they can't put x food item on the board
		balloon_alert(user, "[attacking_item]无法被处理")
	return ..()

#undef GET_RECIPE
