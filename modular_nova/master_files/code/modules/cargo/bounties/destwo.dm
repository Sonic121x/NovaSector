// Goals for all of DS-2

/datum/bounty/item/ds2
	reward = CARGO_CRATE_VALUE * 5

/datum/bounty/item/ds2/handcuffs
	name = "审讯黑站"
	description = "MI13的高层希望向一处本地黑站运送更多手铐。给他们送一些过去。"
	required_count = 5
	reward = CARGO_CRATE_VALUE * 4
	wanted_types = list(
		/obj/item/restraints/handcuffs = TRUE,
	)

/datum/bounty/item/ds2/eyes
	name = "眼线"
	description = "戈莱克斯掠夺者中的突击队需要一些热成像电子眼。给他们送一些过去，他们会付个好价钱。"
	reward = CARGO_CRATE_VALUE * 8
	required_count = 3
	wanted_types = list(
		/obj/item/organ/eyes/robotic/thermals = TRUE,
	)

/datum/bounty/item/ds2/skillchip
	name = "赛博甲板"
	description = "赛博阳想要一些CNS技能芯片连接器植入体用于几项测试。你知道该怎么做，给他们送一些过去。"
	required_count = 4
	reward = CARGO_CRATE_VALUE * 6
	wanted_types = list(
		/obj/item/organ/cyberimp/brain/connector = TRUE,
	)

/datum/bounty/item/ds2/tape
	name = "特殊用途"
	description = "MI13想要一些超级尖锐的胶带。给他们弄一些过去，好让他们别再为此烦我们了。"
	required_count = 3
	reward = CARGO_CRATE_VALUE * 5
	wanted_types = list(
		/obj/item/stack/medical/wrap/sticky_tape/pointy/super = TRUE,
	)

/datum/bounty/item/ds2/gambling
	name = "娱乐用途"
	description = "DS-9对他们最后几台老虎机在一次纳米传讯突袭中被毁感到不太高兴。介意给他们送些新主板吗？船员们没有赌博可玩都快疯了。"
	required_count = 3
	reward = CARGO_CRATE_VALUE * 5
	wanted_types = list(
		/obj/item/circuitboard/computer/slot_machine = TRUE,
	)

/datum/bounty/item/ds2/aichallenge
	name = "内核级处决"
	description = "SELF希望你运送几块AI核心主板过去，他们计划在上面添加一些特殊可执行程序。"
	required_count = 3
	reward = CARGO_CRATE_VALUE * 10
	wanted_types = list(
		/obj/item/circuitboard/aicore = TRUE,
	)

/datum/bounty/item/ds2/clownops
	name = "小丑把戏"
	description = "我们几位更搞笑的行动员弄丢了他们搞笑的击针。就……别问了。"
	required_count = 3
	reward = CARGO_CRATE_VALUE * 50
	wanted_types = list(
		/obj/item/firing_pin/clown = TRUE,
	)

/datum/bounty/item/ds2/randomgods
	name = "恶意之神计划"
	description = "We need you to send a gunkit... a special one called the Event Horizon anti-existential beam rifle part kit. Name's a tongue-twister, but... best you don't ask why we need it."
	reward = CARGO_CRATE_VALUE * 10
	wanted_types = list(
		/obj/item/weaponcrafting/gunkit/beam_rifle = TRUE,
	)

/datum/bounty/item/ds2/clandestine
	name = "秘密行动"
	description = "MI13想要几个消音器，给我们更隐秘的一线特工用。送过去，他们会付个好价钱。"
	required_count = 3
	reward = CARGO_CRATE_VALUE * 8
	wanted_types = list(
		/obj/item/suppressor = TRUE,
	)

/datum/bounty/item/ds2/mindcrack
	name = "心智破解计划"
	description = "戈莱克斯想要几个心智护盾击针进行改造，希望能重新接线为我们所用。他们不接受任何其他击针。"
	required_count = 3
	reward = CARGO_CRATE_VALUE * 8
	wanted_types = list(
		/obj/item/firing_pin/implant/mindshield = TRUE,
	)

/datum/bounty/item/ds2/battleship
	name = "战舰麻烦"
	description = "A recent 'project', per se, has recently taken a fair chunk of our attention... Send us a few communications console boards so we may wire them into our vessels."
	required_count = 3
	reward = CARGO_CRATE_VALUE * 10
	wanted_types = list(
		/obj/item/circuitboard/computer/communications = TRUE,
	)

/datum/bounty/item/ds2/coffee
	name = "咖啡熔毁"
	description = "最近发生的事故导致DS-5、D-6和DS-7上的所有咖啡机都坏了……我们不清楚它们是怎么坏的，但只需送几块新电路板过去，他们就能修好。"
	required_count = 3
	reward = CARGO_CRATE_VALUE * 5
	wanted_types = list(
		/obj/item/circuitboard/machine/coffeemaker = TRUE,
	)

/datum/bounty/item/ds2/flashes
	name = "催眠闪光"
	description = "我们的一些前线人员和IRN的朋友丢了几支催眠闪光棒，送几支新的闪光棒给他们改装，他们会给你一笔不错的报酬。"
	required_count = 10
	reward = CARGO_CRATE_VALUE * 5
	wanted_types = list(
		/obj/item/assembly/flash/handheld = TRUE,
	)

/datum/bounty/item/ds2/cyberpens
	name = "法律努力"
	description = "Cybersun ran out of materials for their... 'Specialty' pens and it's now your problem to fix. Get them a couple of pens so they can make more."
	required_count = 10
	reward = CARGO_CRATE_VALUE * 5
	wanted_types = list(
		/obj/item/pen = TRUE,
	)

/datum/bounty/item/ds2/pizzabombs
	name = "披萨炸弹"
	description = "We had a situation with a recent raid from an unfavorable corporation, they blew up our pizza line so we need you to send some. Give us a few and we'll send a payment to you. \
		And send whole pies. If we get slices, someone is getting fired."
	required_count = 3
	reward = CARGO_CRATE_VALUE * 10
	wanted_types = list(
		/obj/item/food/pizza = TRUE,
	)

/datum/bounty/item/ds2/telecrystals
	name = "远程水晶"
	description = "我们的晶体合成器似乎出了故障，送我们几块蓝空晶体，我们会确保你拿到报酬。"
	required_count = 5
	reward = CARGO_CRATE_VALUE * 10
	wanted_types = list(
		/obj/item/stack/ore/bluespace_crystal = TRUE,
	)

/datum/bounty/item/ds2/toolboxes
	name = "工具箱"
	description = "我们的可疑工具箱用完了，送我们几个普通工具箱，你就会得到报酬。"
	required_count = 5
	reward = CARGO_CRATE_VALUE * 5
	wanted_types = list(
		/obj/item/storage/toolbox = TRUE,
	)

/datum/bounty/item/ds2/dafuckindisk
	name = "那该死的磁盘"
	description = "戈莱克斯公司用完了存放核爆音乐的数据磁盘，送他们几张磁盘，你就会得到报酬。确保是电脑用的数据磁盘，不是DNA磁盘。"
	required_count = 5
	reward = CARGO_CRATE_VALUE * 5
	wanted_types = list(
		/obj/item/disk/computer = TRUE,
	)
