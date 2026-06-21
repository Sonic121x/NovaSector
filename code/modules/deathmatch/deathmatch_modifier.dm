///Deathmatch modifiers are little options the host can choose to spice the match a bit.
/datum/deathmatch_modifier
	/// The name of the modifier
	var/name = "未命名修改器"
	/// A small description/tooltip shown in the UI
	var/description = "这玩意儿到底有啥用？"
	/// The color of the button shown in the UI
	var/color = "blue"
	/// A lazylist of modifier typepaths this is incompatible with.
	var/list/datum/deathmatch_modifier/blacklisted_modifiers
	/// A lazylist of map typepaths this is incomptable with.
	var/list/datum/lazy_template/deathmatch/blacklisted_maps
	/// Is this trait exempted from the "Random Modifiers" modifier.
	var/random_exempted = FALSE

///Whether or not this modifier can be selected, for both host and player-selected modifiers.
/datum/deathmatch_modifier/proc/selectable(datum/deathmatch_lobby/lobby)
	SHOULD_CALL_PARENT(TRUE)
	if(!random_exempted && (/datum/deathmatch_modifier/random in lobby.modifiers))
		return FALSE
	if(length(lobby.modifiers & blacklisted_modifiers))
		return FALSE
	if (map_incompatible(lobby.map))
		return FALSE
	for(var/modpath in lobby.modifiers)
		if(src in GLOB.deathmatch_game.modifiers[modpath].blacklisted_modifiers)
			return FALSE
	return TRUE

/// Returns TRUE if map.type is in our blacklisted maps, FALSE otherwise.
/datum/deathmatch_modifier/proc/map_incompatible(datum/lazy_template/deathmatch/map)
	if (map?.type in blacklisted_maps)
		return TRUE

	return FALSE

///Called when selecting the deathmatch modifier.
/datum/deathmatch_modifier/proc/on_select(datum/deathmatch_lobby/lobby)
	return

///When the host changes his mind and unselects it.
/datum/deathmatch_modifier/proc/unselect(datum/deathmatch_lobby/lobby)
	return

///Called when the host chooses to change map. Returns FALSE if the new map is incompatible, TRUE otherwise.
/datum/deathmatch_modifier/proc/on_map_changed(datum/deathmatch_lobby/lobby)
	if (map_incompatible(lobby.map))
		lobby.unselect_modifier(src)
		return FALSE
	return TRUE

///Called as the game is about to start.
/datum/deathmatch_modifier/proc/on_start_game(datum/deathmatch_lobby/lobby)
	return

///Called as the game has ended, right before the reservation is deleted.
/datum/deathmatch_modifier/proc/on_end_game(datum/deathmatch_lobby/lobby)
	return

///Apply the modifier to the newly spawned player as the game is about to start
/datum/deathmatch_modifier/proc/apply(mob/living/carbon/player, datum/deathmatch_lobby/lobby)
	return

/datum/deathmatch_modifier/health
	name = "双倍生命值"
	description = "初始生命值翻倍"
	blacklisted_modifiers = list(/datum/deathmatch_modifier/health/half, /datum/deathmatch_modifier/health/triple)
	var/multiplier = 2

/datum/deathmatch_modifier/health/apply(mob/living/carbon/player, datum/deathmatch_lobby/lobby)
	player.maxHealth *= multiplier
	player.health *= multiplier

/datum/deathmatch_modifier/health/half
	name = "半额生命值"
	description = "这是你的葬礼"
	blacklisted_modifiers = list(/datum/deathmatch_modifier/health, /datum/deathmatch_modifier/health/triple)
	multiplier = 0.5

/datum/deathmatch_modifier/health/triple
	name = "三倍生命值"
	description = "当\"双倍生命\"还不够时..."
	multiplier = 3
	blacklisted_modifiers = list(/datum/deathmatch_modifier/health, /datum/deathmatch_modifier/health/half)


/datum/deathmatch_modifier/tenacity
	name = "坚韧"
	description = "不受重伤状态和疼痛影响"

/datum/deathmatch_modifier/tenacity/apply(mob/living/carbon/player, datum/deathmatch_lobby/lobby)
	player.add_traits(list(TRAIT_NOSOFTCRIT, TRAIT_NOHARDCRIT, TRAIT_ANALGESIA, TRAIT_NO_DAMAGE_OVERLAY), DEATHMATCH_TRAIT)

