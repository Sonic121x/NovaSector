/obj/structure/flora/tree
	/// The type of stump to spawn when harvested.
	var/stump_type = /obj/structure/flora/tree/stump

/obj/structure/flora/tree/mushroom
	name = "蘑菇树"
	desc = "一种大型分枝蘑菇，似乎在这颗行星的地下茁壮成长。"
	icon = 'modular_nova/modules/serenitystation/icons/mushroomtrees.dmi'
	icon_state = "tree1"
	base_icon_state = "tree_dead1"
	pixel_x = -48
	pixel_y = -20
	stump_type = /obj/structure/flora/tree/stump/mushroom

/obj/structure/flora/tree/mushroom/reverse
	icon_state = "tree2"
	stump_type = /obj/structure/flora/tree/stump/mushroom/reverse

/obj/structure/flora/tree/mushroom/blue
	icon_state = "tree_blue1"

/obj/structure/flora/tree/mushroom/blue/reverse
	icon_state = "tree_blue2"
	stump_type = /obj/structure/flora/tree/stump/mushroom/reverse

/obj/structure/flora/tree/mushroom/green
	icon_state = "tree_green1"

/obj/structure/flora/tree/mushroom/green/reverse
	icon_state = "tree_green2"
	stump_type = /obj/structure/flora/tree/stump/mushroom/reverse

/obj/structure/flora/tree/stump/mushroom
	icon = 'modular_nova/modules/serenitystation/icons/mushroomtrees.dmi'
	icon_state = "tree1_dead"
	pixel_x = -48
	pixel_y = -20

/obj/structure/flora/tree/stump/mushroom/reverse
	icon_state = "tree2_dead"

/obj/structure/flora/ash/tall_shroom/colored
	desc = "许多大型蘑菇，覆盖着一层薄薄的、只能是孢子的东西。"
	icon = 'modular_nova/modules/serenitystation/icons/mushroom_flora.dmi'
	icon_state = "l_mushroom_red1"
	base_icon_state = "l_mushroom_red"
	number_of_variants = 1

/obj/structure/flora/ash/tall_shroom/colored/blue
	icon_state = "l_mushroom_blue1"
	base_icon_state = "l_mushroom_blue"

/obj/structure/flora/ash/tall_shroom/colored/green
	icon_state = "l_mushroom_green1"
	base_icon_state = "l_mushroom_green"

/obj/structure/flora/ash/leaf_shroom/colored
	desc = "许多蘑菇，每一株都围绕着一个色彩鲜艳的孢子囊，孢子囊周围有许多叶状结构。"
	icon = 'modular_nova/modules/serenitystation/icons/mushroom_flora.dmi'
	icon_state = "s_mushroom_red1"
	base_icon_state = "s_mushroom_red"
	number_of_variants = 1

/obj/structure/flora/ash/leaf_shroom/colored/blue
	icon_state = "s_mushroom_blue1"
	base_icon_state = "s_mushroom_blue"

/obj/structure/flora/ash/leaf_shroom/colored/green
	icon_state = "s_mushroom_green1"
	base_icon_state = "s_mushroom_green"

/obj/structure/flora/ash/cap_shroom/colored
	icon = 'modular_nova/modules/serenitystation/icons/mushroom_flora.dmi'
	icon_state = "r_mushroom_red1"
	base_icon_state = "r_mushroom_red"
	number_of_variants = 1

/obj/structure/flora/ash/cap_shroom/colored/blue
	icon_state = "r_mushroom_blue1"
	base_icon_state = "r_mushroom_blue"

/obj/structure/flora/ash/cap_shroom/colored/green
	icon_state = "r_mushroom_green1"
	base_icon_state = "r_mushroom_green"

/obj/structure/flora/ash/stem_shroom/colored
	icon = 'modular_nova/modules/serenitystation/icons/mushroom_flora.dmi'
	icon_state = "t_mushroom_red1"
	base_icon_state = "t_mushroom_red"

/obj/structure/flora/ash/stem_shroom/colored/blue
	icon_state = "t_mushroom_blue1"
	base_icon_state = "t_mushroom_blue"

/obj/structure/flora/ash/stem_shroom/colored/green
	icon_state = "t_mushroom_green1"
	base_icon_state = "t_mushroom_green"

/obj/structure/flora/mushroom
	name = "蘑菇"
	desc = "某种大型蘑菇……它看起来可疑。"
	icon = 'modular_nova/modules/serenitystation/icons/mushroom_flora.dmi'
	icon_state = "fake_stillcap_red"
	flora_flags = FLORA_HERBAL

/obj/structure/flora/mushroom/blue
	icon_state = "fake_stillcap_blue"

/obj/structure/flora/mushroom/green
	icon_state = "fake_stillcap_green"

