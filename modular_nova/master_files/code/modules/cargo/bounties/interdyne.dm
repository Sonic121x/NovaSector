/datum/bounty/item/interdyne_med/heart
	name = "心脏"
	description = "公司需要一些新的心脏用于科学研究。他们允许提交赛博格心脏，但不会接受任何基础赛博格部件。"
	reward = CARGO_CRATE_VALUE * 10
	wanted_types = list(
		/obj/item/organ/heart = TRUE,
		/obj/item/organ/heart/synth = FALSE,
		/obj/item/organ/heart/cybernetic = FALSE,
		/obj/item/organ/heart/cybernetic/tier2 = TRUE,
		/obj/item/organ/heart/cybernetic/tier3 = TRUE,
	)

/datum/bounty/item/interdyne_med/lung
	name = "肺"
	description = "在一次不利事件后，公司需要一些新的肺，具体细节无关紧要。有机肺是首选，但赛博格肺也可以接受。基础赛博格部件不会被接受。"
	reward = CARGO_CRATE_VALUE * 10
	required_count = 3
	wanted_types = list(
		/obj/item/organ/lungs = TRUE,
		/obj/item/organ/lungs/synth = FALSE,
		/obj/item/organ/lungs/cybernetic = FALSE,
		/obj/item/organ/lungs/cybernetic/tier2 = TRUE,
		/obj/item/organ/lungs/cybernetic/tier3 = TRUE,
	)

/datum/bounty/item/interdyne_med/appendix
	name = "阑尾"
	description = "一家……合作公司的几位高管需要一个全新的阑尾，弄一个来他们会付钱。"
	reward = CARGO_CRATE_VALUE * 5
	wanted_types = list(/obj/item/organ/appendix = TRUE)

/datum/bounty/item/interdyne_med/ears
	name = "耳朵"
	description = "因特戴恩29号船发生化学事故导致船员失聪后，需要提供新的耳朵。赛博格耳朵可以，但基础赛博格部件不会被接受。"
	reward = CARGO_CRATE_VALUE * 10
	required_count = 3
	wanted_types = list(
		/obj/item/organ/ears = TRUE,
		/obj/item/organ/ears/synth = FALSE,
		/obj/item/organ/ears/cybernetic = FALSE,
		/obj/item/organ/ears/cybernetic/upgraded = TRUE,
		/obj/item/organ/ears/cybernetic/whisper = TRUE,
		/obj/item/organ/ears/cybernetic/xray = TRUE,
	)

/datum/bounty/item/interdyne_med/liver
	name = "肝脏"
	description = "我们的一处设施最近收治了大量肝衰竭患者。最好送一些有机肝脏来，但赛博格肝脏也行。基础赛博格部件不会被接受。"
	reward = CARGO_CRATE_VALUE * 5
	required_count = 3
	wanted_types = list(
		/obj/item/organ/liver = TRUE,
		/obj/item/organ/liver/synth = FALSE,
		/obj/item/organ/liver/cybernetic = FALSE,
		/obj/item/organ/liver/cybernetic/tier2 = TRUE,
		/obj/item/organ/liver/cybernetic/tier3 = TRUE,
	)

/datum/bounty/item/interdyne_med/eye
	name = "有机眼球"
	description = "IPMV-113上的一位首席研究员用完了带有有机眼睛的尸体……再给他们供应一些，细节我就不多说了。赛博格眼睛不会被接受。"
	reward = CARGO_CRATE_VALUE * 10
	required_count = 3
	wanted_types = list(
		/obj/item/organ/eyes = TRUE,
		/obj/item/organ/eyes/synth = FALSE,
		/obj/item/organ/eyes/robotic = FALSE,
	)

/datum/bounty/item/interdyne_med/tongue
	name = "舌头"
	description = "IPMV-25最近玩了个大冒险游戏，结果傻乎乎地碰了硫酸。他们需要一些新舌头，能送就送点过来。合成舌头不接受。"
	reward = CARGO_CRATE_VALUE * 10
	required_count = 3
	wanted_types = list(
		/obj/item/organ/tongue = TRUE,
		/obj/item/organ/tongue/synth = FALSE,
	)

/datum/bounty/item/interdyne_med/lizard_tail
	name = "蜥蜴尾巴"
	description = "一家合作公司最近发生了一起近乎致命的事故，病人需要一条蜥蜴尾巴。提供它，我们会让你觉得物有所值。"
	reward = CARGO_CRATE_VALUE * 6
	wanted_types = list(/obj/item/organ/tail/lizard = TRUE)

/datum/bounty/item/interdyne_med/cat_tail
	name = "猫尾巴"
	description = "由于酒精、不道德的想法以及质疑猫耳族是否只是长了猫耳朵的人类，我们的一名员工失去了尾巴。尽快送一条新的猫尾巴过来。"
	reward = CARGO_CRATE_VALUE * 6
	wanted_types = list(/obj/item/organ/tail/cat = TRUE)

/datum/bounty/item/interdyne_med/chainsaw
	name = "链锯"
	description = "IPMV-2201上的伊扎泽尔医生想要一把链锯……算了，别问了，送一把过来，他们会慷慨付款的。"
	reward = CARGO_CRATE_VALUE * 5
	wanted_types = list(/obj/item/chainsaw = TRUE)

/datum/bounty/item/interdyne_med/surgerycomp
	name = "手术计算机"
	description = "最近发生了一起炸弹和酒精引发的离奇事故，我们的一台外科手术电脑彻底报废了。给我们送一台，你会得到丰厚报酬。"
	reward = CARGO_CRATE_VALUE * 12
	wanted_types = list(/obj/machinery/computer/operating = TRUE)

/datum/bounty/item/interdyne_med/surgerytable
	name = "手术台"
	description = "最近受感染的船员激增，我们发现光靠口罩已经不够了。也许银质手术台能解决问题，送一张给我们用用。"
	reward = CARGO_CRATE_VALUE * 6
	wanted_types = list(/obj/structure/table/optable = TRUE)