/datum/deathmatch_modifier/no_wounds
	name = "无创伤"
	description = "啊，那些人们脑袋上还没有凹痕的美好旧时光..."

/datum/deathmatch_modifier/no_wounds/apply(mob/living/carbon/player, datum/deathmatch_lobby/lobby)
	ADD_TRAIT(player, TRAIT_NEVER_WOUNDED, DEATHMATCH_TRAIT)

/datum/deathmatch_modifier/no_knockdown
	name = "无击倒"
	description = "我他妈是无敌的！"

/datum/deathmatch_modifier/no_knockdown/apply(mob/living/carbon/player, datum/deathmatch_lobby/lobby)
	player.add_traits(list(TRAIT_STUNIMMUNE, TRAIT_SLEEPIMMUNE), DEATHMATCH_TRAIT)

/datum/deathmatch_modifier/no_slowdown
	name = "无减速"
	description = "你太慢了！"

/datum/deathmatch_modifier/no_slowdown/apply(mob/living/carbon/player, datum/deathmatch_lobby/lobby)
	ADD_TRAIT(player, TRAIT_IGNORESLOWDOWN, DEATHMATCH_TRAIT)

/datum/deathmatch_modifier/teleport
	name = "随机传送"
	description = "上一秒我在这里，下一秒我就在那里"
	///A lazylist of lobbies that have this modifier enabled
	var/list/signed_lobbies
	///The cooldown to the teleportation effect.
	COOLDOWN_DECLARE(teleport_cd)

/datum/deathmatch_modifier/teleport/on_select(datum/deathmatch_lobby/lobby)
	if(isnull(signed_lobbies))
		START_PROCESSING(SSprocessing, src)
	LAZYADD(signed_lobbies, lobby)
	RegisterSignal(lobby, COMSIG_QDELETING, PROC_REF(remove_lobby))

/datum/deathmatch_modifier/teleport/unselect(datum/deathmatch_lobby/lobby)
	remove_lobby(lobby)

/datum/deathmatch_modifier/teleport/proc/remove_lobby(datum/deathmatch_lobby/lobby)
	SIGNAL_HANDLER
	LAZYREMOVE(signed_lobbies, lobby)
	UnregisterSignal(lobby, COMSIG_QDELETING)
	if(isnull(signed_lobbies))
		STOP_PROCESSING(SSprocessing, src)

/datum/deathmatch_modifier/teleport/process(seconds_per_tick)
	if(!COOLDOWN_FINISHED(src, teleport_cd))
		return

	for(var/datum/deathmatch_lobby/lobby as anything in signed_lobbies)
		if(lobby.playing != DEATHMATCH_PLAYING || isnull(lobby.location))
			continue
		for(var/ckey in lobby.players)
			var/mob/living/player = lobby.players[ckey]["mob"]
			if(istype(player))
				continue
			var/turf/destination
			for(var/attempt in 1 to 5)
				var/turf/possible_destination = pick(lobby.location.reserved_turfs)
				if(isopenturf(destination) && !isgroundlessturf(destination))
					destination = possible_destination
					break
			if(isnull(destination))
				continue
			//I want this modifier to be compatible with 'Mounts' and 'Paraplegic' wheelchairs.
			var/atom/movable/currently_buckled = player.buckled
			do_teleport(player, destination, 0, asoundin = 'sound/effects/phasein.ogg', forced = TRUE)
			if(currently_buckled && !currently_buckled.anchored)
				do_teleport(currently_buckled, destination, 0, asoundin = 'sound/effects/phasein.ogg', forced = TRUE)
				currently_buckled.buckle_mob(player)

	COOLDOWN_START(src, teleport_cd, rand(12 SECONDS, 24 SECONDS))

/datum/deathmatch_modifier/snail_crawl
	name = "蜗牛爬行"
	description = "用你的身体涂抹地板，使其变得润滑"
	blacklisted_modifiers = list(/datum/deathmatch_modifier/no_gravity)

/datum/deathmatch_modifier/snail_crawl/apply(mob/living/carbon/player, datum/deathmatch_lobby/lobby)
	player.AddElement(/datum/element/lube_walking, require_resting = TRUE)

/datum/deathmatch_modifier/blinking_and_breathing
	name = "手动眨眼/呼吸"
	description = "通过强制他们手动呼吸和眨眼来破坏所有人的乐趣"

