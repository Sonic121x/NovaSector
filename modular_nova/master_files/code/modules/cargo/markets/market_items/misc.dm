/datum/market_item/misc/shotglasses
	name = "特大号辛迪加子弹杯"
	desc = "一盒子弹杯，其设计容量远超其外观所能容纳的液体量..."
	item = /obj/item/storage/box/syndieshotglasses
	price_min = CARGO_CRATE_VALUE * 0.5
	price_max = CARGO_CRATE_VALUE
	stock_max = 3
	availability_prob = 80

/datum/market_item/clothing/no_slip_MOD
	name = "MOD防滑模块"
	desc = "Honk.co 真的不想让你拥有这些东西。"
	item = /obj/item/mod/module/noslip
	price_min = CARGO_CRATE_VALUE * 2
	price_max = CARGO_CRATE_VALUE * 4
	stock_max = 2
	availability_prob = 65

/datum/market_item/misc/sticker_box
	name = "辛迪加贴纸盒"
	desc = "内含8张随机贴纸，经过精密设计以模仿可疑物品，可能（也可能不）对愚弄船员有用。"
	item = /obj/item/storage/box/stickers/syndie_kit
	price_min = CARGO_CRATE_VALUE * 0.5
	price_max = CARGO_CRATE_VALUE
	stock_max = 2
	availability_prob = 50

/datum/market_item/misc/cardboard_cutout
	name = "自适应纸板人像盒"
	desc = "高度先进的小丑科技，允许你躲在纸板人像后面隐藏身份。"
	item = /obj/item/storage/box/syndie_kit/cutouts
	price_min = CARGO_CRATE_VALUE * 0.5
	price_max = CARGO_CRATE_VALUE
	stock_max = 2
	availability_prob = 50

/datum/market_item/misc/dehydrated_carp
	name = "脱水太空鲤鱼"
	desc = "一个太空鲤鱼的毛绒玩具，卖家称它对其儿子来说太凶了——所以现在出售。"
	item = /obj/item/toy/plush/carpplushie/dehy_carp
	price_min = CARGO_CRATE_VALUE * 0.5
	price_max = CARGO_CRATE_VALUE
	stock_max = 4
	availability_prob = 80


/datum/market_item/misc/foam_smg
	name = "泡沫部队冲锋枪"
	desc = "有人在黑市上出售的一把泡沫部队冲锋枪。别问为什么。泡沫部队弹匣需单独购买。"
	item = /obj/item/gun/ballistic/automatic/toy
	price_min = CARGO_CRATE_VALUE * 0.5
	price_max = CARGO_CRATE_VALUE
	stock_max = 2
	availability_prob = 80

/datum/market_item/misc/foam_smg_riotmag
	name = "泡沫部队冲锋枪弹匣"
	desc = "一个泡沫部队冲锋枪的弹匣，装满了防暴飞镖。泡沫部队冲锋枪需单独购买。"
	item = /obj/item/ammo_box/magazine/toy/smg/riot
	price_min = CARGO_CRATE_VALUE * 0.5
	price_max = CARGO_CRATE_VALUE
	stock_max = 2
	availability_prob = 80

/datum/market_item/misc/engineer_chip
	name = "工程师技能芯片"
	desc = "一块从工程师身上粗暴取出的技能芯片，仍沾有血迹。"
	item = /obj/item/skillchip/job/engineer
	price_min = CARGO_CRATE_VALUE * 2
	price_max = CARGO_CRATE_VALUE * 3
	stock_max = 1
	availability_prob = 35

/datum/market_item/misc/leadacid
	name = "铅酸电池"
	desc = "一块原始的电池。它相当大，而且感觉异常沉重。"
	item = /obj/item/stock_parts/power_store/cell/lead
	stock = 2
	price_min = CARGO_CRATE_VALUE * 4
	price_max = CARGO_CRATE_VALUE * 6
	availability_prob = 100
