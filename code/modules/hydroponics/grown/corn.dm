// Corn
/obj/item/seeds/corn
	name = "玉米种子包"
	desc = "我并不是想说些老套的话......"
	icon_state = "seed-corn"
	species = "corn"
	plantname = "Corn Stalks"
	product = /obj/item/food/grown/corn
	maturation = 8
	potency = 20
	instability = 50 //Corn used to be wheatgrass, before being cultivated for generations.
	growthstages = 3
	growing_icon = 'icons/obj/service/hydroponics/growing_vegetables.dmi'
	icon_grow = "corn-grow" // Uses one growth icons set for all the subtypes
	icon_dead = "corn-dead" // Same for the dead icon
	mutatelist = list(/obj/item/seeds/corn/snapcorn, /obj/item/seeds/corn/pepper)
	reagents_add = list(/datum/reagent/consumable/nutriment/fat/oil/corn = 0.2, /datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1)

/obj/item/food/grown/corn
	seed = /obj/item/seeds/corn
	name = "玉米穗"
	desc = "来点黄油！"
	icon_state = "corn"
	trash_type = /obj/item/grown/corncob
	bite_consumption_mod = 2
	foodtypes = VEGETABLES
	tastes = list("corn" = 1)
	distill_reagent = /datum/reagent/consumable/ethanol/whiskey

/obj/item/food/grown/corn/grind_results()
	return list(/datum/reagent/consumable/cornmeal = 0, /datum/reagent/consumable/nutriment/fat/oil/corn = 0)

/obj/item/food/grown/corn/juice_typepath()
	return /datum/reagent/consumable/corn_starch

/obj/item/food/grown/corn/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/oven_baked_corn, rand(15 SECONDS, 25 SECONDS), TRUE, TRUE)

/obj/item/food/grown/corn/make_microwaveable()
	AddElement(/datum/element/microwavable, /obj/item/food/popcorn)

/obj/item/grown/corncob
	seed = /obj/item/seeds/corn
	name = "玉米棒"
	desc = "提醒你这根已经吃完了."
	icon_state = "corncob"
	inhand_icon_state = null
	w_class = WEIGHT_CLASS_TINY
	throwforce = 0
	throw_speed = 3
	throw_range = 7

/obj/item/grown/corncob/grind_results()
	return list(/datum/reagent/cellulose = 10)

/obj/item/grown/corncob/attackby(obj/item/grown/W, mob/user, list/modifiers, list/attack_modifiers)
	if(W.get_sharpness())
		to_chat(user, span_notice("你用[W]把玉米芯做成了一个烟斗！"))
		new /obj/item/cigarette/pipe/cobpipe (user.loc)
		qdel(src)
	else
		return ..()

// Snapcorn
/obj/item/seeds/corn/snapcorn
	name = "爆裂玉米种子包"
	desc = "哎呀！"
	icon_state = "seed-snapcorn"
	species = "snapcorn"
	plantname = "Snapcorn Stalks"
	product = /obj/item/grown/snapcorn
	mutatelist = null
	rarity = 10

/obj/item/grown/snapcorn
	seed = /obj/item/seeds/corn/snapcorn
	name = "玉米棒"
	desc = "一根玉米棒。"
	icon_state = "snapcorn"
	inhand_icon_state = null
	w_class = WEIGHT_CLASS_TINY
	throwforce = 0
	throw_speed = 3
	throw_range = 7
	var/snap_pops = 1

/obj/item/grown/snapcorn/add_juice()
	..()
	snap_pops = max(round(seed.potency/8), 1)

/obj/item/grown/snapcorn/attack_self(mob/user)
	..()
	to_chat(user, span_notice("你从玉米棒上摘下一个摔炮。"))
	var/obj/item/toy/snappop/S = new /obj/item/toy/snappop(user.loc)
	if(ishuman(user))
		user.put_in_hands(S)
	snap_pops -= 1
	if(!snap_pops)
		new /obj/item/grown/corncob/snap(user.loc)
		qdel(src)

/obj/item/grown/corncob/snap
	seed = /obj/item/seeds/corn/snapcorn
	name = "爆裂玉米芯"
	desc = "昔日恶作剧的纪念品。"

//Pepper-corn - Heh funny.
/obj/item/seeds/corn/pepper
	name = "胡椒玉米种子包"
	desc = "如果彼得摘了一包胡椒玉米..."
	icon_state = "seed-peppercorn"
	species = "peppercorn"
	plantname = "Pepper-Corn Stalks"
	product = /obj/item/food/grown/peppercorn
	mutatelist = null
	reagents_add = list(/datum/reagent/consumable/blackpepper = 0.2, /datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1)

/obj/item/food/grown/peppercorn
	seed = /obj/item/seeds/corn/pepper
	name = "胡椒玉米穗"
	desc = "这个满是灰尘的怪物需要上帝..."
	icon_state = "peppercorn"
	trash_type = /obj/item/grown/corncob/pepper
	foodtypes = VEGETABLES
	tastes = list("pepper" = 1, "sneezing" = 1)

/obj/item/food/grown/peppercorn/grind_results()
	return list(/datum/reagent/consumable/blackpepper = 0)

/obj/item/grown/corncob/pepper
	seed = /obj/item/seeds/corn/pepper
	name = "胡椒玉米芯"
	desc = "昔日基因改造怪物的纪念品。"
