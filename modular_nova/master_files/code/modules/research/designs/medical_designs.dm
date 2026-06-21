/datum/design/cybernetic_tongue
	name = "赛博舌头"
	desc = "一个赛博舌头。"
	id = "cybernetic_tongue"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 4 SECONDS
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT * 2,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT * 2,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT * 2,
	)
	build_path = /obj/item/organ/tongue/cybernetic
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_ORGANS_1,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cybernetic_tongue/lizard
	name = "分叉赛博舌头"
	desc = "一个分叉的赛博舌头。"
	id = "cybernetic_tongue_lizard"
	build_path = /obj/item/organ/tongue/lizard/cybernetic

/datum/design/cone_of_shame
	name = "项圈锥"
	desc = "一种用于防止感染的防护罩。其广告宣称它：“用于防止不必要的抓挠、啃咬或舔舐伤口，以更好地促进愈合。对人类和宠物同样有效！”你质疑它的功效，同时在佩戴时感到一丝轻微的羞耻。"
	id = "cone_of_shame"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/plastic = SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/clothing/head/cone_of_shame
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

// Removed by TG 94182. Bringing back modularly.
/datum/design/defibrillator
	name = "除颤器-Defibrillator"
	desc = "便携式除颤器，用来抢救刚去世的船员"
	id = "defibrillator"
	build_type = PROTOLATHE | AWAY_LATHE
	build_path = /obj/item/defibrillator
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 4, /datum/material/glass = SHEET_MATERIAL_AMOUNT * 2, /datum/material/silver =SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/gold = HALF_SHEET_MATERIAL_AMOUNT * 1.5)
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL
