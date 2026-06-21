/obj/structure/closet/secure_closet/des_two/science_gear
	icon_state = "science"
	name = "科学家装备储物柜"

/obj/item/clothing/accessory/armband/science/syndicate
	name = "研究员臂章"
	desc = "一种臂章，由前哨基地的行动人员佩戴，以显示他们所属的部门。"

/obj/item/storage/bag/garment/syndicate_scientist
	name = "科学家衣物袋"
	desc = "一个用于存放额外衣物和鞋子的袋子。这个属于一名科学家。"

/obj/item/storage/bag/garment/syndicate_scientist/PopulateContents()
	new /obj/item/clothing/suit/hooded/wintercoat/science(src)
	new /obj/item/clothing/suit/toggle/labcoat/science(src)
	new /obj/item/clothing/glasses/sunglasses/chemical(src)
	new /obj/item/clothing/under/rank/rnd/scientist/nova/utility/syndicate(src)
	new /obj/item/clothing/under/rank/rnd/scientist/nova/utility/syndicate(src)
	new /obj/item/clothing/accessory/armband/science/syndicate(src)
	new /obj/item/clothing/accessory/armband/science/syndicate(src)

/obj/structure/closet/secure_closet/des_two/science_gear/PopulateContents()
	..()

	new /obj/item/storage/bag/garment/syndicate_scientist(src)

/obj/structure/closet/secure_closet/des_two/robotics
	icon_state = "science"
	name = "机器人专家装备储物柜"

/obj/item/storage/bag/garment/syndicate_roboticist
	name = "机械师服装袋"
	desc = "一个用于存放额外衣物和鞋子的袋子。这个属于一位机械师。"

/obj/item/storage/bag/garment/syndicate_roboticist/PopulateContents()
	new /obj/item/clothing/suit/hooded/techpriest(src)
	new /obj/item/clothing/suit/toggle/labcoat/roboticist(src)
	new /obj/item/clothing/under/syndicate/nova/overalls/skirt(src)
	new /obj/item/clothing/under/syndicate/nova/overalls(src)
	new /obj/item/clothing/glasses/hud/ar/aviator/diagnostic(src)
	new /obj/item/clothing/glasses/hud/diagnostic(src)
	new /obj/item/clothing/suit/hooded/wintercoat/science/robotics(src)

/obj/structure/closet/secure_closet/des_two/robotics/PopulateContents()
	..()

	new /obj/item/storage/bag/garment/syndicate_scientist(src)
