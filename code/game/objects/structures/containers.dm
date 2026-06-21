/obj/structure/shipping_container
	name = "装运集装箱"
	desc = "一种用于大宗货物运输的标准规格集装箱。这个集装箱是空的，看不出里面装的是什么物品。"
	icon = 'icons/obj/fluff/containers.dmi'
	icon_state = "blank"
	max_integrity = 1000
	bound_width = 96
	bound_height = 32
	density = TRUE
	anchored = TRUE
	layer = ABOVE_ALL_MOB_LAYER
	plane = ABOVE_GAME_PLANE

/obj/structure/shipping_container/Initialize(mapload)
	. = ..()

	AddComponent(/datum/component/seethrough, SEE_THROUGH_MAP_SHIPPING_CONTAINER)

/obj/structure/shipping_container/amsco
	name = "\improper AMSCO货运集装箱"
	desc = "用于大宗货物运输的标准尺寸货运集装箱。这个来自阿蒙森-斯科特公司，很可能装载着勘探设备。"
	icon_state = "amsco"

/obj/structure/shipping_container/blue
	icon_state = "blue"

/obj/structure/shipping_container/conarex
	name = "\improper 科纳瑞克斯 航空航天运输集装箱"
	desc = "一种用于大宗货物运输的标准规格集装箱。这个集装箱来自康纳雷克斯航空公司，它可能正装载着航天器部件（或者是一起贿赂丑闻）。"
	icon_state = "conarex"

/obj/structure/shipping_container/defaced
	name = "被涂鸦的货运集装箱"
	desc = "用于大宗货物运输的标准尺寸货运集装箱。这个集装箱表面覆盖着雅致的涂鸦。"
	icon_state = "defaced"

/obj/structure/shipping_container/deforest
	name = "\improper Nanotrasen-DeForest货运集装箱"
	desc = "用于大宗货物运输的标准尺寸货运集装箱。这个来自Nanotrasen-DeForest公司，很可能装载着医疗用品。"
	icon_state = "deforest"

/obj/structure/shipping_container/great_northern
	name = "\improper Great Northern货运集装箱"
	desc = "用于大宗货物运输的标准尺寸货运集装箱。这个来自Great Northern公司，很可能装载着农业设备。"
	icon_state = "great_northern"

/obj/structure/shipping_container/green
	icon_state = "green"

/obj/structure/shipping_container/kahraman
	name = "\improper 卡拉曼重工运输集装箱"
	desc = "用于大宗货物运输的标准尺寸货运集装箱。这个来自Kahraman公司，为运输采矿设备进行了加固。"
	icon_state = "kahraman"

/obj/structure/shipping_container/kahraman/alt
	icon_state = "kahraman_alt"

/obj/structure/shipping_container/kosmologistika
	name = "\improper 科斯莫里斯提卡集装箱"
	desc = "用于大宗货物运输的标准尺寸货运集装箱。这个来自Kosmologistika公司，这是一家由SSC拥有和运营的国有物流公司。"
	icon_state = "kosmologistika"

/obj/structure/shipping_container/magenta
	icon_state = "magenta"

/obj/structure/shipping_container/nakamura
	name = "\improper 中村工程船运集装箱"
	desc = "一个用于大宗货物运输的标准规格海运集装箱。这个集装箱来自中村公司，用于运输工具或重型工业设备。"
	icon_state = "nakamura"

/obj/structure/shipping_container/nanotrasen
	name = "\improper 纳米传讯装运集装箱"
	desc = "一个用于大宗货物运输的标准规格集装箱。这个集装箱显著地印有纳米传讯的标志，因此想必可以装载任何货物。"
	icon_state = "nanotrasen"

/obj/structure/shipping_container/ntfid
	name = "\improper 纳米传讯未来与创新货运集装箱"
	desc = "用于货物大宗运输的标准尺寸货运集装箱。这个来自NTFID：纳米传讯的研究与开发分部。"
	icon_state = "ntfid"

/obj/structure/shipping_container/ntfid/defaced
	desc = "用于货物大宗运输的标准尺寸货运集装箱。显然有人对NTFID颇有微词。"
	icon_state = "ntfid_defaced"

