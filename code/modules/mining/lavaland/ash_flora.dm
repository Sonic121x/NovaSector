//*******************Contains everything related to the flora on lavaland.*******************************
//This includes: The structures, their produce, their seeds and the crafting recipe for the mushroom bowl

/obj/structure/flora/ash
	name = "大蘑菇"
	desc = "有许多硕大的蘑菇，表面覆盖着一层淡淡的灰烬以及只能是孢子的物质。"
	icon = 'icons/obj/mining_zones/ash_flora.dmi'
	icon_state = "l_mushroom1"
	base_icon_state = "l_mushroom"
	resistance_flags = LAVA_PROOF
	gender = PLURAL
	layer = PROJECTILE_HIT_THRESHHOLD_LAYER //sporangiums up don't shoot
	harvest_with_hands = TRUE
	harvested_name = "shortened mushrooms"
	harvested_desc = "Some quickly regrowing mushrooms, formerly known to be quite large."
	harvest_message_low = "You pick a mushroom, but fail to collect many shavings from its cap."
	harvest_message_med = "You pick a mushroom, carefully collecting the shavings from its cap."
	harvest_message_high = "You harvest and collect shavings from several mushroom caps."
	harvest_message_true_thresholds = TRUE
	harvest_verb = "pluck"
	flora_flags = FLORA_HERBAL //not really accurate but what sound do hit mushrooms make anyway
	var/number_of_variants = 4

/obj/structure/flora/ash/Initialize(mapload)
	. = ..()
	base_icon_state = "[base_icon_state][rand(1, number_of_variants)]"
	icon_state = base_icon_state

/obj/structure/flora/ash/get_potential_products()
	return list(/obj/item/food/grown/ash_flora/shavings = 1)

/obj/structure/flora/ash/harvest(user, product_amount_multiplier)
	if(!..())
		return FALSE
	icon_state = "[base_icon_state]p"
	return TRUE

/obj/structure/flora/ash/regrow()
	..()
	icon_state = base_icon_state

/obj/structure/flora/ash/tall_shroom //exists only so that the spawning check doesn't allow these spawning near other things
	regrowth_time_low = 7 MINUTES

/obj/structure/flora/ash/leaf_shroom
	name = "长叶蘑菇"
	desc = "有许多蘑菇，每一种蘑菇周围都环绕着一个带有若干片叶状结构的绿色孢子囊。"
	icon_state = "s_mushroom1"
	base_icon_state = "s_mushroom"
	harvested_name = "leafless mushrooms"
	harvested_desc = "A bunch of formerly-leafed mushrooms, with their sporangiums exposed. Scandalous?"
	harvest_amount_high = 4
	harvest_message_low = "You pluck a single, suitable leaf."
	harvest_message_med = "You pluck a number of leaves, leaving a few unsuitable ones."
	harvest_message_high = "You pluck quite a lot of suitable leaves."
	harvest_time = 20
	regrowth_time_low = 4 MINUTES
	regrowth_time_high = 10 MINUTES

/obj/structure/flora/ash/leaf_shroom/get_potential_products()
	return list(/obj/item/food/grown/ash_flora/mushroom_leaf = 1)

/obj/structure/flora/ash/cap_shroom
	name = "高大蘑菇"
	desc = "有几种蘑菇，其中较大的那些在菌柄的中部都有一个菌盖环。"
	icon_state = "r_mushroom1"
	base_icon_state = "r_mushroom"
	harvested_name = "small mushrooms"
	harvested_desc = "Several small mushrooms near the stumps of what likely were larger mushrooms."
	harvest_amount_high = 4
	harvest_message_low = "You slice the cap off a mushroom."
	harvest_message_med = "You slice off a few conks from the larger mushrooms."
	harvest_message_high = "You slice off a number of caps and conks from these mushrooms."
	harvest_time = 50
	regrowth_time_low = 5 MINUTES
	regrowth_time_high = 9 MINUTES

/obj/structure/flora/ash/cap_shroom/get_potential_products()
	return list(/obj/item/food/grown/ash_flora/mushroom_cap = 1)