/datum/deathmatch_modifier/blinking_and_breathing/apply(mob/living/carbon/player, datum/deathmatch_lobby/lobby)
	player.AddComponent(/datum/component/manual_blinking)
	player.AddComponent(/datum/component/manual_breathing)

/datum/deathmatch_modifier/forcefield_trail
	name = "力场轨迹"
	description = "你会在身后留下短暂存在、无法通行的力场"

/datum/deathmatch_modifier/forcefield_trail/apply(mob/living/carbon/player, datum/deathmatch_lobby/lobby)
	player.AddElement(/datum/element/effect_trail, /obj/effect/forcefield/cosmic_field/extrafast)

/datum/deathmatch_modifier/xray
	name = "X射线视觉"
	description = "看穿死亡竞赛竞技场的边界！"
	blacklisted_modifiers = list(/datum/deathmatch_modifier/thermal)

/datum/deathmatch_modifier/xray/apply(mob/living/carbon/player, datum/deathmatch_lobby/lobby)
	ADD_TRAIT(player, TRAIT_XRAY_VISION, DEATHMATCH_TRAIT)
	player.update_sight()

/datum/deathmatch_modifier/thermal
	name = "热成像视觉"
	description = "看穿墙壁发现生物"
	blacklisted_modifiers = list(/datum/deathmatch_modifier/xray)

/datum/deathmatch_modifier/thermal/apply(mob/living/carbon/player, datum/deathmatch_lobby/lobby)
	ADD_TRAIT(player, TRAIT_THERMAL_VISION, DEATHMATCH_TRAIT)
	player.update_sight()

/datum/deathmatch_modifier/regen
	name = "生命恢复"
	description = "这是你能得到的最接近免费医疗保险的东西"

/datum/deathmatch_modifier/regen/apply(mob/living/carbon/player, datum/deathmatch_lobby/lobby)
	player.AddComponent(/datum/component/regenerator, regeneration_delay = 4 SECONDS, brute_per_second = 2.5, burn_per_second = 2.5, tox_per_second = 2.5)

/datum/deathmatch_modifier/nearsightness
	name = "近视"
	description = "哎呀，我把眼镜忘在家里了"

/datum/deathmatch_modifier/nearsightness/apply(mob/living/carbon/player, datum/deathmatch_lobby/lobby)
	player.become_nearsighted(DEATHMATCH_TRAIT)

/datum/deathmatch_modifier/ocelot
	name = "虎猫"
	description = "射速更快，额外跳弹，散布更小。你相当不错！"
	blacklisted_modifiers = list(/datum/deathmatch_modifier/stormtrooper)

/datum/deathmatch_modifier/ocelot/apply(mob/living/carbon/player, datum/deathmatch_lobby/lobby)
	player.add_traits(list(TRAIT_NICE_SHOT, TRAIT_DOUBLE_TAP), DEATHMATCH_TRAIT)
	RegisterSignal(player, COMSIG_MOB_FIRED_GUN, PROC_REF(reduce_spread))
	RegisterSignal(player, COMSIG_PROJECTILE_FIRER_BEFORE_FIRE, PROC_REF(apply_ricochet))

/datum/deathmatch_modifier/ocelot/proc/reduce_spread(mob/user, obj/item/gun/gun_fired, target, params, zone_override, list/bonus_spread_values)
	SIGNAL_HANDLER
	bonus_spread_values[MIN_BONUS_SPREAD_INDEX] -= 50
	bonus_spread_values[MAX_BONUS_SPREAD_INDEX] -= 50

/datum/deathmatch_modifier/ocelot/proc/apply_ricochet(mob/user, obj/projectile/projectile, datum/fired_from, atom/clicked_atom)
	SIGNAL_HANDLER
	projectile.ricochets_max += 2
	projectile.min_ricochets += 2
	projectile.ricochet_incidence_leeway = 0
	projectile.accuracy_falloff = 0

/datum/deathmatch_modifier/stormtrooper
	name = "暴风兵准星"
	description = "刚从‘我根本瞄不准’学校毕业"
	blacklisted_modifiers = list(/datum/deathmatch_modifier/ocelot)

/datum/deathmatch_modifier/stormtrooper/apply(mob/living/carbon/player, datum/deathmatch_lobby/lobby)
	RegisterSignal(player, COMSIG_MOB_FIRED_GUN, PROC_REF(increase_spread))

