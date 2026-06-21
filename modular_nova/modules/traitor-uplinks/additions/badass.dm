// LOW COST
/datum/uplink_item/badass/guerilla_gloves
	name = "游击手套"
	desc = "一副极其坚固的战斗抓握手套，擅长在近距离执行制服动作，并额外衬有绝缘层。小心别打到墙！"
	item = /obj/item/clothing/gloves/tackler/combat/insulated
	cost = 1
	uplink_item_flags = NONE
	purchasable_from = UPLINK_TRAITORS | UPLINK_SERIOUS_OPS

/datum/uplink_item/badass/combat_shoes
	name = "战斗长筒靴"
	desc = "高速、低阻力的战斗靴。"
	item = /obj/item/clothing/shoes/combat
	cost = 1
	uplink_item_flags = NONE
	purchasable_from = UPLINK_TRAITORS | UPLINK_SERIOUS_OPS

/datum/uplink_item/badass/bulletproof_armor
	name = "防弹背心"
	desc = "一件 III 型重型防弹背心，在保护穿戴者免受传统抛射武器和一定程度爆炸伤害方面表现出色。"
	item = /obj/item/clothing/suit/armor/bulletproof
	cost = /datum/uplink_item/low_cost::cost
	uplink_item_flags = NONE
	purchasable_from = UPLINK_TRAITORS | UPLINK_SERIOUS_OPS

/datum/uplink_item/badass/swat_helmet
	name = "辛迪加头盔"
	desc = "一顶极其坚固、适合太空环境的头盔，带有不祥的红黑条纹图案。"
	item = /obj/item/clothing/head/helmet/swat
	cost = /datum/uplink_item/low_cost::cost
	uplink_item_flags = NONE
	purchasable_from = UPLINK_TRAITORS | UPLINK_SERIOUS_OPS

/datum/uplink_item/badass/henchmen_traitor_outfits
	name = "Henchmen Bundle"
	desc = "A set of five armored henchmen outfits! Each set comes with a cap, coat, uniform, gloves, shoes, and a switchblade!"
	item = /obj/item/storage/backpack/duffelbag/henchmen_traitor_outfits
	cost = 4

/obj/item/clothing/head/henchmen_hat/traitor
	name = "armored henchmen cap"
	desc = "Alright boss.. I'll handle it. It seems to be armored."
	armor_type = /datum/armor/suit_armor
	greyscale_colors = "#240d0d"

/obj/item/clothing/suit/jacket/henchmen_coat/traitor
	name = "armored henchmen coat"
	desc = "Alright boss.. I'll handle it. It seems to be armored."
	armor_type = /datum/armor/suit_armor
	greyscale_colors = "#240d0d"

/obj/item/storage/box/syndicate/henchmen_traitor_outfit
	name = "henchmen outfit box"

/obj/item/storage/box/syndicate/henchmen_traitor_outfit/PopulateContents()
	var/static/items_inside = list(
		/obj/item/clothing/head/henchmen_hat/traitor = 1,
		/obj/item/clothing/suit/jacket/henchmen_coat/traitor = 1,
		/obj/item/clothing/under/color/black = 1,
		/obj/item/clothing/gloves/color/light_brown = 1,
		/obj/item/clothing/shoes/laceup = 1,
		/obj/item/switchblade = 1,
	)
	generate_items_inside(items_inside,src)

/obj/item/storage/backpack/duffelbag/henchmen_traitor_outfits
/obj/item/storage/backpack/duffelbag/henchmen_traitor_outfits/PopulateContents()
	var/static/items_inside = list(
		/obj/item/storage/box/syndicate/henchmen_traitor_outfit = 5,
	)
	generate_items_inside(items_inside,src)


// MEDIUM COST

/datum/uplink_item/bundles_tc/bunny
	name = "Syndicate Bunny Kit"
	desc = "Straight from the dens of Carota. The Tactical Rabbit Ensemble. \
		Made for Tactical Rabbit Action, it's been adapted for use by the Syndicate, your welcome. \
		This kit contains one armor-lined rabbit costume, and one single carrot shiv. (Carrot shiv may be eaten in transit.)"
	item = /obj/item/storage/box/syndibunny
	cost = 8

/obj/item/storage/box/syndibunny
	name = "Syndicate Bunny Assassin Outfit"
	desc = "A box containing a high tech specialized syndicate... bunny suit?"
	icon_state = "syndiebox"

/obj/item/storage/box/syndibunny/PopulateContents()
	generate_items_inside(list(
		/obj/item/clothing/head/playbunnyears/syndicate = 1,
		/obj/item/clothing/under/syndicate/syndibunny = 1,
		/obj/item/clothing/suit/jacket/tailcoat/syndicate = 1,
		/obj/item/clothing/neck/tie/bunnytie/syndicate = 1,
		/obj/item/clothing/shoes/fancy_heels/syndi = 1,
	), src)

// HIGH COST
