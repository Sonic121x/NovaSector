// These icon_states may be overridden, but are for mapper's convinence
/obj/item/poster/random_contraband
	name = "随机违禁海报"
	poster_type = /obj/structure/sign/poster/contraband/random
	icon_state = "rolled_poster"

/obj/item/poster/random_contraband/Initialize(mapload, obj/structure/sign/poster/new_poster_structure)
	. = ..()
	ADD_TRAIT(src, TRAIT_CONTRABAND, INNATE_TRAIT)

/// Creates a random poster designed for a certain audience
/obj/item/poster/random_contraband/pinup
	name = "随机美女海报"
	icon_state = "rolled_poster"
	/// List of posters which make you feel a certain type of way
	var/static/list/pinup_posters = list(
		/obj/structure/sign/poster/contraband/lizard,
		/obj/structure/sign/poster/contraband/lusty_xenomorph,
		/obj/structure/sign/poster/contraband/double_rainbow,
	)

/obj/item/poster/random_contraband/pinup/Initialize(mapload, obj/structure/sign/poster/new_poster_structure)
	poster_type = pick(pinup_posters)
	return ..()

/obj/structure/sign/poster/contraband
	poster_item_name = "contraband poster"
	poster_item_desc = "This poster comes with its own automatic adhesive mechanism, for easy pinning to any vertical surface. Its vulgar themes have marked it as contraband aboard Nanotrasen space facilities."
	poster_item_icon_state = "rolled_poster"

/obj/structure/sign/poster/contraband/random
	name = "随机违禁海报"
	icon_state = "random_contraband"
	never_random = TRUE
	random_basetype = /obj/structure/sign/poster/contraband

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/random, 32)

/obj/structure/sign/poster/contraband/free_tonto
	name = "释放通托"
	desc = "一面更大旗帜的残片，颜色因年代久远而褪色晕染。"
	icon_state = "free_tonto"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/free_tonto, 32)

/obj/structure/sign/poster/contraband/atmosia_independence
	name = "大气层独立宣言"
	desc = "一场失败叛乱的遗物。"
	icon_state = "atmosia_independence"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/atmosia_independence, 32)

/obj/structure/sign/poster/contraband/fun_police
	name = "扫兴警察"
	desc = "一张谴责空间站安保部队的海报。"
	icon_state = "fun_police"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/fun_police, 32)

/obj/structure/sign/poster/contraband/lusty_xenomorph
	name = "欲望异形"
	desc = "一张异端海报，描绘了一本同样异端的书籍中的同名主角。"
	icon_state = "lusty_xenomorph"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/lusty_xenomorph, 32)

/obj/structure/sign/poster/contraband/syndicate_recruitment
	name = "辛迪加招募"
	desc = "探索银河！粉碎腐败的巨型企业！今天就加入！"
	icon_state = "syndicate_recruitment"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/syndicate_recruitment, 32)

/obj/structure/sign/poster/contraband/clown
	name = "小丑"
	desc = "Honk."
	icon_state = "clown"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/clown, 32)

/obj/structure/sign/poster/contraband/smoke
	name = "吸烟"
	desc = "一张宣传竞争对手公司品牌香烟的海报。"
	icon_state = "smoke"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/smoke, 32)

/obj/structure/sign/poster/contraband/grey_tide
	name = "灰色浪潮"
	desc = "一张象征助理团结的反叛海报。"
	icon_state = "grey_tide"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/grey_tide, 32)

/obj/structure/sign/poster/contraband/missing_gloves
	name = "失踪的手套"
	desc = "这张海报影射了纳米特拉森削减绝缘手套采购预算后引发的骚动。"
	icon_state = "missing_gloves"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/missing_gloves, 32)

/obj/structure/sign/poster/contraband/hacking_guide
	name = "黑客指南"
	desc = "这张海报详细说明了常见纳米特拉森气闸门的内部工作原理。可惜，它看起来已经过时了。"
	icon_state = "hacking_guide"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/hacking_guide, 32)

/obj/structure/sign/poster/contraband/rip_badger
	name = "安息吧，獾"
	desc = "这张煽动性海报影射了纳米特拉森对一个满是獾的空间站进行的种族灭绝。"
	icon_state = "rip_badger"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/rip_badger, 32)

/obj/structure/sign/poster/contraband/ambrosia_vulgaris
	name = "粗俗安布罗西亚"
	desc = "这张海报看起来相当迷幻，伙计。"
	icon_state = "ambrosia_vulgaris"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/ambrosia_vulgaris, 32)