/obj/structure/flora/ash/lightshroom
	name = "光菇"
	desc = "一种奇特的发光蘑菇，生长在有地下液态等离子泉的区域。"
	icon = 'modular_nova/modules/serenitystation/icons/mushroom_flora.dmi'
	icon_state = "red_mushroom1"
	base_icon_state = "red_mushroom"
	light_range = LIGHT_FIRE_BLOSSOM
	light_power = LIGHT_FIRE_BLOSSOM
	light_color = COLOR_RED_LIGHT
	harvested_name = "lightshroom stems"
	harvested_desc = "A few lightshroom stems, missing their caps."
	harvest_amount_high = 3
	harvest_message_low = "You pluck a single, suitable mushroom."
	harvest_message_med = "You pluck a number of mushrooms, leaving a few unsuitable ones."
	harvest_message_high = "You pluck quite a lot of suitable mushrooms."
	regrowth_time_low = 2500
	regrowth_time_high = 4000
	number_of_variants = 1

/obj/structure/flora/ash/lightshroom/get_potential_products()
	return list(/obj/item/food/grown/ash_flora/lightshroom = 1)

/obj/structure/flora/ash/lightshroom/after_harvest()
	set_light_power(LIGHT_RANGE_FIRE_BLOSSOM_HARVESTED)
	set_light_range(LIGHT_POWER_FIRE_BLOSSOM_HARVESTED)
	update_light()
	return ..()

/obj/structure/flora/ash/lightshroom/regrow()
	set_light_power(initial(light_power))
	set_light_range(initial(light_range))
	update_light()
	return ..()

/obj/structure/flora/ash/lightshroom/blue
	icon_state = "blue_mushroom1"
	base_icon_state = "blue_mushroom"
	light_color = COLOR_BIOLUMINESCENCE_BLUE

/obj/structure/flora/ash/lightshroom/blue/get_potential_products()
	return list(/obj/item/food/grown/ash_flora/lightshroom/blue = 1)

/obj/structure/flora/ash/lightshroom/green
	icon_state = "green_mushroom1"
	base_icon_state = "green_mushroom"
	light_color = COLOR_BIOLUMINESCENCE_GREEN

/obj/structure/flora/ash/lightshroom/green/get_potential_products()
	return list(/obj/item/food/grown/ash_flora/lightshroom/green = 1)

/obj/item/food/grown/ash_flora/lightshroom
	name = "红色光菇"
	desc = "一种发光的蘑菇。"
	icon = 'modular_nova/modules/serenitystation/icons/mushroom_flora.dmi'
	icon_state = "red_mushroom_grown"
	seed = /obj/item/seeds/lavaland/lightshroom
	wine_power = 40
	special_desc_requirement = EXAMINE_CHECK_JOB
	special_desc_jobs = list("Botanist")
	special_desc = "This flora contains some healing properties, if you can filter out the radioactive toxins."

/obj/item/food/grown/ash_flora/lightshroom/blue
	name = "蓝色光菇"
	icon_state = "blue_mushroom_grown"
	seed = /obj/item/seeds/lavaland/lightshroom/blue

/obj/item/food/grown/ash_flora/lightshroom/green
	name = "绿色光菇"
	icon_state = "green_mushroom_grown"
	seed = /obj/item/seeds/lavaland/lightshroom/green

/obj/item/seeds/lavaland/lightshroom
	name = "一包红色光菇菌丝体"
	desc = "这些种子会长成色彩鲜艳的光菇。"
	plantname = "Red Lightshroom"
	icon = 'modular_nova/modules/serenitystation/icons/mushroom_flora.dmi'
	icon_state = "mycelium_red_mushroom"
	species = "red_mushroom"
	growthstages = 3
	growing_icon = 'modular_nova/modules/serenitystation/icons/mushroom_flora.dmi'
	icon_dead = "red_mushroom_dead"
	product = /obj/item/food/grown/ash_flora/lightshroom
	genes = list(/datum/plant_gene/trait/plant_type/fungal_metabolism, /datum/plant_gene/trait/glow/red)
	reagents_add = list(/datum/reagent/consumable/nutriment = 0.04, /datum/reagent/consumable/vitfro = 0.04, /datum/reagent/uranium/radium = 0.04)
	graft_gene = /datum/plant_gene/trait/plant_type/fungal_metabolism

/obj/item/seeds/lavaland/lightshroom/blue
	name = "一包蓝色光菇菌丝体"
	plantname = "Blue Lightshroom"
	icon_state = "mycelium_blue_mushroom"
	species = "blue_mushroom"
	icon_dead = "blue_mushroom_dead"
	product = /obj/item/food/grown/ash_flora/lightshroom/blue
	genes = list(/datum/plant_gene/trait/plant_type/fungal_metabolism, /datum/plant_gene/trait/glow/blue)

/obj/item/seeds/lavaland/lightshroom/green
	name = "一包绿色光菇菌丝体"
	plantname = "Green Lightshroom"
	icon_state = "mycelium_green_mushroom"
	species = "green_mushroom"
	icon_dead = "green_mushroom_dead"
	product = /obj/item/food/grown/ash_flora/lightshroom/green
	genes = list(/datum/plant_gene/trait/plant_type/fungal_metabolism, /datum/plant_gene/trait/glow/green)
