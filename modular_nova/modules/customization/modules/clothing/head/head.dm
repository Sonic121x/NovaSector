/obj/item/clothing/head/hats/flakhelm	//Actually the M1 Helmet
	icon = 'modular_nova/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/head.dmi'
	name = "防弹头盔"
	icon_state = "m1helm"
	inhand_icon_state = "helmet"
	armor_type = /datum/armor/hats_flakhelm
	desc = "古代战争中使用的破旧头盔。这个已经脆化，基本没用了。外壳的带子里塞着一张黑桃A。"
	supports_variations_flags = CLOTHING_SNOUTED_VARIATION_NO_NEW_ICON

/datum/armor/hats_flakhelm
	bomb = 0.1
	fire = -10
	acid = -15
	wound = 1

/obj/item/clothing/head/hats/flakhelm/Initialize(mapload)
	. = ..()

	create_storage(storage_type = /datum/storage/pockets/tiny/spacenam)

/datum/storage/pockets/tiny/spacenam
	attack_hand_interact = TRUE		//So you can actually see what you stuff in there

//Cyberpunk PI Costume - Sprites from Eris
/obj/item/clothing/head/fedora/det_hat/cybergoggles //Subset of detective fedora so that detectives dont have to sacrifice candycorns for style
	name = "34P型半封闭式头饰"
	desc = "某些执法机构使用的流行头盔。它具有轻量装甲板和新型层压纤维衬里。"
	icon = 'modular_nova/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/head.dmi'
	icon_state = "cyberpunkgoggle"
	supports_variations_flags = CLOTHING_SNOUTED_VARIATION_NO_NEW_ICON
	hair_mask = "" //The shape of this hat is too tight to the head to not look insane with a mask

/obj/item/clothing/head/fedora/det_hat/cybergoggles/civilian //Actually civilian with no armor for drip purposes only
	name = "34C型半封闭式头饰"
	desc = "某些执法机构使用的流行头盔的民用型号。它没有装甲板。"
	icon = 'modular_nova/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/head.dmi'
	icon_state = "cyberpunkgoggle"
	armor_type = /datum/armor/none
	supports_variations_flags = CLOTHING_SNOUTED_VARIATION_NO_NEW_ICON
	hair_mask = "" //The shape of this hat is too tight to the head to not look insane with a mask

/obj/item/clothing/head/hats/intern/developer
	name = "实习生豆帽"

/obj/item/clothing/head/beret/sec/navywarden/syndicate
	name = "军械长贝雷帽"
	desc = "出人意料地时髦，如果你生活在一部无声的印象派电影里的话。"
	icon_state = "/obj/item/clothing/head/beret/sec/navywarden/syndicate"
	post_init_icon_state = "beret_badge"
	greyscale_config = /datum/greyscale_config/beret_badge
	greyscale_config_worn = /datum/greyscale_config/beret_badge/worn
	greyscale_colors = "#353535#AAAAAA"
	armor_type = /datum/armor/navywarden_syndicate
	strip_delay = 60
	supports_variations_flags = CLOTHING_SNOUTED_VARIATION_NO_NEW_ICON

/datum/armor/navywarden_syndicate
	melee = 40
	bullet = 30
	laser = 30
	energy = 40
	bomb = 25
	fire = 30
	acid = 50
	wound = 6

/obj/item/clothing/head/colourable_flatcap
	name = "可染色平顶帽"
	desc = "你在搞电脑吗，小子？你搞电脑工作的？"
	icon = 'icons/map_icons/clothing/head/_head.dmi'
	icon_state = "/obj/item/clothing/head/colourable_flatcap"
	post_init_icon_state = "flatcap"
	greyscale_config = /datum/greyscale_config/flatcap
	greyscale_config_worn = /datum/greyscale_config/flatcap/worn
	greyscale_colors = "#79684c"
	flags_1 = IS_PLAYER_COLORABLE_1
	supports_variations_flags = CLOTHING_SNOUTED_VARIATION_NO_NEW_ICON

