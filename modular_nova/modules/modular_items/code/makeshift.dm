//Tools that are made using makeshift item crafting

/obj/item/crowbar/makeshift
	name = "临时撬棍"
	desc = "一把用各种零件粗制滥造拼凑而成的临时撬棍。它有一个结实的头部，看起来可以用来敲击。"
	icon = 'modular_nova/modules/modular_items/icons/tools.dmi'
	icon_state = "makeshift_crowbar"
	worn_icon_state = "crowbar"
	force = 2
	throwforce = 2
	w_class = WEIGHT_CLASS_NORMAL
	toolspeed = 1.5
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 4)

/obj/item/screwdriver/makeshift
	name = "临时螺丝刀"
	desc = "一把用布料和一些金属粗制滥造而成的临时螺丝刀。"
	icon = 'modular_nova/modules/modular_items/icons/tools.dmi'
	icon_state = "makeshift_screwdriver"
	random_color = FALSE
	force = 1
	throwforce = 1
	w_class = WEIGHT_CLASS_NORMAL
	toolspeed = 1.5
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT)

/obj/item/weldingtool/makeshift
	name = "临时焊枪"
	desc = "一把用各种零件粗制滥造拼凑而成的临时焊枪。"
	icon = 'modular_nova/modules/modular_items/icons/tools.dmi'
	icon_state = "makeshift_welder"
	force = 1
	throwforce = 2
	toolspeed = 1.5
	w_class = WEIGHT_CLASS_NORMAL
	max_fuel = 10
	heat = 1800
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 6.5)

/obj/item/wirecutters/makeshift
	name = "临时钢丝钳"
	desc = "用各种零件粗制滥造拼凑而成的临时钢丝钳。"
	icon = 'modular_nova/modules/modular_items/icons/tools.dmi'
	icon_state = "makeshift_cutters"
	random_color = FALSE
	force = 3
	throwforce = 2
	w_class = WEIGHT_CLASS_NORMAL
	toolspeed = 1.5
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2)
	greyscale_config = null
	greyscale_config_inhand_left = null
	greyscale_config_inhand_right = null
	greyscale_colors = null

/obj/item/wrench/makeshift
	name = "临时扳手"
	desc = "一把用各种零件粗制滥造拼凑而成的临时扳手。"
	icon = 'modular_nova/modules/modular_items/icons/tools.dmi'
	icon_state = "makeshift_wrench"
	force = 2
	throwforce = 2
	w_class = WEIGHT_CLASS_NORMAL
	toolspeed = 1.5
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 3.5)
