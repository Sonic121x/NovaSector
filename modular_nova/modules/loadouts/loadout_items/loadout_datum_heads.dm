// LOADOUT ITEM DATUMS FOR THE HEAD SLOT

/datum/loadout_item/head/pre_equip_item(datum/outfit/outfit, datum/outfit/outfit_important_for_life, mob/living/carbon/human/equipper, visuals_only = FALSE)
	if(initial(outfit_important_for_life.head))
		.. ()
		return TRUE

/datum/loadout_item/head/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE, override_items = LOADOUT_OVERRIDE_BACKPACK)
	if(override_items == LOADOUT_OVERRIDE_BACKPACK && !visuals_only)
		if(outfit.head)
			LAZYADD(outfit.backpack_contents, outfit.head)
		outfit.head = item_path
	else
		outfit.head = item_path

/*
*	ITEMS BELOW HERE
*/

/datum/loadout_item/head/wrussian
	name = "帕帕哈帽（可重着色）"
	item_path = /obj/item/clothing/head/costume/nova/papakha

/datum/loadout_item/head/standalone_hood
	name = "Hood"
	item_path = /obj/item/clothing/head/standalone_hood

/*
*	BEANIES
*/

/datum/loadout_item/head/white_beanie
	name = "针织帽（可着色）"
	item_path = /obj/item/clothing/head/beanie

/datum/loadout_item/head/black_beanie
	name = "针织帽（黑色）"
	item_path = /obj/item/clothing/head/beanie/black
	loadout_flags = parent_type::loadout_flags | LOADOUT_FLAG_BLOCK_GREYSCALING

/datum/loadout_item/head/dark_blue_beanie
	name = "针织帽（深蓝色）"
	item_path = /obj/item/clothing/head/beanie/darkblue
	loadout_flags = parent_type::loadout_flags | LOADOUT_FLAG_BLOCK_GREYSCALING

/datum/loadout_item/head/orange_beanie
	name = "针织帽（橙色）"
	item_path = /obj/item/clothing/head/beanie/orange
	loadout_flags = parent_type::loadout_flags | LOADOUT_FLAG_BLOCK_GREYSCALING

/datum/loadout_item/head/red_beanie
	name = "针织帽（红色）"
	item_path = /obj/item/clothing/head/beanie/red
	loadout_flags = parent_type::loadout_flags | LOADOUT_FLAG_BLOCK_GREYSCALING

/datum/loadout_item/head/yellow_beanie
	name = "针织帽（黄色）"
	item_path = /obj/item/clothing/head/beanie/yellow
	loadout_flags = parent_type::loadout_flags | LOADOUT_FLAG_BLOCK_GREYSCALING

/datum/loadout_item/head/christmas_beanie
	name = "针织帽 - 圣诞款"
	item_path = /obj/item/clothing/head/beanie/christmas
	loadout_flags = parent_type::loadout_flags | LOADOUT_FLAG_BLOCK_GREYSCALING

/*
*	BERETS
*/

/datum/loadout_item/head/greyscale_beret
	name = "贝雷帽（可着色）"
	item_path = /obj/item/clothing/head/beret

/datum/loadout_item/head/greyscale_beret/badge
	name = "贝雷帽（带徽章，可着色）"
	item_path = /obj/item/clothing/head/beret/badge

/datum/loadout_item/head/atmos_beret
	name = "贝雷帽 - 大气处理部"
	item_path = /obj/item/clothing/head/beret/atmos
	group = "Jobs"

/datum/loadout_item/head/beret_chem
	name = "贝雷帽 - 化学家"
	item_path = /obj/item/clothing/head/beret/medical/chemist
	group = "Jobs"

/datum/loadout_item/head/engi_beret
	name = "贝雷帽 - 工程部"
	item_path = /obj/item/clothing/head/beret/engi
	group = "Jobs"

/datum/loadout_item/head/beret_med
	name = "贝雷帽 - 医疗"
	item_path = /obj/item/clothing/head/beret/medical
	group = "Jobs"

/datum/loadout_item/head/beret_paramedic
	name = "贝雷帽 - 护理员"
	item_path = /obj/item/clothing/head/beret/medical/paramedic
	group = "Jobs"

/datum/loadout_item/head/beret_robo
	name = "贝雷帽 - 机械师"
	item_path = /obj/item/clothing/head/beret/science/fancy/robo
	group = "Jobs"

/datum/loadout_item/head/beret_sci
	name = "贝雷帽 - 科学家"
	item_path = /obj/item/clothing/head/beret/science
	group = "Jobs"

/datum/loadout_item/head/cargo_beret
	name = "贝雷帽 - 补给"
	item_path = /obj/item/clothing/head/beret/cargo
	group = "Jobs"

/datum/loadout_item/head/beret_viro
	name = "贝雷帽 - 病毒学家"
	item_path = /obj/item/clothing/head/beret/medical/virologist
	group = "Jobs"

/datum/loadout_item/head/beret_clown
	name = "贝雷帽 - 小丑"
	item_path = /obj/item/clothing/head/beret/clown
	group = "Jobs"

