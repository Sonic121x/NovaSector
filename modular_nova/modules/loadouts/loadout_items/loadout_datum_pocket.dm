// LOADOUT ITEM DATUMS FOR POCKET ITEMS, PLACED DIRECTLY INTO THE BACKPACK

/datum/loadout_category/pocket
	tab_order = /datum/loadout_category/toys::tab_order + 1

/datum/loadout_item/pocket_items/pre_equip_item(datum/outfit/outfit, datum/outfit/outfit_important_for_life, mob/living/carbon/human/equipper, visuals_only = FALSE) // these go in the backpack
	return FALSE

/datum/loadout_item/pocket_items/wallet/get_item_information()
	. = ..()
	.[FA_ICON_BOX] = "Auto-Filled"

/*
*	ITEMS BELOW HERE
*/

/datum/loadout_item/pocket_items/soap
	name = "肥皂块"
	item_path = /obj/item/soap
	group = "Gear"

/datum/loadout_item/pocket_items/tapeplayer
	name = "卡带录音机"
	item_path = /obj/item/taperecorder
	group = "Comfort"

/datum/loadout_item/pocket_items/tape
	name = "卡式录音带"
	item_path = /obj/item/tape/random
	group = "Comfort"

/datum/loadout_item/pocket_items/cheaplighter
	name = "打火机 - 廉价"
	item_path = /obj/item/lighter/greyscale
	group = "Smoking"

/datum/loadout_item/pocket_items/lighter
	name = "打火机 - Zippo"
	group = "Smoking"

/datum/loadout_item/pocket_items/cigarettes
	name = "Space Cigarette Pack"
	item_path = /obj/item/storage/fancy/cigarettes
	group = "Smoking"

/datum/loadout_item/pocket_items/drom
	name = "Dromedary Co. Cigarette Pack"
	item_path = /obj/item/storage/fancy/cigarettes/dromedaryco
	group = "Smoking"

/datum/loadout_item/pocket_items/uplift
	name = "Uplift Smooth Cigarette Pack"
	item_path = /obj/item/storage/fancy/cigarettes/cigpack_uplift
	group = "Smoking"

/datum/loadout_item/pocket_items/robust
	name = "Robust Cigarette Pack"
	item_path = /obj/item/storage/fancy/cigarettes/cigpack_robust
	group = "Smoking"

/datum/loadout_item/pocket_items/robustgold
	name = "Robust Gold Cigarette Pack"
	item_path = /obj/item/storage/fancy/cigarettes/cigpack_robustgold
	group = "Smoking"

/datum/loadout_item/pocket_items/midori
	name = "Midori Cigarette Pack"
	item_path = /obj/item/storage/fancy/cigarettes/cigpack_midori
	group = "Smoking"

/datum/loadout_item/pocket_items/candycig
	name = "Timmy's First Candy Cigarette Pack"
	item_path = /obj/item/storage/fancy/cigarettes/cigpack_candy
	group = "Smoking"

/datum/loadout_item/pocket_items/weedcig
	name = "Freak Brothers' Special Cigarette Pack"
	item_path = /obj/item/storage/fancy/cigarettes/cigpack_cannabis
	group = "Smoking"

/datum/loadout_item/pocket_items/thccig
	name = "Crown Smoke King's Haze Cigarette Pack"
	item_path = /obj/item/storage/fancy/cigarettes/crownhaze
	group = "Smoking"

/datum/loadout_item/pocket_items/cigarcase
	name = "Premium Cigar Case"
	item_path = /obj/item/storage/fancy/cigarettes/cigars
	group = "Smoking"

/datum/loadout_item/pocket_items/robustocigarcase
	name = "Cohiba Robusto Cigar Case"
	item_path = /obj/item/storage/fancy/cigarettes/cigars/cohiba
	group = "Smoking"

/datum/loadout_item/pocket_items/matches
	name = "火柴盒"
	item_path = /obj/item/storage/box/matches
	group = "Smoking"

