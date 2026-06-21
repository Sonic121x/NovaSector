// Cannabis
/obj/item/seeds/cannabis
	name = "大麻种子包"
	desc = "要收税哦。"
	icon_state = "seed-cannabis"
	plant_icon_offset = 6
	species = "cannabis"
	plantname = "Cannabis Plant"
	product = /obj/item/food/grown/cannabis
	maturation = 8
	potency = 20
	growthstages = 1
	instability = 40
	growing_icon = 'icons/obj/service/hydroponics/growing.dmi'
	icon_grow = "cannabis-grow" // Uses one growth icons set for all the subtypes
	icon_dead = "cannabis-dead" // Same for the dead icon
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	mutatelist = list(
		/obj/item/seeds/cannabis/anti,
		/obj/item/seeds/cannabis/death,
		/obj/item/seeds/cannabis/rainbow,
		/obj/item/seeds/cannabis/ultimate,
		/obj/item/seeds/cannabis/white,
	)
	reagents_add = list(/datum/reagent/drug/thc = 0.15) // NOVA EDIT - CHANGE - MORENARCOTICS - ORIGINAL: reagents_add = list(/datum/reagent/drug/cannabis = 0.15)


/obj/item/seeds/cannabis/rainbow
	name = "彩虹杂草种子包"
	desc = "这些种子长成的是彩虹草。太酷了……而且还极具成瘾性。"
	icon_state = "seed-megacannabis"
	icon_grow = "megacannabis-grow"
	species = "megacannabis"
	plantname = "Rainbow Weed"
	product = /obj/item/food/grown/cannabis/rainbow
	mutatelist = null
	reagents_add = list(/datum/reagent/colorful_reagent = 0.05, /datum/reagent/medicine/psicodine = 0.03, /datum/reagent/drug/happiness = 0.1, /datum/reagent/toxin/mindbreaker = 0.1, /datum/reagent/toxin/lipolicide = 0.15, /datum/reagent/drug/space_drugs = 0.15)
	rarity = 40

/obj/item/seeds/cannabis/death
	name = "死亡杂草种子包"
	desc = "这些种子长成的植物是“死亡草”。可真不吉利啊。"
	icon_state = "seed-blackcannabis"
	icon_grow = "blackcannabis-grow"
	species = "blackcannabis"
	plantname = "Deathweed"
	product = /obj/item/food/grown/cannabis/death
	mutatelist = null
	reagents_add = list(/datum/reagent/toxin/cyanide = 0.35, /datum/reagent/drug/thc = 0.15) // NOVA EDIT CHANGE - MORENARCOTICS - ORIGINAL: agents_add = list(/datum/reagent/toxin/cyanide = 0.35, /datum/reagent/drug/cannabis = 0.15)
	rarity = 40

/obj/item/seeds/cannabis/white
	name = "生命杂草种子包"
	desc = "我会毫无保留地将那能满足生命渴望之源泉的馈赠给予他。"
	icon_state = "seed-whitecannabis"
	icon_grow = "whitecannabis-grow"
	species = "whitecannabis"
	plantname = "Lifeweed"
	instability = 30
	product = /obj/item/food/grown/cannabis/white
	mutatelist = null
	reagents_add = list(/datum/reagent/medicine/omnizine = 0.35, /datum/reagent/drug/thc = 0.15) // NOVA EDIT CHANGE - MORENARCOTICS - ORIGINAL: reagents_add = list(/datum/reagent/medicine/omnizine = 0.35, /datum/reagent/drug/cannabis = 0.15)
	rarity = 40


