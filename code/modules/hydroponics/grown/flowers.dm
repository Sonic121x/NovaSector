// Poppy
/obj/item/seeds/poppy
	name = "罂粟种子包"
	desc = "这些种子能长成罂粟。"
	icon_state = "seed-poppy"
	species = "poppy"
	plantname = "Poppy Plants"
	product = /obj/item/food/grown/poppy
	endurance = 10
	maturation = 8
	yield = 6
	potency = 20
	instability = 1 //Flowers have 1 instability, if you want to breed out instability, crossbreed with flowers.
	growthstages = 3
	growing_icon = 'icons/obj/service/hydroponics/growing_flowers.dmi'
	icon_grow = "poppy-grow"
	icon_dead = "poppy-dead"
	genes = list(/datum/plant_gene/trait/preserved, /datum/plant_gene/trait/opium_production)
	mutatelist = list(/obj/item/seeds/poppy/geranium, /obj/item/seeds/poppy/lily)
	reagents_add = list(/datum/reagent/medicine/c2/libital = 0.2, /datum/reagent/consumable/nutriment = 0.05)

/obj/item/food/grown/poppy
	seed = /obj/item/seeds/poppy
	name = "罂粟"
	desc = "长久以来用作放松、和平和死亡的象征。"
	icon_state = "poppy"
	slot_flags = ITEM_SLOT_HEAD
	alternate_worn_layer = ABOVE_BODY_FRONT_HEAD_LAYER
	bite_consumption_mod = 2
	foodtypes = VEGETABLES | GROSS
	distill_reagent = /datum/reagent/consumable/ethanol/vermouth

// Lily
/obj/item/seeds/poppy/lily
	name = "百合种子包"
	desc = "能长成百合的种子。"
	icon_state = "seed-lily"
	species = "lily"
	plantname = "Lily Plants"
	product = /obj/item/food/grown/poppy/lily
	growthstages = 3
	growing_icon = 'icons/obj/service/hydroponics/growing_flowers.dmi'
	icon_grow = "lily-grow"
	icon_dead = "lily-dead"
	genes = list(/datum/plant_gene/trait/preserved)
	mutatelist = list(/obj/item/seeds/poppy/lily/trumpet)

/obj/item/food/grown/poppy/lily
	seed = /obj/item/seeds/poppy/lily
	name = "百合"
	desc = "一朵美丽的白色花朵。"
	icon_state = "lily"

	//Spacemans's Trumpet
/obj/item/seeds/poppy/lily/trumpet
	name = "太空人喇叭花种子包"
	desc = "一种经过广泛基因工程改造的植物。据说太空人喇叭花与其野生祖先毫无相似之处。在NT AgriSci内部，它更广为人知的代号是NTPW-0372。"
	icon_state = "seed-trumpet"
	species = "spacemanstrumpet"
	plantname = "Spaceman's Trumpet Plant"
	product = /obj/item/food/grown/trumpet
	lifespan = 80
	production = 5
	endurance = 10
	maturation = 12
	yield = 4
	potency = 20
	growthstages = 4
	weed_rate = 2
	weed_chance = 10
	growing_icon = 'icons/obj/service/hydroponics/growing_flowers.dmi'
	icon_grow = "spacemanstrumpet-grow"
	icon_dead = "spacemanstrumpet-dead"
	mutatelist = null
	genes = list(/datum/plant_gene/trait/preserved, /datum/plant_gene/reagent/preset/polypyr)
	reagents_add = list(/datum/reagent/consumable/nutriment = 0.05)
	rarity = 30
	graft_gene = /datum/plant_gene/reagent/preset/polypyr

/obj/item/food/grown/trumpet
	seed = /obj/item/seeds/poppy/lily/trumpet
	name = "太空人喇叭"
	desc = "一朵鲜艳的花朵，散发着淡淡的刚割草的气味。触摸这朵花后，有时会在接触部位留下痕迹，但大多数其他表面似乎不受此现象的影响。"
	icon_state = "spacemanstrumpet"
	bite_consumption_mod = 2
	foodtypes = VEGETABLES

