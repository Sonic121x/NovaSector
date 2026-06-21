/obj/effect/spawner/random/armory
	name = "通用军械库生成器"
	spawn_loot_split = TRUE
	spawn_loot_count = 3
	spawn_loot_split_pixel_offsets = 4

// Misc armory stuff
/obj/effect/spawner/random/armory/barrier_grenades
	name = "屏障手榴弹生成器"
	icon_state = "barrier_grenade"
	loot = list(/obj/item/grenade/barrier)

/obj/effect/spawner/random/armory/barrier_grenades/six
	name = "六枚屏障手榴弹生成器"
	spawn_loot_count = 6

/obj/effect/spawner/random/armory/riot_shield
	name = "防暴盾牌生成器"
	icon_state = "riot_shield"
	loot = list(/obj/item/shield/riot)

/obj/effect/spawner/random/armory/rubbershot
	name = "橡胶弹生成器"
	icon_state = "rubbershot"
	loot = list(/obj/item/storage/box/rubbershot)

/obj/effect/spawner/random/armory/buckshot
	name = "鹿弹生成器"
	icon_state = "buckshot"
	loot = list(/obj/item/storage/box/lethalshot)

/obj/effect/spawner/random/armory/buckshot/sketchy
	name = "可疑的鹿弹生成器"
	icon_state = "buckshot"
	loot = list(
		/obj/item/storage/box/lethalshot = 4,
		/obj/item/storage/box/lethalshot/old = 2,
	)

/obj/effect/spawner/random/armory/slug
	name = "独头弹生成器"
	icon_state = "buckshot"
	loot = list(/obj/item/storage/box/slugs)

/obj/effect/spawner/random/armory/strilka
	name = ".310 斯特里尔卡弹药箱生成器"
	icon_state = "buckshot"
	spawn_loot_count = 1
	loot = list(
		/obj/item/storage/toolbox/ammobox/strilka310,
		/obj/item/storage/toolbox/ammobox/strilka310/surplus,
	)

// Weapons
/obj/effect/spawner/random/armory/disablers
	name = "致残枪生成器"
	icon_state = "disabler"
	loot = list(/obj/item/gun/energy/disabler)

/obj/effect/spawner/random/armory/laser_gun
	name = "激光枪生成器"
	icon_state = "laser_gun"
	loot = list(/obj/item/gun/energy/laser)

/obj/effect/spawner/random/armory/laser_pistol
	name = "激光手枪生成器"
	icon_state = "laser_gun"
	spawn_loot_count = 6
	loot = list(/obj/item/gun/energy/laser/pistol)

/obj/effect/spawner/random/armory/laser_carbine
	name = "激光卡宾枪生成器"
	icon_state = "laser_gun"
	loot = list(/obj/item/gun/energy/laser/carbine)

/obj/effect/spawner/random/armory/assault_laser
	name = "突击激光枪生成器"
	icon_state = "laser_gun"
	spawn_loot_count = 1
	loot = list(/obj/item/gun/energy/laser/assault)

/obj/effect/spawner/random/armory/pick_laser_loadout
	name = "激光枪类型随机化器"
	icon_state = "laser_gun"
	spawn_loot_count = 1
	loot = list(
		/obj/effect/spawner/random/armory/laser_gun = 30,
		/obj/effect/spawner/random/armory/laser_carbine = 30,
		/obj/effect/spawner/random/armory/laser_pistol = 10,
	)

/obj/effect/spawner/random/armory/e_gun
	name = "能量枪生成器"
	icon_state = "e_gun"
	loot = list(/obj/item/gun/energy/e_gun)

/obj/effect/spawner/random/armory/shotgun
	name = "霰弹枪生成器"
	icon_state = "shotgun"
	loot = list(/obj/item/gun/ballistic/shotgun/riot)

/obj/effect/spawner/random/armory/dragnet
	name = "DRAGnet 生成器"
	icon_state = "dragnet"
	loot = list(/obj/item/gun/energy/e_gun/dragnet)
	spawn_loot_count = 2

/obj/effect/spawner/random/armory/dragnet/spawn_loot(lootcount_override)
	. = ..()
	new /obj/item/dragnet_beacon(get_turf(src)) //And give them a beacon too!

// Armor
/obj/effect/spawner/random/armory/bulletproof_helmet
	name = "防弹头盔生成器"
	icon_state = "armor_helmet"
	loot = list(/obj/item/clothing/head/helmet/alt)

/obj/effect/spawner/random/armory/riot_helmet
	name = "防暴头盔生成器"
	icon_state = "riot_helmet"
	loot = list(/obj/item/clothing/head/helmet/toggleable/riot)

/obj/effect/spawner/random/armory/bulletproof_armor
	name = "防弹护甲生成器"
	icon_state = "bulletproof_armor"
	loot = list(/obj/item/clothing/suit/armor/bulletproof)

/obj/effect/spawner/random/armory/riot_armor
	name = "防暴护甲生成器"
	icon_state = "riot_armor"
	loot = list(/obj/item/clothing/suit/armor/riot)
