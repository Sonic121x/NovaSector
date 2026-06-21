
/obj/item/storage/belt/holster
	name = "肩挂式枪套"
	desc = "一个相当朴素但看起来仍然很酷的枪套，可以容纳一把手枪。"
	icon_state = "holster"
	inhand_icon_state = "holster"
	worn_icon_state = "holster"
	alternate_worn_layer = UNDER_SUIT_LAYER
	w_class = WEIGHT_CLASS_BULKY
	storage_type = /datum/storage/holster

/obj/item/storage/belt/holster/equipped(mob/user, slot)
	. = ..()
	if(slot & (ITEM_SLOT_BELT|ITEM_SLOT_SUITSTORE))
		ADD_CLOTHING_TRAIT(user, TRAIT_GUNFLIP)

/obj/item/storage/belt/holster/dropped(mob/user)
	. = ..()
	REMOVE_CLOTHING_TRAIT(user, TRAIT_GUNFLIP)

/obj/item/storage/belt/holster/energy
	name = "能量武器肩挂枪套"
	desc = "一对相当朴素的肩挂枪套，内部有一些绝缘衬垫。设计用于容纳能量武器。"
	storage_type = /datum/storage/holster/energy

/obj/item/storage/belt/holster/energy/thermal
	name = "热能武器肩挂枪套"
	desc = "一副相当普通的肩挂式枪套，内部带有一点绝缘衬垫。旨在容纳一对双生热能手枪，但也能装下好几种能量手枪。"

/obj/item/storage/belt/holster/energy/thermal/PopulateContents()
	generate_items_inside(list(
		/obj/item/gun/energy/laser/thermal/inferno = 1,
		/obj/item/gun/energy/laser/thermal/cryo = 1,
	),src)

/obj/item/storage/belt/holster/energy/disabler
	desc = "一副相当普通的肩挂式枪套，内部带有一点绝缘衬垫。设计用于容纳能量武器。生产标记表明它出厂时配有一把眩晕枪。"

/obj/item/storage/belt/holster/energy/disabler/PopulateContents()
	new /obj/item/gun/energy/disabler(src)

/obj/item/storage/belt/holster/energy/laser_pistol
	desc = "一副相当普通的肩挂式枪套，内部带有一点绝缘衬垫。设计用于容纳能量武器。生产标记表明它出厂时配有一把5C型激光手枪。"

/obj/item/storage/belt/holster/energy/laser_pistol/PopulateContents()
	new /obj/item/gun/energy/laser/pistol(src)

/obj/item/storage/belt/holster/energy/smoothbore
	desc = "一副相当普通的肩挂式枪套，内部带有一点绝缘衬垫。设计用于容纳能量武器。看起来它原本是用来装两把滑膛枪的。"

/obj/item/storage/belt/holster/energy/smoothbore/PopulateContents()
	generate_items_inside(list(
		/obj/item/gun/energy/disabler/smoothbore = 2,
	),src)

/obj/item/storage/belt/holster/detective
	name = "侦探枪套"
	desc = "一个能携带手枪和一些弹药的枪套。警告：仅供狠人使用。"
	w_class = WEIGHT_CLASS_BULKY
	storage_type = /datum/storage/holster/detective

/obj/item/storage/belt/holster/detective/full/PopulateContents()
	generate_items_inside(list(
		/obj/item/ammo_box/speedloader/c38 = 2,
		/obj/item/gun/ballistic/revolver/c38/detective = 1,
	), src)

/obj/item/storage/belt/holster/detective/full/ert
	name = "陆战队员枪套"
	desc = "戴上这个让你感觉很酷，但你怀疑这只是从NT剩余物资里翻新喷漆的侦探枪套。"
	icon_state = "syndicate_holster"
	inhand_icon_state = "syndicate_holster"
	worn_icon_state = "syndicate_holster"

/obj/item/storage/belt/holster/detective/full/ert/PopulateContents()
	generate_items_inside(list(
		/obj/item/ammo_box/magazine/m45 = 2,
		/obj/item/gun/ballistic/automatic/pistol/m1911 = 1,
	),src)

/obj/item/storage/belt/holster/chameleon
	name = "辛迪加枪套"
	desc = "一种使用变色龙技术伪装自己的腰挂式枪套，由于增加了变色龙技术，它无法安装在护甲上。"
	icon_state = "syndicate_holster"
	inhand_icon_state = "syndicate_holster"
	worn_icon_state = "syndicate_holster"
	w_class = WEIGHT_CLASS_NORMAL
	actions_types = list(/datum/action/item_action/chameleon/change/belt)
	storage_type = /datum/storage/holster/chameleon

/obj/item/storage/belt/holster/nukie
	name = "特工枪套"
	desc = "一个深肩式枪套，能够容纳几乎所有类型的枪支及其弹药。"
	icon_state = "syndicate_holster"
	inhand_icon_state = "syndicate_holster"
	worn_icon_state = "syndicate_holster"
	w_class = WEIGHT_CLASS_BULKY
	storage_type = /datum/storage/holster/nukie

/obj/item/storage/belt/holster/nukie/cowboy
	desc = "一个深肩式枪套，能够容纳几乎所有类型的小型枪支及其弹药。这个是专门为手枪设计的。"
	storage_type = /datum/storage/holster/nukie/cowboy

/obj/item/storage/belt/holster/nukie/cowboy/full/PopulateContents()
	generate_items_inside(list(
		/obj/item/ammo_box/speedloader/c357 = 2,
		/obj/item/gun/ballistic/revolver/cowboy/nuclear = 1,
	), src)