/obj/item/clothing/head/hats/imperial
	name = "海军军官帽"
	desc = "一顶中央带有标识圆盘的海军帽。"
	icon = 'icons/map_icons/clothing/head/_head.dmi'
	icon_state = "/obj/item/clothing/head/hats/imperial"
	post_init_icon_state = "navalcap"
	greyscale_config = /datum/greyscale_config/navalcap
	greyscale_config_worn = /datum/greyscale_config/navalcap/worn
	greyscale_colors = "#A49C9C#FFFFFF"
	flags_1 = IS_PLAYER_COLORABLE_1
	supports_variations_flags = CLOTHING_SNOUTED_VARIATION_NO_NEW_ICON

/obj/item/clothing/head/hats/imperial/cap
	name = "舰长的海军军官帽"
	desc = "一顶白色的海军帽，中央别着象征舰长身份的徽章。"
	icon_state = "/obj/item/clothing/head/hats/imperial/cap"
	greyscale_colors = "#FFFFFF#FFCE5B"
	armor_type = /datum/armor/hats_caphat
	flags_1 = null

/obj/item/clothing/head/hats/imperial/nanotrasen_consultant
	name = "纳米传讯顾问的海军帽"
	desc = "一顶海军帽，中央别着象征纳米传讯顾问身份的徽章。"
	icon_state = "/obj/item/clothing/head/hats/imperial/nanotrasen_consultant"
	greyscale_colors = "#54a57e#ffce5b"
	flags_1 = null

/obj/item/clothing/head/hats/imperial/blueshield
	name = "蓝盾的海军帽"
	desc = "一顶海军帽，中央别着象征蓝盾身份的徽章。"
	icon_state = "/obj/item/clothing/head/hats/imperial/blueshield"
	greyscale_colors = "#3c485a#bbbbbb"
	flags_1 = null
	armor_type = /datum/armor/cosmetic_sec

/obj/item/clothing/head/hats/imperial/bridge_officer
	name = "舰桥军官的海军帽"
	desc = "一顶海军帽，中央别着象征舰桥军官身份的徽章。"
	icon_state = "/obj/item/clothing/head/hats/imperial/bridge_officer"
	greyscale_colors = "#41579a#ccced1"
	flags_1 = null

/obj/item/clothing/head/hats/imperial/hop
	name = "人事主管的海军军官帽"
	desc = "一顶橄榄绿色的海军帽，中央别着象征人事主管身份的徽章。"
	icon_state = "/obj/item/clothing/head/hats/imperial/hop"
	greyscale_colors = "#829A8C#88242D"
	flags_1 = null
	armor_type = /datum/armor/hats_hopcap

/obj/item/clothing/head/hats/imperial/hos
	name = "安全主管的海军军官帽"
	desc = "一顶焦黑色的海军帽，中央别着象征安全主管身份的徽章。"
	icon_state = "/obj/item/clothing/head/hats/imperial/hos"
	greyscale_colors = "#29252D#FFCE5B"
	armor_type = /datum/armor/hats_hos
	flags_1 = null

/obj/item/clothing/head/hats/imperial/cmo
	name = "首席医疗官的海军帽"
	desc = "一顶青绿色的海军帽，中央别着象征首席医疗官身份的徽章。"
	icon_state = "/obj/item/clothing/head/hats/imperial/cmo"
	greyscale_colors = "#5EB8B8#5FA4CC"
	flags_1 = null

/obj/item/clothing/head/hats/imperial/ce
	name = "首席工程师的海军帽"
	desc = "一顶海军帽，中央别着一枚代表首席工程师的徽章。"
	icon_state = "/obj/item/clothing/head/hats/imperial/ce"
	greyscale_colors = "#404429#5c97e6"
	flags_1 = null