// Geranium
/obj/item/seeds/poppy/geranium
	name = "天竺葵种子包"
	desc = "能长成天竺葵的种子"
	icon_state = "seed-geranium"
	species = "geranium"
	plantname = "Geranium Plants"
	product = /obj/item/food/grown/poppy/geranium
	growthstages = 3
	growing_icon = 'icons/obj/service/hydroponics/growing_flowers.dmi'
	icon_grow = "geranium-grow"
	icon_dead = "geranium-dead"
	genes = list(/datum/plant_gene/trait/preserved)
	mutatelist = list(/obj/item/seeds/poppy/geranium/fraxinella)

/obj/item/food/grown/poppy/geranium
	seed = /obj/item/seeds/poppy/geranium
	name = "天竺葵"
	desc = "一朵美丽的蓝色花朵。"
	icon_state = "geranium"

///Fraxinella seeds.
/obj/item/seeds/poppy/geranium/fraxinella
	name = "白鲜种子包"
	desc = "能长成瓦斯花的种子。"
	icon_state = "seed-fraxinella"
	species = "fraxinella"
	plantname = "Fraxinella Plants"
	product = /obj/item/food/grown/poppy/geranium/fraxinella
	mutatelist = null
	rarity = 15
	reagents_add = list(/datum/reagent/consumable/nutriment = 0.05, /datum/reagent/fuel/oil = 0.05)
	graft_gene = /datum/plant_gene/trait/preserved

///Fraxinella Flowers.
/obj/item/food/grown/poppy/geranium/fraxinella
	seed = /obj/item/seeds/poppy/geranium/fraxinella
	name = "瓦斯花"
	desc = "一朵美丽的浅粉色花朵。"
	icon_state = "fraxinella"
	distill_reagent = /datum/reagent/ash

// Harebell
/obj/item/seeds/harebell
	name = "风铃草种子包"
	desc = "能长成海拉贝尔花的种子"
	icon_state = "seed-harebell"
	plant_icon_offset = 1
	species = "harebell"
	plantname = "Harebells"
	product = /obj/item/food/grown/harebell
	lifespan = 100
	endurance = 20
	maturation = 7
	production = 1
	yield = 2
	potency = 30
	instability = 1
	growthstages = 4
	genes = list(/datum/plant_gene/trait/plant_type/weed_hardy, /datum/plant_gene/trait/preserved)
	growing_icon = 'icons/obj/service/hydroponics/growing_flowers.dmi'
	reagents_add = list(/datum/reagent/consumable/nutriment = 0.04)
	graft_gene = /datum/plant_gene/trait/plant_type/weed_hardy

/obj/item/food/grown/harebell
	seed = /obj/item/seeds/harebell
	name = "海拉贝尔"
	desc = "“我会让你的这座凄凉的坟墓变得温馨起来：你不会缺少与你面容相配的花朵，那就是淡雅的蒲公英，还有像你血管色泽一样的蓝色风铃草；当然，还有紫罗兰的叶子，千万别诋毁它，因为它比你的气息还要芬芳。”"
	icon_state = "harebell"
	slot_flags = ITEM_SLOT_HEAD
	alternate_worn_layer = ABOVE_BODY_FRONT_HEAD_LAYER
	bite_consumption_mod = 2
	distill_reagent = /datum/reagent/consumable/ethanol/vermouth

// Sunflower
/obj/item/seeds/sunflower
	name = "向日葵种子包"
	desc = "能长成向日葵的种子。"
	icon_state = "seed-sunflower"
	species = "sunflower"
	plantname = "Sunflowers"
	product = /obj/item/food/grown/sunflower
	genes = list(/datum/plant_gene/trait/attack/sunflower_attack, /datum/plant_gene/trait/preserved)
	endurance = 20
	production = 2
	yield = 2
	instability = 1
	growthstages = 3
	growing_icon = 'icons/obj/service/hydroponics/growing_flowers.dmi'
	icon_grow = "sunflower-grow"
	icon_dead = "sunflower-dead"
	mutatelist = list(/obj/item/seeds/sunflower/moonflower, /obj/item/seeds/sunflower/novaflower)
	reagents_add = list(/datum/reagent/consumable/nutriment/fat/oil = 0.08, /datum/reagent/consumable/nutriment = 0.04)

