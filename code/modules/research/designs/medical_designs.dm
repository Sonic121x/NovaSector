/////////////////////////////////////////
////////////Medical Tools////////////////
/////////////////////////////////////////

/datum/design/healthanalyzer
	name = "Health Analyzer"
	id = "healthanalyzer"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*5, /datum/material/glass =SMALL_MATERIAL_AMOUNT*0.5)
	build_path = /obj/item/healthanalyzer
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/autopsy_scanner
	name = "Autopsy Scanner"
	id = "autopsyscanner"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT*5, /datum/material/glass = SMALL_MATERIAL_AMOUNT)
	build_path = /obj/item/autopsy_scanner
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/bluespacebeaker
	name = "Bluespace Beaker"
	desc = "蓝空烧杯，由蓝空实验技术与复合材料结合而成。最多可容纳300u。"
	id = "bluespacebeaker"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/glass =SHEET_MATERIAL_AMOUNT * 2.5, /datum/material/plastic =SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/diamond =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/bluespace =HALF_SHEET_MATERIAL_AMOUNT)
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_CHEMISTRY
	)
	build_path = /obj/item/reagent_containers/cup/beaker/bluespace
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/noreactbeaker
	name = "Cryostasis Beaker"
	desc = "一个低温存储烧杯，可实现无化学反应的化学物质储存。最大容量为50单位。"
	id = "splitbeaker"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT * 1.5)
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_CHEMISTRY
	)
	build_path = /obj/item/reagent_containers/cup/beaker/noreact
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/xlarge_beaker
	name = "X-large Beaker"
	id = "xlarge_beaker"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT*2.5, /datum/material/plastic =SHEET_MATERIAL_AMOUNT * 1.5)
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_CHEMISTRY
	)
	build_path = /obj/item/reagent_containers/cup/beaker/plastic
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/organ_jar
	name = "Organ Jar"
	id = "organ_jar"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT*2.5, /datum/material/plastic =SHEET_MATERIAL_AMOUNT * 1.5)
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_CHEMISTRY
	)
	build_path = /obj/item/reagent_containers/cup/beaker/organ_jar
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/meta_beaker
	name = "超材料烧杯-Beaker"
	id = "meta_beaker"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT*2.5, /datum/material/plastic =SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/gold =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/titanium =HALF_SHEET_MATERIAL_AMOUNT)
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_CHEMISTRY
	)
	build_path = /obj/item/reagent_containers/cup/beaker/meta
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/ph_meter
	name = "Chemical Analyzer"
	id = "ph_meter"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT*2.5, /datum/material/gold =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/titanium =HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/ph_meter
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_CHEMISTRY
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/bluespacesyringe
	name = "蓝空注射器-Syringe"
	desc = "一支可容纳60单位化学品的高级注射器。"
	id = "bluespacesyringe"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/glass =SHEET_MATERIAL_AMOUNT, /datum/material/plasma =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/diamond =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/bluespace =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/reagent_containers/syringe/bluespace
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_CHEMISTRY
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/dna_disk
	name = "Genetic Data Disk"
	desc = "生产用于存储遗传学数据的额外磁盘。"
	id = "dna_disk"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT * 3, /datum/material/glass =SMALL_MATERIAL_AMOUNT, /datum/material/silver =SMALL_MATERIAL_AMOUNT*0.5)
	build_path = /obj/item/disk/data
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_GENETICS
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/piercesyringe
	name = "穿刺型注射器-Syringe"
	desc = "一种带有金刚石尖头的注射器，发射时能够穿透盔甲。它最多可容纳 10 个u的药物。"
	id = "piercesyringe"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/glass =SHEET_MATERIAL_AMOUNT, /datum/material/diamond =HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/reagent_containers/syringe/piercing
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_CHEMISTRY
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/inhaler
	name = "Inhaler"
	desc = "A small device capable of administering short bursts of aerosolized chemicals. Requires a canister to function."
	id = "inhaler"
	build_path = /obj/item/inhaler/medical
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/plastic = SHEET_MATERIAL_AMOUNT * 0.1)
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/inhaler_canister
	name = "Inhaler Canister"
	desc = "A small canister filled with aerosolized reagents for use in a inhaler."
	id = "inhaler_canister"
	build_path = /obj/item/reagent_containers/inhaler_canister
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 0.2)
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/bluespacebodybag
	name = "蓝空裹尸袋-Body Bag"
	desc = "蓝空裹尸袋，由蓝空实验技术驱动。它可以容纳大量的尸体和最大的生物。"
	id = "bluespacebodybag"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/plasma =SHEET_MATERIAL_AMOUNT, /datum/material/diamond =SMALL_MATERIAL_AMOUNT*5, /datum/material/bluespace =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/bodybag/bluespace
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/stasis_bag
	name = "Stasis Body Bag"
	desc = "A disposal bodybag designed to stabilize patients in the field in critical condition. \
		The bag itself cannot maintain stasis for long, and will eventually fall apart."
	id = "stasis_bodybag"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/plastic = 10 * SHEET_MATERIAL_AMOUNT, // Very plastic expensive (but only because cloth cannot be put in the lathe)
		/datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/bodybag/stasis
	category = list(RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MEDICAL)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/plasmarefiller
	name = "等离子人灭火服补充包"
	desc = "等离子人服装上的自动灭火器的补充包。"
	id = "plasmarefiller" //Why did this have no plasmatech
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*2, /datum/material/plasma =HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/extinguisher_refill
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_GAS_TANKS_EQUIPMENT
	)
	departmental_flags = ALL