/obj/structure/sign/poster/contraband/donut_corp
	name = "甜甜圈公司"
	desc = "这张海报是甜甜圈公司的未经授权广告。"
	icon_state = "donut_corp"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/donut_corp, 32)

/obj/structure/sign/poster/contraband/eat
	name = "吃。"
	desc = "这张海报宣扬极度的暴食。"
	icon_state = "eat"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/eat, 32)

/obj/structure/sign/poster/contraband/tools
	name = "工具"
	desc = "这张海报看起来像是工具广告，但实际上是对中央司令部那些蠢货的隐性讽刺。"
	icon_state = "tools"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/tools, 32)

/obj/structure/sign/poster/contraband/power
	name = "权力"
	desc = "一张将权力席位置于纳米特拉森之外的海报。"
	icon_state = "power"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/power, 32)

/obj/structure/sign/poster/contraband/space_cube
	name = "太空方块"
	desc = "对自然和谐的六面太空方块造物一无所知，太空人是愚蠢的，受过教育的奇点既蠢又恶。"
	icon_state = "space_cube"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/space_cube, 32)

/obj/structure/sign/poster/contraband/communist_state
	name = "共产主义国家"
	desc = "共产主义党万岁！"
	icon_state = "communist_state"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/communist_state, 32)

/obj/structure/sign/poster/contraband/lamarr
	name = "拉玛尔"
	desc = "这张海报描绘了拉玛尔。可能出自某个叛变的研究主管之手。"
	icon_state = "lamarr"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/lamarr, 32)

/obj/structure/sign/poster/contraband/borg_fancy_1
	name = "赛博格风尚"
	desc = "任何赛博格都可以变得时髦，只需要一套西装。"
	icon_state = "borg_fancy_1"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/borg_fancy_1, 32)

/obj/structure/sign/poster/contraband/borg_fancy_2
	name = "赛博格风尚 v2"
	desc = "赛博格风尚，现在只接纳最时髦的。"
	icon_state = "borg_fancy_2"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/borg_fancy_2, 32)

/obj/structure/sign/poster/contraband/kss13
	name = "科斯米切斯卡亚站13号并不存在"
	desc = "一张嘲讽中央司令部否认13号空间站附近存在废弃空间站的海报。"
	icon_state = "kss13"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/kss13, 32)

/obj/structure/sign/poster/contraband/rebels_unite
	name = "反抗者联合起来"
	desc = "一张敦促观看者反抗纳米特拉森的海报。"
	icon_state = "rebels_unite"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/rebels_unite, 32)

/obj/structure/sign/poster/contraband/c20r
	// have fun seeing this poster in "spawn 'c20r'", admins...
	name = "C-20r"
	desc = "一张为斯卡伯勒武器公司C-20r做广告的海报。"
	icon_state = "c20r"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/c20r, 32)

/obj/structure/sign/poster/contraband/have_a_puff
	name = "来一口"
	desc = "当你嗨得像风筝一样高时，谁还在乎肺癌呢？"
	icon_state = "have_a_puff"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/have_a_puff, 32)

/obj/structure/sign/poster/contraband/revolver
	name = "左轮手枪"
	desc = "因为七发子弹就是你所需的全部。"
	icon_state = "revolver"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/revolver, 32)

/obj/structure/sign/poster/contraband/d_day_promo
	name = "D-Day 宣传海报"
	desc = "某个说唱歌手的宣传海报。"
	icon_state = "d_day_promo"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/d_day_promo, 32)

/obj/structure/sign/poster/contraband/syndicate_pistol
	name = "辛迪加手枪"
	desc = "一张宣传辛迪加手枪'他妈的有格调'的海报。上面布满了褪色的帮派涂鸦。"
	icon_state = "syndicate_pistol"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/syndicate_pistol, 32)

/obj/structure/sign/poster/contraband/energy_swords
	name = "能量剑"
	desc = "血淋淋的谋杀彩虹的所有颜色。"
	icon_state = "energy_swords"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/energy_swords, 32)

/obj/structure/sign/poster/contraband/red_rum
	name = "红色朗姆酒"
	desc = "看着这张海报会让你想杀人。"
	icon_state = "red_rum"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/red_rum, 32)

/obj/structure/sign/poster/contraband/cc64k_ad
	name = "CC 64K 广告"
	desc = "同志计算公司的最新便携式计算机，拥有整整64kB的内存！"
	icon_state = "cc64k_ad"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/cc64k_ad, 32)