/obj/structure/flora/ash/stem_shroom
	name = "大量蘑菇"
	desc = "大量的蘑菇，其中有些有着长长的、多汁的茎部。它们正在发出光芒！"
	icon_state = "t_mushroom1"
	base_icon_state = "t_mushroom"
	light_range = 1.5
	light_power = 2.1
	harvested_name = "tiny mushrooms"
	harvested_desc = "A few tiny mushrooms around larger stumps. You can already see them growing back."
	harvest_amount_high = 4
	harvest_message_low = "You pick and slice the cap off a mushroom, leaving the stem."
	harvest_message_med = "You pick and decapitate several mushrooms for their stems."
	harvest_message_high = "You acquire a number of stems from these mushrooms."
	harvest_time = 40
	regrowth_time_low = 5 MINUTES
	regrowth_time_high = 10 MINUTES

/obj/structure/flora/ash/stem_shroom/get_potential_products()
	return list(/obj/item/food/grown/ash_flora/mushroom_stem = 1)

/obj/structure/flora/ash/cacti
	name = "水果仙人掌"
	desc = "几株多刺的仙人掌，果实已成熟饱满，表面覆盖着一层薄薄的灰烬。"
	icon_state = "cactus1"
	base_icon_state = "cactus"
	harvested_name = "cacti"
	harvested_desc = "A bunch of prickly cacti. You can see fruits slowly growing beneath the covering of ash."
	harvest_amount_high = 2
	harvest_message_low = "You pick a cactus fruit."
	harvest_message_med = "You pick several cactus fruit." //shouldn't show up, because you can't get more than two
	harvest_message_high = "You pick a pair of cactus fruit."
	harvest_time = 10
	regrowth_time_low = 8 MINUTES
	regrowth_time_high = 12 MINUTES
	can_uproot = FALSE //Don't want 50 in one tile to decimate whoever dare step on the mass of cacti

/obj/structure/flora/ash/cacti/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/caltrop, min_damage = 3, max_damage = 6, probability = 70)

/obj/structure/flora/ash/cacti/get_potential_products()
	return list(/obj/item/food/grown/ash_flora/cactus_fruit = 20, /obj/item/seeds/lavaland/cactus = 1)

/obj/structure/flora/ash/seraka
	name = "蛇栗菇"
	desc = "一小簇蛇栗菇蘑菇。这些肯定是随阿什利蜥蜴一同带来的。"
	icon_state = "seraka_mushroom1"
	base_icon_state = "seraka_mushroom"
	harvested_name = "harvested seraka mushrooms"
	harvested_desc = "A couple of small seraka mushrooms, with the larger ones clearly having been recently removed. They'll grow back... eventually."
	harvest_amount_high = 6
	harvest_message_low = "You pluck a few choice tasty mushrooms."
	harvest_message_med = "You grab a good haul of mushrooms."
	harvest_message_high = "You hit the mushroom motherlode and make off with a bunch of tasty mushrooms."
	harvest_time = 25
	regrowth_time_low = 5 MINUTES
	regrowth_time_high = 9 MINUTES
	number_of_variants = 2
	harvest_message_true_thresholds = FALSE

/obj/structure/flora/ash/seraka/get_potential_products()
	return list(/obj/item/food/grown/ash_flora/seraka = 1)

/obj/structure/flora/ash/fireblossom
	name = "火焰花"
	desc = "一种奇特的、常见于熔岩体附近生长的花朵。"
	icon_state = "fireblossom1"
	base_icon_state = "fireblossom"
	light_range = LIGHT_FIRE_BLOSSOM
	light_power = LIGHT_FIRE_BLOSSOM
	light_color = COLOR_BIOLUMINESCENCE_YELLOW
	harvested_name = "fire blossom stems"
	harvested_desc = "A few fire blossom stems, missing their flowers."
	harvest_amount_high = 3
	harvest_message_low = "You pluck a single, suitable flower."
	harvest_message_med = "You pluck a number of flowers, leaving a few unsuitable ones."
	harvest_message_high = "You pluck quite a lot of suitable flowers."
	regrowth_time_low = 4 MINUTES
	regrowth_time_high = 7 MINUTES
	number_of_variants = 2