/obj/structure/shipping_container/nthi
	name = "\improper 纳米传讯重工运输集装箱"
	desc = "用于大宗运输普通金属和矿物的标准尺寸货运集装箱。这个来自NTHI：纳米传讯的采矿与精炼分部。"
	icon_state = "nthi"

/obj/structure/shipping_container/nthi/minor
	desc = "用于大宗运输稀有金属和矿物的标准尺寸货运集装箱。这个来自NTHI：纳米传讯的采矿与精炼分部。"
	icon_state = "nthi_minor"

/obj/structure/shipping_container/nthi/precious
	desc = "用于大宗运输贵金属和矿物的标准尺寸货运集装箱。这个来自NTHI：纳米传讯的采矿与精炼分部。"
	icon_state = "nthi_precious"

/obj/structure/shipping_container/orange
	icon_state = "orange"

/obj/structure/shipping_container/purple
	icon_state = "purple"

/obj/structure/shipping_container/red
	icon_state = "red"

/obj/structure/shipping_container/sunda
	name = "\improper 巽他星系货运集装箱"
	desc = "用于货物大宗运输的标准尺寸货运集装箱。这个来自巽他星系，里面可能装着任何东西。"
	icon_state = "sunda"

/obj/structure/shipping_container/vitezstvi
	name = "\improper Vítězství (捷克语 '胜利' ) 武器运输集装箱"
	desc = "用于散装货物运输的标准尺寸的船运集装箱，这一个来自Vítězství武器，自豪地宣布Vítězství武器意味着胜利。"
	icon_state = "vitezstvi"

/obj/structure/shipping_container/vitezstvi/flags
	icon_state = "vitezstvi_flags"

/obj/structure/shipping_container/yellow
	icon_state = "yellow"

//Syndies
/obj/structure/shipping_container/biosustain
	name = "\improper 生物维持货运集装箱"
	desc = "用于货物大宗运输的标准尺寸货运集装箱。这个来自生物维持公司，所以很可能装着种子或农用设备。"
	icon_state = "biosustain"

/obj/structure/shipping_container/cybersun
	name = "\improper 赛博森工业运输集装箱"
	desc = "一种用于货物散装运输的标准尺寸集装箱。这个集装箱上显著地印有赛博森的标志，因此推测几乎可以装载任何东西。"
	icon_state = "cybersun"

/obj/structure/shipping_container/cybersun/defaced
	desc = "用于货物大宗运输的标准尺寸货运集装箱。这个集装箱原本印有赛博阳光的标识，后来被一位有想法的艺术家涂掉了。"
	icon_state = "cybersun_defaced"

/obj/structure/shipping_container/donk_co
	name = "\improper 杜克公司运输集装箱"
	desc = "用于货物大宗运输的标准尺寸货运集装箱。这个来自唐克公司，里面可能装着任何东西——尽管很可能只是唐克口袋饼。"
	icon_state = "donk_co"

/obj/structure/shipping_container/exagon
	name = "\improper 六边形-市川货运集装箱"
	desc = "用于大宗运输普通金属和矿物的标准尺寸货运集装箱。这个来自六边形-市川，赛博阳光工业的采矿与精炼分部。"
	icon_state = "exagon"

/obj/structure/shipping_container/exagon/minor
	desc = "用于大宗运输稀有金属和矿物的标准尺寸货运集装箱。这个来自六边形-市川，赛博阳光工业的采矿与精炼分部。"
	icon_state = "exagon_minor"

/obj/structure/shipping_container/exagon/precious
	desc = "一个用于大宗运输贵金属和矿物的标准尺寸货运集装箱。这个来自Exagon-Ichikawa，是赛博阳光工业的采矿与精炼子公司。"
	icon_state = "exagon_precious"

/obj/structure/shipping_container/gorlex
	name = "\improper 戈雷克斯集团运输集装箱"
	desc = "一种用于货物散装运输的标准运输集装箱。这个来自戈雷克斯集团，可能运载着他们的主要出口品：战争罪行。"
	icon_state = "gorlex"

/obj/structure/shipping_container/gorlex/red
	icon_state = "gorlex_red"

