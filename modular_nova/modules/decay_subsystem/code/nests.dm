/obj/structure/mob_spawner
	name = "巢穴"
	desc = "一堆由树枝和碎片组成的恶心玩意儿。"
	icon = 'modular_nova/modules/decay_subsystem/icons/nests.dmi'
	icon_state = "nest"
	density = FALSE
	anchored = TRUE
	layer = TABLE_LAYER
	max_integrity = 100
	light_range = 2
	light_power = 1
	light_color = LIGHT_COLOR_LAVA
	faction = list(NEST_FACTION)
	var/spawn_delay = 0
	/// What mob to spawn
	var/list/monster_types = list(/mob/living/basic/spider/giant/hunter)
	/// How many mobs can we spawn?
	var/max_mobs = 3
	var/spawned_mobs = 0
	/// How long it takes for a new mob to emerge after being triggered.
	var/spawn_cooldown = 30 SECONDS
	/// How long it takes to regenerate mobs to spawn again
	var/regenerate_time = 20 MINUTES
	var/retaliated = FALSE
	/// How long it takes for us to retaliate again.
	var/retaliate_cooldown = 20 SECONDS
	var/list/registered_turfs = list()
	/// What loot do we spawn upon death?
	var/list/loot = list()
	/// Do spawned mobs become ghost controllable?
	var/ghost_controllable = FALSE
	/// The range at which these are triggered.
	var/trigger_range = 5
	/// Does this nest passively spawn mobs too?
	var/passive_spawning = FALSE

/obj/structure/mob_spawner/Initialize(mapload)
	. = ..()
	calculate_trigger_turfs()
	if(passive_spawning)
		START_PROCESSING(SSobj, src)

/obj/structure/mob_spawner/proc/calculate_trigger_turfs()
	for(var/turf/open/seen_turf in view(trigger_range, src))
		registered_turfs += seen_turf
		RegisterSignal(seen_turf, COMSIG_ATOM_ENTERED, PROC_REF(proximity_trigger))

/obj/structure/mob_spawner/atom_destruction(damage_flag)
	if(loot)
		for(var/path in loot)
			var/number = loot[path]
			if(!isnum(number))//Default to 1
				number = 1
			for(var/i in 1 to number)
				new path (loc)
	playsound(src, 'sound/effects/blob/blobattack.ogg', 100)
	return ..()

/obj/structure/mob_spawner/Destroy()
	for(var/t in registered_turfs)
		UnregisterSignal(t, COMSIG_ATOM_ENTERED)
	registered_turfs = null
	if(passive_spawning)
		STOP_PROCESSING(SSobj, src)
	return ..()

/obj/structure/mob_spawner/process(seconds_per_tick)
	if(passive_spawning)
		if(spawned_mobs >= max_mobs)
			return
		if(spawn_delay > world.time)
			return
		spawn_delay = world.time + spawn_cooldown
		spawn_mob()

/obj/structure/mob_spawner/proc/proximity_trigger(datum/source, atom/movable/AM)
	SIGNAL_HANDLER
	if(spawned_mobs >= max_mobs)
		return
	if(spawn_delay > world.time)
		return
	spawn_delay = world.time + spawn_cooldown

	if(!isliving(AM))
		return

	var/mob/living/entered_mob = AM

	if((entered_mob.has_faction(NEST_FACTION)))
		return

	spawn_mob()

/obj/structure/mob_spawner/proc/spawn_mob()
	var/sound/sound_to_play = pick('modular_nova/master_files/sound/effects/rustle1.ogg', 'modular_nova/master_files/sound/effects/rustle2.ogg')
	playsound(src, sound_to_play, 100)
	do_squish(0.8, 1.2)

	spawned_mobs++

	var/chosen_mob_type = pick(monster_types)
	var/mob/living/spawned_mob = new chosen_mob_type(loc)

	spawned_mob.flags_1 |= (flags_1 & ADMIN_SPAWNED_1)
	spawned_mob.set_faction(faction)
	spawned_mob.ghost_controllable = ghost_controllable

	RegisterSignal(spawned_mob, COMSIG_LIVING_DEATH, PROC_REF(mob_death))

	visible_message(span_danger("[spawned_mob]从[src]中钻了出来。"))

/obj/structure/mob_spawner/proc/mob_death(mob/living/dead_guy, gibbed)
	SIGNAL_HANDLER
	spawned_mobs--
	UnregisterSignal(dead_guy, COMSIG_LIVING_DEATH)

/obj/structure/mob_spawner/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	do_jiggle_nova()
	if(!retaliated)
		visible_message(span_danger("[src]愤怒地发出咕噜声！"))
		var/chosen_mob_type = pick(monster_types)
		var/mob/living/simple_animal/L = new chosen_mob_type(loc)
		visible_message(span_danger("[L]从[src]中钻了出来。"))
		retaliated = TRUE
		addtimer(CALLBACK(src, PROC_REF(ready_retaliate)), retaliate_cooldown)

