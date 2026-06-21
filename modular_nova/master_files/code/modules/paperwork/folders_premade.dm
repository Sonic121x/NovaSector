/obj/item/folder/ancient_paperwork/five
	name = "塞满的积尘文件夹"
	desc = "你相当确定文件夹不该塞得这么满，尤其是看起来这么旧的。"

/obj/item/folder/ancient_paperwork/five/Initialize(mapload)
	. = ..()
	// as we inherit the previous init, which generates one ancient paperwork, we initialize 4 more for 5 total
	new /obj/item/paperwork/ancient(src)
	new /obj/item/paperwork/ancient(src)
	new /obj/item/paperwork/ancient(src)
	new /obj/item/paperwork/ancient(src)
	update_appearance()
