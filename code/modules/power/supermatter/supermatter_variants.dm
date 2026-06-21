/// Normal SM with it's processing disabled.
/obj/machinery/power/supermatter_crystal/hugbox
	disable_damage = TRUE
	disable_gas =  TRUE
	disable_power_change = TRUE
	disable_process = SM_PROCESS_DISABLED

/// Normal SM designated as main engine.
/obj/machinery/power/supermatter_crystal/engine
	is_main_engine = TRUE

/// Shard SM.
/obj/machinery/power/supermatter_crystal/shard
	name = "超物质碎片"
	desc = "一块奇特的半透明且色彩斑斓的晶体，看起来像是曾经是某个更大结构的一部分。"
	base_icon_state = "sm_shard"
	icon_state = "sm_shard"
	anchored = FALSE
	absorption_ratio = 0.125
	explosion_power = 12
	layer = ABOVE_MOB_LAYER
	moveable = TRUE


/obj/machinery/power/supermatter_crystal/shard/Initialize(mapload)
	. = ..()

	register_context()


/obj/machinery/power/supermatter_crystal/shard/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()

	if(held_item?.tool_behaviour == TOOL_WRENCH)
		context[SCREENTIP_CONTEXT_LMB] = anchored ? "Unanchor" : "Anchor"
		return CONTEXTUAL_SCREENTIP_SET


/// Shard SM with it's processing disabled.
/obj/machinery/power/supermatter_crystal/shard/hugbox
	name = "锚定的超物质碎片"
	disable_damage = TRUE
	disable_gas =  TRUE
	disable_power_change = TRUE
	disable_process = SM_PROCESS_DISABLED
	moveable = FALSE
	anchored = TRUE

/// Shard SM designated as the main engine.
/obj/machinery/power/supermatter_crystal/shard/engine
	name = "锚定的超物质碎片"
	is_main_engine = TRUE
	anchored = TRUE
	moveable = FALSE

/// Normal sm but small (sm sword recipe element) (wiz only) and adamantine pedestal for it
/obj/machinery/power/supermatter_crystal/small
	name = "异常微小的超物质晶体"
	desc = "一个异常半透明且泛着虹彩的晶体，坐落于精金基座上。它看起来似乎应该再大一点..."
	base_icon_state = "sm_small"
	icon_state = "sm_small"
	moveable = TRUE
	anchored = FALSE
	custom_materials = list(/datum/material/adamantine = SHEET_MATERIAL_AMOUNT * 20, /datum/material/iron = SHEET_MATERIAL_AMOUNT)

/obj/machinery/power/supermatter_crystal/small/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/gps, "Adamantium Signal")
	priority_announce("Anomalous crystal detected onboard. Location is marked on every GPS device.", "Nanotrasen Anomaly Department Announcement")

/obj/item/adamantine_pedestal
	name = "精金基座"
	desc = "一个精金基座。它看起来上面应该放着某种小巧但质量巨大的东西。"
	icon = 'icons/obj/machines/engine/supermatter.dmi'
	icon_state = "pedestal"
	w_class = WEIGHT_CLASS_HUGE
	throw_speed = 1
	throw_range = 1
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	custom_materials = list(/datum/material/adamantine = SHEET_MATERIAL_AMOUNT * 20)