/datum/loadout_item/pocket_items/cigar
	name = "雪茄"
	item_path = /obj/item/cigarette/cigar
	group = "Smoking"

/datum/loadout_item/pocket_items/folder
	name = "文件夹"
	item_path = /obj/item/folder
	group = "Comfort"


/datum/loadout_item/pocket_items/link_scryer
	name = "MODlink 窥探器"
	item_path = /obj/item/clothing/neck/link_scryer/loaded
	group = "Gear"

/datum/loadout_item/pocket_items/modular_laptop
	name = "模块化笔记本电脑"
	item_path = /obj/item/modular_computer/laptop/preset/civilian/closed
	group = "Gear"

/datum/loadout_item/pocket_items/newspaper
	name = "报纸"
	item_path = /obj/item/newspaper
	group = "Comfort"

/datum/loadout_item/pocket_items/cross
	name = "华丽十字架"
	item_path = /obj/item/crucifix
	group = "Comfort"

/datum/loadout_item/pocket_items/gum_pack
	name = "口香糖包"
	item_path = /obj/item/storage/box/gum
	group = "Comfort"

/datum/loadout_item/pocket_items/gum_pack_nicotine
	name = "口香糖包 - 尼古丁"
	item_path = /obj/item/storage/box/gum/nicotine
	group = "Comfort"

/datum/loadout_item/pocket_items/gum_pack_hp
	name = "口香糖包 - HP+"
	item_path = /obj/item/storage/box/gum/happiness
	group = "Comfort"

/datum/loadout_item/pocket_items/multipen
	name = "笔 - 多色"
	item_path = /obj/item/pen/fourcolor
	group = "Comfort"

/datum/loadout_item/pocket_items/fountainpen
	name = "笔 - 高级"
	item_path = /obj/item/pen/fountain
	group = "Comfort"

/datum/loadout_item/pocket_items/paicard
	name = "个人AI设备"
	item_path = /obj/item/pai_card
	group = "Comfort"

/datum/loadout_item/pocket_items/rag
	name = "抹布"
	item_path = /obj/item/rag
	group = "Gear"

/datum/loadout_item/pocket_items/razor
	name = "剃须刀"
	item_path = /obj/item/razor
	group = "Comfort"

/datum/loadout_item/pocket_items/ttsdevice
	name = "文本转语音设备"
	item_path = /obj/item/ttsdevice
	group = "Gear"

/datum/loadout_item/pocket_items/ringbox_diamond
	name = "戒指盒 - 钻石"
	item_path = /obj/item/storage/fancy/ringbox/diamond
	group = "Comfort"

/datum/loadout_item/pocket_items/ringbox_gold
	name = "戒指盒 - 黄金"
	item_path = /obj/item/storage/fancy/ringbox
	group = "Comfort"

/datum/loadout_item/pocket_items/ringbox_silver
	name = "戒指盒 - 白银"
	item_path = /obj/item/storage/fancy/ringbox/silver
	group = "Comfort"

/datum/loadout_item/pocket_items/paperbin
	name = "纸盒 - 纸张"
	item_path = /obj/item/paper_bin
	group = "Comfort"

/datum/loadout_item/pocket_items/paperbin_carbon
	name = "纸盒 - 复写纸"
	item_path = /obj/item/paper_bin/carbon
	group = "Comfort"

/datum/loadout_item/pocket_items/paperbin_construction
	name = "纸盒 - 工程用纸"
	item_path = /obj/item/paper_bin/construction
	group = "Comfort"

/datum/loadout_item/pocket_items/paperbin_natural
	name = "纸盒 - 天然纸"
	item_path = /obj/item/paper_bin/bundlenatural
	group = "Comfort"

/*
*	UTILITY
*/

/datum/loadout_item/pocket_items/medkit_pouch
	name = "殖民地急救包（空）"
	item_path = /obj/item/storage/pouch/cin_medkit
	group = "Gear"

