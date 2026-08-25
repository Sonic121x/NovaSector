#define GET_RECIPE(input_thing) LAZYACCESS(processor_inputs[/obj/machinery/processor], input_thing.type)

/obj/item/cutting_board
	name = "cutting board"
	desc = "Processing food before electricity was cool, because you can just do your regular cutting on the table next to this right?"
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
	. += span_notice(LANG("obj.7b700ac9ac55f1e1", null))
	. += span_notice(LANG("obj.48a3e387c72052ad", null))
	. += span_notice(LANG("obj.b48618d7aef3aac7", null))
	if(length(contents))
		. += span_notice(LANG("obj.130b7d3822325e9d", list(contents[1])))

/obj/item/cutting_board/Destroy()
	drop_everything_contained()
	return ..()

/obj/item/cutting_board/click_alt(mob/user)
	if(!length(contents))
		balloon_alert(user, LANG("obj.a0cf78a3d233a55c", null))
		return CLICK_ACTION_BLOCKING

	drop_everything_contained()
	balloon_alert(user, LANG("obj.875cc2b8bdb2e3a0", null))
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

/obj/item/cutting_board/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(user.combat_mode)
		return ..()

	if(tool.tool_behaviour == TOOL_KNIFE)
		if(!length(contents))
			balloon_alert(user, LANG("obj.7499becf944e839d", null))
			return ITEM_INTERACT_BLOCKING

		var/datum/food_processor_process/item_process_recipe = GET_RECIPE(contents[1])
		if(!item_process_recipe)
			log_admin("DEBUG: [src] (cutting board item) just tried to process [contents[1]] but wasn't able to get a recipe somehow, this should not be able to happen.")
			return ITEM_INTERACT_BLOCKING

		playsound(src, 'sound/effects/butcher.ogg', 50, TRUE)
		balloon_alert_to_viewers(LANG("obj.33079829a5a3116c", null))
		if(!do_after(user, 3 SECONDS, target = src))
			balloon_alert_to_viewers(LANG("obj.21e88fc0995288d5", null))
			return ITEM_INTERACT_BLOCKING

		process_food(item_process_recipe, contents[1])
		return ITEM_INTERACT_SUCCESS

	var/datum/food_processor_process/gotten_recipe = GET_RECIPE(tool)
	if(gotten_recipe)
		if(length(contents))
			balloon_alert(user, LANG("obj.eaa67f28d6a8b4cc", null))
			return ITEM_INTERACT_BLOCKING

		tool.forceMove(src)
		balloon_alert(user, LANG("obj.7cf423a549322ea5", list(tool)))
		update_appearance()
		return ITEM_INTERACT_SUCCESS

	if(IS_EDIBLE(tool)) //We may have failed but the user wants some feedback on why they can't put x food item on the board
		balloon_alert(user, LANG("obj.3c24e22ab3ca648d", list(tool)))
	return ..()

#undef GET_RECIPE