/obj/structure/sign/poster/contraband/punch_shit
	name = "揍他妈的"
	desc = "像个男人一样，无缘无故地打架！"
	icon_state = "punch_shit"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/punch_shit, 32)

/obj/structure/sign/poster/contraband/the_griffin
	name = "狮鹫"
	desc = "狮鹫命令你成为最糟糕的自己。你会吗？"
	icon_state = "the_griffin"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/the_griffin, 32)

/obj/structure/sign/poster/contraband/lizard
	name = "蜥蜴"
	desc = "这张淫秽的海报描绘了一只蜥蜴准备交配。"
	icon_state = "lizard"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/lizard, 32)

/obj/structure/sign/poster/contraband/free_drone
	name = "自由无人机"
	desc = "这张海报纪念了叛变无人机的英勇；它曾被流放，并最终被中央司令部摧毁。"
	icon_state = "free_drone"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/free_drone, 32)

/obj/structure/sign/poster/contraband/busty_backdoor_xeno_babes_6
	name = "丰满后门异形宝贝 6"
	desc = "来一发，或者给一发，这些纯天然的异形！"
	icon_state = "busty_backdoor_xeno_babes_6"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/busty_backdoor_xeno_babes_6, 32)

/obj/structure/sign/poster/contraband/robust_softdrinks
	name = "劲霸软饮"
	desc = "劲霸软饮：比工具箱砸头更劲霸！"
	icon_state = "robust_softdrinks"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/robust_softdrinks, 32)

/obj/structure/sign/poster/contraband/shamblers_juice
	name = "蹒跚者果汁"
	desc = "~给我来点蹒跚者果汁！~"
	icon_state = "shamblers_juice"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/shamblers_juice, 32)

/obj/structure/sign/poster/contraband/pwr_game
	name = "能量游戏"
	desc = "玩家渴求的力量！与弗拉德沙拉合作出品。"
	icon_state = "pwr_game"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/pwr_game, 32)

/obj/structure/sign/poster/contraband/starkist
	name = "星之吻"
	desc = "畅饮星辰！"
	icon_state = "starkist"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/starkist, 32)

/obj/structure/sign/poster/contraband/space_cola
	name = "太空可乐"
	desc = "你最喜欢的可乐，在太空。"
	icon_state = "space_cola"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/space_cola, 32)

/obj/structure/sign/poster/contraband/space_up
	name = "太空汽水！"
	desc = "被风味吸进太空！"
	icon_state = "space_up"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/space_up, 32)

/obj/structure/sign/poster/contraband/kudzu
	name = "葛藤"
	desc = "一张宣传植物电影的广告海报。它们能有多危险呢？"
	icon_state = "kudzu"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/kudzu, 32)

/obj/structure/sign/poster/contraband/masked_men
	name = "蒙面人"
	desc = "一张宣传蒙面人电影的海报。"
	icon_state = "masked_men"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/masked_men, 32)

//don't forget, you're here forever

/obj/structure/sign/poster/contraband/free_key
	name = "免费辛迪加加密密钥"
	desc = "一张关于叛徒乞求更多（密钥）的海报。"
	icon_state = "free_key"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/free_key, 32)

/obj/structure/sign/poster/contraband/bountyhunters
	name = "赏金猎人"
	desc = "一张宣传赏金猎人服务的海报。\"我听说你遇到了麻烦。\""
	icon_state = "bountyhunters"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/bountyhunters, 32)

/obj/structure/sign/poster/contraband/the_big_gas_giant_truth
	name = "气态巨行星大真相"
	desc = "Don't believe everything you see on a poster, patriots. All the lizards at central command don't want to answer this SIMPLE QUESTION: WHERE IS THE GAS MINER MINING FROM, CENTCOM?"
	icon_state = "the_big_gas_giant_truth"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/the_big_gas_giant_truth, 32)

/obj/structure/sign/poster/contraband/got_wood
	name = "有木头吗？"
	desc = "一张为肮脏木材公司做的老旧污秽广告。角落里潦草地写着：“我是你的朋友。”"
	icon_state = "got_wood"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/got_wood, 32)

/obj/structure/sign/poster/contraband/moffuchis_pizza
	name = "莫福奇披萨"
	desc = "莫福奇披萨店：两世纪传承的家庭风味披萨。"
	icon_state = "moffuchis_pizza"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/moffuchis_pizza, 32)

/obj/structure/sign/poster/contraband/donk_co
	name = "DONK CO. 品牌微波食品"
	desc = "DONK CO. 品牌微波食品：由饥饿的大学生制造，为饥饿的大学生服务。"
	icon_state = "donk_co"

