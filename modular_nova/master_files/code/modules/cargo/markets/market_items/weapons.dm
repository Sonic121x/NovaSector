/datum/market_item/weapon/mosin_pro
	name = "Xhihao 'Rengo' Precision Rifle Stock"
	desc = "当然，它不包含任何真正会响的部件，但当你用多出的五发子弹吓唬他们时，谁还会笑呢？"
	item = /obj/item/crafting_conversion_kit/mosin_pro
	price_min = CARGO_CRATE_VALUE * 2
	price_max = CARGO_CRATE_VALUE * 4
	stock_max = 3
	availability_prob = 80

/datum/market_item/weapon/ablative_bat
	name = "消融棒球棍"
	desc = "一把完全由金属制成的棒球棍，卖家告诉你这曾属于一位著名运动员，不会便宜出售……"
	item = /obj/item/melee/baseball_bat/ablative
	price_min = CARGO_CRATE_VALUE * 6
	price_max = CARGO_CRATE_VALUE * 10
	stock_max = 1
	availability_prob = 55

/datum/market_item/weapon/edagger
	name = "不起眼的钢笔"
	desc = "一支看似普通的钢笔，笔夹（切换笔尖的部分）内安装了某种发生器。"
	item = /obj/item/pen/edagger
	price_min = CARGO_CRATE_VALUE * 3
	price_max = CARGO_CRATE_VALUE * 7
	stock_max = 1
	availability_prob = 25

/datum/market_item/weapon/telescopic_bronze
	name = "青铜头伸缩警棍"
	desc = "一根加固的伸缩警棍，很可能是从某个倒霉的军需官那里偷来的。"
	item = /obj/item/melee/baton/telescopic/bronze
	price_min = CARGO_CRATE_VALUE * 8
	price_max = CARGO_CRATE_VALUE * 13
	stock_max = 1
	availability_prob = 45

/datum/market_item/weapon/Assasin_kit
	name = "刺客入门套件"
	desc = "一套极度非法的枪械套件，不知何故流入了黑市。卖家声明对套件内容、其功能或未来所有者的行为概不负责。"
	item = /obj/item/storage/toolbox/guncase/nova/pistol/opfor/makarov
	price_min = CARGO_CRATE_VALUE * 15
	price_max = CARGO_CRATE_VALUE * 25
	stock_max = 1
	availability_prob = 5

/datum/market_item/weapon/hollowpoint9mm
	name = "9毫米空尖弹弹匣"
	desc = "8发装9毫米空尖弹弹匣。显然，这是非法获取的，而且很可能适配一把更非法的武器。"
	item = /obj/item/ammo_box/magazine/m9mm/hp
	price_min = CARGO_CRATE_VALUE * 0.5
	price_max = CARGO_CRATE_VALUE * 0.7
	stock_max = 3
	availability_prob = 15

/datum/market_item/weapon/sord
	name = "SORD"
	desc = "这东西烂得难以言喻，唯一比试图卖掉它更愚蠢的事，就是买下它。"
	item = /obj/item/sord
	price_min = CARGO_CRATE_VALUE * 0.5
	price_max = CARGO_CRATE_VALUE * 0.7
	stock_max = 1
	availability_prob = 100

/datum/market_item/weapon/carrotshiv
	name = "胡萝卜匕首"
	desc = "与其他胡萝卜不同，你最好让这东西离你的眼睛远点。"
	item = /obj/item/knife/shiv/carrot
	price_min = CARGO_CRATE_VALUE * 0.5
	price_max = CARGO_CRATE_VALUE * 0.7
	stock_max = 5
	availability_prob = 75

/datum/market_item/weapon/ultranif
	name = "血液窃取NIF软件"
	desc = "Reverse-engineered nanite template smuggled through so many customs and bounty hunters you're lucky to even see one. Won't go for cheap - it took us too much to get them."
	item = /obj/item/disk/nifsoft_uploader/mil_grade/blood_steal
	price_min = CARGO_CRATE_VALUE * 12
	price_max = CARGO_CRATE_VALUE * 24
	availability_prob = 40
	stock_max = 2

// Makes this even more expensive
/datum/market_item/weapon/dimensional_bomb
	price_min = CARGO_CRATE_VALUE * 180
	price_max = CARGO_CRATE_VALUE * 200

/datum/market_item/weapon/milspec_buck
	name = "军用规格鹿弹盒"
	desc = "一盒标准尺寸、斯卡伯勒制造、高装药量的鹿弹，共15发，专为那些热衷于造成严重身体伤害的人士准备。"
	item = /obj/item/ammo_box/advanced/s12gauge/buckshot/milspec
	price_min = CARGO_CRATE_VALUE * 3
	price_max = CARGO_CRATE_VALUE * 6
	availability_prob = 40
	stock_max = 3

/datum/market_item/weapon/milspec_slugs
	name = "军用规格独头弹盒"
	desc = "一盒标准尺寸、斯卡伯勒制造、高装药量的独头弹，共15发，专为那些热衷于造成严重身体伤害的人士准备。"
	item = /obj/item/ammo_box/advanced/s12gauge/milspec
	price_min = CARGO_CRATE_VALUE * 3
	price_max = CARGO_CRATE_VALUE * 6
	availability_prob = 40
	stock_max = 3
