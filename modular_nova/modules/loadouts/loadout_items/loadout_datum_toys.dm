// LOADOUT ITEM DATUMS FOR TOY ITEMS, PLACED DIRECTLY INTO THE BACKPACK

/datum/loadout_category/toys
	category_name = "Toys"
	category_ui_icon = FA_ICON_TROPHY
	type_to_generate = /datum/loadout_item/toys
	tab_order = /datum/loadout_category/weapons::tab_order + 1
	/// How many toys are allowed at maximum.
	VAR_PRIVATE/max_allowed = 3

/datum/loadout_category/toys/New()
	. = ..()
	category_info = "([max_allowed] allowed)"

/datum/loadout_category/toys/handle_duplicate_entires(
	datum/preference_middleware/loadout/manager,
	datum/loadout_item/conflicting_item,
	datum/loadout_item/added_item,
	list/datum/loadout_item/all_loadout_items,
)
	var/list/datum/loadout_item/toys/other_toys = list()
	for(var/datum/loadout_item/toys/other_toy in all_loadout_items)
		other_toys += other_toy

	if(length(other_toys) >= max_allowed)
		// We only need to deselect something if we're above the limit
		// (And if we are we prioritize the first item found, FIFO)
		manager.deselect_item(other_toys[1])
	return TRUE

/datum/loadout_item/toys
	abstract_type = /datum/loadout_item/toys

/datum/loadout_item/toys/pre_equip_item(datum/outfit/outfit, datum/outfit/outfit_important_for_life, mob/living/carbon/human/equipper, visuals_only = FALSE)  // these go in the backpack
	return FALSE

/*
*	ITEMS BELOW HERE
*/

/datum/loadout_item/toys/crayons
	//Extra space forces the "Toys" Group to the top
	name = "一盒蜡笔"
	item_path = /obj/item/storage/crayons

/datum/loadout_item/toys/cat_toy
	name = "猫玩具"
	item_path = /obj/item/toy/cattoy

/datum/loadout_item/toys/dog_bone
	name = "巨型狗骨头"
	item_path = /obj/item/dog_bone

/datum/loadout_item/toys/red_laser
	name = "激光笔（红色）"
	item_path = /obj/item/laser_pointer/limited/red

/datum/loadout_item/toys/green_laser
	name = "激光笔（绿色）"
	item_path = /obj/item/laser_pointer/limited/green

/datum/loadout_item/toys/blue_laser
	name = "激光笔（蓝色）"
	item_path = /obj/item/laser_pointer/limited/blue

/datum/loadout_item/toys/purple_laser
	name = "激光笔（紫色）"
	item_path = /obj/item/laser_pointer/limited/purple

/datum/loadout_item/toys/eightball
	name = "魔法八号球"
	item_path = /obj/item/toy/eightball

/datum/loadout_item/toys/spray_can
	name = "喷漆罐"
	item_path = /obj/item/toy/crayon/spraycan

/datum/loadout_item/toys/toykatana
	name = "玩具武士刀"
	item_path = /obj/item/toy/katana

/datum/loadout_item/toys/toykatanasheath
	name = "Toy Katana (Sheathed)"
	item_path = /obj/item/storage/belt/sheath/katana/toy

/datum/loadout_item/toys/purity_seal
	name = "Box of Purity Seals"
	item_path = /obj/item/storage/box/purity_seal_box

/datum/loadout_item/toys/foam_pistol
	name = "Foam Force Pistol"
	item_path = /obj/item/gun/ballistic/automatic/pistol/toy

/datum/loadout_item/toys/foam_shotgun
	name = "Foam Force Shotgun"
	item_path = /obj/item/gun/ballistic/shotgun/toy

/datum/loadout_item/toys/foam_lmg
	name = "Foam Force LMG"
	item_path = /obj/item/gun/ballistic/automatic/l6_saw/toy/unrestricted

/datum/loadout_item/toys/foam_smg
	name = "Foam Force SMG"
	item_path = /obj/item/gun/ballistic/automatic/c20r/toy/unrestricted

