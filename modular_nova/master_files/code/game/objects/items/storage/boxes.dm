// Most of these are just additions to allow certain cargo packs to exist. More will be on the way on additional PR's

/obj/item/storage/box/techshell
	name = "未装填技术弹壳盒"
	desc = "一盒技术弹壳。这些弹壳是未装填的，可用于定制装药。"

/obj/item/storage/box/techshell/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/ammo_casing/shotgun/techshell(src)

/obj/item/storage/box/lewd_toys
	name = "情趣玩具盒"
	desc = "内含用于独处或与他人共度时光的情趣用具！下次记得藏好点。"

/obj/item/storage/box/lewd_toys/PopulateContents()
	new /obj/item/clothing/sextoy/dildo(src)
	new /obj/item/clothing/sextoy/buttplug(src)
	new /obj/item/stack/shibari_rope/full(src)
	new /obj/item/spanking_pad(src)
	new /obj/item/clothing/mask/muzzle/ballgag(src)
	new /obj/item/clothing/suit/straight_jacket/shackles(src)
	new /obj/item/clothing/glasses/blindfold/dorms(src)
