/datum/experiment/scanning/points/slime
	name = "基础史莱姆实验"
	required_points = 1

/datum/experiment/scanning/points/slime/hard
	name = "挑战性史莱姆调查"
	description = "Another station has challenged your research team to collect several challenging slime cores, \
		are you up to the task?"
	required_points = 10
	required_atoms = list(/obj/item/slime_extract/bluespace = 1,
		/obj/item/slime_extract/sepia = 1,
		/obj/item/slime_extract/cerulean = 1,
		/obj/item/slime_extract/pyrite = 1,
		/obj/item/slime_extract/red = 2,
		/obj/item/slime_extract/green = 2,
		/obj/item/slime_extract/pink = 2,
		/obj/item/slime_extract/gold = 2)

/datum/experiment/scanning/points/slime/expert
	name = "专家级史莱姆调查"
	description = "The intergalactic society of xenobiologists are currently looking for samples of the most complex \
		slime cores, we are tasking your station with providing them with everything they need."
	required_points = 10
	required_atoms = list(/obj/item/slime_extract/adamantine = 1,
		/obj/item/slime_extract/oil = 1,
		/obj/item/slime_extract/black = 1,
		/obj/item/slime_extract/lightpink = 1,
		/obj/item/slime_extract/rainbow = 10)

/datum/experiment/scanning/random/cytology/easy
	name = "基本细胞学扫描实验"
	description = "一位科学家需要害虫进行测试，使用细胞学设备培育一些简单的生物吧！"
	total_requirement = 3
	max_requirement_per_type = 2
	possible_types = list(/mob/living/basic/cockroach, /mob/living/basic/mouse, /mob/living/basic/snail)

/datum/experiment/scanning/random/cytology/medium
	name = "高级细胞学扫描实验"
	description = "我们需要观察身体从最初时刻如何运作。一些细胞学实验将帮助我们获得这种理解。"
	total_requirement = 3
	max_requirement_per_type = 2
	possible_types = list(
		/mob/living/basic/pet/cat,
		/mob/living/basic/carp,
		/mob/living/basic/chicken,
		/mob/living/basic/cow,
		/mob/living/basic/pet/dog/corgi,
		/mob/living/basic/snake,
	)

/datum/experiment/scanning/random/cytology/medium/one
	name = "高级细胞学扫描实验一"

/datum/experiment/scanning/random/cytology/medium/two
	name = "高级细胞学扫描实验二"

/datum/experiment/scanning/random/janitor_trash
	name = "空间站卫生检查"
	description = "要学习如何清洁，我们必须先了解污秽是什么。我们需要你扫描空间站周围的一些污秽物。"
	possible_types = list(/obj/effect/decal/cleanable/vomit,
	/obj/effect/decal/cleanable/blood)
	total_requirement = 3

/datum/experiment/ordnance/explosive/lowyieldbomb
	name = "低威力炸药"
	description = "低当量炸药可能对我们的资产保护团队有用。用多普勒阵列捕捉一次小型爆炸，并将数据发表在论文中。"
	gain = list(10,15,20)
	target_amount = list(5,10,20)
	experiment_proper = TRUE
	sanitized_misc = FALSE
	sanitized_reactions = FALSE
	allow_any_source = TRUE

/datum/experiment/ordnance/explosive/highyieldbomb
	name = "高威力炸药"
	description =  "几种反应会释放大量能量，可用于制造更大的爆炸物。用多普勒阵列捕捉任何储罐爆炸，并将数据发表在论文中。允许任何气体反应。"
	gain = list(10,50,100)
	target_amount = list(50,100,300)
	experiment_proper = TRUE
	sanitized_misc = FALSE
	sanitized_reactions = FALSE

/datum/experiment/ordnance/explosive/hydrogenbomb
	name = "氢炸药"
	description = "氢及其衍生物的燃烧可能非常剧烈。使用多普勒阵列捕捉任何储罐爆炸，并将数据发表在论文中。仅允许氢或氚火。"
	gain = list(15,40,60)
	target_amount = list(50,75,150)
	experiment_proper = TRUE
	sanitized_misc = TRUE
	sanitized_reactions = TRUE
	require_all = FALSE
	required_reactions = list(/datum/gas_reaction/h2fire, /datum/gas_reaction/tritfire)

