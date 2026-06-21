// LOADOUT ITEM DATUMS FOR THE HANDS SLOT

/datum/loadout_category/hands
	category_name = "Hands"
	category_ui_icon = FA_ICON_HAND
	type_to_generate = /datum/loadout_item/gloves
	tab_order = /datum/loadout_category/belt::tab_order + 1

/datum/loadout_item/gloves
	abstract_type = /datum/loadout_item/gloves

/datum/loadout_item/gloves/pre_equip_item(datum/outfit/outfit, datum/outfit/outfit_important_for_life, mob/living/carbon/human/equipper, visuals_only = FALSE)
	if(initial(outfit_important_for_life.gloves))
		.. ()
		return TRUE

/datum/loadout_item/gloves/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE, override_items = LOADOUT_OVERRIDE_BACKPACK)
	if(override_items == LOADOUT_OVERRIDE_BACKPACK && !visuals_only)
		if(outfit.gloves)
			LAZYADD(outfit.backpack_contents, outfit.gloves)
		outfit.gloves = item_path
	else
		outfit.gloves = item_path

/*
*	ITEMS BELOW HERE
*/

/datum/loadout_item/gloves/armwraps
	name = "臂带（可着色）"
	item_path = /obj/item/clothing/gloves/bracer/wraps

/datum/loadout_item/gloves/black
	name = "手套（黑色）"
	item_path = /obj/item/clothing/gloves/color/black

/datum/loadout_item/gloves/brown
	name = "手套（棕色）"
	item_path = /obj/item/clothing/gloves/color/brown

/datum/loadout_item/gloves/blue
	name = "手套（蓝色）"
	item_path = /obj/item/clothing/gloves/color/blue

/datum/loadout_item/gloves/green
	name = "手套（绿色）"
	item_path = /obj/item/clothing/gloves/color/green

/datum/loadout_item/gloves/grey
	name = "手套（灰色）"
	item_path = /obj/item/clothing/gloves/color/grey

/datum/loadout_item/gloves/light_brown
	name = "手套（浅棕色）"
	item_path = /obj/item/clothing/gloves/color/light_brown

/datum/loadout_item/gloves/orange
	name = "手套（橙色）"
	item_path = /obj/item/clothing/gloves/color/orange

/datum/loadout_item/gloves/purple
	name = "手套（紫色）"
	item_path = /obj/item/clothing/gloves/color/purple

/datum/loadout_item/gloves/red
	name = "手套（红色）"
	item_path = /obj/item/clothing/gloves/color/red

/datum/loadout_item/gloves/white
	name = "手套（白色）"
	item_path = /obj/item/clothing/gloves/color/white

/datum/loadout_item/gloves/yellow
	name = "手套（黄色）"
	item_path = /obj/item/clothing/gloves/color/ffyellow

/datum/loadout_item/gloves/yellow/get_item_information()
	. = ..()
	.[FA_ICON_BOLT] = "Non-Insulating"

/datum/loadout_item/gloves/kim
	name = "手套 - 气动式"
	item_path = /obj/item/clothing/gloves/kim

/datum/loadout_item/gloves/lalune_long
	name = "手套 - 设计师款"
	item_path = /obj/item/clothing/gloves/designer

/datum/loadout_item/gloves/evening
	name = "手套 - 晚宴款"
	item_path = /obj/item/clothing/gloves/evening

/datum/loadout_item/gloves/rainbow
	name = "手套 - 彩虹款"
	item_path = /obj/item/clothing/gloves/color/rainbow

/datum/loadout_item/gloves/maid_arm_covers
	name = "女仆臂套（可着色）"
	item_path = /obj/item/clothing/gloves/maid_arm_covers

/datum/loadout_item/gloves/tactical_maid_sleeves
	name = "女仆臂套 - 战术款"
	item_path = /obj/item/clothing/gloves/tactical_maid

/datum/loadout_item/gloves/pink_clown_gloves
	name = "粉色小丑手套"
	item_path = /obj/item/clothing/gloves/pink_clown

/datum/loadout_item/gloves/recolorable
	name = "Gloves (Colorable)"
	item_path = /obj/item/clothing/gloves/recolorable

/datum/loadout_item/gloves/recolorable_fingerless
	name = "Fingerless Gloves (Colorable)"
	item_path = /obj/item/clothing/gloves/recolorable/fingerless

/datum/loadout_item/gloves/recolorable_long
	name = "Long Gloves (Colorable)"
	item_path = /obj/item/clothing/gloves/recolorable/long

/datum/loadout_item/gloves/recolorable_fingerless_long
	name = "Long Fingerless Gloves (Colorable)"
	item_path = /obj/item/clothing/gloves/recolorable/fingerless/long

/*
*	RINGS
*/

/datum/loadout_item/gloves/diamondring
	name = "戒指 - 钻石"
	item_path = /obj/item/clothing/gloves/ring/diamond

/datum/loadout_item/gloves/goldring
	name = "戒指 - 黄金"
	item_path = /obj/item/clothing/gloves/ring

/datum/loadout_item/gloves/silverring
	name = "戒指 - 白银"
	item_path = /obj/item/clothing/gloves/ring/silver

/*
*	erp_item
*/

/datum/loadout_item/gloves/latex
	name = "乳胶手套"
	item_path = /obj/item/clothing/gloves/long_gloves
	erp_item = TRUE

/*
*	DONATOR
*/

/datum/loadout_item/gloves/donator
	abstract_type = /datum/loadout_item/gloves/donator
	donator_only = TRUE

/datum/loadout_item/gloves/donator/military
	name = "军用战术手套"
	item_path = /obj/item/clothing/gloves/military
