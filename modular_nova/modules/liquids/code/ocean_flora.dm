/obj/structure/flora/ocean
	icon = 'modular_nova/modules/liquids/icons/obj/flora/ocean_flora.dmi'
	var/random_variants = 0

/obj/structure/flora/ocean/Initialize(mapload)
	. = ..()
	if(random_variants)
		icon_state = "[icon_state][rand(1,random_variants)]"

/obj/structure/flora/ocean/glowweed
	name = "发光海草"
	icon_state = "glowweed"
	desc = "一种末端带有发光球茎的植物。"
	random_variants = 3
	light_color = LIGHT_COLOR_CYAN
	light_range = 1.5

/obj/structure/flora/ocean/seaweed
	name = "海草"
	icon_state = "seaweed"
	desc = "就是普通的海草。"
	random_variants = 5

/obj/structure/flora/ocean/longseaweed
	name ="海草"
	icon_state = "longseaweed"
	desc = "不那么普通的海草。这一株非常长。"
	random_variants = 4

/obj/structure/flora/ocean/coral
	name = "珊瑚"
	icon_state = "coral"
	desc = "美丽的珊瑚。"
	random_variants = 3
	density = TRUE

/obj/effect/spawner/liquids_spawner
	name = "液体生成器（水，齐腰深）"
	icon = 'modular_nova/modules/liquids/icons/obj/effects/liquid.dmi'
	icon_state = "spawner"
	color = "#AAAAAA77"
	var/reagent_list = list(/datum/reagent/water = ONE_LIQUIDS_HEIGHT*LIQUID_WAIST_LEVEL_HEIGHT)
	var/temp = T20C

/obj/effect/spawner/liquids_spawner/Initialize(mapload)
	. = ..()

	if(!isturf(loc))
		return
	var/turf/T = loc
	T.add_liquid_list(reagent_list, FALSE, temp)

/obj/effect/spawner/liquids_spawner/puddle
	name = "液体生成器（水，水洼）"
	reagent_list = list(/datum/reagent/water = ONE_LIQUIDS_HEIGHT)

/obj/effect/spawner/liquids_spawner/ankles
	name = "液体生成器（水，脚踝深）"
	reagent_list = list(/datum/reagent/water = ONE_LIQUIDS_HEIGHT*LIQUID_ANKLES_LEVEL_HEIGHT)

/obj/effect/spawner/liquids_spawner/shoulders
	name = "液体生成器（水，齐肩深）"
	reagent_list = list(/datum/reagent/water = ONE_LIQUIDS_HEIGHT*LIQUID_SHOULDERS_LEVEL_HEIGHT)

/obj/effect/spawner/liquids_spawner/fulltile
	name = "液体生成器（水，满格）"
	reagent_list = list(/datum/reagent/water = ONE_LIQUIDS_HEIGHT*LIQUID_FULLTILE_LEVEL_HEIGHT)
