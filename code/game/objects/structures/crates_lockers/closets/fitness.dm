/obj/structure/closet/athletic_mixed
	name = "运动员衣柜"
	desc = "储存运动员衣物的单位。"
	icon_door = "mixed"

/obj/structure/closet/athletic_mixed/PopulateContents()
	..()
	new /obj/item/clothing/under/shorts/purple(src)
	new /obj/item/clothing/under/shorts/grey(src)
	new /obj/item/clothing/under/shorts/black(src)
	new /obj/item/clothing/under/shorts/red(src)
	new /obj/item/clothing/under/shorts/blue(src)
	new /obj/item/clothing/under/shorts/green(src)
	new /obj/item/clothing/under/costume/jabroni(src)

/obj/structure/closet/boxinggloves
	name = "拳击手套柜"
	desc = "一个专门用于存放拳击手套的存储单元。"
	icon_door = "mixed"

/obj/structure/closet/boxinggloves/PopulateContents()
	..()
	new /obj/item/clothing/gloves/boxing/blue(src)
	new /obj/item/clothing/gloves/boxing/green(src)
	new /obj/item/clothing/gloves/boxing/yellow(src)
	new /obj/item/clothing/gloves/boxing(src)

/obj/structure/closet/masks
	name = "面具衣橱"
	desc = "一个专门用于存放搏击面具的存储单元，嗷！"

/obj/structure/closet/masks/PopulateContents()
	..()
	new /obj/item/clothing/mask/luchador(src)
	new /obj/item/clothing/mask/luchador/rudos(src)
	new /obj/item/clothing/mask/luchador/tecnicos(src)

/obj/structure/closet/lasertag/red
	name = "红色镭射标记设备"
	desc = "一个专门用于存放镭射标记设备的存储单元。"
	icon_door = "red"
	icon_state = "rack"

/obj/structure/closet/lasertag/red/PopulateContents()
	..()
	for(var/i in 1 to 3)
		new /obj/item/gun/energy/laser/redtag(src)
	for(var/i in 1 to 3)
		new /obj/item/clothing/suit/redtag(src)
	new /obj/item/clothing/head/helmet/taghelm/red(src)


/obj/structure/closet/lasertag/blue
	name = "蓝色镭射标记设备"
	desc = "一个专门用于存放镭射标记设备的存储单元。"
	icon_door = "blue"
	icon_state = "rack"

/obj/structure/closet/lasertag/blue/PopulateContents()
	..()
	for(var/i in 1 to 3)
		new /obj/item/gun/energy/laser/bluetag(src)
	for(var/i in 1 to 3)
		new /obj/item/clothing/suit/bluetag(src)
	new /obj/item/clothing/head/helmet/taghelm/blue(src)
