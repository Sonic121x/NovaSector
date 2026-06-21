/obj/item/clothing/shoes/sandal
	desc = "一双很普通的木制凉鞋。"
	name = "凉鞋"
	icon_state = "wizard"
	inhand_icon_state = "wizshoe"
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT)
	resistance_flags = FLAMMABLE
	strip_delay = 0.5 SECONDS
	equip_delay_other = 5 SECONDS
	armor_type = /datum/armor/shoes_sandal
	fastening_type = SHOES_SLIPON
	species_exception = list(/datum/species/golem)
	lace_time = 3 SECONDS
	clothing_flags = parent_type::clothing_flags | CARP_STYLE_FACTOR

/obj/item/clothing/shoes/sandal/alt
	name = "黑色凉鞋"
	desc = "一双闪亮的黑色木制凉鞋。"
	icon_state = "blacksandals"
	inhand_icon_state = "blacksandals"

/datum/armor/shoes_sandal
	bio = 10

/obj/item/clothing/shoes/sandal/magic
	name = "魔法凉鞋"
	desc = "一双附有魔法的凉鞋。"
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/clothing/shoes/sandal/beach
	name = "人字拖"
	desc = "一双非常时尚的人字拖。"

/obj/item/clothing/shoes/sandal/velcro
	name = "魔术贴凉鞋"
	desc = "A pair of wooden sandals that have been 'upgraded' with velcro straps in order to comply with corporate uniform policy."
	fastening_type = SHOES_VELCRO

/obj/item/clothing/shoes/sandal/alt/velcro
	name = "黑色魔术贴凉鞋"
	desc = "A pair of shiny black sandals that have been 'upgraded' with velcro straps in order to comply with corporate uniform policy."
	fastening_type = SHOES_VELCRO