/*
*	CAPS
*/

/datum/loadout_item/head/delinquent_cap
	name = "帽子 - 不良少年"

/datum/loadout_item/head/mail_cap
	name = "帽子 - 邮递"

/datum/loadout_item/head/flatcap
	name = "帽子 - 平顶"

/datum/loadout_item/head/pflatcap
	name = "帽子 - 平顶 (可着色)"
	item_path = /obj/item/clothing/head/colourable_flatcap

/datum/loadout_item/head/hflatcap
	name = "Cap - Mobster Flat"
	item_path = /obj/item/clothing/head/henchmen_hat


/datum/loadout_item/head/fashionable_cap
	name = "帽子 - 棒球帽"
	item_path = /obj/item/clothing/head/soft/yankee

/datum/loadout_item/head/colonialcap
	name = "帽子 - 殖民风格"
	item_path = /obj/item/clothing/head/hats/colonial
	species_blacklist = list(SPECIES_TESHARI)

/datum/loadout_item/head/frontiercap
	name = "帽子 - 边疆风格"
	item_path = /obj/item/clothing/head/soft/frontier_colonist

/datum/loadout_item/head/frontiercap/medic
	name = "帽子 - 边疆医疗"
	item_path = /obj/item/clothing/head/soft/frontier_colonist/medic

/datum/loadout_item/head/tarkon
	name = "塔肯焊接面罩"
	item_path = /obj/item/clothing/head/utility/welding/hat
	blacklisted_roles = list(JOB_PRISONER)
	group = "Jobs"

/datum/loadout_item/head/welder
	name = "普通焊接面罩"
	item_path = /obj/item/clothing/head/utility/welding
	blacklisted_roles = list(JOB_PRISONER)

/*
*	FEDORAS
*/

/datum/loadout_item/head/greyscale_fedora
	name = "软呢帽 (可着色)"
	item_path = /obj/item/clothing/head/fedora/greyscale

/datum/loadout_item/head/brown_fedora
	name = "软呢帽 (棕色)"
	item_path = /obj/item/clothing/head/fedora/brown

/*
*	HARDHATS
*/

/datum/loadout_item/head/dark_blue_hardhat
	name = "安全帽 (深蓝色)"
	item_path = /obj/item/clothing/head/utility/hardhat/dblue

/datum/loadout_item/head/orange_hardhat
	name = "安全帽（橙色）"
	item_path = /obj/item/clothing/head/utility/hardhat/orange

/datum/loadout_item/head/red_hardhat
	name = "安全帽（红色）"
	item_path = /obj/item/clothing/head/utility/hardhat/red

/datum/loadout_item/head/white_hardhat
	name = "安全帽（白色）"
	item_path = /obj/item/clothing/head/utility/hardhat/white

/datum/loadout_item/head/yellow_hardhat
	name = "安全帽（黄色）"
	item_path = /obj/item/clothing/head/utility/hardhat

/*
*	MISCELLANEOUS
*	(For things that aren't QUITE a hat, y'know?)
*/

/datum/loadout_item/head/back_bow
	name = "蝴蝶结 - 后系式"
	item_path = /obj/item/clothing/head/large_bow/back_bow
	group = "Miscellaneous"

/datum/loadout_item/head/large_bow
	name = "蝴蝶结 - 大型"
	item_path = /obj/item/clothing/head/large_bow
	group = "Miscellaneous"

/datum/loadout_item/head/small_bow
	name = "蝴蝶结 - 小型"
	item_path = /obj/item/clothing/head/small_bow
	group = "Miscellaneous"

/datum/loadout_item/head/sweet_bow
	name = "蝴蝶结 - 甜美款"
	item_path = /obj/item/clothing/head/large_bow/sweet_bow
	group = "Miscellaneous"

/datum/loadout_item/head/cone_of_shame
	name = "耻辱锥"
	item_path = /obj/item/clothing/head/cone_of_shame
	group = "Miscellaneous"

/datum/loadout_item/head/warning_cone
	name = "Warning Cone"
	item_path = /obj/item/clothing/head/cone
	group = "Miscellaneous"

/datum/loadout_item/head/wig //TG overwrite so that we can have both fake/natural wigs
	name = "假发"
	item_path = /obj/item/clothing/head/wig
	group = "Miscellaneous"

/datum/loadout_item/head/wignatural
	name = "假发 - 自然款"
	item_path = /obj/item/clothing/head/wig/natural
	group = "Miscellaneous"

// FLOWERS
/datum/loadout_item/head/geranium
	name = "花朵 - 天竺葵"
	group = "Miscellaneous"

/datum/loadout_item/head/harebell
	name = "花朵 - 风铃草"
	group = "Miscellaneous"

/datum/loadout_item/head/lily
	name = "花朵 - 百合"
	group = "Miscellaneous"

/datum/loadout_item/head/poppy
	name = "花朵 - 罂粟"
	group = "Miscellaneous"

/datum/loadout_item/head/rose
	name = "花朵 - 玫瑰"
	group = "Miscellaneous"

/datum/loadout_item/head/sunflower
	name = "花朵 - 向日葵"
	group = "Miscellaneous"

/datum/loadout_item/head/floral_garland
	name = "花环"
	item_path = /obj/item/clothing/head/costume/garland
	group = "Miscellaneous"

/datum/loadout_item/head/lily_crown
	name = "花冠 - 百合"
	item_path = /obj/item/clothing/head/costume/garland/lily
	group = "Miscellaneous"

/datum/loadout_item/head/poppy_crown
	name = "花冠 - 罂粟"
	item_path = /obj/item/clothing/head/costume/garland/poppy
	group = "Miscellaneous"

/datum/loadout_item/head/sunflower_crown
	name = "花冠 - 向日葵"
	item_path = /obj/item/clothing/head/costume/garland/sunflower
	group = "Miscellaneous"

/datum/loadout_item/head/flowerpin
	name = "花朵发夹"
	item_path = /obj/item/clothing/head/costume/nova/flowerpin
	group = "Miscellaneous"

/*
*	COSTUME
*/

/datum/loadout_item/head/roman_helmet
	name = "Roman Helmet"
	item_path = /obj/item/clothing/head/helmet/roman/fake
	group = "Costumes"

/datum/loadout_item/head/rastafarian
	group = "Costumes"

/datum/loadout_item/head/kitty_ears
	group = "Costumes"

/datum/loadout_item/head/rabbit_ears
	group = "Playbunny Ears"

/datum/loadout_item/head/glassdome
	name = "Fish Bowl Helmet"
	item_path = /obj/item/clothing/head/helmet/glassdome
	group = "Costumes"

/datum/loadout_item/head/synde
	name = "黑色太空头盔复制品"
	item_path = /obj/item/clothing/head/syndicatefake
	group = "Costumes"

/datum/loadout_item/head/blastwave_helmet
	name = "冲击波塑料头盔"
	item_path = /obj/item/clothing/head/blastwave
	group = "Costumes"

/datum/loadout_item/head/blastwave_cap
	name = "冲击波鸭舌帽"
	item_path = /obj/item/clothing/head/blastwave/officer
	group = "Costumes"

/datum/loadout_item/head/deckers
	name = "迪克斯帽"
	item_path = /obj/item/clothing/head/costume/deckers
	group = "Costumes"

/datum/loadout_item/head/hairpin
	name = "华丽发簪"
	item_path = /obj/item/clothing/head/costume/hairpin
	group = "Costumes"

/datum/loadout_item/head/saints
	name = "华丽礼帽（可着色）"
	item_path = /obj/item/clothing/head/costume/fancy
	group = "Costumes"

/datum/loadout_item/head/flakhelm
	name = "防弹头盔"
	item_path = /obj/item/clothing/head/hats/flakhelm
	group = "Costumes"

/datum/loadout_item/head/glatiator
	name = "角斗士头盔"
	item_path = /obj/item/clothing/head/helmet/gladiator
	group = "Costumes"

/datum/loadout_item/head/griffin
	name = "狮鹫头套"
	item_path = /obj/item/clothing/head/costume/griffin
	group = "Costumes"

/datum/loadout_item/head/jester
	name = "小丑帽"
	item_path = /obj/item/clothing/head/costume/jester
	group = "Costumes"

/datum/loadout_item/head/jesteralt
	name = "小丑帽 - 变体"
	item_path = /obj/item/clothing/head/costume/jesteralt
	group = "Costumes"

/datum/loadout_item/head/nursehat
	name = "护士帽"
	item_path = /obj/item/clothing/head/costume/nursehat
	group = "Costumes"

/datum/loadout_item/head/pirate_bandana
	name = "海盗头巾"
	item_path = /obj/item/clothing/head/costume/pirate/bandana
	group = "Costumes"

/datum/loadout_item/head/pirate
	name = "海盗帽"
	item_path = /obj/item/clothing/head/costume/pirate
	group = "Costumes"

/datum/loadout_item/head/plague_hat
	name = "瘟疫医生帽"
	item_path = /obj/item/clothing/head/bio_hood/plague
	group = "Costumes"

/datum/loadout_item/head/rice_hat
	name = "斗笠"
	item_path = /obj/item/clothing/head/costume/rice_hat
	group = "Costumes"

/datum/loadout_item/head/slime
	name = "史莱姆帽"
	item_path = /obj/item/clothing/head/collectable/slime
	group = "Costumes"

/datum/loadout_item/head/sombrero
	name = "墨西哥宽边帽"
	item_path = /obj/item/clothing/head/costume/sombrero
	group = "Costumes"

/datum/loadout_item/head/cybergoggles_civ
	name = "34C型法证头饰"
	item_path = /obj/item/clothing/head/fedora/det_hat/cybergoggles/civilian
	group = "Costumes"

/datum/loadout_item/head/wedding_veil
	name = "婚礼头纱"
	item_path = /obj/item/clothing/head/costume/weddingveil
	group = "Costumes"

/datum/loadout_item/head/witch
	name = "女巫帽"
	item_path = /obj/item/clothing/head/wizard/marisa/fake
	group = "Costumes"