/datum/deathmatch_modifier/stormtrooper/proc/increase_spread(mob/user, obj/item/gun/gun_fired, target, params, zone_override, list/bonus_spread_values)
	SIGNAL_HANDLER
	bonus_spread_values[MIN_BONUS_SPREAD_INDEX] += 10
	bonus_spread_values[MAX_BONUS_SPREAD_INDEX] += 35

/datum/deathmatch_modifier/four_hands
	name = "四只手"
	description = "当一双不够用时……"

/datum/deathmatch_modifier/four_hands/apply(mob/living/carbon/player, datum/deathmatch_lobby/lobby)
	player.change_number_of_hands(4)

/datum/deathmatch_modifier/paraplegic
	name = "截瘫"
	description = "轮椅。给。每个人。"

/datum/deathmatch_modifier/paraplegic/apply(mob/living/carbon/player, datum/deathmatch_lobby/lobby)
	player.gain_trauma(/datum/brain_trauma/severe/paralysis/paraplegic, TRAUMA_RESILIENCE_ABSOLUTE)
	///Mounts are being used. Do not spawn wheelchairs.
	if(/datum/deathmatch_modifier/mounts in lobby.modifiers)
		return
	var/obj/vehicle/ridden/wheelchair/motorized/improved/wheels = new (player.loc)
	wheels.setDir(player.dir)
	wheels.buckle_mob(player)

/datum/deathmatch_modifier/mounts
	name = "坐骑"
	description = "一匹马！一匹马！我的王国换一匹马！"

/datum/deathmatch_modifier/mounts/apply(mob/living/carbon/player, datum/deathmatch_lobby/lobby)
	///We do a bit of fun over balance here, some mounts may be better than others.
	var/mount_path = pick(list(
		/mob/living/basic/carp,
		/mob/living/basic/pony,
		/mob/living/basic/pony/syndicate,
		/mob/living/basic/pig,
		/mob/living/basic/cow,
		/mob/living/basic/cow/moonicorn,
		/mob/living/basic/mining/wolf,
		/mob/living/basic/mining/goldgrub,
		/mob/living/basic/mining/goliath/deathmatch,
		))
	var/mob/living/basic/mount = new mount_path (player.loc)
	mount.tamed(player, null)
	mount.befriend(player)
	mount.buckle_mob(player)
	if(HAS_TRAIT(lobby, TRAIT_DEATHMATCH_EXPLOSIVE_IMPLANTS))
		var/obj/item/implant/explosive/deathmatch/implant = new()
		implant.implant(mount, silent = TRUE, force = TRUE)

/datum/deathmatch_modifier/no_gravity
	name = "无重力"
	description = "在零重力环境下磨练你的战斗技巧"
	blacklisted_modifiers = list(/datum/deathmatch_modifier/mounts, /datum/deathmatch_modifier/paraplegic, /datum/deathmatch_modifier/minefield)

/datum/deathmatch_modifier/no_gravity/on_start_game(datum/deathmatch_lobby/lobby)
	ASYNC
		for(var/turf/turf as anything in lobby.location.reserved_turfs)
			turf.AddElement(/datum/element/forced_gravity, 0)
			CHECK_TICK

/datum/deathmatch_modifier/no_gravity/on_end_game(datum/deathmatch_lobby/lobby)
	for(var/turf/turf as anything in lobby.location.reserved_turfs)
		turf.RemoveElement(/datum/element/forced_gravity, 0)

/datum/deathmatch_modifier/drop_pod
	name = "空投舱：辛迪加"
	description = "钢铁之雨：辛迪加版"
	///A lazylist of lobbies that have this modifier enabled
	var/list/signed_lobbies
	///The type of drop pod that'll periodically fall from the sky
	var/drop_pod_type = /obj/structure/closet/supplypod/podspawn/deathmatch
	///A (weighted) list of possible contents of the drop pod. Only one is picked at a time
	var/list/contents
	///An interval representing the min and max cooldown between each time it's fired.
	var/interval = list(7 SECONDS, 12 SECONDS)
	///How many (a number or a two keyed list) drop pods can be dropped at a time.
	var/amount = list(1, 2)
	///The cooldown for dropping pods into every affected deathmatch arena.
	COOLDOWN_DECLARE(drop_pod_cd)

/datum/deathmatch_modifier/drop_pod/New()
	. = ..()
	populate_contents()

/datum/deathmatch_modifier/drop_pod/on_select(datum/deathmatch_lobby/lobby)
	if(isnull(signed_lobbies))
		START_PROCESSING(SSprocessing, src)
	LAZYADD(signed_lobbies, lobby)
	RegisterSignal(lobby, COMSIG_QDELETING, PROC_REF(remove_lobby))

