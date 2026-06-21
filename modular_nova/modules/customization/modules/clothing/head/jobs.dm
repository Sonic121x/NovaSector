// This is for all the berets that /tg/ didn't want. You're welcome, they should look better.

/obj/item/clothing/head/hats/hos/beret
	name = "安全主管贝雷帽"
	desc = "为安全主管准备的坚固贝雷帽，在保持时尚的同时不牺牲防护。"
	icon = 'icons/map_icons/clothing/head/_head.dmi'
	icon_state = "/obj/item/clothing/head/hats/hos/beret"
	post_init_icon_state = "beret_badge"
	greyscale_config = /datum/greyscale_config/beret_badge
	greyscale_config_worn = /datum/greyscale_config/beret_badge/worn
	greyscale_colors = "#3F3C40#FFCE5B"

/obj/item/clothing/head/hats/hos/beret/syndicate
	name = "辛迪加贝雷帽"
	desc = "一顶内部有厚实装甲衬垫的黑色贝雷帽。时尚又坚固。"
	icon_state = "/obj/item/clothing/head/hats/hos/beret/syndicate"
	greyscale_colors = "#3F3C40#DB2929"

/obj/item/clothing/head/beret/sec/navywarden
	name = "典狱长贝雷帽"
	desc = "一顶印有典狱长徽章的特制贝雷帽。献给有品位的典狱长。"
	icon_state = "/obj/item/clothing/head/beret/sec/navywarden"
	post_init_icon_state = "beret_badge_fancy_twist"
	greyscale_config = /datum/greyscale_config/beret_badge_fancy
	greyscale_config_worn = /datum/greyscale_config/beret_badge_fancy/worn
	greyscale_colors = "#3C485A#FF0000#00AEEF"
	armor_type = /datum/armor/sec_navywarden
	strip_delay = 60

/datum/armor/sec_navywarden
	melee = 40
	bullet = 30
	laser = 30
	energy = 40
	bomb = 25
	fire = 30
	acid = 50
	wound = 6

/obj/item/clothing/head/beret/sec/navyofficer
	desc = "一顶印有安保部门徽章的特制贝雷帽。献给有品位的警官。"
	icon_state = "/obj/item/clothing/head/beret/sec/navyofficer"
	post_init_icon_state = "beret_badge_bolt"
	greyscale_colors = "#3C485A#FF0000"


//Medical

/obj/item/clothing/head/beret/medical
	name = "医疗贝雷帽"
	desc = "一顶医疗风格的贝雷帽，献给内心的医生！"
	icon_state = "/obj/item/clothing/head/beret/medical"
	post_init_icon_state = "beret_badge_med"
	greyscale_config = /datum/greyscale_config/beret_badge
	greyscale_config_worn = /datum/greyscale_config/beret_badge/worn
	greyscale_colors = "#FFFFFF#5FA4CC"
	flags_1 = NONE

/obj/item/clothing/head/beret/medical/paramedic
	name = "护理员贝雷帽"
	desc = "用于有格调地寻找尸体！"
	icon_state = "/obj/item/clothing/head/beret/medical/paramedic"
	greyscale_colors = "#364660#5FA4CC"

/obj/item/clothing/head/beret/medical/chemist
	name = "化学家贝雷帽"
	desc = "不防酸！"
	icon_state = "/obj/item/clothing/head/beret/medical/chemist"
	greyscale_colors = "#FFFFFF#D15B1B"

/obj/item/clothing/head/beret/medical/virologist
	name = "病毒学家贝雷帽"
	desc = "在这顶昂贵的贝雷帽里打喷嚏可是对一顶好帽子的浪费。"
	icon_state = "/obj/item/clothing/head/beret/medical/virologist"
	greyscale_colors = "#FFFFFF#198019"


//Engineering

/obj/item/clothing/head/beret/engi
	name = "工程贝雷帽"
	desc = "也许不能保护你免受辐射，但绝对能保护你不显得不时髦！"
	icon_state = "/obj/item/clothing/head/beret/engi"
	post_init_icon_state = "beret_badge_engi"
	greyscale_config = /datum/greyscale_config/beret_badge
	greyscale_config_worn = /datum/greyscale_config/beret_badge/worn
	greyscale_colors = "#ff8200#ffe12f"
	flags_1 = NONE

/obj/item/clothing/head/beret/atmos
	name = "大气处理贝雷帽"
	desc = "虽然“管道”和“风格”可能不押韵，但这顶贝雷帽肯定让你觉得它们应该押韵！"
	icon_state = "/obj/item/clothing/head/beret/atmos"
	post_init_icon_state = "beret_badge"
	greyscale_config = /datum/greyscale_config/beret_badge
	greyscale_config_worn = /datum/greyscale_config/beret_badge/worn
	greyscale_colors = "#59D7FF#ffe12f"
	flags_1 = NONE

// From this point forth will be berets that are made especially for Nova Sector. Those are loosely based off of the ones that were ported initially, but they might not be 1:1

/obj/item/clothing/head/beret/engi/ce
	name = "首席工程师的贝雷帽"
	desc = "一顶完全按照首席工程师品味设计的华丽贝雷帽，只是少了LED灯。"
	icon_state = "/obj/item/clothing/head/beret/engi/ce"
	greyscale_colors = "#FFFFFF#2E992E"

/obj/item/clothing/head/beret/medical/cmo
	name = "首席医疗官的贝雷帽"
	desc = "一顶为首席医疗官量身定制的贝雷帽，在Runtime抓到它后修补过一两次。"
	icon_state = "/obj/item/clothing/head/beret/medical/cmo"
	greyscale_colors = "#5EB8B8#5FA4CC"