/datum/loadout_item/pocket_items/general_pouch
	name = "殖民地通用包（空）"
	item_path = /obj/item/storage/pouch/cin_general
	group = "Gear"

/datum/loadout_item/pocket_items/medipen_pouch
	name = "殖民地医疗笔包（空）"
	item_path = /obj/item/storage/pouch/cin_medipens
	group = "Gear"

/datum/loadout_item/pocket_items/deforest_cheesekit
	name = "医疗包 - 民防"
	item_path = /obj/item/storage/medkit/civil_defense/stocked
	group = "Gear"

/datum/loadout_item/pocket_items/medkit
	name = "医疗包 - 急救"
	item_path = /obj/item/storage/medkit/regular
	group = "Gear"

/datum/loadout_item/pocket_items/deforest_frontiermedkit
	name = "医疗包 - 边疆"
	item_path = /obj/item/storage/medkit/frontier/stocked
	group = "Gear"

/datum/loadout_item/pocket_items/synthetic_medkit
	name = "医疗包 - 机器人学"
	item_path = /obj/item/storage/medkit/robotic_repair/stocked
	group = "Gear"

/datum/loadout_item/pocket_items/mini_extinguisher
	name = "迷你灭火器"
	item_path = /obj/item/extinguisher/mini
	group = "Gear"

/datum/loadout_item/pocket_items/neuroware_spacedrugs
	name = "神经芯片盒（万花筒）"
	item_path = /obj/item/storage/box/flat/neuroware/space_drugs
	group = "Comfort"

/datum/loadout_item/pocket_items/neuroware_thc
	name = "神经芯片盒（石头先生）"
	item_path = /obj/item/storage/box/flat/neuroware/thc
	group = "Comfort"

/datum/loadout_item/pocket_items/neuroware_mindbreaker
	name = "神经芯片盒（正极冲击64）"
	item_path = /obj/item/storage/box/flat/neuroware/mindbreaker
	group = "Comfort"

/datum/loadout_item/pocket_items/binoculars
	name = "双筒望远镜"
	item_path = /obj/item/binoculars
	group = "Gear"

/datum/loadout_item/pocket_items/drugs_happy
	name = "药瓶 - 快乐丸"
	item_path = /obj/item/storage/pill_bottle/happy
	group = "Comfort"

/datum/loadout_item/pocket_items/drugs_lsd
	name = "药瓶 - 心智崩解剂"
	item_path = /obj/item/storage/pill_bottle/lsd
	group = "Comfort"

/datum/loadout_item/pocket_items/random_pizza
	name = "随机披萨盒"
	item_path = /obj/item/pizzabox/random
	group = "Comfort"

/datum/loadout_item/pocket_items/moth_mre
	name = "口粮 - 蛾族"
	item_path = /obj/item/storage/box/mothic_rations
	group = "Comfort"

/datum/loadout_item/pocket_items/colonial_mre
	name = "口粮 - 殖民者"
	item_path = /obj/item/storage/box/colonial_rations
	group = "Comfort"

/datum/loadout_item/pocket_items/drugs_weed
	name = "种子 - 大麻"
	item_path = /obj/item/seeds/cannabis
	group = "Comfort"

/datum/loadout_item/pocket_items/drugs_liberty
	name = "种子 - 自由帽菇"
	item_path = /obj/item/seeds/liberty
	group = "Comfort"

/datum/loadout_item/pocket_items/drugs_reishi
	name = "种子 - 灵芝"
	item_path = /obj/item/seeds/reishi
	group = "Comfort"

/datum/loadout_item/pocket_items/six_beer
	name = "六罐装 - 啤酒"
	item_path = /obj/item/storage/cans/sixbeer
	group = "Comfort"

/datum/loadout_item/pocket_items/six_soda
	name = "六罐装 - 汽水"
	item_path = /obj/item/storage/cans/sixsoda
	group = "Comfort"

/datum/loadout_item/pocket_items/power_cell
	name = "标准电源单元"
	item_path = /obj/item/stock_parts/power_store/cell
	group = "Comfort"

