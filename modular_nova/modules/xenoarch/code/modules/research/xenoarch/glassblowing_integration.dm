/obj/item/glassblowing/magnifying_glass
	name = "放大镜"
	desc = "一种借助放大镜片，能让你看清微小之物的工具。"
	icon_state = "magnifying_glass"
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT)

/datum/crafting_recipe/magnifying_glass
	name = "放大镜"
	result = /obj/item/glassblowing/magnifying_glass
	reqs = list(
		/obj/item/stack/sheet/mineral/wood = 1,
		/obj/item/glassblowing/glass_lens = 1,
	)
	category = CAT_EQUIPMENT
