// LOADOUT ITEM DATUMS FOR THE BELT SLOT

/datum/loadout_category/belt
	category_name = "Belt"
	category_ui_icon = FA_ICON_SCREWDRIVER_WRENCH
	type_to_generate = /datum/loadout_item/belts
	tab_order = /datum/loadout_category/accessories::tab_order + 1

/datum/loadout_item/belts
	abstract_type = /datum/loadout_item/belts

/datum/loadout_item/belts/pre_equip_item(datum/outfit/outfit, datum/outfit/outfit_important_for_life, mob/living/carbon/human/equipper, visuals_only = FALSE)  // don't bother storing in backpack, can't fit
	if(initial(outfit_important_for_life.belt))
		return TRUE

/datum/loadout_item/belts/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE, override_items = LOADOUT_OVERRIDE_BACKPACK)
	if(override_items == LOADOUT_OVERRIDE_BACKPACK && !visuals_only)
		if(outfit.belt)
			LAZYADD(outfit.backpack_contents, outfit.belt)

	outfit.belt = item_path

/*
*	ITEMS BELOW HERE
*/

/datum/loadout_item/belts/fanny_pack_black
	name = "腰包（黑色）"
	item_path = /obj/item/storage/belt/fannypack/black

/datum/loadout_item/belts/fanny_pack_blue
	name = "腰包（蓝色）"
	item_path = /obj/item/storage/belt/fannypack/blue

/datum/loadout_item/belts/fanny_pack_brown
	name = "腰包（棕色）"
	item_path = /obj/item/storage/belt/fannypack

/datum/loadout_item/belts/fanny_pack_cyan
	name = "腰包（青色）"
	item_path = /obj/item/storage/belt/fannypack/cyan

/datum/loadout_item/belts/fanny_pack_green
	name = "腰包（绿色）"
	item_path = /obj/item/storage/belt/fannypack/green

/datum/loadout_item/belts/fanny_pack_orange
	name = "腰包（橙色）"
	item_path = /obj/item/storage/belt/fannypack/orange

/datum/loadout_item/belts/fanny_pack_pink
	name = "腰包（粉色）"
	item_path = /obj/item/storage/belt/fannypack/pink

/datum/loadout_item/belts/fanny_pack_purple
	name = "腰包（紫色）"
	item_path = /obj/item/storage/belt/fannypack/purple

/datum/loadout_item/belts/fanny_pack_red
	name = "腰包（红色）"
	item_path = /obj/item/storage/belt/fannypack/red

/datum/loadout_item/belts/fanny_pack_white
	name = "腰包（白色）"
	item_path = /obj/item/storage/belt/fannypack/white

/datum/loadout_item/belts/fanny_pack_yellow
	name = "腰包（黄色）"
	item_path = /obj/item/storage/belt/fannypack/yellow

/datum/loadout_item/belts/lantern
	name = "提灯"
	item_path = /obj/item/flashlight/lantern

/datum/loadout_item/belts/thigh_satchel
	name = "大腿挎包"
	item_path = /obj/item/storage/belt/thigh_satchel

// HOLSTERS

/datum/loadout_item/belts/holster_shoulders
	name = "枪套（肩部）"
	item_path = /obj/item/storage/belt/holster

/datum/loadout_item/belts/holster_cowboy
	name = "枪套（大腿，可着色）"
	item_path = /obj/item/storage/belt/holster/thigh

// RIGS (for military larpers)

/datum/loadout_item/belts/cin_surplus_chestrig
	name = "腰带 - CIN 剩余物资（可着色）"
	item_path = /obj/item/storage/belt/military/cin_surplus

/datum/loadout_item/belts/cin_surplus_chestrig_desert
	name = "腰带 - CIN 剩余物资（沙漠色）"
	item_path = /obj/item/storage/belt/military/cin_surplus/desert
	loadout_flags = parent_type::loadout_flags | LOADOUT_FLAG_BLOCK_GREYSCALING

/datum/loadout_item/belts/cin_surplus_chestrig_forest
	name = "腰带 - CIN 剩余物资（森林色）"
	item_path = /obj/item/storage/belt/military/cin_surplus/forest
	loadout_flags = parent_type::loadout_flags | LOADOUT_FLAG_BLOCK_GREYSCALING

/datum/loadout_item/belts/cin_surplus_chestrig_marine
	name = "腰带 - CIN 剩余物资（海军陆战队色）"
	item_path = /obj/item/storage/belt/military/cin_surplus/marine
	loadout_flags = parent_type::loadout_flags | LOADOUT_FLAG_BLOCK_GREYSCALING
