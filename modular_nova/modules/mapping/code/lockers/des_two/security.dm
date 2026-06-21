/obj/structure/closet/secure_closet/des_two/prisoner_locker
	name = "囚犯物品柜"
	req_access = list("syndicate_leader")

/obj/structure/closet/secure_closet/des_two/brig_officer_locker
	icon_door = "sec"
	icon_state = "sec"
	name = "禁闭室军官装备柜"
	req_access = list("syndicate_leader")

/obj/item/clothing/suit/toggle/jacket/nova/sec/old/syndicate
	name = "禁闭室军官夹克"

/obj/item/clothing/accessory/armband/syndicate
	name = "禁闭室军官臂章"
	desc ="一种臂章，由前哨基地的行动人员佩戴，以显示他们被分配到的部门。"

/obj/item/storage/bag/garment/brig_officer
	name = "禁闭室军官服装袋"
	desc = "一个用于存放额外衣物和鞋子的袋子。这个属于一位禁闭室军官。"

/obj/item/storage/bag/garment/brig_officer/PopulateContents()
	new /obj/item/clothing/under/rank/security/nova/utility/syndicate(src)
	new /obj/item/clothing/head/beret/sec/syndicate(src)
	new /obj/item/clothing/accessory/armband(src)
	new /obj/item/clothing/mask/gas/syndicate(src)
	new /obj/item/clothing/suit/toggle/jacket/nova/sec/old/syndicate(src)
	new /obj/item/clothing/mask/neck_gaiter(src)
	new /obj/item/clothing/glasses/hud/security/sunglasses/eyepatch(src)
	new /obj/item/clothing/glasses/hud/security/sunglasses(src)

/obj/structure/closet/secure_closet/des_two/brig_officer_locker/PopulateContents()
	..()

	new /obj/item/storage/belt/security/full(src)
	new /obj/item/storage/bag/garment/brig_officer(src)
	new /obj/item/radio/headset/interdyne(src)

/obj/structure/closet/secure_closet/des_two/brig_officer_locker/populate_contents_immediate()
	. = ..()

	new /obj/item/gun/energy/disabler(src)

/obj/structure/closet/secure_closet/des_two/armory_gear_locker
	anchored = 1
	icon = 'modular_nova/master_files/icons/obj/closet.dmi'
	icon_door = "riot"
	icon_state = "riot"
	name = "军械库装备柜"
	req_access = list("syndicate_leader")

/obj/structure/closet/secure_closet/des_two/armory_gear_locker/PopulateContents()
	..()

	new /obj/item/storage/belt/holster/nukie(src)
	new /obj/item/storage/belt/holster/nukie(src)
	new /obj/item/storage/belt/holster/nukie(src)
	new /obj/item/clothing/suit/armor/vest(src)
	new /obj/item/clothing/suit/armor/vest(src)
	new /obj/item/clothing/suit/armor/vest(src)
	new /obj/item/storage/belt/military(src)
	new /obj/item/storage/belt/military(src)
	new /obj/item/storage/belt/military(src)
	new /obj/item/clothing/head/helmet(src)
	new /obj/item/clothing/head/helmet(src)
	new /obj/item/clothing/head/helmet(src)

/obj/structure/closet/secure_closet/des_two/munitions_locker
	anchored = 1;
	icon = 'modular_nova/master_files/icons/obj/closet.dmi'
	icon_door = "riot"
	icon_state = "riot"
	name = "军械库弹药柜"

/obj/structure/closet/secure_closet/des_two/munitions_locker/PopulateContents()
	..()

	generate_items_inside(list(
		/obj/item/ammo_box/magazine/c35sol_pistol = 6,
		/obj/item/ammo_box/magazine/c35sol_pistol/stendo = 2,
		/obj/item/ammo_box/c35sol = 2,
		/obj/item/ammo_box/magazine/c40sol_rifle/standard = 2,
		/obj/item/ammo_box/c40sol = 2,
		/obj/item/ammo_box/advanced/s12gauge = 2,
		/obj/item/ammo_box/advanced/s12gauge/rubber = 2,
	),src)