/datum/loadout_item/toys/ventriloquist
	name = "Ventriloquist Dummy"
	item_path = /obj/item/toy/dummy

/*
*	TENNIS BALLS
*/

/datum/loadout_item/toys/tennis
	name = "网球（经典款）"
	item_path = /obj/item/toy/tennis

/datum/loadout_item/toys/tennisred
	name = "网球（红色）"
	item_path = /obj/item/toy/tennis/red

/datum/loadout_item/toys/tennisyellow
	name = "网球（黄色）"
	item_path = /obj/item/toy/tennis/yellow

/datum/loadout_item/toys/tennisgreen
	name = "网球（绿色）"
	item_path = /obj/item/toy/tennis/green

/datum/loadout_item/toys/tenniscyan
	name = "网球（青色）"
	item_path = /obj/item/toy/tennis/cyan

/datum/loadout_item/toys/tennisblue
	name = "网球（蓝色）"
	item_path = /obj/item/toy/tennis/blue

/datum/loadout_item/toys/tennispurple
	name = "网球（紫色）"
	item_path = /obj/item/toy/tennis/purple

/*
*	CARDS
*/

/datum/loadout_item/toys/card_binder
	name = "卡牌收纳册"
	item_path = /obj/item/storage/card_binder

/datum/loadout_item/toys/card_deck
	name = "卡牌组"
	item_path = /obj/item/toy/cards/deck

/datum/loadout_item/toys/kotahi_deck
	name = "卡牌组 - 科塔希"
	item_path = /obj/item/toy/cards/deck/kotahi

/datum/loadout_item/toys/tarot
	name = "卡牌组 - 塔罗牌"
	item_path = /obj/item/toy/cards/deck/tarot

/datum/loadout_item/toys/wizoff_deck
	name = "卡牌组 - 巫师对决"
	item_path = /obj/item/toy/cards/deck/wizoff

/*
*	DICE
*/

/datum/loadout_item/toys/dice
	group = "Dice"
	abstract_type = /datum/loadout_item/toys/dice

/datum/loadout_item/toys/dice/d00
	//Extra space forces "Dice" Group above "Plushies"
	name = "D00"
	item_path = /obj/item/dice/d00

//I am NOT alphabetizing numbers dawg. It's not actually number order 11 comes before 2
/datum/loadout_item/toys/dice/d1
	name = "D1"
	item_path = /obj/item/dice/d1

/datum/loadout_item/toys/dice/d2
	name = "D2"
	item_path = /obj/item/dice/d2

/datum/loadout_item/toys/dice/d4
	name = "D4"
	item_path = /obj/item/dice/d4

/datum/loadout_item/toys/dice/d6
	name = "D6"
	item_path = /obj/item/dice/d6

/datum/loadout_item/toys/dice/d6_ebony
	name = "D6 (乌木)"
	item_path = /obj/item/dice/d6/ebony

/datum/loadout_item/toys/dice/d6_space
	name = "D6 (太空)"
	item_path = /obj/item/dice/d6/space

/datum/loadout_item/toys/dice/d8
	name = "D8"
	item_path = /obj/item/dice/d8

/datum/loadout_item/toys/dice/d10
	name = "D10"
	item_path = /obj/item/dice/d10

/datum/loadout_item/toys/dice/d12
	name = "D12"
	item_path = /obj/item/dice/d12

/datum/loadout_item/toys/dice/d20
	name = "D20"
	item_path = /obj/item/dice/d20

/datum/loadout_item/toys/dice/d20_weighted_low
	name = "D20 (加重，低值)"
	item_path = /obj/item/dice/d20/nat1

/datum/loadout_item/toys/dice/d20_weighted_high
	name = "D20 (加重，高值)"
	item_path = /obj/item/dice/d20/nat20

/datum/loadout_item/toys/dice/d100
	name = "D100"
	item_path = /obj/item/dice/d100

/datum/loadout_item/toys/dice/dice_bag
	name = "骰子袋"
	item_path = /obj/item/storage/dice