/datum/design/crewpinpointer
	name = "Crew Pinpointer"
	desc = "如果某人的服装上的传感器被设置为追踪模式，就能对其进行位置追踪。"
	id = "crewpinpointer"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/gold =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/pinpointer/crew
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/defibrillator_mount
	name = "壁挂式除颤器"
	desc = "放置除颤器的安装框架，提供简单的安全性。"
	id = "defibmountdefault"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT, /datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/wallframe/defib_mount
	category = list(
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MOUNTS
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/defibrillator_mount_charging
	name = "PENLITE型壁挂式除颤器"
	desc = "一款一体化的安装支架，用于固定除颤器，配有带锁扣的夹子和充电线。PENLITE版本还支持除颤器电池的缓慢充电。"
	id = "defibmount"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT, /datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/silver =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/wallframe/defib_mount/charging
	category = list(
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MOUNTS
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/genescanner
	name = "Genetic Sequence Analyzer"
	desc = "一种便捷的手持式分析仪，可快速检测突变并获取完整的序列信息。"
	id = "genescanner"
	build_path = /obj/item/sequence_scanner
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/glass =SMALL_MATERIAL_AMOUNT*5)
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_GENETICS
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/healthanalyzer_advanced
	name = "Advanced Health Analyzer"
	desc = "一种手持式身体扫描仪，能够高精度地分析受试者的生命体征。"
	id = "healthanalyzer_advanced"
	build_path = /obj/item/healthanalyzer/advanced
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT * 2.5, /datum/material/glass = SHEET_MATERIAL_AMOUNT*1.25, /datum/material/silver =SHEET_MATERIAL_AMOUNT, /datum/material/gold =HALF_SHEET_MATERIAL_AMOUNT * 1.5)
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL_ADVANCED
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/medigel
	name = "Medical Gel"
	desc = "一款医用凝胶涂抹瓶，设计用于精准施药，配有可旋开的瓶盖。"
	id = "medigel"
	build_path = /obj/item/reagent_containers/medigel
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*1.25, /datum/material/glass =SMALL_MATERIAL_AMOUNT*5)
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/surgical_drapes
	name = "Surgical Drapes"
	id = "surgical_drapes"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/plastic =SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/surgical_drapes
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design/laserscalpel
	name = "Laser Scalpel"
	desc = "一种精确切割的激光手术刀"
	id = "laserscalpel"
	build_path = /obj/item/scalpel/advanced
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*3, /datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/silver =SHEET_MATERIAL_AMOUNT, /datum/material/gold =HALF_SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/diamond =SMALL_MATERIAL_AMOUNT * 2, /datum/material/titanium = SHEET_MATERIAL_AMOUNT*2)
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL_ADVANCED
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/mechanicalpinches
	name = "Mechanical Pinches"
	desc = "这些夹子既可以作为牵开器使用，也可以作为止血器使用。"
	id = "mechanicalpinches"
	build_path = /obj/item/retractor/advanced
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*6, /datum/material/glass = SHEET_MATERIAL_AMOUNT*2, /datum/material/silver = SHEET_MATERIAL_AMOUNT*2, /datum/material/titanium =SHEET_MATERIAL_AMOUNT * 2.5)
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL_ADVANCED
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/searingtool
	name = "Searing Tool"
	desc = "用于将组织缝合在一起。或者用于将组织钻除掉。"
	id = "searingtool"
	build_path = /obj/item/cautery/advanced
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*2, /datum/material/glass =SHEET_MATERIAL_AMOUNT, /datum/material/plasma =SHEET_MATERIAL_AMOUNT, /datum/material/uranium =SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/titanium =SHEET_MATERIAL_AMOUNT * 1.5)
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL_ADVANCED
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/medical_spray_bottle
	name = "Medical Spray Bottle"
	desc = "一种传统的喷雾瓶，用于产生细小的雾状物。请勿将其与药物喷雾混淆。"
	id = "med_spray_bottle"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/plastic =SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/reagent_containers/spray/medical
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/chem_pack
	name = "Intravenous Medicine Bag"
	desc = "一种用于静脉给药的塑料压力袋。"
	id = "chem_pack"
	build_type = PROTOLATHE | AWAY_LATHE
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL
	materials = list(/datum/material/plastic =SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/reagent_containers/chem_pack
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/blood_pack
	name = "Blood Pack"
	desc = "用于盛装用于输血的血液。必须与静脉输液装置相连。"
	id = "blood_pack"
	build_type = PROTOLATHE | AWAY_LATHE
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL
	materials = list(/datum/material/plastic =HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/reagent_containers/blood
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/portable_chem_mixer
	name = "便携式化学混合器"
	desc = "一种可携带的化学品调配与混合装置。需使用烧杯供应试剂。"
	id = "portable_chem_mixer"
	build_type = PROTOLATHE | AWAY_LATHE
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL
	materials = list(/datum/material/plastic =SHEET_MATERIAL_AMOUNT * 2.5, /datum/material/iron = SHEET_MATERIAL_AMOUNT*5, /datum/material/glass =SHEET_MATERIAL_AMOUNT * 1.5)
	build_path = /obj/item/storage/portable_chem_mixer
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_CHEMISTRY
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/medical_bed
	name = "Medical Bed"
	desc = "A bed made of sterile materials ideal for use in the medical field. Patient assistance or joyriding, it'll do it all!"
	id = "medicalbed"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/titanium = SHEET_MATERIAL_AMOUNT * 2.7, /datum/material/plastic = SHEET_MATERIAL_AMOUNT * 1.7)
	build_path = /obj/structure/bed/medical
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/emergency_bed
	name = "Medical Bed (Emergency)"
	desc = "A portable, foldable version of the medical bed. Perfect for paramedics or whenever you have mass casualties!"
	id = "medicalbed_emergency"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/titanium = SHEET_MATERIAL_AMOUNT * 2.7, /datum/material/plastic = SHEET_MATERIAL_AMOUNT * 1.7)
	build_path = /obj/item/emergency_bed
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/penlight
	name = "Penlight"
	id = "penlight"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*5, /datum/material/glass =SMALL_MATERIAL_AMOUNT*0.5)
	build_path = /obj/item/flashlight/pen
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/penlight_paramedic
	name = "Paramedic Penlight"
	id = "penlight_paramedic"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*5, /datum/material/glass =SMALL_MATERIAL_AMOUNT*1)
	build_path = /obj/item/flashlight/pen/paramedic
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/flesh_reshapers
	name = "Flesh Reshaper"
	desc = "Reshape those external features!"
	id = "fleshreshaper"
	build_path = /obj/item/flesh_shears
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 1, /datum/material/silver =SHEET_MATERIAL_AMOUNT * 1)
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL_ADVANCED
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/flesh_reshapers/medical // slight variant with different color palette
	name = "Medical Flesh Reshaper"
	id = "fleshreshapermed"
	build_path = /obj/item/flesh_shears/medical
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/////////////////////////////////////////
//////////Cybernetic Implants////////////
/////////////////////////////////////////

