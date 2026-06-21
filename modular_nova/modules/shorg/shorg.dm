/mob/living/basic/pet/dog/shorg // I had thought of a different names such as shitten(shark+kitten), but shorg sounds fine
	name = "\improper 鲨狗"
	real_name = "shorg"
	desc = "这是一种狗和鲨鱼的可爱混种，但它的物种名——鲨狗——就没那么可爱了。"
	icon = 'modular_nova/modules/shorg/icons/pets.dmi'
	held_lh = 'modular_nova/modules/shorg/icons/pets_held_lh.dmi'
	held_rh = 'modular_nova/modules/shorg/icons/pets_held_rh.dmi'
	icon_state = "shorg"
	icon_living = "shorg"
	icon_dead = "shorg_dead"
	collar_icon_state = "shorg"
	held_state = "shorg"
	butcher_results = list(/obj/item/food/fishmeat/quality = 3, /obj/item/food/meat/slab/corgi = 1)
	gold_core_spawnable = FRIENDLY_SPAWN
	collar_icon_state = "shorg"
	held_state = "shorg"
	faction = list(FACTION_NEUTRAL, FACTION_CARP) // Carps wont attack it
	obj_damage = 5
	melee_damage_lower = 8
	melee_damage_upper = 16
	wound_bonus = 15 // Shark(shorg?) bites

/datum/supply_pack/critter/corgis/shorg
	name = "鲨狗板条箱"
	desc = "包含一只鲨狗——鲨鱼与柯基犬的混种。非常可爱。"
	cost = CARGO_CRATE_VALUE * 10
	contains = list(/mob/living/basic/pet/dog/shorg)
	crate_name = "shorg crate"
