//Necropolis Tendrils, which spawn lavaland monsters and break into a chasm when killed
/obj/structure/spawner/lavaland
	name = "墓地卷须"
	desc = "一根邪恶的腐败触须，源自地下深处。可怕的怪物从这里涌出。"

	icon = 'icons/mob/simple/lavaland/nest.dmi'
	icon_state = "tendril"

	faction = list(FACTION_MINING, FACTION_MINING_FAUNA) // NOVA EDIT CHANGE - ORIGINAL: faction = list(FACTION_MINING, FACTION_ASHWALKER)
	max_mobs = 3
	max_integrity = 250
	mob_types = list(/mob/living/basic/mining/watcher)

	move_resist=INFINITY // just killing it tears a massive hole in the ground, let's not move it
	anchored = TRUE
	resistance_flags = FIRE_PROOF | LAVA_PROOF
	var/obj/effect/light_emitter/tendril/emitted_light
	scanner_taggable = TRUE
	mob_gps_id = "WT"
	spawner_gps_id = "Necropolis Tendril"

/obj/structure/spawner/lavaland/goliath
	mob_types = list(/mob/living/basic/mining/goliath)
	mob_gps_id = "GL"

/obj/structure/spawner/lavaland/legion
	mob_types = list(/mob/living/basic/mining/legion/spawner_made)
	mob_gps_id = "LG"

/obj/structure/spawner/lavaland/icewatcher
	mob_types = list(/mob/living/basic/mining/watcher/icewing)
	mob_gps_id = "WT|I" // icewing

GLOBAL_LIST_INIT(tendrils, list())
/obj/structure/spawner/lavaland/Initialize(mapload)
	. = ..()
	emitted_light = new(loc)
	for(var/F in RANGE_TURFS(1, src))
		if(ismineralturf(F))
			var/turf/closed/mineral/M = F
			M.ScrapeAway(null, CHANGETURF_IGNORE_AIR)
	AddComponent(/datum/component/gps, "Eerie Signal")
	GLOB.tendrils += src

/obj/structure/spawner/lavaland/atom_deconstruct(disassembled)
	new /obj/effect/collapse(loc)

/obj/structure/spawner/lavaland/examine(mob/user)
	var/list/examine_messages = ..()
	examine_messages += span_notice("一旦这东西受到足够伤害，就会触发一次猛烈的最终反击。")
	examine_messages += span_notice("你只有几秒钟时间冲上去，用空着的手抓些战利品，然后带着它逃出来。")
	return examine_messages

/obj/structure/spawner/lavaland/Destroy()
	var/last_tendril = TRUE
	if(GLOB.tendrils.len>1)
		last_tendril = FALSE

	if(last_tendril && !(flags_1 & ADMIN_SPAWNED_1))
		if(SSachievements.achievements_enabled)
			for(var/mob/living/L in view(7,src))
				if(L.stat || !L.client)
					continue
				L.client.give_award(/datum/award/achievement/boss/tendril_exterminator, L)
				L.client.give_award(/datum/award/score/tendril_score, L) //Progresses score by one
	GLOB.tendrils -= src
	QDEL_NULL(emitted_light)
	return ..()

/obj/effect/light_emitter/tendril
	set_luminosity = 4
	set_cap = 2.5
	light_color = LIGHT_COLOR_LAVA

/obj/effect/collapse
	name = "塌陷中的墓地卷须"
	desc = "拿好你的战利品，然后赶快跑路！"
	layer = TABLE_LAYER
	icon = 'icons/mob/simple/lavaland/nest.dmi'
	icon_state = "tendril"
	anchored = TRUE
	density = TRUE
	/// weakref list of which mobs have gotten their loot from this effect.
	var/list/collected = list()
	/// a bit of light as to make less unfair deaths from the chasm
	var/obj/effect/light_emitter/tendril/emitted_light

/obj/effect/collapse/Initialize(mapload)
	. = ..()
	emitted_light = new(loc)
	visible_message(span_bolddanger("触须狂怒地扭动着，周围的地面开始开裂崩碎！快退后！"))
	balloon_alert_to_viewers("interact to grab loot before collapse!", vision_distance = 7)
	playsound(loc,'sound/effects/tendril_destroyed.ogg', 200, FALSE, 50, TRUE, TRUE)
	addtimer(CALLBACK(src, PROC_REF(collapse)), 5 SECONDS)

/obj/effect/collapse/examine(mob/user)
	var/list/examine_messages = ..()
	if(isliving(user))
		if(has_collected(user))
			examine_messages += span_boldnotice("你已经拿到了能拿的东西，现在快逃！")
		else
			examine_messages += span_boldnotice("在它彻底崩塌前，你或许还有一点时间用空着的手抓些好东西！")
	return examine_messages

/obj/effect/collapse/attack_hand(mob/living/collector, list/modifiers)
	. = ..()
	if(has_collected(collector))
		to_chat(collector, span_danger("你已经拿到了一些战利品，快带着它离开那里！"))
		return
	visible_message(span_warning("有什么东西从触须上掉了下来！"))
	var/obj/structure/closet/crate/necropolis/tendril/loot = new /obj/structure/closet/crate/necropolis/tendril(loc)
	collector.start_pulling(loot)
	collected += WEAKREF(collector)

/obj/effect/collapse/Destroy()
	collected.Cut()
	QDEL_NULL(emitted_light)
	return ..()

///Helper proc that resolves weakrefs to determine if collector is in collected list, returning a boolean.
/obj/effect/collapse/proc/has_collected(mob/collector)
	for(var/datum/weakref/weakref as anything in collected)
		var/mob/living/resolved = weakref.resolve()
		//it could have been collector, it could not have been, we don't care
		if(!resolved)
			continue
		if(resolved == collector)
			return TRUE
	return FALSE

/obj/effect/collapse/proc/collapse()
	for(var/mob/M in range(7,src))
		shake_camera(M, 15, 1)
	playsound(get_turf(src),'sound/effects/explosion/explosionfar.ogg', 200, TRUE)
	visible_message(span_bolddanger("触须向内塌陷，周围的地面裂开，形成了一个深不见底的裂口！"))
	for(var/turf/T in RANGE_TURFS(2,src))
		if(HAS_TRAIT(T, TRAIT_NO_TERRAFORM))
			continue
		if(!T.density)
			T.TerraformTurf(/turf/open/chasm/lavaland, /turf/open/chasm/lavaland, flags = CHANGETURF_INHERIT_AIR)
	qdel(src)
