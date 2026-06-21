/obj/effect/spawner/random/peel_or_nana
	name = "香蕉皮或香蕉生成器"
	icon_state = "peel"
	spawn_random_offset =  TRUE
	loot = list(
		/obj/item/grown/bananapeel = 3,
		/obj/item/food/grown/banana = 2,
	)

/obj/effect/spawner/random/bananas_or_nothing
	name = "香蕉或无生成器"
	icon_state = "bunch"
	spawn_random_offset =  TRUE
	spawn_loot_chance = 66
	loot = list(
		/obj/item/food/grown/banana/bunch = 6,
		/obj/item/food/grown/banana = 4,
	)

/obj/effect/spawner/random/chance_for_freedom
	name = "自由之心或无生成器"
	icon_state = "cap"
	spawn_loot_chance = 40
	loot = list(
		/obj/item/organ/heart/freedom = 1,
	)
