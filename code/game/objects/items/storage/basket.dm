/obj/item/storage/basket
	name = "篮子"
	desc = "手工编织的篮子。"
	icon = 'icons/obj/storage/basket.dmi'
	icon_state = "basket"
	w_class = WEIGHT_CLASS_BULKY
	resistance_flags = FLAMMABLE
	storage_type = /datum/storage/basket

/obj/item/storage/basket/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/cuffable_item)