/obj/structure/flora/ash/fireblossom/get_potential_products()
	return list(/obj/item/food/grown/ash_flora/fireblossom = 1)

/obj/structure/flora/ash/fireblossom/after_harvest()
	set_light_power(LIGHT_RANGE_FIRE_BLOSSOM_HARVESTED)
	set_light_range(LIGHT_POWER_FIRE_BLOSSOM_HARVESTED)
	update_light()
	return ..()

/obj/structure/flora/ash/fireblossom/regrow()
	set_light_power(initial(light_power))
	set_light_range(initial(light_range))
	update_light()
	return ..()

/obj/structure/flora/ash/glowgrowth
	name = "glowgrowth colony"
	desc = "A colony of bioluminescent fungi growing on a hot air vent, feeding off mineral particulate blowing through it."
	icon_state = "glowgrowth1"
	base_icon_state = "glowgrowth"
	density = TRUE // Large rock formations with plants ontop
	light_range = 1.7
	light_power = 1.2
	light_color = "#67b6a5"
	harvested_name = "hot air vent"
	harvested_desc = "A ridged porous rock formation exuming hot air from the depths of the planet."
	harvest_amount_high = 4
	harvest_verb = "scrape"
	harvest_message_low = "You scrape off a thin layer of glowing fungi."
	harvest_message_med = "You pick a sizeable patch of glowing fungi."
	harvest_message_high = "You grab a large fistful of glowing fungi."
	regrowth_time_low = 8 MINUTES
	regrowth_time_high = 16 MINUTES
	number_of_variants = 3

/obj/structure/flora/ash/glowgrowth/Initialize(mapload)
	. = ..()
	update_appearance()

/obj/structure/flora/ash/glowgrowth/get_potential_products()
	return list(/obj/item/food/grown/ash_flora/glowgrowth = 1)

/obj/structure/flora/ash/glowgrowth/after_harvest()
	set_light_on(FALSE)
	update_light()
	update_appearance()
	return ..()

/obj/structure/flora/ash/glowgrowth/regrow()
	set_light_on(TRUE)
	update_light()
	update_appearance()
	return ..()

/obj/structure/flora/ash/glowgrowth/update_overlays()
	. = ..()
	if (!harvested)
		. += emissive_appearance(icon, "[icon_state]e", src, alpha = 120)

///Snow flora to exist on icebox.
/obj/structure/flora/ash/chilly
	name = "富有弹性的青草状果实"
	desc = "有许多色泽鲜艳、富有弹性的蓝色果实植物。它们似乎并不在意严寒的寒冷环境。"
	icon_state = "chilly_pepper1"
	base_icon_state = "chilly_pepper"
	harvested_name = "springy grass"
	harvested_desc = "A bunch of springy, bouncy fruiting grass, all picked. Or maybe they were never fruiting at all?"
	harvest_amount_high = 3
	harvest_message_low = "You pluck a single, curved fruit."
	harvest_message_med = "You pluck a number of curved fruit."
	harvest_message_high = "You pluck quite a lot of curved fruit."
	harvest_time = 15
	regrowth_time_low = 2400
	regrowth_time_high = 5500
	number_of_variants = 2

/obj/structure/flora/ash/chilly/get_potential_products()
	return list(/obj/item/food/grown/icepepper = 1)

//SNACKS

/obj/item/food/grown/ash_flora
	name = "蘑菇屑"
	desc = "一根高大蘑菇的几片屑。如果数量足够的话，或许可以用来做成一个碗。"
	icon = 'icons/obj/mining_zones/ash_flora.dmi'
	icon_state = "mushroom_shavings"
	abstract_type = /obj/item/food/grown/ash_flora
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE
	max_integrity = 100
	seed = /obj/item/seeds/lavaland/polypore
	wine_power = 20
	foodtypes = VEGETABLES

/obj/item/food/grown/ash_flora/Initialize(mapload)
	. = ..()
	pixel_x = base_pixel_x + rand(-4, 4)
	pixel_y = base_pixel_y + rand(-4, 4)

