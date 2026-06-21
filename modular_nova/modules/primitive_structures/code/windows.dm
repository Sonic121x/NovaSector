/obj/structure/window/green_glass_pane
	name = "绿色玻璃窗"
	desc = "一扇手工制作的绿色玻璃窗。至少你还能透过它看东西。"
	icon = 'modular_nova/modules/primitive_structures/icons/windows.dmi'
	icon_state = "green_glass"
	flags_1 = NONE
	obj_flags = parent_type::obj_flags | NO_DEBRIS_AFTER_DECONSTRUCTION
	fulltile = TRUE
	flags_1 = PREVENT_CLICK_UNDER_1
	custom_materials = list(/datum/material/glass = SHEET_MATERIAL_AMOUNT * 2)

/datum/crafting_recipe/green_glass_pane
	name = "绿色玻璃窗"
	result = /obj/structure/window/green_glass_pane
	time = 0.2 SECONDS
	reqs = list(
		/datum/reagent/iron = 5,
		/obj/item/stack/sheet/glass = 2,
	)
	category = CAT_STRUCTURE
