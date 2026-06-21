#define SYNDIE_DRAW_TIME 3 SECONDS

// Extending the existing spraycan item was more trouble than it was worth, I don't want or need this to be able to draw arbitrary shapes.
/obj/item/traitor_spraycan
	name = "煽动性喷漆罐"
	desc = "这个喷漆罐可以在一个3x3区域内喷涂包含潜意识启动剂的颠覆性图案。仅含足够进行一次最终涂层的底漆。"
	icon = 'icons/obj/art/crayons.dmi'
	icon_state = "deathcan"
	worn_icon_state = "spraycan"
	inhand_icon_state = "spraycan"
	lefthand_file = 'icons/mob/inhands/equipment/hydroponics_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/hydroponics_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	var/paint_color = "#780000"
	var/static/list/no_draw_turfs = typecacheof(list(/turf/open/space, /turf/open/openspace, /turf/open/lava, /turf/open/chasm))

	/// Are we currently drawing? Used to prevent spam clicks for do_while
	var/drawing_rune = FALSE
	/// Set to true if we finished drawing something, this spraycan is now useless
	var/expended = FALSE

/obj/item/traitor_spraycan/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if (!check_allowed_items(interacting_with) || !isliving(user))
		return NONE

	if (expended)
		user.balloon_alert(user, "颜料用完了...")
		return ITEM_INTERACT_BLOCKING

	if (drawing_rune)
		user.balloon_alert(user, "正忙！")
		return ITEM_INTERACT_BLOCKING

	if (isturf(interacting_with))
		try_draw_new_rune(user, interacting_with)
		return ITEM_INTERACT_SUCCESS

	if (istype(interacting_with, /obj/effect/decal/cleanable/traitor_rune))
		try_complete_rune(user, interacting_with)
		return ITEM_INTERACT_SUCCESS

	return ITEM_INTERACT_BLOCKING

/**
 * Attempt to draw a rune on [target_turf].
 * Shamelessly adapted from the heretic rune drawing process.
 *
 * Arguments
 * * user - the mob drawing the rune
 * * target_turf - the place the rune's being drawn
 */
/obj/item/traitor_spraycan/proc/try_draw_new_rune(mob/living/user, turf/target_turf)
	for(var/turf/nearby_turf as anything in RANGE_TURFS(1, target_turf))
		if (!isopenturf(nearby_turf) || is_type_in_typecache(nearby_turf, no_draw_turfs))
			user.balloon_alert(user, "你需要一块3x3的干净区域！")
			return

	draw_rune(user, target_turf)

/**
 * Draw your stage one rune on the ground and store it.
 *
 * Arguments
 * * user - the mob drawing the rune
 * * target_turf - the place the rune's being drawn
 */
/obj/item/traitor_spraycan/proc/draw_rune(mob/living/user, turf/target_turf)
	if (!try_draw_step("drawing outline...", user, target_turf))
		return
	try_complete_rune(user, new /obj/effect/decal/cleanable/traitor_rune(target_turf))

/**
 * Holder for repeated code to do something after a message and a set amount of time.
 *
 * Arguments
 * * output - a string to show when you start the process
 * * user - the mob drawing the rune
 * * target - what they're trying to draw, or the place they are trying to draw on
 */
/obj/item/traitor_spraycan/proc/try_draw_step(start_output, mob/living/user, atom/target)
	drawing_rune = TRUE
	user.balloon_alert(user, "[start_output]")
	var/wait_time = SYNDIE_DRAW_TIME

	if(HAS_TRAIT(user, TRAIT_TAGGER))
		wait_time *= 0.5

	if(!do_after(user, wait_time, target, hidden = TRUE, extra_checks = CALLBACK(src, PROC_REF(adjacency_check), user, target)))
		user.balloon_alert(user, "被打断了！")
		drawing_rune = FALSE
		return FALSE

	playsound(src, 'sound/effects/spray.ogg', 5, TRUE, 5)
	drawing_rune = FALSE
	return TRUE

#define RUNE_STAGE_OUTLINE 0
#define RUNE_STAGE_COLOURED 1
#define RUNE_STAGE_COMPLETE 2
#define RUNE_STAGE_REMOVABLE 3

/**
 * Try to upgrade a floor rune to its next stage.
 *
 * Arguments
 * * user - the mob drawing the rune
 * * target_turf - the place the rune's being drawn
 */
/obj/item/traitor_spraycan/proc/try_complete_rune(mob/living/user, obj/effect/decal/cleanable/traitor_rune/rune)
	switch(rune.drawn_stage)
		if (RUNE_STAGE_OUTLINE)
			if (!try_draw_step("... finalising design...", user, rune))
				return
			if (!rune)
				user.balloon_alert(user, "涂鸦被破坏了！")
				return
			rune.set_stage(RUNE_STAGE_COLOURED)
			try_complete_rune(user, rune)

		if (RUNE_STAGE_COLOURED)
			if (!try_draw_step("... applying final coating...", user, rune))
				return
			if (!rune)
				user.balloon_alert(user, "涂鸦被破坏了！")
				return
			user.balloon_alert(user, "完成了！")
			rune.set_stage(RUNE_STAGE_COMPLETE)
			expended = TRUE
			desc = "一个看起来可疑的喷漆罐，油漆已经用完了。"
			SEND_SIGNAL(src, COMSIG_TRAITOR_GRAFFITI_DRAWN, rune)

		if (RUNE_STAGE_COMPLETE, RUNE_STAGE_REMOVABLE)
			user.balloon_alert(user, "全部完成！")