/datum/loadout_item/pocket_items/cloth_ten
	name = "十张布料"
	item_path = /obj/item/stack/sheet/cloth/ten
	group = "Comfort"

/datum/loadout_item/pocket_items/ingredients
	name = "万能食材盒"
	item_path = /obj/item/storage/box/ingredients/wildcard
	group = "Comfort"

/datum/loadout_item/pocket_items/shaker
	name = "Drink Shaker"
	item_path = /obj/item/reagent_containers/cup/glass/shaker
	group = "Comfort"

/datum/loadout_item/pocket_items/primitive_centrifuge
	name = "Primitive Centrifuge"
	item_path = /obj/item/reagent_containers/cup/primitive_centrifuge
	group = "Comfort"

/datum/loadout_item/pocket_items/pizza_voucher
	name = "Pizza Voucher"
	item_path = /obj/item/pizzavoucher
	group = "Comfort"

/datum/loadout_item/pocket_items/spess_knife
	name = "Spess Knife"
	item_path = /obj/item/spess_knife
	group = "Comfort"

/datum/loadout_item/pocket_items/jerry_can
	name = "Jerry Can"
	item_path = /obj/item/reagent_containers/cup/jerrycan
	group = "Comfort"
/*
*	COSMETICS
*/

/datum/loadout_item/pocket_items/hairbrush
	name = "发刷"
	item_path = /obj/item/hairbrush
	group = "Cosmetics"

/datum/loadout_item/pocket_items/comb
	name = "梳子"
	item_path = /obj/item/hairbrush/comb
	group = "Cosmetics"

/datum/loadout_item/pocket_items/hairbrush
	name = "发刷"
	item_path = /obj/item/hairbrush
	group = "Cosmetics"

/datum/loadout_item/pocket_items/dye
	group = "Cosmetics"

/datum/loadout_item/pocket_items/hair_tie
	name = "发圈"
	item_path = /obj/item/clothing/head/hair_tie
	group = "Cosmetics"

/datum/loadout_item/pocket_items/hair_tie_scrunchie
	name = "发圈 - 发绳"
	item_path = /obj/item/clothing/head/hair_tie/scrunchie
	group = "Cosmetics"

/datum/loadout_item/pocket_items/hair_tie_plastic_beads
	name = "发圈 - 塑料珠"
	item_path = /obj/item/clothing/head/hair_tie/plastic_beads
	group = "Cosmetics"

/datum/loadout_item/pocket_items/hhmirror
	name = "手持镜"
	item_path = /obj/item/hhmirror
	group = "Cosmetics"

//LIPSTICK
/datum/loadout_item/pocket_items/lipstick
	group = "Cosmetics"

/datum/loadout_item/pocket_items/lipstick_black
	name = "唇膏（黑色）"
	item_path = /obj/item/lipstick/black
	group = "Cosmetics"

/datum/loadout_item/pocket_items/lipstick_blue
	name = "唇膏（蓝色）"
	item_path = /obj/item/lipstick/blue
	group = "Cosmetics"

/datum/loadout_item/pocket_items/lipstick_green
	name = "口红（绿色）"
	item_path = /obj/item/lipstick/green
	group = "Cosmetics"

/datum/loadout_item/pocket_items/lipstick_jade
	name = "口红（玉色）"
	item_path = /obj/item/lipstick/jade
	group = "Cosmetics"

/datum/loadout_item/pocket_items/lipstick_purple
	name = "口红（紫色）"
	item_path = /obj/item/lipstick/purple
	group = "Cosmetics"

/datum/loadout_item/pocket_items/lipstick_white
	name = "口红（白色）"
	item_path = /obj/item/lipstick/white
	group = "Cosmetics"

//PERFUME
/datum/loadout_item/pocket_items/fragrance_amber
	name = "香水（琥珀）"
	item_path = /obj/item/perfume/amber
	group = "Cosmetics"

