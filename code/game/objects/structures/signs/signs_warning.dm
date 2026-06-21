//warning signs


///////DANGEROUS THINGS

/obj/structure/sign/warning
	name = "\improper 警示标识"
	sign_change_name = "Warning"
	desc = "一个警示标识"
	icon_state = "securearea"
	is_editable = TRUE

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/warning, 32)
MAPPING_DIAGONAL_HELPERS(/obj/structure/sign/warning, 32)

/obj/structure/sign/warning/secure_area
	name = "\improper 管制区标识"
	sign_change_name = "Warning - Secure Area"
	desc = "一个写着'管制区'的警示标"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/warning/secure_area, 32)
MAPPING_DIAGONAL_HELPERS(/obj/structure/sign/warning/secure_area, 32)

/obj/structure/sign/warning/docking
	name = "\improper 请勿靠近: 停靠区 标识"
	sign_change_name = "Warning - Docking Area"
	desc = "一个写着'远离停靠区'的警示标"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/warning/docking, 32)

/obj/structure/sign/warning/biohazard
	name = "\improper 生物危害 标识"
	sign_change_name = "Warning - Biohazard"
	desc = "A warning sign which reads 'BIOHAZARD'."
	icon_state = "bio"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/warning/biohazard, 32)

/obj/structure/sign/warning/electric_shock
	name = "\improper 高压电 标识"
	sign_change_name = "Warning - High Voltage"
	desc = "一个写着'高压电'的警示标"
	icon_state = "shock"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/warning/electric_shock, 32)

/obj/structure/sign/warning/vacuum
	name = "\improper 前方真空 标识"
	sign_change_name = "Warning - Hard Vacuum"
	desc = "一个写着'前方真空'的警示标"
	icon_state = "space"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/warning/vacuum, 32)

/obj/structure/sign/warning/vacuum/external
	name = "\improper 外闸门标识"
	sign_change_name = "Warning - External Airlock"
	desc = "一个写着'外气闸'的警示标"
	layer = MOB_LAYER

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/warning/vacuum/external, 32)

/obj/structure/sign/warning/deathsposal
	name = "\improper 处理: 通向太空 标识"
	sign_change_name = "Warning - Disposals: Leads to Space"
	desc = "一个写着'处理: 通向太空'的警示标"
	icon_state = "deathsposal"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/warning/deathsposal, 32)

/obj/structure/sign/warning/bodysposal
	name = "\improper 处理: 通向太平间 标识"
	sign_change_name = "Warning - Disposals: Leads to Morgue"
	desc = "一个写着'处理: 通向太平间'的警示标"
	icon_state = "bodysposal"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/warning/bodysposal, 32)

/obj/structure/sign/warning/fire
	name = "\improper 高火灾风险 标识"
	sign_change_name = "Warning - Fire Hazard"
	desc = "一个写着'高火灾风险'的警示标"
	icon_state = "fire"
	resistance_flags = FIRE_PROOF

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/warning/fire, 32)

/obj/structure/sign/warning/no_smoking
	name = "\improper 禁烟区 标识"
	sign_change_name = "Warning - No Smoking"
	desc = "一个写着‘禁烟’的警示标"
	icon_state = "nosmoking2"
	resistance_flags = FLAMMABLE

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/warning/no_smoking, 32)

/obj/structure/sign/warning/no_smoking/circle
	name = "\improper 禁止吸烟标志"
	sign_change_name = "Warning - No Smoking Alt"
	desc = "A warning sign which reads 'NO SMOKING'."
	icon_state = "nosmoking"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/warning/no_smoking/circle, 32)

/obj/structure/sign/warning/yes_smoking/circle
	name = "\improper 吸烟区 标识"
	sign_change_name = "Warning - Yes Smoking"
	desc = "一个写着'吸烟区'的警示标"
	icon_state = "yessmoking"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/warning/yes_smoking/circle, 32)

/obj/structure/sign/warning/radiation
	name = "\improper 有害辐射 标识"
	sign_change_name = "Warning - Radiation"
	desc = "一个警示路人潜在的辐射危害的警示标"
	icon_state = "radiation"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/warning/radiation, 32)

