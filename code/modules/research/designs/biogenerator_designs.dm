///////////////////////////////////
///////Biogenerator Designs ///////
///////////////////////////////////

/datum/design/milk
	name = "合成牛奶"
	id = "milk"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 0.4)
	make_reagent = /datum/reagent/consumable/milk
	category = list(RND_CATEGORY_INITIAL, RND_CATEGORY_BIO_FOOD)

/datum/design/soymilk
	name = "合成豆奶"
	id = "soymilk"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 0.4)
	make_reagent = /datum/reagent/consumable/soymilk
	category = list(RND_CATEGORY_INITIAL, RND_CATEGORY_BIO_FOOD)

/datum/design/ethanol
	name = "合成乙醇"
	id = "ethanol"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 0.6)
	make_reagent = /datum/reagent/consumable/ethanol
	category = list(RND_CATEGORY_INITIAL, RND_CATEGORY_BIO_FOOD)

/datum/design/cream
	name = "合成奶油"
	id = "cream"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 0.6)
	make_reagent = /datum/reagent/consumable/cream
	category = list(RND_CATEGORY_INITIAL, RND_CATEGORY_BIO_FOOD)

/datum/design/black_pepper
	name = "合成黑胡椒"
	id = "black_pepper"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 0.6)
	make_reagent = /datum/reagent/consumable/blackpepper
	category = list(RND_CATEGORY_INITIAL, RND_CATEGORY_BIO_FOOD)

/datum/design/enzyme
	name = "合成酶"
	id = "enzyme"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 0.6)
	make_reagent = /datum/reagent/consumable/enzyme
	category = list(RND_CATEGORY_INITIAL, RND_CATEGORY_BIO_FOOD)

/datum/design/flour
	name = "合成面粉"
	id = "flour_sack"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 0.6)
	make_reagent = /datum/reagent/consumable/flour
	category = list(RND_CATEGORY_INITIAL, RND_CATEGORY_BIO_FOOD)

/datum/design/sugar
	name = "合成糖"
	id = "sugar"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 0.6)
	make_reagent = /datum/reagent/consumable/sugar
	category = list(RND_CATEGORY_INITIAL, RND_CATEGORY_BIO_FOOD)

/datum/design/monkey_cube
	name = "猴子方块"
	id = "mcube"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 50)
	build_path = /obj/item/food/monkeycube
	category = list(RND_CATEGORY_INITIAL, RND_CATEGORY_BIO_FOOD)

/datum/design/seaweed_sheet
	name = "海苔片"
	id = "seaweedsheet"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 3)
	build_path = /obj/item/food/seaweedsheet
	category = list(RND_CATEGORY_INITIAL, RND_CATEGORY_BIO_FOOD)

/datum/design/ez_nut   //easy nut :)
	name = "E-Z营养剂"
	id = "ez_nut"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 0.1)
	make_reagent = /datum/reagent/plantnutriment/eznutriment
	category = list(RND_CATEGORY_INITIAL, RND_CATEGORY_BIO_CHEMICALS)

/datum/design/l4z_nut
	name = "Left 4 Zed"
	id = "l4z_nut"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 0.1)
	make_reagent = /datum/reagent/plantnutriment/left4zednutriment
	category = list(RND_CATEGORY_INITIAL, RND_CATEGORY_BIO_CHEMICALS)

/datum/design/rh_nut
	name = "丰收强效剂"
	id = "rh_nut"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 0.2)
	make_reagent = /datum/reagent/plantnutriment/robustharvestnutriment
	category = list(RND_CATEGORY_INITIAL, RND_CATEGORY_BIO_CHEMICALS)

/datum/design/end_gro
	name = "耐久生长剂"
	id = "end_gro"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 0.3)
	make_reagent = /datum/reagent/plantnutriment/endurogrow
	category = list(RND_CATEGORY_INITIAL, RND_CATEGORY_BIO_CHEMICALS)

/datum/design/liq_earth
	name = "液态地震"
	id = "liq_earth"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 0.3)
	make_reagent = /datum/reagent/plantnutriment/liquidearthquake
	category = list(RND_CATEGORY_INITIAL, RND_CATEGORY_BIO_CHEMICALS)

/datum/design/weed_killer
	name = "除草剂"
	id = "weed_killer"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 0.2)
	make_reagent = /datum/reagent/toxin/plantbgone/weedkiller
	category = list(RND_CATEGORY_INITIAL, RND_CATEGORY_BIO_CHEMICALS)

/datum/design/pest_spray
	name = "杀虫剂"
	id = "pest_spray"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 0.4)
	make_reagent = /datum/reagent/toxin/pestkiller
	category = list(RND_CATEGORY_INITIAL, RND_CATEGORY_BIO_CHEMICALS)

/datum/design/org_pest_spray
	name = "有机杀虫剂"
	id = "org_pest_spray"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 0.6)
	make_reagent = /datum/reagent/toxin/pestkiller/organic
	category = list(RND_CATEGORY_INITIAL, RND_CATEGORY_BIO_CHEMICALS)

/datum/design/leather
	name = "皮革"
	id = "leather"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 30)
	build_path = /obj/item/stack/sheet/leather
	category = list(RND_CATEGORY_INITIAL, RND_CATEGORY_BIO_MATERIALS)

/datum/design/cloth
	name = "布料"
	id = "cloth"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 10)
	build_path = /obj/item/stack/sheet/cloth
	category = list(RND_CATEGORY_INITIAL, RND_CATEGORY_BIO_MATERIALS)

/datum/design/cardboard
	name = "纸板"
	id = "cardboard"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 5)
	build_path = /obj/item/stack/sheet/cardboard
	category = list(RND_CATEGORY_INITIAL, RND_CATEGORY_BIO_MATERIALS)

/datum/design/paper
	name = "纸张"
	id = "paper"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 2)
	build_path = /obj/item/paper
	category = list(RND_CATEGORY_INITIAL, RND_CATEGORY_BIO_MATERIALS)

/datum/design/rolling_paper
	name = "卷烟纸"
	id = "rollingpaper"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 1)
	build_path = /obj/item/rollingpaper
	category = list(RND_CATEGORY_INITIAL, RND_CATEGORY_BIO_MATERIALS)

/datum/design/candle
	name = "蜡烛"
	id = "candle"
	build_type = BIOGENERATOR
	materials = list(/datum/material/biomass = 3)
	build_path = /obj/item/flashlight/flare/candle
	category = list(RND_CATEGORY_INITIAL, RND_CATEGORY_BIO_MATERIALS)
