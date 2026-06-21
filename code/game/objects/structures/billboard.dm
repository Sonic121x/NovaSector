/obj/structure/billboard
	name = "空白广告牌"
	desc = "一块空白的广告牌，上面预留了放置各种广告的空间。"
	icon = 'icons/obj/fluff/billboard.dmi'
	icon_state = "billboard_blank"
	plane = ABOVE_GAME_PLANE
	max_integrity = 1000
	bound_width = 96
	bound_height = 32
	density = TRUE
	anchored = TRUE

/obj/structure/billboard/Initialize(mapload)
	. = ..()

	AddComponent(/datum/component/seethrough, SEE_THROUGH_MAP_BILLBOARD)

/obj/structure/billboard/donk_n_go
	name = "\improper Donk-n-Go 广告牌"
	desc = "一个广告牌宣传 Donk Co 永远存在且不健康的快餐业务 Donk-n-Go：进来，吃饱，走人！"
	icon_state = "billboard_donk_n_go"

/obj/structure/billboard/space_cola
	name = "\improper 太空可乐广告牌"
	desc = "一块宣传“太空可乐”的广告牌上写着：“放松一下，来一杯太空可乐吧。”"
	icon_state = "billboard_space_cola"

/obj/structure/billboard/nanotrasen
	name = "\improper 纳米传讯广告牌"
	desc = "一块宣传“纳米传讯：今日开创美好明天”的广告牌。"
	icon_state = "billboard_nanotrasen"

/obj/structure/billboard/nanotrasen/defaced
	name = "污损的纳米传讯广告牌"
	desc = "宣传纳米传讯的广告牌，有人在上面喷涂了一条信息：去他妈的公司狗。"
	icon_state = "billboard_fuck_corps"

/obj/structure/billboard/azik
	name = "\improper 阿齐克星际广告牌"
	desc = "一块广告广告牌，宣传阿齐克星际和他们的最新型号——独裁者太阳能帆船，阿齐克星际：提兹兰精炼银河必需品。"
	icon_state = "billboard_azik"

/obj/structure/billboard/cvr
	name = "\improper 莱茵兰的查理曼广告牌"
	desc = "广告牌宣传查理曼·冯·莱茵兰的日耳曼级超级游艇。查理曼·冯·莱茵兰：国王的造船厂。"
	icon_state = "billboard_cvr"

/obj/structure/billboard/twenty_four_seven
	name = "\improper 24-七 广告牌"
	desc = "一块宣传 24-Seven 新款限量版思乐冰口味的广告牌。24-Seven：全天候，每一天。"
	icon_state = "billboard_twenty_four_seven"

/obj/structure/billboard/starway
	name = "\improper 星途交通广告牌"
	desc = "一块宣传星途运输公司从新莫斯科直飞纽约的广告牌，写着 '经济舱卧铺只需2000 cr' 星途：你的星际之旅的入场券。"
	icon_state = "billboard_starway"

/obj/structure/billboard/lizards_gas
	name = "\improper 蜥蜴燃气广告牌"
	desc = "A billboard labelling the gas station known as 'The Lizard's Gas'. It's been lost to time, and this is the only known gas station of its type. It's hard to see why it flopped based on the quality of the billboard."
	icon_state = "billboard_lizards_gas"

/obj/structure/billboard/lizards_gas/defaced
	desc = "一块广告牌上写着这个加油站的名字叫 '蜥蜴燃气' ，深情绘制的广告牌已被涂鸦，一个善良的陌生人在尖刻的涂鸦上作画。"
	icon_state = "billboard_lizards_gas_defaced"

/obj/structure/billboard/roadsign
	name = "\improper 路牌广告牌"
	desc = "一块广告牌，告诉读者距离加油站还有多少英里，然而，这一张似乎是空白的。"
	icon_state = "billboard_roadsign_blank"

/obj/structure/billboard/roadsign/two
	desc = "一块广告牌，告诉读者距离下一个加油站还有多少英里，很难看出这个标志有什么用处。"
	icon_state = "billboard_roadsign_two"

/obj/structure/billboard/roadsign/twothousand
	desc = "一块广告牌，告诉读者距离下一个加油站还有多少英里，如果你看到这样的情况，你可能会想要囤积食物和汽油。"
	icon_state = "billboard_roadsign_twothousand"

/obj/structure/billboard/roadsign/twomillion
	desc = "一块广告牌，告诉读者距离下一个加油站还有多少英里，如果你有能力进行几百万英里的旅行，这不应该是一件容易的事！而如果你没有.……"
	icon_state = "billboard_roadsign_twomillion"

/obj/structure/billboard/roadsign/error
	desc = "一块广告牌，告诉读者距离下一个加油站还有多少英里，这是一个静态的标志，所以你一定想知道什么样的人会把它打印出来，然后挂起来。"
	icon_state = "billboard_roadsign_error"

/obj/structure/billboard/smoothies
	name = "\improper Spinward Smoothies 广告牌"
	desc = "一块广告牌，宣传 Spinward Smoothies。"
	icon_state = "billboard_smoothies"

/obj/structure/billboard/fortune_telling
	name = "\improper 占卜师广告牌"
	desc = "一块宣传占卜服务的广告牌。据说是由真正的灵能者进行的！"
	icon_state = "billboard_fortune_tell"

/obj/structure/billboard/Phone_booth
	name = "\improper 全息电话广告牌"
	desc = "一块宣传全息电话的广告牌。星际通话仅需实惠的 49.99 信用点，还附赠免税零食！"
	icon_state = "billboard_phone"

/obj/structure/billboard/american_diner
	name = "\improper 全美式餐厅广告牌"
	desc = "一块宣传复古 1950 年代主题餐厅连锁店“全美式餐厅”的广告牌。"
	icon_state = "billboard_american_diner"

/obj/structure/billboard/gloves
	name = "\improper RoroCo 手套广告牌"
	desc = "一块宣传 RoroCo 的广告牌，该公司生产绝缘手套及绝缘手套配件。展示了该公司可爱的吉祥物 Roro。"
	icon_state = "billboard_gloves"
