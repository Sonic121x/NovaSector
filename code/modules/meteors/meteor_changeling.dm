
/obj/effect/meteor/meaty/changeling
	name = "令人不安的肉状流星"
	desc = "一团紧密编织的血肉与皮肤，随着生命脉动。"
	icon_state = "changeling"
	heavy = FALSE
	hits = 1 //Instantly splatters apart when it hits anything.
	hitpwr = EXPLODE_LIGHT
	threat = 100
	signature = "xenobiological lifesign" //In the extremely unlikely one-in-a-million chance that one of these gets reported by the stray meteor event
	///Where we want our changeling to, by whatever means, end up at.
	var/atom/landing_target

/obj/effect/meteor/meaty/changeling/Initialize(mapload, turf/target)
	. = ..()

	landing_target = target

/obj/effect/meteor/meaty/changeling/meteor_effect()
	..()

	for(var/atom/movable/child in contents)
		child.forceMove(get_turf(src))

/obj/effect/meteor/meaty/changeling/ram_turf()
	return //So we don't instantly smash into our occupant upon unloading them.

/obj/effect/meteor/meaty/changeling/shield_defense(obj/machinery/satellite/meteor_shield/defender)
	landing_target = defender
	return TRUE

//If the meteor misses the station and deletes itself, we make absolutely sure the changeling reaches the station.
/obj/effect/meteor/meaty/changeling/moved_off_z()
	if(!landing_target)
		//If our destination turf is gone for some reason, we chuck them at the observer_start landmark (usually at the center of the station) as a last resort.
		landing_target = locate(/obj/effect/landmark/observer_start) in GLOB.landmarks_list

	for(var/atom/movable/changeling in contents)
		changeling.forceMove(get_turf(src))
		changeling.throw_at(landing_target, 2, 2)
		changeling.visible_message(span_warning("[changeling]从\the [src]内部被发射出来了！"), span_changeling("察觉到情况严重不对，我们强制从\the [src]中弹射出来了！"))
		playsound(changeling, 'sound/effects/splat.ogg', 50, pressure_affected = FALSE)

	return ..()

/obj/effect/meteor/meaty/changeling/check_examine_award(mob/user) //We don't want this to be a free achievement that comes with the role.
	return
