/obj/item/mecha_diagnostic
	name = "机甲全息诊断仪"
	desc = "一份包含机甲构造独特数据以及已发布设计之间生产差异的全息数据表，用于记录渐进式改进。"
	icon = 'icons/obj/devices/scanner.dmi'
	icon_state = "holosheet"
	w_class = WEIGHT_CLASS_SMALL
	layer = ABOVE_MOB_LAYER
	light_system = OVERLAY_LIGHT
	light_range = 1
	light_power = 2
	light_color = "#79aeeb"
	/// What mech was this diagnostic sheet generated from? Used for applicability in bounties.
	var/obj/vehicle/sealed/mecha/mech_data

/obj/item/mecha_diagnostic/Initialize(mapload)
	. = ..()
	set_light_on(TRUE)

/obj/item/mecha_diagnostic/Destroy(force)
	. = ..()
	mech_data = null

/obj/item/mecha_diagnostic/examine(mob/user)
	. = ..()
	if(mech_data)
		. += "This holodata sheet consists of data from a <b>[initial(mech_data.name)]</b>."
