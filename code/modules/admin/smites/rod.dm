// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/// Throw an immovable rod at the target
/datum/smite/rod
	name = "Immovable Rod"
	var/force_looping = FALSE

/datum/smite/rod/configure(client/user)
	var/loop_input = tgui_alert(usr,LANG("datum.9820a3d389f7488e", null), LANG("datum.8ae1b7f8e648aad8", null), list("Yes", "No"))

	force_looping = (loop_input == "Yes")

/datum/smite/rod/effect(client/user, mob/living/target)
	. = ..()
	var/turf/target_turf = get_turf(target)
	var/startside = pick(GLOB.cardinals)
	var/turf/start_turf = spaceDebrisStartLoc(startside, target_turf.z)
	var/turf/end_turf = spaceDebrisFinishLoc(startside, target_turf.z)
	new /obj/effect/immovablerod(start_turf, end_turf, target, force_looping)
