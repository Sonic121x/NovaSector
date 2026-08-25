// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/item/pipe_painter
	name = "pipe painter"
	desc = "Used for coloring pipes, unsurprisingly."
	icon = 'icons/obj/service/bureaucracy.dmi'
	icon_state = "labeler1"
	inhand_icon_state = null
	item_flags = NOBLUDGEON
	var/paint_color = "grey"

	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2.5, /datum/material/glass = SHEET_MATERIAL_AMOUNT)

/obj/item/pipe_painter/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(istype(interacting_with, /obj/machinery/atmospherics))
		var/obj/machinery/atmospherics/target_pipe = interacting_with
		target_pipe.paint(GLOB.pipe_paint_colors[paint_color])
		playsound(src, 'sound/machines/click.ogg', 50, TRUE)
		balloon_alert(user, LANG("obj.4da583d630a718fb", list(paint_color)))
		return ITEM_INTERACT_SUCCESS

	if(istype(interacting_with, /obj/item/pipe))
		var/obj/item/pipe/target_pipe = interacting_with
		var/color = GLOB.pipe_paint_colors[paint_color]
		target_pipe.pipe_color = color
		target_pipe.add_atom_colour(color, FIXED_COLOUR_PRIORITY)
		playsound(src, 'sound/machines/click.ogg', 50, TRUE)
		balloon_alert(user, LANG("obj.4da583d630a718fb", list(paint_color)))
		return ITEM_INTERACT_SUCCESS

	return NONE

/obj/item/pipe_painter/attack_self(mob/user)
	paint_color = tgui_input_list(user, LANG("obj.14deab37a273c7c0", null), LANG("obj.e47df031e534173c", null), GLOB.pipe_paint_colors)

/obj/item/pipe_painter/examine(mob/user)
	. = ..()
	. += span_notice(LANG("obj.a434c23ebb4aed22", list(paint_color)))