/datum/experiment/ordnance/explosive/nobliumbomb
	name = "超铌炸药"
	description = "超氖的形成过程能量极高，可用于制造爆炸物。使用多普勒阵列捕捉任何储罐爆炸，并将数据发表在论文中。仅允许超氖冷凝。"
	gain = list(15,60,120)
	target_amount = list(50,100,300)
	experiment_proper = TRUE
	sanitized_misc = TRUE
	sanitized_reactions = TRUE
	required_reactions = list(/datum/gas_reaction/nobliumformation)

/datum/experiment/ordnance/explosive/pressurebomb
	name = "非反应性炸药"
	description = "高比热容的气体可以加热低比热容的气体并产生巨大压力。使用多普勒阵列捕捉任何储罐爆炸，并将数据发表在论文中。不允许发生气体反应。"
	gain = list(10,50,100)
	target_amount = list(20,50,100)
	experiment_proper = TRUE
	sanitized_misc = FALSE
	sanitized_reactions = TRUE

/datum/experiment/ordnance/gaseous/nitrous_oxide
	name = "一氧化二氮气壳"
	description = "向作战区域输送N2O可能很有用。将指定气体装入储罐，并使用储罐压缩机使其爆裂。将数据发表在论文中。"
	gain = list(10,40)
	target_amount = list(200,600)
	experiment_proper = TRUE
	required_gas = /datum/gas/nitrous_oxide

/datum/experiment/ordnance/gaseous/plasma
	name = "等离子体气体炮弹"
	description = "向作战区域输送等离子气体可能很有用。将指定气体装入储罐，并使用储罐压缩机使其爆裂。将数据发表在论文中。"
	gain = list(10,40)
	target_amount = list(200,600)
	experiment_proper = TRUE
	required_gas = /datum/gas/plasma

/datum/experiment/ordnance/gaseous/bz
	name = "BZ气壳"
	description = "向作战区域输送BZ气体可能很有用。将指定气体装入储罐，并使用储罐压缩机使其爆裂。将数据发表在论文中。"
	gain = list(10,30,60)
	target_amount = list(50,125,400)
	experiment_proper = TRUE
	required_gas = /datum/gas/bz

/datum/experiment/ordnance/gaseous/noblium
	name = "超铌气壳"
	description = "向作战区域输送超氖气体可能很有用。将指定气体装入储罐，并使用储罐压缩机使其爆裂。将数据发表在论文中。"
	gain = list(10,40,80)
	target_amount = list(15,55,250)
	experiment_proper = TRUE
	required_gas = /datum/gas/hypernoblium

/datum/experiment/ordnance/gaseous/halon
	name = "哈龙气壳"
	description = "向作战区域输送哈龙气体可能很有用。在该领域进行研究并发表论文。"
	gain = list(10,30,60)
	target_amount = list(15,55,250)
	experiment_proper = TRUE
	required_gas = /datum/gas/halon

/datum/experiment/scanning/random/material/meat
	name = "生物材料扫描实验"
	description = "They told us we couldn't make chairs out of every material in the world. You're here to prove those naysayers wrong."
	possible_material_types = list(/datum/material/meat)

/datum/experiment/scanning/random/material/easy
	name = "低等级材料扫描实验"
	description = "Material science is all about a basic understanding of the universe, and how it's built. To explain this, build something basic and we'll show you how to break it."
	total_requirement = 6
	possible_types = list(/obj/structure/chair, /obj/structure/toilet, /obj/structure/table)
	possible_material_types = list(/datum/material/iron, /datum/material/glass)

/datum/experiment/scanning/random/material/medium
	name = "中等质量材料扫描实验"
	description = "并非所有材料都足够坚固，能撑起一座空间站。看看这些材料，了解一下是什么让它们对我们的电子设备和装备有用。"
	possible_material_types = list(/datum/material/silver, /datum/material/gold, /datum/material/plastic, /datum/material/titanium)

/datum/experiment/scanning/random/material/medium/one
	name = "中等质量材料扫描实验一"

/datum/experiment/scanning/random/material/medium/two
	name = "中等质量材料扫描实验二"

/datum/experiment/scanning/random/material/medium/three
	name = "中等质量材料扫描实验三"

/datum/experiment/scanning/random/material/hard
	name = "高等级材料扫描实验"
	description = "纳米传讯不惜成本，甚至要测试最有价值的材料作为建筑材料的品质。去为我们制造一些这些奇异的造物并收集数据吧。"
	possible_material_types = list(/datum/material/diamond, /datum/material/plasma, /datum/material/uranium)