/datum/design/cyberimp_breather
	name = "Breathing Tube Implant"
	desc = "这个简单的植入物在你的背部添加了一个呼吸配件连接器，可以让你在没有佩戴面罩的情况下使用呼吸配件并防止你窒息。"
	id = "ci-breather"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 3.5 SECONDS
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT*6, /datum/material/glass = SMALL_MATERIAL_AMOUNT*2.5)
	build_path = /obj/item/organ/cyberimp/mouth/breathing_tube
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_HEALTH
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cyberimp_surgical
	name = "Surgical Arm Implant"
	desc = "一套手术用具，收纳于使用者手臂上的隐蔽嵌板。"
	id = "ci-surgery"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 1.25,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT * 1.5,
		/datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT * 1.5,
	)
	construction_time = 2 SECONDS
	build_path = /obj/item/organ/cyberimp/arm/toolkit/surgery
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_UTILITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cyberimp_toolset
	name = "Toolset Arm Implant"
	desc = "一套精简版的工程赛博工具组，可安装在对象的手臂上。"
	id = "ci-toolset"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 1.25,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT * 1.5,
		/datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT * 1.5,
	)
	construction_time = 2 SECONDS
	build_path = /obj/item/organ/cyberimp/arm/toolkit/toolset
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_UTILITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cyberimp_medical_hud
	name = "Medical HUD Implant"
	desc = "这对电子眼会在你视野内的一切活物上显示医疗HUD.转动眼球来控制."
	id = "ci-medhud"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 5 SECONDS
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/silver =SMALL_MATERIAL_AMOUNT*5,
		/datum/material/gold =SMALL_MATERIAL_AMOUNT*5,
	)
	build_path = /obj/item/organ/cyberimp/eyes/hud/medical
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_UTILITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cyberimp_security_hud
	name = "Security HUD Implant"
	desc = "这对电子眼会在你视野内的一切东西上显示安保HUD.转动眼球来控制."
	id = "ci-sechud"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 5 SECONDS
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT*7.5,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT*7.5,
	)
	build_path = /obj/item/organ/cyberimp/eyes/hud/security
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_UTILITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cyberimp_diagnostic_hud
	name = "Diagnostic HUD Implant"
	desc = "这对电子眼会在你视野内的一切活物上显示诊断HUD.转动眼球来控制."
	id = "ci-diaghud"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 5 SECONDS
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT*6,
	)
	build_path = /obj/item/organ/cyberimp/eyes/hud/diagnostic
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_UTILITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cyberimp_xray
	name = "X-ray Eyes"
	desc = "这对电子眼球会带给你X射线视觉.眨眼变得毫无意义."
	id = "ci-xray"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 6 SECONDS
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/plasma = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/uranium = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/diamond = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/bluespace = HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/organ/eyes/robotic/xray
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_COMBAT
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cyberimp_xray/moth
	name = "Moth X-ray Eyes"
	id = "ci-xray-moth"
	build_path = /obj/item/organ/eyes/robotic/xray/moth

/datum/design/cyberimp_thermals
	name = "Thermal Eyes"
	desc = "这对电子眼球会带给你热视觉.带有缝状竖瞳."
	id = "ci-thermals"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 6 SECONDS
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/plasma =HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/diamond =SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/organ/eyes/robotic/thermals
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_COMBAT
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cyberimp_thermals/moth
	name = "Moth Thermal Eyes"
	id = "ci-thermals-moth"
	build_path = /obj/item/organ/eyes/robotic/thermals/moth