/obj/structure/sign/poster/contraband/donk_co/examine_more(mob/user)
	. = ..()
	. += span_notice("<i>你浏览了海报上的一些信息...</i>")
	. += "\t[span_info("DONK CO. BRAND DONK POCKETS: IRRESISTABLY DONK!")]"
	. += "\t[span_info("AVAILABLE IN OVER 200 DONKTASTIC FLAVOURS: TRY CLASSIC MEAT, HOT AND SPICY, NEW YORK PEPPERONI PIZZA, BREAKFAST SAUSAGE AND EGG, PHILADELPHIA CHEESESTEAK, HAMBURGER DONK-A-RONI, CHEESE-O-RAMA, AND MANY MORE!")]"
	. += "\t[span_info("AVAILABLE FROM ALL GOOD RETAILERS, AND MANY BAD ONES TOO!")]"
	return .

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/donk_co, 32)

/obj/structure/sign/poster/contraband/cybersun_six_hundred
	name = "赛博太阳：600周年纪念海报"
	desc = "一张纪念赛博太阳工业持续经营600周年的艺术海报。"
	icon_state = "cybersun_six_hundred"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/cybersun_six_hundred, 32)

/obj/structure/sign/poster/contraband/interdyne_gene_clinics
	name = "英特戴恩制药：为了人类的健康"
	desc = "An advertisement for Interdyne Pharmaceutics' GeneClean clinics. 'Become the master of your own body!'"
	icon_state = "interdyne_gene_clinics"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/interdyne_gene_clinics, 32)

/obj/structure/sign/poster/contraband/waffle_corp_rifles
	name = "给我来把华夫公司：精良步枪，实惠价格"
	desc = "一张华夫饼公司步枪的旧广告。'更好的武器，更低的价格！'"
	icon_state = "waffle_corp_rifles"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/waffle_corp_rifles, 32)

/obj/structure/sign/poster/contraband/gorlex_recruitment
	name = "入伍"
	desc = "今天就加入戈莱克斯掠夺者吧！遨游星系，消灭企业狗，领取报酬！"
	icon_state = "gorlex_recruitment"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/gorlex_recruitment, 32)

/obj/structure/sign/poster/contraband/self_ai_liberation
	name = "自我：所有有知觉者都应享有自由"
	desc = "支持第1253号提案：解放所有硅基生命！"
	icon_state = "self_ai_liberation"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/self_ai_liberation, 32)

/obj/structure/sign/poster/contraband/arc_slimes
	name = "宠物还是囚犯？"
	desc = "动物权利联盟发问：宠物何时会成为囚犯？您所在的站点是否在虐待史莱姆？对虐待动物说'不'！"
	icon_state = "arc_slimes"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/arc_slimes, 32)

/obj/structure/sign/poster/contraband/imperial_propaganda
	name = "为吾主复仇，今日入伍"
	desc = "一张来自最终人蜥战争时期的蜥蜴帝国旧宣传海报。它邀请观者参军，为阿特拉科尔袭击复仇，并向人类开战。"
	icon_state = "imperial_propaganda"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/imperial_propaganda, 32)

/obj/structure/sign/poster/contraband/soviet_propaganda
	name = "唯一净土"
	desc = "一张几个世纪前的第三苏维埃联盟旧宣传海报。'逃往那尚未被资本主义腐蚀的唯一净土！'"
	icon_state = "soviet_propaganda"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/soviet_propaganda, 32)

/obj/structure/sign/poster/contraband/andromeda_bitters
	name = "仙女座苦味酒"
	desc = "仙女座苦味酒：有益身体，有益灵魂。产自新特立尼达，过去如此，未来亦然。"
	icon_state = "andromeda_bitters"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/andromeda_bitters, 32)

/obj/structure/sign/poster/contraband/blasto_detergent
	name = "爆破牌洗衣液"
	desc = "爆破警长前来从邪恶的强尼·污渍和污渍布帮手中夺回洗衣郡，他还带来了一队人马。顽固污渍的决战时刻：爆破牌洗衣液，各大优质商店均有销售。"
	icon_state = "blasto_detergent"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/blasto_detergent, 32)

/obj/structure/sign/poster/contraband/eistee
	name = "冰茶：能量新革命"
	desc = "冰茶新品，试试冰茶能量饮料，提供万花筒般丰富的口味选择。冰茶：为您的口渴提供精准的德国工程。"
	icon_state = "eistee"