/datum/experiment/scanning/random/material/hard/one
	name = "高等级材料扫描实验一"

/datum/experiment/scanning/random/material/hard/two
	name = "高等级材料扫描实验二"

/datum/experiment/scanning/random/material/hard/three
	name = "高等级材料扫描实验三"

/datum/experiment/scanning/random/plants/wild
	name = "野生生物物质变异样本"
	description = "由于多种原因（太阳射线、仅以不稳定诱变剂为食、熵增），不稳定性较低的植物在收获时偶尔会发生突变。请为我们扫描一份此类样本。"
	performance_hint = "\"Wild\" mutations have been recorded to occur above 30 points of instability, while species mutations occur above 60 points of instability."
	total_requirement = 1

/datum/experiment/scanning/random/plants/traits
	name = "独特的生物物质变异样本"
	description = "我们中央司令部正在寻找具有独特特性的稀有奇异植物，以便向股东们炫耀。我们目前正在寻找一份具有特定基因的样本。"
	performance_hint = "The wide varities of plants on station each carry various traits, some unique to them. Look for plants that may mutate into what we're looking for."
	total_requirement = 3
	possible_plant_genes = list(/datum/plant_gene/trait/squash, /datum/plant_gene/trait/cell_charge, /datum/plant_gene/trait/glow/shadow, /datum/plant_gene/trait/teleport, /datum/plant_gene/trait/brewing, /datum/plant_gene/trait/juicing, /datum/plant_gene/trait/eyes, /datum/plant_gene/trait/sticky)

/datum/experiment/scanning/points/machinery_tiered_scan/tier2_lathes
	name = "高级零部件基准值"
	description = "我们新设计的高级机械部件需要进行实际应用测试，以获取可能进一步改进的线索，并总体确认我们没有设计出更差的部件。"
	required_points = 6
	required_atoms = list(
		/obj/machinery/rnd/production/protolathe/department/science = 1,
		/obj/machinery/rnd/production/protolathe/department/engineering = 1,
		/obj/machinery/rnd/production/techfab/department/cargo = 1,
		/obj/machinery/rnd/production/techfab/department/medical = 1,
		/obj/machinery/rnd/production/techfab/department/security = 1,
		/obj/machinery/rnd/production/techfab/department/service = 1
	)
	required_tier = 2

/datum/experiment/scanning/points/machinery_tiered_scan/tier3_bluespacemachines
	name = "蓝空机械调谐"
	description = "利用蓝空能力的传送技术是我们公司的一大卖点，但校准程序中出现严重故障的威胁是我们未曾预料到的。既然我们的研发部门已经引发了飞人种族骚乱，也许你在标准零件方面的进展能帮助缓解这嗡嗡作响的问题。"
	required_points = 4
	required_atoms = list(
		/obj/machinery/teleport/hub = 1,
		/obj/machinery/teleport/station = 1
	)
	required_tier = 3

/datum/experiment/scanning/points/machinery_tiered_scan/tier3_variety
	name = "高效率组件应用测试"
	description = "我们需要对标准零件设计进行进一步测试，以将其效率和市场价格推向更高水平。"
	required_points = 15
	required_atoms = list(
		/obj/machinery/autolathe = 1,
		/obj/machinery/rnd/production/circuit_imprinter/department/science = 1,
		/obj/machinery/monkey_recycler = 1,
		/obj/machinery/processor/slime = 1,
		/obj/machinery/processor = 2,
		/obj/machinery/reagentgrinder = 2,
		/obj/machinery/hydroponics = 2,
		/obj/machinery/biogenerator = 3,
		/obj/machinery/gibber = 3,
		/obj/machinery/chem_master = 3,
		/obj/machinery/cryo_cell = 3,
		/obj/machinery/harvester = 5,
		/obj/machinery/quantumpad = 5
	)
	required_tier = 3

/datum/experiment/scanning/points/machinery_tiered_scan/tier3_mechbay
	name = "军用级机械所设置"
	description = "建造战斗型外骨骼是一项昂贵的工程。确保你拥有高效的生产设置，我们会发送一些我们的设计文件过来。"
	required_points = 6
	required_atoms = list(
		/obj/machinery/mecha_part_fabricator = 1,
		/obj/machinery/mech_bay_recharge_port = 1,
		/obj/machinery/recharge_station = 1
	)
	required_tier = 3