/datum/design/cyberimp_tacvisor
	name = "Tactical IFF Visor"
	desc = "A sick IFF visor with an inbuilt LED display. May critically overload the user's prefrontal cortex."
	id = "ci-tacvisor"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 6 SECONDS
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT * 4,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT * 4,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT * 4,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT * 6,
		/datum/material/plasma = HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/organ/eyes/robotic/tacvisor
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_COMBAT
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cyberimp_antidrop
	name = "Anti-Drop-防掉落植入物"
	desc = "这个脑部电子植入物能够让你的手部肌肉强制收缩，以防止物品从手中掉落。抽动耳朵来切换。"
	id = "ci-antidrop"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 6 SECONDS
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT*4,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT*4,
	)
	build_path = /obj/item/organ/cyberimp/brain/anti_drop
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_COMBAT
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cyberimp_antistun
	name = "CNS Rebooter Implant"
	desc = "这个植入物将自动恢复你对中枢神经系统的控制，减少晕眩的恢复时间。"
	id = "ci-antistun"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 6 SECONDS
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/silver =SMALL_MATERIAL_AMOUNT*5,
		/datum/material/gold =HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/organ/cyberimp/brain/anti_stun
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_COMBAT
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cyberimp_herculean
	name = "Herculean Gravitronic Spinal Implant"
	desc = "This gravitronic spinal interface allows the user to reduce the impact of gravity on their body, effectively improving athletic performance."
	id = "ci-herculean"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 4 SECONDS
	materials = list(
		/datum/material/iron =SMALL_MATERIAL_AMOUNT*5,
		/datum/material/titanium=SMALL_MATERIAL_AMOUNT*3,
		/datum/material/gold=SMALL_MATERIAL_AMOUNT*3,
		/datum/material/diamond =SMALL_MATERIAL_AMOUNT*5,
	)
	build_path = /obj/item/organ/cyberimp/chest/spine
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_HEALTH
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cyberimp_connector
	name = "CNS Skillchip Connector Implant"
	desc = "This cybernetic adds a port to the back of your head, where you can remove or add skillchips at will."
	id = "ci-connector"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 6 SECONDS
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/titanium = SMALL_MATERIAL_AMOUNT*3,
	)
	build_path = /obj/item/organ/cyberimp/brain/connector
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_MISC
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cyberimp_nutriment
	name = "Nutriment Pump Implant"
	desc = "This implant will synthesize and pump into your bloodstream a small amount of nutriment when you are starving."
	id = "ci-nutriment"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 4 SECONDS
	materials = list(
		/datum/material/iron =SMALL_MATERIAL_AMOUNT*5,
		/datum/material/glass =SMALL_MATERIAL_AMOUNT*5,
		/datum/material/gold =SMALL_MATERIAL_AMOUNT*5,
	)
	build_path = /obj/item/organ/cyberimp/chest/nutriment
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_HEALTH
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cyberimp_nutriment_plus
	name = "Nutriment Pump Implant PLUS"
	desc = "This implant will synthesize and pump into your bloodstream a small amount of nutriment when you are hungry."
	id = "ci-nutrimentplus"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 5 SECONDS
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT*6,
		/datum/material/gold =SMALL_MATERIAL_AMOUNT*5,
		/datum/material/uranium = SMALL_MATERIAL_AMOUNT*7.5,
	)
	build_path = /obj/item/organ/cyberimp/chest/nutriment/plus
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_HEALTH
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cyberimp_reviver
	name = "Reviver Implant"
	desc = "这个植入物在你失去意识时会尝试唤醒你。适合那些胆小的人！"
	id = "ci-reviver"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 6 SECONDS
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT*8,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT*8,
		/datum/material/gold =SMALL_MATERIAL_AMOUNT * 3,
		/datum/material/uranium =SMALL_MATERIAL_AMOUNT*5,
	)
	build_path = /obj/item/organ/cyberimp/chest/reviver
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_HEALTH
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cyberimp_thrusters
	name = "Thrusters Set Implant"
	desc = "这个植入物可以让你在零重力条件下使用环境气体或呼吸配件内的气体来推进。"
	id = "ci-thrusters"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 8 SECONDS
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT*2,
		/datum/material/glass =SHEET_MATERIAL_AMOUNT,
		/datum/material/silver =HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/diamond =HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/organ/cyberimp/chest/thrusters
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_UTILITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cyberimp_surgery_brain
	name = "Surgical Processor Implant"
	desc = "A cybernetic brain implant that provides access to advanced surgeries."
	id = "ci-surgery-brain"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 4 SECONDS
	materials = list(
		/datum/material/titanium = SHEET_MATERIAL_AMOUNT * 0.25,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 0.5,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT * 0.75,
	)
	build_path = /obj/item/organ/cyberimp/brain/surgical_processor
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_UTILITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/////////////////////////////////////////
////////////Regular Implants/////////////
/////////////////////////////////////////

/datum/design/implanter
	name = "植入器"
	desc = "一个无菌自动植入物注射器。"
	id = "implanter"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT*6, /datum/material/glass =SMALL_MATERIAL_AMOUNT * 2)
	build_path = /obj/item/implanter
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_TOOLS
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_MEDICAL

/datum/design/implantcase
	name = "植入物盒"
	desc = "一个用来装植入物的玻璃盒。"
	id = "implantcase"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/glass =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/implantcase
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_TOOLS
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_MEDICAL

/datum/design/implant_sadtrombone
	name = "悲伤长号植入物盒"
	desc = "令死亡也能引人发笑。"
	id = "implant_trombone"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/glass =SMALL_MATERIAL_AMOUNT*5, /datum/material/bananium =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/implantcase/sad_trombone
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_HEALTH
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/implant_chem
	name = "化合物植入物盒"
	desc = "A glass case containing a chemical implant."
	id = "implant_chem"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/glass = SMALL_MATERIAL_AMOUNT * 7)
	build_path = /obj/item/implantcase/chem
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_MEDICAL

