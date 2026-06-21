/datum/design/pocket_medkit
	name = "空便携急救包"
	id = "slavic_cfap"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 250)
	build_path = /obj/item/storage/pouch/cin_medkit
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HC_MEDICAL,
	)

/datum/design/medipouch
	name = "空医疗笔袋"
	id = "slavic_medipouch"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 250)
	build_path = /obj/item/storage/pouch/cin_medipens
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HC_MEDICAL,
	)

/datum/design/genpouch
	name = "空通用袋"
	id = "slavic_genpouch"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 250)
	build_path = /obj/item/storage/pouch/cin_general
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HC_MEDICAL,
	)

/datum/design/sutures
	name = "止血缝合线"
	id = "slavic_suture"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 150)
	build_path = /obj/item/stack/medical/suture/bloody
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HC_MEDICAL,
	)

/datum/design/mesh
	name = "止血网"
	id = "slavic_mesh"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 150)
	build_path = /obj/item/stack/medical/mesh/bloody
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HC_MEDICAL,
	)

/datum/design/bruise_patch
	name = "瘀伤贴片"
	id = "slavic_bruise"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 250)
	build_path = /obj/item/reagent_containers/applicator/patch/libital
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HC_MEDICAL,
	)

/datum/design/burn_patch
	name = "烧伤贴片"
	id = "slavic_burn"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 250)
	build_path = /obj/item/reagent_containers/applicator/patch/aiuri
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HC_MEDICAL,
	)

/datum/design/gauze
	name = "医疗纱布"
	id = "slavic_gauze"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 100)
	build_path = /obj/item/stack/medical/wrap/gauze
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HC_MEDICAL,
	)

/datum/design/epi_pill
	name = "肾上腺素药片"
	id = "slavic_epi"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 75)
	build_path = /obj/item/reagent_containers/applicator/pill/epinephrine
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HC_MEDICAL,
	)

/datum/design/conv_pill
	name = "康沃莫药片"
	id = "slavic_conv"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 75)
	build_path = /obj/item/reagent_containers/applicator/pill/convermol
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HC_MEDICAL,
	)

/datum/design/multiver_pill
	name = "多维尔药片"
	id = "slavic_multiver"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 75)
	build_path = /obj/item/reagent_containers/applicator/pill/multiver
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_HC_MEDICAL,
	)
