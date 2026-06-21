/obj/item/storage/box/spaceman_ration
	name = "未标记的配给容器"
	desc = "你感觉这本不该寄给你？"
	icon = 'modular_nova/modules/paycheck_rations/icons/food_containers.dmi'
	icon_state = "plants"
	illustration = null
	/// How many storage slots this has, yes I'm being lazy
	var/box_storage_slots = 1

/obj/item/storage/box/spaceman_ration/Initialize(mapload)
	. = ..()
	atom_storage.max_slots = box_storage_slots

/obj/item/storage/box/spaceman_ration/PopulateContents()
	return

// Contains your daily need of plants, yum!

/obj/item/storage/box/spaceman_ration/plants
	name = "农产品配给容器"
	desc = "包含你分配的农产品配给，这里应该是豌豆和土豆。"
	box_storage_slots = 2

/obj/item/storage/box/spaceman_ration/plants/PopulateContents()
	new /obj/item/food/grown/peas(src)
	new /obj/item/food/grown/potato(src)

// Alternate diet, themed around martian food a bit more

/obj/item/storage/box/spaceman_ration/plants/alternate
	desc = "包含你分配的农产品配给，这里应该是卷心菜和洋葱。"
	icon_state = "plants_alt"

/obj/item/storage/box/spaceman_ration/plants/alternate/PopulateContents()
	new /obj/item/food/grown/cabbage(src)
	new /obj/item/food/grown/onion(src)

// For the moths amogus

/obj/item/storage/box/spaceman_ration/plants/mothic
	desc = "包含你分配的农产品配给，这里应该是辣椒和土豆。"
	icon_state = "plants_moth"

/obj/item/storage/box/spaceman_ration/plants/mothic/PopulateContents()
	new /obj/item/food/grown/chili(src)
	new /obj/item/food/grown/potato(src)

// For the lizards amongus

/obj/item/storage/box/spaceman_ration/plants/lizard
	desc = "包含你分配的农产品配给，这里应该是两颗科塔果和两个土豆。"
	icon_state = "plants_lizard"
	box_storage_slots = 4

/obj/item/storage/box/spaceman_ration/plants/lizard/PopulateContents()
	new /obj/item/food/grown/korta_nut(src)
	new /obj/item/food/grown/korta_nut(src)
	new /obj/item/food/grown/potato(src)
	new /obj/item/food/grown/potato(src)

// Contains your allotted meats, tasty!

/obj/item/storage/box/spaceman_ration/meats
	name = "肉类配给容器"
	desc = "包含你分配的肉类配给，这里应该是腌猪肉和一份随机配菜选项。"
	icon_state = "meats"

/obj/item/storage/box/spaceman_ration/meats/PopulateContents()
	new /obj/item/food/meat/slab/pig(src)
	var/secondary_meat = pick(/obj/item/food/raw_sausage, /obj/item/food/meat/slab/chicken, /obj/item/food/meat/slab/meatproduct)
	new secondary_meat(src)

// Seafood variant

/obj/item/storage/box/spaceman_ration/meats/fish
	desc = "包含你分配的肉类配给，这里应该是腌猪肉和一份随机海鲜配菜选项。"
	icon_state = "meats_fish"

/obj/item/storage/box/spaceman_ration/meats/fish/PopulateContents()
	new /obj/item/food/meat/slab/pig(src)
	var/secondary_meat = pick(/obj/item/food/meat/slab/rawcrab, /obj/item/food/fishmeat)
	new secondary_meat(src)

// For the lizards amongus

/obj/item/storage/box/spaceman_ration/meats/lizard
	desc = "包含你分配的肉类配给，这里应该是腌猪肉和一份随机海鲜配菜选项。"
	icon_state = "meats_lizard"

/obj/item/storage/box/spaceman_ration/meats/lizard/PopulateContents()
	new /obj/item/food/fishmeat/moonfish(src)
	var/secondary_meat = pick(/obj/item/food/raw_tiziran_sausage, /obj/item/food/liver_pate)
	new secondary_meat(src)

// Paper sack that spawns a random two slices of bread

/obj/item/storage/box/papersack/ration_bread_slice
	name = "面包奶酪配给袋"
	desc = "一个积满灰尘的旧纸袋，理想情况下应该装着你的面包和奶酪配给。"

/obj/item/storage/box/papersack/ration_bread_slice/Initialize(mapload)
	. = ..()
	atom_storage.max_slots = 3

/obj/item/storage/box/papersack/ration_bread_slice/PopulateContents()
	var/bread_slice = pick(/obj/item/food/breadslice/plain, /obj/item/food/breadslice/reispan, /obj/item/food/breadslice/root)
	new bread_slice(src)
	new bread_slice(src)
	var/cheese_slice = pick(/obj/item/food/cheese/wedge, /obj/item/food/cheese/firm_cheese_slice, /obj/item/food/cheese/cheese_curds, /obj/item/food/cheese/mozzarella)
	new cheese_slice(src)
