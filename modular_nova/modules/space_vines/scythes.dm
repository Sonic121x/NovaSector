/obj/item/scythe
	name = "镰刀"
	desc = "一把锋利弯曲的刀刃安装在长长的纤维金属手柄上，这件工具让你轻松收割你所播种之物。"
	icon = 'modular_nova/modules/space_vines/icons/items_and_weapons.dmi'
	icon_state = "scythe_t1"
	worn_icon = 'modular_nova/modules/space_vines/icons/back.dmi'
	lefthand_file = 'modular_nova/modules/space_vines/icons/polearms_lefthand.dmi'
	righthand_file = 'modular_nova/modules/space_vines/icons/polearms_righthand.dmi'
	force = 13
	throwforce = 5
	throw_speed = 2
	throw_range = 3
	wound_bonus = 10
	w_class = WEIGHT_CLASS_BULKY
	obj_flags = CONDUCTS_ELECTRICITY
	armour_penetration = 20
	slot_flags = ITEM_SLOT_BACK
	attack_verb_continuous = list("chops", "slices", "cuts", "reaps")
	attack_verb_simple = list("chop", "slice", "cut", "reap")
	hitsound = 'sound/items/weapons/bladeslice.ogg'
	item_flags = CRUEL_IMPLEMENT //maybe they want to use it in surgery

	var/hit_range = 0
	var/swiping = FALSE

/obj/item/scythe/pre_attack(atom/A, mob/living/user, params)
	if(!istype(A, /obj/structure/spacevine) && !istype(A, /mob/living/basic/venus_human_trap))
		return ..()
	if(swiping)
		return ..()
	swiping = TRUE
	if(istype(A, /obj/structure/spacevine) && hit_range >= 1)
		for(var/obj/structure/spacevine/choose_vine in view(hit_range, A))
			melee_attack_chain(user, choose_vine)
		swiping = FALSE
		return
	swiping = FALSE

/obj/item/scythe/tier1
	name = "镰刀（等级 1）"
	icon_state = "scythe_t1"

/obj/item/scythe/tier2
	name = "镰刀（等级 2）"
	icon_state = "scythe_t2"
	force = 15
	hit_range = 1

/obj/item/scythe/tier3
	name = "镰刀（等级 3）"
	icon_state = "scythe_t3"
	force = 18
	hit_range = 2

/obj/item/scythe/tier4
	name = "镰刀（等级 4）"
	icon_state = "scythe_t4"
	force = 22
	hit_range = 3

/datum/design/scythe
	name = "镰刀（等级 1）"
	desc = "一把锋利弯曲的刀刃安装在长长的纤维金属手柄上，这件工具让你轻松收割你所播种之物。"
	id = "scythet1"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/scythe/tier1
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_BOTANY,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_SECURITY

/datum/design/scythe/tier2
	name = "镰刀（等级 2）"
	id = "scythet2"
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/scythe/tier2

/datum/design/scythe/tier3
	name = "镰刀（等级 3）"
	id = "scythet3"
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/scythe/tier3

/datum/design/scythe/tier4
	name = "镰刀（等级 4）"
	id = "scythet4"
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/scythe/tier4

/datum/techweb_node/scythe_t1
	id = TECHWEB_NODE_SCYTHE_1
	display_name = "Scythe (Tier 1)"
	description = "用于高效清除的改良镰刀。"
	prereq_ids = list(TECHWEB_NODE_EXP_TOOLS, TECHWEB_NODE_CHEM_SYNTHESIS, TECHWEB_NODE_BOTANY_EQUIP)
	design_ids = list(
		"scythet1",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	discount_experiments = list(/datum/experiment/scanning/random/plants/wild = TECHWEB_TIER_1_POINTS)
	announce_channels = list(RADIO_CHANNEL_SERVICE, RADIO_CHANNEL_SECURITY)

/datum/techweb_node/scythe_t2
	id = TECHWEB_NODE_SCYTHE_2
	display_name = "Scythe (Tier 2)"
	description = "用于高效清除的进一步改良镰刀。"
	prereq_ids = list(TECHWEB_NODE_SCYTHE_1)
	design_ids = list(
		"scythet2",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)
	discount_experiments = list(/datum/experiment/scanning/random/plants/wild = TECHWEB_TIER_2_POINTS)
	announce_channels = list(RADIO_CHANNEL_SERVICE, RADIO_CHANNEL_SECURITY)

/datum/techweb_node/scythe_t3
	id = TECHWEB_NODE_SCYTHE_3
	display_name = "Scythe (Tier 3)"
	description = "用于高效清除的更进一步改良镰刀。"
	prereq_ids = list(TECHWEB_NODE_SCYTHE_2)
	design_ids = list(
		"scythet3",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	discount_experiments = list(/datum/experiment/scanning/random/plants/wild = TECHWEB_TIER_3_POINTS)
	announce_channels = list(RADIO_CHANNEL_SERVICE, RADIO_CHANNEL_SECURITY)

/datum/techweb_node/scythe_t4
	id = TECHWEB_NODE_SCYTHE_4
	display_name = "Scythe (Tier 4)"
	description = "最高效的收割用镰刀。"
	prereq_ids = list(TECHWEB_NODE_SCYTHE_3)
	design_ids = list(
		"scythet4",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_4_POINTS)
	discount_experiments = list(/datum/experiment/scanning/random/plants/wild = TECHWEB_TIER_4_POINTS)
	announce_channels = list(RADIO_CHANNEL_SERVICE, RADIO_CHANNEL_SECURITY)

/datum/supply_pack/organic/tier3_scythe
	name = "等级 3 镰刀"
	desc = "有讨厌的藤蔓需要更快地砍掉吗？现在就订购这个板条箱！"
	cost = CARGO_CRATE_VALUE * 20
	contains = list(/obj/item/scythe/tier3)
	crate_name = "tier 3 scythe supply crate"

/datum/supply_pack/organic/tier4_scythe
	name = "等级 4 镰刀"
	desc = "有讨厌的藤蔓需要更快地砍掉吗？现在就订购这个板条箱！"
	cost = CARGO_CRATE_VALUE * 40
	contains = list(/obj/item/scythe/tier4)
	crate_name = "tier 4 scythe supply crate"