/obj/item/food/grown/ash_flora/shavings/grind_results()
	return list(/datum/reagent/toxin/mushroom_powder = 5)

/obj/item/food/grown/ash_flora/mushroom_leaf
	name = "蘑菇叶"
	desc = "一片蘑菇上的叶子。"
	icon_state = "mushroom_leaf"
	seed = /obj/item/seeds/lavaland/porcini
	wine_power = 40

/obj/item/food/grown/ash_flora/mushroom_cap
	name = "菇帽"
	desc = "大蘑菇的菇帽。"
	icon_state = "mushroom_cap"
	seed = /obj/item/seeds/lavaland/inocybe
	wine_power = 70

/obj/item/food/grown/ash_flora/mushroom_stem
	name = "菇柄"
	desc = "一根长长的菇柄。它闪着微光。"
	icon_state = "mushroom_stem"
	seed = /obj/item/seeds/lavaland/ember
	wine_power = 60

/obj/item/food/grown/ash_flora/cactus_fruit
	name = "仙人掌果实"
	desc = "一个长满了厚厚的、略带红色外皮的仙人掌果实，上面还沾有一些灰烬。"
	icon_state = "cactus_fruit"
	seed = /obj/item/seeds/lavaland/cactus
	wine_power = 50
	foodtypes = FRUIT

/obj/item/food/grown/ash_flora/cactus_fruit/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/raptor_food, growth_modifier = 0.1, ability_modifier = -0.05)

/obj/item/food/grown/ash_flora/seraka
	name = "蛇栗菇"
	desc = "小巧而味道浓郁的蘑菇，原产于泰泽拉。"
	icon_state = "seraka_cap"
	seed = /obj/item/seeds/lavaland/seraka
	wine_power = 40

/obj/item/food/grown/ash_flora/seraka/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/raptor_food, ability_modifier = 0.1)

/obj/item/food/grown/ash_flora/fireblossom
	name = "火之花"
	desc = "一朵来自火之花的花。"
	icon_state = "fireblossom"
	slot_flags = ITEM_SLOT_HEAD
	seed = /obj/item/seeds/lavaland/fireblossom
	wine_power = 40

/obj/item/food/grown/ash_flora/fireblossom/Initialize(mapload)
	. = ..()
	// Fire flowers make fireproof raptors
	AddElement(/datum/element/raptor_food, color_chances = string_list(list(/datum/raptor_color/blue = 5)))

/obj/item/food/grown/ash_flora/glowgrowth
	name = "glowgrowth sheet"
	desc = "A thick sheet of glowing fungi."
	icon_state = "glowgrowth"
	seed = /obj/item/seeds/lavaland/glowgrowth // Cannot be grown in hydroponics as it feeds off mineral air
	wine_power = 50

// SEEDS

/obj/item/seeds/lavaland
	name = "拉瓦兰种子"
	desc = "你绝对不应该看到这个。"
	lifespan = 50
	endurance = 25
	maturation = 7
	production = 4
	yield = 4
	potency = 15
	growthstages = 3
	rarity = PLANT_MODERATELY_RARE
	reagents_add = list(/datum/reagent/consumable/nutriment = 0.1)
	species = "polypore" // silence unit test
	genes = list(/datum/plant_gene/trait/fire_resistance)
	graft_gene = /datum/plant_gene/trait/fire_resistance

/obj/item/seeds/lavaland/cactus
	name = "结果仙人掌种子包"
	desc = "这些种子会长成结果的仙人掌。"
	icon_state = "seed-cactus"
	species = "cactus"
	plantname = "Fruiting Cactus"
	product = /obj/item/food/grown/ash_flora/cactus_fruit
	mutatelist = list(/obj/item/seeds/star_cactus)
	genes = list(/datum/plant_gene/trait/fire_resistance)
	growing_icon = 'icons/obj/service/hydroponics/growing_fruits.dmi'
	growthstages = 2
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.04, /datum/reagent/consumable/vitfro = 0.08)

