/datum/bounty/item/botany
	reward = CARGO_CRATE_VALUE * 10
	var/multiplier = 0 //adds bonus reward money; increased for higher tier or rare mutations
	var/bonus_desc //for adding extra flavor text to bounty descriptions
	var/foodtype = "meal" //same here

/datum/bounty/item/botany/New()
	..()
	description = "中央指挥部的总厨正打算用[foodtype]和[name]准备一道佳肴。[bonus_desc]"
	reward += multiplier * (CARGO_CRATE_VALUE * 2)
	required_count = rand(5, 10)

/datum/bounty/item/botany/ambrosia_vulgaris
	name = "普通蒿叶"
	wanted_types = list(/obj/item/food/grown/ambrosia/vulgaris = TRUE)
	foodtype = "stew"

/datum/bounty/item/botany/ambrosia_gaia
	name = "自然安布罗希亚叶"
	wanted_types = list(/obj/item/food/grown/ambrosia/gaia = TRUE)
	multiplier = 4
	foodtype = "stew"

/datum/bounty/item/botany/apple_golden
	name = "金苹果"
	wanted_types = list(/obj/item/food/grown/apple/gold = TRUE)
	multiplier = 4
	foodtype = "dessert"

/datum/bounty/item/botany/banana
	name = "香蕉"
	wanted_types = list(
		/obj/item/food/grown/banana = TRUE,
		/obj/item/food/grown/banana/bluespace = FALSE,
	)
	foodtype = "banana split"

/datum/bounty/item/botany/banana_bluespace
	name = "蓝空香蕉"
	wanted_types = list(/obj/item/food/grown/banana/bluespace = TRUE)
	multiplier = 2
	foodtype = "banana split"

/datum/bounty/item/botany/beans_koi
	name = "鲤鱼豆"
	wanted_types = list(/obj/item/food/grown/koibeans = TRUE)
	multiplier = 2

/datum/bounty/item/botany/berries_death
	name = "死亡浆果"
	wanted_types = list(/obj/item/food/grown/berries/death = TRUE)
	multiplier = 2
	bonus_desc = "He insists that \"he knows what he's doing\"."
	foodtype = "sorbet"

/datum/bounty/item/botany/berries_glow
	name = "发光浆果"
	wanted_types = list(/obj/item/food/grown/berries/glow = TRUE)
	multiplier = 2
	foodtype = "sorbet"

/datum/bounty/item/botany/cannabis
	name = "大麻叶"
	wanted_types = list(
		/obj/item/food/grown/cannabis = TRUE,
		/obj/item/food/grown/cannabis/white = FALSE,
		/obj/item/food/grown/cannabis/death = FALSE,
		/obj/item/food/grown/cannabis/ultimate = FALSE,
	)
	multiplier = 4 //hush money
	bonus_desc = "Do not mention this shipment to security."
	foodtype = "batch of \"muffins\""

/datum/bounty/item/botany/cannabis_white
	name = "生命草叶"
	wanted_types = list(/obj/item/food/grown/cannabis/white = TRUE)
	multiplier = 6
	bonus_desc = "Do not mention this shipment to security."
	foodtype = "\"meal\""

/datum/bounty/item/botany/cannabis_death
	name = "死亡草叶"
	wanted_types = list(/obj/item/food/grown/cannabis/death = TRUE)
	multiplier = 6
	bonus_desc = "Do not mention this shipment to security."
	foodtype = "\"meal\""

/datum/bounty/item/botany/cannabis_ultimate
	name = "欧米茄草叶"
	wanted_types = list(/obj/item/food/grown/cannabis/ultimate = TRUE)
	multiplier = 6
	bonus_desc = "Under no circumstances mention this shipment to security."
	foodtype = "batch of \"brownies\""

/datum/bounty/item/botany/wheat
	name = "小麦谷物"
	wanted_types = list(/obj/item/food/grown/wheat = TRUE)

/datum/bounty/item/botany/rice
	name = "大米谷物"
	wanted_types = list(/obj/item/food/grown/rice = TRUE)

/datum/bounty/item/botany/chili
	name = "辣椒"
	wanted_types = list(/obj/item/food/grown/chili = TRUE)

/datum/bounty/item/botany/ice_chili
	name = "冷椒"
	wanted_types = list(/obj/item/food/grown/icepepper = TRUE)
	multiplier = 2

/datum/bounty/item/botany/ghost_chili
	name = "幽灵辣椒"
	wanted_types = list(/obj/item/food/grown/ghost_chili = TRUE)
	multiplier = 2

