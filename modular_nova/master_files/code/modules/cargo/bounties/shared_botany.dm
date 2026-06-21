/datum/bounty/item/shared_botany
	reward = CARGO_CRATE_VALUE * 10
	var/multiplier = 0 //adds bonus reward money; increased for higher tier or rare mutations
	var/bonus_desc //for adding extra flavor text to bounty descriptions
	var/foodtype = "meal" //same here

/datum/bounty/item/shared_botany/New()
	..()
	description = "总部的厨师长正打算用 [foodtype] 准备一道精美的 [name]。[bonus_desc]"
	reward += multiplier * (CARGO_CRATE_VALUE * 2)
	required_count = rand(5, 10)

/datum/bounty/item/shared_botany/ambrosia_vulgaris
	name = "普通神果叶"
	wanted_types = list(/obj/item/food/grown/ambrosia/vulgaris = TRUE)
	foodtype = "stew"

/datum/bounty/item/shared_botany/ambrosia_gaia
	name = "盖亚神果叶"
	wanted_types = list(/obj/item/food/grown/ambrosia/gaia = TRUE)
	multiplier = 4
	foodtype = "stew"

/datum/bounty/item/shared_botany/apple_golden
	name = "金苹果"
	wanted_types = list(/obj/item/food/grown/apple/gold = TRUE)
	multiplier = 4
	foodtype = "dessert"

/datum/bounty/item/shared_botany/banana
	name = "香蕉"
	wanted_types = list(
		/obj/item/food/grown/banana = TRUE,
		/obj/item/food/grown/banana/bluespace = FALSE,
	)
	foodtype = "banana split"

/datum/bounty/item/shared_botany/banana_bluespace
	name = "蓝空香蕉"
	wanted_types = list(/obj/item/food/grown/banana/bluespace = TRUE)
	multiplier = 2
	foodtype = "banana split"

/datum/bounty/item/shared_botany/beans_koi
	name = "锦鲤豆"
	wanted_types = list(/obj/item/food/grown/koibeans = TRUE)
	multiplier = 2

/datum/bounty/item/shared_botany/berries_death
	name = "死亡浆果"
	wanted_types = list(/obj/item/food/grown/berries/death = TRUE)
	multiplier = 2
	bonus_desc = "He insists that \"he knows what he's doing\"."
	foodtype = "sorbet"

/datum/bounty/item/shared_botany/berries_glow
	name = "发光浆果"
	wanted_types = list(/obj/item/food/grown/berries/glow = TRUE)
	multiplier = 2
	foodtype = "sorbet"

/datum/bounty/item/shared_botany/cannabis
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

/datum/bounty/item/shared_botany/cannabis_white
	name = "生命草叶"
	wanted_types = list(/obj/item/food/grown/cannabis/white = TRUE)
	multiplier = 6
	bonus_desc = "Do not mention this shipment to security."
	foodtype = "\"meal\""

/datum/bounty/item/shared_botany/cannabis_death
	name = "死亡草叶"
	wanted_types = list(/obj/item/food/grown/cannabis/death = TRUE)
	multiplier = 6
	bonus_desc = "Do not mention this shipment to security."
	foodtype = "\"meal\""

/datum/bounty/item/shared_botany/cannabis_ultimate
	name = "欧米茄草叶"
	wanted_types = list(/obj/item/food/grown/cannabis/ultimate = TRUE)
	multiplier = 6
	bonus_desc = "Under no circumstances mention this shipment to security."
	foodtype = "batch of \"brownies\""

/datum/bounty/item/shared_botany/wheat
	name = "小麦粒"
	wanted_types = list(/obj/item/food/grown/wheat = TRUE)

/datum/bounty/item/shared_botany/rice
	name = "稻米粒"
	wanted_types = list(/obj/item/food/grown/rice = TRUE)

/datum/bounty/item/shared_botany/chili
	name = "辣椒"
	wanted_types = list(/obj/item/food/grown/chili = TRUE)

/datum/bounty/item/shared_botany/ice_chili
	name = "寒椒"
	wanted_types = list(/obj/item/food/grown/icepepper = TRUE)
	multiplier = 2

/datum/bounty/item/shared_botany/ghost_chili
	name = "鬼椒"
	wanted_types = list(/obj/item/food/grown/ghost_chili = TRUE)
	multiplier = 2

/datum/bounty/item/shared_botany/citrus_lime
	name = "青柠"
	wanted_types = list(/obj/item/food/grown/citrus/lime = TRUE)
	foodtype = "sorbet"

