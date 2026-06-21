/obj/item/grenade/gas_crystal
	desc = "某种晶体，这不应该生成"
	name = "气体晶体"
	icon = 'icons/obj/weapons/grenade.dmi'
	icon_state = "bluefrag"
	inhand_icon_state = "flashbang"
	resistance_flags = FIRE_PROOF

/obj/item/grenade/gas_crystal/arm_grenade(mob/user, delayoverride, msg = TRUE, volume = 60)
	log_grenade(user) //Inbuilt admin procs already handle null users
	if(user)
		add_fingerprint(user)
		if(msg)
			to_chat(user, span_warning("你捏碎了[src]！[capitalize(DisplayTimeText(det_time))]！"))
	if(shrapnel_type && shrapnel_radius)
		shrapnel_initialized = TRUE
		AddComponent(/datum/component/pellet_cloud, projectile_type = shrapnel_type, magnitude = shrapnel_radius)
	active = TRUE
	icon_state = initial(icon_state) + "_active"
	playsound(src, 'sound/effects/hit_on_shattered_glass.ogg', volume, TRUE)
	SEND_SIGNAL(src, COMSIG_GRENADE_ARMED, det_time, delayoverride)
	if(user)
		SEND_SIGNAL(src, COMSIG_MOB_GRENADE_ARMED, user, src, det_time, delayoverride)
	addtimer(CALLBACK(src, PROC_REF(detonate)), isnull(delayoverride)? det_time : delayoverride)

/obj/item/grenade/gas_crystal/healium_crystal
	name = "希利姆晶体"
	desc = "由希利姆气体形成的晶体，触感冰凉。"
	icon_state = "healium_crystal"
	///Range of the grenade that will cool down and affect mobs
	var/fix_range = 7

/obj/item/grenade/gas_crystal/healium_crystal/detonate(mob/living/lanced_by)
	. = ..()
	if(!.)
		return

	update_mob()
	playsound(src, 'sound/effects/spray2.ogg', 100, TRUE)
	var/list/turf_list = RANGE_TURFS(fix_range, src)
	var/datum/gas_mixture/base_mix = SSair.parse_gas_string(OPENTURF_DEFAULT_ATMOS)
	for(var/turf/open/turf_fix in turf_list)
		if(turf_fix.blocks_air)
			continue
		turf_fix.copy_air(base_mix.copy())
		turf_fix.air_update_turf(update = FALSE, remove = FALSE)
	qdel(src)

/obj/item/grenade/gas_crystal/proto_nitrate_crystal
	name = "原硝酸盐晶体"
	desc = "由原硝酸盐气体形成的晶体，你能看到内部液态的气体。"
	icon_state = "proto_nitrate_crystal"
	///Range of the grenade air refilling
	var/refill_range = 5
	///Amount of Nitrogen gas released (close to the grenade)
	var/n2_gas_amount = 80
	///Amount of Oxygen gas released (close to the grenade)
	var/o2_gas_amount = 30

/obj/item/grenade/gas_crystal/proto_nitrate_crystal/detonate(mob/living/lanced_by)
	. = ..()
	if(!.)
		return

	update_mob()
	playsound(src, 'sound/effects/spray2.ogg', 100, TRUE)
	for(var/turf/turf_loc in view(refill_range, loc))
		if(!isopenturf(turf_loc))
			continue
		var/distance_from_center = max(get_dist(turf_loc, loc), 1)
		var/turf/open/floor_loc = turf_loc
		floor_loc.atmos_spawn_air("[GAS_N2]=[n2_gas_amount / distance_from_center];[GAS_O2]=[o2_gas_amount / distance_from_center];[TURF_TEMPERATURE(273)]")
	qdel(src)

/obj/item/grenade/gas_crystal/nitrous_oxide_crystal
	name = "N2O晶体"
	desc = "由N2O气体形成的晶体，你能看到内部液态的气体。"
	icon_state = "n2o_crystal"
	///Range of the grenade air refilling
	var/fill_range = 1
	///Amount of n2o gas released (close to the grenade)
	var/n2o_gas_amount = 10

/obj/item/grenade/gas_crystal/nitrous_oxide_crystal/detonate(mob/living/lanced_by)
	. = ..()
	if(!.)
		return

	update_mob()
	playsound(src, 'sound/effects/spray2.ogg', 100, TRUE)
	for(var/turf/turf_loc in view(fill_range, loc))
		if(!isopenturf(turf_loc))
			continue
		var/distance_from_center = max(get_dist(turf_loc, loc), 1)
		var/turf/open/floor_loc = turf_loc
		floor_loc.atmos_spawn_air("[GAS_N2O]=[n2o_gas_amount / distance_from_center];[TURF_TEMPERATURE(273)]")
	qdel(src)

/obj/item/grenade/gas_crystal/crystal_foam
	name = "晶体泡沫"
	desc = "内部朦胧的晶体"
	icon_state = "crystal_foam"
	var/breach_range = 7

/obj/item/grenade/gas_crystal/crystal_foam/detonate(mob/living/lanced_by)
	. = ..()

	var/datum/reagents/first_batch = new
	var/datum/reagents/second_batch = new
	var/list/datum/reagents/reactants = list()

	first_batch.add_reagent(/datum/reagent/aluminium, 75)
	second_batch.add_reagent(/datum/reagent/smart_foaming_agent, 25)
	second_batch.add_reagent(/datum/reagent/toxin/acid/fluacid, 25)
	reactants += first_batch
	reactants += second_batch

	var/turf/detonation_turf = get_turf(src)

	chem_splash(detonation_turf, null, breach_range, reactants)

	playsound(src, 'sound/effects/spray2.ogg', 100, TRUE)
	log_game("A grenade detonated at [AREACOORD(detonation_turf)]")

	update_mob()

	qdel(src)
