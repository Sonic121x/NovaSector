/obj/item/storage/fish_case/donkfish
	name = "\improper Donk公司促销鱼箱"

/obj/item/storage/fish_case/donkfish/PopulateContents()
	. = ..()
	new /obj/item/fish/donkfish(src)
