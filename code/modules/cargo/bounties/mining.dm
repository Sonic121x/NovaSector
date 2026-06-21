/datum/bounty/item/mining/goliath_steaks
	name = "岩烤歌莉娅肉排"
	description = "自从食堂开始只供应猴子和猴子副产品以来，帕夫洛夫上将一直在进行绝食抗议。她要求吃熔岩烤制的歌利亚牛排。"
	reward = CARGO_CRATE_VALUE * 10
	required_count = 3
	wanted_types = list(/obj/item/food/meat/steak/goliath = TRUE)

/datum/bounty/item/mining/goliath_boat
	name = "歌利亚皮艇"
	description = "缅科夫指挥官想参加一年一度的熔岩地赛舟会。他请求你们的造船师建造人类已知最快的船。"
	reward = CARGO_CRATE_VALUE * 20
	wanted_types = list(/obj/vehicle/ridden/lavaboat = TRUE)

/datum/bounty/item/mining/bone_oar
	name = "骨桨"
	description = "缅科夫指挥官需要船桨来参加一年一度的熔岩地赛舟会。运送一对过来。"
	reward = CARGO_CRATE_VALUE * 8
	required_count = 2
	wanted_types = list(/obj/item/oar = TRUE)

//NOVA EDIT REMOVAL
/*
/datum/bounty/item/mining/bone_axe
	name = "Bone Axe"
	description = "Station 12 has had their fire axes stolen by marauding clowns. Ship them a bone axe as a replacement."
	reward = CARGO_CRATE_VALUE * 15
	wanted_types = list(/obj/item/fireaxe/boneaxe = TRUE)
*/
//END NOVA EDIT REMOVAL

/datum/bounty/item/mining/bone_armor
	name = "骨甲"
	description = "14号空间站自愿让他们的蜥蜴船员参与防弹护甲测试。运送一些骨制护甲过来。"
	reward = CARGO_CRATE_VALUE * 10
	wanted_types = list(/obj/item/clothing/suit/armor/bone = TRUE)

/datum/bounty/item/mining/skull_helmet
	name = "头骨盔"
	description = "42号空间站的安全主管明天过生日！我们想送她一顶时尚的颅骨头盔作为惊喜。"
	reward = CARGO_CRATE_VALUE * 8
	wanted_types = list(/obj/item/clothing/head/helmet/skull = TRUE)

/datum/bounty/item/mining/bone_talisman
	name = "骨护身符"
	description = "14号空间站的研究主管声称异教骨制护身符能保护佩戴者。运送一些给他们，以便他们开始测试。"
	reward = CARGO_CRATE_VALUE * 15
	required_count = 3
	wanted_types = list(/obj/item/clothing/accessory/talisman = TRUE)

/datum/bounty/item/mining/watcher_wreath
	name = "守望者花环"
	description = "14号空间站的研究主管认为他们在某些异教信仰的文化符号方面即将取得突破。运送一些观察者花环给他们分析。"
	include_subtypes = FALSE
	reward = CARGO_CRATE_VALUE * 15
	required_count = 3
	wanted_types = list(/obj/item/clothing/neck/wreath = TRUE)

/datum/bounty/item/mining/icewing_wreath
	name = "冰翼花环"
	description = "We're getting some....weird messages from Station 14's Research Director. And most of what they said was incoherent. But they apparently want an icewing wreath. Could you send them one?"
	reward = CARGO_CRATE_VALUE * 30
	required_count = 1
	wanted_types = list(/obj/item/clothing/neck/wreath/icewing = TRUE)

//NOVA EDIT REMOVAL
/*
/datum/bounty/item/mining/bone_dagger
	name = "Bone Daggers"
	description = "Central Command's canteen is undergoing budget cuts. Ship over some bone daggers so our chef can keep working."
	reward = CARGO_CRATE_VALUE * 10
	required_count = 3
	wanted_types = list(/obj/item/knife/combat/bone = TRUE)
*/
//END NOVA EDIT REMOVAL

/datum/bounty/item/mining/polypore_mushroom
	name = "蘑菇碗"
	description = "杰布中尉把他最喜欢的蘑菇碗摔了。给他运送一个新的让他开心起来，好吗？"
	reward = CARGO_CRATE_VALUE * 15 //5x mushroom shavings
	wanted_types = list(/obj/item/reagent_containers/cup/bowl/mushroom_bowl = TRUE)

/datum/bounty/item/mining/inocybe_mushroom
	name = "蘑菇杯"
	description = "我们的植物学家声称他能从任何植物中蒸馏出美味的酒。让我们看看他用丝盖伞菌帽能做出什么。"
	reward = CARGO_CRATE_VALUE * 9
	required_count = 3
	wanted_types = list(/obj/item/food/grown/ash_flora/mushroom_cap = TRUE)

/datum/bounty/item/mining/porcini_mushroom
	name = "蘑菇叶"
	description = "据说牛肝菌叶具有治疗功效。我们的研究人员想验证这一说法。"
	reward = CARGO_CRATE_VALUE * 9
	required_count = 3
	wanted_types = list(/obj/item/food/grown/ash_flora/mushroom_leaf = TRUE)
