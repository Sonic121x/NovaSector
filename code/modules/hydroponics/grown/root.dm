// Carrot
/obj/item/seeds/carrot
	name = "胡萝卜种子包"
	desc = "能长成胡萝卜的种子。"
	icon_state = "seed-carrot"
	species = "carrot"
	plantname = "Carrots"
	product = /obj/item/food/grown/carrot
	maturation = 10
	production = 1
	yield = 5
	instability = 15
	growthstages = 3
	growing_icon = 'icons/obj/service/hydroponics/growing_vegetables.dmi'
	mutatelist = list(/obj/item/seeds/carrot/parsnip, /obj/item/seeds/carrot/cahnroot)
	reagents_add = list(/datum/reagent/medicine/oculine = 0.1, /datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.05)
	genes = list(/datum/plant_gene/trait/soil_lover)

/obj/item/food/grown/carrot
	seed = /obj/item/seeds/carrot
	name = "胡萝卜"
	desc = "胡萝卜对眼睛有好处！"
	icon_state = "carrot"
	bite_consumption_mod = 2
	foodtypes = VEGETABLES
	wine_power = 30

/obj/item/food/grown/carrot/juice_typepath()
	return /datum/reagent/consumable/carrotjuice

/obj/item/food/grown/carrot/attackby(obj/item/I, mob/user, list/modifiers, list/attack_modifiers)
	if(!I.get_sharpness())
		return ..()

	/// The blade carrot will turn into once sharpened
	var/obj/item/carrot_blade
	/// Chance for it to become a sword rather than a shiv
	var/carrot_sword_chance = (max(0, seed.potency - 50) / 50)
	if (prob(carrot_sword_chance))
		carrot_blade = new /obj/item/claymore/carrot
		to_chat(user, span_notice("你用[I]将胡萝卜削成了一把剑。"))
	else
		carrot_blade = new /obj/item/knife/shiv/carrot
		to_chat(user, span_notice("你用[I]将胡萝卜削成了一把简易匕首。"))
	remove_item_from_storage(user)
	qdel(src)
	user.put_in_hands(carrot_blade)

// Parsnip
/obj/item/seeds/carrot/parsnip
	name = "欧防风种子包"
	desc = "能长成防风草的种子。"
	icon_state = "seed-parsnip"
	species = "parsnip"
	plantname = "Parsnip"
	product = /obj/item/food/grown/parsnip
	icon_dead = "carrot-dead"
	mutatelist = null
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.05, /datum/reagent/consumable/nutriment = 0.05, /datum/reagent/aluminium = 0.05)

/obj/item/food/grown/parsnip
	seed = /obj/item/seeds/carrot/parsnip
	name = "parsnip"
	desc = "和胡萝卜关系很近。"
	icon_state = "parsnip"
	foodtypes = VEGETABLES
	wine_power = 35

/obj/item/food/grown/parsnip/juice_typepath()
	return /datum/reagent/consumable/parsnipjuice

/obj/item/food/grown/parsnip/attackby(obj/item/I, mob/user, list/modifiers, list/attack_modifiers)
	if(!I.get_sharpness())
		return ..()

	/// The blade parsnip will turn into once sharpened
	var/obj/item/parsnip_blade
	/// Chance for it to become a sabre rather than a shiv
	var/parsnip_sabre_chance = (max(0, seed.potency - 50) / 50)
	if (prob(parsnip_sabre_chance))
		parsnip_blade = new /obj/item/melee/parsnip_sabre
		to_chat(user, span_notice("你用[I]将欧防风削成了一把军刀。"))
	else
		parsnip_blade = new /obj/item/knife/shiv/parsnip
		to_chat(user, span_notice("你用[I]将欧防风削成了一把简易匕首。"))
	remove_item_from_storage(user)
	qdel(src)
	user.put_in_hands(parsnip_blade)