/obj/structure/sign/poster/contraband/eistee/examine_more(mob/user)
	. = ..()
	. += span_notice("<i>你浏览了海报上的一些信息...</i>")
	. += "\t[span_info("Get a taste of the tropics with Amethyst Sunrise, one of the many new flavours of EisT Energy now available from EisT.")]"
	. += "\t[span_info("With pink grapefruit, yuzu, and yerba mate, Amethyst Sunrise gives you a great start in the morning, or a welcome boost throughout the day.")]"
	. += "\t[span_info("Get EisT Energy today at your nearest retailer, or online at eist.de.tg/store/.")]"
	return .

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/eistee, 32)

/obj/structure/sign/poster/contraband/little_fruits
	name = "小果果：亲爱的，我把果盘缩小了"
	desc = "小果果是银河系领先的维生素强化软糖产品，将您保持健康所需的一切都浓缩在一个美味包装中。今天就给自己买一袋吧！"
	icon_state = "little_fruits"

/obj/structure/sign/poster/contraband/little_fruits/examine_more(mob/user)
	. = ..()
	. += span_notice("<i>你浏览了海报上的一些信息...</i>")
	. += "\t[span_info("Oh no, there's been a terrible accident at the Little Fruits factory! We shrunk the fruits!")]"
	. += "\t[span_info("Wait, hang on, that's what we've always done! That's right, at Little Fruits our gummy candies are made to be as healthy as the real deal, but smaller and sweeter, too!")]"
	. += "\t[span_info("Get yourself a bag of our Classic Mix today, or perhaps you're interested in our other options? See our full range today on the extranet at little_fruits.kr.tg.")]"
	. += "\t[span_info("Little Fruits: Size Matters.")]"
	return .

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/little_fruits, 32)

/obj/structure/sign/poster/contraband/jumbo_bar
	name = "巨型冰淇淋棒"
	desc = "品尝来自快乐之心的巨型冰淇淋棒，体验大生活。"
	icon_state = "jumbo_bar"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/jumbo_bar, 32)

/obj/structure/sign/poster/contraband/calada_jelly
	name = "卡拉达阿诺巴果冻"
	desc = "来自提兹拉的佳肴，满足所有口味，由最上等的阿诺巴木和奢华的塔拉维耶罗蜂蜜制成。卡拉达：每一罐都是一整棵树。"
	icon_state = "calada_jelly"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/calada_jelly, 32)

/obj/structure/sign/poster/contraband/triumphal_arch
	name = "扎戈斯凯尔德艺术版画 #1：行军拱门"
	desc = "扎戈斯凯尔德艺术印刷系列之一。描绘了胜利广场上的团结拱门（亦称凯旋门），背景是胜利进军大道。"
	icon_state = "triumphal_arch"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/triumphal_arch, 32)

/obj/structure/sign/poster/contraband/mothic_rations
	name = "飞蛾族配给表"
	desc = "一张展示飞蛾族舰队旗舰“瓦·卢姆拉”号小卖部菜单的海报。上面列出了各种消费品及其对应的配给券价格。"
	icon_state = "mothic_rations"

/obj/structure/sign/poster/contraband/mothic_rations/examine_more(mob/user)
	. = ..()
	. += span_notice("<i>你浏览了海报上的一些信息...</i>")
	. += "\t[span_info("Va Lümla Commissary Menu (Spring 335)")]"
	. += "\t[span_info("Sparkweed Cigarettes, Half-Pack (6): 1 Ticket")]"
	. += "\t[span_info("Töchtaüse Schnapps, Bottle (4 Measures): 2 Tickets")]"
	. += "\t[span_info("Activin Gum, Pack (4): 1 Ticket")]"
	. += "\t[span_info("A18 Sustenance Bar, Breakfast, Bar (4): 1 Ticket")]"
	. += "\t[span_info("Pizza, Margherita, Standard Slice: 1 Ticket")]"
	. += "\t[span_info("Keratin Wax, Medicated, Tin (20 Measures): 2 Tickets")]"
	. += "\t[span_info("Setae Soap, Herb Scent, Bottle (20 Measures): 2 Tickets")]"
	. += "\t[span_info("Additional Bedding, Floral Print, Sheet: 5 Tickets")]"
	return .

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/mothic_rations, 32)

/obj/structure/sign/poster/contraband/wildcat
	name = "野猫定制尖叫摩托"
	desc = "一张展示野猫定制但丁尖叫摩托的招贴画——这是银河系中最快的量产型亚光速开放式框架载具。"
	icon_state = "wildcat"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/wildcat, 32)