/datum/design/implant_tracking
	name = "跟踪植入物盒"
	desc = "A glass case containing a tracking implant."
	id = "implant_tracking"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 5, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 5)
	build_path = /obj/item/implantcase/tracking
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_MEDICAL

/datum/design/implant_beacon
	name = "Beacon Implant Case"
	desc = "A glass case containing a beacon implant."
	id = "implant_beacon"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 5, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 5, /datum/material/bluespace = SMALL_MATERIAL_AMOUNT * 3)
	build_path = /obj/item/implantcase/beacon
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/implant_bluespace
	name = "Bluespace Grounding Implant Case"
	desc = "A glass case containing a teleport blocker implant."
	id = "implant_bluespace"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 5, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 5, /datum/material/bluespace = SMALL_MATERIAL_AMOUNT * 3)
	build_path = /obj/item/implantcase/teleport_blocker
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/implant_exile
	name = "Exile Implant Case"
	desc = "A glass case containing an exile implant."
	id = "implant_exile"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 5, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 5, /datum/material/titanium = SMALL_MATERIAL_AMOUNT * 3)
	build_path = /obj/item/implantcase/exile
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

//Cybernetic organs

/datum/design/cybernetic_liver
	name = "Basic Cybernetic Liver"
	desc = "一块初级电子肝。"
	id = "cybernetic_liver"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 4 SECONDS
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*5, /datum/material/glass =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/organ/liver/cybernetic
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_1
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cybernetic_liver/tier2
	name = "Cybernetic Liver"
	desc = "一块电子肝"
	id = "cybernetic_liver_tier2"
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*5, /datum/material/glass =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/organ/liver/cybernetic/tier2
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_2
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cybernetic_liver/tier3
	name = "Upgraded Cybernetic Liver"
	desc = "一块升级的电子肝脏"
	id = "cybernetic_liver_tier3"
	construction_time = 5 SECONDS
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*5, /datum/material/glass =SMALL_MATERIAL_AMOUNT*5, /datum/material/silver=SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/organ/liver/cybernetic/tier3
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_3
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cybernetic_heart
	name = "Basic Cybernetic Heart"
	desc = "一颗初级电子心"
	id = "cybernetic_heart"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 4 SECONDS
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*5, /datum/material/glass =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/organ/heart/cybernetic
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_1
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cybernetic_heart/tier2
	name = "Cybernetic Heart"
	desc = "一颗电子心"
	id = "cybernetic_heart_tier2"
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*5, /datum/material/glass =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/organ/heart/cybernetic/tier2
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_2
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cybernetic_heart/tier3
	name = "Upgraded Cybernetic Heart"
	desc = "一块升级的电子心脏"
	id = "cybernetic_heart_tier3"
	construction_time = 5 SECONDS
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*5, /datum/material/glass =SMALL_MATERIAL_AMOUNT*5, /datum/material/silver=SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/organ/heart/cybernetic/tier3
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_3
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cybernetic_heart/anomalock
	name = "Voltaic combat cyberheart"
	desc = "A cutting-edge cyberheart, originally designed for Nanotrasen killsquad usage but later declassified for normal research. Voltaic technology allows the heart to keep the body upright in dire circumstances, alongside redirecting anomalous flux energy to fully shield the user from shocks and electro-magnetic pulses. Does nothing without a flux anomaly core."
	id = "cybernetic_heart_anomalock"
	construction_time = 5 SECONDS
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT * 5,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT * 5,
		/datum/material/titanium = SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/diamond = SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/organ/heart/cybernetic/anomalock
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SCIENCE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/cybernetic_lungs
	name = "Basic Cybernetic Lungs"
	desc = "一对基础电子肺"
	id = "cybernetic_lungs"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 4 SECONDS
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*5, /datum/material/glass =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/organ/lungs/cybernetic
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_1
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cybernetic_lungs/tier2
	name = "Cybernetic Lungs"
	desc = "一对电子肺"
	id = "cybernetic_lungs_tier2"
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*5, /datum/material/glass =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/organ/lungs/cybernetic/tier2
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_2
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cybernetic_lungs/tier3
	name = "Upgraded Cybernetic Lungs"
	desc = "一对升级的电子肺"
	id = "cybernetic_lungs_tier3"
	construction_time = 5 SECONDS
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*5, /datum/material/glass =SMALL_MATERIAL_AMOUNT*5, /datum/material/silver =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/organ/lungs/cybernetic/tier3
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_3
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cybernetic_stomach
	name = "Basic Cybernetic Stomach"
	desc = "一块初级电子胃。"
	id = "cybernetic_stomach"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 4 SECONDS
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*5, /datum/material/glass =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/organ/stomach/cybernetic
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_1
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cybernetic_stomach/tier2
	name = "Cybernetic Stomach"
	desc = "一块电子胃。"
	id = "cybernetic_stomach_tier2"
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*5, /datum/material/glass =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/organ/stomach/cybernetic/tier2
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_2
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cybernetic_stomach/tier3
	name = "Upgraded Cybernetic Stomach"
	desc = "一个升级的电子胃"
	id = "cybernetic_stomach_tier3"
	construction_time = 5 SECONDS
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*5, /datum/material/glass =SMALL_MATERIAL_AMOUNT*5, /datum/material/silver =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/organ/stomach/cybernetic/tier3
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_3
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cybernetic_ears
	name = "Basic Cybernetic Ears"
	desc = "A Basic pair of cybernetic ears."
	id = "cybernetic_ears"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 3 SECONDS
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT*2.5, /datum/material/glass = SMALL_MATERIAL_AMOUNT*4)
	build_path = /obj/item/organ/ears/cybernetic
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_1
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cybernetic_ears_u
	name = "Cybernetic Ears"
	desc = "一对电子耳。"
	id = "cybernetic_ears_u"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 4 SECONDS
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT*5,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT*5,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT*5,
	)
	build_path = /obj/item/organ/ears/cybernetic/upgraded
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_2
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cybernetic_ears_whisper
	name = "Whisper-sensitive Cybernetic Ears"
	desc = "A pair of whisper-sensitive cybernetic ears."
	id = "cybernetic_ears_whisper"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 4 SECONDS
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT*5,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT*5,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT*5,
	)
	build_path = /obj/item/organ/ears/cybernetic/whisper
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_3
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cybernetic_ears_volume
	name = "Volume-adjusting Cybernetic Ears"
	desc = "A pair of volume-adjusting cybernetic ears"
	id = "cybernetic_ears_volume"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 4 SECONDS
	materials = list(
			/datum/material/iron = SMALL_MATERIAL_AMOUNT*5,
			/datum/material/glass = SMALL_MATERIAL_AMOUNT*5,
			/datum/material/silver = SMALL_MATERIAL_AMOUNT*5,
	)
	build_path = /obj/item/organ/ears/cybernetic/volume
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_3
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cybernetic_ears_xray
	name = "Wall-penetrating Cybernetic Ears"
	desc = "A pair of wall-penetrating cybernetic ears."
	id = "cybernetic_ears_xray"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 4 SECONDS
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT*5,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT*5,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT*5,
	)
	build_path = /obj/item/organ/ears/cybernetic/xray
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_3
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cybernetic_ears/cat
	name = "Basic Cybernetic Cat Ears"
	desc = "A basic pair of cybernetic cat ears"
	id = "cybernetic_ears_cat"
	build_path = /obj/item/organ/ears/cat/cybernetic

