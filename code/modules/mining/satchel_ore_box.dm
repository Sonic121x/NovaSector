// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md

/**********************Ore box**************************/

/obj/structure/ore_box
	icon = 'icons/obj/mining.dmi'
	icon_state = "orebox"
	name = "ore box"
	desc = "A heavy wooden box, which can be filled with a lot of ores or boulders"
	density = TRUE
	pressure_resistance = 5 * ONE_ATMOSPHERE
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 4)

/obj/structure/ore_box/Initialize(mapload)
	. = ..()
	register_context()

///Dumps all contents of this ore box on the turf
/obj/structure/ore_box/proc/dump_box_contents()
	var/drop = drop_location()
	for(var/obj/item/weapon in src)
		weapon.forceMove(drop)

/obj/structure/ore_box/atom_deconstruct(disassembled = TRUE)
	new /obj/item/stack/sheet/mineral/wood(loc, 4)

	dump_box_contents()

/obj/structure/ore_box/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = NONE
	if(isnull(held_item))
		return

	if(held_item.tool_behaviour == TOOL_CROWBAR)
		context[SCREENTIP_CONTEXT_LMB] = "Deconstruct"
		return CONTEXTUAL_SCREENTIP_SET
	else if(istype(held_item, /obj/item/stack/ore) || istype(held_item, /obj/item/boulder))
		context[SCREENTIP_CONTEXT_LMB] = "Insert Item"
		return CONTEXTUAL_SCREENTIP_SET
	else if(held_item.atom_storage)
		context[SCREENTIP_CONTEXT_LMB] = "Transfer Contents"
		return CONTEXTUAL_SCREENTIP_SET


/obj/structure/ore_box/examine(mob/living/user)
	. = ..()
	if(in_range(src, user) || isobserver(user))
		. += span_notice(LANG("obj.069a5701e7253e5f", list(EXAMINE_HINT("pried"))))
		ui_interact(user)

/obj/structure/ore_box/crowbar_act(mob/living/user, obj/item/I)
	. = ITEM_INTERACT_BLOCKING
	if(I.use_tool(src, user, 50, volume = 50))
		user.visible_message(span_notice(LANG("obj.bb43d2f3b7e7a709", list(user, src))),
			span_notice(LANG("obj.309c60905890fde0", list(src))),
			span_hear(LANG("obj.5fcb16ad6c46c22a", null)))
		deconstruct(TRUE)
		return ITEM_INTERACT_SUCCESS

/obj/structure/ore_box/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/stack/ore) || istype(tool, /obj/item/boulder))
		user.transferItemToLoc(tool, src)
		return ITEM_INTERACT_SUCCESS

	if(tool.atom_storage)
		tool.atom_storage.remove_type(/obj/item/stack/ore, src, INFINITY, TRUE, FALSE, user, null)
		to_chat(user, span_notice(LANG("obj.e933838f5b28d3c6", list(tool, src))))
		return ITEM_INTERACT_SUCCESS

	return NONE

/obj/structure/ore_box/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	. = ..()
	if(istype(arrived, /obj/item/boulder) && ismecha(loc)) //Boulders being put into a mech's orebox get processed
		var/obj/item/boulder/to_process = arrived
		to_process.convert_to_ore(src)
		qdel(to_process)

/obj/structure/ore_box/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "OreBox", name)
		ui.open()

/obj/structure/ore_box/ui_data()
	var/list/materials = list()
	var/name
	var/amount
	for(var/obj/item/stack/ore/potental_ore as anything in contents)
		if(istype(potental_ore, /obj/item/stack/ore))
			name = potental_ore.name
			amount = potental_ore.amount
		else
			name = "Boulders"
			amount = 1

		var/item_found = FALSE
		for(var/list/item as anything in materials)
			if(item["name"] == name)
				item_found = TRUE
				item["amount"] += amount
				break
		if(!item_found)
			materials += list(list("name" = name, "amount" = amount))

	return list("materials" = materials)

/obj/structure/ore_box/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(action == "removeall")
		dump_box_contents()
		return TRUE

/// Special override for notify_contents = FALSE.
/obj/structure/ore_box/on_changed_z_level(turf/old_turf, turf/new_turf, same_z_layer, notify_contents = FALSE)
	return ..()