/obj/item/clothing/head/hats/imperial/rd
	name = "研究主管的海军帽"
	desc = "一顶海军帽，中央别着一枚代表研究主管的徽章。"
	icon_state = "/obj/item/clothing/head/hats/imperial/rd"
	greyscale_colors = "#7e1980#fac719"
	flags_1 = null

/obj/item/clothing/head/hats/imperial/qm
	name = "军需官的海军帽"
	desc = "一顶海军帽，中央别着一枚代表军需官的徽章。"
	icon_state = "/obj/item/clothing/head/hats/imperial/qm"
	greyscale_colors = "#8B4C31#DEB63D"
	flags_1 = null

/obj/item/clothing/head/soft/yankee
	name = "时尚棒球帽"
	desc = "有帽檐，也有帽边。"
	icon = 'modular_nova/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/head.dmi'
	icon_state = "yankeesoft"
	soft_type = "yankee"
	dog_fashion = /datum/dog_fashion/head/yankee
	supports_variations_flags = CLOTHING_SNOUTED_VARIATION_NO_NEW_ICON

/obj/item/clothing/head/soft/yankee/rimless
	name = "无檐时尚棒球帽"
	desc = "无檐设计，只为取悦她。"
	icon = 'modular_nova/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/head.dmi'
	icon_state = "yankeenobrimsoft"
	soft_type = "yankeenobrim"

/obj/item/clothing/head/fedora/brown //Fedora without detective's candy corn gimmick
	name = "棕色软呢帽"
	icon_state = "detective"

/obj/item/clothing/head/standalone_hood
	name = "兜帽"
	desc = "一个兜帽，颈部周围有支撑设计，能真正固定住，适用于所有你想要兜帽但不想穿外套的场合。"
	worn_icon = 'modular_nova/modules/GAGS/icons/head/head.dmi'
	worn_icon_teshari = 'modular_nova/modules/GAGS/icons/head/head_teshari.dmi'
	body_parts_covered = HEAD
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	flags_inv = HIDEEARS|HIDEHAIR
	supports_variations_flags = CLOTHING_SNOUTED_VARIATION_NO_NEW_ICON
	flags_1 = IS_PLAYER_COLORABLE_1
	greyscale_colors = "#4e4a43#F1F1F1"
	icon = 'icons/map_icons/clothing/head/_head.dmi'
	icon_state = "/obj/item/clothing/head/standalone_hood"
	post_init_icon_state = "hood"
	greyscale_config = /datum/greyscale_config/standalone_hood
	greyscale_config_worn = /datum/greyscale_config/standalone_hood/worn
	greyscale_config_worn_teshari = /datum/greyscale_config/standalone_hood/worn/teshari
	greyscale_config_worn_better_vox = /datum/greyscale_config/standalone_hood/worn/newvox
	greyscale_config_worn_vox = /datum/greyscale_config/standalone_hood/worn/oldvox

/obj/item/clothing/head/beret/badge
	name = "带徽章贝雷帽"
	desc = "一顶贝雷帽。带个徽章。你还想要什么，一篇论文吗？这就是顶帽子。"
	icon_state = "/obj/item/clothing/head/beret/badge"
	post_init_icon_state = "beret_badge"
	greyscale_config = /datum/greyscale_config/beret_badge
	greyscale_config_worn = /datum/greyscale_config/beret_badge/worn
	greyscale_colors = "#972A2A#EFEFEF"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/head/costume/cowboyhat_old
	icon = 'modular_nova/master_files/icons/obj/clothing/hats.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/head.dmi'
	name = "旧牛仔帽"
	desc = "一顶老式牛仔帽，适合任何亡命之徒，只是缺少花哨的颜色魔法。"
	icon_state = "cowboyhat_black"
	inhand_icon_state = "cowboy_hat_black"
	supports_variations_flags = CLOTHING_SNOUTED_VARIATION_NO_NEW_ICON

