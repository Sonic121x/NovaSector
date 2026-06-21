////////////////////
//Clusterbang
////////////////////

#define RANDOM_DETONATE_MIN_TIME (1.5 SECONDS)
#define RANDOM_DETONATE_MAX_TIME (6 SECONDS)

/obj/item/grenade/clusterbuster
	desc = "使用此武器在您所在区域可能构成战争罪，请咨询您当地的舰长。"
	name = "集束手榴弹"
	icon = 'icons/obj/weapons/grenade.dmi'
	icon_state = "clusterbang"
	var/base_state = "clusterbang"
	var/payload = /obj/item/grenade/flashbang/cluster
	var/payload_spawner = /obj/effect/payload_spawner
	var/min_spawned = 4
	var/max_spawned = 8
	var/segment_chance = 35

/obj/item/grenade/clusterbuster/apply_grenade_fantasy_bonuses(quality)
	min_spawned = modify_fantasy_variable("min_spawned", min_spawned, round(quality/2))
	max_spawned = modify_fantasy_variable("max_spawned", max_spawned, round(quality/2))

/obj/item/grenade/clusterbuster/remove_grenade_fantasy_bonuses(quality)
	min_spawned = reset_fantasy_variable("min_spawned", min_spawned)
	max_spawned = reset_fantasy_variable("max_spawned", max_spawned)

/obj/item/grenade/clusterbuster/detonate(mob/living/lanced_by)
	. = ..()
	if(!.)
		return

	update_mob()
	var/numspawned = rand(min_spawned, max_spawned)
	var/again = 0

	for(var/_ in 1 to numspawned)
		if(prob(segment_chance))
			again++
			numspawned--

	for(var/loop in 1 to again)
		new /obj/item/grenade/clusterbuster/segment(drop_location(), src)//Creates 'segments' that launches a few more payloads

	new payload_spawner(drop_location(), payload, numspawned)//Launches payload
	playsound(src, grenade_arm_sound, 75, TRUE, -3)
	qdel(src)

//////////////////////
//Clusterbang segment
//////////////////////
/obj/item/grenade/clusterbuster/segment
	desc = "集束手榴弹的一个小分段。最好快跑！"
	name = "集束手榴弹分段"
	icon = 'icons/obj/weapons/grenade.dmi'
	icon_state = "clusterbang_segment"
	base_state = "clusterbang_segment"

/obj/item/grenade/clusterbuster/segment/Initialize(mapload, obj/item/grenade/clusterbuster/base)
	. = ..()

	if(base)
		name = "[base.name] 分段"
		base_state = "[base.base_state]_segment"
		icon_state = base_state
		payload_spawner = base.payload_spawner
		payload = base.payload
		grenade_arm_sound = base.grenade_arm_sound
		min_spawned = base.min_spawned
		max_spawned = base.max_spawned
	icon_state = "[base_state]_active"
	active = TRUE
	var/steps = rand(1, 4)
	for(var/step in 1 to steps)
		step_away(src, loc)
	addtimer(CALLBACK(src, PROC_REF(detonate)), rand(RANDOM_DETONATE_MIN_TIME, RANDOM_DETONATE_MAX_TIME))

/obj/item/grenade/clusterbuster/segment/detonate(mob/living/lanced_by)
	new payload_spawner(drop_location(), payload, rand(min_spawned, max_spawned))
	playsound(src, grenade_arm_sound, 75, TRUE, -3)
	qdel(src)

//////////////////////////////////
//The payload spawner effect
/////////////////////////////////
/obj/effect/payload_spawner/Initialize(mapload, type, numspawned)
	..()
	if(type && isnum(numspawned))
		spawn_payload(type, numspawned)
	return INITIALIZE_HINT_QDEL

/obj/effect/payload_spawner/proc/spawn_payload(type, numspawned)
	for(var/_ in 1 to numspawned)
		var/obj/item/grenade/grenade = new type(loc)
		if(istype(grenade))
			grenade.active = TRUE
			grenade.type_cluster = TRUE
			addtimer(CALLBACK(grenade, TYPE_PROC_REF(/obj/item/grenade, detonate)), rand(RANDOM_DETONATE_MIN_TIME, RANDOM_DETONATE_MAX_TIME))
		var/steps = rand(1, 4)
		for(var/step in 1 to steps)
			step_away(src, loc)

