
/datum/bounty/item/science/relic
	name = "实验机-导师电路板"
	description = "嘘，嘿。别告诉助手们，但我们正在压低他们发现的那些‘奇怪物品’的价值。用E.X.P.E.R.I-MENTOR捞一个上来，然后给我们送一个已鉴定的。"
	reward = CARGO_CRATE_VALUE * 8
	wanted_types = list(/obj/item/relic = TRUE)

/datum/bounty/item/science/relic/applies_to(obj/O)
	if(!..())
		return FALSE
	var/obj/item/relic/experiment = O
	if(experiment.activated)
		return TRUE
	return

/datum/bounty/item/science/bepis_disc
	name = "重新格式化的技术磁盘"
	description = "事实证明，BEPIS打印实验节点所用的磁盘空间效率极高。用完后，把你多余的送一张给我们。"
	reward = CARGO_CRATE_VALUE * 8
	wanted_types = list(
		/obj/item/disk/design_disk/bepis/remove_tech = TRUE,
		/obj/item/disk/design_disk/bepis = TRUE,
	)

/datum/bounty/item/science/genetics
	name = "遗传障碍突变器"
	description = "理解类人基因组是治愈许多太空遗传缺陷、超越我们最基本极限的第一步。"
	reward = CARGO_CRATE_VALUE * 2
	wanted_types = list(/obj/item/dnainjector = TRUE)
	///What's the instability
	var/desired_instability = 0

/datum/bounty/item/science/genetics/New()
	. = ..()
	desired_instability = rand(10,40)
	reward += desired_instability * (CARGO_CRATE_VALUE * 0.2)
	description += " We want a DNA injector whose total instability is higher than [desired_instability] points."

/datum/bounty/item/science/genetics/applies_to(obj/O)
	if(!..())
		return FALSE
	var/obj/item/dnainjector/mutator = O
	if(mutator.used)
		return FALSE
	var/inst_total = 0
	for(var/pot_mut in mutator.add_mutations)
		var/datum/mutation/mutation = pot_mut
		if(initial(mutation.quality) != POSITIVE)
			continue
		inst_total += mutation.instability
	if(inst_total >= desired_instability)
		return TRUE
	return FALSE

//******Modular Computer Bounties******
/datum/bounty/item/science/ntnet
	name = "模块化平板电脑"
	description = "事实证明，NTNet毕竟不是一时流行，谁知道呢。送一些功能齐全的PDA来帮助我们跟上最新技术。"
	reward = CARGO_CRATE_VALUE * 6
	required_count = 4
	wanted_types = list(/obj/item/modular_computer/pda = TRUE)
	var/require_powered = TRUE

/datum/bounty/item/science/ntnet/applies_to(obj/O)
	if(!..())
		return FALSE
	if(require_powered)
		var/obj/item/modular_computer/computer = O
		if(!istype(computer) || !computer.enabled)
			return FALSE
	return TRUE

/datum/bounty/item/science/ntnet/laptops
	name = "模块化笔记本电脑"
	description = "中央司令部的高层需要比平板更强大、比控制台更便携的东西。帮帮这些老古董，给我们运送一些能正常工作的笔记本电脑。请将它们开机后发送。"
	reward = CARGO_CRATE_VALUE * 3
	required_count = 2
	wanted_types = list(/obj/item/modular_computer/laptop = TRUE)

/datum/bounty/item/science/ntnet/console
	name = "模块化电脑控制台"
	description = "我们的大数据部门需要更强大的硬件来玩‘炸翻古巴人-’，呃，是为了密切监控你们星区的威胁。给我们发送一台能正常工作的模块化计算机控制台。"
	reward = CARGO_CRATE_VALUE * 6
	required_count = 1
	wanted_types = list(/obj/machinery/modular_computer = TRUE)
	require_powered = FALSE

/datum/bounty/item/science/ntnet/console/applies_to(obj/O)
	if(!..())
		return FALSE
	var/obj/machinery/modular_computer/computer = O
	if(!istype(computer) || !computer.cpu)
		return FALSE
	return TRUE


//******Anomaly Cores******
/datum/bounty/item/science/ref_anomaly
	name = "精制蓝空核心"
	description = "我们需要一个蓝空核心来组装一个次元袋。请给我们运送一个。"
	reward = CARGO_CRATE_VALUE * 20
	wanted_types = list(/obj/item/assembly/signaler/anomaly/bluespace = TRUE)

/datum/bounty/item/science/ref_anomaly/can_get(obj/O)
	var/anomaly_type = wanted_types[1]
	if(SSresearch.created_anomaly_types[anomaly_type] >= SSresearch.anomaly_hard_limit_by_type[anomaly_type])
		return FALSE
	return TRUE

/datum/bounty/item/science/ref_anomaly/flux
	name = "精制磁波核心"
	description = "我们正试图制造一把特斯拉炮来对付一些蛾子。请给我们运送一个通量核心。"
	wanted_types = list(/obj/item/assembly/signaler/anomaly/flux = TRUE)

/datum/bounty/item/science/ref_anomaly/pyro
	name = "精制火成碎屑核心"
	description = "我们需要研究一个精炼的熔火核心，请发送一个。"
	wanted_types = list(/obj/item/assembly/signaler/anomaly/pyro = TRUE)

/datum/bounty/item/science/ref_anomaly/grav
	name = "精制重力核心"
	description = "中央研发部正试图找到让机甲浮起来的方法，请发送一个引力核心。"
	wanted_types = list(/obj/item/assembly/signaler/anomaly/grav = TRUE)

/datum/bounty/item/science/ref_anomaly/vortex
	name = "精制漩涡核心"
	description = "我们打算把一个涡流核心扔进虫洞看看会发生什么。发送一个过来。"
	wanted_types = list(/obj/item/assembly/signaler/anomaly/vortex = TRUE)

/datum/bounty/item/science/ref_anomaly/hallucination
	name = "精制幻惑核心"
	description = "我们正在制造一种更好的太空毒品，给我们发送一个核心来帮助我们复制其效果。"
	wanted_types = list(/obj/item/assembly/signaler/anomaly/hallucination = TRUE)

/datum/bounty/item/science/ref_anomaly/bioscrambler
	name = "精制生物扰频核心"
	description = "我们的清洁工蜥蜴失去了所有肢体，给我们发送一个生物扰频核心来替换它们。"
	wanted_types = list(/obj/item/assembly/signaler/anomaly/bioscrambler = TRUE)

/datum/bounty/item/science/ref_anomaly/dimensional
	name = "精制维度核心"
	description = "我们正试图节省中央司令部年度翻新的费用。给我们发送一个维度核心。"
	wanted_types = list(/obj/item/assembly/signaler/anomaly/dimensional = TRUE)
