/obj/item/conveyor_sorter
	name = "传送带分拣器列表器"
	desc = "一种工具，不仅用于创建传送带分拣器，还能为传送带分拣器提供列表。"
	icon = 'modular_nova/modules/cargo_items/icons/conveyor_sorter.dmi'
	icon_state = "lister"
	///the list of conveyor sorters spawned by
	var/list/spawned_sorters = list()
	///the list of things that are currently within the sorting list
	var/list/current_sort = list()
	///This controls the maximum amount of sorters that can be spawned by one lister item.
	var/max_sorters = 4
	///This controls the maximum amount of items that can be added to the sorting list.
	var/max_items = 5
	/// This is used for the improved sorter, so that it can use the improved sorter type instead of the normal sorter type.
	var/conveyor_type = /obj/effect/decal/conveyor_sorter

/obj/item/conveyor_sorter/Destroy()
	for(var/deleting_sorters in spawned_sorters)
		qdel(deleting_sorters)
	return ..()

/obj/item/conveyor_sorter/examine(mob/user)
	. = ..()
	. += span_notice("用它来放置一个传送带分拣器，最多可放置 <b>[max_sorters]</b> 个。")
	. += span_notice("此分拣器最多可分拣 <b>[max_items]</b> 个物品。")
	. += span_notice("使用 Alt-点击来重置分拣列表。")
	. += span_notice("攻击物品以尝试将其添加到分拣列表中。")

/obj/item/conveyor_sorter/attack_self(mob/user, modifiers)
	if(length(spawned_sorters) >= max_sorters)
		to_chat(user, span_warning("你最多只能生成 [max_sorters] 个传送带分拣器！"))
		return
	var/obj/effect/decal/conveyor_sorter/new_cs = new conveyor_type(get_turf(src))
	new_cs.parent_item = src
	new_cs.sorting_list = current_sort
	spawned_sorters += new_cs

/obj/item/conveyor_sorter/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!ismovable(interacting_with))
		return NONE
	if(istype(interacting_with, /obj/effect/decal/conveyor_sorter))
		return NONE
	if(is_type_in_list(interacting_with, current_sort))
		to_chat(user, span_warning("[interacting_with] 已在 [src] 的分拣列表中！"))
		return ITEM_INTERACT_BLOCKING
	if(length(current_sort) >= max_items)
		to_chat(user, span_warning("[src] 的分拣列表中已有 [max_items] 个物品！"))
		return ITEM_INTERACT_BLOCKING
	current_sort += interacting_with.type
	to_chat(user, span_notice("[interacting_with] 已被添加到 [src] 的分拣列表中。"))
	return ITEM_INTERACT_SUCCESS

/obj/item/conveyor_sorter/click_alt(mob/user)
	visible_message("[src] 发出哔哔声，正在重置其分拣列表！")
	playsound(src, 'sound/machines/ping.ogg', 30, TRUE)
	current_sort = list()
	return CLICK_ACTION_SUCCESS

/obj/effect/decal/conveyor_sorter
	name = "传送带分拣器"
	desc = "一个根据物品类型进行分拣的标记。"
	icon = 'modular_nova/modules/cargo_items/icons/conveyor_sorter.dmi'
	icon_state = "sorter"
	layer = OBJ_LAYER
	plane = GAME_PLANE
	///the list of items that will be sorted to the sorted direction
	var/list/sorting_list = list()
	//the direction that the items in the sorting list will be moved to
	dir = NORTH
	///the parent conveyor sorter lister item, used for deletion
	var/obj/item/conveyor_sorter/parent_item
	var/list/directions =  list("North", "East", "South", "West") //This is used for the tgui input list, so that the user can choose which direction to sort to.
	/// To prevent spam
	COOLDOWN_DECLARE(use_cooldown)

	light_range = 3
	light_color = COLOR_RED_LIGHT

/obj/effect/decal/conveyor_sorter/Initialize(mapload)
	. = ..()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered),
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/effect/decal/conveyor_sorter/Destroy()
	if(parent_item)
		parent_item.spawned_sorters -= src
		parent_item = null
	return ..()

/obj/effect/decal/conveyor_sorter/examine(mob/user)
	. = ..()
	. += span_notice("使用传送带分拣器列表器攻击以设置分拣列表。")
	. += span_notice("用空手拍击以更改分拣方向。")
	. += span_notice("Alt-点击以重置分拣列表。")
	. += span_notice("Ctrl-点击以移除。")