/datum/design/cybernetic_ears_u/cat
	name = "Cybernetic Cat Ears"
	desc = "A pair of cybernetic cat ears"
	id = "cybernetic_ears_u_cat"
	build_path = /obj/item/organ/ears/cat/cybernetic/upgraded

/datum/design/cybernetic_ears_whisper/cat
	name = "Whisper-sensitive Cybernetic Cat Ears"
	desc = "A pair of whisper-sensitive cybernetic cat ears"
	id = "cybernetic_ears_whisper_cat"
	build_path = /obj/item/organ/ears/cat/cybernetic/whisper

/datum/design/cybernetic_ears_volume/cat
	name = "Volume-adjusting Cybernetic Cat Ears"
	desc = "A pair of volume-adjusting cybernetic cat ears"
	id = "cybernetic_ears_volume_cat"
	build_path = /obj/item/organ/ears/cat/cybernetic/volume

/datum/design/cybernetic_ears_xray/cat
	name = "Wall-penetrating Cybernetic Cat Ears"
	desc = "A pair of wall-penetrating cybernetic cat ears"
	id = "cybernetic_ears_xray_cat"
	build_path = /obj/item/organ/ears/cat/cybernetic/xray

/datum/design/cybernetic_eyes
	name = "Basic Cybernetic Eyes"
	desc = "一对基础电子眼."
	id = "cybernetic_eyes"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 3 SECONDS
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT*2.5, /datum/material/glass = SMALL_MATERIAL_AMOUNT*4)
	build_path = /obj/item/organ/eyes/robotic/basic
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_1
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cybernetic_eyes/moth
	name = "Basic Cybernetic Moth Eyes"
	id = "cybernetic_eyes_moth"
	build_path = /obj/item/organ/eyes/robotic/basic/moth

/datum/design/cybernetic_eyes/improved
	name = "Cybernetic Eyes"
	desc = "一对电子眼."
	id = "cybernetic_eyes_improved"
	build_path = /obj/item/organ/eyes/robotic
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_2
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cybernetic_eyes/improved/moth
	name = "Cybernetic Moth Eyes"
	id = "cybernetic_eyes_improved_moth"
	build_path = /obj/item/organ/eyes/robotic/moth

/datum/design/cyberimp_welding
	name = "Welding Shield Eyes"
	desc = "这些反应式微型屏障会保护你的眼睛免受焊光和闪光弹的伤害，并且不会减弱你的视力."
	id = "ci-welding"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 4 SECONDS
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT*6, /datum/material/glass = SMALL_MATERIAL_AMOUNT*4)
	build_path = /obj/item/organ/eyes/robotic/shield
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_3
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cyberimp_welding/moth
	name = "Welding Shield Moth Eyes"
	id = "ci-welding-moth"
	build_path = /obj/item/organ/eyes/robotic/shield/moth

/datum/design/cyberimp_gloweyes
	name = "Luminescent Eyes"
	desc = "一对能发出多彩荧光的电子眼."
	id = "ci-gloweyes"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 4 SECONDS
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT*6, /datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/organ/eyes/robotic/glow
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_3
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cyberimp_gloweyes/moth
	name = "Luminescent Moth Eyes"
	id = "ci-gloweyes-moth"
	build_path = /obj/item/organ/eyes/robotic/glow/moth

