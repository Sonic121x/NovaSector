///The item used as the basis for construction kits for organic interface
/obj/item/construction_kit
	name = "组装套件"
	desc = "用于建造各种物品"
	w_class = WEIGHT_CLASS_BULKY
	obj_flags = CAN_BE_HIT
	throwforce = 0
	///What is the path for the resulting structure generating by using this item?
	var/obj/structure/resulting_structure = /obj/structure/chair
	///How much time does it take to construct an item using this?
	var/construction_time = 8 SECONDS
	///What color is the item using? If none, leave this blank.
	var/current_color = ""

/obj/item/construction_kit/Initialize(mapload)
	. = ..()
	name = "[initial(resulting_structure.name)] [name]"

/obj/item/construction_kit/examine(mob/user)
	. = ..()
	. += span_purple("[src] 可以通过在 [src] 位于地面上时使用 <b>Ctrl+Shift+点击</b> 来组装。")

/obj/item/construction_kit/click_ctrl_shift(mob/user)
	if((item_flags & IN_INVENTORY) || (item_flags & IN_STORAGE))
		return

	to_chat(user, span_notice("你开始组装 [src]..."))
	if(!do_after(user, construction_time, src))
		to_chat(user, span_warning("你未能组装 [src]！"))
		return

	var/obj/structure/chair/final_structure = new resulting_structure (get_turf(user))
	if(current_color && istype(final_structure, /obj/structure/chair/milking_machine))
		var/obj/structure/chair/milking_machine/new_milker = final_structure
		new_milker.machine_color = current_color

		if(current_color == "pink")
			new_milker.icon_state = "milking_pink_off"
		else
			new_milker.icon_state = "milking_teal_off"

	if(istype(final_structure, /obj/structure/chair/shibari_stand))
		var/obj/structure/chair/shibari_stand/stand = final_structure
		stand.set_greyscale(greyscale_colors)

	qdel(src)
	to_chat(user, span_notice("你组装了 [src]。"))

// MILKER

/obj/item/construction_kit/milker
	icon = 'modular_nova/modules/modular_items/lewd_items/icons/obj/lewd_structures/milking_machine.dmi'
	icon_state = "milkbuild_pink"
	base_icon_state = "milkbuild"
	current_color = "pink"
	resulting_structure = /obj/structure/chair/milking_machine

/obj/item/construction_kit/milker/Initialize(mapload)
	. = ..()
	update_icon_state()
	update_icon()

/obj/item/construction_kit/milker/update_icon_state()
	icon_state = "[initial(base_icon_state)]_[current_color]"
	return ..()


/obj/item/construction_kit/pole
	icon = 'modular_nova/modules/modular_items/lewd_items/icons/obj/lewd_structures/dancing_pole.dmi'
	icon_state = "pole_base"
	resulting_structure = /obj/structure/stripper_pole

// BDSM FURNITURE
/obj/item/construction_kit/bdsm
	icon = 'modular_nova/modules/modular_items/lewd_items/icons/obj/lewd_structures/bdsm_furniture.dmi'

// X-STAND

/obj/item/construction_kit/bdsm/x_stand
	icon_state = "xstand_kit"
	resulting_structure = /obj/structure/chair/x_stand

// RESTRAINED BED

/obj/item/construction_kit/bdsm/bed
	icon_state = "bdsm_bed_kit"
	resulting_structure = /obj/structure/bed/bdsm_bed

/obj/item/construction_kit/bdsm/shibari
	icon = 'icons/map_icons/items/_item.dmi'
	icon_state = "/obj/item/construction_kit/bdsm/shibari"
	post_init_icon_state = "shibari_kit"
	greyscale_config = /datum/greyscale_config/shibari_stand_item
	greyscale_colors = "#bd8fcf"
	resulting_structure = /obj/structure/chair/shibari_stand

// SHIBARI STAND

/obj/item/construction_kit/bdsm/shibari/examine(mob/user)
	.=..()
	. += span_purple("[src] 的颜色可以通过 <b>Ctrl+点击</b> 来自定义。")

//to change model
/obj/item/construction_kit/bdsm/shibari/item_ctrl_click(mob/user)
	. = ..()
	if(. == FALSE)
		return CLICK_ACTION_BLOCKING

	var/list/allowed_configs = list()
	allowed_configs += "[greyscale_config]"
	var/datum/greyscale_modify_menu/menu = new(
		src, usr, allowed_configs, null, \
		starting_icon_state = icon_state, \
		starting_config = greyscale_config, \
		starting_colors = greyscale_colors
	)
	menu.ui_interact(usr)
	to_chat(user, span_notice("你切换了框架塑料配件的颜色。"))
	return CLICK_ACTION_SUCCESS
