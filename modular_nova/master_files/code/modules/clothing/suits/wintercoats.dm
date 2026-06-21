//File for modular wintercoats that aren't bundled with other stuff
//If the coat is part of a module (i.e. the Blueshield coat) then make sure it's subtyped under wintercoat/nova, but don't put it in this file!

//Coat Basetype (The Assistant's Formal Coat)
/obj/item/clothing/suit/hooded/wintercoat/nova
	name = "助手的正式冬季大衣"
	desc = "一件深灰色冬季大衣，带有青铜金色细节，拉链呈工具箱形状。"
	icon = 'modular_nova/master_files/icons/obj/clothing/suits/wintercoat.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/suits/wintercoat.dmi'
	icon_state = "coataformal"
	hoodtype = /obj/item/clothing/head/hooded/winterhood/nova

//Hood Basetype (The Assistant's Formal Coat Hood)
/obj/item/clothing/head/hooded/winterhood/nova
	icon = 'modular_nova/master_files/icons/obj/clothing/head/winterhood.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/head/winterhood.dmi'
	icon_state = "hood_aformal"

//Bartender
/obj/item/clothing/suit/hooded/wintercoat/nova/bartender
	name = "酒保的冬季大衣"
	desc = "一件用最初从厨师的山羊那里偷来的羊毛制成的厚重夹克。这个新设计旨在贴合经典的西装领带美学，同时避免体温过低。"
	icon_state = "coatbar"
	allowed = list(
		/obj/item/reagent_containers/cup/glass/shaker,
		/obj/item/reagent_containers/cup/glass/flask,
		/obj/item/rag
	)
	hoodtype = /obj/item/clothing/head/hooded/winterhood/nova/bartender

/obj/item/clothing/head/hooded/winterhood/nova/bartender
	icon_state = "hood_bar"

//Ratvar-themed
/obj/item/clothing/suit/hooded/wintercoat/nova/ratvar
	name = "拉特维安冬季大衣"
	desc = "一件黄铜镶边的纽扣式冬季大衣。拉链头上没有拉片，取而代之的是一个镶嵌着微小红宝石的黄铜齿轮。"
	icon_state = "coatratvar"
	hoodtype = /obj/item/clothing/head/hooded/winterhood/nova/ratvar

/obj/item/clothing/head/hooded/winterhood/nova/ratvar
	icon_state = "hood_ratvar"

//Nar'sie-themed
/obj/item/clothing/suit/hooded/wintercoat/nova/narsie
	name = "纳尔西寒冬大衣"
	desc = "一件色调阴郁的灰色熵变纽扣外套，配有一条邪恶的深红色拉链。它覆盖着复杂的符文与符号，拉链头看起来像一滴鲜血。"
	icon_state = "coatnarsie"
	hoodtype = /obj/item/clothing/head/hooded/winterhood/nova/narsie

/obj/item/clothing/head/hooded/winterhood/nova/narsie
	desc = "一顶黑色的寒冬兜帽，充满了只有她才会知晓的低语秘密。"
	icon_state = "hood_narsie"

//Christmas
/obj/item/clothing/suit/hooded/wintercoat/nova/christmas
	name = "圣诞寒冬大衣"
	desc = "一件喜庆的圣诞大衣，温暖舒适，内衬白色柔软织物。拉链头是一个小小的拐杖糖！"
	icon_state = "coatchristmas"
	hoodtype = /obj/item/clothing/head/hooded/winterhood/nova/christmas

/obj/item/clothing/head/hooded/winterhood/nova/christmas
	icon_state = "hood_christmas"

/obj/item/clothing/suit/hooded/wintercoat/nova/christmas/green
	icon_state = "coatchristmas_green"
	hoodtype = /obj/item/clothing/head/hooded/winterhood/nova/christmas/green

/obj/item/clothing/head/hooded/winterhood/nova/christmas/green
	icon_state = "hood_christmas_green"