/obj/item/food/grown/sunflower // FLOWER POWER!
	seed = /obj/item/seeds/sunflower
	name = "向日葵"
	desc = "真美啊！要是你把这些踩坏了，说不定某个人会把你给打死了呢。"
	icon_state = "sunflower"
	inhand_icon_state = "sunflower"
	lefthand_file = 'icons/mob/inhands/weapons/plants_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/plants_righthand.dmi'
	foodtypes = VEGETABLES
	damtype = BURN
	force = 0
	slot_flags = ITEM_SLOT_HEAD
	alternate_worn_layer = ABOVE_BODY_FRONT_HEAD_LAYER
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 1
	throw_range = 3

/obj/item/food/grown/sunflower/make_dryable()
	AddElement(/datum/element/dryable, /obj/item/food/semki/healthy) //yum

// Moonflower
/obj/item/seeds/sunflower/moonflower
	name = "月光花种子包"
	desc = "能长成向月葵的种子。"
	icon_state = "seed-moonflower"
	lefthand_file = 'icons/mob/inhands/items/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/food_righthand.dmi'
	species = "moonflower"
	plantname = "Moonflowers"
	icon_grow = "moonflower-grow"
	icon_dead = "sunflower-dead"
	product = /obj/item/food/grown/moonflower
	genes = list(/datum/plant_gene/trait/glow/purple, /datum/plant_gene/trait/preserved)
	mutatelist = null
	reagents_add = list(/datum/reagent/consumable/ethanol/moonshine = 0.2, /datum/reagent/consumable/nutriment/vitamin = 0.02, /datum/reagent/consumable/nutriment = 0.02)
	rarity = 15
	graft_gene = /datum/plant_gene/trait/glow/purple

/obj/item/food/grown/moonflower
	seed = /obj/item/seeds/sunflower/moonflower
	name = "向月葵"
	desc = "将其存放在距离狼人至少 50 码远的地方。"
	icon_state = "moonflower"
	inhand_icon_state = "moonflower"
	slot_flags = ITEM_SLOT_HEAD
	alternate_worn_layer = ABOVE_BODY_FRONT_HEAD_LAYER
	distill_reagent = /datum/reagent/consumable/ethanol/absinthe //It's made from flowers.

// Novaflower
/obj/item/seeds/sunflower/novaflower
	name = "新星花种子包"
	desc = "能长成烈焰葵的种子。"
	icon_state = "seed-novaflower"
	species = "novaflower"
	plantname = "Novaflowers"
	icon_grow = "novaflower-grow"
	icon_dead = "sunflower-dead"
	product = /obj/item/grown/novaflower
	genes = list(/datum/plant_gene/trait/backfire/novaflower_heat, /datum/plant_gene/trait/attack/novaflower_attack, /datum/plant_gene/trait/preserved)
	mutatelist = null
	reagents_add = list(/datum/reagent/consumable/condensedcapsaicin = 0.25, /datum/reagent/consumable/capsaicin = 0.3, /datum/reagent/consumable/nutriment = 0, /datum/reagent/toxin/acid = 0.05)
	rarity = PLANT_MODERATELY_RARE

/obj/item/grown/novaflower
	seed = /obj/item/seeds/sunflower/novaflower
	name = "\improper 烈焰葵"
	desc = "这些美丽的花朵散发着清新的烟熏香气，宛如夏日篝火的芬芳。"
	icon_state = "novaflower"
	inhand_icon_state = "novaflower"
	lefthand_file = 'icons/mob/inhands/weapons/plants_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/plants_righthand.dmi'
	damtype = BURN
	force = 0
	slot_flags = ITEM_SLOT_HEAD
	alternate_worn_layer = ABOVE_BODY_FRONT_HEAD_LAYER
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 1
	throw_range = 3
	attack_verb_continuous = list("roasts", "scorches", "burns")
	attack_verb_simple = list("roast", "scorch", "burn")