//BOWS
/obj/item/clothing/head/small_bow
	name = "小蝴蝶结"
	desc = "一个可以别在头发一侧的小巧蝴蝶结。"
	icon = 'icons/map_icons/clothing/head/_head.dmi'
	icon_state = "/obj/item/clothing/head/small_bow"
	post_init_icon_state = "small_bow"
	greyscale_config = /datum/greyscale_config/small_bow
	greyscale_config_worn = /datum/greyscale_config/small_bow/worn
	greyscale_colors = "#7b9ab5"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/head/small_bow/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon, "switch side")

/obj/item/clothing/head/large_bow
	name = "大蝴蝶结"
	desc = "一个可以戴在头顶的大蝴蝶结。"
	icon = 'icons/map_icons/clothing/head/_head.dmi'
	icon_state = "/obj/item/clothing/head/large_bow"
	post_init_icon_state = "large_bow"
	greyscale_config = /datum/greyscale_config/large_bow
	greyscale_config_worn = /datum/greyscale_config/large_bow/worn
	greyscale_colors = "#7b9ab5"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/head/large_bow/back_bow
	name = "后置蝴蝶结"
	desc = "一个可以戴在脑后的蝴蝶结。"
	greyscale_config = /datum/greyscale_config/back_bow
	greyscale_config_worn = /datum/greyscale_config/back_bow/worn
	flags_1 = IS_PLAYER_COLORABLE_1 | NO_NEW_GAGS_PREVIEW_1

/obj/item/clothing/head/large_bow/sweet_bow
	name = "甜美蝴蝶结"
	desc = "一个可以戴在脑后的甜美蝴蝶结。"
	greyscale_config = /datum/greyscale_config/sweet_bow
	greyscale_config_worn = /datum/greyscale_config/sweet_bow/worn
	flags_1 = IS_PLAYER_COLORABLE_1 | NO_NEW_GAGS_PREVIEW_1

// Skrell chains
/obj/item/clothing/head/skrell_chain
	name = "金色史奎利安头链"
	desc = "传统的史奎利安头链"
	icon = 'modular_nova/master_files/icons/obj/clothing/hats.dmi'
	icon_state = "skrell_chain_gold"
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/head/skrell_chains.dmi'
	worn_icon_state = "chain_gold"
	w_class = WEIGHT_CLASS_TINY
	custom_price = PAYCHECK_CREW * 2
	var/list/chain_styles = list(
		"Long Diadema" = "long_diadema_gold",
		"Short Diadema" = "short_diadema_gold",
		"Long Fest" = "long_fest_gold",
		"Short Fest" = "short_fest_gold",
		"Chain" = "chain_gold",
	)

/obj/item/clothing/head/skrell_chain/examine(mob/user)
	. = ..()
	. += span_notice("<b>在手中使用</b>以选择新样式。")

/obj/item/clothing/head/skrell_chain/attack_self(mob/user)
	var/style_name = tgui_input_list(user, "链条立起来时是什么样子？", "选择！", chain_styles)
	worn_icon_state = chain_styles[style_name]
	balloon_alert(user, "样式已选择！")

/obj/item/clothing/head/skrell_chain/silver
	name = "银色史奎利安头链"
	icon_state = "skrell_chain_silver"
	worn_icon_state = "chain_silver"
	custom_price = PAYCHECK_CREW
	chain_styles = list(
		"Long Diadema" = "long_diadema_silver",
		"Short Diadema" = "short_diadema_silver",
		"Chain" = "chain_silver",
	)

/obj/item/clothing/head/henchmen_hat
	name = "henchmen cap"
	desc = "Alright boss.. I'll handle it."
	icon = 'icons/map_icons/clothing/head/_head.dmi'
	icon_state = "/obj/item/clothing/head/henchmen_hat"
	post_init_icon_state = "greyscale_cap"
	greyscale_colors = "#201b1a"
	greyscale_config = /datum/greyscale_config/henchmen
	greyscale_config_worn = /datum/greyscale_config/henchmen/worn
	flags_1 = IS_PLAYER_COLORABLE_1