///Star Cactus seeds, mutation of lavaland cactus.
/obj/item/seeds/star_cactus
	name = "星仙人掌种子包"
	desc = "能长成星辰仙人掌的种子。"
	icon_state = "seed-starcactus"
	species = "starcactus"
	plantname = "Star Cactus Cluster"
	product = /obj/item/food/grown/star_cactus
	lifespan = 60
	endurance = 30
	maturation = 7
	production = 6
	yield = 3
	growthstages = 4
	genes = list(/datum/plant_gene/trait/sticky, /datum/plant_gene/trait/stinging)
	graft_gene = /datum/plant_gene/trait/sticky
	growing_icon = 'icons/obj/service/hydroponics/growing_vegetables.dmi'
	reagents_add = list(/datum/reagent/water = 0.08, /datum/reagent/consumable/nutriment = 0.05, /datum/reagent/medicine/c2/helbital = 0.05)

///Star Cactus Plants.
/obj/item/food/grown/star_cactus
	seed = /obj/item/seeds/star_cactus
	name = "星辰仙人掌"
	desc = "一簇尖刺状、圆形的带刺星状仙人掌。而且，它之所以被称为“星状仙人掌”，并不是因为它是存在于太空中的植物。"
	icon_state = "starcactus"
	filling_color = "#1c801c"
	foodtypes = VEGETABLES
	distill_reagent = /datum/reagent/consumable/ethanol/tequila

/obj/item/seeds/lavaland/polypore
	name = "多孔菌菌丝包"
	desc = "这种菌丝体会长成菌盖蘑菇，也被称为多孔菌。这种木质且坚硬的菌体常被矿工们用于制作临时工具。"
	icon_state = "mycelium-polypore"
	species = "polypore"
	plantname = "Polypore Mushrooms"
	product = /obj/item/food/grown/ash_flora/shavings
	genes = list(/datum/plant_gene/trait/plant_type/fungal_metabolism, /datum/plant_gene/trait/fire_resistance)
	growing_icon = 'icons/obj/service/hydroponics/growing_mushrooms.dmi'
	reagents_add = list(/datum/reagent/consumable/nutriment = 0.04, /datum/reagent/consumable/ethanol = 0.04, /datum/reagent/stabilizing_agent = 0.06, /datum/reagent/consumable/mintextract = 0.02)

/obj/item/seeds/lavaland/porcini
	name = "牛肝菌菌丝包"
	desc = "这种菌丝体能长成牛肝菌（也被称为猪肝菌）。这种菌类原产于地球的末期时期，但在拉瓦兰星球被发现。它具有烹饪、药用和放松的功效。"
	icon_state = "mycelium-porcini"
	species = "porcini"
	plantname = "Porcini Mushrooms"
	product = /obj/item/food/grown/ash_flora/mushroom_leaf
	genes = list(/datum/plant_gene/trait/plant_type/fungal_metabolism, /datum/plant_gene/trait/fire_resistance)
	growing_icon = 'icons/obj/service/hydroponics/growing_mushrooms.dmi'
	reagents_add = list(/datum/reagent/consumable/nutriment = 0.06,  /datum/reagent/consumable/sugar = 0.06, /datum/reagent/consumable/vitfro = 0.04, /datum/reagent/drug/nicotine = 0.04)

/obj/item/seeds/lavaland/inocybe
	name = "丝盖菇菌丝包"
	desc = "这种菌丝体会发育成一种名为丝盖伞菌的蘑菇，这是一种源自拉瓦兰地区的蘑菇，具有致幻和毒性作用。"
	icon_state = "mycelium-inocybe"
	species = "inocybe"
	plantname = "Inocybe Mushrooms"
	product = /obj/item/food/grown/ash_flora/mushroom_cap
	genes = list(/datum/plant_gene/trait/plant_type/fungal_metabolism, /datum/plant_gene/trait/fire_resistance)
	growing_icon = 'icons/obj/service/hydroponics/growing_mushrooms.dmi'
	reagents_add = list(/datum/reagent/toxin/mindbreaker = 0.04, /datum/reagent/consumable/entpoly = 0.08, /datum/reagent/drug/mushroomhallucinogen = 0.04)

