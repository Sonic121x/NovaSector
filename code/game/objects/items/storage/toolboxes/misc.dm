
/obj/item/storage/toolbox/drone
	name = "机械工具箱"
	icon_state = "blue"
	inhand_icon_state = "toolbox_blue"
	material_flags = NONE

/obj/item/storage/toolbox/drone/PopulateContents()
	var/pickedcolor = pick("red","yellow","green","blue","pink","orange","cyan","white")
	new /obj/item/screwdriver(src)
	new /obj/item/wrench(src)
	new /obj/item/weldingtool(src)
	new /obj/item/crowbar(src)
	new /obj/item/stack/cable_coil(src,MAXCOIL,pickedcolor)
	new /obj/item/wirecutters(src)
	new /obj/item/multitool(src)

/obj/item/storage/toolbox/artistic
	name = "艺术工具箱"
	desc = "一个漆成亮绿色的工具箱。为什么有人会把美术用品放在工具箱里，这让你无法理解，但它确实有很多额外空间。"
	icon_state = "green"
	inhand_icon_state = "toolbox_green"
	w_class = WEIGHT_CLASS_GIGANTIC //Holds more than a regular toolbox!
	material_flags = NONE
	storage_type = /datum/storage/toolbox/artistic

/obj/item/storage/toolbox/artistic/PopulateContents()
	new /obj/item/storage/crayons(src)
	new /obj/item/toy/crayon/spraycan(src)
	new /obj/item/toy/crayon/spraycan(src)
	new /obj/item/paint_palette(src)
	new /obj/item/paint/anycolor(src)
	new /obj/item/paint/anycolor(src)
	new /obj/item/paint/anycolor(src)

/obj/item/storage/toolbox/haunted
	name = "旧工具箱"
	custom_materials = list(/datum/material/hauntium = SMALL_MATERIAL_AMOUNT*5)

/obj/item/storage/toolbox/crafter
	name = "工匠工具箱"
	desc = "一个漆成亮粉色的工具箱。装满了手工材料！"
	icon_state = "pink"
	inhand_icon_state = "toolbox_pink"
	w_class = WEIGHT_CLASS_GIGANTIC //Holds more than a regular toolbox!
	material_flags = NONE
	storage_type = /datum/storage/toolbox/crafter

/obj/item/storage/toolbox/crafter/PopulateContents()
	new /obj/item/storage/crayons(src)
	new /obj/item/camera(src)
	new /obj/item/camera_film(src)
	new /obj/item/chisel(src)
	new /obj/item/stack/pipe_cleaner_coil/red(src)
	new /obj/item/stack/pipe_cleaner_coil/yellow(src)
	new /obj/item/stack/pipe_cleaner_coil/blue(src)
	new /obj/item/stack/pipe_cleaner_coil/green(src)
	new /obj/item/stack/pipe_cleaner_coil/pink(src)
	new /obj/item/stack/pipe_cleaner_coil/orange(src)
	new /obj/item/stack/pipe_cleaner_coil/cyan(src)
	new /obj/item/stack/pipe_cleaner_coil/white(src)
	new /obj/item/stack/pipe_cleaner_coil/brown(src)