/datum/loadout_item/head/wizard
	name = "巫师帽"
	item_path = /obj/item/clothing/head/wizard/fake
	group = "Costumes"

/datum/loadout_item/head/xenos
	name = "异形头盔"
	item_path = /obj/item/clothing/head/costume/xenos
	group = "Costumes"

//Pelts
/datum/loadout_item/head/bear_pelt
	name = "毛皮 - 熊（太空）"
	group = "Costumes"

/datum/loadout_item/head/bearpeltblack
	name = "毛皮 - 熊（黑色）"
	item_path = /obj/item/clothing/head/pelt/black
	group = "Costumes"

/datum/loadout_item/head/bearpelt
	name = "毛皮 - 熊（棕色）"
	item_path = /obj/item/clothing/head/pelt
	group = "Costumes"

/datum/loadout_item/head/bearpeltwhite
	name = "毛皮 - 熊（白色）"
	item_path = /obj/item/clothing/head/pelt/white
	group = "Costumes"

/datum/loadout_item/head/tigerpelt
	name = "毛皮 - 虎"
	item_path = /obj/item/clothing/head/pelt/tiger
	group = "Costumes"

/datum/loadout_item/head/tigerpeltpink
	name = "毛皮 - 虎（粉色）"
	item_path = /obj/item/clothing/head/pelt/pink_tiger
	group = "Costumes"

/datum/loadout_item/head/tigerpeltsnow
	name = "毛皮 - 虎（雪地）"
	item_path = /obj/item/clothing/head/pelt/snow_tiger
	group = "Costumes"

/datum/loadout_item/head/wolfpeltblack
	name = "毛皮 - 狼（黑色）"
	item_path = /obj/item/clothing/head/pelt/wolf/black
	group = "Costumes"

/datum/loadout_item/head/wolfpelt
	name = "毛皮 - 狼（棕色）"
	item_path = /obj/item/clothing/head/pelt/wolf
	group = "Costumes"

/datum/loadout_item/head/wolfpeltwhite
	name = "毛皮 - 狼（白色）"
	item_path = /obj/item/clothing/head/pelt/wolf/white
	group = "Costumes"

//Maid
/datum/loadout_item/head/maid_headband
	name = "女仆头带（可着色）"
	item_path = /obj/item/clothing/head/maid_headband
	group = "Costumes"

/datum/loadout_item/head/maidhead
	name = "女仆头带 - 简约款"
	item_path = /obj/item/clothing/head/costume/nova/maid
	group = "Costumes"

/datum/loadout_item/head/tactical_headband
	name = "女仆头带 - 战术款"
	item_path = /obj/item/clothing/head/costume/maid_headband/syndicate/loadout_headband
	group = "Costumes"

/datum/loadout_item/head/maidhead/get_item_information()
	. = ..()
	.[FA_ICON_HAT_COWBOY] = "Top of Head"

/datum/loadout_item/head/maidhead2
	name = "女仆头带 - 荷叶边款"
	item_path = /obj/item/clothing/head/costume/maid_headband
	group = "Costumes"

/datum/loadout_item/head/maidhead2/get_item_information()
	. = ..()
	.[FA_ICON_EAR_DEAF] = "Behind Ears"

//Chaplain
/datum/loadout_item/head/chap_nunh
	name = "修女兜帽"
	item_path = /obj/item/clothing/head/chaplain/nun_hood
	group = "Costumes"

/datum/loadout_item/head/chap_nunv
	name = "修女面纱"
	item_path = /obj/item/clothing/head/chaplain/habit_veil
	group = "Costumes"

/datum/loadout_item/head/chap_kippah
	name = "犹太圆顶小帽"
	item_path = /obj/item/clothing/head/chaplain/kippah
	group = "Costumes"

/*
*	SPECIES
*/

/datum/loadout_item/head/mothcap
	name = "蛾族软帽"
	item_path = /obj/item/clothing/head/mothcap
	group = "Species-Unique"

/datum/loadout_item/head/skrell_chain_gold
	name = "史奎利头链 - 金色"
	item_path = /obj/item/clothing/head/skrell_chain
	group = "Species-Unique"

/datum/loadout_item/head/skrell_chain_silver
	name = "史奎利头链 - 银色"
	item_path = /obj/item/clothing/head/skrell_chain/silver
	group = "Species-Unique"

/datum/loadout_item/head/akula_helmet
	name = "岸装头盔"
	item_path = /obj/item/clothing/head/helmet/space/akula_wetsuit
	group = "Species-Unique"

/datum/loadout_item/head/azulea_oldblood
	name = "古老血脉皇家帽"
	item_path = /obj/item/clothing/head/hats/caphat/azulean/old_blood
	group = "Species-Unique"

/datum/loadout_item/head/azulea_upstart
	name = "新晋贵族帽"
	item_path = /obj/item/clothing/head/hats/caphat/azulean/upstart
	group = "Species-Unique"

/*
*	COWBOY
*/

/datum/loadout_item/head/cowboyhat
	name = "牛仔帽"
	item_path = /obj/item/clothing/head/cowboy/nova/cattleman

