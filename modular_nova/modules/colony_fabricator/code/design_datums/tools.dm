/datum/techweb_node/colony_fabricator_special_tools
	id = TECHWEB_NODE_COLONY_TOOLS
	display_name = "Colony Fabricator Tool Designs"
	description = "包含殖民地制造机的所有工具设计。"
	design_ids = list(
		"colony_power_drive",
		"colony_crowbar",
		"colony_arc_welder",
		"colony_compact_drill",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 50000000000000) // God save you
	hidden = TRUE
	show_on_wiki = FALSE
	starting_node = TRUE

// Screw-Wrench-Wirecutter combo machine

/datum/design/colony_power_driver
	name = "动力驱动器"
	id = "colony_power_drive"
	build_type = COLONY_FABRICATOR
	build_path = /obj/item/screwdriver/omni_drill
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 1.75,
		/datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT * 1.5,
		/datum/material/titanium = HALF_SHEET_MATERIAL_AMOUNT,
	)
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING_ADVANCED,
	)

// Regular Crowbar until we invent something else.

/datum/design/colony_crowbar
	name = "撬棍"
	id = "colony_crowbar"
	build_type = COLONY_FABRICATOR
	build_path = /obj/item/crowbar
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT*0.35,
	)
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING_ADVANCED,
	)

// Welder that takes no fuel or power to run but is quite slow, at least it sounds cool as hell

/datum/design/colony_arc_welder
	name = "电弧焊枪"
	id = "colony_arc_welder"
	build_type = COLONY_FABRICATOR
	build_path = /obj/item/weldingtool/electric/arc_welder
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/plasma = HALF_SHEET_MATERIAL_AMOUNT * 1.5,
	)
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_ENGINEERING_ADVANCED,
	)

// Slightly slower drill that fits in backpacks

/datum/design/colony_compact_drill
	name = "紧凑型采矿钻"
	id = "colony_compact_drill"
	build_type = COLONY_FABRICATOR
	build_path = /obj/item/pickaxe/drill/compact
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 3,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
	)
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MINING,
	)