/obj/item/seeds/cannabis/ultimate
	name = "欧米茄杂草种子包"
	desc = "能长成欧米茄草的种子。"
	icon_state = "seed-ocannabis"
	plant_icon_offset = 0
	icon_grow = "ocannabis-grow"
	species = "ocannabis"
	plantname = "Omega Weed"
	product = /obj/item/food/grown/cannabis/ultimate
	genes = list(/datum/plant_gene/trait/repeated_harvest, /datum/plant_gene/trait/glow/green, /datum/plant_gene/trait/modified_volume/omega_weed)
	mutatelist = null
	reagents_add = list(/datum/reagent/drug/thc = 0.3, // NOVA EDIT CHANGE - MORE NARCOTICS - ORIGINAL: reagents_add = list(/datum/reagent/drug/cannabis = 0.3,
		/datum/reagent/toxin/mindbreaker = 0.3,
		/datum/reagent/mercury = 0.15,
		/datum/reagent/lithium = 0.15,
		/datum/reagent/medicine/atropine = 0.15,
		/datum/reagent/drug/methamphetamine = 0.15,
		/datum/reagent/drug/bath_salts = 0.15,
		/datum/reagent/drug/krokodil = 0.15,
		// /datum/reagent/toxin/lipolicide = 0.15, // NOVA EDIT REMOVAL - MORE NARCOTICS
		/datum/reagent/drug/nicotine = 0.1,
	)
	rarity = 69
	graft_gene = /datum/plant_gene/trait/glow/green

/obj/item/seeds/cannabis/anti
	name = "反杂草种子包"
	desc = "这些种子会长成反杂草。"
	icon_state = "seed-ocannabis"
	plant_icon_offset = 0
	icon_grow = "ocannabis-grow"
	species = "ocannabis"
	plantname = "Anti Weed"
	product = /obj/item/food/grown/cannabis/anti
	genes = list(/datum/plant_gene/trait/repeated_harvest, /datum/plant_gene/trait/glow/shadow)
	mutatelist = null
	reagents_add = list(/datum/reagent/medicine/naloxone = 0.3, /datum/reagent/medicine/antihol = 0.2, /datum/reagent/medicine/synaphydramine = 0.1)
	rarity = 40
	instability = 0

/obj/item/seeds/cannabis/anti/Initialize(mapload, nogenes)
	. = ..()
	add_atom_colour(COLOR_MATRIX_INVERT, FIXED_COLOUR_PRIORITY)
	transform = transform.Turn(180)

/obj/item/seeds/cannabis/anti/get_tray_overlay(age, status)
	var/mutable_appearance/plant = ..()
	plant.color = COLOR_MATRIX_INVERT
	return plant

// ---------------------------------------------------------------

/obj/item/food/grown/cannabis
	seed = /obj/item/seeds/cannabis
	icon = 'icons/obj/service/hydroponics/harvest.dmi'
	name = "大麻叶"
	desc = "最近在大多数星系合法化了。"
	icon_state = "cannabis"
	bite_consumption_mod = 4
	foodtypes = VEGETABLES //i dont really know what else weed could be to be honest
	tastes = list("cannabis" = 1)
	wine_power = 20

/obj/item/food/grown/cannabis/rainbow
	seed = /obj/item/seeds/cannabis/rainbow
	name = "彩虹大麻叶"
	desc = "它应该像那样发光...吗？"
	icon_state = "megacannabis"
	wine_power = 60

/obj/item/food/grown/cannabis/death
	seed = /obj/item/seeds/cannabis/death
	name = "死亡大麻叶"
	desc = "颜色看起来有点深。哦，好吧。"
	icon_state = "blackcannabis"
	wine_power = 40

/obj/item/food/grown/cannabis/white
	seed = /obj/item/seeds/cannabis/white
	name = "白色大麻叶"
	desc = "摸起来很顺滑。"
	icon_state = "whitecannabis"
	wine_power = 10

/obj/item/food/grown/cannabis/ultimate
	seed = /obj/item/seeds/cannabis/ultimate
	name = "欧米茄大麻叶"
	desc = "看着它你会头晕。搞什么鬼？"
	icon_state = "ocannabis"
	bite_consumption_mod = 2 // Ingesting like 40 units of drugs in 1 bite at 100 potency
	wine_power = 90

/obj/item/food/grown/cannabis/anti
	seed = /obj/item/seeds/cannabis/anti
	name = "反大麻叶"
	desc = "看着它你感觉很正常。这他妈是什么情况？"
	icon_state = "ocannabis"

/obj/item/food/grown/cannabis/anti/Initialize(mapload, obj/item/seeds/new_seed)
	. = ..()
	add_atom_colour(COLOR_MATRIX_INVERT, FIXED_COLOUR_PRIORITY)
	transform = transform.Turn(180)
	if(prob(0.05))
		name = "邪恶大麻叶"
