// a few simple food items/reagents used as ingredients. mostly dried forms of normal foods to give the new dehydrator a use.
// they should be fine to use as normal foods and as ingredients for recipes, don't be shy!

/obj/item/food/dried_fish
	name = "鱼干片"
	desc = "技术上算是鱼肉干？"
	icon = 'modular_nova/modules/cook_console_recipes/icons.dmi'
	icon_state = "driedfish"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 4,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("fish" = 1, "dried meat" = 1)
	foodtypes = SEAFOOD
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_1

/obj/item/food/dried_fish/grind_results()
	return list(/datum/reagent/consumable/bonito = 20)

/obj/item/food/fishmeat/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/dryable, /obj/item/food/dried_fish)

/obj/item/food/dried_chili
	name = "干辣椒"
	desc = "It's spicy! Wait... it's dry too."
	icon = 'modular_nova/modules/cook_console_recipes/icons.dmi'
	icon_state = "driedchili"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("dry heat" = 1)
	foodtypes = FRUIT

/obj/item/food/dried_chili/grind_results()
	return list(/datum/reagent/consumable/chili_powder = 20)

/obj/item/food/grown/chili/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/dryable, /obj/item/food/dried_chili)

/obj/item/food/dried_herbs
	name = "干香草束"
	desc = "一束各种干香草。应该不难把你想要的那种弄碎。"
	icon = 'modular_nova/modules/cook_console_recipes/icons.dmi'
	icon_state = "driedherbs"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("store bought herbs." = 1)
	foodtypes = VEGETABLES

/obj/item/food/grown/herbs/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/dryable, /obj/item/food/dried_herbs)

/datum/reagent/consumable/bonito
	name = "柴鱼片"
	description = "也被称为\"鲣节\"，显然！"
	color = "#fce2c7"
	taste_description = "Umami"
	taste_mult = 1.5

/datum/reagent/consumable/chili_powder
	name = "辣椒粉"
	description = "不，不，辣椒粉是我的招牌！"
	color = "#88100a"
	taste_description = "dry hot peppers"
	taste_mult = 1.5

/datum/reagent/consumable/onion_juice
	name = "洋葱汁"
	description = "像眼泪汁但更可口。"
	color = "#1bf5ea"
	taste_description = "onion"

/obj/item/food/onion_slice/grind_results()
	return list(/datum/reagent/consumable/onion_juice = 20)

//this has been added in to avoid an error? apparently some weird subsystem decided the condiments are soups now so they need these, silly.

/datum/glass_style/has_foodtype/soup/coconut_milk
	required_drink_type = /datum/reagent/consumable/coconut_milk
	drink_type = VEGETABLES

/datum/glass_style/has_foodtype/soup/curry_powder
	required_drink_type = /datum/reagent/consumable/curry_powder
	drink_type = VEGETABLES

/datum/glass_style/has_foodtype/soup/red_bay
	required_drink_type = /datum/reagent/consumable/red_bay
	drink_type = VEGETABLES
