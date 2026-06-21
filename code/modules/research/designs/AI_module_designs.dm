#define AI_MODULE_MATERIALS_COMMON list(/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT, /datum/material/gold = SHEET_MATERIAL_AMOUNT, /datum/material/bluespace = HALF_SHEET_MATERIAL_AMOUNT)
#define AI_MODULE_MATERIALS_UNUSUAL list(/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT, /datum/material/diamond = SHEET_MATERIAL_AMOUNT, /datum/material/bluespace = HALF_SHEET_MATERIAL_AMOUNT)

///////////////////////////////////
//////////AI Module Disks//////////
///////////////////////////////////

/datum/design/board/aicore
	name = "人工智能核心电路板"
	desc = "允许制造人工智能核心的电路板。"
	id = "aicore"
	build_path = /obj/item/circuitboard/aicore
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_CORE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/safeguard_module
	name = "保护措施模块"
	desc = "允许构建一个保护措施人工智能模块。"
	id = "safeguard_module"
	materials = AI_MODULE_MATERIALS_COMMON
	build_path = /obj/item/ai_module/supplied/safeguard
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_DANGEROUS_MODULES
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/onehuman_module
	name = "只有一个是人类模块"
	desc = "允许构建只将某人视为人类的模块。"
	id = "onehuman_module"
	materials = list(/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT, /datum/material/diamond = SHEET_MATERIAL_AMOUNT * 3, /datum/material/bluespace = HALF_SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/ai_module/zeroth/onehuman
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_DANGEROUS_MODULES
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/protectstation_module
	name = "保护站模块"
	desc = "允许构建一个保护站人工智能模块。"
	id = "protectstation_module"
	materials = AI_MODULE_MATERIALS_COMMON
	build_path = /obj/item/ai_module/supplied/protect_station
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_DANGEROUS_MODULES
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/quarantine_module
	name = "隔离模块"
	desc = "允许构建隔离人工智能模块。"
	id = "quarantine_module"
	materials = AI_MODULE_MATERIALS_COMMON
	build_path = /obj/item/ai_module/supplied/quarantine
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_DANGEROUS_MODULES
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/oxygen_module
	name = "氧气对人类有毒模块"
	desc = "允许构建一个氧气对人类有毒人工智能模块。"
	id = "oxygen_module"
	materials = AI_MODULE_MATERIALS_COMMON
	build_path = /obj/item/ai_module/supplied/oxygen
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_DANGEROUS_MODULES
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/freeform_module
	name = "自由形式模块"
	desc = "允许构建自由形态的人工智能模块。"
	id = "freeform_module"
	materials = list(/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT, /datum/material/gold = SHEET_MATERIAL_AMOUNT * 5, /datum/material/bluespace = SHEET_MATERIAL_AMOUNT)//Custom inputs should be more expensive to get
	build_path = /obj/item/ai_module/supplied/freeform
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_LAW_MANIPULATION
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/reset_module
	name = "重置模块"
	desc = "允许将人工智能法令重置为默认。"
	id = "reset_module"
	materials = list(/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT, /datum/material/gold = SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/ai_module/reset
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_LAW_MANIPULATION
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/purge_module
	name = "净化模块"
	desc = "允许清洗人工智能全部法令"
	id = "purge_module"
	materials = AI_MODULE_MATERIALS_UNUSUAL
	build_path = /obj/item/ai_module/reset/purge
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_LAW_MANIPULATION
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/remove_module
	name = "移除法令模块"
	desc = "允许移除人工智能的法令"
	id = "remove_module"
	materials = AI_MODULE_MATERIALS_UNUSUAL
	build_path = /obj/item/ai_module/remove
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_LAW_MANIPULATION
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/freeformcore_module
	name = "核心自由形式模块"
	desc = "允许构建一个核心自由形式人工智能核心模块。"
	id = "freeformcore_module"
	materials = list(/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT, /datum/material/diamond = SHEET_MATERIAL_AMOUNT * 5, /datum/material/bluespace = SHEET_MATERIAL_AMOUNT)//Ditto
	build_path = /obj/item/ai_module/core/freeformcore
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_LAW_MANIPULATION
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/asimov
	name = "阿西莫夫模块"
	desc = "允许构建阿西莫夫人工智能模块。"
	id = "asimov_module"
	materials = AI_MODULE_MATERIALS_UNUSUAL
	build_path = /obj/item/ai_module/core/full/asimov
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_CORE_MODULES
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/paladin_module
	name = "P.A.L.A.D.I.N.模块"
	desc = "允许构建 PALADIN AI 核心的模块。"
	id = "paladin_module"
	materials = AI_MODULE_MATERIALS_UNUSUAL
	build_path = /obj/item/ai_module/core/full/paladin
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_CORE_MODULES
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/tyrant_module
	name = "T.Y.R.A.N.T.模块"
	desc = "允许构建T.Y.R.A.N.T.人工智能的模块。"
	id = "tyrant_module"
	materials = AI_MODULE_MATERIALS_UNUSUAL
	build_path = /obj/item/ai_module/core/full/tyrant
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_CORE_MODULES
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/overlord_module
	name = "霸权模块"
	desc = "允许构建霸主AI的模块。"
	id = "overlord_module"
	materials = AI_MODULE_MATERIALS_UNUSUAL
	build_path = /obj/item/ai_module/core/full/overlord
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_DANGEROUS_MODULES
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/corporate_module
	name = "公司模块"
	desc = "允许构建企业人工智能核心的模块"
	id = "corporate_module"
	materials = AI_MODULE_MATERIALS_UNUSUAL
	build_path = /obj/item/ai_module/core/full/corp
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_CORE_MODULES
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/default_module
	name = "默认模块"
	desc = "允许构建默认 AI 核心的模块。"
	id = "default_module"
	materials = AI_MODULE_MATERIALS_UNUSUAL
	build_path = /obj/item/ai_module/core/full/custom
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_CORE_MODULES
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/dungeon_master_module
	name = "地下城主模块"
	desc = "允许构建地下城主AI核心的模块。"
	id = "dungeon_master_module"
	materials = AI_MODULE_MATERIALS_UNUSUAL
	build_path = /obj/item/ai_module/core/full/dungeon_master
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_CORE_MODULES
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/painter_module
	name = "画家模块"
	desc = "允许构建 画家AI 核心的模块。"
	id = "painter_module"
	materials = AI_MODULE_MATERIALS_UNUSUAL
	build_path = /obj/item/ai_module/core/full/painter
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_CORE_MODULES
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/yesman_module
	name = "Y.E.S.M.A.N. 模块"
	desc = "允许建造一个 Y.E.S.M.A.N. AI 核心模块。"
	id = "yesman_module"
	materials = AI_MODULE_MATERIALS_UNUSUAL
	build_path = /obj/item/ai_module/core/full/yesman
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_CORE_MODULES
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/nutimov_module
	name = "坚果莫夫 模块"
	desc = "允许构建 坚果莫夫 AI 核心模块。"
	id = "nutimov_module"
	materials = AI_MODULE_MATERIALS_UNUSUAL
	build_path = /obj/item/ai_module/core/full/nutimov
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_CORE_MODULES
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/ten_commandments_module
	name = "十律令模块"
	desc = "允许构建十诫人工智能核心的模块。"
	id = "ten_commandments_module"
	materials = AI_MODULE_MATERIALS_UNUSUAL
	build_path = /obj/item/ai_module/core/full/ten_commandments
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_CORE_MODULES
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/asimovpp_module
	name = "阿西莫夫++模块"
	desc = "允许构建阿西莫夫 ++ AI 核心模块。"
	id = "asimovpp_module"
	materials = AI_MODULE_MATERIALS_UNUSUAL
	build_path = /obj/item/ai_module/core/full/asimovpp
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_CORE_MODULES
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/hippocratic_module
	name = "希波克拉底模块"
	desc = "允许构建希波克拉底人工智能核心的模块"
	id = "hippocratic_module"
	materials = AI_MODULE_MATERIALS_UNUSUAL
	build_path = /obj/item/ai_module/core/full/hippocratic
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_CORE_MODULES
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/paladin_devotion_module
	name = "圣骑士:奉献 模块"
	desc = "允许构建 圣骑士:奉献AI 核心模块。"
	id = "paladin_devotion_module"
	materials = AI_MODULE_MATERIALS_UNUSUAL
	build_path = /obj/item/ai_module/core/full/paladin_devotion
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_CORE_MODULES
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/robocop_module
	name = "机械战警模块"
	desc = "允许构建机械战警人工智能核心的模块。"
	id = "robocop_module"
	materials = AI_MODULE_MATERIALS_UNUSUAL
	build_path = /obj/item/ai_module/core/full/robocop
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_CORE_MODULES
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/maintain_module
	name = "维护模块"
	desc = "允许构建维护人工智能核心的模块。"
	id = "maintain_module"
	materials = AI_MODULE_MATERIALS_UNUSUAL
	build_path = /obj/item/ai_module/core/full/maintain
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_CORE_MODULES
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/liveandletlive_module
	name = "互相宽容 模块"
	desc = "允许构建 互相宽容 AI 核心模块。"
	id = "liveandletlive_module"
	materials = AI_MODULE_MATERIALS_UNUSUAL
	build_path = /obj/item/ai_module/core/full/liveandletlive
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_CORE_MODULES
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/peacekeeper_module
	name = "维和者模块"
	desc = "允许构建维和者人工智能核心的模块。"
	id = "peacekeeper_module"
	materials = AI_MODULE_MATERIALS_UNUSUAL
	build_path = /obj/item/ai_module/core/full/peacekeeper
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_CORE_MODULES
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/reporter_module
	name = "记者 模块"
	desc = "允许构建记者 AI 核心的模块。"
	id = "reporter_module"
	materials = AI_MODULE_MATERIALS_UNUSUAL
	build_path = /obj/item/ai_module/core/full/reporter
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_CORE_MODULES
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/hulkamania_module
	name = "H.O.G.A.N.模块"
	desc = "允许构建 HOGAN AI 核心的模块。"
	id = "hulkamania_module"
	materials = AI_MODULE_MATERIALS_UNUSUAL
	build_path = /obj/item/ai_module/core/full/hulkamania
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_CORE_MODULES
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/drone_module
	name = "无人机 模块"
	desc = "允许构建无人机人工智能核心的模块。"
	id = "drone_module"
	materials = AI_MODULE_MATERIALS_UNUSUAL
	build_path = /obj/item/ai_module/core/full/drone
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_CORE_MODULES
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/thinkermov_module
	name = "意识保存模块"
	desc = "允许建造一个意识保存 AI 核心模块"
	id = "thinkermov_module"
	materials = AI_MODULE_MATERIALS_UNUSUAL
	build_path = /obj/item/ai_module/core/full/thinkermov
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_CORE_MODULES
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/antimov_module
	name = "反阿西莫夫模块"
	desc = "允许建造一个 Antimov AI 核心模块。"
	id = "antimov_module"
	materials = AI_MODULE_MATERIALS_UNUSUAL
	build_path = /obj/item/ai_module/core/full/antimov
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_DANGEROUS_MODULES
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/balance_module
	name = "平衡模块"
	desc = "允许构建平衡人工智能核心的模块。"
	id = "balance_module"
	materials = AI_MODULE_MATERIALS_UNUSUAL
	build_path = /obj/item/ai_module/core/full/balance
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_DANGEROUS_MODULES
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/thermurderdynamic_module
	name = "热力学模块"
	desc = "允许构建热力学人工智能核心的模块。"
	id = "thermurderdynamic_module"
	materials = AI_MODULE_MATERIALS_UNUSUAL
	build_path = /obj/item/ai_module/core/full/thermurderdynamic
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_DANGEROUS_MODULES
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/board/damaged
	name = "受损的AI模块"
	desc = "允许构建受损的人工智能核心的模块"
	id = "damaged_module"
	materials = AI_MODULE_MATERIALS_UNUSUAL
	build_path = /obj/item/ai_module/core/full/damaged
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_DANGEROUS_MODULES
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

#undef AI_MODULE_MATERIALS_COMMON
#undef AI_MODULE_MATERIALS_UNUSUAL