/datum/experiment/scanning/points/machinery_pinpoint_scan/tier2_microlaser
	name = "高功率微型-镭射校准"
	description = "我们的纳米传讯高功率办公就绪激光笔™目前还不足以将空中的辛迪加无人机击落。为我们找一些二极管应用，以获取改进它们的线索！"
	required_points = 10
	required_atoms = list(
		/obj/machinery/mecha_part_fabricator = 1,
		/obj/machinery/rnd/experimentor = 1,
		/obj/machinery/dna_scannernew = 1,
		/obj/machinery/microwave = 2,
		/obj/machinery/deepfryer = 2,
		/obj/machinery/chem_heater = 3,
		/obj/machinery/power/emitter = 3
	)
	required_stock_part = /obj/item/stock_parts/micro_laser/high

/datum/experiment/scanning/points/machinery_pinpoint_scan/tier2_capacitors
	name = "高级电容器基准测试"
	description = "进一步提高整个空间站设备的功率容量，是迈向代号为“关键”的重要项目的下一步：由蓝空约束核能驱动的电动轮椅。"
	required_points = 12
	required_atoms = list(
		/obj/machinery/recharge_station = 1,
		/obj/machinery/cell_charger = 1,
		/obj/machinery/mech_bay_recharge_port = 1,
		/obj/machinery/recharger = 2,
		/obj/machinery/power/smes = 2,
		/obj/machinery/chem_dispenser = 3,
		/obj/machinery/chem_dispenser/drinks = 3, /*actually having only the chem dispenser works for scanning soda/booze dispensers but im not quite sure how would i go about actually pointing that out w/o these two lines*/
		/obj/machinery/chem_dispenser/drinks/beer = 3
	)
	required_stock_part = /obj/item/stock_parts/capacitor/adv

/datum/experiment/scanning/points/machinery_pinpoint_scan/tier2_scanmodules
	name = "高级扫描模块校准"
	description = "尽管我们的空间站上扫描模块的使用率明显不足，我们仍然期望你对它们进行性能测试，以防我们想出突破性的方法在外骨骼中塞进6个扫描模块。"
	required_points = 6
	required_atoms = list(
		/obj/machinery/dna_scannernew = 1,
		/obj/machinery/rnd/experimentor = 1,
		/obj/machinery/medical_kiosk = 2,
		/obj/machinery/piratepad/civilian = 2,
	)
	required_stock_part = /obj/item/stock_parts/scanning_module/adv

/datum/experiment/scanning/points/machinery_pinpoint_scan/tier3_cells
	name = "电池容量测试"
	description = "纳米传讯在其新型仓鼠动力发电机阵列上面临两大问题：产生的电力过剩，以及动物权利联盟活动人士因对仓鼠进行绿巨人基因改造而发起的暴力抗议。我们优先处理后者！"
	required_points = 8
	required_atoms = list(
		/obj/machinery/recharge_station = 1,
		/obj/machinery/chem_dispenser = 1,
		/obj/machinery/chem_dispenser/drinks = 1,
		/obj/machinery/chem_dispenser/drinks/beer = 1,
		/obj/machinery/power/smes = 2
	)
	required_stock_part = /obj/item/stock_parts/power_store/cell/hyper

/datum/experiment/scanning/points/machinery_pinpoint_scan/tier3_microlaser
	name = "超功率微型-镭射校准"
	description = "我们即将通过发明足够精确的激光工具来超越过去的外科医生，这些工具甚至能在葡萄上进行手术。帮助我们微调二极管以达到完美！"
	required_points = 10
	required_atoms = list(
		/obj/machinery/mecha_part_fabricator = 1,
		/obj/machinery/microwave = 1,
		/obj/machinery/rnd/experimentor = 1,
		/obj/machinery/atmospherics/components/unary/thermomachine/freezer = 2,
		/obj/machinery/power/emitter = 2,
		/obj/machinery/chem_heater = 2,
		/obj/machinery/chem_mass_spec = 3
	)
	required_stock_part = /obj/item/stock_parts/micro_laser/ultra

/datum/experiment/scanning/random/mecha_damage_scan
	name = "外骨骼材料：应力失效测试"
	description = "你们的机械外骨骼制造机允许小规模快速生产，但所制造部件的结构完整性不如更传统的方法。"
	exp_tag = "Scan"
	total_requirement = 2
	possible_types = list(/obj/vehicle/sealed/mecha)
	///Damage percent that each mech needs to be at for a scan to work.
	var/damage_percent

