///// First we enstate a techweb so we can add the node. /////

/datum/techweb/tarkon
	id = "TARKON"
	organization = "Tarkon Industries"
	should_generate_points = TRUE

/datum/techweb/tarkon/New()
	. = ..()
	research_node_id(TECHWEB_NODE_OLDSTATION_SURGERY, TRUE, TRUE, FALSE)
	research_node_id(TECHWEB_NODE_TARKON, TRUE, TRUE, FALSE)

/datum/techweb_node/tarkon
	id = TECHWEB_NODE_TARKON
	display_name = "Tarkon Industries Technology"
	description = "Tarkon工业使用的工具。"
	required_items_to_unlock = list(
		/obj/item/mod/construction/plating/tarkon,
		/obj/item/construction/rcd/tarkon,
		/obj/item/gun/energy/recharge/resonant_system,
	)
	prereq_ids = list(TECHWEB_NODE_CONSTRUCTION)
	design_ids = list(
		"mod_plating_tarkon",
		"arcs",
		"rcd_tarkon",
		"tarkonbsc",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_5_POINTS)
	hidden = TRUE

/datum/techweb_node/tarkonturret //Yes. Tarkon does not start with this unlocked.
	id = TECHWEB_NODE_TARKON_DEFENSE
	display_name = "Tarkon Industries Automated Turrets"
	description = "Tarkon工业黑锈打捞部门的防御设计。"
	prereq_ids = list(TECHWEB_NODE_TARKON, TECHWEB_NODE_BASIC_ARMS, TECHWEB_NODE_AI)
	design_ids = list(
		"hoplite_assembly",
		"cerberus_assembly",
		"target_designator",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_5_POINTS)

/datum/design/mod_plating/tarkon
	name = "MOD Tarkon护甲板"
	id = "mod_plating_tarkon"
	build_path = /obj/item/mod/construction/plating/tarkon
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 3,
		/datum/material/uranium = SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/plasma = HALF_SHEET_MATERIAL_AMOUNT,
	)
	research_icon_state = "tarkon-plating"
	research_icon = 'modular_nova/master_files/icons/obj/clothing/modsuit/mod_construction.dmi'

/datum/design/arcs
	name = "A.R.C.S共振器"
	id = "arcs"
	build_type = PROTOLATHE | AWAY_LATHE | AUTOLATHE
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 3,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/uranium = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/diamond = SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/gun/energy/recharge/resonant_system
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MINING
	)

/datum/design/tarkonbsc
	name = "Tarkon BSC精炼箱"
	id = "tarkonbsc"
	build_type = PROTOLATHE | AWAY_LATHE | AUTOLATHE
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/plasma = SHEET_MATERIAL_AMOUNT * 3,
		/datum/material/titanium = SHEET_MATERIAL_AMOUNT * 3,
	)
	build_path = /obj/item/flatpacked_machine/boulder_collector/tarkon
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MINING
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO

/datum/design/tarkonrcd
	name = "塔康快速建造装置"
	desc = "由塔康工业制造的快速建造装置。能够进行远程建造。"
	id = "rcd_tarkon"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 30,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 10,
		/datum/material/uranium = SHEET_MATERIAL_AMOUNT * 4,
		/datum/material/diamond = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/bluespace = SHEET_MATERIAL_AMOUNT * 3,
		)
	build_path = /obj/item/construction/rcd/tarkon
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING_ADVANCED
	)

/datum/design/hoplite_assembly
	name = "重装步兵炮塔组件"
	desc = "一种为基本构造体防御设计的可部署炮塔套件。这个型号制造的是\"Hoplite\"模型。"
	id = "hoplite_assembly"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 25,
		/datum/material/plasma = SHEET_MATERIAL_AMOUNT * 10,
		/datum/material/titanium = SHEET_MATERIAL_AMOUNT * 4,
		/datum/material/gold = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT * 2,
		)
	build_path = /obj/item/turret_assembly/hoplite
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_WEAPONS_KITS
	)

/datum/design/cerberus_assembly
	name = "刻耳柏洛斯炮塔组件"
	desc = "一种为基本构造体防御设计的可部署炮塔套件。这个制造的是\"刻耳柏洛斯\"型号。"
	id = "cerberus_assembly"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 30,
		/datum/material/plasma = SHEET_MATERIAL_AMOUNT * 20,
		/datum/material/titanium = SHEET_MATERIAL_AMOUNT * 10,
		/datum/material/gold = SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT * 3,
	)
	build_path = /obj/item/turret_assembly/cerberus
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_WEAPONS_KITS,
	)

/datum/design/target_designator
	name = "炮塔目标指示器"
	desc = "一种用于控制弹匣供弹炮塔的基本目标指示器。"
	id = "target_designator"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/plasma = SHEET_MATERIAL_AMOUNT,
		/datum/material/titanium = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/gold = SHEET_MATERIAL_AMOUNT,
		/datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/target_designator
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_WEAPONS_KITS,
	)

///// Now we make the physical server /////

/obj/item/circuitboard/machine/rdserver/tarkon
	name = "塔康工业研发服务器"
	build_path = /obj/machinery/rnd/server/tarkon

/obj/machinery/rnd/server/tarkon
	name = "\improper 塔康工业研发服务器"
	circuit = /obj/item/circuitboard/machine/rdserver/tarkon
	req_access = list(ACCESS_AWAY_SCIENCE)

/obj/machinery/rnd/server/tarkon/Initialize(mapload)
	var/datum/techweb/tarkon_techweb = locate(/datum/techweb/tarkon) in SSresearch.techwebs
	stored_research = tarkon_techweb
	return ..()

/obj/machinery/rnd/server/tarkon/examine(mob/user)
	. = ..()
	. += span_notice("你可以将<b>研究笔记</b>用在这上面来生成研究点数。")

/obj/machinery/rnd/server/tarkon/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/research_notes) && stored_research)
		var/obj/item/research_notes/research_notes = tool
		stored_research.add_point_list(list(TECHWEB_POINT_TYPE_GENERIC = research_notes.value))
		playsound(src, 'sound/machines/copier.ogg', 50, TRUE)
		qdel(research_notes)
		return ITEM_INTERACT_SUCCESS

	return ..()

/obj/machinery/rnd/production/protolathe/tarkon
	name = "塔康工业原型机"
	desc = "将原材料转化为有用的物品。经过翻新和升级，摆脱了先前有限的功能。"
	circuit = /obj/item/circuitboard/machine/protolathe/tarkon
	stripe_color = "#350f04"

/obj/item/circuitboard/machine/protolathe/tarkon
	name = "塔康工业原型机"
	greyscale_colors = CIRCUIT_COLOR_SUPPLY
	build_path = /obj/machinery/rnd/production/protolathe/tarkon