/obj/item/clothing/head/beret/medical/cmo/alt
	name = "首席医疗官的贝雷帽"
	desc = "一顶为首席医疗官量身定制的贝雷帽，在Runtime抓到它后修补过一两次。这顶是用白色面料制成的。真时髦。"
	icon_state = "/obj/item/clothing/head/beret/medical/cmo/alt"
	greyscale_colors = "#FFFFFF#199393"

/obj/item/clothing/head/beret/science/fancy
	desc = "一顶为辛勤工作的科学家准备的科研主题贝雷帽。这顶还带有一枚华丽的徽章！"
	icon_state = "/obj/item/clothing/head/beret/science/fancy"
	post_init_icon_state = "beret_badge"
	greyscale_config = /datum/greyscale_config/beret_badge
	greyscale_config_worn = /datum/greyscale_config/beret_badge/worn
	greyscale_config_worn_teshari = /datum/greyscale_config/beret_badge/worn/teshari
	greyscale_colors = "#7E1980#FFFFFF"

/obj/item/clothing/head/beret/science/fancy/robo
	name = "机器人学贝雷帽"
	desc = "一顶采用高耐久纳米纤维设计的时尚黑色贝雷帽——至少机器人学家是这么声称的。"
	icon_state = "/obj/item/clothing/head/beret/science/fancy/robo"
	greyscale_colors = "#3E3E48#88242D"

/obj/item/clothing/head/beret/science/rd/alt
	name = "研究主管的贝雷帽"
	desc = "一顶为研究主管量身定制的贝雷帽。Lamarr觉得它看起来很棒。这顶是用白色面料制成的。真时髦。"
	icon_state = "/obj/item/clothing/head/beret/science/rd/alt"
	greyscale_colors = "#FFFFFF#7E1980"

/obj/item/clothing/head/beret/cargo/qm
	name = "军需官的贝雷帽"
	desc = "一顶帮助军需官不断告诉自己他们是正式部门主管的贝雷帽。"
	icon_state = "/obj/item/clothing/head/beret/cargo/qm"
	post_init_icon_state = "beret_badge"
	greyscale_config = /datum/greyscale_config/beret_badge
	greyscale_config_worn = /datum/greyscale_config/beret_badge/worn
	greyscale_colors = "#cf932f#FFCE5B"

/obj/item/clothing/head/beret/cargo/qm/alt
	name = "军需官的贝雷帽"
	desc = "一顶帮助军需官不断告诉自己他们是正式部门主管的贝雷帽。这款由白色织物制成。很别致。"
	icon_state = "/obj/item/clothing/head/beret/cargo/qm/alt"
	greyscale_colors = "#FFFFFF#FFCE5B"

/obj/item/clothing/head/beret/clown
	name = "\improper H.O.N.K战术贝雷帽"
	desc = "一顶在执行最危险恶作剧时使用的战术贝雷帽。"
	icon_state = "/obj/item/clothing/head/beret/clown"
	post_init_icon_state = "beret_badge_clown"
	greyscale_config = /datum/greyscale_config/beret_badge_clown
	greyscale_config_worn = /datum/greyscale_config/beret_badge_clown/worn
	greyscale_colors = "#FFBAFF"

/obj/item/clothing/head/caphat/beret/nova
	icon_state = "/obj/item/clothing/head/caphat/beret/nova"
	greyscale_colors = "#41579A#FFCE5B"

/obj/item/clothing/head/caphat/beret/alt
	name = "舰长的贝雷帽"
	desc = "为那些以时尚感著称的舰长准备。这款由白色织物制成。很别致。"
	icon_state = "/obj/item/clothing/head/caphat/beret/alt"
	greyscale_colors = "#FFFFFF#FFCE5B"

/obj/item/clothing/head/hopcap/beret
	name = "人事主管的贝雷帽"
	desc = "一顶由NT人事部门为他们最喜爱的部门主管设计的别致贝雷帽。"
	icon = 'icons/map_icons/clothing/head/_head.dmi'
	icon_state = "/obj/item/clothing/head/hopcap/beret"
	post_init_icon_state = "beret_badge"
	greyscale_config = /datum/greyscale_config/beret_badge
	greyscale_config_worn = /datum/greyscale_config/beret_badge/worn
	greyscale_colors = "#3e5c88#88242D"
	armor_type = /datum/armor/hats_hopcap

/obj/item/clothing/head/hopcap/beret/alt
	name = "人事主管的贝雷帽"
	desc = "一顶由NT人事部门为他们最喜爱的部门主管设计的别致贝雷帽。这款由白色织物制成，很别致。"
	icon_state = "/obj/item/clothing/head/hopcap/beret/alt"
	greyscale_colors = "#FFFFFF#88242D"

/obj/item/clothing/head/hopcap/beret/olive
	name = "人事主管的贝雷帽"
	desc = "一顶由NT人事部门为他们最喜爱的部门主管设计的别致贝雷帽。这款由橄榄色织物制成，很别致。"
	icon_state = "/obj/item/clothing/head/hopcap/beret/olive"
	greyscale_colors = "#829A8C#88242D"

/obj/item/clothing/head/beret/bridgeofficer
	name = "舰桥军官的贝雷帽"
	desc = "一顶别着舰桥军官标识的贝雷帽。"
	post_init_icon_state = "beret_badge"
	greyscale_config = /datum/greyscale_config/beret_badge
	greyscale_config_worn = /datum/greyscale_config/beret_badge/worn
	icon_state = "/obj/item/clothing/head/beret/bridgeofficer"
	greyscale_colors = "#41579a#ccced1"