/obj/effect/decal/conveyor_sorter/attack_hand(mob/living/user, list/modifiers)
	var/user_choice = tgui_input_list(user, "选择要分拣到哪个方向！", "方向选择", directions) // this would be cooler as a radial
	if(!user_choice)
		return ..()

	var/dir = text2dir(user_choice)
	if(!dir)
		return ..()

	setDir(dir)

	visible_message("[src] 发出哔哔声，正在更新其分拣方向！")
	playsound(src, 'sound/machines/ping.ogg', 30, TRUE)

/obj/effect/decal/conveyor_sorter/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers)
	if(istype(attacking_item, /obj/item/conveyor_sorter))
		var/obj/item/conveyor_sorter/cs_item = attacking_item
		sorting_list = cs_item.current_sort
		visible_message("[src] 发出哔哔声，正在更新其分拣列表！")
		playsound(src, 'sound/machines/ping.ogg', 30, TRUE)
		return
	else
		return ..()

/obj/effect/decal/conveyor_sorter/click_alt(mob/user)
	visible_message("[src] 发出哔哔声，正在重置其分拣列表！")
	playsound(src, 'sound/machines/ping.ogg', 30, TRUE)
	sorting_list = list()
	return CLICK_ACTION_SUCCESS

/obj/effect/decal/conveyor_sorter/click_ctrl(mob/user)
	visible_message("[src] 开始剧烈地哔哔作响！")
	playsound(src, 'sound/machines/ping.ogg', 30, TRUE)
	qdel(src)
	return CLICK_ACTION_SUCCESS

/obj/effect/decal/conveyor_sorter/proc/on_entered(datum/source, atom/movable/entering_atom)
	SIGNAL_HANDLER
	if(is_type_in_list(entering_atom, sorting_list) && !entering_atom.anchored && COOLDOWN_FINISHED(src, use_cooldown))
		COOLDOWN_START(src, use_cooldown, 1 SECONDS)
		entering_atom.Move(get_step(src, dir))

/datum/design/conveyor_sorter
	name = "传送带分拣器"
	desc = "一个可以设置标记并强制将物品推向某个方向的绝妙物品。"
	id = "conveysorter"
	build_type = PROTOLATHE | AWAY_LATHE
	build_path = /obj/item/conveyor_sorter
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/plastic = HALF_SHEET_MATERIAL_AMOUNT,
	)
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_CARGO,
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO

/obj/item/conveyor_sorter/improved
	name = "改进型传送带分拣器列表器"
	desc = "一种不仅用于创建传送带分拣器，还能为传送带分拣器提供列表的工具。"
	icon_state = "lister_improved"
	max_sorters = 8
	max_items = 10
	conveyor_type = /obj/effect/decal/conveyor_sorter/improved

/obj/effect/decal/conveyor_sorter/improved
	name = "改进型传送带分拣器"
	desc = "一个根据物品类型进行分拣的标记。这个还能按斜向分拣！"
	icon = 'modular_nova/modules/cargo_items/icons/conveyor_sorter.dmi'
	icon_state = "sorter_improved"
	light_range = 3
	light_color = COLOR_BLUE_LIGHT
	directions = list("North", "East", "South", "West", "NorthEast", "NorthWest", "SouthEast", "SouthWest")

/datum/design/conveyor_sorter/improved
	name = "改进型传送带分拣器"
	desc = "一个可以设置标记并强制将物品推向某个方向的绝妙物品。拥有更大的容量以分拣更多物品！"
	id = "conveyor_sorter_improved"
	build_path = /obj/item/conveyor_sorter/improved
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/plastic = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/gold = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/bluespace = HALF_SHEET_MATERIAL_AMOUNT,
	)

/datum/techweb_node/conveyor_sorter/improved
	id = TECHWEB_NODE_CONVEYOR_SORTER_IMPROVED
	display_name = "Improved Conveyor Sorter"
	description = "传送带分拣器的改进版本，这个版本允许对分拣进行更多控制。"
	prereq_ids = list(TECHWEB_NODE_MISC_CARGO)
	design_ids = list(
		"conveyor_sorter_improved",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