/datum/loadout_item/head/cowboyhat_black
	name = "牛仔帽 - 宽檐款"
	item_path = /obj/item/clothing/head/cowboy/nova/cattleman/wide

/datum/loadout_item/head/cowboyhat_wide
	name = "宽檐帽"
	item_path = /obj/item/clothing/head/cowboy/nova/wide

/datum/loadout_item/head/cowboyhat_wide_feather
	name = "宽檐羽饰帽"
	item_path = /obj/item/clothing/head/cowboy/nova/wide/feathered

/datum/loadout_item/head/cowboyhat_flat
	name = "平檐帽"
	item_path = /obj/item/clothing/head/cowboy/nova/flat

/datum/loadout_item/head/cowboyhat_flat_cowl
	name = "带兜帽平檐帽"
	item_path = /obj/item/clothing/head/cowboy/nova/flat/cowl

/datum/loadout_item/head/cowboyhat_winter
	name = "带兜帽平檐帽 - 冬季款"
	item_path = /obj/item/clothing/head/cowboy/nova/flat/cowl/sheriff

/datum/loadout_item/head/cowboyhat_sheriff
	name = "平檐帽 - 警长款"
	item_path = /obj/item/clothing/head/cowboy/nova/flat/sheriff

/datum/loadout_item/head/cowboyhat_deputy
	name = "平檐帽 - 副警长款"
	item_path = /obj/item/clothing/head/cowboy/nova/flat/deputy

// Legacy unpaintable cowboy hat because it fits a character better
/datum/loadout_item/head/cowboyhat_legacy
	name = "牛仔帽（旧版）"
	item_path = /obj/item/clothing/head/costume/cowboyhat_old

/*
*	TREK/STAR WARS
*/

/datum/loadout_item/head/trekcap
	name = "军官帽（白色）"
	item_path = /obj/item/clothing/head/hats/caphat/parade/fedcap
	group = "Jobs"

/datum/loadout_item/head/trekcapcap
	name = "军官帽（黑色）"
	item_path = /obj/item/clothing/head/hats/caphat/parade/fedcap/black
	group = "Jobs"

/datum/loadout_item/head/trekcapmedisci
	name = "军官帽 - 医疗科学部（蓝色）"
	item_path = /obj/item/clothing/head/hats/caphat/parade/fedcap/medsci
	group = "Jobs"

/datum/loadout_item/head/trekcapeng
	name = "军官帽 - 工程部（黄色）"
	item_path = /obj/item/clothing/head/hats/caphat/parade/fedcap/eng
	group = "Jobs"

/datum/loadout_item/head/trekcapsec
	name = "军官帽 - 行动安保部（红色）"
	item_path = /obj/item/clothing/head/hats/caphat/parade/fedcap/sec
	group = "Jobs"

/datum/loadout_item/head/trekcapcustom
	name = "军官帽（可着色）"
	item_path = /obj/item/clothing/head/hats/caphat/parade/fedcap/custom

/datum/loadout_item/head/trekcapcustom_gold
	name = "军官帽（可着色，金色徽章）"
	item_path = /obj/item/clothing/head/hats/caphat/parade/fedcap/custom/gold

/datum/loadout_item/head/navalcap
	name = "海军帽（可着色）"
	item_path = /obj/item/clothing/head/hats/caphat/naval/custom

/datum/loadout_item/head/navalcap_gold
	name = "海军帽（可着色，金色徽章）"
	item_path = /obj/item/clothing/head/hats/caphat/naval/custom/gold


/datum/loadout_item/head/imperial_generic
	name = "海军军官帽"
	item_path = /obj/item/clothing/head/hats/imperial
/*
*	JOBS
*/

//COM
/datum/loadout_item/head/imperial_cap
	name = "舰长的海军帽"
	item_path = /obj/item/clothing/head/hats/imperial/cap
	restricted_roles = list(JOB_CAPTAIN, JOB_NT_REP)
	group = "Jobs"

//SERV
/datum/loadout_item/head/imperial_hop
	name = "人事主管的海军帽"
	item_path = /obj/item/clothing/head/hats/imperial/hop
	restricted_roles = list(JOB_HEAD_OF_PERSONNEL, JOB_NT_REP)
	group = "Jobs"

//MED
/datum/loadout_item/head/imperial_cmo
	name = "首席医疗官的海军帽"
	item_path = /obj/item/clothing/head/hats/imperial/cmo
	restricted_roles = list(JOB_CHIEF_MEDICAL_OFFICER)
	group = "Jobs"

//ENGI
/datum/loadout_item/head/imperial_ce
	name = "首席工程师的防爆头盔"
	item_path = /obj/item/clothing/head/hats/imperial/ce
	restricted_roles = list(JOB_CHIEF_ENGINEER)
	group = "Jobs"

//SEC
/datum/loadout_item/head/navybluehoscap
	name = "安全主管的海军帽"
	item_path = /obj/item/clothing/head/hats/imperial/hos
	restricted_roles = list(JOB_HEAD_OF_SECURITY)
	group = "Jobs"