/datum/design/medibot_upgrade
	name = "Medibot Upgrade"
	desc = "Automatically upgrades the effectiveness of all medibots linked to the research network."
	id = "medibot_upgrade"
	research_icon = 'icons/mob/silicon/aibots.dmi'
	research_icon_state = "medbot_generic_idle"
	/// Medibot healing starts at a 1x multiplier. For every tech researched, it goes up by this amount additively.
	var/additive_multiplier = 1

/datum/design/medibot_upgrade/tier_two
	id = "medibot_upgrade_two"
	research_icon_state = "medbot_adv_idle"

/datum/design/medibot_upgrade/tier_three
	id = "medibot_upgrade_three"
	research_icon_state = "medbot_adv_idle"

/datum/design/medibot_upgrade/tier_four
	id = "medibot_upgrade_four"
	research_icon_state = "medbot_bezerk_idle" // alien tech

/////////////////////
///Surgery Designs///
/////////////////////

/datum/design/surgery
	abstract_type = /datum/design/surgery
	id = DESIGN_ID_IGNORE
	name = null
	desc = null
	research_icon = 'icons/obj/medical/surgery_ui.dmi'
	research_icon_state = "surgery_any"
	/// Typepath of what operation this design unlocks
	var/datum/surgery_operation/surgery

/datum/design/surgery/New()
	. = ..()
	if(isnull(name))
		name = surgery::rnd_name || capitalize(surgery::name)
	if(isnull(desc))
		desc = surgery::rnd_desc || surgery::desc

/datum/design/surgery/lobotomy
	id = "surgery_lobotomy"
	surgery = /datum/surgery_operation/organ/lobotomy
	research_icon_state = "surgery_head"

/datum/design/surgery/lobotomy/mechanic
	id = "surgery_lobotomy_mechanic"
	surgery = /datum/surgery_operation/organ/lobotomy/mechanic

/datum/design/surgery/pacify
	id = "surgery_pacify"
	surgery = /datum/surgery_operation/organ/pacify
	research_icon_state = "surgery_head"

/datum/design/surgery/pacify/mechanic
	id = "surgery_pacify_mechanic"
	surgery = /datum/surgery_operation/organ/pacify/mechanic

/datum/design/surgery/viral_bonding
	id = "surgery_viral_bond"
	surgery = /datum/surgery_operation/basic/viral_bonding
	research_icon_state = "surgery_chest"

/datum/design/surgery/tend_wounds_upgrade
	name = "Tend Wounds Upgrade"
	desc = "Upgrade the efficiency of the individual tend wound operations."
	id = "surgery_heal_upgrade"
	surgery = /datum/surgery_operation/basic/tend_wounds/upgraded
	research_icon_state = "surgery_chest"

/datum/design/surgery/tend_wounds_upgrade/femto
	name = "Tend Wounds Upgrade"
	surgery = /datum/surgery_operation/basic/tend_wounds/upgraded/master
	id = "surgery_heal_upgrade_femto"

/datum/design/surgery/tend_wounds_combo
	name = "Tend Wounds Combo"
	desc = "An alternative wound treatment operation that treats both bruises and burns at the same time, albeit less effectively than their individual counterparts."
	surgery = /datum/surgery_operation/basic/tend_wounds/combo
	id = "surgery_heal_combo"
	research_icon_state = "surgery_chest"

/datum/design/surgery/tend_wounds_combo/upgrade
	name = "Tend Wounds Combo Upgrade"
	surgery = /datum/surgery_operation/basic/tend_wounds/combo/upgraded
	id = "surgery_heal_combo_upgrade"

/datum/design/surgery/tend_wounds_combo/upgrade/femto
	name = "Tend Wounds Combo Upgrade"
	desc = "The ultimate in wound treatment operations, treating both bruises and burns simultaneous and faster than their individual counterparts."
	surgery = /datum/surgery_operation/basic/tend_wounds/combo/upgraded/master
	id = "surgery_heal_combo_upgrade_femto"

/datum/design/surgery/brainwashing
	id = "surgery_brainwashing"
	surgery = /datum/surgery_operation/organ/brainwash
	research_icon_state = "surgery_head"

/datum/design/surgery/brainwashing/mechanic
	id = "surgery_brainwashing_mechanic"
	surgery = /datum/surgery_operation/organ/brainwash/mechanic

/datum/design/surgery/nerve_splicing
	desc = "一种将神经拼接起来的增强手术，使得躯体更能抵抗眩晕"
	id = "surgery_nerve_splice"
	surgery = /datum/surgery_operation/limb/bioware/nerve_splicing
	research_icon_state = "surgery_chest"

/datum/design/surgery/nerve_splicing/mechanic
	desc = "A robotic upgrade which upgrades a robotic patient's automatic systems, making them more resistant to stuns."
	id = "surgery_nerve_splice_mechanic"
	surgery = /datum/surgery_operation/limb/bioware/nerve_splicing/mechanic

/datum/design/surgery/nerve_grounding
	desc = "一种将神经充当为接地棒的增强手术，使得躯体免受电击"
	id = "surgery_nerve_ground"
	surgery = /datum/surgery_operation/limb/bioware/nerve_grounding
	research_icon_state = "surgery_chest"

/datum/design/surgery/nerve_grounding/mechanic
	desc = "A robotic upgrade which installs grounding rods into the robotic patient's system, protecting them from electrical shocks."
	id = "surgery_nerve_ground_mechanic"
	surgery = /datum/surgery_operation/limb/bioware/nerve_grounding/mechanic