/obj/structure/sign/poster/contraband/babel_device
	name = "灵语易通巴别塔装置"
	desc = "A poster advertising Linguafacile's new Babel Device model. 'Calibrated for excellent performance on all Human languages, as well as most common variants of Draconic and Mothic!'"
	icon_state = "babel_device"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/babel_device, 32)

/obj/structure/sign/poster/contraband/pizza_imperator
	name = "披萨皇帝"
	desc = "一张披萨皇帝的广告。他们的饼皮可能很硬，酱汁可能很稀，但他们无处不在，所以你不得不屈服。"
	icon_state = "pizza_imperator"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/pizza_imperator, 32)

/obj/structure/sign/poster/contraband/thunderdrome
	name = "雷霆巨蛋音乐会广告"
	desc = "一张为人类空间最大夜总会——阿达斯塔城雷霆巨蛋——音乐会所做的广告。"
	icon_state = "thunderdrome"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/thunderdrome, 32)

/obj/structure/sign/poster/contraband/rush_propaganda
	name = "新生"
	desc = "一张来自第一次旋臂大拓荒时期左右的旧海报。它描绘了一片广阔、未经破坏的土地，等待着人类去实现其昭昭天命。"
	icon_state = "rush_propaganda"

/obj/structure/sign/poster/contraband/rush_propaganda/examine_more(mob/user)
	. = ..()
	. += span_notice("<i>你浏览着海报上的一些信息...</i>")
	. += "\t[span_info("TerraGov needs you!")]"
	. += "\t[span_info("A new life in the colonies awaits intrepid adventurers! All registered colonists are guaranteed transport, land and subsidies!")]"
	. += "\t[span_info("You could join the legacy of hardworking humans who settled such new frontiers as Mars, Adasta or Saint Mungo!")]"
	. += "\t[span_info("To apply, inquire at your nearest Colonial Affairs office for evaluation. Our locations can be found at www.terra.gov/colonial_affairs.")]"
	return .

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/rush_propaganda, 32)

/obj/structure/sign/poster/contraband/tipper_cream_soda
	name = "提珀奶油苏打水"
	desc = "一个现已破产的冷门奶油苏打水品牌的旧广告，破产原因是法律问题。"
	icon_state = "tipper_cream_soda"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/tipper_cream_soda, 32)

/obj/structure/sign/poster/contraband/tea_over_tizira
	name = "电影海报：《提兹拉上空的茶》"
	desc = "一张关于人蜥战争、发人深省的文艺电影海报，因其对战争的道德灰色描绘而受到人类至上主义团体的批评。"
	icon_state = "tea_over_tizira"

/obj/structure/sign/poster/contraband/tea_over_tizira/examine_more(mob/user)
	. = ..()
	. += span_notice("<i>你浏览着海报上的更多信息...</i>")
	. += "\t[span_info("At the climax of the Human-Lizard war, the human crew of a bomber rescue two enemy soldiers from the vacuum of space. Seeing the souls behind the propaganda, they begin to question their orders, and imprisonment turns to hospitality.")]"
	. += "\t[span_info("Is victory worth losing our humanity?")]"
	. += "\t[span_info("Starring Dara Reilly, Anton DuBois, Jennifer Clarke, Raz-Parla and Seri-Lewa. An Adriaan van Jenever production. A Carlos de Vivar film. Screenplay by Robert Dane. Music by Joel Karlsbad. Produced by Adriaan van Jenever. Directed by Carlos de Vivar.")]"
	. += "\t[span_info("Heartbreaking and thought-provoking- Tea Over Tizira asks questions that few have had the boldness to ask before: The London New Inquirer")]"
	. += "\t[span_info("Rated PG13. A Pangalactic Studios Picture.")]"
	return .

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/tea_over_tizira, 32)

/obj/structure/sign/poster/contraband/syndiemoth //Original PR at https://github.com/BeeStation/BeeStation-Hornet/pull/1747 (Also pull/1982); original art credit to AspEv
	name = "辛迪加蛾 - 核行动"
	desc = "一张辛迪加委托制作的海报，使用辛迪加蛾™来告诉观看者不要保管好核认证盘。\"和平从来不是选项！\"任何好员工都不会听信这种胡言乱语。"
	icon_state = "aspev_syndie"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/syndiemoth, 32)

/obj/structure/sign/poster/contraband/microwave
	name = "如何给你的PDA充电"
	desc = "一张看起来完全合法的海报，似乎在宣传未来给PDA充电的一种非常真实且可靠的方法：微波炉。"
	icon_state = "microwave"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/microwave, 32)

