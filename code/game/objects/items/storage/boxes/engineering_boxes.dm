// This file contains all boxes used by the Engineering department and its purpose on the station. Also contains stuff we use when we wanna fix up stuff as well or helping us live when shit goes southwardly.

/obj/item/storage/box/metalfoam
	name = "金属泡沫手雷盒"
	desc = "用于快速封堵船体破口。"
	illustration = "grenade"

/obj/item/storage/box/metalfoam/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/grenade/chem_grenade/metalfoam(src)

/obj/item/storage/box/smart_metal_foam
	name = "智能金属泡沫手雷盒"
	desc = "用于快速封堵船体破口。这种类型会贴合所在区域的墙壁形状。"
	illustration = "grenade"

/obj/item/storage/box/smart_metal_foam/PopulateContents()
	for(var/i in 1 to 7)
		new/obj/item/grenade/chem_grenade/smart_metal_foam(src)

/obj/item/storage/box/debugtools
	name = "调试工具盒"
	icon_state = "syndiebox"
	storage_type = /datum/storage/box/debug

/obj/item/storage/box/debugtools/PopulateContents()
	var/list/items_inside = list(
		/obj/item/card/emag=1,
		/obj/item/construction/rcd/combat/admin=1,
		/obj/item/disk/tech_disk/debug=1,
		/obj/item/flashlight/emp/debug=1,
		/obj/item/geiger_counter=1,
		/obj/item/healthanalyzer/advanced=1,
		/obj/item/modular_computer/pda/heads/captain=1,
		/obj/item/pipe_dispenser=1,
		/obj/item/stack/spacecash/c1000=50,
		/obj/item/storage/box/beakers/bluespace=1,
		/obj/item/storage/box/beakers/variety=1,
		/obj/item/storage/bag/sheetsnatcher/debug=1,
		/obj/item/uplink/debug=1,
		/obj/item/uplink/nuclear/debug=1,
		/obj/item/clothing/ears/earmuffs/debug=1,
		/obj/item/gps/visible_debug=1,
		/obj/item/clothing/glasses/meson/engine/admin=1,
		)
	generate_items_inside(items_inside, src)

/obj/item/storage/box/plastic
	name = "塑料盒"
	desc = "这是一个坚固的塑料外壳盒子。"
	icon_state = "plasticbox"
	foldable_result = null
	illustration = "writing"
	custom_materials = list(/datum/material/plastic = HALF_SHEET_MATERIAL_AMOUNT) //You lose most if recycled.

/obj/item/storage/box/emergencytank
	name = "应急氧气罐盒"
	desc = "一盒应急氧气罐。"
	illustration = "emergencytank"

/obj/item/storage/box/emergencytank/PopulateContents()
	..()
	for(var/i in 1 to 7)
		new /obj/item/tank/internals/emergency_oxygen(src) //in case anyone ever wants to do anything with spawning them, apart from crafting the box

/obj/item/storage/box/engitank
	name = "扩容应急氧气罐盒"
	desc = "一盒扩容应急氧气罐。"
	illustration = "extendedtank"

/obj/item/storage/box/engitank/PopulateContents()
	..()
	for(var/i in 1 to 7)
		new /obj/item/tank/internals/emergency_oxygen/engi(src) //in case anyone ever wants to do anything with spawning them, apart from crafting the box

/obj/item/storage/box/stickers/chief_engineer
	name = "总工程师认证贴纸包"
	desc = "用这些贴纸之一，告知船员走廊里的装置绝对安全！"
	illustration = "label_ce"

/obj/item/storage/box/stickers/chief_engineer/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/sticker/chief_engineer(src)
