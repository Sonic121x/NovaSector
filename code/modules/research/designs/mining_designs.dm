
/////////////////////////////////////////
/////////////////Mining//////////////////
/////////////////////////////////////////
/datum/design/cargo_express
	name = "特快供应控制台电路板"//shes beautiful
	desc = "允许构建特快供应控制台的电路板。"//who?
	id = "cargoexpress"//the coder reading this
	build_type = IMPRINTER
	materials = list(/datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/circuitboard/computer/cargo/express
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_CARGO
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO

/datum/design/bluespace_pod
	name = "特快供应空投仓升级数据盘"
	desc = "使专用控制台能够召唤蓝空降落舱，显著提高了用户的安全性。"//who?
	id = "bluespace_pod"//the coder reading this
	build_type = PROTOLATHE
	materials = list(/datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/disk/cargo/bluespace_pod
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_CARGO
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO

/datum/design/pickaxe
	name = "十字镐"
	id = "pickaxe"
	build_type = PROTOLATHE | AWAY_LATHE | AUTOLATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/pickaxe
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MINING
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO

/datum/design/drill
	name = "采矿钻"
	desc = "你的钻头能钻穿岩壁。"
	id = "drill"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*3, /datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT) //expensive, but no need for miners.
	build_path = /obj/item/pickaxe/drill
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MINING
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO

/datum/design/drill_diamond
	name = "钻石尖采矿钻"
	desc = "你的钻头将突破天际！"
	id = "drill_diamond"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT*3,
		/datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/diamond =SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/pickaxe/drill/diamonddrill
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MINING
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO

/datum/design/plasmacutter
	name = "等离子切割机"
	desc = "你可以用它来切下异种的四肢！或者，你知道，就是我们的肢体。"
	id = "plasmacutter"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT * 1.5,
		/datum/material/glass =SMALL_MATERIAL_AMOUNT*5,
		/datum/material/plasma = SMALL_MATERIAL_AMOUNT*4,
	)
	build_path = /obj/item/gun/energy/plasmacutter
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MINING
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/plasmacutter_adv
	name = "高级等离子切割机"
	desc = "这是一台先进的等离子切割机，天啊。"
	id = "plasmacutter_adv"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron =SHEET_MATERIAL_AMOUNT * 1.5,
		/datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/plasma =SHEET_MATERIAL_AMOUNT,
		/datum/material/gold =SMALL_MATERIAL_AMOUNT*5,
	)
	build_path = /obj/item/gun/energy/plasmacutter/adv
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MINING
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO

/datum/design/jackhammer
	name = "声波手提钻"
	desc = "本质上是一个手持的行星破坏器。听到这些声音，岩壁会吓得缩成一团。"
	id = "jackhammer"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT*3,
		/datum/material/glass =SHEET_MATERIAL_AMOUNT,
		/datum/material/silver =SHEET_MATERIAL_AMOUNT,
		/datum/material/diamond = SHEET_MATERIAL_AMOUNT*3,
	)
	build_path = /obj/item/pickaxe/drill/jackhammer
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MINING
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO

/datum/design/superresonator
	name = "高级谐振器"
	desc = "谐振器的升级版，可以同时激活更多的电场。"
	id = "superresonator"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT*2,
		/datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT * 1.5,
		/datum/material/silver =HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/uranium =HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/resonator/upgraded
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MINING
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO

/datum/design/trigger_guard_mod
	name = "动能加速器扳机护环模块"
	desc = "一种使任何生物都能操纵动能加速器的装置。"
	id = "triggermod"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron =SHEET_MATERIAL_AMOUNT,
		/datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT * 1.5,
		/datum/material/gold =HALF_SHEET_MATERIAL_AMOUNT * 1.5,
		/datum/material/uranium =HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/borg/upgrade/modkit/trigger_guard
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_PKA_MODS
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO

/datum/design/damage_mod
	name = "动能加速器伤害提升模块"
	desc = "一个能让动能加速器造成更大伤害的装置。"
	id = "damagemod"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron =SHEET_MATERIAL_AMOUNT,
		/datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT * 1.5,
		/datum/material/gold =HALF_SHEET_MATERIAL_AMOUNT * 1.5,
		/datum/material/uranium =HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/borg/upgrade/modkit/damage
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_PKA_MODS
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO

/datum/design/damage_mod/borg
	id = "borg_upgrade_damagemod"
	build_type = MECHFAB
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_MINING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/cooldown_mod
	name = "动能加速器冷却时间减少模块"
	desc = "一个减少动能加速器冷却时间的装置。"
	id = "cooldownmod"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT, /datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/gold =HALF_SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/uranium =HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/borg/upgrade/modkit/cooldown
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_PKA_MODS
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO

/datum/design/cooldown_mod/borg
	id = "borg_upgrade_cooldownmod"
	build_type = MECHFAB
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_MINING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/range_mod
	name = "动能加速器射程模块"
	desc = "一种能让动能加速器在更远的范围内发射的装置。"
	id = "rangemod"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT, /datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/gold =HALF_SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/uranium =HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/borg/upgrade/modkit/range
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_PKA_MODS
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO

/datum/design/range_mod/borg
	id = "borg_upgrade_rangemod"
	build_type = MECHFAB
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_MINING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/hyperaccelerator
	name = "动能加速器范围采矿模块"
	desc = "一种动能加速器的改装套件，它可以发射范围爆炸波摧毁岩石。"
	id = "hypermod"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT*4,
		/datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT * 1.5,
		/datum/material/silver =SHEET_MATERIAL_AMOUNT,
		/datum/material/gold =SHEET_MATERIAL_AMOUNT,
		/datum/material/diamond =SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/borg/upgrade/modkit/cooldown/aoe/turfs
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_PKA_MODS
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO

/datum/design/hyperaccelerator/borg
	id = "borg_upgrade_hypermod"
	build_type = MECHFAB
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_MINING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/mining_scanner
	name = "采矿扫描仪"
	id = "mining_scanner"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/glass =SMALL_MATERIAL_AMOUNT*5,
		/datum/material/iron =SMALL_MATERIAL_AMOUNT*5,
		/datum/material/silver =HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/t_scanner/adv_mining_scanner/lesser
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MINING
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO

/datum/design/unique_modkit
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_PKA_MODS,
	)
	build_type = PROTOLATHE
	departmental_flags = DEPARTMENT_BITFLAG_CARGO

/datum/design/unique_modkit/offensive_turf_aoe
	name = "动能加速器攻击性采矿爆炸模组"
	desc = "一种使动能加速器发射范围性爆炸的装置，可摧毁岩石并伤害生物。"
	id = "hyperaoemod"
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*3.5, /datum/material/glass = SHEET_MATERIAL_AMOUNT*1.5, /datum/material/silver =SHEET_MATERIAL_AMOUNT*1.5, /datum/material/gold =SHEET_MATERIAL_AMOUNT*1.5, /datum/material/diamond = SHEET_MATERIAL_AMOUNT*2)
	build_path = /obj/item/borg/upgrade/modkit/cooldown/aoe/mobs/andturfs

/datum/design/unique_modkit/rapid_repeater
	name = "动能加速器快速连发模组"
	desc = "一种装置，能大幅减少动能加速器击中生物目标或岩石后的冷却时间，但会大幅增加其基础冷却时间。"
	id = "repeatermod"
	materials = list(/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT * 5, /datum/material/glass =SHEET_MATERIAL_AMOUNT * 2.5, /datum/material/uranium = SHEET_MATERIAL_AMOUNT*4, /datum/material/bluespace =SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/borg/upgrade/modkit/cooldown/repeater

/datum/design/unique_modkit/resonator_blast
	name = "动能加速器谐振器爆炸模组"
	desc = "一种使动能加速器发射能留下并引爆谐振器冲击波的射击的装置。"
	id = "resonatormod"
	materials = list(/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT*5, /datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT*5, /datum/material/silver =HALF_SHEET_MATERIAL_AMOUNT*5, /datum/material/uranium =SHEET_MATERIAL_AMOUNT * 2.5)
	build_path = /obj/item/borg/upgrade/modkit/resonator_blasts

/datum/design/unique_modkit/bounty
	name = "动能加速器死亡虹吸模组"
	desc = "一种使动能加速器能永久提升对用其击杀的生物类型伤害的装置。"
	id = "bountymod"
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*2, /datum/material/silver = SHEET_MATERIAL_AMOUNT*2, /datum/material/gold = SHEET_MATERIAL_AMOUNT*2, /datum/material/bluespace = SHEET_MATERIAL_AMOUNT*2)
	build_path = /obj/item/borg/upgrade/modkit/bounty