/// Copying the functionality from normal spraycans, but doesn't need all the optional checks
/obj/item/traitor_spraycan/suicide_act(mob/living/user)
	if(expended)
		user.visible_message(span_suicide("[user] 摇晃着[src]发出咔啦声，然后举到[user.p_their()]嘴边，但什么都没发生！"))
		user.say("MEDIOCRE!!", forced="spraycan suicide")
		return SHAME

	var/mob/living/carbon/human/suicider = user
	user.visible_message(span_suicide("[user] 摇晃着[src]发出咔啦声，然后举到[user.p_their()]嘴边，将油漆喷在了[user.p_their()]牙齿上！"))
	user.say("WITNESS ME!!", forced="spraycan suicide")
	playsound(src, 'sound/effects/spray.ogg', 5, TRUE, 5)
	suicider.AddComponent(/datum/component/face_decal, "spray", EXTERNAL_ADJACENT, paint_color)
	return OXYLOSS

///Checks if the user is still adjacent to the target (used for do_after extra_checks)
/obj/item/traitor_spraycan/proc/adjacency_check(mob/user, atom/target)
	if(!user.Adjacent(target))
		user.balloon_alert(user, "移动得太远了！")
		return FALSE
	return TRUE

/obj/effect/decal/cleanable/traitor_rune
	name = "辛迪加涂鸦"
	desc = "看起来它会是……辛迪加的标志？"
	icon = 'icons/effects/96x96.dmi'
	icon_state = "traitor_rune_outline"
	pixel_x = -32
	pixel_y = -32
	gender = NEUTER
	mergeable_decal = FALSE
	resistance_flags = FIRE_PROOF | UNACIDABLE | ACID_PROOF
	clean_type = CLEAN_TYPE_HARD_DECAL
	plane = FLOOR_PLANE
	layer = RUNE_LAYER
	var/slip_time = 6 SECONDS
	var/slip_flags = NO_SLIP_WHEN_WALKING

	/// The stage of drawing we have reached
	var/drawn_stage = RUNE_STAGE_OUTLINE
	/// Proximity sensor to make people sad if they're nearby
	var/datum/proximity_monitor/advanced/demoraliser/demoraliser
	/// Whether we protect the rune from being cleaned up
	var/clean_proof = FALSE
	/// Timer until the rune can be cleaned up off the floor
	var/protected_timer

/obj/effect/decal/cleanable/traitor_rune/Destroy()
	deltimer(protected_timer)
	QDEL_NULL(demoraliser)
	return ..()

/obj/effect/decal/cleanable/traitor_rune/HasProximity(atom/movable/proximity_check_mob)
	if (isliving(proximity_check_mob) && get_dist(proximity_check_mob, src) <= 1)
		slip(proximity_check_mob)
	return ..()

/**
 * Makes someone fall over. If it's not the traitor, this counts as demoralising the crew.
 *
 * Arguments
 * * victim - whoever just slipped, point and laugh at them
 */
/obj/effect/decal/cleanable/traitor_rune/proc/slip(mob/living/victim)
	if(victim.movement_type & MOVETYPES_NOT_TOUCHING_GROUND)
		return
	if (!victim.slip(slip_time, src, slip_flags))
		return
	SEND_SIGNAL(src, COMSIG_TRAITOR_GRAFFITI_SLIPPED, victim.mind)

/**
 * Sets the "drawing stage" of the rune.
 * This affects the appearance, behaviour, and description of the effect.
 *
 * Arguments
 * * stage - new stage to apply
 */
/obj/effect/decal/cleanable/traitor_rune/proc/set_stage(stage)
	drawn_stage = stage
	switch(drawn_stage)
		if (RUNE_STAGE_OUTLINE)
			icon_state = "traitor_rune_outline"
			desc = "看起来它会是……辛迪加的标志？"

		if (RUNE_STAGE_COLOURED, RUNE_STAGE_REMOVABLE)
			icon_state = "traitor_rune_done"
			desc = "一幅巨大的辛迪加标志图案。"
			clean_proof = FALSE

		if (RUNE_STAGE_COMPLETE)
			icon_state = "traitor_rune_sheen"
			desc = "一幅巨大的辛迪加标志图案。看起来滑溜溜的。"
			var/datum/demoralise_moods/graffiti/mood_category = new()
			demoraliser = new(src, 7, TRUE, mood_category)
			clean_proof = TRUE
			protected_timer = addtimer(CALLBACK(src, PROC_REF(set_stage), RUNE_STAGE_REMOVABLE), 5 MINUTES)

/obj/effect/decal/cleanable/traitor_rune/wash(clean_types)
	if (clean_proof)
		return NONE

	return ..()

#undef SYNDIE_DRAW_TIME
#undef RUNE_STAGE_COLOURED
#undef RUNE_STAGE_COMPLETE
#undef RUNE_STAGE_OUTLINE
#undef RUNE_STAGE_REMOVABLE
