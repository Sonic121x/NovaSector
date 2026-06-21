/obj/machinery/rnd/production/protolathe
	name = "复合机"
	desc = "将原材料转化为有用的物品。"
	icon_state = "protolathe"
	base_icon_state = "protolathe"
	circuit = /obj/item/circuitboard/machine/protolathe
	production_animation = "protolathe_n"
	allowed_buildtypes = PROTOLATHE

/obj/machinery/rnd/production/protolathe/on_deconstruction(disassembled)
	log_game("Protolathe of type [type] [disassembled ? "disassembled" : "deconstructed"] by [key_name(usr)] at [get_area_name(src, TRUE)]")

	return ..()

/obj/machinery/rnd/production/protolathe/Initialize(mapload)
	if(!mapload)
		log_game("Protolathe of type [type] constructed by [key_name(usr)] at [get_area_name(src, TRUE)]")

	return ..()

/// Special subtype protolathe for offstation use. Has a more limited available design selection.
/obj/machinery/rnd/production/protolathe/offstation
	name = "古代的复合机"
	desc = "将原材料转化为有用的物品。其古老的构造可能限制了其打印所有已知技术的能力。"
	circuit = /obj/item/circuitboard/machine/protolathe/offstation
	allowed_buildtypes = AWAY_LATHE
