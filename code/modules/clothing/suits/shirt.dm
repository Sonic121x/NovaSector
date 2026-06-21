/obj/item/clothing/suit/costume/wellworn_shirt
	name = "破旧衬衫"
	desc = "一件破旧但异常舒适的T恤。虽然不至于说穿上它就像被拥抱一样，但也差不多了。很适合睡觉时穿。"
	inhand_icon_state = null
	icon = 'icons/map_icons/clothing/suit/costume.dmi'
	icon_state = "/obj/item/clothing/suit/costume/wellworn_shirt"
	post_init_icon_state = "wellworn_shirt"
	greyscale_config = /datum/greyscale_config/wellworn_shirt
	greyscale_config_worn = /datum/greyscale_config/wellworn_shirt/worn
	greyscale_colors = COLOR_WHITE
	species_exception = list(/datum/species/golem)
	flags_1 = IS_PLAYER_COLORABLE_1
	///How many times has this shirt been washed? (In an ideal world this is just the determinant of the transform matrix.)
	var/wash_count = 0

/obj/item/clothing/suit/costume/wellworn_shirt/machine_wash(obj/machinery/washing_machine/washer)
	. = ..()
	if(wash_count <= 5)
		transform *= TRANSFORM_USING_VARIABLE(0.8, 1)
		washer.visible_message("[src] 洗过后似乎缩水了。")
		wash_count += 1
	else
		washer.visible_message("[src] 因反复洗涤而坍缩了。")
		qdel(src)

/obj/item/clothing/suit/costume/wellworn_shirt/skub
	name = "支持Skub的T恤"
	desc = "一件破旧但异常舒适的T恤，宣告着你支持Skub的立场。去他娘的反Skub分子。"
	greyscale_colors = "#FFFF4D"
	icon_state = "/obj/item/clothing/suit/costume/wellworn_shirt/skub"
	post_init_icon_state = "wellworn_shirt_pro_skub"
	greyscale_config = /datum/greyscale_config/wellworn_shirt_skub
	greyscale_config_worn = /datum/greyscale_config/wellworn_shirt_skub/worn

/obj/item/clothing/suit/costume/wellworn_shirt/skub/anti
	name = "反对Skub的T恤"
	desc = "一件破旧但异常舒适的T恤，宣告着你反对Skub的立场。去他娘的支持Skub分子。"
	icon_state = "/obj/item/clothing/suit/costume/wellworn_shirt/skub/anti"
	post_init_icon_state = "wellworn_shirt_anti_skub"

/obj/item/clothing/suit/costume/wellworn_shirt/graphic
	name = "破旧图案T恤"
	desc = "一件破旧但异常舒适的T恤，正面印着《Phanic the Weasel》里的一个角色。它为自己和穿着者增添了一些魅力点，并让你想起这个系列还在2500年那会儿的辉煌时期。"
	greyscale_colors = "#FFFFFF#46B45B"
	icon_state = "/obj/item/clothing/suit/costume/wellworn_shirt/graphic"
	post_init_icon_state = "wellworn_shirt_gamer"
	greyscale_config = /datum/greyscale_config/wellworn_shirt_graphic
	greyscale_config_worn = /datum/greyscale_config/wellworn_shirt_graphic/worn

/obj/item/clothing/suit/costume/wellworn_shirt/graphic/ian
	name = "破旧伊恩T恤"
	desc = "一件破旧但异常舒适的T恤，上面印着柯基犬伊恩的图片。虽然不至于说穿上它就像被拥抱一样，但也差不多了。很适合穿着睡觉。"
	icon_state = "/obj/item/clothing/suit/costume/wellworn_shirt/graphic/ian"
	post_init_icon_state = "wellworn_shirt_ian"
	greyscale_colors = "#FFFFFF#E1B26C"

/obj/item/clothing/suit/costume/wellworn_shirt/wornout
	name = "磨损T恤"
	desc = "一件相当邋遢，但依然舒适的T恤。你穿着这件衣服睡觉有点太久了。"
	icon_state = "/obj/item/clothing/suit/costume/wellworn_shirt/wornout"
	post_init_icon_state = "wornout_shirt"

/obj/item/clothing/suit/costume/wellworn_shirt/wornout/graphic
	name = "磨损图案T恤"
	desc = "一件相当邋遢，但依然舒适的T恤，正面印着《Phanic the Weasel》里的一个角色。那略显破烂的样子让人想起那部把他变成吸血鬼的糟糕作品。连续穿着它睡了这么多天，你应该能解锁成就了。"
	greyscale_colors = "#FFFFFF#46B45B"
	icon_state = "/obj/item/clothing/suit/costume/wellworn_shirt/wornout/graphic"
	post_init_icon_state = "wornout_shirt_gamer"
	greyscale_config = /datum/greyscale_config/wornout_shirt_graphic
	greyscale_config_worn = /datum/greyscale_config/wornout_shirt_graphic/worn

/obj/item/clothing/suit/costume/wellworn_shirt/wornout/graphic/ian
	name = "磨损伊恩T恤"
	desc = "A pretty grubby, yet still comfortable t-shirt with a picture of Ian the Corgi. It's gone past 'a bit worn' to 'well-loved;' excellent for use as pajamas."
	icon_state = "/obj/item/clothing/suit/costume/wellworn_shirt/wornout/graphic/ian"
	post_init_icon_state = "wornout_shirt_ian"
	greyscale_colors = "#FFFFFF#E1B26C"

/obj/item/clothing/suit/costume/wellworn_shirt/messy
	name = "邋遢磨损T恤"
	desc = "这件磨损但不知为何很舒适的T恤，已经对污垢有了更透彻的理解；也许它一直没洗这个事实能起到某种伪装作用？"
	icon_state = "/obj/item/clothing/suit/costume/wellworn_shirt/messy"
	post_init_icon_state = "messyworn_shirt"

/obj/item/clothing/suit/costume/wellworn_shirt/messy/graphic
	name = "邋遢图案T恤"
	desc = "这件磨损但不知为何很舒适的T恤，已经对污垢有了更透彻的理解。普通人永远不会明白这是一件收藏品，而你的时尚感绝对碾压他们。Phanic永恒。"
	icon_state = "/obj/item/clothing/suit/costume/wellworn_shirt/messy/graphic"
	post_init_icon_state = "messyworn_shirt_gamer"
	greyscale_config = /datum/greyscale_config/messyworn_shirt_graphic
	greyscale_config_worn = /datum/greyscale_config/messyworn_shirt_graphic/worn
	greyscale_colors = "#FFFFFF#46B45B"

/obj/item/clothing/suit/costume/wellworn_shirt/messy/graphic/ian
	name = "邋遢的伊恩衬衫"
	desc = "这件破旧却莫名舒适的T恤对污垢有了更透彻的理解。你感觉自己仿佛理解了流浪狗的处境，但伊恩的脸庞依然让你感到安慰。"
	icon_state = "/obj/item/clothing/suit/costume/wellworn_shirt/messy/graphic/ian"
	post_init_icon_state = "messyworn_shirt_ian"
	greyscale_colors = "#FFFFFF#E1B26C"

/obj/item/clothing/suit/costume/wellworn_shirt/messy/graphic/gamer
	name = "玩家T恤"
	desc = "一件宽松、极度破旧的衬衫，胸前过于醒目地印着复古游戏角色鼬鼠菲尼克。你的大脑无法承受回忆起那些菲尼克同人图的冲击；更别提这件上衣的臭味了。"