/obj/item/grown/novaflower/grind_results()
	return list(/datum/reagent/consumable/capsaicin = 0, /datum/reagent/consumable/condensedcapsaicin = 0)

// Rose
/obj/item/seeds/rose
	name = "玫瑰种子包"
	desc = "能长成玫瑰的种子。"
	icon_state = "seed-rose"
	species = "rose"
	plantname = "Rose Bush"
	product = /obj/item/food/grown/rose
	endurance = 12
	yield = 6
	potency = 15
	instability = 20 //Roses crossbreed easily, and there's many many species of them.
	growthstages = 3
	genes = list(/datum/plant_gene/trait/repeated_harvest, /datum/plant_gene/trait/backfire/rose_thorns, /datum/plant_gene/trait/preserved)
	growing_icon = 'icons/obj/service/hydroponics/growing_flowers.dmi'
	icon_grow = "rose-grow"
	icon_dead = "rose-dead"
	mutatelist = list(/obj/item/seeds/carbon_rose)
	//Roses are commonly used as herbal medicines (diarrhodons) and for their 'rose oil'.
	reagents_add = list(/datum/reagent/consumable/nutriment = 0.05, /datum/reagent/medicine/granibitaluri = 0.1, /datum/reagent/fuel/oil = 0.05)

/obj/item/food/grown/rose
	seed = /obj/item/seeds/rose
	name = "\improper 玫瑰"
	desc = "经典的“爱之花”——爱的花朵。要小心它的刺哦！"
	base_icon_state = "rose"
	icon_state = "rose"
	inhand_icon_state = "rose"
	worn_icon_state = "rose"
	lefthand_file = 'icons/mob/inhands/items/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/food_righthand.dmi'
	slot_flags = ITEM_SLOT_HEAD | ITEM_SLOT_MASK
	alternate_worn_layer = ABOVE_BODY_FRONT_HEAD_LAYER
	bite_consumption_mod = 2
	foodtypes = VEGETABLES | GROSS

/obj/item/food/grown/rose/equipped(mob/user, slot, initial)
	. = ..()
	if(slot & ITEM_SLOT_MASK)
		worn_icon_state = "[base_icon_state]_mouth"
		user.update_worn_mask()
	else
		worn_icon_state = base_icon_state
		user.update_worn_head()

// Carbon Rose
/obj/item/seeds/carbon_rose
	name = "碳玫瑰种子包"
	desc = "能长成碳玫瑰的种子。"
	icon_state = "seed-carbonrose"
	species = "carbonrose"
	plantname = "Carbon Rose Flower"
	product = /obj/item/grown/carbon_rose
	endurance = 12
	yield = 6
	potency = 15
	instability = 3
	growthstages = 3
	genes = list(/datum/plant_gene/reagent/preset/carbon, /datum/plant_gene/trait/preserved)
	growing_icon = 'icons/obj/service/hydroponics/growing_flowers.dmi'
	icon_grow = "carbonrose-grow"
	icon_dead = "carbonrose-dead"
	reagents_add = list(/datum/reagent/plastic_polymers = 0.05)
	rarity = 10
	graft_gene = /datum/plant_gene/reagent/preset/carbon

/obj/item/grown/carbon_rose
	seed = /obj/item/seeds/carbon_rose
	name = "碳玫瑰"
	desc = "全新推出的“爱之花”灰色款——这朵代表爱的花朵，经过现代化改良，已不再有刺了。"
	icon_state = "carbonrose"
	lefthand_file = 'icons/mob/inhands/weapons/plants_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/plants_righthand.dmi'
	force = 0
	throwforce = 0
	slot_flags = ITEM_SLOT_HEAD
	alternate_worn_layer = ABOVE_BODY_FRONT_HEAD_LAYER
	throw_speed = 1
	throw_range = 3
