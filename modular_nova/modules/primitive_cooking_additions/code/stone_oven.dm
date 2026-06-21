#define OVEN_TRAY_Y_OFFSET -12

/obj/machinery/oven/primitive
	name = "石制烤箱"
	desc = "抱歉伙计，所有石头都用光了预算，不然本来可以放加菲猫漫画笑话的。"
	icon = 'modular_nova/modules/primitive_cooking_additions/icons/stone_kitchen_machines.dmi'
	circuit = null
	use_power = FALSE
	custom_materials = list(/datum/material/stone = SHEET_MATERIAL_AMOUNT * 5)

	/// A list of the different oven trays we can spawn with
	var/static/list/random_oven_tray_types = list(
		/obj/item/plate/oven_tray/material/fake_copper,
		/obj/item/plate/oven_tray/material/fake_brass,
		/obj/item/plate/oven_tray/material/fake_tin,
	)

/obj/machinery/oven/primitive/clay
	name = "黏土烤箱"
	custom_materials = list(/datum/material/clay = SHEET_MATERIAL_AMOUNT * 10)

/obj/machinery/oven/primitive/Initialize(mapload)
	. = ..()

	AddElement(/datum/element/tool_blocker, TOOL_SCREWDRIVER)
	AddElement(/datum/element/tool_blocker, TOOL_CROWBAR)

	if(!mapload)
		return

	if(used_tray) // We have to get rid of normal generic tray that normal ovens spawn with
		QDEL_NULL(used_tray)

	var/new_tray_type_to_use = pick(random_oven_tray_types)
	add_tray_to_oven(new new_tray_type_to_use(src))

/obj/machinery/oven/primitive/examine(mob/user)
	. = ..()

	. += span_notice("可以用<b>撬棍</b>将其拆开。")

/obj/machinery/oven/primitive/add_tray_to_oven(obj/item/plate/oven_tray, mob/baker)
	used_tray = oven_tray

	if(!open)
		oven_tray.vis_flags |= VIS_HIDE
	vis_contents += oven_tray
	oven_tray.vis_flags |= VIS_INHERIT_PLANE
	oven_tray.pixel_y = OVEN_TRAY_Y_OFFSET

	RegisterSignal(used_tray, COMSIG_MOVABLE_MOVED, PROC_REF(on_tray_moved))
	update_baking_audio()
	update_appearance()

/obj/machinery/oven/primitive/set_smoke_state(new_state)
	. = ..()

	if(particles)
		particles.position = list(0, 10, 0)

/obj/machinery/oven/primitive/crowbar_act(mob/living/user, obj/item/tool)
	user.balloon_alert_to_viewers("disassembling...")
	if(!tool.use_tool(src, user, 2 SECONDS, volume = 100))
		return
	deconstruct(TRUE)
	return ITEM_INTERACT_SUCCESS

/obj/machinery/oven/primitive/on_deconstruction(disassembled)
	new /obj/item/stack/sheet/mineral/stone(drop_location(), 5)

#undef OVEN_TRAY_Y_OFFSET
