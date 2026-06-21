/*
 * Ring Box
 */

/obj/item/storage/fancy/ringbox
	name = "戒指盒"
	desc = "一个覆盖着柔软红色毛毡的小盒子，用于存放戒指。"
	icon = 'modular_nova/master_files/icons/obj/ring.dmi'
	icon_state = "gold ringbox"
	base_icon_state = "gold ringbox"
	w_class = WEIGHT_CLASS_TINY
	spawn_type = /obj/item/clothing/gloves/ring
	spawn_count = 1

/obj/item/storage/fancy/ringbox/Initialize(mapload)
	. = ..()
	atom_storage.max_slots = 1
	atom_storage.can_hold = typecacheof(list(/obj/item/clothing/gloves/ring))

/obj/item/storage/fancy/ringbox/diamond
	icon_state = "diamond ringbox"
	base_icon_state = "diamond ringbox"
	spawn_type = /obj/item/clothing/gloves/ring/diamond

/obj/item/storage/fancy/ringbox/silver
	icon_state = "silver ringbox"
	base_icon_state = "silver ringbox"
	spawn_type = /obj/item/clothing/gloves/ring/silver
