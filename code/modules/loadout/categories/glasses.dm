/// Glasses Slot Items (Moves overrided items to backpack)
/datum/loadout_category/glasses
	category_name = "Glasses"
	category_ui_icon = FA_ICON_GLASSES
	type_to_generate = /datum/loadout_item/glasses
	tab_order = /datum/loadout_category/head::tab_order + 1

/datum/loadout_item/glasses
	abstract_type = /datum/loadout_item/glasses

/datum/loadout_item/glasses/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE)
	if(outfit.glasses)
		LAZYADD(outfit.backpack_contents, outfit.glasses)
	outfit.glasses = item_path

/datum/loadout_item/glasses/regular
	name = "眼镜"
	item_path = /obj/item/clothing/glasses/regular

/datum/loadout_item/glasses/circle_glasses
	name = "圆形眼镜"
	item_path = /obj/item/clothing/glasses/regular/circle

/datum/loadout_item/glasses/hipster_glasses
	name = "复古眼镜"
	item_path = /obj/item/clothing/glasses/regular/hipster

/datum/loadout_item/glasses/jamjar_glasses
	name = "果酱瓶眼镜"
	item_path = /obj/item/clothing/glasses/regular/jamjar

/* NOVA EDIT REMOVAL - Already exists in our loadout
/datum/loadout_item/glasses/black_blindfold
	name = "Black Blindfold"
	item_path = /obj/item/clothing/glasses/blindfold
*/ // NOVA REMOVAL END

/datum/loadout_item/glasses/cold_glasses
	name = "防寒眼镜"
	item_path = /obj/item/clothing/glasses/cold

/datum/loadout_item/glasses/heat_glasses
	name = "热感眼镜"
	item_path = /obj/item/clothing/glasses/heat

/datum/loadout_item/glasses/orange_glasses
	name = "橙色眼镜"
	item_path = /obj/item/clothing/glasses/orange

/datum/loadout_item/glasses/red_glasses
	name = "红色眼镜"
	item_path = /obj/item/clothing/glasses/red

/datum/loadout_item/glasses/eyepatch
	name = "眼罩"
	item_path = /obj/item/clothing/glasses/eyepatch

/** NOVA EDIT REMOVAL - We already have it in the loadout.
/datum/loadout_item/glasses/eyepatch/medical
	name = "Medical Eyepatch"
	item_path = /obj/item/clothing/glasses/eyepatch/medical
*/ // NOVA EDIT REMOVAL END

/datum/loadout_item/glasses/kim
	name = "细框眼镜"
	item_path = /obj/item/clothing/glasses/regular/kim

/datum/loadout_item/glasses/monocle
	name = "单片眼镜"
	item_path = /obj/item/clothing/glasses/monocle
