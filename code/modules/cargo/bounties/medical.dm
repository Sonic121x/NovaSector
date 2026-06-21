/datum/bounty/item/medical/heart
	name = "Heart-心脏"
	description = "Commander Johnson is in critical condition after suffering yet another heart attack. Doctors say he needs a new heart fast. Ship one, pronto! We'll take a cybernetic one if need be, but only if it's upgraded."
	reward = CARGO_CRATE_VALUE * 5
	wanted_types = list(
		/obj/item/organ/heart = TRUE,
		/obj/item/organ/heart/synth = FALSE, // NOVA EDIT ADDITION
		/obj/item/organ/heart/cybernetic = FALSE,
		/obj/item/organ/heart/cybernetic/tier2 = TRUE,
		/obj/item/organ/heart/cybernetic/tier3 = TRUE,
	)

/datum/bounty/item/medical/lung
	name = "Lungs-肺"
	description = "A recent explosion at Central Command has left multiple staff with punctured lungs. Ship spare lungs to be rewarded. We'll take cybernetic ones if need be, but only if they're upgraded."
	reward = CARGO_CRATE_VALUE * 10
	required_count = 3
	wanted_types = list(
		/obj/item/organ/lungs = TRUE,
		/obj/item/organ/lungs/synth = FALSE, // NOVA EDIT ADDITION
		/obj/item/organ/lungs/cybernetic = FALSE,
		/obj/item/organ/lungs/cybernetic/tier2 = TRUE,
		/obj/item/organ/lungs/cybernetic/tier3 = TRUE,
	)

/datum/bounty/item/medical/appendix
	name = "Appendix-阑尾"
	description = "Chef Gibb of Central Command wants to prepare a meal using a very special delicacy: an appendix. If you ship one, he'll pay."
	reward = CARGO_CRATE_VALUE * 5 //there are no synthetic appendixes
	wanted_types = list(/obj/item/organ/appendix = TRUE)

/datum/bounty/item/medical/ears
	name = "Ears-耳朵"
	description = "Multiple staff at Station 12 have been left deaf due to unauthorized clowning. Ship them new ears. We'll take cybernetic ones if need be, but only if they're upgraded."
	reward = CARGO_CRATE_VALUE * 10
	required_count = 3
	wanted_types = list(
		/obj/item/organ/ears = TRUE,
		/obj/item/organ/ears/synth = FALSE, // NOVA EDIT ADDITION
		/obj/item/organ/ears/cybernetic = FALSE,
		/obj/item/organ/ears/cybernetic/upgraded = TRUE,
		/obj/item/organ/ears/cybernetic/whisper = TRUE,
		/obj/item/organ/ears/cybernetic/xray = TRUE,
		/obj/item/organ/ears/cybernetic/volume = TRUE,
	)

/datum/bounty/item/medical/liver
	name = "Livers-肝"
	description = "多名中央司令部高级外交官在与第三苏维埃联盟大使会晤后因肝功能衰竭住院。帮我们一把，好吗？如果需要的话，我们也可以接受赛博格肝脏，但必须是升级过的。"
	reward = CARGO_CRATE_VALUE * 10
	required_count = 3
	wanted_types = list(
		/obj/item/organ/liver = TRUE,
		/obj/item/organ/liver/synth = FALSE, // NOVA EDIT ADDITION
		/obj/item/organ/liver/cybernetic = FALSE,
		/obj/item/organ/liver/cybernetic/tier2 = TRUE,
		/obj/item/organ/liver/cybernetic/tier3 = TRUE,
	)

/datum/bounty/item/medical/eye
	name = "Organic Eyes-有机眼"
	description = "Station 5's Research Director Willem is requesting a few pairs of non-robotic eyes. Don't ask questions, just ship them."
	reward = CARGO_CRATE_VALUE * 10
	required_count = 3
	wanted_types = list(
		/obj/item/organ/eyes = TRUE,
		/obj/item/organ/eyes/synth = FALSE, // NOVA EDIT ADDITION
		/obj/item/organ/eyes/robotic = FALSE,
	)

