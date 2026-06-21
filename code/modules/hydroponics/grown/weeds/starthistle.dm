// Starthistle
/obj/item/seeds/starthistle
	name = "星蓟种子包"
	desc = "一种强健的杂草，常常会在宇宙飞船停车场的缝隙中生长出来。"
	icon_state = "seed-starthistle"
	plant_icon_offset = 3
	species = "starthistle"
	plantname = "Starthistle"
	lifespan = 70
	endurance = 50 // damm pesky weeds
	maturation = 5
	production = 1
	yield = 2
	potency = 10
	instability = 35
	growthstages = 3
	growing_icon = 'icons/obj/service/hydroponics/growing_flowers.dmi'
	genes = list(/datum/plant_gene/trait/plant_type/weed_hardy)
	mutatelist = list(/obj/item/seeds/starthistle/corpse_flower, /obj/item/seeds/galaxythistle)
	graft_gene = /datum/plant_gene/trait/plant_type/weed_hardy

/obj/item/seeds/starthistle/harvest(mob/user)
	var/obj/machinery/hydroponics/parent = loc
	var/seed_count = yield
	if(prob(getYield() * 20))
		seed_count++
		var/output_loc = parent.Adjacent(user) ? user.loc : parent.loc
		for(var/i in 1 to seed_count)
			var/obj/item/seeds/starthistle/harvestseeds = Copy()
			harvestseeds.forceMove(output_loc)

	parent.update_tray(user, seed_count)

// Corpse flower
/obj/item/seeds/starthistle/corpse_flower
	name = "尸花种子包"
	desc = "一种会散发难闻的气味的植物。在恶劣的环境条件下，这种气味就会停止产生。"
	icon_state = "seed-corpse-flower"
	species = "corpse-flower"
	plantname = "Corpse flower"
	production = 2
	growing_icon = 'icons/obj/service/hydroponics/growing_flowers.dmi'
	genes = list(/datum/plant_gene/trait/gas_production)
	mutatelist = null
	reagents_add = list(/datum/reagent/toxin/formaldehyde = 0.1, /datum/reagent/fluorine = 0.1)

//Galaxy Thistle
/obj/item/seeds/galaxythistle
	name = "银河蓟种子包"
	desc = "一种令人瞩目的植物，据信是由简单的紫锥菊进化而来的。它含有黄烷醇类化合物，能够帮助修复受损的肝脏。"
	icon_state = "seed-galaxythistle"
	species = "galaxythistle"
	plantname = "Galaxythistle"
	product = /obj/item/food/grown/galaxythistle
	lifespan = 70
	endurance = 40
	maturation = 3
	production = 2
	yield = 2
	potency = 25
	instability = 35
	growthstages = 3
	growing_icon = 'icons/obj/service/hydroponics/growing_flowers.dmi'
	genes = list(/datum/plant_gene/trait/plant_type/weed_hardy, /datum/plant_gene/trait/invasive/galaxythistle)
	mutatelist = null
	reagents_add = list(/datum/reagent/consumable/nutriment = 0.05, /datum/reagent/medicine/silibinin = 0.1)
	graft_gene = /datum/plant_gene/trait/invasive

/obj/item/food/grown/galaxythistle
	seed = /obj/item/seeds/galaxythistle
	name = "星系蓟花头"
	desc = "这一簇带刺的花蕾让你联想到那片高地。"
	icon_state = "galaxythistle"
	bite_consumption_mod = 2
	foodtypes = VEGETABLES
	wine_power = 35
	tastes = list("thistle" = 2, "artichoke" = 1)
