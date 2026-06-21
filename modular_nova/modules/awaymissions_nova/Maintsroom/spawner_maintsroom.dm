/obj/effect/spawner/random/maintsrooms
	name = "随机维护室生成点"
	desc = "为维护室远征任务生成一个随机的物体、生物或结构。"
	loot = list(
		/turf/closed/wall/r_wall = 31,
		/turf/open/floor/white = 37,
		/obj/structure/table/reinforced = 23,
		/obj/effect/spawner/random/environmentally_safe_anomaly/immobile = 3,
		/obj/effect/decal/remains/human = 0.4,
		/obj/effect/decal/remains/robot = 0.4,
		/obj/effect/decal/remains/xeno = 0.4,
		/obj/structure/fluff/clockwork/clockgolem_remains = 0.4,
		/obj/item/raw_anomaly_core/random = 2,
		/obj/item/stack/sheet/mineral/zaukerite = 0.3,
		/obj/item/stack/sheet/mineral/runite = 0.4,
		/obj/item/stack/sheet/mineral/gold = 0.4,
		/obj/item/stack/sheet/mineral/diamond = 0.4,
		/obj/item/stack/sheet/mineral/adamantine = 0.3,
		/obj/item/stack/sheet/hauntium = 0.3,
		/obj/item/stack/telecrystal = 0.3,
		/obj/item/stack/ore/bluespace_crystal = 0.4,
	)

/// number count for myself, this is the remaining amount until the sum is 100
/// 0
/obj/effect/spawner/random/maintsrooms/make_item(spawn_loc, type_path_to_make)
	if(ispath(type_path_to_make, /turf) && isturf(spawn_loc))
		var/turf/spawn_turf = spawn_loc
		return spawn_turf.place_on_top(type_path_to_make)
	else
		return ..()

/obj/effect/spawner/random/maintsrooms/no_walls
	name = "随机维护室生成点（无墙壁）"

/obj/effect/spawner/random/maintsrooms/no_walls/New()
	loot[/turf/open/floor/white] = (loot[/turf/open/floor/white] + loot[/turf/closed/wall/r_wall])
	loot -= /turf/closed/wall/r_wall
	return ..()