/datum/experiment/scanning/random/mecha_equipped_scan
	name = "外骨骼材料：负载应变测试"
	description = "机械外骨骼装备会对载具结构造成独特的压力。扫描你从机械外骨骼制造机中组装并完全装备好的机械外骨骼，以加速我们的结构应力模拟。"
	possible_types = list(/obj/vehicle/sealed/mecha)
	total_requirement = 1

/// Scan a person with any mutation
/datum/experiment/scanning/people/mutant
	name = "人类实地研究：基因突变"
	description = "我们的新科研助手一直在为科学而饮用随机化学品，结果其中一人掌握了心灵传动，另一人则开始从眼睛发射激光。这可能对我们的研究有用。通过让助手饮用不稳定诱变剂、扫描他们并报告结果来重复这个实验。"
	performance_hint = "Scan a person with a random mutation."
	required_traits_desc = "random mutation"

/datum/experiment/scanning/people/mutant/is_valid_scan_target(mob/living/carbon/human/check, datum/component/experiment_handler/experiment_handler)
	. = ..()
	if (!.)
		return
	if(!LAZYLEN(check.dna.mutations))
		return FALSE
	return TRUE

/// Scan for organs you didn't start the round with
/datum/experiment/scanning/people/novel_organs
	name = "人类实地研究：异常生物学"
	description = "We need data on organic compatibility between species. Scan some samples of humanoid organisms with organs they don't usually have. \
		Data on mechanical organs isn't of any use to us."
	performance_hint = "Unusual organs can be introduced manually by transplant, genetic infusion, or very rapidly via a Bioscrambler anomaly effect."
	required_traits_desc = "non-synthetic organs not typical for their species"
	/// Disallow prosthetic organs
	var/organic_only = TRUE

/datum/experiment/scanning/people/novel_organs/is_valid_scan_target(mob/living/carbon/human/check)
	. = ..()
	if (!.)
		return
	// Organs which are valid for get_mutant_organ_type_for_slot
	var/static/list/vital_organ_slots = list(
		ORGAN_SLOT_BRAIN,
		ORGAN_SLOT_HEART,
		ORGAN_SLOT_LUNGS,
		ORGAN_SLOT_APPENDIX,
		ORGAN_SLOT_EYES,
		ORGAN_SLOT_EARS,
		ORGAN_SLOT_TONGUE,
		ORGAN_SLOT_LIVER,
		ORGAN_SLOT_STOMACH,
	)

	for (var/obj/item/organ/organ as anything in check.organs)
		if (organic_only && !IS_ORGANIC_ORGAN(organ))
			continue
		var/datum/species/target_species = check.dna.species
		if (organ.slot in vital_organ_slots)
			if (organ.type == target_species.get_mutant_organ_type_for_slot(organ.slot))
				continue
		else
			if ((organ.type in target_species.mutant_organs))
				continue
		return TRUE
	return FALSE

/// Scan for cybernetic organs
/datum/experiment/scanning/people/augmented_organs
	name = "人类实地研究：增强器官"
	description = "我们需要收集关于赛博格重要器官如何与人类生物学整合的数据。对植入这些器官的人类进行一次扫描，以帮助我们了解其兼容性。"
	performance_hint = "Perform an organ manipulation surgery to replace one of the vital organs with a cybernetic variant."
	required_traits_desc = "augmented vital organs"
	required_count = 1

/datum/experiment/scanning/people/augmented_organs/is_valid_scan_target(mob/living/carbon/human/check)
	. = ..()
	if (!.)
		return
	var/static/list/vital_organ_slots = list(
		ORGAN_SLOT_HEART,
		ORGAN_SLOT_LUNGS,
		ORGAN_SLOT_EYES,
		ORGAN_SLOT_EARS,
		ORGAN_SLOT_LIVER,
		ORGAN_SLOT_STOMACH,
	)

	for (var/obj/item/organ/organ as anything in check.organs)
		if ((organ.slot in vital_organ_slots) && IS_ROBOTIC_ORGAN(organ))
			return TRUE
	return FALSE

/// Scan for skillchips
/datum/experiment/scanning/people/skillchip
	name = "人类实地研究：技能芯片植入体"
	description = "在将编程电路植入人脑之前，我们需要了解大脑如何处理简单的芯片。扫描一名大脑中植有技能芯片的活人。"
	performance_hint = "Perform a skill chip implantation with a skill station."
	required_traits_desc = "skill chip implant"