/datum/deathmatch_modifier/drop_pod/unselect(datum/deathmatch_lobby/lobby)
	remove_lobby(lobby)

/datum/deathmatch_modifier/drop_pod/proc/remove_lobby(datum/deathmatch_lobby/lobby)
	SIGNAL_HANDLER
	LAZYREMOVE(signed_lobbies, lobby)
	UnregisterSignal(lobby, COMSIG_QDELETING)
	if(isnull(signed_lobbies))
		STOP_PROCESSING(SSprocessing, src)

/datum/deathmatch_modifier/drop_pod/process(seconds_per_tick)
	if(!COOLDOWN_FINISHED(src, drop_pod_cd))
		return
	var/pod_spawned = FALSE
	for(var/datum/deathmatch_lobby/lobby as anything in signed_lobbies)
		if(lobby.playing != DEATHMATCH_PLAYING || isnull(lobby.location))
			continue
		var/yet_to_spawn = islist(amount) ? rand(amount[1], amount[2]) : amount
		for(var/attempt in 1 to 10)
			var/turf/to_strike = pick(lobby.location.reserved_turfs)
			if(!isopenturf(to_strike) || isgroundlessturf(to_strike))
				continue
			var/atom/movable/to_spawn
			if(length(contents))
				var/spawn_path = pick_weight(contents)
				to_spawn = new spawn_path (to_strike)
				if(isliving(to_spawn) && HAS_TRAIT(lobby, TRAIT_DEATHMATCH_EXPLOSIVE_IMPLANTS))
					var/obj/item/implant/explosive/deathmatch/implant = new()
					implant.implant(to_spawn, silent = TRUE, force = TRUE)
			podspawn(list(
				"path" = drop_pod_type,
				"target" = to_strike,
				"spawn" = to_spawn,
			))
			pod_spawned = TRUE
			yet_to_spawn--
			if(yet_to_spawn == 0)
				break

	if(pod_spawned)
		COOLDOWN_START(src, drop_pod_cd, rand(interval[1], interval[2]))

/datum/deathmatch_modifier/drop_pod/proc/populate_contents()
	contents = typesof(/mob/living/basic/trooper/syndicate)
	for(var/typepath in contents) //Make sure to set even weights for the keys or `pick_weight` won't work.
		contents[typepath] = 1

/datum/deathmatch_modifier/drop_pod/monsters
	name = "空投舱：怪物"
	description = "怪物正从天而降！"

/datum/deathmatch_modifier/drop_pod/monsters/populate_contents()
	contents = list(
		/mob/living/basic/ant = 2,
		/mob/living/basic/construct/proteon = 2,
		/mob/living/basic/dark_wizard = 2,
		/mob/living/basic/flesh_spider = 2,
		/mob/living/basic/garden_gnome = 2,
		/mob/living/basic/goose = 2,
		/mob/living/basic/killer_tomato = 2,
		/mob/living/basic/leaper = 1,
		/mob/living/basic/mega_arachnid = 1,
		/mob/living/basic/mining/goliath = 1,
		/mob/living/basic/mining/ice_demon = 1,
		/mob/living/basic/mining/ice_whelp = 1,
		/mob/living/basic/mining/lobstrosity = 1,
		/mob/living/basic/mining/mook = 2,
		/mob/living/basic/mouse/rat = 2,
		/mob/living/basic/vatbeast = 1,
		/mob/living/basic/spider/giant/nurse/scrawny = 2,
		/mob/living/basic/spider/giant/tarantula/scrawny = 2,
		/mob/living/basic/spider/giant/hunter/scrawny = 2,
		/mob/living/simple_animal/hostile/ooze = 1,
	)

/datum/deathmatch_modifier/drop_pod/missiles
	name = "空投舱：巡航导弹"
	description = "你将被猛烈炮击"
	drop_pod_type = /obj/structure/closet/supplypod/deadmatch_missile
	interval = list(3 SECONDS, 5 SECONDS)
	amount = list(1, 3)

/datum/deathmatch_modifier/drop_pod/missiles/populate_contents()
	return

/datum/deathmatch_modifier/explode_on_death
	name = "爆炸性死亡"
	description = "每个人都会获得一个无法手动激活的微型炸弹。"