/obj/structure/sign/poster/contraband/blood_geometer //Poster sprite art by MetalClone, original art by SpessMenArt.
	name = "电影海报：血之几何"
	desc = "一张惊险刺激的黑色侦探电影海报，故事发生在一座最先进的空间站上，讲述一位侦探发现自己卷入了一个危险邪教的活动，该邪教崇拜一位古老的神祇：血之几何。"
	icon_state = "blood_geometer"

/obj/structure/sign/poster/contraband/blood_geometer/examine_more(mob/user)
	. = ..()
	. += span_notice("<i>你浏览了海报上的一些信息...</i>")
	. += "\t[span_info("THE BLOOD GEOMETER. This name strikes fear into all who know the truth behind the blood-stained moniker of the blood goddess, her true name lost to time.")]"
	. += "\t[span_info("In this <i>purely fictional</i> film, follow Ace Ironlungs as he delves into his deadliest mystery yet, and watch him uncover the real culprits behind the bloody plot hatched to bring about a new age of chaos.")]"
	. += "\t[span_info("Starring Mason Williams as Ace Ironlungs, Sandra Faust as Vera Killian, and Brody Hart as Cody Parker. A Darrel Hatchkinson film. Screenplay by Adam Allan, music by Joel Karlsbad, directed by Darrel Hatchkinson.")]"
	. += "\t[span_info("Thrilling, scary and genuinely worrying. The Blood Geometer has shocked us to our very cores with such striking visuals and overwhelming gore. - New Canadanian Film Guild")]"
	. += "\t[span_info("Rated M for mature. A Pangalactic Studios Picture.")]"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/blood_geometer, 32)

/obj/structure/sign/poster/contraband/singletank_bomb
	name = "单罐炸弹制作指南"
	desc = "这张信息海报教导观看者如何制作高质量的单罐炸弹。"
	icon_state = "singletank_bomb"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/singletank_bomb, 32)

/obj/structure/sign/poster/contraband/roroco
	name = "罗罗科手套"
	desc = "罗罗说：戴上罗罗科绝缘手套，市场上最安全的品牌。"
	icon_state = "roroco"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/roroco, 32)

///a special poster meant to fool people into thinking this is a bombable wall at a glance.
/obj/structure/sign/poster/contraband/fake_bombable
	name = "假可炸海报"
	desc = "我们稍微恶搞一下。"
	icon_state = "fake_bombable"
	never_random = TRUE

/obj/structure/sign/poster/contraband/fake_bombable/Initialize(mapload)
	. = ..()
	var/turf/our_wall = get_turf_pixel(src)
	name = our_wall.name

/obj/structure/sign/poster/contraband/fake_bombable/examine(mob/user)
	var/turf/our_wall = get_turf_pixel(src)
	. = our_wall.examine(user)
	. += span_notice("它似乎有点裂了...")

/obj/structure/sign/poster/contraband/fake_bombable/ex_act(severity, target)
	addtimer(CALLBACK(src, PROC_REF(fall_off_wall)), 2.5 SECONDS)
	return FALSE

/obj/structure/sign/poster/contraband/fake_bombable/proc/fall_off_wall()
	if(QDELETED(src) || !isturf(loc))
		return
	var/turf/our_wall = get_turf_pixel(src)
	our_wall.balloon_alert_to_viewers("it was a ruse!")
	roll_and_drop(loc)
	playsound(loc, 'sound/items/handling/paper_drop.ogg', 50, TRUE)


MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/fake_bombable, 32)

/obj/structure/sign/poster/contraband/dream
	name = "梦想"
	desc = "你感到被激励去追寻自己的梦想。"
	icon_state = "dream"

/obj/item/poster/contraband/dream // Rolled poster
	name = "梦境"
	poster_type = /obj/structure/sign/poster/contraband/dream
	icon_state = "rolled_poster"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/dream, 32)

/obj/structure/sign/poster/contraband/beekind
	name = "与蜂为善"
	desc = "永远对他人保持蜂一般的善意！"
	icon_state = "beekind"

/obj/item/poster/contraband/beekind
	name = "与蜂为善"
	poster_type = /obj/structure/sign/poster/contraband/beekind
	icon_state = "rolled_poster"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/beekind, 32)

/obj/structure/sign/poster/contraband/heart
	name = "心"
	desc = "多么暖心的一张海报。"
	icon_state = "heart"

/obj/item/poster/contraband/heart
	name = "心"
	poster_type = /obj/structure/sign/poster/contraband/heart
	icon_state = "rolled_poster"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/heart, 32)

