// LOADOUT ITEM DATUMS FOR THE MASK SLOT

/datum/loadout_category/face
	category_name = "Face"
	category_ui_icon = FA_ICON_MASK
	type_to_generate = /datum/loadout_item/mask
	tab_order = /datum/loadout_category/glasses::tab_order + 1

/datum/loadout_item/mask
	abstract_type = /datum/loadout_item/mask

/datum/loadout_item/mask/pre_equip_item(datum/outfit/outfit, datum/outfit/outfit_important_for_life, mob/living/carbon/human/equipper, visuals_only = FALSE)
	if(initial(outfit_important_for_life.mask))
		..()
		return TRUE

/datum/loadout_item/mask/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE, override_items = LOADOUT_OVERRIDE_BACKPACK)
	if(override_items == LOADOUT_OVERRIDE_BACKPACK && !visuals_only)
		if(outfit.mask)
			LAZYADD(outfit.backpack_contents, outfit.mask)
		outfit.mask = item_path
	else
		outfit.mask = item_path

/*
*	ITEMS BELOW HERE
*/

/datum/loadout_item/mask/driscoll
	name = "德里斯科尔面具"
	item_path = /obj/item/clothing/mask/gas/driscoll

/datum/loadout_item/mask/facescarf
	name = "面巾"
	item_path = /obj/item/clothing/mask/facescarf

/datum/loadout_item/mask/lollipop
	name = "棒棒糖"
	item_path = /obj/item/food/lollipop

/datum/loadout_item/mask/neck_gaiter
	name = "颈套"
	item_path = /obj/item/clothing/mask/neck_gaiter

/datum/loadout_item/mask/pipe
	name = "烟斗"
	item_path = /obj/item/cigarette/pipe

/datum/loadout_item/mask/corn_pipe
	name = "烟斗 - 玉米芯"
	item_path = /obj/item/cigarette/pipe/cobpipe

/datum/loadout_item/mask/surgical
	name = "无菌口罩（可着色）"
	item_path = /obj/item/clothing/mask/surgical/greyscale

/*
*	BANDANAS
*/

/datum/loadout_item/mask/bandana
	name = "头巾（可着色）"
	item_path = /obj/item/clothing/mask/bandana

/datum/loadout_item/mask/bandana_striped
	name = "头巾（可着色，条纹）"
	item_path = /obj/item/clothing/mask/bandana/striped

/datum/loadout_item/mask/skull_bandana
	name = "头巾（可着色，骷髅图案）"
	item_path = /obj/item/clothing/mask/bandana/skull

/datum/loadout_item/mask/black_bandana
	name = "头巾（黑色）"
	item_path = /obj/item/clothing/mask/bandana/black

/datum/loadout_item/mask/blue_bandana
	name = "头巾（蓝色）"
	item_path = /obj/item/clothing/mask/bandana/blue

/datum/loadout_item/mask/gold_bandana
	name = "头巾（金色）"
	item_path = /obj/item/clothing/mask/bandana/gold

/datum/loadout_item/mask/green_bandana
	name = "头巾（绿色）"
	item_path = /obj/item/clothing/mask/bandana/green

/datum/loadout_item/mask/red_bandana
	name = "头巾（红色）"
	item_path = /obj/item/clothing/mask/bandana/red
/*
*	BALACLAVAS
*/

/datum/loadout_item/mask/balaclava
	name = "巴拉克拉瓦头套"
	item_path = /obj/item/clothing/mask/balaclava

/datum/loadout_item/mask/balaclavaadj
	name = "巴拉克拉瓦头套 - 可调节"
	item_path = /obj/item/clothing/mask/balaclava/adjustable

/datum/loadout_item/mask/balaclavathree
	name = "巴拉克拉瓦头套 - 三孔式（黑色）"
	item_path = /obj/item/clothing/mask/balaclava/threehole

/datum/loadout_item/mask/balaclavagreen
	name = "巴拉克拉瓦头套 - 三孔式（绿色）"
	item_path = /obj/item/clothing/mask/balaclava/threehole/green

/*
*	GAS MASKS
*/

/datum/loadout_item/mask/gas_mask
	name = "防毒面具"
	item_path = /obj/item/clothing/mask/gas

/datum/loadout_item/mask/gas_alt
	name = "防毒面具 - 替代款"
	item_path = /obj/item/clothing/mask/gas/alt

/datum/loadout_item/mask/gas_glass
	name = "防毒面具 - 玻璃款"
	item_path = /obj/item/clothing/mask/gas/glass

/datum/loadout_item/mask/respirator
	name = "半面式呼吸器"
	item_path = /obj/item/clothing/mask/gas/respirator

/datum/loadout_item/mask/cyborg_mask
	name = "Cyborg Mask"
	item_path = /obj/item/clothing/mask/gas/cyborg

/*
*	COSTUME
*/

/datum/loadout_item/mask/fake_mustache
	name = "假胡子"
	item_path = /obj/item/clothing/mask/fakemoustache
	group = "Costumes"

/datum/loadout_item/mask/joy
	name = "喜悦面具"
	item_path = /obj/item/clothing/mask/joy
	group = "Costumes"

/datum/loadout_item/mask/kitsune
	name = "狐面"
	item_path = /obj/item/clothing/mask/kitsune
	group = "Costumes"

/datum/loadout_item/mask/monkey
	name = "猴子面具"
	item_path = /obj/item/clothing/mask/gas/monkeymask
	group = "Costumes"

/datum/loadout_item/mask/owl
	name = "猫头鹰面具"
	item_path = /obj/item/clothing/mask/gas/owl_mask
	group = "Costumes"

/datum/loadout_item/mask/pink_clown_wig
	name = "粉色小丑假发"
	item_path = /obj/item/clothing/mask/gas/pink_clown_wig
	group = "Costumes"

/datum/loadout_item/mask/paper
	name = "纸面具"
	item_path = /obj/item/clothing/mask/paper
	group = "Costumes"

/datum/loadout_item/mask/plague_doctor
	name = "瘟疫医生面具"
	item_path = /obj/item/clothing/mask/gas/plaguedoctor
	group = "Costumes"

/datum/loadout_item/mask/rebellion
	name = "反抗军面具"
	item_path = /obj/item/clothing/mask/rebellion
	group = "Costumes"

// MASQUERADE MASKS
/datum/loadout_item/mask/masquerade
	name = "化装舞会面具"
	item_path = /obj/item/clothing/mask/masquerade
	group = "Costumes"

/datum/loadout_item/mask/masquerade/two_colors
	name = "化装舞会面具 - 分色款"
	item_path = /obj/item/clothing/mask/masquerade/two_colors
	group = "Costumes"

/datum/loadout_item/mask/masquerade/feathered
	name = "化装舞会面具 - 羽饰款"
	item_path = /obj/item/clothing/mask/masquerade/feathered
	group = "Costumes"

/datum/loadout_item/mask/masquerade/two_colors/feathered
	name = "化装舞会面具 - 羽饰分色款"
	item_path = /obj/item/clothing/mask/masquerade/two_colors/feathered
	group = "Costumes"

/*
*	JOB-LOCKED
*/
// No group (groups should be ~5+ items)

/datum/loadout_item/mask/whistlesec
	name = "警哨"
	item_path = /obj/item/clothing/mask/whistle
	restricted_roles = list(ALL_JOBS_SEC)

/*
*	DONATOR
*/

/datum/loadout_item/mask/donator
	abstract_type = /datum/loadout_item/mask/donator
	donator_only = TRUE