/datum/bounty/item/botany/citrus_lime
	name = "酸橙"
	wanted_types = list(/obj/item/food/grown/citrus/lime = TRUE)
	foodtype = "sorbet"

/datum/bounty/item/botany/citrus_lemon
	name = "柠檬"
	wanted_types = list(/obj/item/food/grown/citrus/lemon = TRUE)
	foodtype = "sorbet"

/datum/bounty/item/botany/citrus_oranges
	name = "橙子"
	wanted_types = list(/obj/item/food/grown/citrus/orange = TRUE)
	bonus_desc = "Do not ship lemons or limes." //I vanted orahnge!
	foodtype = "sorbet"

/datum/bounty/item/botany/eggplant
	name = "茄子"
	wanted_types = list(/obj/item/food/grown/eggplant = TRUE)
	bonus_desc = "Not to be confused with egg-plants."

/datum/bounty/item/botany/eggplant_eggy
	name = "蛋安置板"
	wanted_types = list(/obj/item/food/grown/eggy = TRUE)
	bonus_desc = "Not to be confused with eggplants."
	multiplier = 2

/datum/bounty/item/botany/kudzu
	name = "葛荚"
	wanted_types = list(/obj/item/food/grown/kudzupod = TRUE)
	bonus_desc = "Store in a dry, dark place."
	multiplier = 4

/datum/bounty/item/botany/watermelon
	name = "西瓜"
	wanted_types = list(/obj/item/food/grown/watermelon = TRUE)
	foodtype = "dessert"

/datum/bounty/item/botany/watermelon_holy
	name = "圣瓜"
	wanted_types = list(/obj/item/food/grown/holymelon = TRUE)
	multiplier = 2
	foodtype = "dessert"

/datum/bounty/item/botany/glowshroom
	name = "荧光菇"
	wanted_types = list(
		/obj/item/food/grown/mushroom/glowshroom = TRUE,
		/obj/item/food/grown/mushroom/glowshroom/glowcap = FALSE,
		/obj/item/food/grown/mushroom/glowshroom/shadowshroom = FALSE,
	)
	foodtype = "omelet"

/datum/bounty/item/botany/glowshroom_cap
	name = "发光帽"
	wanted_types = list(/obj/item/food/grown/mushroom/glowshroom/glowcap = TRUE)
	multiplier = 2
	foodtype = "omelet"

/datum/bounty/item/botany/glowshroom_shadow
	name = "暗影菇"
	wanted_types = list(/obj/item/food/grown/mushroom/glowshroom/shadowshroom = TRUE)
	multiplier = 2
	foodtype = "omelet"

/datum/bounty/item/botany/nettles_death
	name = "死亡荨麻"
	wanted_types = list(/obj/item/food/grown/nettle/death = TRUE)
	multiplier = 2
	bonus_desc = "Wear protection when handling them."
	foodtype = "cheese"

/datum/bounty/item/botany/pineapples
	name = "菠萝"
	wanted_types = list(/obj/item/food/grown/pineapple = TRUE)
	bonus_desc = "Not for human consumption."
	foodtype = "ashtray"

/datum/bounty/item/botany/tomato
	name = "番茄"
	wanted_types = list(
		/obj/item/food/grown/tomato = TRUE,
		/obj/item/food/grown/tomato/blue = FALSE,
	)

/datum/bounty/item/botany/tomato_bluespace
	name = "蓝空番茄"
	wanted_types = list(/obj/item/food/grown/tomato/blue/bluespace = TRUE)
	multiplier = 4

/datum/bounty/item/botany/oatz
	name = "燕麦"
	wanted_types = list(/obj/item/food/grown/oat = TRUE)
	multiplier = 2
	foodtype = "batch of oatmeal"
	bonus_desc = "Squats and oats. We're all out of oats."

/datum/bounty/item/botany/bonfire
	name = "点燃的篝火"
	description = "我们的太空加热器出了故障，中央指挥部的货运人员开始觉得冷了。种些木头，然后运一个点燃的篝火过来给他们取暖。"
	wanted_types = list(/obj/structure/bonfire = TRUE)

/datum/bounty/item/botany/bonfire/applies_to(obj/O)
	if(!..())
		return FALSE
	var/obj/structure/bonfire/B = O
	return !!B.burning

/datum/bounty/item/botany/cucumber
	name = "黄瓜"
	wanted_types = list(/obj/item/food/grown/cucumber = TRUE)