/datum/loadout_item/pocket_items/fragrance_cherry
	name = "香水（樱桃）"
	item_path = /obj/item/perfume/cherry
	group = "Cosmetics"

/datum/loadout_item/pocket_items/fragrance_jasmine
	name = "香水（茉莉）"
	item_path = /obj/item/perfume/jasmine
	group = "Cosmetics"

/datum/loadout_item/pocket_items/fragrance_mint
	name = "香水（薄荷）"
	item_path = /obj/item/perfume/mint
	group = "Cosmetics"

/datum/loadout_item/pocket_items/fragrance_pear
	name = "香水（梨）"
	item_path = /obj/item/perfume/pear
	group = "Cosmetics"

/datum/loadout_item/pocket_items/fragrance_rose
	name = "香水（玫瑰）"
	item_path = /obj/item/perfume/rose
	group = "Cosmetics"

/datum/loadout_item/pocket_items/fragrance_strawberry
	name = "香水（草莓）"
	item_path = /obj/item/perfume/strawberry
	group = "Cosmetics"

/datum/loadout_item/pocket_items/fragrance_vanilla
	name = "香水（香草）"
	item_path = /obj/item/perfume/vanilla
	group = "Cosmetics"

/datum/loadout_item/pocket_items/fragrance_wood
	name = "香水（木质）"
	item_path = /obj/item/perfume/wood
	group = "Cosmetics"

/datum/loadout_item/pocket_items/fragrance_cologne
	name = "香水 - 古龙水"
	item_path = /obj/item/perfume/cologne
	group = "Cosmetics"
/*
*	FLAGS
*/

/datum/loadout_item/pocket_items/gay_pride_flag
	name = "Pride Flag - Rainbow"
	item_path = /obj/item/sign/flag/pride/gay
	group = "Comfort"

/datum/loadout_item/pocket_items/ace_pride_flag
	name = "Pride Flag - Asexual"
	item_path = /obj/item/sign/flag/pride/ace
	group = "Comfort"

/datum/loadout_item/pocket_items/bi_pride_flag
	name = "Pride Flag - Bisexual"
	item_path = /obj/item/sign/flag/pride/bi
	group = "Comfort"

/datum/loadout_item/pocket_items/lesbian_pride_flag
	name = "Pride Flag - Lesbian"
	item_path = /obj/item/sign/flag/pride/lesbian
	group = "Comfort"

/datum/loadout_item/pocket_items/pan_pride_flag
	name = "Pride Flag - Pansexual"
	item_path = /obj/item/sign/flag/pride/pan
	group = "Comfort"

/datum/loadout_item/pocket_items/trans_pride_flag
	name = "Pride Flag - Transgender"
	item_path = /obj/item/sign/flag/pride/trans
	group = "Comfort"

/datum/loadout_item/pocket_items/nb_pride_flag
	name = "Pride Flag - Non-binary"
	item_path = /obj/item/sign/flag/pride/nonbinary
	group = "Comfort"
/*
*	JOB-LOCKED
*/
// No group (groups should be ~5+ items)

/datum/loadout_item/pocket_items/crusher_sword_kit
	name = "粉碎者改装套件"
	item_path = /obj/item/crusher_trophy/retool_kit
	restricted_roles = list(JOB_SHAFT_MINER)

/*
*	DONATOR
*/

/datum/loadout_item/pocket_items/donator
	abstract_type = /datum/loadout_item/pocket_items/donator
	donator_only = TRUE

/datum/loadout_item/pocket_items/donator/coin
	name = "铁币"
	item_path = /obj/item/coin/iron
	group = "Comfort"

/datum/loadout_item/pocket_items/donator/havana_cigar_case
	name = "哈瓦那雪茄"
	item_path = /obj/item/storage/fancy/cigarettes/cigars/havana
	group = "Smoking"

/datum/loadout_item/pocket_items/donator/vape
	name = "电子烟"
	item_path = /obj/item/vape
	group = "Smoking"
