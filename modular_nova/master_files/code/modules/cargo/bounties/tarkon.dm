/datum/bounty/item/tarkon/xenobodies
	name = "异形躯体"
	description = "一家本地企业集团，某个技术供应商之类的，非常想要一些异形尸体。你们那里有吗？"
	reward = CARGO_CRATE_VALUE * 5
	wanted_types = list(
		/mob/living/basic/alien = TRUE,
	)

/datum/bounty/item/tarkon/arc
	name = "先进工具"
	description = "我们需要几个A.R.C.S.谐振器，你们那里有吗？"
	reward = CARGO_CRATE_VALUE * 5
	required_count = 3
	wanted_types = list(
		/obj/item/gun/energy/recharge/resonant_system = TRUE,
	)

/datum/bounty/item/tarkon/rcd
	name = "重建计划"
	description = "我们需要把我们专有的几台快速建造装置运送给公司，以便他们完成一笔交易。"
	reward = CARGO_CRATE_VALUE * 5
	required_count = 3
	wanted_types = list(
		/obj/item/construction/rcd/tarkon = TRUE,
	)

/datum/bounty/item/tarkon/defense
	name = "关闭计划"
	description = "一位大客户想要我们的一款专利炮塔，两种型号都可以。请尽快发货。" 
	reward = CARGO_CRATE_VALUE * 8
	required_count = 1
	wanted_types = list(
		/obj/item/storage/toolbox/emergency/turret/mag_fed/cerberus = TRUE,
		/obj/item/storage/toolbox/emergency/turret/mag_fed/hoplite = TRUE,
	)
