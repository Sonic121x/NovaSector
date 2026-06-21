/obj/item/crucifix
	name = "华丽十字架"
	desc = "一个华丽的金色十字架，装饰着各种宝石和微小的雕刻。不知为何，它摸起来总是温热的。"
	icon = 'modular_nova/modules/modular_items/icons/crucifix.dmi'
	icon_state = "cross_ornate"
	lefthand_file = 'modular_nova/modules/modular_items/icons/cross_left.dmi'
	righthand_file = 'modular_nova/modules/modular_items/icons/cross_right.dmi'
	force = 5 //Gem-encrusted and reinforced with GOD
	throw_speed = 3
	throw_range = 4
	throwforce = 10
	w_class = WEIGHT_CLASS_TINY
	custom_materials = list(/datum/material/gold = SHEET_MATERIAL_AMOUNT, /datum/material/diamond = SHEET_MATERIAL_AMOUNT)

/datum/crafting_recipe/cross
	name = "华丽十字架"
	result = /obj/item/crucifix
	reqs = list(/obj/item/stack/sheet/mineral/gold = 1,
				/obj/item/stack/sheet/mineral/diamond = 1)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 20
	category = CAT_MISC
