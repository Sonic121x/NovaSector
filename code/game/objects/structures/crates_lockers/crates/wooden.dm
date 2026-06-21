/obj/structure/closet/crate/wooden
	name = "木板箱"
	desc = "就像金属做的一样好。"
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 6)
	material_drop = /obj/item/stack/sheet/mineral/wood
	material_drop_amount = 6
	icon_state = "wooden"
	base_icon_state = "wooden"
	open_sound = 'sound/machines/closet/wooden_closet_open.ogg'
	close_sound = 'sound/machines/closet/wooden_closet_close.ogg'
	open_sound_volume = 25
	close_sound_volume = 50
	paint_jobs = null
	cutting_tool = /obj/item/crowbar
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 6)

/obj/structure/closet/crate/wooden/toy
	name = "玩具盒"
	desc = "下面用记号笔写着\"小丑 + 默剧\"。"

/obj/structure/closet/crate/wooden/toy/PopulateContents()
	. = ..()
	new /obj/item/megaphone/clown(src)
	new /obj/item/reagent_containers/cup/soda_cans/canned_laughter(src)
	new /obj/item/pneumatic_cannon/pie(src)
	new /obj/item/food/pie/cream(src)
	new /obj/item/storage/crayons(src)