/datum/deathmatch_modifier/explode_on_death/on_start_game(datum/deathmatch_lobby/lobby)
	ADD_TRAIT(lobby, TRAIT_DEATHMATCH_EXPLOSIVE_IMPLANTS, DEATHMATCH_TRAIT)

/datum/deathmatch_modifier/explode_on_death/apply(mob/living/carbon/player, datum/deathmatch_lobby/lobby)
	var/obj/item/implant/explosive/deathmatch/implant = new()
	implant.implant(player, silent = TRUE, force = TRUE)

/datum/deathmatch_modifier/helgrasp
	name = "赫尔格拉斯普"
	description = "诅咒之手正朝你袭来！"

/datum/deathmatch_modifier/helgrasp/apply(mob/living/carbon/player, datum/deathmatch_lobby/lobby)
	var/metabolism_rate = /datum/reagent/inverse/helgrasp/heretic::metabolization_rate
	player.reagents.add_reagent(/datum/reagent/inverse/helgrasp/heretic, initial(lobby.map.automatic_gameend_time) / metabolism_rate)

/datum/deathmatch_modifier/wasted
	name = "废土化"
	description = "你喝得有点太多了"

/datum/deathmatch_modifier/wasted/apply(mob/living/carbon/player, datum/deathmatch_lobby/lobby)
	player.adjust_drunk_effect(rand(30, 35))
	var/metabolism_rate = /datum/reagent/consumable/ethanol/jack_rose::metabolization_rate
	player.reagents.add_reagent(/datum/reagent/consumable/ethanol/jack_rose, initial(lobby.map.automatic_gameend_time) * 0.35 / metabolism_rate)

/datum/deathmatch_modifier/monkeys
	name = "猴化"
	description = "回去吧，我想当猴子！"

/datum/deathmatch_modifier/monkeys/apply(mob/living/carbon/player, datum/deathmatch_lobby/lobby)
	//we don't call monkeyize(), because it'd set the player name to a generic "monkey(number)".
	player.set_species(/datum/species/monkey)

/datum/deathmatch_modifier/inverted_movement
	name = "反向移动"
	description = "上是下，左是右"

/datum/deathmatch_modifier/inverted_movement/apply(mob/living/carbon/player, datum/deathmatch_lobby/lobby)
	player.AddElement(/datum/element/inverted_movement)

/datum/deathmatch_modifier/minefield
	name = "雷区"
	description = "哦，看来你踩到地雷了！"

/datum/deathmatch_modifier/minefield/on_start_game(datum/deathmatch_lobby/lobby)
	var/list/mines = subtypesof(/obj/effect/mine)
	mines -= list(
		/obj/effect/mine/explosive, //too lethal.
		/obj/effect/mine/kickmine, //will kick the client, lol
		/obj/effect/mine/gas, //Just spawns oxygen.
		/obj/effect/mine/gas/n2o, //no sleeping please.
	)

	///1 every 11 turfs, but it will actually spawn fewer mines since groundless and closed turfs are skipped.
	var/mines_to_spawn = length(lobby.location.reserved_turfs) * 0.09
	for(var/iteration in 1 to mines_to_spawn)
		var/turf/target_turf = pick(lobby.location.reserved_turfs)
		if(!isopenturf(target_turf) || isgroundlessturf(target_turf))
			continue
		///don't spawn mine next to player spawns.
		if(locate(/obj/effect/landmark/deathmatch_player_spawn) in range(1, target_turf))
			continue
		///skip belt loops or they'll explode right away.
		if(locate(/obj/machinery/conveyor) in target_turf.contents)
			continue
		var/mine_path = pick(mines)
		new mine_path (target_turf)

/datum/deathmatch_modifier/random
	name = "随机修饰器"
	description = "在游戏即将开始时，随机选取3到5个修改器"
	random_exempted = TRUE

/datum/deathmatch_modifier/random/on_select(datum/deathmatch_lobby/lobby)
	///remove any other global modifier if chosen. It'll pick random ones when the time comes.
	for(var/modpath in lobby.modifiers)
		var/datum/deathmatch_modifier/modifier = GLOB.deathmatch_game.modifiers[modpath]
		if(modifier.random_exempted)
			continue
		modifier.unselect(lobby)
		lobby.modifiers -= modpath

