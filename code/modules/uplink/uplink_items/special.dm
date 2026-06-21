/datum/uplink_category/special
	name = "特殊"
	weight = -3

/datum/uplink_item/special
	category = /datum/uplink_category/special
	cant_discount = TRUE
	surplus = 0
	purchasable_from = NONE

/datum/uplink_item/special/autosurgeon
	name = "辛迪加自动手术仪"
	desc = "一个多用途自动手术仪，用于将任何你想要的东西植入自身。把那空间站拆了，让它成为你的一部分。"
	item = /obj/item/autosurgeon/syndicate
	cost = 5

/datum/uplink_item/special/autosurgeon/New()
	..()
	if(HAS_TRAIT(SSstation, STATION_TRAIT_CYBERNETIC_REVOLUTION))
		purchasable_from |= UPLINK_TRAITORS
