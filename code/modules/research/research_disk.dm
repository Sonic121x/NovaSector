
/obj/item/disk/tech_disk
	name = "科研数据盘"
	desc = "一个用于存储技术数据以供进一步研究的磁盘。"
	icon_state = "datadisk0"
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT * 3, /datum/material/glass=SMALL_MATERIAL_AMOUNT)
	var/datum/techweb/stored_research

/obj/item/disk/tech_disk/Initialize(mapload)
	. = ..()
	if(!stored_research)
		stored_research = new /datum/techweb/disk
	pixel_x = base_pixel_x + rand(-5, 5)
	pixel_y = base_pixel_y + rand(-5, 5)

/obj/item/disk/tech_disk/debug
	name = "\improper 中央指挥部科技磁盘"
	desc = "一个用于研究的调试物品"
	custom_materials = null

/obj/item/disk/tech_disk/debug/Initialize(mapload)
	stored_research = locate(/datum/techweb/admin) in SSresearch.techwebs
	return ..()
