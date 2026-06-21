// Override to add the bloody type to these tgmaters
/obj/item/food/grown/tomato/blood/Initialize(mapload, obj/item/seeds/new_seed)
	foodtypes |= BLOODY
	return ..()

/obj/item/food/hemophage
	name = "血腥食物"
	desc = "如果你看到这个，说明出了大问题，你应该一有机会就报告。"
	icon = 'modular_nova/master_files/icons/obj/food/hemophage_food.dmi'
	foodtypes = GORE | BLOODY

/obj/item/food/hemophage/blood_rice_pearl
	name = "血染珍珠米"
	desc = "一种有趣的手指食物。一小团粘米饭，里面有一点猪肉末和青葱，全部浸泡并裹在新鲜血液中；使其呈现深红色。建议趁热食用！"
	icon_state = "blood_rice_pearl"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/blood = 10,
	)
	tastes = list("rice" = 3, "blood" = 5)
	foodtypes = GRAIN | GORE | BLOODY
	crafting_complexity = FOOD_COMPLEXITY_1

/obj/item/food/hemophage/blood_rice_pearl/raw
	name = "未煮的血米饭"
	desc = "一团生米饭，浸透了血液。"
	icon = 'icons/obj/food/food.dmi'
	icon_state = "uncooked_rice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/blood = 10,
	)
	tastes = list("raw rice" = 3, "blood" = 5)
	color = "#810000"
	foodtypes = GRAIN | GORE | BLOODY | RAW
	crafting_complexity = FOOD_COMPLEXITY_0

/obj/item/food/hemophage/blood_rice_pearl/raw/make_microwaveable()
	AddElement(/datum/element/microwavable, /obj/item/food/hemophage/blood_rice_pearl)

/obj/item/food/hemophage/blood_noodles
	name = "水煮血面"
	desc = "一道简单的血浸面条，如果加点别的配料可能会更好吃。"
	icon = 'icons/obj/food/spaghetti.dmi'
	icon_state = "spaghettiboiled"
	color = "#810000"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/blood = 20,
	)
	tastes = list("blood" = 5, "pasta" = 1)
	foodtypes = GRAIN | GORE | BLOODY
	crafting_complexity = FOOD_COMPLEXITY_1

/obj/item/food/hemophage/blood_noodles/raw
	name = "生血面"
	desc = "彻底浸泡在血里的面条。生吃听起来就不开胃。说真的，怎么吃都不开胃。"
	color = "#ad0000"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/blood = 15, // You should really be cooking those if you want the full amount of blood out of them
	)
	tastes = list("blood" = 5, "raw pasta" = 1)
	foodtypes = GRAIN | GORE | BLOODY | RAW
	crafting_complexity = FOOD_COMPLEXITY_0

/obj/item/food/hemophage/blood_noodles/raw/make_microwaveable()
	AddElement(/datum/element/microwavable, /obj/item/food/hemophage/blood_noodles)

/obj/item/food/hemophage/blood_noodles/boat_noodles
	name = "船面"
	desc = "这道菜通常由猪肉和牛肉的浓烈组合制成；而这个无肉版本的主要亮点在于血豆腐和卷曲面条的结合，经过调味并浸入新鲜血液，直至它们变成深红色。它散发着浓烈的铁锈味。"
	icon_state = "meatballspaghetti"
	color = "#d10000"
	max_volume = 70
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 10,
		/datum/reagent/consumable/nutriment/vitamin = 10,
		/datum/reagent/blood = 50,
	)
	tastes = list("blood" = 5, "congealed blood" = 3, "pasta" = 1)
	foodtypes = GRAIN | GORE | BLOODY
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/hemophage/blood_curd
	name = "血豆腐"
	desc = "也被称为'血豆腐'或'血布丁'，这道羊鱼美食看起来是由凝结并煮熟的血制成的。它柔软光滑，略有嚼劲，富含核黄素。"
	icon_state = "blood_curd"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/blood = 15,
	)
	tastes = list("congealed blood" = 1)
	foodtypes = GORE | BLOODY | RAW
	crafting_complexity = FOOD_COMPLEXITY_0

/obj/item/food/hemophage/blood_cake
	name = "猪血糕"
	desc = "Also known as 'pig's blood cake' or 'black cake', this is a variant of blood pudding normally served as street food in night markets. Created from steamed blood and sticky rice, it's been coated in peanut powder and coriander, and can be served with some dipping sauces. It seems the amount of blood in this meal has been turned up a lot, giving the all-too-familiar twinge of iron when it's tasted."
	icon_state = "blood_cake"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 10,
		/datum/reagent/consumable/peanut_butter = 5,
		/datum/reagent/blood = 25,
	)
	tastes = list("blood" = 5, "crunchy rice" = 2, "peanut butter" = 2)
	foodtypes = GRAIN | GORE | BLOODY | SUGAR | NUTS | BREAKFAST
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/soup/hemophage/blood_soup
	name = "血肠炖"
	desc = "一种通常由内脏或新鲜炖肉制成的咸味炖菜。这个版本以血豆腐为特色，同时还有一种由新鲜血液和醋制成的浓郁、辛辣、深色的肉汁。还加入了辣椒和大蒜来增强肉汤的咸香味。"
	icon = 'modular_nova/master_files/icons/obj/food/hemophage_food.dmi'
	icon_state = "blood_soup"
	max_volume = 90
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 10,
		/datum/reagent/blood = 60,
	)
	tastes = list("blood" = 5, "congealed blood" = 2, "chili" = 3, "vinegar" = 1, "garlic" = 1)
	foodtypes = GORE | BLOODY | VEGETABLES
	crafting_complexity = FOOD_COMPLEXITY_4