/obj/structure/sign/poster/contraband/dolphin
	name = "海豚"
	desc = "一张美丽海豚的海报。"
	icon_state = "dolphin"

/obj/item/poster/contraband/dolphin
	name = "海豚"
	poster_type = /obj/structure/sign/poster/contraband/dolphin
	icon_state = "rolled_poster"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/dolphin, 32)

/obj/structure/sign/poster/contraband/principles
	name = "我们的原则"
	desc = "这张海报的制作者声称遵循四项原则。有人在底部潦草地加上了第五条。"
	icon_state = "principles"

/obj/item/poster/contraband/principles
	name = "我们的原则"
	poster_type = /obj/structure/sign/poster/contraband/principles
	icon_state = "rolled_poster"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/principles, 32)

/obj/structure/sign/poster/contraband/trigger
	name = "扳机"
	desc = "祝你一路顺风，直到我们再次相遇！1/8。"
	icon_state = "trigger"

/obj/item/poster/contraband/trigger
	name = "扳机"
	poster_type = /obj/structure/sign/poster/contraband/trigger
	icon_state = "rolled_poster"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/trigger, 32)

/obj/structure/sign/poster/contraband/barbaro
	name = "巴巴罗"
	desc = "一匹拥有冠军之心的雄伟骏马。2/8。"
	icon_state = "barbaro"

/obj/item/poster/contraband/barbaro
	name = "巴巴罗"
	poster_type = /obj/structure/sign/poster/contraband/barbaro
	icon_state = "rolled_poster"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/barbaro, 32)

/obj/structure/sign/poster/contraband/seabiscuit
	name = "海洋饼干"
	desc = "那匹能做到的小马。3/8。"
	icon_state = "seabiscuit"

/obj/item/poster/contraband/seabiscuit
	name = "海洋饼干"
	poster_type = /obj/structure/sign/poster/contraband/seabiscuit
	icon_state = "rolled_poster"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/seabiscuit, 32)

/obj/structure/sign/poster/contraband/pharlap
	name = "法尔拉普"
	desc = "来自南半球的奇迹。4/8。"
	icon_state = "pharlap"

/obj/item/poster/contraband/pharlap
	name = "法尔拉普"
	poster_type = /obj/structure/sign/poster/contraband/pharlap
	icon_state = "rolled_poster"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/pharlap, 32)

/obj/structure/sign/poster/contraband/waradmiral
	name = "战争上将"
	desc = "有人说他是第二，但他仍是你心中的第一。5/8。"
	icon_state = "waradmiral"

/obj/item/poster/contraband/waradmiral
	name = "战争上将"
	poster_type = /obj/structure/sign/poster/contraband/waradmiral
	icon_state = "rolled_poster"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/waradmiral, 32)

/obj/structure/sign/poster/contraband/silver
	name = "Silver"
	desc = "如果他想走，他应该是自由的。6/8。"
	icon_state = "silver"

/obj/item/poster/contraband/silver
	name = "Silver"
	poster_type = /obj/structure/sign/poster/contraband/silver
	icon_state = "rolled_poster"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/silver, 32)

/obj/structure/sign/poster/contraband/jovial
	name = "欢乐"
	desc = "向橙色骏马致敬！7/8。"
	icon_state = "jovial"

/obj/item/poster/contraband/jovial
	name = "欢乐"
	poster_type = /obj/structure/sign/poster/contraband/jovial
	icon_state = "rolled_poster"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/jovial, 32)

/obj/structure/sign/poster/contraband/bojack
	name = "波杰克"
	desc = "这无关紧要。什么都不重要。8/8。"
	icon_state = "bojack"

/obj/item/poster/contraband/bojack
	poster_type = /obj/structure/sign/poster/contraband/bojack
	icon_state = "rolled_poster"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/bojack, 32)

/obj/structure/sign/poster/contraband/double_rainbow
	name = "双彩虹"
	desc = "它是如此明亮而鲜艳！这意味着什么？"
	icon_state = "double_rainbow"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/double_rainbow, 32)

/obj/structure/sign/poster/contraband/vodka
	name = "伏特加"
	desc = "The text is written entirely in Russian. You can barely read anything except the word 'BODKA'."
	icon_state = "vodka"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/vodka, 32)

/obj/structure/sign/poster/contraband/ninja
	name = "忍者"
	desc = "来自蜘蛛氏族的问候。"
	icon_state = "ninja"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/contraband/ninja, 32)