/obj/structure/shipping_container/interdyne
	name = "\improper Interdyne货运集装箱"
	desc = "一个用于大宗运输货物的标准尺寸货运集装箱。这个来自Interdyne，一家私营制药公司。很可能装载着医疗或研究物资，大概吧。"
	icon_state = "interdyne"

/obj/structure/shipping_container/oms
	name = "\improper OMS货运集装箱"
	desc = "一个用于大宗运输货物的标准尺寸货运集装箱。这个来自赛博阳光的医疗子公司OMS（大阪医疗系统），很可能装载着医疗用赛博格部件之类的东西。"
	icon_state = "oms"

/obj/structure/shipping_container/tiger_coop
	name = "可疑的货运集装箱"
	desc = "一个用于大宗运输货物的标准尺寸货运集装箱。这个原本空白的集装箱被喷上了老虎合作社的标志，意味着里面的东西很可能很危险。"
	icon_state = "tiger_coop"

/obj/structure/shipping_container/tiger_coop/text
	icon_state = "tiger_coop_text"

// REEFER CONTAINERS (REFRIGERATED)
/obj/structure/shipping_container/reefer
	name = "冷藏货运集装箱"
	desc = "一个用于大宗运输冷藏货物的标准尺寸冷藏货运集装箱。这个是空白的，没有提供任何关于其内容的线索。"
	icon_state = "blank_reefer"

/obj/structure/shipping_container/reefer/deforest
	name = "\improper Nanotrasen-DeForest冷藏货运集装箱"
	desc = "一个用于大宗运输冷藏货物的标准尺寸冷藏货运集装箱。这个来自Nanotrasen-DeForest，很可能装载着温度敏感的生物材料。"
	icon_state = "deforest_reefer"

/obj/structure/shipping_container/reefer/biosustain
	name = "\improper Biosustain冷藏货运集装箱"
	desc = "一个用于大宗运输冷藏货物的标准尺寸冷藏货运集装箱。这个来自Biosustain，所以很可能装载着转基因生物或农用化学品。"
	icon_state = "biosustain_reefer"

/obj/structure/shipping_container/reefer/interdyne
	name = "\improper Interdyne冷藏货运集装箱"
	desc = "一个用于大宗运输冷藏货物的标准尺寸冷藏货运集装箱。这个来自Interdyne，一家私营制药公司，很可能装载着器官或血液，也许两者都有。"
	icon_state = "interdyne_reefer"

// GAS TANK
/obj/structure/shipping_container/gas
	name = "大宗气体储罐"
	desc = "一个用于大宗运输气体的标准尺寸气体储罐。这个相当不负责任地空白着，没有提供任何关于其内容的线索。"
	icon_state = "blank_gas"

/obj/structure/shipping_container/gas/apda
	name = "\improper APdA S.p.A.大宗氦气储罐"
	desc = "一个用于大宗运输气体的标准尺寸气体储罐。这个来自亚得里亚石化联合公司，装着他们第二重要的出口产品：用于燃料用途的氦-3。"
	icon_state = "apda_gas_helium"

/obj/structure/shipping_container/gas/apda/hydrogen
	name = "\improper APdA S.p.A. 散装氢气罐"
	desc = "一种用于气体散装运输的标准规格气罐。这个来自亚得里亚石化联合公司，装着他们最重要的出口品：用作燃料的氢气。"
	icon_state = "apda_gas_hydrogen"

/obj/structure/shipping_container/gas/nthi
	name = "\improper NTHI 散装等离子体罐"
	desc = "一种用于气体散装运输的标准规格气罐。这个来自NTHI，即纳米传讯的采矿与精炼子公司，装着来自旋臂星区的高品质气态等离子体。"
	icon_state = "nthi_gas_plasma"

/obj/structure/shipping_container/gas/exagon
	name = "\improper Exagon-Ichikawa 散装等离子体罐"
	desc = "一种用于气体散装运输的标准规格气罐。这个来自Exagon-Ichikawa，即赛博太阳工业的采矿与精炼子公司，装着很可能源自火星的气态等离子体。"
	icon_state = "exagon_gas_plasma"
