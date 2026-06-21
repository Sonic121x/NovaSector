// Wooden shelves that force items placed on them to be visually placed them

/obj/structure/rack/wooden
	name = "架子"
	icon_state = "shelf_wood"
	icon = 'modular_nova/modules/primitive_structures/icons/storage.dmi'
	resistance_flags = FLAMMABLE
	interaction_flags_mouse_drop = NEED_DEXTERITY
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 2)


/obj/structure/rack/wooden/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/tool_blocker, TOOL_WRENCH, TOOL_ACT_SECONDARY)

/obj/structure/rack/wooden/mouse_drop_receive(atom/dropping, mob/user, params)
	if ((!isitem(dropping) || user.get_active_held_item() != dropping))
		return

	if(!user.dropItemToGround(dropping))
		return

	if(dropping.loc != src.loc)
		step(dropping, get_dir(dropping, src))

	var/list/modifiers = params2list(params)
	if(!LAZYACCESS(modifiers, ICON_X) || !LAZYACCESS(modifiers, ICON_Y))
		return

	dropping.pixel_x = clamp(text2num(LAZYACCESS(modifiers, ICON_X)) - 16, -(ICON_SIZE_X / 3), ICON_SIZE_X / 3)
	dropping.pixel_y = text2num(LAZYACCESS(modifiers, ICON_Y)) > 16 ? 10 : -4

/obj/structure/rack/wooden/crowbar_act(mob/living/user, obj/item/tool)
	user.balloon_alert_to_viewers("disassembling...")
	if(!tool.use_tool(src, user, 2 SECONDS, volume = 100))
		return

	deconstruct(TRUE)
	return ITEM_INTERACT_SUCCESS

/obj/structure/rack/wooden/atom_deconstruct(disassembled = TRUE)
	new /obj/item/stack/sheet/mineral/wood(drop_location(), 2)

// Barrel but it works like a crate

/obj/structure/closet/crate/wooden/storage_barrel
	name = "储物桶"
	desc = "这个桶不能装液体，不过它可以把东西装在里面！"
	icon_state = "barrel"
	base_icon_state = "barrel"
	icon = 'modular_nova/modules/primitive_structures/icons/storage.dmi'
	resistance_flags = FLAMMABLE
	material_drop = /obj/item/stack/sheet/mineral/wood
	material_drop_amount = 4
	cutting_tool = /obj/item/crowbar
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 4)

/obj/machinery/smartfridge/wooden
	name = "调试用木质智能冰箱"
	desc = "你不应该看到这个！"
	icon = 'modular_nova/modules/primitive_structures/icons/storage.dmi'
	resistance_flags = FLAMMABLE
	base_build_path = /obj/machinery/smartfridge/wooden
	icon_state = "producebin"
	base_icon_state = "producebin"
	use_power = NO_POWER_USE
	light_power = 0
	idle_power_usage = 0
	circuit = null
	has_emissive = FALSE
	integrity_failure = 0
	can_atmos_pass = ATMOS_PASS_YES
	visible_contents = TRUE
	can_be_welded_down = FALSE
	has_emissive = FALSE
	vend_sound = null

/obj/machinery/smartfridge/wooden/Initialize(mapload)
	. = ..()
	if(type == /obj/machinery/smartfridge/wooden) // don't even let these prototypes exist
		return INITIALIZE_HINT_QDEL

	AddElement(/datum/element/tool_blocker, TOOL_SCREWDRIVER)
	AddElement(/datum/element/tool_blocker, TOOL_CROWBAR)

/obj/machinery/smartfridge/wooden/visible_items()
	return contents.len

/obj/machinery/smartfridge/wooden/crowbar_act(mob/living/user, obj/item/tool)
	user.balloon_alert_to_viewers("disassembling...")
	if(!tool.use_tool(src, user, 2 SECONDS, volume = 100))
		return

	deconstruct(TRUE)
	return ITEM_INTERACT_SUCCESS

/obj/machinery/smartfridge/wooden/on_deconstruction(disassembled)
	new /obj/item/stack/sheet/mineral/wood(drop_location(), 10)

/obj/machinery/smartfridge/wooden/structure_examine()
	. = span_info("整个架子可以被[EXAMINE_HINT("pried")]开。")

/obj/machinery/smartfridge/wooden/produce_bin
	name = "农产品箱"
	desc = "一个木制篮子，用于存放植物产品并试图保护它们免受害虫侵害。"
	icon_state = "producebin"
	base_icon_state = "producebin"
	contents_overlay_icon = "produce"
	base_build_path = /obj/machinery/smartfridge/wooden/produce_bin
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 10)

/obj/machinery/smartfridge/wooden/produce_bin/accept_check(obj/item/item_to_check)
	var/static/list/accepted_items = list(
		/obj/item/food/grown,
		/obj/item/grown,
		/obj/item/graft,
	)

	return is_type_in_list(item_to_check, accepted_items)

/obj/machinery/smartfridge/wooden/seed_shelf
	name = "种子架"
	desc = "一个木制架子，用于存放种子，防止它们过早发芽。"
	icon_state = "seedshelf"
	base_icon_state = "seedshelf"
	contents_overlay_icon = "seed"
	base_build_path = /obj/machinery/smartfridge/wooden/seed_shelf
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 10)

/obj/machinery/smartfridge/wooden/seed_shelf/accept_check(obj/item/item_to_check)
	return istype(item_to_check, /obj/item/seeds)

/obj/machinery/smartfridge/wooden/ration_shelf
	name = "配给架"
	desc = "一个木制架子，用于储存食物……最好是保存好的。"
	icon_state = "rationshelf"
	base_icon_state = "rationshelf"
	contents_overlay_icon = "ration"
	base_build_path = /obj/machinery/smartfridge/wooden/ration_shelf
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 10)

/obj/machinery/smartfridge/wooden/ration_shelf/accept_check(obj/item/item_to_check)
	return (IS_EDIBLE(item_to_check) || (istype(item_to_check,/obj/item/reagent_containers/cup/bowl) && length(item_to_check.reagents?.reagent_list)))

/obj/machinery/smartfridge/wooden/produce_display
	name = "农产品展示台"
	desc = "一个带遮阳篷的木桌，用于展示农产品。"
	icon_state = "producedisplay"
	base_icon_state = "producedisplay"
	contents_overlay_icon = "nonfood"
	base_build_path = /obj/machinery/smartfridge/wooden/produce_display
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 10)

/obj/machinery/smartfridge/wooden/produce_display/accept_check(obj/item/item_to_check)
	var/static/list/accepted_items = list(
		/obj/item/grown,
		/obj/item/bouquet,
		/obj/item/clothing/head/costume/garland,
		/obj/item/stack/sheet/cloth,
		/obj/item/stack/sheet/durathread,
		/obj/item/stack/sheet/leather,
		/obj/item/stack/sheet/mineral/wood,
		/obj/item/stack/sheet/mineral/bamboo
	)
	var/fancy_food = istype(item_to_check, /obj/item/food/grown) && item_to_check.slot_flags != NONE // mostly things like flowers
	return fancy_food || is_type_in_list(item_to_check, accepted_items)
