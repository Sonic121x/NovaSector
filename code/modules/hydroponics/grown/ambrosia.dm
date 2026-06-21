// Ambrosia - base type
/obj/item/food/grown/ambrosia
	seed = /obj/item/seeds/ambrosia
	name = "安布罗希亚枝叶"
	desc = "这是一棵植物。"
	icon_state = "ambrosiavulgaris"
	slot_flags = ITEM_SLOT_HEAD
	bite_consumption_mod = 3
	foodtypes = VEGETABLES
	tastes = list("ambrosia" = 1)

// Ambrosia Vulgaris
/obj/item/seeds/ambrosia
	name = "普通神果种子包"
	desc = "这些种子长成了常见的安布罗希亚植物，这是一种由人类种植并由人类食用的药用植物。"
	icon_state = "seed-ambrosiavulgaris"
	plant_icon_offset = 0
	species = "ambrosiavulgaris"
	plantname = "Ambrosia Vulgaris"
	product = /obj/item/food/grown/ambrosia/vulgaris
	lifespan = 60
	endurance = 25
	yield = 6
	potency = 5
	instability = 30
	icon_dead = "ambrosia-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	mutatelist = list(/obj/item/seeds/ambrosia/deus)
	reagents_add = list(/datum/reagent/medicine/c2/aiuri = 0.1, /datum/reagent/medicine/c2/libital = 0.1 ,/datum/reagent/drug/space_drugs = 0.15, /datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.05, /datum/reagent/toxin = 0.1)

/obj/item/food/grown/ambrosia/vulgaris
	seed = /obj/item/seeds/ambrosia
	name = "安布罗希亚枝条"
	desc = "这是一种含有多种治疗性化学物质的植物。"
	wine_power = 30

// Ambrosia Deus
/obj/item/seeds/ambrosia/deus
	name = "神圣神果种子包"
	desc = "这些种子长成了神之食粮。难道这就是众神的美食吗？"
	icon_state = "seed-ambrosiadeus"
	species = "ambrosiadeus"
	plantname = "Ambrosia Deus"
	product = /obj/item/food/grown/ambrosia/deus
	mutatelist = list(/obj/item/seeds/ambrosia/gaia)
	reagents_add = list(/datum/reagent/medicine/omnizine = 0.15, /datum/reagent/medicine/synaptizine = 0.15, /datum/reagent/drug/space_drugs = 0.1, /datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.05)
	rarity = 40

/obj/item/food/grown/ambrosia/deus
	seed = /obj/item/seeds/ambrosia/deus
	name = "安布罗希亚德乌斯枝叶"
	desc = "吃了这个会让你觉得自己长生不老！"
	icon_state = "ambrosiadeus"
	wine_power = 50

//Ambrosia Gaia
/obj/item/seeds/ambrosia/gaia
	name = "盖亚神果种子包"
	desc = "这些种子长成了盖亚之花，蕴含着无限的潜能。"
	icon_state = "seed-ambrosia_gaia"
	species = "ambrosia_gaia"
	plantname = "Ambrosia Gaia"
	product = /obj/item/food/grown/ambrosia/gaia
	mutatelist = list(/obj/item/seeds/ambrosia/deus)
	reagents_add = list(/datum/reagent/medicine/earthsblood = 0.05, /datum/reagent/consumable/nutriment = 0.06, /datum/reagent/consumable/nutriment/vitamin = 0.05)
	rarity = 30 //These are some pretty good plants right here
	genes = list()
	weed_rate = 4
	weed_chance = 100

/obj/item/food/grown/ambrosia/gaia
	name = "安布罗西亚盖亚枝叶"
	desc = "吃了这个会让你<i>觉得</i>自己长生不老！"
	icon_state = "ambrosia_gaia"
	light_system = OVERLAY_LIGHT
	light_range = 3
	light_power = 1.2
	light_color = "#ffff00"
	seed = /obj/item/seeds/ambrosia/gaia
	wine_power = 70
	wine_flavor = "the earthmother's blessing"
