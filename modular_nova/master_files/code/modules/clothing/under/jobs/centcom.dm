//This file is for any station-aligned or neutral factions, not JUST Nanotrasen.
//Try to keep them all a subtype of centcom/nova, for file sorting and balance - all faction representatives should have the same/similarly armored uniforms

/obj/item/clothing/under/rank/centcom
	worn_icon_digi = 'modular_nova/master_files/icons/mob/clothing/under/centcom_digi.dmi'

/obj/item/clothing/under/rank/centcom/nova
	icon = 'modular_nova/master_files/icons/obj/clothing/under/centcom.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/under/centcom.dmi'

/*
*	NANOTRASEN
*/
//Check modular_nova\modules\nanotrasen_naval_command\code\clothing.dm for more of these! (Or, currently, ALL of these.)

/*
*	LOPLAND (On the chopping block)
*/
/obj/item/clothing/under/rank/centcom/nova/lopland
	name = "\improper 承包商企业制服"
	desc = "一件由PMC公司人员穿着的修身连体服。它出人意料地衬垫良好。"
	icon_state = "lopland_shirt"
	worn_icon_state = "lopland_shirt"

/obj/item/clothing/under/rank/centcom/nova/lopland/instructor
	name = "\improper 承包商教官制服"
	desc = "一件由PMC认证教官穿着的、极其夸张的军国主义连体服，背后印着一个巨大的PMC标志。其口袋数量多到足以让一名星际陆战队员落泪。"
	icon_state = "lopland_tac"
	worn_icon_state = "lopland_tac"


/*
*	MISC
*/
// pizza and other misc ERTs in this file too?