/obj/structure/mob_spawner/proc/ready_retaliate()
	retaliated = FALSE
	visible_message(span_danger("[src]平静了下来。"))

/*
*	CUSTOM SPAWNERS
*/

/obj/structure/mob_spawner/spiders
	name = "粘性蛛网"
	desc = "一团粘稠的蛛网和看起来恶心的卵..."
	icon_state = "nest_spider"
	light_color = LIGHT_COLOR_BLOOD_MAGIC
	monster_types = list(/mob/living/basic/spider/giant/hunter, /mob/living/basic/spider/giant/)
	loot = list(/obj/item/spider_egg = 4)

/obj/item/spider_egg
	name = "蜘蛛卵"
	desc = "一颗白色的卵，里面有东西在蠕动。看起来...很脆弱。"
	icon = 'modular_nova/modules/decay_subsystem/icons/loot.dmi'
	icon_state = "spider_egg"

/obj/item/spider_egg/attack_self(mob/user, modifiers)
	. = ..()
	to_chat(user, span_danger("你开始撬开[src]..."))
	if(do_after(user, 3 SECONDS, src))
		to_chat(user, span_userdanger("你撬开了[src]，有什么怪物般的东西爬了出来！"))
		playsound(src, 'sound/effects/blob/blobattack.ogg', 100)
		new /mob/living/basic/spider/giant/ (user.loc)
		qdel(src)

/obj/structure/mob_spawner/bush
	name = "血淋淋的灌木丛"
	desc = "一丛灌木...在渗血？"
	icon_state = "nest_grass"
	light_color = LIGHT_COLOR_GREEN
	monster_types = list(/mob/living/basic/killer_tomato)
	loot = list(/obj/item/seeds/random = 3)
	max_mobs = 6

/obj/structure/mob_spawner/beehive
	name = "蜂巢"
	desc = "里面充满了只为让你的生活变成人间地狱的小生物。"
	icon_state = "nest_bee"
	light_color = LIGHT_COLOR_BRIGHT_YELLOW
	monster_types = list(/mob/living/basic/bee)
	max_mobs = 15
	spawn_cooldown = 5 SECONDS
	loot = list(/obj/item/food/honeycomb = 5, /obj/item/queen_bee)
	var/swarmed = FALSE

/obj/structure/mob_spawner/beehive/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	if(!swarmed)
		playsound(src, 'sound/mobs/non-humanoids/bee/bee.ogg', 100)
		visible_message(span_userdanger("[src]剧烈地嗡嗡作响，蜜蜂倾巢而出！"))
		for(var/i=1, i<max_mobs, ++i)
			new /mob/living/basic/bee (loc)
		swarmed = TRUE

/obj/structure/mob_spawner/beehive/toxic
	name = "渗液蜂巢"
	desc = "一个蜂巢……但它看起来不对劲，正渗出某种发着绿光的粘稠物。"
	icon_state = "nest_bee_toxic"
	monster_types = list(/mob/living/basic/bee/toxin)
	max_mobs = 6
	color = LIGHT_COLOR_ELECTRIC_GREEN

/obj/structure/mob_spawner/snake
	name = "恶心的卵"
	desc = "这些搏动着的卵正渗出脓液般的物质……"
	icon_state = "nest_eggs"
	light_color = LIGHT_COLOR_BRIGHT_YELLOW
	monster_types = list(/mob/living/basic/snake)
	max_mobs = 8
	spawn_cooldown = 5 SECONDS

/obj/structure/mob_spawner/rats
	name = "肮脏的巢穴"
	desc = "一个爬满了……某种东西的巢穴！"
	icon_state = "nest_rats"
	light_color = LIGHT_COLOR_GREEN
	max_mobs = 8
	spawn_cooldown = 15 SECONDS
	monster_types = list(/mob/living/basic/mouse/rat)
	loot = list(/obj/item/seeds/replicapod = 2)

/obj/structure/mob_spawner/grapes
	name = "葡萄藤"
	desc = "一根葡萄藤……上面有……卵？"
	icon_state = "nest_grapes"
	light_color = LIGHT_COLOR_PURPLE
	monster_types = list(/mob/living/simple_animal/hostile/ooze/grapes)
	loot = list(/obj/item/resurrection_crystal)

/obj/structure/mob_spawner/grapes/atom_destruction(damage_flag)
	if(loot)
		for(var/path in loot)
			var/number = loot[path]
			if(!isnum(number))//Default to 1
				number = 1
			for(var/i in 1 to number)
				new path (loc)
	playsound(src, 'sound/effects/blob/blobattack.ogg', 100)
	new /mob/living/basic/vatbeast(loc)
	return ..()
