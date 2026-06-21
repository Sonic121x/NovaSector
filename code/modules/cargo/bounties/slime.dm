/datum/bounty/item/slime
	reward = CARGO_CRATE_VALUE * 6

/datum/bounty/item/slime/New()
	..()
	description = "纳米传讯的科研主管正在寻找稀有且奇特的 [name]。已为此提供赏金。"
	reward += rand(0, 4) * 500

/datum/bounty/item/slime/green
	name = "绿史莱姆提取物"
	wanted_types = list(/obj/item/slime_extract/green = TRUE)

/datum/bounty/item/slime/pink
	name = "粉史莱姆提取物"
	wanted_types = list(/obj/item/slime_extract/pink = TRUE)

/datum/bounty/item/slime/gold
	name = "金史莱姆提取物"
	wanted_types = list(/obj/item/slime_extract/gold = TRUE)

/datum/bounty/item/slime/oil
	name = "油史莱姆提取物"
	wanted_types = list(/obj/item/slime_extract/oil = TRUE)

/datum/bounty/item/slime/black
	name = "黑史莱姆提取物"
	wanted_types = list(/obj/item/slime_extract/black = TRUE)

/datum/bounty/item/slime/lightpink
	name = "亮粉史莱姆提取物"
	wanted_types = list(/obj/item/slime_extract/lightpink = TRUE)

/datum/bounty/item/slime/adamantine
	name = "精金史莱姆提取物"
	wanted_types = list(/obj/item/slime_extract/adamantine = TRUE)

/datum/bounty/item/slime/rainbow
	name = "彩虹史莱姆提取物"
	wanted_types = list(/obj/item/slime_extract/rainbow = TRUE)