/obj/effect/payload_spawner/random_slime
	var/volatile = FALSE

/obj/effect/payload_spawner/random_slime/volatile
	volatile = TRUE

/obj/effect/payload_spawner/random_slime/spawn_payload(type, numspawned)
	for(var/_ in 1 to numspawned)
		var/chosen = pick(subtypesof(/obj/item/slime_extract))
		var/obj/item/slime_extract/slime_extract = new chosen(loc)
		if(volatile)
			addtimer(CALLBACK(slime_extract, TYPE_PROC_REF(/obj/item/slime_extract, auto_activate_reaction)), rand(RANDOM_DETONATE_MIN_TIME, RANDOM_DETONATE_MAX_TIME))
		var/steps = rand(1, 4)
		for(var/step in 1 to steps)
			step_away(src, loc)

#undef RANDOM_DETONATE_MIN_TIME
#undef RANDOM_DETONATE_MAX_TIME

//////////////////////////////////
//Custom payload clusterbusters
/////////////////////////////////
/obj/item/grenade/flashbang/cluster
	icon_state = "flashbang_active"

/obj/item/grenade/clusterbuster/emp
	name = "电磁风暴"
	payload = /obj/item/grenade/empgrenade

/obj/item/grenade/clusterbuster/smoke
	name = "忍者消失术"
	payload = /obj/item/grenade/smokebomb

/obj/item/grenade/clusterbuster/metalfoam
	name = "速凝混凝土"
	payload = /obj/item/grenade/chem_grenade/metalfoam

/obj/item/grenade/clusterbuster/inferno
	name = "炼狱"
	payload = /obj/item/grenade/chem_grenade/incendiary

/obj/item/grenade/clusterbuster/antiweed
	name = "除草灵"
	payload = /obj/item/grenade/chem_grenade/antiweed

/obj/item/grenade/clusterbuster/cleaner
	name = "Proper先生"
	payload = /obj/item/grenade/chem_grenade/cleaner

/obj/item/grenade/clusterbuster/teargas
	name = "洋葱手榴弹"
	payload = /obj/item/grenade/chem_grenade/teargas

/obj/item/grenade/clusterbuster/facid
	name = "酸蚀之雨"
	payload = /obj/item/grenade/chem_grenade/facid

/obj/item/grenade/clusterbuster/syndieminibomb
	name = "辛迪之怒"
	payload = /obj/item/grenade/syndieminibomb

/obj/item/grenade/clusterbuster/spawner_manhacks
	name = "i开膛手"
	payload = /obj/item/grenade/spawnergrenade/manhacks

/obj/item/grenade/clusterbuster/spawner_spesscarp
	name = "太空鲤鱼入侵"
	payload = /obj/item/grenade/spawnergrenade/spesscarp

/obj/item/grenade/clusterbuster/soap
	name = "滑倒末日"
	payload = /obj/item/grenade/spawnergrenade/syndiesoap

/obj/item/grenade/clusterbuster/clf3
	name = "欢迎来到地狱"
	payload = /obj/item/grenade/chem_grenade/clf3

//random clusterbuster spawner
/obj/item/grenade/clusterbuster/random
	icon_state = "random_clusterbang"

/obj/item/grenade/clusterbuster/random/Initialize(mapload)
	..()
	var/real_type = pick(subtypesof(/obj/item/grenade/clusterbuster))
	new real_type(loc)
	return INITIALIZE_HINT_QDEL

//rainbow slime effect
/obj/item/grenade/clusterbuster/slime
	name = "噗噜噗噜"
	icon_state = "slimebang"
	base_state = "slimebang"
	payload_spawner = /obj/effect/payload_spawner/random_slime
	grenade_arm_sound = 'sound/effects/bubbles/bubbles.ogg'

/obj/item/grenade/clusterbuster/slime/volatile
	payload_spawner = /obj/effect/payload_spawner/random_slime/volatile
