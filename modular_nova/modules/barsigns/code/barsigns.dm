// Modularly set the correct icon file
/obj/machinery/barsign/update_icon_state()
	. = ..()
	// uses tg icon file
	if(!istype(chosen_sign, /datum/barsign/nova) || icon_state == "empty")
		icon = initial(icon)
		return

	// uses modular icon file
	if(istype(chosen_sign, /datum/barsign/nova/large))
		icon = NOVA_LARGE_BARSIGN_FILE
	else
		icon = NOVA_BARSIGN_FILE

/datum/barsign/nova/topmen
	name = "顶尖人物"
	icon_state = "topmen"
	neon_color = "#C2AACA"

/datum/barsign/nova/spaceballgrille
	name = "太空球烧烤"
	icon_state = "spaceballgrille"
	neon_color = "#827973"

/datum/barsign/nova/clubee
	name = "蜜蜂俱乐部"
	icon_state = "clubee"
	neon_color = "#F2EEEE"

/datum/barsign/nova/thesun
	name = "太阳"
	icon_state = "thesun"
	neon_color = "#F8F0B8"

/datum/barsign/nova/limbo
	name = "灵薄狱"
	icon_state = "limbo"
	desc = "迷失灵魂的流行聚集地。氛围灯光简直绝了！"
	neon_color = "#777777"

/datum/barsign/nova/meadbay
	name = "蜜酒湾"
	icon_state = "meadbay"
	neon_color = "#EBB823"

/datum/barsign/nova/cindikate
	name = "辛迪·凯特"
	icon_state = "cindikate"
	neon_color = "#FF3403"

/datum/barsign/nova/theclownshead
	name = "小丑之首"
	icon_state = "theclownshead"
	desc = "这里是Headdy的家，那个会按喇叭的小丑头！"
	neon_color = "#FFD800"

/datum/barsign/nova/theorchard
	name = "果园"
	icon_state = "theorchard"
	neon_color = "#CFFF47"

/datum/barsign/nova/thesaucyclown
	name = "俏皮小丑"
	icon_state = "thesaucyclown"
	desc = "一年一度小丑求偶仪式的知名聚集地。"
	neon_color = "#FF66CC"

/datum/barsign/nova/thedamnwall
	name = "该死的墙"
	icon_state = "thedamnwall"
	desc = "当你被逼到墙角时，最好的伙伴就是身边可靠的烈酒和可靠的朋友。"
	neon_color = "#CC3333"

/datum/barsign/nova/whiskeyimplant
	name = "威士忌植入体"
	icon_state = "whiskeyimplant"
	neon_color = "#E9F517"

/datum/barsign/nova/carpecarp
	name = "抓住鲤鱼"
	icon_state = "carpecarp"
	neon_color = "#C717FE"

/datum/barsign/nova/robustroadhouse
	name = "强健路边酒馆"
	icon_state = "robustroadhouse"
	neon_color = "#F7A804"

/datum/barsign/nova/theredshirt
	name = "红衫客"
	icon_state = "theredshirt"
	neon_color = "#FF92E0"

/datum/barsign/nova/maltesefalconmk2
	name = "马耳他猎鹰MK2"
	icon_state = "maltesefalconmk2"
	desc = "马耳他猎鹰第二代，现在更加硬核了。"
	neon_color = "#E30000"

/datum/barsign/nova/thecavernmk2
	name = "洞穴MK2"
	icon_state = "thecavernmk2"
	desc = "美酒配佳音。"
	neon_color = "#AA9393"

/datum/barsign/nova/lv426
	name = "LV-426"
	icon_state = "lv426"
	desc = "戴着花哨面罩喝酒显然比去医疗室更重要。"
	neon_color = "#00F206"

/datum/barsign/nova/zocalo
	name = "索卡洛"
	icon_state = "zocalo"
	desc = "Anteriormente ubicado en Spessmerica."
	neon_color = "#E5AF1C"

/datum/barsign/nova/fourtheemprah
	name = "为了帝皇"
	icon_state = "4theemprah"
	desc = "狂热者、异端分子和脑损伤的顾客都乐在其中。"
	neon_color = "#E5AF1C"

/datum/barsign/nova/ishimura
	name = "石村"
	icon_state = "ishimura"
	desc = "以其优质的棕星酒和美味的饼干而闻名。"
	neon_color = "#FF0000"

/datum/barsign/nova/tardis
	name = "塔迪斯"
	icon_state = "tardis"
	desc = "这家店至少经历了5,343次迭代。"
	neon_color = "#2739AA"

/datum/barsign/nova/quarks
	name = "夸克酒吧"
	icon_state = "quarks"
	desc = "这家店的常客经常戴着介子扫描仪；多么别致。"
	neon_color = "#10E500"

/datum/barsign/nova/tenforward
	name = "十前区"
	icon_state = "tenforward"
	neon_color = "#E5AF1C"

/datum/barsign/nova/theprancingpony
	name = "跃马客栈"
	icon_state = "theprancingpony"
	desc = "好吧，我们可不太喜欢你们这些小个子到处打探，寻找什么游侠渣滓。"
	neon_color = "#FF9100"

