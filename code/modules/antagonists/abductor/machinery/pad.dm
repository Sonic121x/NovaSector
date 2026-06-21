/obj/machinery/abductor/pad
	name = "外星传送平台"
	desc = "用它来往返人类栖息地。"
	icon = 'icons/obj/antags/abductor.dmi'
	icon_state = "alien-pad-idle"
	var/turf/teleport_target
	var/obj/machinery/abductor/console/console

/obj/machinery/abductor/pad/Destroy()
	if(console)
		console.pad = null
		console = null
	return ..()

/obj/machinery/abductor/pad/proc/Warp(mob/living/target)
	if(!target.buckled)
		target.forceMove(get_turf(src))

/obj/machinery/abductor/pad/proc/Send()
	if(teleport_target == null)
		teleport_target = GLOB.teleportlocs[pick(GLOB.teleportlocs)]
	flick("alien-pad", src)
	for(var/mob/living/target in loc)
		target.forceMove(teleport_target)
		new /obj/effect/temp_visual/dir_setting/ninja(get_turf(target), target.dir)
		to_chat(target, span_warning("扭曲的不稳定性让你感到晕头转向！"))
		target.Stun(60)

/obj/machinery/abductor/pad/proc/Retrieve(mob/living/target)
	flick("alien-pad", src)
	new /obj/effect/temp_visual/dir_setting/ninja(get_turf(target), target.dir)
	Warp(target)

/obj/machinery/abductor/pad/proc/doMobToLoc(place, atom/movable/target)
	flick("alien-pad", src)
	target.forceMove(place)
	new /obj/effect/temp_visual/dir_setting/ninja(get_turf(target), target.dir)

/obj/machinery/abductor/pad/proc/MobToLoc(place,mob/living/target)
	new /obj/effect/temp_visual/teleport_abductor(place)
	addtimer(CALLBACK(src, PROC_REF(doMobToLoc), place, target), 8 SECONDS)

/obj/machinery/abductor/pad/proc/doPadToLoc(place)
	flick("alien-pad", src)
	for(var/mob/living/target in get_turf(src))
		target.forceMove(place)
		new /obj/effect/temp_visual/dir_setting/ninja(get_turf(target), target.dir)

/obj/machinery/abductor/pad/proc/PadToLoc(place)
	new /obj/effect/temp_visual/teleport_abductor(place)
	addtimer(CALLBACK(src, PROC_REF(doPadToLoc), place), 8 SECONDS)

/obj/effect/temp_visual/teleport_abductor
	name = "哈"
	icon = 'icons/obj/antags/abductor.dmi'
	icon_state = "teleport"
	duration = 8 SECONDS

/obj/effect/temp_visual/teleport_abductor/Initialize(mapload)
	. = ..()
	do_sparks(10, FALSE, loc)

/obj/effect/temp_visual/teleport_golem
	name = "蓝空轮廓"
	icon = 'icons/obj/antags/abductor.dmi'
	icon_state = "teleport"
	duration = 6 SECONDS