/datum/loadout_item/head/navybluewardenberet
	name = "典狱长的贝雷帽（海军蓝）"
	item_path = /obj/item/clothing/head/beret/sec/navywarden
	restricted_roles = list(JOB_WARDEN)
	group = "Jobs"

/datum/loadout_item/head/officerberet
	name = "安保贝雷帽"
	item_path = /obj/item/clothing/head/beret/sec/nova
	restricted_roles = list(ALL_JOBS_SEC)
	group = "Jobs"

/datum/loadout_item/head/navyblueofficerberet
	name = "安保贝雷帽（海军蓝）"
	item_path = /obj/item/clothing/head/beret/sec/navyofficer
	restricted_roles = list(ALL_JOBS_SEC)
	group = "Jobs"

/datum/loadout_item/head/officercap
	name = "安保帽"
	item_path = /obj/item/clothing/head/security_cap
	restricted_roles = list(ALL_JOBS_SEC)
	group = "Jobs"

/datum/loadout_item/head/officergarrisoncap
	name = "安保帽 - 驻防型"
	item_path = /obj/item/clothing/head/security_garrison
	restricted_roles = list(ALL_JOBS_SEC)
	group = "Jobs"

/datum/loadout_item/head/officerpatrolcap
	name = "安保帽 - 巡逻型"
	item_path = /obj/item/clothing/head/hats/warden/police/patrol
	restricted_roles = list(ALL_JOBS_SEC)
	group = "Jobs"

/datum/loadout_item/head/cowboyhat_sec
	name = "安保牛仔帽"
	item_path = /obj/item/clothing/head/cowboy/nova/cattleman/sec
	restricted_roles = list(ALL_JOBS_SEC)
	group = "Jobs"

/datum/loadout_item/head/cowboyhat_secwide
	name = "安保牛仔帽 - 宽檐款"
	item_path = /obj/item/clothing/head/cowboy/nova/cattleman/wide/sec
	restricted_roles = list(ALL_JOBS_SEC)
	group = "Jobs"

/datum/loadout_item/head/ushanka/sec
	name = "安保乌纱卡帽"
	item_path = /obj/item/clothing/head/costume/ushanka/sec
	restricted_roles = list(ALL_JOBS_SEC)
	group = "Jobs"

/datum/loadout_item/head/cybergoggles //Cyberpunk-P.I. Outfit
	name = "侦探用 34P型法证头戴设备"
	item_path = /obj/item/clothing/head/fedora/det_hat/cybergoggles
	restricted_roles = list(ALL_JOBS_SEC)
	group = "Jobs"

/datum/loadout_item/head/detfedora
	name = "侦探用软呢帽"
	item_path = /obj/item/clothing/head/fedora/det_hat
	restricted_roles = list(JOB_DETECTIVE)
	group = "Jobs"

/datum/loadout_item/head/rabbit
	name = "Bunny Ears (Playbunny)"
	item_path = /obj/item/clothing/head/playbunnyears
	group = "Playbunny Ears"

/datum/loadout_item/head/rabbitplaybunny
	name = "Bunny Ears (CentCom)"
	item_path = /obj/item/clothing/head/playbunnyears/centcom
	restricted_roles = list(ALL_JOBS_CC)
	group = "Playbunny Ears"

/datum/loadout_item/head/rabbitplaybunnyusa
	name = "Bunny Ears (American)"
	item_path = /obj/item/clothing/head/playbunnyears/usa
	group = "Playbunny Ears"

/datum/loadout_item/head/rabbitplaybunnyussr
	name = "Bunny Ears (Soviet)"
	item_path = /obj/item/clothing/head/playbunnyears/communist
	group = "Playbunny Ears"

/datum/loadout_item/head/rabbitplaybunnybrit
	name = "Bunny Ears (British)"
	item_path = /obj/item/clothing/head/playbunnyears/british
	group = "Playbunny Ears"

/datum/loadout_item/head/rabbitplaybunnycap
	name = "Bunny Ears (Captain)"
	item_path = /obj/item/clothing/head/hats/caphat/bunnyears_captain
	restricted_roles = list(JOB_CAPTAIN)
	group = "Playbunny Ears"

/datum/loadout_item/head/rabbitplaybunnyqm
	name = "Bunny Ears (Quartermaster)"
	item_path = /obj/item/clothing/head/playbunnyears/quartermaster
	restricted_roles = list(JOB_QUARTERMASTER)
	group = "Playbunny Ears"

/datum/loadout_item/head/rabbitplaybunnycargo
	name = "Bunny Ears (Cargo)"
	item_path = /obj/item/clothing/head/playbunnyears/cargo
	group = "Playbunny Ears"

/datum/loadout_item/head/rabbitplaybunnymail
	name = "Bunny Ears (Courier)"
	item_path = /obj/item/clothing/head/playbunnyears/mailman
	group = "Playbunny Ears"

/datum/loadout_item/head/rabbitplaybunnybitrun
	name = "Bunny Ears (Gamer)"
	item_path = /obj/item/clothing/head/playbunnyears/bitrunner
	group = "Playbunny Ears"