/datum/barsign/nova/vault13
	name = "13号避难所"
	icon_state = "vault13"
	desc = "巧合是刻意的。"
	neon_color = "#FFA800"

/datum/barsign/nova/thehive
	name = "蜂巢"
	icon_state = "thehive"
	neon_color = "#FFC62A"

/datum/barsign/nova/cantina
	name = "查尔蒙的坎蒂娜"
	icon_state = "cantina"
	desc = "这家酒吧建立在原创性原则之上；他们24/7播放着同样的音乐。"
	neon_color = "#0078FF"

/datum/barsign/nova/milliways42
	name = "42号尽头餐厅"
	icon_state = "milliways42"
	desc = "这并非真正的终结；它是你所有饮品需求的开始、意义与答案。"
	neon_color = "#FF00F6"

/datum/barsign/nova/timeofeve
	name = "夏娃的时间"
	icon_state = "thetimeofeve"
	desc = "来自2453年的复古饮品！"
	neon_color = "#EB52F8"

/datum/barsign/nova/spaceasshole
	name = "太空混蛋"
	icon_state = "spaceasshole"
	desc = "自2125年开业以来，变化不大；工程师们仍然会释放奇点，而那些该死的矿工仍然更可能砸烂你的脸而不是送来矿石。"
	neon_color = "#FF0000"

/datum/barsign/nova/birdcage
	name = "鸟笼酒吧"
	icon_state = "birdcage"
	desc = "呱。"
	neon_color = "#FFD21E"

/datum/barsign/nova/narsie
	name = "纳尔西小馆"
	icon_state = "narsiebistro"
	desc = "世界终结前的最后一家酒馆。"
	neon_color = "#FF0000"

/datum/barsign/nova/fallout
	name = "酒窖掩体"
	icon_state = "boozebunker"
	desc = "躲避炮火时，怎能没有一杯酒！"
	neon_color = "#FCC41B"

/datum/barsign/nova/brokendreams
	name = "破碎梦想咖啡馆"
	icon_state = "brokendreams"
	desc = "尝尝我们新出的狗肉小汉堡！"
	neon_color = "#E8E8A5"

/datum/barsign/nova/toolboxtavern
	name = "工具箱酒馆"
	icon_state = "toolboxtavern"
	desc = "每购买一杯螺丝刀鸡尾酒，即可获赠免费住宿！"
	neon_color = ""

/datum/barsign/nova/blueoyster
	name = "蓝牡蛎酒吧"
	icon_state = "blueoyster"
	desc = "专为完全异性恋男士开设的完全异性恋酒吧，进来看看就知道了。"
	neon_color = ""

/datum/barsign/nova/foreign
	name = "异国美食招牌"
	icon_state = "foreign"
	desc = "一块用某种死语言书写的招牌，宣传着某种难以名状的异国美食。"
	neon_color = ""

/datum/barsign/nova/commie
	name = "无产者首选"
	icon_state = "commie"
	desc = "同志，这是你唯一需要的酒吧！"
	neon_color = "#E46F6F"

/datum/barsign/nova/brokenheros
	name = "破碎英雄酒吧"
	icon_state = "brokenheros"
	desc = "你喜欢伤害别人吗？"
	neon_color = ""

/datum/barsign/nova/sociallubricator
	name = "社交润滑剂"
	icon_state = "sociallubricator"
	desc = "让你喜欢上你讨厌的人的完美之物。"
	neon_color = ""

/datum/barsign/nova/chemlab
	name = "化学实验室"
	icon_state = "chemlab"
	desc = "尝尝我们的新款等离子马提尼！"
	neon_color = ""

/datum/barsign/nova/mime
	name = "月光哑剧"
	icon_state = "mime"
	desc = "静默，非搅拌。"
	neon_color = ""

/datum/barsign/nova/clown
	name = "鸣叫小丑"
	icon_state = "clown"
	desc = "香蕉不包含在内。"
	neon_color = ""

/datum/barsign/nova/progressive
	name = "一家现代而进步的酒吧"
	icon_state = "progressive"
	desc = "管它什么意思。"
	neon_color = "#DB9B9A"

/datum/barsign/nova/va11halla
	name = "VA-11 HALL-A"
	icon_state = "va11halla"
	desc = "不像 N1-RV Ann-A 那么危险。"
	neon_color = "#FB3F7D"

/datum/barsign/nova/squatopia
	name = "蹲踞乌托邦"
	icon_state = "squatopia"
	desc = "这水晶曾属于我父亲。他被谋杀了。"
	neon_color = "#CC0033"

/datum/barsign/nova/bug
	name = "饥饿虫虫"
	icon_state = "hungrybug"
	desc = "快来品尝“洞窟”著名的饺子吧！"
	neon_color = "#E2B001"

// 96x96 signs

/datum/barsign/nova/large/cyberslyph
	name = "赛博精灵"
	icon_state = "cyberslyph"
	neon_color = "#00FFFF"
