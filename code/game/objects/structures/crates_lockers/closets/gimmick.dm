/obj/structure/closet/cabinet
	name = "柜子"
	desc = "古老的东西永远不会过时。"
	icon_state = "cabinet"
	resistance_flags = FLAMMABLE
	open_sound = 'sound/machines/closet/wooden_closet_open.ogg'
	close_sound = 'sound/machines/closet/wooden_closet_close.ogg'
	open_sound_volume = 25
	close_sound_volume = 50
	max_integrity = 70
	door_anim_time = 0 // no animation
	material_drop = /obj/item/stack/sheet/mineral/wood
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 2)

/obj/structure/closet/acloset
	name = "怪异的衣橱"
	desc = "它看起来太外星了！"
	icon_state = "alien"
	material_drop = /obj/item/stack/sheet/mineral/abductor
	custom_materials = list(/datum/material/alloy/alien = SHEET_MATERIAL_AMOUNT * 2)

/obj/structure/closet/gimmick
	name = "管理用品储藏柜"
	desc = "一个专门用于存放不该出现在这里的东西的存储单元。"
	icon_state = "syndicate"

/obj/structure/closet/gimmick/russian
	name = "\improper 俄罗斯盈余衣橱"
	desc = "一个专门用于存放盈余的俄国制式装备的存储单元。"

/obj/structure/closet/gimmick/russian/PopulateContents()
	..()
	for(var/i in 1 to 5)
		new /obj/item/clothing/head/costume/ushanka(src)
	for(var/i in 1 to 5)
		new /obj/item/clothing/under/costume/soviet(src)

/obj/structure/closet/gimmick/tacticool
	name = "战酷装备衣橱"
	desc = "这是一个存放战酷装备的储藏柜。"

/obj/structure/closet/gimmick/tacticool/PopulateContents()
	..()
	new /obj/item/clothing/glasses/eyepatch(src)
	new /obj/item/clothing/gloves/tackler/combat(src)
	new /obj/item/clothing/gloves/tackler/combat(src)
	new /obj/item/clothing/head/helmet/swat(src)
	new /obj/item/clothing/head/helmet/swat(src)
	new /obj/item/clothing/mask/gas/sechailer/swat(src)
	new /obj/item/clothing/mask/gas/sechailer/swat(src)
	new /obj/item/clothing/shoes/combat/swat(src)
	new /obj/item/clothing/shoes/combat/swat(src)
	new /obj/item/mod/control/pre_equipped/apocryphal(src)
	new /obj/item/mod/control/pre_equipped/apocryphal(src)
	new /obj/item/clothing/under/syndicate/tacticool(src)
	new /obj/item/clothing/under/syndicate/tacticool(src)

/obj/structure/closet/gimmick/tacticool/populate_contents_immediate()
	new /obj/item/clothing/glasses/sunglasses(src)

/obj/structure/closet/thunderdome
	name = "\improper 闪电棚衣橱"
	desc = "你需要的一切！"
	anchored = TRUE

/obj/structure/closet/thunderdome/tdred
	name = "红队闪电棚衣橱"
	icon_door = "red"

/obj/structure/closet/thunderdome/tdred/PopulateContents()
	..()
	for(var/i in 1 to 3)
		new /obj/item/clothing/suit/armor/tdome/red(src)
	for(var/i in 1 to 3)
		new /obj/item/melee/energy/sword/saber(src)
	for(var/i in 1 to 3)
		new /obj/item/melee/baton/security/loaded(src)
	for(var/i in 1 to 3)
		new /obj/item/storage/box/flashbangs(src)
	for(var/i in 1 to 3)
		new /obj/item/clothing/head/helmet/thunderdome(src)

/obj/structure/closet/thunderdome/tdred/populate_contents_immediate()
	for(var/i in 1 to 3)
		new /obj/item/gun/energy/laser(src)

/obj/structure/closet/thunderdome/tdgreen
	name = "绿队闪电棚衣橱"
	icon_door = "green"

/obj/structure/closet/thunderdome/tdgreen/PopulateContents()
	..()
	for(var/i in 1 to 3)
		new /obj/item/clothing/suit/armor/tdome/green(src)
	for(var/i in 1 to 3)
		new /obj/item/melee/energy/sword/saber(src)
	for(var/i in 1 to 3)
		new /obj/item/melee/baton/security/loaded(src)
	for(var/i in 1 to 3)
		new /obj/item/storage/box/flashbangs(src)
	for(var/i in 1 to 3)
		new /obj/item/clothing/head/helmet/thunderdome(src)

/obj/structure/closet/thunderdome/tdgreen/populate_contents_immediate()
	for(var/i in 1 to 3)
		new /obj/item/gun/energy/laser(src)

/obj/structure/closet/malf/suits
	desc = "一个专门用于存放行动装备的存储单元。"
	icon_state = "syndicate"

/obj/structure/closet/malf/suits/PopulateContents()
	..()
	new /obj/item/tank/jetpack/void(src)
	new /obj/item/clothing/mask/breath(src)
	new /obj/item/clothing/head/helmet/space/nasavoid(src)
	new /obj/item/clothing/suit/space/nasavoid(src)
	new /obj/item/crowbar(src)
	new /obj/item/stock_parts/power_store/cell(src)
	new /obj/item/multitool(src)

/obj/structure/closet/mini_fridge
	name = "脏兮兮的迷你冰箱"
	desc = "一种小型装置，旨在为少量饮品注入宜人的凉意。"
	icon_state = "mini_fridge"
	icon_welded = "welded_small"
	max_mob_size = MOB_SIZE_SMALL
	pass_flags = PASSTABLE
	anchored_tabletop_offset = 3
	anchored = 1
	storage_capacity = 10

/obj/structure/closet/mini_fridge/PopulateContents()
	. = ..()
	new /obj/effect/spawner/random/food_or_drink/refreshing_beverage(src)
	new /obj/effect/spawner/random/food_or_drink/refreshing_beverage(src)
	if(prob(50))
		new /obj/effect/spawner/random/food_or_drink/refreshing_beverage(src)
	if(prob(40))
		new /obj/item/reagent_containers/cup/glass/bottle/beer(src)

/obj/structure/closet/mini_fridge/grimy
	name = "脏兮兮的迷你冰箱"
	desc = "一种小家电，设计用来为几杯饮料添上令人愉快的凉意，但是这款老旧型号看起来只是漫无目的地在和蟑螂作伴。"

/obj/structure/closet/mini_fridge/grimy/PopulateContents()
	. = ..()
	if(prob(40))
		if(prob(50))
			new /obj/item/food/pizzaslice/moldy/bacteria(src)
		else
			new /obj/item/food/breadslice/moldy/bacteria(src)
	else if(prob(40))
		if(prob(50))
			new /obj/item/food/syndicake(src)
		else
			new /mob/living/basic/cockroach(src)
