// This file contains all boxes used by the Cargo department and its purpose on the station.

/obj/item/storage/box/shipping
	name = "一箱运输用品"
	desc = "包含用于运输物品的若干扫描仪和标签机。包装纸不包含在内。"
	illustration = "shipping"

/obj/item/storage/box/shipping/PopulateContents()
	var/list/items_inside = list(
		/obj/item/dest_tagger = 1,
		/obj/item/universal_scanner = 1,
		/obj/item/stack/package_wrap/small = 2,
		/obj/item/stack/wrapping_paper/small = 1,
	)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/shipping/debug
	name = "box of bigger shipping supplies"
	desc = "Everything you need to make your own cargo department."

/obj/item/storage/box/shipping/debug/PopulateContents()
	var/list/items_inside = list(
		/obj/item/universal_scanner = 1,
		/obj/item/stack/package_wrap/small = 2,
		/obj/item/stack/wrapping_paper/small = 2,
		/obj/item/boulder_beacon = 1,
		/obj/item/stack/conveyor/thirty = 1,
		/obj/item/conveyor_switch_construct = 1,
		/obj/item/construction/plumbing = 1,
	)
	generate_items_inside(items_inside,src)