/datum/experiment/scanning/people/skillchip/is_valid_scan_target(mob/living/carbon/human/check, datum/component/experiment_handler/experiment_handler)
	. = ..()
	if (!.)
		return
	var/obj/item/organ/brain/scanned_brain = check.get_organ_slot(ORGAN_SLOT_BRAIN)
	if (isnull(scanned_brain))
		experiment_handler.announce_message("Subject is brainless!")
		return FALSE
	if (scanned_brain.get_used_skillchip_slots() == 0)
		experiment_handler.announce_message("No skill chips found!")
		return FALSE
	return TRUE

/// Scan an android
/datum/experiment/scanning/people/android
	name = "人类实地研究：完全改造"
	description = "对一名船员进行完整的赛博格改造，然后扫描他们以测试其新获得的能力以及新的感官和认知功能。"
	performance_hint = "Achieve full augmentation by performing a set of surgery operations."
	required_traits_desc = "fully augmented android"
	required_count = 1

/datum/experiment/scanning/people/android/is_valid_scan_target(mob/living/carbon/human/check, datum/component/experiment_handler/experiment_handler)
	. = ..()
	if (!.)
		return
	if (isandroid(check))
		return TRUE
	if (length(check.organs) < 6 || length(check.get_missing_limbs()) > 1)
		return FALSE

	var/static/list/augmented_organ_slots = list(
		ORGAN_SLOT_EYES,
		ORGAN_SLOT_EARS,
		ORGAN_SLOT_HEART,
		ORGAN_SLOT_LUNGS,
		ORGAN_SLOT_LIVER,
		ORGAN_SLOT_STOMACH,
	)
	for (var/obj/item/organ/organ as anything in check.organs)
		if (!(organ.slot in augmented_organ_slots))
			continue
		if (!IS_ROBOTIC_ORGAN(organ))
			return FALSE
	for (var/obj/item/bodypart/bodypart as anything in check.get_bodyparts())
		if (!IS_ROBOTIC_LIMB(bodypart))
			return FALSE
	return TRUE

/datum/experiment/scanning/reagent/cryostylane
	name = "纯低温苯乙烯扫描"
	description = "看来冷冻苯试剂有可能完全停止人体的生理过程。生产纯度至少为99%的冷冻苯并扫描烧杯。"
	performance_hint = "Keep the temperature as high as possible during the reaction."
	required_reagent = /datum/reagent/cryostylane
	min_purity = 0.99

/datum/experiment/scanning/reagent/haloperidol
	name = "纯氟哌啶醇扫描"
	description = "我们需要进行与慢性精神障碍长期治疗相关的测试。生产纯度至少为98%的氟哌啶醇并扫描烧杯。"
	performance_hint = "Exothermic and consumes hydrogen during reaction."
	required_reagent = /datum/reagent/medicine/haloperidol
	min_purity = 0.98

/datum/experiment/scanning/points/bluespace_crystal
	name = "蓝晶采样"
	description = "通过扫描人工或自然生成的变体来研究蓝空晶体的特性。这将有助于我们加深对蓝空现象的理解。"
	required_points = 1
	required_atoms = list(
		/obj/item/stack/ore/bluespace_crystal = 1,
		/obj/item/stack/sheet/bluespace_crystal = 1
	)

/datum/experiment/scanning/points/anomalies
	name = "已中和异常分析"
	description = "我们现在有能力处理异常了。用异常中和器将其消除，或在精炼厂中精炼原始核心并扫描结果。"
	required_points = 4
	required_atoms = list(/obj/item/assembly/signaler/anomaly = 1)

/datum/experiment/scanning/points/machinery_tiered_scan/tier2_any
	name = "升级版标准零件基准测试"
	description = "我们新设计的机械部件需要进行实际应用测试，以获取可能进一步发展的线索，并总体确认我们没有设计出更差的部件。扫描任何装有升级部件的机械并报告结果。"
	required_points = 6
	required_atoms = list(
		/obj/machinery = 1
	)
	required_tier = 2

/datum/experiment/scanning/points/machinery_tiered_scan/tier3_any
	name = "高级零部件基准值"
	description = "我们新设计的机械部件需要进行实际应用测试，以获取进一步改进的线索，同时也要确认我们没有设计出更差的部件。扫描任何装有高级部件的机械并报告结果。"
	required_points = 6
	required_atoms = list(
		/obj/machinery = 1
	)
	required_tier = 3
