/// Shoe Slot Items (Deletes overrided items)
/datum/loadout_category/shoes
	category_name = "Shoes"
	category_ui_icon = FA_ICON_SHOE_PRINTS
	type_to_generate = /datum/loadout_item/shoes
	tab_order = 1

/datum/loadout_item/shoes
	abstract_type = /datum/loadout_item/shoes

/datum/loadout_item/shoes/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE)
	outfit.shoes = item_path
/* // NOVA EDIT REMOVAL START
/datum/loadout_item/shoes/sneakers
	name = "Sneakers"
	item_path = /obj/item/clothing/shoes/sneakers
*/ // NOVA EDIT REMOVAL END
/datum/loadout_item/shoes/sandals_laced
	name = "凉鞋（魔术贴）"
	item_path = /obj/item/clothing/shoes/sandal/velcro

/datum/loadout_item/shoes/sandals_laced_black
	name = "凉鞋（黑色，魔术贴）"
	item_path = /obj/item/clothing/shoes/sandal/alt/velcro

/datum/loadout_item/shoes/laceup
	name = "鞋子（系带）"
	item_path = /obj/item/clothing/shoes/laceup

/datum/loadout_item/shoes/cowboy_brown
	name = "靴子（牛仔，棕色）"
	item_path = /obj/item/clothing/shoes/cowboy/laced

/datum/loadout_item/shoes/cowboy_white
	name = "靴子（牛仔，白色）"
	item_path = /obj/item/clothing/shoes/cowboy/white/laced

/datum/loadout_item/shoes/cowboy_black
	name = "靴子（牛仔，黑色）"
	item_path = /obj/item/clothing/shoes/cowboy/black/laced

/datum/loadout_item/shoes/glow_shoes
	name = "鞋子（发光，可着色）"
	item_path = /obj/item/clothing/shoes/glow

/datum/loadout_item/shoes/jackboots
	name = "工作靴（黑色）"
	item_path = /obj/item/clothing/shoes/workboots/black
