///Tool capable of taking biological samples from mobs
/obj/item/biopsy_tool
	name = "活组织采样器"
	desc = "用于从生物体获取细胞系。别担心，不会疼的。"
	icon = 'icons/obj/science/vatgrowing.dmi'
	icon_state = "biopsy"
	worn_icon_state = "biopsy"
	base_icon_state = "biopsy"
	/// Whether or not we can swab objects
	var/can_swap_objects = FALSE

///Adds the swabbing component to the biopsy tool
/obj/item/biopsy_tool/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/swabbing, can_swap_objects, FALSE, TRUE, CALLBACK(src, PROC_REF(update_swab_icon)), max_items = 1)

/obj/item/biopsy_tool/proc/update_swab_icon(list/swabbed_items)
	if(LAZYLEN(swabbed_items))
		icon_state = base_icon_state + "_full"
	else
		icon_state = base_icon_state

/obj/item/biopsy_tool/organ
	name = "组织活检工具"
	desc = "用于从器官组织和生物体获取细胞系。别担心，不会疼的。"
	icon_state = "biopsy_organ"
	base_icon_state = "biopsy_organ"

	can_swap_objects = TRUE

