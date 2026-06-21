// GENERIC
/obj/item/card/id/advanced/silver/generic
	name = "通用银色身份卡"
	icon = 'modular_nova/master_files/icons/obj/card.dmi'
	icon_state = "card_silvergen"
	assigned_icon_state = null

/obj/item/card/id/advanced/gold/generic
	name = "通用金色身份卡"
	icon = 'modular_nova/master_files/icons/obj/card.dmi'
	icon_state = "card_goldgen"
	assigned_icon_state = null

// Interdyne (Deck Officer's)
/obj/item/card/id/advanced/chameleon/elite/black/silver
	name = "银色身份卡"
	desc = "一张象征荣誉与奉献的银色卡片。"
	icon_state = "card_silver"
	inhand_icon_state = "silver_id"
	assigned_icon_state = "assigned_silver"

// DS2
/obj/item/card/id/advanced/prisoner/ds2
	name = "辛迪加囚犯卡"
	icon = 'modular_nova/master_files/icons/obj/card.dmi'
	icon_state = "card_ds2prisoner"

// SOLFED
/obj/item/card/id/advanced/solfed
	name = "太阳联邦身份卡"
	icon = 'modular_nova/master_files/icons/obj/card.dmi'
	icon_state = "card_solfed"
	assigned_icon_state = "assigned_solfed"

// Station CC
/obj/item/card/id/advanced/centcom/station
	wildcard_slots = WILDCARD_LIMIT_SILVER

/obj/item/card/id/examine_more(mob/user)
	. = ..()

	if(ACCESS_WEAPONS in GetAccess())
		. += span_info("此ID授权持卡人携带大型枪械和自动武器。")
	else
		. += span_info("此ID不授权持卡人携带大型枪械或自动武器。")
