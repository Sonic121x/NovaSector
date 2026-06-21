/datum/market_item/tool/ai_detector
	name = "人工智能探测器"
	desc = "一把功能齐全的多功能工具，当检测到人工智能监视时会变红，你不确定卖家是否知道这个功能的存在。"
	item = /obj/item/multitool/ai_detect
	price_min = CARGO_CRATE_VALUE
	price_max = CARGO_CRATE_VALUE * 1.5
	stock_max = 2
	availability_prob = 65

/datum/market_item/tool/doorforcer
	name = "阿克特公司撬棍"
	desc = "臭名昭著的殖民地撬棍，尽管纳米传讯安全委员会试图将其列入黑名单，但在黑市上仍能低调购得。"
	item = /obj/item/crowbar/large/doorforcer
	stock = 4
	price_min = CARGO_CRATE_VALUE * 0.5
	price_max = CARGO_CRATE_VALUE
	availability_prob = 100
