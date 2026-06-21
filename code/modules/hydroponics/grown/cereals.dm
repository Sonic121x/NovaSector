// Wheat
/obj/item/seeds/wheat
	name = "小麦种子包"
	desc = "这些种子可能会，也可能不会长成小麦。"
	icon_state = "seed-wheat"
	species = "wheat"
	plantname = "Wheat Stalks"
	product = /obj/item/food/grown/wheat
	production = 1
	yield = 4
	potency = 15
	instability = 20
	icon_dead = "wheat-dead"
	mutatelist = list(/obj/item/seeds/wheat/oat, /obj/item/seeds/wheat/meat)
	reagents_add = list(/datum/reagent/consumable/nutriment = 0.12)

/obj/item/food/grown/wheat
	seed = /obj/item/seeds/wheat
	name = "小麦"
	desc = "唉……小麦……一粒？"
	gender = PLURAL
	icon_state = "wheat"
	bite_consumption_mod = 0.5 // Chewing on wheat grains?
	foodtypes = GRAIN
	tastes = list("wheat" = 1)
	distill_reagent = /datum/reagent/consumable/ethanol/beer
	slot_flags = ITEM_SLOT_MASK
	worn_icon = 'icons/mob/clothing/head/hydroponics.dmi'

/obj/item/food/grown/wheat/grind_results()
	return list(/datum/reagent/consumable/flour = 0)

// Oat
/obj/item/seeds/wheat/oat
	name = "燕麦种子包"
	desc = "这些种子可能会，也可能不会长成燕麦。"
	icon_state = "seed-oat"
	species = "oat"
	plantname = "Oat Stalks"
	product = /obj/item/food/grown/oat
	mutatelist = null

/obj/item/food/grown/oat
	seed = /obj/item/seeds/wheat/oat
	name = "燕麦"
	desc = "吃燕麦，做深蹲。"
	gender = PLURAL
	icon_state = "oat"
	bite_consumption_mod = 0.5
	foodtypes = GRAIN
	tastes = list("oat" = 1)
	distill_reagent = /datum/reagent/consumable/ethanol/ale

/obj/item/food/grown/oat/grind_results()
	return list(/datum/reagent/consumable/flour = 0)

// Rice
/obj/item/seeds/wheat/rice
	name = "水稻种子包"
	desc = "这些种子可能会，也可能不会长成大米。"
	icon_state = "seed-rice"
	species = "rice"
	plantname = "Rice Stalks"
	instability = 1
	product = /obj/item/food/grown/rice
	mutatelist = null
	growthstages = 3
	genes = list(/datum/plant_gene/trait/semiaquatic)


/obj/item/food/grown/rice
	seed = /obj/item/seeds/wheat/rice
	name = "大米"
	desc = "很高兴认识米。"
	gender = PLURAL
	icon_state = "rice"
	bite_consumption_mod = 0.5
	foodtypes = GRAIN
	tastes = list("rice" = 1)
	distill_reagent = /datum/reagent/consumable/ethanol/sake

/obj/item/food/grown/rice/grind_results()
	return list(/datum/reagent/consumable/rice = 0)

//Meatwheat - grows into synthetic meat
/obj/item/seeds/wheat/meat
	name = "肉麦种子包"
	desc = "如果你曾想让一个素食者陷入疯狂，那么不妨试试下面这个方法。"
	icon_state = "seed-meatwheat"
	species = "meatwheat"
	plantname = "Meatwheat"
	product = /obj/item/food/grown/meatwheat
	mutatelist = null

/obj/item/food/grown/meatwheat
	name = "肉麦"
	desc = "一些沾满鲜血的麦秆。如果你使劲眯起眼睛，就能把它们压碎成类似肉状的东西。"
	icon_state = "meatwheat"
	gender = PLURAL
	bite_consumption_mod = 0.5
	seed = /obj/item/seeds/wheat/meat
	foodtypes = MEAT
	tastes = list("meatwheat" = 1)
	can_distill = FALSE
	slot_flags = ITEM_SLOT_MASK
	worn_icon = 'icons/mob/clothing/head/hydroponics.dmi'

/obj/item/food/grown/meatwheat/grind_results()
	return list(/datum/reagent/consumable/flour = 0, /datum/reagent/blood = 0)

/obj/item/food/grown/meatwheat/attack_self(mob/living/user)
	user.visible_message(span_notice("[user] 将 [src] 碾碎成了肉。"), span_notice("你将 [src] 碾碎成了类似肉的东西。"))
	playsound(user, 'sound/effects/blob/blobattack.ogg', 50, TRUE)
	var/obj/item/food/meat/slab/meatwheat/meaties = new(null)
	meaties.reagents.set_all_reagents_purity(seed.get_reagent_purity())
	qdel(src)
	user.put_in_hands(meaties)
	return TRUE
