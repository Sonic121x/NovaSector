/obj/item/folder/blue
	desc = "一个蓝色文件夹。"
	icon_state = "folder_blue"
	bg_color = "#355e9f"

/obj/item/folder/red
	desc = "一个红色文件夹。"
	icon_state = "folder_red"
	bg_color = "#b5002e"

/obj/item/folder/yellow
	desc = "一个黄色文件夹。"
	icon_state = "folder_yellow"
	bg_color = "#b88f3d"

/obj/item/folder/white
	desc = "一个白色文件夹。"
	icon_state = "folder_white"
	bg_color = "#d9d9d9"

/obj/item/folder/documents
	name = "文件夹-'最高机密'"
	desc = "一个贴有“绝密 - 纳米传讯所有。未经授权传播将处以死刑”字样的文件夹。"

/obj/item/folder/documents/Initialize(mapload)
	. = ..()
	new /obj/item/documents/nanotrasen(src)
	update_appearance()

/obj/item/folder/syndicate
	icon_state = "folder_syndie"
	bg_color = "#3f3f3f"
	name = "文件夹-'最高机密'"
	desc = "一个盖有“绝密 -辛迪加财产”印章的文件夹。"

/obj/item/folder/syndicate/red
	icon_state = "folder_sred"

/obj/item/folder/syndicate/red/Initialize(mapload)
	. = ..()
	new /obj/item/documents/syndicate/red(src)
	update_appearance()

/obj/item/folder/syndicate/blue
	icon_state = "folder_sblue"

/obj/item/folder/syndicate/blue/Initialize(mapload)
	. = ..()
	new /obj/item/documents/syndicate/blue(src)
	update_appearance()

/obj/item/folder/syndicate/mining/Initialize(mapload)
	. = ..()
	new /obj/item/documents/syndicate/mining(src)
	update_appearance()

/obj/item/folder/ancient_paperwork/Initialize(mapload)
	. = ..()
	new /obj/item/paperwork/ancient(src)
	update_appearance()