/obj/item/seeds/lavaland/ember
	name = "余烬菇菌丝包"
	desc = "这种菌丝体会长成余烬菌这种蘑菇，它是来自拉瓦兰地区的会发光的蘑菇的一种。"
	icon_state = "mycelium-ember"
	species = "ember"
	plantname = "Embershroom Mushrooms"
	product = /obj/item/food/grown/ash_flora/mushroom_stem
	genes = list(/datum/plant_gene/trait/plant_type/fungal_metabolism, /datum/plant_gene/trait/glow, /datum/plant_gene/trait/fire_resistance)
	growing_icon = 'icons/obj/service/hydroponics/growing_mushrooms.dmi'
	reagents_add = list(/datum/reagent/consumable/tinlux = 0.04, /datum/reagent/consumable/nutriment/vitamin = 0.02, /datum/reagent/drug/space_drugs = 0.02)

/obj/item/seeds/lavaland/seraka
	name = "塞拉卡菌丝包"
	desc = "这种菌丝体会发育成蛇栗蘑菇，这是一种味道鲜美的蘑菇，原产于泰泽拉地区，常用于食品制作和传统医药中。"
	icon_state = "mycelium-seraka"
	species = "seraka"
	plantname = "Seraka Mushrooms"
	product = /obj/item/food/grown/ash_flora/seraka
	genes = list(/datum/plant_gene/trait/plant_type/fungal_metabolism, /datum/plant_gene/trait/fire_resistance)
	growing_icon = 'icons/obj/service/hydroponics/growing_mushrooms.dmi'
	reagents_add = list(/datum/reagent/toxin/mushroom_powder = 0.1, /datum/reagent/medicine/coagulant/seraka_extract = 0.02)

/obj/item/seeds/lavaland/fireblossom
	name = "火之花种子包"
	desc = "这些种子会长成火之花。"
	plantname = "Fire Blossom"
	icon_state = "seed-fireblossom"
	species = "fireblossom"
	growthstages = 3
	product = /obj/item/food/grown/ash_flora/fireblossom
	genes = list(/datum/plant_gene/trait/fire_resistance, /datum/plant_gene/trait/glow/yellow)
	growing_icon = 'icons/obj/service/hydroponics/growing_flowers.dmi'
	reagents_add = list(/datum/reagent/consumable/tinlux = 0.04, /datum/reagent/consumable/nutriment = 0.03, /datum/reagent/carbon = 0.05)

/obj/item/seeds/lavaland/glowgrowth
	name = "glowgrowth mycelium pack"
	desc = "This mycelium grows into glowgrowth fungi."
	plantname = "Glowgrowth Fungi"
	icon_state = "mycelium-glowgrowth"
	species = "glowgrowth"
	product = /obj/item/food/grown/ash_flora/glowgrowth
	genes = list(/datum/plant_gene/trait/plant_type/fungal_metabolism, /datum/plant_gene/trait/fire_resistance, /datum/plant_gene/trait/glow/blue) // Fungal metab doesn't do anything (cause it can't be planted) but it shows up in analyzers
	reagents_add = list(/datum/reagent/luminescent_fluid/cyan = 0.06, /datum/reagent/consumable/nutriment = 0.01, /datum/reagent/silicon = 0.03)
	seed_flags = parent_type::seed_flags | NO_PLANTING

//CRAFTING

/datum/crafting_recipe/mushroom_bowl
	name = "Mushroom Bowl"
	result = /obj/item/reagent_containers/cup/bowl/mushroom_bowl
	reqs = list(/obj/item/food/grown/ash_flora/shavings = 5)
	time = 3 SECONDS
	category = CAT_CONTAINERS

/obj/item/reagent_containers/cup/bowl/mushroom_bowl
	name = "蘑菇碗"
	desc = "一个用蘑菇制成的碗。不过这并非食物，尽管它可能曾经盛放过一些食物。"
	icon = 'icons/obj/mining_zones/ash_flora.dmi'
	base_icon_state = "mushroom_bowl"
	icon_state = "mushroom_bowl"
	fill_icon_state = "fullbowl"
	fill_icon = 'icons/obj/mining_zones/ash_flora.dmi'
	custom_materials = null

