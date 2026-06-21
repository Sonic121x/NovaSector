/datum/action/cooldown/mob_cooldown/the_thing
	shared_cooldown = MOB_SHARED_COOLDOWN_3
	/// in what phases of The Thing bossfight is this available
	var/list/available_in_phases = list(1,2,3)

/datum/action/cooldown/mob_cooldown/the_thing/IsAvailable(feedback)
	var/mob/living/basic/boss/thing/the_thing = owner
	if(!istype(the_thing))
		return ..()
	return ..() && (the_thing.phase in available_in_phases)

//decimate

/datum/action/cooldown/mob_cooldown/the_thing/decimate
	name = "毁灭"
	desc = "在半径范围内制造尖刺。"
	button_icon = 'icons/obj/weapons/stabby.dmi'
	button_icon_state = "huntingknife"
	click_to_activate = FALSE
	cooldown_time = 10 SECONDS

/datum/action/cooldown/mob_cooldown/the_thing/decimate/Activate(atom/caster)
	if(HAS_TRAIT_FROM(caster, TRAIT_IMMOBILIZED, MEGAFAUNA_TRAIT))
		return
	. = ..()

	ADD_TRAIT(caster, TRAIT_IMMOBILIZED, MEGAFAUNA_TRAIT)
	caster.Shake(1.4, 0.8, 0.3 SECONDS)
	caster.visible_message(span_danger("[caster]剧烈地摇晃！"))

	for(var/turf/open/target in RANGE_TURFS(2, caster) - caster.loc)
		new /obj/effect/temp_visual/telegraphing/exclamation/animated(target, 1.5 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(make_spikes), caster), 1.5 SECONDS)

/datum/action/cooldown/mob_cooldown/the_thing/decimate/proc/make_spikes(atom/caster)
	REMOVE_TRAIT(caster, TRAIT_IMMOBILIZED, MEGAFAUNA_TRAIT)
	for(var/turf/open/target in RANGE_TURFS(2, caster))
		if(locate(/obj/structure/thing_boss_spike) in target)
			continue
		new /obj/structure/thing_boss_spike(target)

// charge

/datum/action/cooldown/mob_cooldown/charge/the_thing
	shared_cooldown = NONE
	charge_damage = 35
	charge_past = 3

/datum/action/cooldown/mob_cooldown/charge/the_thing/charge_sequence(atom/movable/charger, atom/target_atom, delay, past)
	if(HAS_TRAIT_FROM(owner, TRAIT_IMMOBILIZED, MEGAFAUNA_TRAIT))
		return
	var/mob/living/basic/boss/thing/the_thing = owner
	var/charge_count = the_thing.phase != 3 ? 1 : 2
	for(var/i in 1 to charge_count)
		do_charge(owner, target_atom, charge_delay * i, charge_past)

/datum/action/cooldown/mob_cooldown/charge/the_thing/do_charge_indicator(atom/charger, atom/charge_target)
	var/turf/target_turf = get_turf(charge_target)
	if(!target_turf)
		return
	new /obj/effect/temp_visual/telegraphing/exclamation/animated(target_turf)
	var/obj/effect/temp_visual/decoy/decoy = new /obj/effect/temp_visual/decoy(charger.loc, charger)
	animate(decoy, alpha = 0, color = COLOR_RED, transform = matrix()*2, time = 3)

/datum/action/cooldown/mob_cooldown/charge/the_thing/hit_target(atom/movable/source, mob/living/target, damage_dealt)
	target.visible_message(span_danger("[source]猛冲向[target]！"), span_userdanger("[source]将你击倒在地，并在过程中对你进行劈砍！"))
	target.apply_damage(damage_dealt, BRUTE)
	target.Knockdown(0.5 SECONDS)
	playsound(get_turf(target), 'sound/items/weapons/rapierhit.ogg', 100, TRUE)
	shake_camera(target, 4, 3)

// square tendrils

/datum/action/cooldown/mob_cooldown/the_thing/big_tendrils
	name = "方形触须"
	desc = "在目标周围制造一个方形区域的尖刺。"
	button_icon = 'icons/obj/weapons/stabby.dmi'
	button_icon_state = "huntingknife"
	cooldown_time = 5 SECONDS
	available_in_phases = list(2,3)

/datum/action/cooldown/mob_cooldown/the_thing/big_tendrils/Activate(atom/target)
	if(HAS_TRAIT_FROM(owner, TRAIT_IMMOBILIZED, MEGAFAUNA_TRAIT))
		return
	. = ..()
	target = get_turf(target)
	var/mob/living/living_owner = owner
	var/delay = 1 SECONDS
	if((living_owner.health <= living_owner.maxHealth/3) ? 2 : 1)
		delay += 1 SECONDS
		new /obj/effect/temp_visual/telegraphing/big(target, delay)
	else
		new /obj/effect/temp_visual/telegraphing/exclamation/animated(target)
	addtimer(CALLBACK(src, PROC_REF(make_spikes), target), delay)

/datum/action/cooldown/mob_cooldown/the_thing/big_tendrils/proc/make_spikes(atom/epicenter)
	var/mob/living/living_owner = owner
	var/radius = living_owner.health <= living_owner.maxHealth/3 ? 2 : 1
	for(var/turf/open/target in RANGE_TURFS(radius, epicenter))
		if(locate(/obj/structure/thing_boss_spike) in target)
			continue
		new /obj/effect/temp_visual/mook_dust(target)
		new /obj/structure/thing_boss_spike(target)

