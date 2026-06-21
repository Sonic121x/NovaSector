
/// For spawning loot from necropolis chests or other sources, this randomly chooses one of the following entries to spawn.
/obj/effect/spawner/random/mining_loot
	name = "随机采矿战利品"
	desc = "生成一个随机采矿战利品。"
	icon = 'icons/obj/storage/crates.dmi'
	icon_state = "necrocrate"
	loot = list(
		/obj/item/shared_storage/red = 1,
		/obj/item/soulstone/anybody/mining = 1,
		/obj/item/clothing/glasses/godeye = 1,
		/obj/item/reagent_containers/cup/bottle/potion/flight = 1,
		/obj/item/clothing/gloves/gauntlets = 1,
		/obj/effect/spawner/random/mining_loot/pka_mod = 1,
		/obj/item/rod_of_asclepius = 1,
		/obj/item/organ/heart/cursed/wizard = 1,
		/obj/item/ship_in_a_bottle = 1,
		/obj/item/clothing/suit/hooded/berserker = 1,
		/obj/item/jacobs_ladder = 1,
		/obj/item/guardian_creator/miner = 1,
		/obj/item/warp_cube/red = 1,
		/obj/item/wisp_lantern = 1,
		/obj/item/immortality_talisman = 1,
		/obj/item/book/granter/action/spell/summonitem = 1,
		/obj/item/book_of_babel = 1,
		/obj/item/clothing/neck/necklace/memento_mori = 1,
	)

/obj/effect/spawner/random/mining_loot/demonic
	name = "随机恶魔采矿战利品"
	desc = "从恶魔列表中生成一个随机采矿战利品。"
	icon = 'icons/obj/storage/crates.dmi'
	icon_state = "necrocrate"
	loot = list(
		/obj/item/shared_storage/red = 1,
		/obj/item/clothing/neck/cloak/wolf_coat = 1,
		/obj/item/soulstone/anybody/mining = 1,
		/obj/item/clothing/glasses/godeye = 1,
		/obj/item/reagent_containers/cup/bottle/potion/flight = 1,
		/obj/item/clothing/gloves/gauntlets = 1,
		/obj/effect/spawner/random/mining_loot/pka_mod = 1,
		/obj/item/rod_of_asclepius = 1,
		/obj/item/organ/heart/cursed/wizard = 1,
		/obj/item/jacobs_ladder = 1,
		/obj/item/guardian_creator/miner = 1,
		/obj/item/weldingtool/abductor = 1,
		/obj/item/warp_cube/red = 1,
		/obj/item/immortality_talisman = 1,
		/obj/item/book/granter/action/spell/summonitem = 1,
		/obj/item/clothing/neck/necklace/memento_mori = 1,
		/obj/item/book/granter/action/spell/sacredflame = 1,
	)

/// For spawning a rare PKA modkit
/obj/effect/spawner/random/mining_loot/pka_mod
	name = "随机稀有PKA改装套件"
	desc = "生成一个随机稀有PKA改装套件。"
	icon = 'icons/obj/mining.dmi'
	icon_state = "modkit"
	loot = list(
		/obj/item/borg/upgrade/modkit/cooldown/aoe/mobs/andturfs = 1,
		/obj/item/borg/upgrade/modkit/cooldown/repeater = 1,
		/obj/item/borg/upgrade/modkit/resonator_blasts = 1,
		/obj/item/borg/upgrade/modkit/bounty = 1,
		/obj/item/borg/upgrade/modkit/lifesteal = 1,
	)
