// Grass
/obj/item/seeds/grass
	name = "草籽包"
	desc = "这些种子能长成草。美味！"
	icon_state = "seed-grass"
	species = "grass"
	plantname = "Grass"
	product = /obj/item/food/grown/grass
	lifespan = 40
	endurance = 40
	maturation = 2
	production = 5
	yield = 5
	instability = 10
	growthstages = 2
	icon_grow = "grass-grow"
	icon_dead = "grass-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest, /datum/plant_gene/trait/safe_instability)
	graft_gene = /datum/plant_gene/trait/safe_instability
	mutatelist = list(/obj/item/seeds/grass/carpet, /obj/item/seeds/grass/fairy)
	reagents_add = list(/datum/reagent/consumable/nutriment = 0.02, /datum/reagent/hydrogen = 0.05)

/obj/item/food/grown/grass
	seed = /obj/item/seeds/grass
	name = "grass"
	desc = "郁郁葱葱。"
	icon_state = "grassclump"
	bite_consumption_mod = 0.5 // Grazing on grass
	var/stacktype = /obj/item/stack/tile/grass
	var/tile_coefficient = 0.02 // 1/50
	wine_power = 15

/obj/item/food/grown/grass/attack_self(mob/user)
	to_chat(user, span_notice("你准备好了人造草皮。"))
	var/grassAmt = 1 + round(seed.potency * tile_coefficient) // The grass we're holding
	for(var/obj/item/food/grown/grass/G in user.loc) // The grass on the floor
		if(G.type != type)
			continue
		grassAmt += 1 + round(G.seed.potency * tile_coefficient)
		qdel(G)
	new stacktype(user.drop_location(), grassAmt)
	qdel(src)

/obj/item/food/grown/grass/make_dryable()
	AddElement(/datum/element/dryable, /obj/item/stack/tile/hay)

//Fairygrass
/obj/item/seeds/grass/fairy
	name = "仙灵草种子包"
	desc = "这些种子长成了一种更加神秘的草。"
	icon_state = "seed-fairygrass"
	species = "fairygrass"
	plantname = "Fairygrass"
	product = /obj/item/food/grown/grass/fairy
	icon_grow = "fairygrass-grow"
	icon_dead = "fairygrass-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest, /datum/plant_gene/trait/glow/blue, /datum/plant_gene/trait/safe_instability)
	reagents_add = list(/datum/reagent/consumable/nutriment = 0.02, /datum/reagent/hydrogen = 0.05, /datum/reagent/drug/space_drugs = 0.15)
	graft_gene = /datum/plant_gene/trait/glow/blue
	mutatelist = null

/obj/item/food/grown/grass/fairy
	seed = /obj/item/seeds/grass/fairy
	name = "fairygrass"
	desc = "蓝色，发光，并带有淡淡的蘑菇气味。"
	icon_state = "fairygrassclump"
	bite_consumption_mod = 1
	stacktype = /obj/item/stack/tile/fairygrass

// Carpet
/obj/item/seeds/grass/carpet
	name = "地毯草种子包"
	desc = "这些种子长成了一款款美观的地毯样品。"
	icon_state = "seed-carpet"
	species = "carpet"
	plantname = "Carpet"
	product = /obj/item/food/grown/grass/carpet
	mutatelist = null
	rarity = 10

/obj/item/food/grown/grass/carpet
	seed = /obj/item/seeds/grass/carpet
	name = "carpet"
	desc = "纺织业的隐秘真相。"
	icon_state = "carpetclump"
	stacktype = /obj/item/stack/tile/carpet
	can_distill = FALSE
