/obj/machinery/griddle/stone
	name = "石制煎板"
	desc = "你大概能在这上面煎个蛋……这块石板看起来非常不卫生。"
	icon = 'modular_nova/modules/primitive_cooking_additions/icons/stone_kitchen_machines.dmi'
	icon_state = "griddle1_off"
	density = TRUE
	pass_flags_self = PASSMACHINE | PASSTABLE| LETPASSTHROW // It's roughly the height of a table.
	layer = BELOW_OBJ_LAYER
	use_power = FALSE
	circuit = null
	resistance_flags = FIRE_PROOF
	processing_flags = START_PROCESSING_MANUALLY
	variant = 1
	custom_materials = list(/datum/material/stone = SHEET_MATERIAL_AMOUNT * 5)

/obj/machinery/griddle/stone/Initialize(mapload)
	. = ..()
	variant = 1
	update_appearance()

/obj/machinery/griddle/stone/examine(mob/user)
	. = ..()

	. += span_notice("可以用<b>撬棍</b>将其拆解。")

/obj/machinery/griddle/stone/crowbar_act(mob/living/user, obj/item/tool)
	user.balloon_alert_to_viewers("disassembling...")
	if(!tool.use_tool(src, user, 2 SECONDS, volume = 100))
		return
	new /obj/item/stack/sheet/mineral/stone(drop_location(), 5)
	deconstruct(TRUE)
	return ITEM_INTERACT_SUCCESS