/datum/bounty/item/medical/tongue
	name = "Tongues-舌"
	description = "最近一次默剧演员极端分子的袭击让23号空间站的员工们说不出话来。运送一些备用舌头过来。"
	reward = CARGO_CRATE_VALUE * 10
	required_count = 3
	// wanted_types = list(/obj/item/organ/tongue = TRUE) // NOVA EDIT REMOVAL
	// NOVA EDIT ADDITION START
	wanted_types = list(
		/obj/item/organ/tongue = TRUE,
		/obj/item/organ/tongue/synth = FALSE,
	)
	// NOVA EDIT ADDITION END

/datum/bounty/item/medical/lizard_tail
	name = "蜥蜴尾"
	description = "巫师联合会偷走了纳米传讯的蜥蜴尾巴库存。在中央司令部对付巫师的同时，你们空间站能支援一条尾巴吗？"
	reward = CARGO_CRATE_VALUE * 6
	wanted_types = list(/obj/item/organ/tail/lizard = TRUE)

/datum/bounty/item/medical/cat_tail
	name = "猫尾"
	description = "中央司令部的高级管道清洁剂用完了。你能运送一条猫尾巴来帮我们吗？"
	reward = CARGO_CRATE_VALUE * 6
	wanted_types = list(/obj/item/organ/tail/cat = TRUE)

/datum/bounty/item/medical/chainsaw
	name = "链锯"
	description = "中央司令部的一位医疗总监在给魔像做手术时遇到了困难。她请求提供一把链锯。"
	reward = CARGO_CRATE_VALUE * 5
	wanted_types = list(/obj/item/chainsaw = TRUE)

/datum/bounty/item/medical/tail_whip //Like the cat tail bounties, with more processing.
	name = "九尾鞭"
	description = "杰克逊指挥官正在为她奇特的武器收藏寻找一件精品。她会为一条猫尾九节鞭或蜥蜴尾九节鞭提供丰厚的报酬。"
	reward = CARGO_CRATE_VALUE * 8
	wanted_types = list(/obj/item/melee/chainofcommand/tailwhip = TRUE)

/datum/bounty/item/medical/surgerycomp
	name = "手术计算机"
	description = "在我们中央司令部年度奶酪节上又发生了一起离奇的爆炸事件后，我们这边有一大堆受伤的船员。如果可能的话，请给我们发送一台新的手术电脑。"
	reward = CARGO_CRATE_VALUE * 12
	wanted_types = list(/obj/machinery/computer/operating = TRUE)

/datum/bounty/item/medical/surgerytable
	name = "手术台"
	description = "在最近一批受感染的船员涌入后，我们发现仅靠口罩已经不够了。银质手术台或许能解决问题，给我们送一台来用用。"
	reward = CARGO_CRATE_VALUE * 6
	wanted_types = list(/obj/structure/table/optable = TRUE)

/datum/bounty/item/medical/scanning
	name = "船员医疗扫描"
	description = "使用任何健康分析仪对一名健康状况接近完美或更好的船员进行一次常规医疗扫描，以确保船员认真对待他们的医疗护理。然后，打印医疗报告并将其运送回我们这里。"
	reward = CARGO_CRATE_VALUE * 8
	required_count = 2
	wanted_types = list(/obj/item/paper/medical_report = TRUE)

/datum/bounty/item/medical/scanning/applies_to(obj/shipped)
	. = ..()
	if(!istype(shipped, /obj/item/paper/medical_report))
		return FALSE
	var/obj/item/paper/medical_report/report = shipped
	if(!report)
		return FALSE

	var/mob/living/patient = report.last_healthy_scanned_mob?.resolve()
	if(patient)
		return TRUE
	return FALSE
