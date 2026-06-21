// Belts

/datum/design/frontier_chest_rig
	name = "前沿胸挂"
	id = "frontier_chest_rig"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 150)
	build_path = /obj/item/storage/belt/utility/frontier_colonist
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_AKHTER_EQUIPMENT,
	)

/datum/design/frontier_med_belt
	name = "挎包医疗套件"
	id = "frontier_med_belt"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 200)
	build_path = /obj/item/storage/backpack/duffelbag/deforest_medkit
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_AKHTER_EQUIPMENT,
	)

/datum/design/frontier_medtech_belt
	name = "医疗技师套件"
	id = "frontier_medtech_belt"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 200)
	build_path = /obj/item/storage/backpack/duffelbag/deforest_paramedic
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_AKHTER_EQUIPMENT,
	)

/datum/design/frontier_medkit
	name = "边疆医疗包"
	id = "frontier_medkit"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 100)
	build_path = /obj/item/storage/medkit/frontier
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_AKHTER_EQUIPMENT,
	)

// Backpacks

/datum/design/frontier_backpack
	name = "边疆背包"
	id = "frontier_backpack"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 100)
	build_path = /obj/item/storage/backpack/industrial/frontier_colonist
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_AKHTER_EQUIPMENT,
	)

/datum/design/frontier_satchel
	name = "边疆挎包"
	id = "frontier_satchel"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 100)
	build_path = /obj/item/storage/backpack/industrial/frontier_colonist/satchel
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_AKHTER_EQUIPMENT,
	)

/datum/design/frontier_messenger
	name = "边疆信使包"
	id = "frontier_messenger"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 100)
	build_path = /obj/item/storage/backpack/industrial/frontier_colonist/messenger
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_AKHTER_EQUIPMENT,
	)