/datum/deathmatch_modifier/random/on_start_game(datum/deathmatch_lobby/lobby)
	lobby.modifiers -= type //remove it before attempting to select other modifiers, or they'll fail.

	var/static/list/static_pool
	if(isnull(static_pool))
		static_pool = subtypesof(/datum/deathmatch_modifier)
		for(var/datum/deathmatch_modifier/modpath as anything in static_pool)
			if(initial(modpath.random_exempted))
				static_pool -= modpath
	var/list/modifiers_pool = static_pool.Copy()
	for(var/modpath in modifiers_pool)
		var/datum/deathmatch_modifier/modifier = GLOB.deathmatch_game.modifiers[modpath]
		if(!modifier.selectable(lobby))
			modifiers_pool -= modpath

	///Pick global modifiers at random.
	for(var/iteration in 1 to rand(3, 5))
		var/datum/deathmatch_modifier/modifier = GLOB.deathmatch_game.modifiers[pick_n_take(modifiers_pool)]
		modifier.on_select(lobby)
		modifier.on_start_game(lobby)
		lobby += modifier.type
		modifiers_pool -= modifier.blacklisted_modifiers
		if(!length(modifiers_pool))
			return

/datum/deathmatch_modifier/any_loadout
	name = "允许任意装备"
	description = "看着玩家每次都选择一击必杀"
	random_exempted = TRUE

/datum/deathmatch_modifier/any_loadout/selectable(datum/deathmatch_lobby/lobby)
	. = ..()
	if(!.)
		return
	return lobby.map.allowed_loadouts

/datum/deathmatch_modifier/any_loadout/on_select(datum/deathmatch_lobby/lobby)
	lobby.loadouts = GLOB.deathmatch_game.loadouts

/datum/deathmatch_modifier/any_loadout/unselect(datum/deathmatch_lobby/lobby)
	lobby.loadouts = lobby.map.allowed_loadouts

/datum/deathmatch_modifier/any_loadout/on_map_changed(datum/deathmatch_lobby/lobby)
	if(lobby.loadouts == GLOB.deathmatch_game.loadouts) //This arena already allows any loadout for some reason.
		lobby.unselect_modifier(src)
	else
		lobby.loadouts = GLOB.deathmatch_game.loadouts

/datum/deathmatch_modifier/hear_global_chat
	name = "听觉强化"
	description = "这让你能隔墙听到他人说话，也能听到死亡频道"
	random_exempted = TRUE

/datum/deathmatch_modifier/hear_global_chat/apply(mob/living/carbon/player, datum/deathmatch_lobby/lobby)
	player.add_traits(list(TRAIT_SIXTHSENSE, TRAIT_XRAY_HEARING), DEATHMATCH_TRAIT)

/datum/deathmatch_modifier/apply_quirks
	name = "特性已启用"
	description = "将选定的怪癖应用于所有玩家"

/datum/deathmatch_modifier/apply_quirks/apply(mob/living/carbon/player, datum/deathmatch_lobby/lobby)
	if (!player.client)
		return

	SSquirks.AssignQuirks(player, player.client)

/datum/deathmatch_modifier/martial_artistry
	name = "随机武术"
	description = "每个人都学会一门随机的武术！"
	blacklisted_maps = list(/datum/lazy_template/deathmatch/meatower)
	// kaza ruk excluded because its too common and too simple, mushpunch excluded because its horrible and not even funny
	var/static/list/weighted_martial_arts = list(
		// common
		/datum/martial_art/cqc = 30,
		/datum/martial_art/the_sleeping_carp = 30,
		// uncommon
		/datum/martial_art/boxing/evil = 20,
		// LEGENDARY
		/datum/martial_art/plasma_fist = 5,
		/datum/martial_art/wrestling = 5, // wrestling is kinda strong ngl
		/datum/martial_art/psychotic_brawling = 5, // a complete meme. sometimes you just get hardstunned. sometimes you punch someone across the room
	)

/datum/deathmatch_modifier/martial_artistry/apply(mob/living/carbon/player, datum/deathmatch_lobby/lobby)
	. = ..()

	var/datum/martial_art/picked_art_path = pick_weight(weighted_martial_arts)
	var/datum/martial_art/instantiated_art = new picked_art_path(player)

	if (istype(instantiated_art, /datum/martial_art/boxing))
		player.mind.adjust_experience(/datum/skill/athletics, SKILL_EXP_LEGENDARY)

	instantiated_art.teach(player)

	to_chat(player, span_revenboldnotice("你的武术是[uppertext(instantiated_art.name)]！"))
