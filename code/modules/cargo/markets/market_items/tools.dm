/datum/market_item/tool
	category = "Tools"
	abstract_path = /datum/market_item/tool

/datum/market_item/tool/blackmarket_telepad
	name = "Black Market LTSRBT"
	desc = "Need a faster and better way of transporting your illegal goods from and to the \
		station? Fear not, the Long-To-Short-Range-Bluespace-Transceiver is here to help. \
		Contains a LTSRBT circuit. Bluespace crystals and ansible not included."
	item = /obj/item/circuitboard/machine/ltsrbt
	stock_min = 2
	stock_max = 4
	price_min = CARGO_CRATE_VALUE * 2.5
	price_max = CARGO_CRATE_VALUE * 3.25
	availability_prob = 100

/datum/market_item/tool/caravan_wrench
	name = "实验性扳手"
	desc = "您一直渴望拥有那种速度更快，使用更便捷的扳手！"
	item = /obj/item/wrench/caravan
	stock = 1

	price_min = CARGO_CRATE_VALUE * 2
	price_max = CARGO_CRATE_VALUE * 4
	availability_prob = 20

/datum/market_item/tool/caravan_wirecutters
	name = "实验性剪线钳"
	desc = "您一直渴望拥有那种速度更快，使用更便捷的剪线钳！"
	item = /obj/item/wirecutters/caravan
	stock = 1

	price_min = CARGO_CRATE_VALUE * 2
	price_max = CARGO_CRATE_VALUE * 4
	availability_prob = 20

/datum/market_item/tool/caravan_screwdriver
	name = "实验性螺丝刀"
	desc = "您一直渴望拥有那种速度更快，使用更便捷的螺丝刀！"
	item = /obj/item/screwdriver/caravan
	stock = 1

	price_min = CARGO_CRATE_VALUE * 2
	price_max = CARGO_CRATE_VALUE * 4
	availability_prob = 20

/datum/market_item/tool/caravan_crowbar
	name = "实验性撬棍"
	desc = "您一直渴望拥有那种速度更快，使用更便捷的撬棍！"
	item = /obj/item/crowbar/red/caravan
	stock = 1

	price_min = CARGO_CRATE_VALUE * 2
	price_max = CARGO_CRATE_VALUE * 4
	availability_prob = 20

/datum/market_item/tool/binoculars
	name = "望远镜"
	desc = "这个实用的小工具可以将你的视力提升150％！"
	item = /obj/item/binoculars
	stock = 1

	price_min = CARGO_CRATE_VALUE * 1.75
	price_max = CARGO_CRATE_VALUE * 4
	availability_prob = 30

/datum/market_item/tool/riot_shield
	name = "防暴盾牌"
	desc = "保护自己在当地警察局里免受意外骚乱!"
	item = /obj/item/shield/riot

	price_min = CARGO_CRATE_VALUE * 2.25
	price_max = CARGO_CRATE_VALUE * 3.25
	stock_max = 2
	availability_prob = 50

/datum/market_item/tool/thermite_bottle
	name = "铝热剂瓶"
	desc = "50u of Thermite to assist in creating a quick access point or get away!"
	item = /obj/item/reagent_containers/cup/bottle/thermite

	price_min = CARGO_CRATE_VALUE * 0.75
	price_max = CARGO_CRATE_VALUE
	stock_max = 3
	availability_prob = 30

/datum/market_item/tool/program_disk
	name = "Bootleg Data Disk"
	desc = "A data disk containing EXCLUSIVE and LIMITED modular programs. Legally, we're not allowed to tell you how we acquired them."
	item = /obj/item/disk/computer/black_market
	price_min = CARGO_CRATE_VALUE * 0.75
	price_max = CARGO_CRATE_VALUE * 2
	stock_max = 3
	availability_prob = 40