/datum/loadout_item/head/rabbitplaybunnyengi
	name = "Bunny Ears (Engineer)"
	item_path = /obj/item/clothing/head/playbunnyears/engineer
	group = "Playbunny Ears"

/datum/loadout_item/head/rabbitplaybunnyengiatmos
	name = "Bunny Ears (Atmos Tech)"
	item_path = /obj/item/clothing/head/playbunnyears/atmos_tech
	group = "Playbunny Ears"

/datum/loadout_item/head/rabbitplaybunnyengice
	name = "Bunny Ears (Chief Engineer)"
	item_path = /obj/item/clothing/head/playbunnyears/ce
	restricted_roles = list(JOB_CHIEF_ENGINEER)
	group = "Playbunny Ears"

/datum/loadout_item/head/rabbitplaybunnymed
	name = "Bunny Ears (Medical)"
	item_path = /obj/item/clothing/head/playbunnyears/doctor
	group = "Playbunny Ears"

/datum/loadout_item/head/rabbitplaybunnymedpara
	name = "Bunny Ears (Paramedical)"
	item_path = /obj/item/clothing/head/playbunnyears/paramedic
	group = "Playbunny Ears"

/datum/loadout_item/head/rabbitplaybunnymedchem
	name = "Bunny Ears (Chemical)"
	item_path = /obj/item/clothing/head/playbunnyears/chemist
	group = "Playbunny Ears"

/datum/loadout_item/head/rabbit/playbunnymedviro
	name = "Bunny Ears (Pathological)"
	item_path = /obj/item/clothing/head/playbunnyears/pathologist
	group = "Playbunny Ears"

/datum/loadout_item/head/rabbit/playbunnymedcoroner
	name = "Bunny Ears (Coroner)"
	item_path = /obj/item/clothing/head/playbunnyears/coroner
	group = "Playbunny Ears"

/datum/loadout_item/head/rabbit/playbunnymedcmo
	name = "Bunny Ears (Chief Medical)"
	item_path = /obj/item/clothing/head/playbunnyears/cmo
	restricted_roles = list(JOB_CHIEF_MEDICAL_OFFICER)
	group = "Playbunny Ears"

/datum/loadout_item/head/rabbitplaybunnyrnd
	name = "Bunny Ears (Research)"
	item_path = /obj/item/clothing/head/playbunnyears/scientist
	group = "Playbunny Ears"

/datum/loadout_item/head/rabbitplaybunnyrndrobo
	name = "Bunny Ears (Robotic)"
	item_path = /obj/item/clothing/head/playbunnyears/roboticist
	group = "Playbunny Ears"

/datum/loadout_item/head/rabbitplaybunnyrndgene
	name = "Bunny Ears (Genetic)"
	item_path = /obj/item/clothing/head/playbunnyears/geneticist
	group = "Playbunny Ears"

/datum/loadout_item/head/rabbitplaybunnyrndrd
	name = "Bunny Ears (Director)"
	item_path = /obj/item/clothing/head/playbunnyears/rd
	restricted_roles = list(JOB_RESEARCH_DIRECTOR)
	group = "Playbunny Ears"

/datum/loadout_item/head/rabbitplaybunnysecdept
	name = "Bunny Ears (Less Secure)"
	item_path = /obj/item/clothing/head/playbunnyears/security/assistant
	restricted_roles = list(ALL_JOBS_SEC)
	group = "Playbunny Ears"

/datum/loadout_item/head/rabbitplaybunnysec
	name = "Bunny Ears (Secure)"
	item_path = /obj/item/clothing/head/playbunnyears/security
	restricted_roles = list(ALL_JOBS_SEC)
	group = "Playbunny Ears"

/datum/loadout_item/head/rabbitplaybunnysecwarden
	name = "Bunny Ears (Secure Silver)"
	item_path = /obj/item/clothing/head/playbunnyears/warden
	restricted_roles = list(JOB_WARDEN)
	group = "Playbunny Ears"

/datum/loadout_item/head/rabbitplaybunnysechos
	name = "Bunny Ears (Secure Gold)"
	item_path = /obj/item/clothing/head/playbunnyears/hos
	restricted_roles = list(JOB_HEAD_OF_SECURITY)
	group = "Playbunny Ears"

/datum/loadout_item/head/rabbitplaybunnysecmed
	name = "Bunny Ears (Secure Medical)"
	item_path = /obj/item/clothing/head/playbunnyears/brig_phys
	restricted_roles = list(ALL_JOBS_SEC)
	group = "Playbunny Ears"

/datum/loadout_item/head/rabbitplaybunnysecdet
	name = "Bunny Ears (Curious)"
	item_path = /obj/item/clothing/head/playbunnyears/detective
	restricted_roles = list(JOB_DETECTIVE)
	group = "Playbunny Ears"

/datum/loadout_item/head/rabbitplaybunnysecdetnoir
	name = "Bunny Ears (Curious Noir)"
	item_path = /obj/item/clothing/head/playbunnyears/detective/noir
	restricted_roles = list(JOB_DETECTIVE)
	group = "Playbunny Ears"