/obj/structure/sign/warning/radiation/rad_area
	name = "\improper 放射性沾染区 标识"
	sign_change_name = "Warning - Radioactive Area"
	desc = "一个写着‘放射性区域’的警示标"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/warning/radiation/rad_area, 32)

/obj/structure/sign/warning/xeno_mining
	name = "\improper 危险异星生物 标识"
	sign_change_name = "Warning - Xenos"
	desc = "警告标志：警告旅行者附近可能会遭遇敌对外星生命。"
	icon = 'icons/obj/signs.dmi'
	icon_state = "xeno_warning"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/warning/xeno_mining, 32)

/obj/structure/sign/warning/engine_safety
	name = "\improper 工程安全警告标识"
	sign_change_name = "Warning - Engineering Safety Protocols"
	desc = "一块详细说明了站上工作的安全规范的标识牌，以确保轮班安全。"
	icon_state = "safety"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/warning/engine_safety, 32)

/obj/structure/sign/warning/explosives
	name = "\improper 高爆炸风险 标识"
	sign_change_name = "Warning - Explosives"
	desc = "一个写着‘高爆炸性’的警示标"
	icon_state = "explosives"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/warning/explosives, 32)

/obj/structure/sign/warning/explosives/alt
	name = "\improper 高爆炸物标志"
	sign_change_name = "Warning - Explosives Alt"
	desc = "A warning sign which reads 'HIGH EXPLOSIVES'."
	icon_state = "explosives2"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/warning/explosives/alt, 32)

/obj/structure/sign/warning/test_chamber
	name = "\improper 试验区 标识"
	sign_change_name = "Warning - Testing Area"
	desc = "警告标志：附近存在高能量的测试装置。"
	icon_state = "testchamber"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/warning/test_chamber, 32)

/obj/structure/sign/warning/firing_range
	name = "\improper 射击场 标识"
	sign_change_name = "Warning - Firing Range"
	desc = "警告标志：记得站在射击线后方以及佩戴耳部保护装置。"
	icon_state = "firingrange"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/warning/firing_range, 32)

/obj/structure/sign/warning/cold_temp
	name = "\improper 冷空气 标识"
	sign_change_name = "Warning - Temp: Cold"
	desc = "警告标志：附近有极端低温气体。"
	icon_state = "cold"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/warning/cold_temp, 32)

/obj/structure/sign/warning/hot_temp
	name = "\improper 过热气体 标识"
	sign_change_name = "Warning - Temp: Hot"
	desc = "警告标志：附近有极端高温气体。"
	icon_state = "heat"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/warning/hot_temp, 32)

/obj/structure/sign/warning/gas_mask
	name = "\improper 污染空气 标识"
	sign_change_name = "Warning - Contaminated Air"
	desc = "警告标志：空气中有危险成分，指示你佩戴防护设备。"
	icon_state = "gasmask"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/warning/gas_mask, 32)

/obj/structure/sign/warning/chem_diamond
	name = "\improper 反应性化学品 标识"
	sign_change_name = "Warning - Hazardous Chemicals sign"
	desc = "一个警告附近可能存在反应性化学品的标志，无论是易爆、易燃还是酸性物质。"
	icon_state = "chemdiamond"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/warning/chem_diamond, 32)

/obj/structure/sign/warning/doors
	name = "\improper 防爆门标识牌"
	sign_change_name = "Warning - Blast Doors"
	desc = "一个指示这里有门的标志。到处都是门！"
	icon_state = "doors"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/warning/doors, 32)

////MISC LOCATIONS

/obj/structure/sign/warning/pods
	name = "\improper 逃生舱标识"
	sign_change_name = "Location - Escape Pods"
	desc = "一个写着'撤离仓'的警示标"
	icon_state = "pods"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/warning/pods, 32)

/obj/structure/sign/warning/rad_shelter
	name = "\improper 辐射风暴庇护所标识"
	sign_change_name = "Location - Radstorm Shelter"
	desc = "一个写着'辐射风暴庇护所'的警示标"
	icon_state = "radshelter"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/warning/rad_shelter, 32)
