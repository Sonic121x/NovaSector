/obj/item/clothing/shoes/laceup
	name = "系带鞋"
	desc = "这可是时尚的巅峰之作，而且它们都经过了精心打磨！"
	icon_state = "laceups"
	equip_delay_other = 5 SECONDS
	clothing_flags = parent_type::clothing_flags | CARP_STYLE_FACTOR

/obj/item/clothing/shoes/laceup/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, 3) //You aren't going to fish with these are you?
