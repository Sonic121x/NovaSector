/datum/bounty/item/interdyne_slime
	reward = CARGO_CRATE_VALUE * 6

/datum/bounty/item/interdyne_slime/New()
	..()
	description = "我们的科研主管正在寻找 [name]。已为此提供赏金，祝你好运。"
	reward += rand(0, 4) * 500

/datum/bounty/item/interdyne_slime/green
	name = "绿色史莱姆提取物"
	wanted_types = list(/obj/item/slime_extract/green = TRUE)

/datum/bounty/item/interdyne_slime/pink
	name = "粉色史莱姆提取物"
	wanted_types = list(/obj/item/slime_extract/pink = TRUE)

/datum/bounty/item/interdyne_slime/gold
	name = "金色史莱姆提取物"
	wanted_types = list(/obj/item/slime_extract/gold = TRUE)

/datum/bounty/item/interdyne_slime/oil
	name = "油性史莱姆提取物"
	wanted_types = list(/obj/item/slime_extract/oil = TRUE)

/datum/bounty/item/interdyne_slime/black
	name = "黑色史莱姆提取物"
	wanted_types = list(/obj/item/slime_extract/black = TRUE)

/datum/bounty/item/interdyne_slime/lightpink
	name = "浅粉色史莱姆提取物"
	wanted_types = list(/obj/item/slime_extract/lightpink = TRUE)

/datum/bounty/item/interdyne_slime/adamantine
	name = "精金史莱姆提取物"
	wanted_types = list(/obj/item/slime_extract/adamantine = TRUE)

/datum/bounty/item/interdyne_slime/rainbow
	name = "彩虹史莱姆提取物"
	wanted_types = list(/obj/item/slime_extract/rainbow = TRUE)