// shriek

/datum/action/cooldown/mob_cooldown/the_thing/shriek
	name = "尖啸"
	desc = "在半径范围内造成混乱。"
	button_icon = 'icons/obj/weapons/stabby.dmi'
	button_icon_state = "huntingknife"
	click_to_activate = FALSE
	cooldown_time = 10 SECONDS
	shared_cooldown = NONE
	available_in_phases = list(2,3)

/datum/action/cooldown/mob_cooldown/the_thing/shriek/Activate(atom/caster)
	if(HAS_TRAIT_FROM(caster, TRAIT_IMMOBILIZED, MEGAFAUNA_TRAIT))
		return
	. = ..()
	ADD_TRAIT(caster, TRAIT_IMMOBILIZED, MEGAFAUNA_TRAIT)
	caster.visible_message(span_danger("[caster][caster.p_s()]的肉体开始布满孔洞！"))
	for(var/turf/open/target in RANGE_TURFS(2, caster))
		new /obj/effect/temp_visual/telegraphing/exclamation(target, 1.2 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(shriek), owner), 1.2 SECONDS)

/datum/action/cooldown/mob_cooldown/the_thing/shriek/proc/shriek(atom/caster)
	REMOVE_TRAIT(caster, TRAIT_IMMOBILIZED, MEGAFAUNA_TRAIT)
	caster.visible_message(span_danger("[caster]发出尖啸！那纯粹的声音频率让你的皮肤刺痛，感觉大脑像在燃烧！"))
	SEND_SOUND(caster, sound('sound/effects/screech.ogg'))
	for(var/mob/living/target in range(2, caster))
		if(target == owner)
			continue
		target.set_confusion_if_lower(5 SECONDS)
		target.set_jitter_if_lower(5 SECONDS)
		var/mob/living/carbon/carbon_target = target
		if(istype(carbon_target))
			carbon_target.drop_all_held_items()
		SEND_SOUND(target, sound('sound/effects/screech.ogg'))

// card. tendrils

/datum/action/cooldown/mob_cooldown/the_thing/cardinal_tendrils
	name = "四向触须"
	desc = "在所有基本方向制造触须。"
	button_icon = 'icons/obj/weapons/stabby.dmi'
	button_icon_state = "huntingknife"
	cooldown_time = 10 SECONDS
	available_in_phases = list(2,3)
	click_to_activate = FALSE
	/// range of tendril
	var/range = 9

/datum/action/cooldown/mob_cooldown/the_thing/cardinal_tendrils/Activate(atom/targetted_turf)
	if(HAS_TRAIT_FROM(owner, TRAIT_IMMOBILIZED, MEGAFAUNA_TRAIT))
		return
	. = ..()
	targetted_turf = get_turf(targetted_turf)
	owner.Shake(1.4, 0.8, 0.3 SECONDS)
	owner.visible_message(span_danger("[owner]剧烈地摇晃！"))
	var/list/turf/target_turfs = find_turfs(targetted_turf)
	for(var/turf/open/target in target_turfs)
		new /obj/effect/temp_visual/telegraphing/exclamation/animated(target, 1.5 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(make_spikes), target_turfs, owner), 1.5 SECONDS)

/datum/action/cooldown/mob_cooldown/the_thing/cardinal_tendrils/proc/find_turfs(atom/caster)
	. = list()
	for(var/direction in GLOB.cardinals)
		for(var/turf/potential_turf as anything in get_line(caster, get_ranged_target_turf(caster, direction, range)))
			if(potential_turf.density)
				break
			. += potential_turf

/datum/action/cooldown/mob_cooldown/the_thing/cardinal_tendrils/proc/make_spikes(list/target_turfs, atom/caster)
	REMOVE_TRAIT(caster, TRAIT_IMMOBILIZED, MEGAFAUNA_TRAIT)
	for(var/turf/open/target as anything in target_turfs)
		if(locate(/obj/structure/thing_boss_spike) in target)
			continue
		new /obj/effect/temp_visual/mook_dust(target)
		new /obj/structure/thing_boss_spike(target)

// acid

/datum/action/cooldown/mob_cooldown/the_thing/acid_spit
	name = "酸液喷淋"
	desc = "在你周围的半径范围内喷吐酸液斑块。"
	button_icon = 'icons/obj/weapons/stabby.dmi'
	button_icon_state = "huntingknife"
	cooldown_time = 10 SECONDS
	click_to_activate = FALSE
	available_in_phases = list(3)

/datum/action/cooldown/mob_cooldown/the_thing/acid_spit/Activate(atom/target)
	if(HAS_TRAIT_FROM(owner, TRAIT_IMMOBILIZED, MEGAFAUNA_TRAIT))
		return
	. = ..()
	var/turf/owner_turf = get_turf(owner)
	owner.visible_message(span_danger("[owner]喷吐酸液！"))
	var/list/potential = RANGE_TURFS(4, owner_turf)

	for(var/i = 1 to rand(2,4))
		new /obj/effect/temp_visual/incoming_thing_acid(pick(potential))