// Cahn'root
/obj/item/seeds/carrot/cahnroot
	name = "卡恩根种子包"
	desc = "这些种子会长成卡恩根。"
	icon_state = "seed-cahn'root"
	species = "cahn'root"
	plantname = "Cahn'root"
	product = /obj/item/food/grown/cahnroot
	genes = list(/datum/plant_gene/trait/soil_lover, /datum/plant_gene/trait/plant_type/weed_hardy)
	endurance = 50
	instability = 10
	icon_dead = "cahn'root-dead"
	mutatelist = null
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.05, /datum/reagent/consumable/nutriment = 0.05, /datum/reagent/cellulose = 0.01, /datum/reagent/consumable/sugar = 0.01)
	rarity = 10
	graft_gene = /datum/plant_gene/trait/plant_type/weed_hardy

/obj/item/food/grown/cahnroot
	seed = /obj/item/seeds/carrot/cahnroot
	name = "卡恩根"
	desc = "地球胡萝卜的重度改良版本，最初由飞蛾舰队一位富有进取精神的科学家卡恩·曼格培育，旨在最恶劣的环境中生存。"
	icon_state = "cahn'root"
	foodtypes = VEGETABLES
	tastes = list("sweet dirt" = 1)
	distill_reagent = /datum/reagent/consumable/rootbeer

/obj/item/food/grown/cahnroot/juice_typepath()
	return null

/obj/item/food/grown/cahnroot/attackby(obj/item/I, mob/user, list/modifiers, list/attack_modifiers)
	if(!I.get_sharpness())
		return ..()

	/// The blade cahn'root will turn into once sharpened
	var/obj/item/knife/root_blade
	/// Chance for it to become a dagger rather than a shiv
	var/root_dagger_chance = (max(0, seed.potency - 25) / 50)
	if (prob(root_dagger_chance))
		root_blade = new /obj/item/knife/combat/root
		to_chat(user, span_notice("你用[I]将卡恩根削成了一把匕首。"))
	else
		root_blade = new /obj/item/knife/shiv/root
		to_chat(user, span_notice("你用[I]将卡恩根削成了一把简易匕首。"))
	remove_item_from_storage(user)
	qdel(src)
	user.put_in_hands(root_blade)

// White-Beet
/obj/item/seeds/whitebeet
	name = "白甜菜种子包"
	desc = "这些种子能长成用来产糖的甜菜。"
	icon_state = "seed-whitebeet"
	species = "whitebeet"
	plantname = "White-Beet Plants"
	product = /obj/item/food/grown/whitebeet
	lifespan = 60
	endurance = 50
	yield = 6
	instability = 10
	growing_icon = 'icons/obj/service/hydroponics/growing_vegetables.dmi'
	icon_dead = "whitebeet-dead"
	genes = list(/datum/plant_gene/trait/soil_lover)
	mutatelist = list(/obj/item/seeds/redbeet)
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/sugar = 0.2, /datum/reagent/consumable/nutriment = 0.05)

/obj/item/food/grown/whitebeet
	seed = /obj/item/seeds/whitebeet
	name = "白甜菜"
	desc = "你绝对战胜不了白天才。"
	icon_state = "whitebeet"
	bite_consumption_mod = 3
	foodtypes = VEGETABLES
	wine_power = 40

// Red Beet
/obj/item/seeds/redbeet
	name = "红甜菜种子包"
	desc = "这些种子能长成用来产糖的红甜菜。"
	icon_state = "seed-redbeet"
	species = "redbeet"
	plantname = "Red-Beet Plants"
	product = /obj/item/food/grown/redbeet
	lifespan = 60
	endurance = 50
	yield = 5
	instability = 15
	growing_icon = 'icons/obj/service/hydroponics/growing_vegetables.dmi'
	icon_dead = "whitebeet-dead"
	genes = list(/datum/plant_gene/trait/soil_lover, /datum/plant_gene/trait/maxchem)
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.05, /datum/reagent/consumable/nutriment = 0.05)
	graft_gene = /datum/plant_gene/trait/maxchem

/obj/item/food/grown/redbeet
	seed = /obj/item/seeds/redbeet
	name = "红甜菜"
	desc = "你绝对战胜不了超天才。"
	icon_state = "redbeet"
	bite_consumption_mod = 2
	foodtypes = VEGETABLES
	wine_power = 60
