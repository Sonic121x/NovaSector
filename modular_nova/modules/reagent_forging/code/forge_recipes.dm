/datum/crafting_recipe/primitive_billow
	name = "原始锻造风箱"
	result = /obj/item/forging/billow/primitive
	reqs = list(/obj/item/stack/sheet/mineral/wood = 5)
	category = CAT_TOOLS

/datum/crafting_recipe/primitive_tong
	name = "原始锻造钳"
	result = /obj/item/forging/tongs/primitive
	reqs = list(/obj/item/stack/sheet/iron = 5)
	category = CAT_TOOLS

/datum/crafting_recipe/primitive_hammer
	name = "原始锻造锤"
	result = /obj/item/forging/hammer/primitive
	reqs = list(/obj/item/stack/sheet/iron = 5)
	category = CAT_TOOLS

//cargo supply pack for items
/datum/supply_pack/service/forging_items
	name = "锻造入门工具包"
	desc = "特色：锻造。此包装满了开启锻造生涯所需的物品：钳子、锤子、风箱、铁、煤、木头。"
	cost = CARGO_CRATE_VALUE * 2.5
	contains = list(
		/obj/item/forging/tongs,
		/obj/item/forging/hammer,
		/obj/item/forging/billow,
		/obj/item/stack/sheet/iron/twenty,
		/obj/item/stack/sheet/mineral/coal/five,
		/obj/item/stack/sheet/mineral/wood/thirty,
	)
	crate_name = "forging start items"
	crate_type = /obj/structure/closet/crate/forging_items

/obj/structure/closet/crate/forging_items
	name = "锻造入门物品"
	desc = "一个装满开始锻造所需物品的板条箱（风箱、锤子和钳子）。"
