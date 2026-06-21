/**
 * # Spider Charge
 *
 * A unique version of c4 possessed only by the space ninja. Has a stronger blast radius.
 * Can only be detonated by space ninjas with the bombing objective. Can only be set up where the objective says it can.
 * When it primes, the space ninja responsible will have their objective set to complete.
 *
 */
/obj/item/grenade/c4/ninja
	name = "蜘蛛炸药"
	desc = "由蜘蛛氏族提供的改良型C-4炸药。它具有强大的爆炸威力，但被设定为只能在特定区域起爆。"
	icon_state = "ninja-explosive0"
	inhand_icon_state = "ninja-explosive"
	boom_sizes = list(4, 8, 12)
	///Weakref to the mob that has planted the charge
	var/datum/weakref/detonator
	///The only area that the charge is allowed to be planted, and detonated in
	var/area/detonation_area

/obj/item/grenade/c4/ninja/Destroy()
	detonator = null
	detonation_area = null
	return ..()

/obj/item/grenade/c4/ninja/examine(mob/user)
	. = ..()
	if (!IS_SPACE_NINJA(user))
		return
	if (isnull(detonation_area))
		. += span_notice("这个炸药没有设定目的地，无法使用。")
	else
		. += span_notice("此装置仅在[detonation_area]区域内有效。")

/**
 * set_detonation_area
 *
 * Proc used to set the allowed location for charge detonation
 *
 * Arguments
 * * datum/antagonist/ninja/ninja_antag - The antag datum for the owner of the c4
 */
/obj/item/grenade/c4/ninja/proc/set_detonation_area(datum/antagonist/ninja/ninja_antag)
	if (!ninja_antag)
		return
	var/datum/objective/plant_explosive/objective = locate() in ninja_antag.objectives
	if (!objective)
		return
	detonation_area = objective.detonation_location

/obj/item/grenade/c4/ninja/plant_c4(atom/bomb_target, mob/living/user)
	if(!IS_SPACE_NINJA(user))
		say("Access denied.")
		return FALSE
	if(!check_loc(bomb_target, user))
		return FALSE
	if(!..())
		return FALSE
	detonator = WEAKREF(user)
	return TRUE

/obj/item/grenade/c4/ninja/detonate(mob/living/lanced_by)
	if(!check_loc(target, detonator.resolve())) // if its moved, deactivate the c4
		var/obj/item/grenade/c4/ninja/new_c4 = new /obj/item/grenade/c4/ninja(target.loc)
		new_c4.detonation_area = detonation_area
		new_c4.say("Invalid location!")
		target.cut_overlay(plastic_overlay, TRUE)
		qdel(src)
		return
	//Since we already did the checks in afterattack, the denonator must be a ninja with the bomb objective.
	if(isnull(detonator))
		return
	var/mob/ninja = detonator.resolve()
	. = ..()
	if(!.)
		return
	if (isnull(ninja))
		return
	var/datum/antagonist/ninja/ninja_antag = ninja.mind.has_antag_datum(/datum/antagonist/ninja)
	var/datum/objective/plant_explosive/objective = locate() in ninja_antag.objectives
	objective?.completed = TRUE

/**
 * check_loc
 *
 * Checks to see if the c4 is in the correct place when being planted.
 *
 * Arguments
 * * mob/user - The planter of the c4
 */
/obj/item/grenade/c4/ninja/proc/check_loc(atom/bomb_target, mob/user)
	if(isnull(detonation_area))
		balloon_alert(user, "未设置位置！")
		return FALSE
	if(get_area(bomb_target) != detonation_area)
		if (!active)
			balloon_alert(user, "位置错误！")
		return FALSE
	return TRUE