/datum/bounty/item/shared_botany/citrus_lemon
	name = "柠檬"
	wanted_types = list(/obj/item/food/grown/citrus/lemon = TRUE)
	foodtype = "sorbet"

/datum/bounty/item/shared_botany/citrus_oranges
	name = "橙子"
	wanted_types = list(/obj/item/food/grown/citrus/orange = TRUE)
	bonus_desc = "Do not ship lemons or limes." //I vanted orahnge!
	foodtype = "sorbet"

/datum/bounty/item/shared_botany/eggplant
	name = "茄子"
	wanted_types = list(/obj/item/food/grown/eggplant = TRUE)
	bonus_desc = "Not to be confused with egg-plants."

/datum/bounty/item/shared_botany/eggplant_eggy
	name = "蛋茄"
	wanted_types = list(/obj/item/food/grown/eggy = TRUE)
	bonus_desc = "Not to be confused with eggplants."
	multiplier = 2

/datum/bounty/item/shared_botany/kudzu
	name = "葛藤荚"
	wanted_types = list(/obj/item/food/grown/kudzupod = TRUE)
	bonus_desc = "Store in a dry, dark place."
	multiplier = 4

/datum/bounty/item/shared_botany/watermelon
	name = "西瓜"
	wanted_types = list(/obj/item/food/grown/watermelon = TRUE)
	foodtype = "dessert"

/datum/bounty/item/shared_botany/watermelon_holy
	name = "圣瓜"
	wanted_types = list(/obj/item/food/grown/holymelon = TRUE)
	multiplier = 2
	foodtype = "dessert"

/datum/bounty/item/shared_botany/glowshroom
	name = "荧光菇"
	wanted_types = list(
		/obj/item/food/grown/mushroom/glowshroom = TRUE,
		/obj/item/food/grown/mushroom/glowshroom/glowcap = FALSE,
		/obj/item/food/grown/mushroom/glowshroom/shadowshroom = FALSE,
	)
	foodtype = "omelet"

/datum/bounty/item/shared_botany/glowshroom_cap
	name = "荧光帽菇"
	wanted_types = list(/obj/item/food/grown/mushroom/glowshroom/glowcap = TRUE)
	multiplier = 2
	foodtype = "omelet"

/datum/bounty/item/shared_botany/glowshroom_shadow
	name = "暗影菇"
	wanted_types = list(/obj/item/food/grown/mushroom/glowshroom/shadowshroom = TRUE)
	multiplier = 2
	foodtype = "omelet"

/datum/bounty/item/shared_botany/nettles_death
	name = "死亡荨麻"
	wanted_types = list(/obj/item/food/grown/nettle/death = TRUE)
	multiplier = 2
	bonus_desc = "Wear protection when handling them."
	foodtype = "cheese"

/datum/bounty/item/shared_botany/pineapples
	name = "菠萝"
	wanted_types = list(/obj/item/food/grown/pineapple = TRUE)
	bonus_desc = "Not for human consumption."
	foodtype = "ashtray"

/datum/bounty/item/shared_botany/tomato
	name = "番茄"
	wanted_types = list(
		/obj/item/food/grown/tomato = TRUE,
		/obj/item/food/grown/tomato/blue = FALSE,
	)

/datum/bounty/item/shared_botany/tomato_bluespace
	name = "蓝空番茄"
	wanted_types = list(/obj/item/food/grown/tomato/blue/bluespace = TRUE)
	multiplier = 4

/datum/bounty/item/shared_botany/oatz
	name = "燕麦"
	wanted_types = list(/obj/item/food/grown/oat = TRUE)
	multiplier = 2
	foodtype = "batch of oatmeal"
	bonus_desc = "Squats and oats. We're all out of oats."

/datum/bounty/item/shared_botany/bonfire
	name = "点燃的篝火"
	description = "我们的太空加热器出了故障，总部的工作人员开始感到寒冷。种植一些原木，然后运送一个点燃的篝火来温暖他们。"
	wanted_types = list(/obj/structure/bonfire = TRUE)

/datum/bounty/item/shared_botany/bonfire/applies_to(obj/O)
	if(!..())
		return FALSE
	var/obj/structure/bonfire/bonfire = O
	return bonfire.burning

/datum/bounty/item/shared_botany/cucumber
	name = "黄瓜"
	wanted_types = list(/obj/item/food/grown/cucumber = TRUE)
