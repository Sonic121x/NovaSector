/obj/structure/closet/secure_closet/des_two/medical
	icon_state = "med_secure"
	name = "医疗装备储物柜"

/obj/item/storage/bag/garment/syndicate_medical
	name = "医疗衣物袋"
	desc = "一个用于存放额外衣物和鞋子的袋子。这个属于医疗部门。"

/obj/item/storage/bag/garment/syndicate_medical/PopulateContents()
	new /obj/item/clothing/gloves/latex/nitrile/ntrauma(src)
	new /obj/item/clothing/suit/toggle/labcoat/interdyne(src)
	new /obj/item/clothing/suit/toggle/labcoat/interdyne(src)
	new /obj/item/clothing/glasses/hud/ar/aviator/health(src)
	new /obj/item/clothing/glasses/hud/ar/aviator/health(src)

/obj/structure/closet/secure_closet/des_two/medical/PopulateContents()
	..()

	new /obj/item/storage/belt/medbandolier(src)
	new /obj/item/storage/belt/medbandolier(src)
	new /obj/item/storage/bag/garment/syndicate_medical(src)