/datum/loadout_item/head/rabbitplaybunnyprisoner
	name = "Bunny Ears (Locked Up)"
	item_path = /obj/item/clothing/head/playbunnyears/prisoner
	group = "Playbunny Ears"

/datum/loadout_item/head/rabbitplaybunnyhop
	name = "Bunny Ears (Hopping)"
	item_path = /obj/item/clothing/head/playbunnyears/hop
	restricted_roles = list(JOB_HEAD_OF_PERSONNEL)
	group = "Playbunny Ears"

/datum/loadout_item/head/rabbitplaybunnybar
	name = "Bunny Ears (Drunk)"
	item_path = /obj/item/clothing/head/playbunnyears/bartender
	group = "Playbunny Ears"

/datum/loadout_item/head/rabbitplaybunnyjani
	name = "Bunny Ears (Clean)"
	item_path = /obj/item/clothing/head/playbunnyears/janitor
	group = "Playbunny Ears"

/datum/loadout_item/head/rabbitplaybunnychef
	name = "Bunny Ears (Hungry)"
	item_path = /obj/item/clothing/head/playbunnyears/cook
	group = "Playbunny Ears"

/datum/loadout_item/head/rabbitplaybunnyhydro
	name = "Bunny Ears (Botanical)"
	item_path = /obj/item/clothing/head/playbunnyears/botanist
	group = "Playbunny Ears"

/datum/loadout_item/head/rabbitplaybunnyclown
	name = "Bunny Ears (Funny)"
	item_path = /obj/item/clothing/head/playbunnyears/clown
	group = "Playbunny Ears"

/datum/loadout_item/head/rabbitplaybunnymime
	name = "Bunny Ears (Quiet)"
	item_path = /obj/item/clothing/head/playbunnyears/mime
	group = "Playbunny Ears"

/datum/loadout_item/head/rabbitplaybunnychaplain
	name = "Bunny Ears (Holy)"
	item_path = /obj/item/clothing/head/playbunnyears/chaplain
	group = "Playbunny Ears"

/datum/loadout_item/head/rabbitplaybunnycuratorred
	name = "Bunny Ears (Nerdy Red)"
	item_path = /obj/item/clothing/head/playbunnyears/curator_red
	group = "Playbunny Ears"

/datum/loadout_item/head/rabbitplaybunnycuratorgreen
	name = "Bunny Ears (Nerdy Green)"
	item_path = /obj/item/clothing/head/playbunnyears/curator_green
	group = "Playbunny Ears"

/datum/loadout_item/head/rabbitplaybunnycuratorteal
	name = "Bunny Ears (Nerdy Teal)"
	item_path = /obj/item/clothing/head/playbunnyears/curator_teal
	group = "Playbunny Ears"

/datum/loadout_item/head/rabbitplaybunnylawyerblack
	name = "Bunny Ears (Lawful Black)"
	item_path = /obj/item/clothing/head/playbunnyears/lawyer_black
	group = "Playbunny Ears"

/datum/loadout_item/head/rabbitplaybunnylawyerblue
	name = "Bunny Ears (Lawful Blue)"
	item_path = /obj/item/clothing/head/playbunnyears/lawyer_blue
	group = "Playbunny Ears"

/datum/loadout_item/head/rabbitplaybunnylawyerred
	name = "Bunny Ears (Lawful Red)"
	item_path = /obj/item/clothing/head/playbunnyears/lawyer_red
	group = "Playbunny Ears"

/datum/loadout_item/head/rabbitplaybunnylawyergood
	name = "Bunny Ears (Lawful Good)"
	item_path = /obj/item/clothing/head/playbunnyears/lawyer_good
	group = "Playbunny Ears"

/datum/loadout_item/head/rabbitplaybunnypsych
	name = "Bunny Ears (Shrink)"
	item_path = /obj/item/clothing/head/playbunnyears/psychologist
	group = "Playbunny Ears"

/*
*	erp_item
*/

/datum/loadout_item/head/domina_cap
	name = "支配者帽"
	item_path = /obj/item/clothing/head/domina_cap
	erp_item = TRUE

/*
*	DONATOR
*/

/datum/loadout_item/head/donator
	abstract_type = /datum/loadout_item/head/donator
	donator_only = TRUE

/datum/loadout_item/head/donator/carbon_rose
	name = "花朵 - 碳玫瑰"
	item_path = /obj/item/grown/carbon_rose
	group = "Miscellaneous"

/datum/loadout_item/head/donator/fraxinella
	name = "花朵 - 白鲜"
	item_path = /obj/item/food/grown/poppy/geranium/fraxinella
	group = "Miscellaneous"

/datum/loadout_item/head/donator/rainbow_bunch
	name = "花朵 - 彩虹花束"
	item_path = /obj/item/food/grown/rainbow_flower
	group = "Miscellaneous"

/datum/loadout_item/head/donator/rainbow_bunch/get_item_information()
	. = ..()
	.[FA_ICON_DICE] = TOOLTIP_RANDOM_COLOR
