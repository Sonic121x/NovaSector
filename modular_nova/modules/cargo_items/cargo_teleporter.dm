GLOBAL_LIST_EMPTY(cargo_marks)
#define MAX_CARGO_TELEPORTER_ITEMS 20 // same as the push broom.
#define CARGO_TELEPORTER_COOLDOWN 8 SECONDS

/obj/item/cargo_teleporter
	name = "货运传送器"
	desc = "一种可以放置一定数量标记的物品，允许将一格内的物品传送到已设置的标记处。"
	icon = 'modular_nova/modules/cargo_items/icons/cargo_teleporter.dmi'
	icon_state = "cargo_tele"
	///the list of markers spawned by this item
	var/list/marker_children = list()
	///which marker it is currently on
	var/obj/effect/decal/cleanable/cargo_mark/selected_mark

	COOLDOWN_DECLARE(use_cooldown)

/obj/item/cargo_teleporter/examine(mob/user)
	. = ..()
	. += span_notice("攻击自身以放置标记！")
	. += span_notice("ALT-点击以打开移除标记或设置标记的选项！")

/obj/item/cargo_teleporter/Destroy()
	if(length(marker_children))
		for(var/obj/effect/decal/cleanable/cargo_mark/destroy_children in marker_children)
			destroy_children.parent_item = null
			qdel(destroy_children)

	return ..()

/obj/item/cargo_teleporter/attack_self(mob/user, modifiers)
	if(length(marker_children) >= 3)
		to_chat(user, span_warning("你只能从[src]生成三个标记！"))
		return

	to_chat(user, span_notice("你在脚下放置了一个货运标记。"))
	var/obj/effect/decal/cleanable/cargo_mark/spawned_marker = new /obj/effect/decal/cleanable/cargo_mark(get_turf(src))
	playsound(src, 'sound/machines/click.ogg', 50)
	spawned_marker.parent_item = src
	marker_children += spawned_marker

/obj/item/cargo_teleporter/click_alt(mob/user)
	var/option_selection = tgui_input_list(user, "你想做什么？", "货物传送器选项", list("Remove all markers", "Set default marker"))
	if(isnull(option_selection))
		return CLICK_ACTION_BLOCKING

	if(option_selection == "Remove all markers")
		if(length(marker_children))
			for(var/obj/effect/decal/cleanable/cargo_mark/destroy_children in marker_children)
				qdel(destroy_children)

		return CLICK_ACTION_SUCCESS

	if(option_selection == "Set default marker")
		var/cargo_mark_selection = tgui_input_list(user, "选择将物品传送到哪个货物标记点？", "货物标记点选择", GLOB.cargo_marks)
		if(isnull(cargo_mark_selection))
			return CLICK_ACTION_BLOCKING

		selected_mark = cargo_mark_selection
		to_chat(user, span_notice("你已选择 [selected_mark] 作为默认标记。ALT-点击以打开选项来更改选择。"))
		return CLICK_ACTION_SUCCESS

/obj/item/cargo_teleporter/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!COOLDOWN_FINISHED(src, use_cooldown))
		to_chat(user, span_warning("[src] 仍在冷却中！"))
		return ITEM_INTERACT_BLOCKING

	if(isnull(selected_mark))
		var/choice = tgui_input_list(user, "选择将物品传送到哪个货物标记点？", "货物标记点选择", GLOB.cargo_marks)
		if(isnull(choice))
			return ITEM_INTERACT_BLOCKING

		selected_mark = choice
		to_chat(user, span_notice("你已选择 [selected_mark] 作为默认标记。ALT-点击以打开选项来更改选择。"))

	if(get_dist(user, interacting_with) > 1)
		return ITEM_INTERACT_BLOCKING

	var/turf/moving_turf = get_turf(selected_mark)
	var/turf/target_turf = get_turf(interacting_with)
	var/teleported = 0
	for(var/check_content in target_turf.contents)
		if (teleported >= MAX_CARGO_TELEPORTER_ITEMS)
			break

		if(isobserver(check_content))
			continue

		if(!ismovable(check_content))
			continue

		var/atom/movable/movable_content = check_content
		if(isliving(movable_content))
			continue

		if(length(movable_content.get_all_contents_type(/mob/living)))
			continue

		if(movable_content.anchored)
			continue

		do_teleport(movable_content, moving_turf, no_effects = TRUE)
		teleported++

	playsound(target_turf, 'sound/effects/magic/Disable_Tech.ogg', 50)
	playsound(moving_turf, 'sound/effects/magic/Disable_Tech.ogg', 50)
	do_sparks(2, FALSE, target_turf)
	do_sparks(2, FALSE, moving_turf)
	new /obj/effect/decal/cleanable/ash(target_turf)
	COOLDOWN_START(src, use_cooldown, CARGO_TELEPORTER_COOLDOWN)
	return ITEM_INTERACT_SUCCESS

/datum/design/cargo_teleporter
	name = "货运传送器"
	desc = "一个可以设置标记并将物品传送到这些标记处的绝妙物品。"
	id = "cargotele"
	build_type = PROTOLATHE | AWAY_LATHE
	build_path = /obj/item/cargo_teleporter
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/plastic = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/uranium = HALF_SHEET_MATERIAL_AMOUNT,
	)
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_CARGO,
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO

/obj/effect/decal/cleanable/cargo_mark
	name = "货运标记"
	desc = "货运传送器留下的标记，允许进行定向传送。可以用货运传送器移除。"
	icon = 'modular_nova/modules/cargo_items/icons/cargo_teleporter.dmi'
	icon_state = "marker"
	///the reference to the item that spawned the cargo mark
	var/obj/item/cargo_teleporter/parent_item

	light_range = 3
	light_color = COLOR_VIVID_YELLOW

/obj/effect/decal/cleanable/cargo_mark/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers)
	if(istype(attacking_item, /obj/item/cargo_teleporter))
		to_chat(user, span_notice("你使用 [attacking_item] 移除了 [src]。"))
		playsound(src, 'sound/machines/click.ogg', 50)
		qdel(src)
		return

	return ..()

/obj/effect/decal/cleanable/cargo_mark/Destroy()
	if(parent_item)
		parent_item.marker_children -= src

	GLOB.cargo_marks -= src
	return ..()

/obj/effect/decal/cleanable/cargo_mark/Initialize(mapload, list/datum/disease/diseases)
	. = ..()
	var/area/src_area = get_area(src)
	name = "[src_area.name] ([rand(100000,999999)])"
	GLOB.cargo_marks += src

#undef MAX_CARGO_TELEPORTER_ITEMS
#undef CARGO_TELEPORTER_COOLDOWN
