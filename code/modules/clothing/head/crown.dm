/obj/item/clothing/head/costume/crown
	name = "王冠"
	desc = "适合国王的王冠，也许只是个小小的国王。"
	icon_state = "crown"
	armor_type = /datum/armor/costume_crown
	resistance_flags = FIRE_PROOF
	custom_materials = list(/datum/material/gold = SHEET_MATERIAL_AMOUNT * 5)

/datum/armor/costume_crown
	melee = 15
	energy = 10
	fire = 100
	acid = 50
	wound = 5

/obj/item/clothing/head/costume/crown/fancy
	name = "精致华丽的王冠"
	desc = "只有<s>最高皇帝</s>才能戴上的王冠"
	icon_state = "fancycrown"
