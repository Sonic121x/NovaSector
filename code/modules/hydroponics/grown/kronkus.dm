/obj/item/seeds/kronkus
	name = "克朗库斯种子包"
	desc = "一包高度非法的克朗库斯种子。\nPossession 这些种子在7个扇区都适用死刑。"
	icon_state = "seed-kronkus"
	plant_icon_offset = 6
	species = "kronkus"
	plantname = "Kronkus Vine"
	product = /obj/item/food/grown/kronkus
	//shitty stats, because botany is easy
	lifespan = 60
	endurance = 40
	maturation = 6
	production = 4
	growthstages = 3
	growing_icon = 'icons/obj/service/hydroponics/growing.dmi'
	reagents_add = list(/datum/reagent/consumable/nutriment = 0.05)

/obj/item/seeds/kronkus/Initialize(mapload, nogenes)
	. = ..()
	ADD_TRAIT(src, TRAIT_CONTRABAND, INNATE_TRAIT)

/obj/item/food/grown/kronkus
	seed = /obj/item/seeds/kronkus
	name = "克朗库斯藤段"
	desc = "一段成熟的克朗库斯藤蔓。它散发出刺鼻的有毒气味。\n\nIt 可以发酵制成一种粗提物，太空驳船上的流浪汉们用它来在发动机废气渗入他们棚屋时保持清醒。\n\nFurther 据说进一步加工可以产出克朗可卡因，但关于此主题的信息技术受到严格控制。"
	icon_state = "kronkus"
	filling_color = "#37946e"
	foodtypes = VEGETABLES | TOXIC
	distill_reagent = /datum/reagent/kronkus_extract

/obj/item/food/grown/kronkus/Initialize(mapload, nogenes)
	. = ..()
	ADD_TRAIT(src, TRAIT_CONTRABAND, INNATE_TRAIT)
