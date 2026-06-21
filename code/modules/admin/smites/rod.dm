/// Throw an immovable rod at the target
/datum/smite/rod
	name = "Immovable Rod-不动杆"
	var/force_looping = FALSE

/datum/smite/rod/configure(client/user)
	var/loop_input = tgui_alert(usr,"你希望这根杆子强制在太空Z层级间循环吗？", "循环麦循环脸", list("Yes", "No"))

	force_looping = (loop_input == "Yes")

/datum/smite/rod/effect(client/user, mob/living/target)
	. = ..()
	var/turf/target_turf = get_turf(target)
	var/startside = pick(GLOB.cardinals)
	var/turf/start_turf = spaceDebrisStartLoc(startside, target_turf.z)
	var/turf/end_turf = spaceDebrisFinishLoc(startside, target_turf.z)
	new /obj/effect/immovablerod(start_turf, end_turf, target, force_looping)
