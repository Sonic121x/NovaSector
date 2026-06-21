/obj/effect/spawner/random/mod
	name = "MOD模块生成器"
	desc = "请将其模块化。"
	icon_state = "circuit"

/obj/effect/spawner/random/mod/maint
	name = "维护区MOD模块生成器"
	loot = list(
		/obj/item/mod/module/springlock = 2,
		/obj/item/mod/module/visor/rave = 2,
		/obj/item/mod/module/tanner = 1,
		/obj/item/mod/module/balloon = 1,
		/obj/item/mod/module/paper_dispenser = 1,
		/obj/item/mod/module/hat_stabilizer = 2,
		/obj/item/mod/module/stamp = 1,
		/obj/item/mod/module/recycler/donk/safe = 1,
	)

/obj/effect/spawner/random/mod/maint/Initialize(mapload)
	if(is_multi_z_level(z))
		loot += list(/obj/item/mod/module/atrocinator = 3)
	return ..()
