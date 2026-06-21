/datum/design/monkey_helmet
	name = "猴子思维放大头盔"
	desc = "一个脆弱的、嵌入电路的头盔，用于将猴子的智力提升到更高水平。"
	id = "monkey_helmet"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/gold = HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/clothing/head/helmet/monkey_sentience
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_EQUIPMENT_SCIENCE,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/plumbing_eng
	name = "工程管道构造器"
	desc = "一种设计用于操纵流体的管道构造器。"
	id = "plumbing_eng"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 40,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/gold = HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/construction/plumbing/engineering
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING,
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/design/smartdartgun
	name = "医疗智能飞镖枪"
	desc = "医疗注射枪的改良版本，仅允许装填智能飞镖。"
	id = "smartdartgun"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT * 2,
	)
	build_path = /obj/item/gun/syringe/smartdart
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_EQUIPMENT_MEDICAL,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/anesthetic_machine
	name = "麻醉机零件套件"
	desc = "一体化套件，包含组装便携式麻醉支架所需的零件，不含气罐。"
	id = "anesthetic_machine"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/plastic = SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT * 2,
	)
	build_path = /obj/item/anesthetic_machine_kit
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_EQUIPMENT_MEDICAL,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/vox_gas_filter
	name = "沃克斯气体过滤器"
	id = "vox_gas_filter"
	build_type = PROTOLATHE | AUTOLATHE | COLONY_FABRICATOR
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/gas_filter/vox
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_GAS_TANKS_EQUIPMENT
	)
	departmental_flags = ALL

/datum/design/d2
	name = "D2骰子"
	id = "d2"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/plastic = SMALL_MATERIAL_AMOUNT * 0.2)
	build_path = /obj/item/dice/d2
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MISC,
	)

/datum/design/d4
	name = "D4骰子"
	id = "d4"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/plastic = SMALL_MATERIAL_AMOUNT * 0.2)
	build_path = /obj/item/dice/d4
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MISC,
	)

/datum/design/d6
	name = "D6骰子"
	id = "d6"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/plastic = SMALL_MATERIAL_AMOUNT * 0.2)
	build_path = /obj/item/dice/d6
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MISC,
	)

/datum/design/d8
	name = "D8骰子"
	id = "d8"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/plastic = SMALL_MATERIAL_AMOUNT * 0.2)
	build_path = /obj/item/dice/d8
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MISC,
	)

/datum/design/d10
	name = "D10骰子"
	id = "d10"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/plastic = SMALL_MATERIAL_AMOUNT * 0.2)
	build_path = /obj/item/dice/d10
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MISC,
	)

/datum/design/d00
	name = "D00骰子"
	id = "d00"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/plastic = SMALL_MATERIAL_AMOUNT * 0.2)
	build_path = /obj/item/dice/d00
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MISC,
	)


/datum/design/d12
	name = "D12骰子"
	id = "d12"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/plastic = SMALL_MATERIAL_AMOUNT * 0.2)
	build_path = /obj/item/dice/d12
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MISC,
	)

/datum/design/d20
	name = "D20骰子"
	id = "d20"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/plastic = SMALL_MATERIAL_AMOUNT * 0.2)
	build_path = /obj/item/dice/d20
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MISC,
	)

/datum/design/fudge
	name = "命运骰"
	id = "fudge"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/plastic = SMALL_MATERIAL_AMOUNT * 0.2)
	build_path = /obj/item/dice/fudge
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MISC,
	)

/datum/design/d100
	name = "D100骰子"
	id = "d100"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/plastic = SMALL_MATERIAL_AMOUNT * 0.4) //Uses more plastic, because it's a chunky boy.
	build_path = /obj/item/dice/d100
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MISC,
	)
