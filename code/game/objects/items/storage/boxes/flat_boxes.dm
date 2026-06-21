/obj/item/storage/box/flat
	name = "扁平纸箱"
	desc = "一种以最利于隐藏而非存放物品的方式折叠的纸板箱。"
	icon_state = "flat"
	illustration = null
	storage_type = /datum/storage/box/flat

/obj/item/storage/box/flat/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/undertile, TRAIT_T_RAY_VISIBLE, INVISIBILITY_OBSERVER, use_anchor = TRUE, tilt_tile = TRUE)

/obj/item/storage/box/proc/flatten_box()
	if(istype(loc, /obj/item/storage) || type != /obj/item/storage/box || contents.len)
		return

	var/obj/flat_box = new /obj/item/storage/box/flat(drop_location())
	playsound(src, 'sound/items/handling/materials/cardboard_drop.ogg', 50, TRUE)

	flat_box.pixel_x = pixel_x
	flat_box.pixel_y = pixel_y

	qdel(src)

/obj/item/storage/box/flat/fentanylpatches
	name = "隐蔽盒子"
	desc = "一个装有若干无标记透皮贴片的小盒子。"
	icon_state = "flat"

/obj/item/storage/box/flat/fentanylpatches/Initialize(mapload)
	. = ..()
	for(var/i = 1 to 3)
		new /obj/item/reagent_containers/applicator/patch/fent(src)