/datum/design/surgery/vein_threading
	desc = "一种能大大减少伤口出血量的增强手术。"
	id = "surgery_vein_thread"
	surgery = /datum/surgery_operation/limb/bioware/vein_threading
	research_icon_state = "surgery_chest"

/datum/design/surgery/vein_threading/mechanic
	desc = "A robotic upgrade which severely reduces the amount of hydraulic fluid lost in case of injury."
	id = "surgery_vein_thread_mechanic"
	surgery = /datum/surgery_operation/limb/bioware/vein_threading/mechanic

/datum/design/surgery/muscled_veins
	desc = "A surgical procedure which adds a muscled membrane to blood vessels, allowing a patient to pump blood without a heart."
	id = "surgery_muscled_veins"
	surgery = /datum/surgery_operation/limb/bioware/muscled_veins
	research_icon_state = "surgery_chest"

/datum/design/surgery/muscled_veins/mechanic
	desc = "A robotic upgrade which adds sophisticated hydraulics redundancies, allowing a patient to pump hydraulic fluid without an engine."
	id = "surgery_muscled_veins_mechanic"
	surgery = /datum/surgery_operation/limb/bioware/muscled_veins/mechanic

/datum/design/surgery/ligament_hook
	desc = "A surgical procedure which reshapes the connections between torso and limbs, making it so limbs can be attached manually if severed. \
		However, this weakens the connection, making them easier to detach as well."
	id = "surgery_ligament_hook"
	surgery = /datum/surgery_operation/limb/bioware/ligament_hook
	research_icon_state = "surgery_chest"

/datum/design/surgery/ligament_hook/mechanic
	desc = "A robotic upgrade which installs rapid detachment anchor points, making it so limbs can be attached manually if detached. \
		However, this weakens the connection, making them easier to detach as well."
	id = "surgery_ligament_hook_mechanic"
	surgery = /datum/surgery_operation/limb/bioware/ligament_hook/mechanic

/datum/design/surgery/ligament_reinforcement
	desc = "A surgical procedure which adds a protective tissue and bone cage around the connections between the torso and limbs, preventing dismemberment. \
		However, the nerve connections as a result are more easily interrupted, making it easier to disable limbs with damage."
	id = "surgery_ligament_reinforcement"
	surgery = /datum/surgery_operation/limb/bioware/ligament_reinforcement
	research_icon_state = "surgery_chest"

/datum/design/surgery/ligament_reinforcement/mechanic
	desc = "A surgical procedure which adds reinforced limb anchor points to the patient's chassis, preventing dismemberment. \
		However, the nerve connections as a result are more easily interrupted, making it easier to disable limbs with damage."
	id = "surgery_ligament_reinforcement_mechanic"
	surgery = /datum/surgery_operation/limb/bioware/ligament_reinforcement/mechanic

/datum/design/surgery/cortex_imprint
	desc = "一种将大脑皮层改造为冗余神经模式的增强手术，使大脑能够避免较微脑损伤带来的不必要麻烦"
	id = "surgery_cortex_imprint"
	surgery = /datum/surgery_operation/limb/bioware/cortex_imprint
	research_icon_state = "surgery_head"

/datum/design/surgery/cortex_imprint/mechanic
	desc = "A surgical procedure which updates the patient's operating system to the 'latest version', whatever that means, making the brain able to bypass damage caused by minor brain traumas."
	id = "surgery_cortex_imprint_mechanic"
	surgery = /datum/surgery_operation/limb/bioware/cortex_imprint/mechanic

/datum/design/surgery/cortex_folding
	desc = "一种将大脑皮层折叠成复杂褶皱的增强手术，为非标准神经模式提供了更多空间"
	id = "surgery_cortex_folding"
	surgery = /datum/surgery_operation/limb/bioware/cortex_folding
	research_icon_state = "surgery_head"

/datum/design/surgery/cortex_folding/mechanic
	desc = "A robotic upgrade which reprograms the patient's neural network in a downright eldritch programming language, giving space to non-standard neural patterns."
	id = "surgery_cortex_folding_mechanic"
	surgery = /datum/surgery_operation/limb/bioware/cortex_folding/mechanic

/datum/design/surgery/necrotic_revival
	id = "surgery_zombie"
	surgery = /datum/surgery_operation/limb/bionecrosis
	research_icon_state = "surgery_head"

/datum/design/surgery/wing_reconstruction
	id = "surgery_wing_reconstruction"
	surgery = /datum/surgery_operation/organ/fix_wings
	research_icon_state = "surgery_chest"

/datum/design/surgery/experimental_dissection
	id = "surgery_oldstation_dissection"
	surgery = /datum/surgery_operation/basic/dissection
	research_icon_state = "surgery_chest"

/datum/design/vitals_monitor
	name = "Vitals Monitor"
	desc = "A wall mounted computer that displays the vitals of a patient nearby. \
		Links to stasis beds, operating tables, and other machines that can hold patients \
		such as cryo cells, sleepers, and more."
	id = "vitals_monitor"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 4,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/gold = HALF_SHEET_MATERIAL_AMOUNT * 0.5,
	)
	build_path = /obj/item/wallframe/status_display/vitals
	category = list(RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_MEDICAL)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/vitals_monitor/advanced
	name = "Advanced Vitals Monitor"
	desc = "An updated vitals display which performs a more detailed scan of the patient than the basic display."
	id = "vitals_monitor_advanced"
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 4,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/gold = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT * 0.5,
	)
	build_path = /obj/item/wallframe/status_display/vitals/advanced
