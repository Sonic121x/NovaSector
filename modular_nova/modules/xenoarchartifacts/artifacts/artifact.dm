#define DIG_UNDEFINED 1
#define DIG_DELETE 2
#define DIG_ROCK 3

#define BRUSH_DELETE 1
#define BRUSH_UNCOVER 2
#define BRUSH_NONE 3
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Large finds - (Potentially) active alien machinery from the dawn of time
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// TO DO LIST:
// * More effects!!!
// * More artifact types!!!
//

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Boulders - sometimes turn up after excavating turf - excavate further to try and find large xenoarch finds

/obj/structure/boulder
	name = "rocky debris"
	desc = "Leftover rock from an excavation, it's been partially dug out already but there's still a lot to go."
	icon = 'modular_nova/modules/xenoarchartifacts/icons/mining.dmi'
	icon_state = "boulder1"
	density = TRUE
	opacity = 1
	anchored = TRUE
	/// If TRUE - shows dug depth in description
	var/measured = FALSE
	/// If TRUE - shows approximate_excavation_level in description
	var/holomark = FALSE
	/// If TRUE - shows target_excavation_level in description
	var/holomark_adv = FALSE
	/// Is our boulder stabilized and ready to be uncovered
	var/stabilised = FALSE
	/// Currently dug depth
	var/excavation_level = 0
	/// How much do we need to dig
	var/target_excavation_level = 0
	/// Used to show target_excavation_level +- 15 cm
	var/approximate_excavation_level = 0
	/// Loot drop from boulder
	var/artifact_find_type
	/// Fluff text
	var/artifact_id
	/// What type of stabilization field we need to use
	var/artifact_stabilizing_field
	/// Fluff text
	var/artifact_age

/obj/structure/boulder/examine(mob/user)
	. = ..()
	. += span_notice("[holomark ? "This boulder has been scanned. Target Depth: [approximate_excavation_level] +- 15 cm." : "This boulder has not been scanned."]")
	if(holomark_adv)
		. += span_notice(LANG("obj.9c404e9c", list(target_excavation_level)))
	. += span_notice("[measured ? "This boulder has been measured. Dug Depth: [excavation_level]." : "This boulder has not been measured."]")
	var/datum/component/gps/our_gps = GetComponent(/datum/component/gps)
	if(our_gps)
		. += span_notice(LANG("obj.87719a64", list(artifact_id)))
	else
		. += span_notice(LANG("obj.d7cf889a", null))

/obj/structure/boulder/Initialize(mapload)
	. = ..()
	artifact_age = rand(1000,9000000000)
	icon_state = "boulder[rand(1, 4)]"
	target_excavation_level = rand(25, 200)
	approximate_excavation_level = target_excavation_level - (rand(-15,15))
	artifact_find_type = pick_weight(list(
		/obj/machinery/power/supermatter_crystal/shard = 5,
		/obj/effect/spawner/random/artifact_exosuit = 50,
		/obj/structure/constructshell = 75,
		/obj/machinery/artifact/bluespace_crystal = 100,
		/obj/machinery/power/crystal = 100,
		/obj/machinery/auto_cloner = 100,
		/obj/machinery/replicator = 100,
		/obj/machinery/artifact = 1000,
	))
	artifact_stabilizing_field = pick(list(
		"Diffracted carbon dioxide laser",
		"Nitrogen tracer field",
		"Potassium refrigerant cloud",
		"Mercury dispersion wave",
		"Iron wafer conduction field",
		"Calcium binary deoxidizer",
		"Chlorine diffusion emissions",
		"Phoron saturated field",
	))
	artifact_id = "[pick("Kappa","Sigma","Antaeres","Beta","Omicron","Iota","Epsilon","Omega","Gamma","Delta","Tau","Alpha","Fluffy","Zeta")]-[rand(0,9999)]"

/**
 * Spawns artifact and check for it's stabilization status.
 * If it is not - destroys/harms it with 50/50 chance
 */
/obj/structure/boulder/proc/spawn_artifact()
	var/obj/machinery/artifact/new_artifact = new artifact_find_type(get_turf(src))
	if (!stabilised)
		if (prob(50))
			new_artifact.update_integrity(10) // It is on the edge of destruction
		else
			qdel(new_artifact)

/obj/structure/boulder/Destroy() // spawns and destroys artifact immediately
	if (!stabilised)
		var/obj/machinery/artifact/new_artifact = new artifact_find_type(get_turf(src))
		qdel(new_artifact)
	return ..()

/obj/structure/boulder/Bumped(who_moved)
	. = ..()
	if(ishuman(who_moved))
		var/mob/living/carbon/human/human_mob = who_moved
		var/obj/item/offered_item = human_mob.get_active_held_item()
		if(istype(offered_item, /obj/item/xenoarch/hammer))
			item_interaction(human_mob, offered_item)

	else if(iscyborg(who_moved))
		var/mob/living/silicon/robot/robot_mob = who_moved
		if(istype(robot_mob.module_active, /obj/item/xenoarch/hammer))
			item_interaction(robot_mob, robot_mob.module_active)

/**
 * Adds holomark to the boulder
 *
 * Arguments:
 * * advanced - will our tool give advanced holomark
 */
/obj/structure/boulder/proc/get_scanned(advanced)
	if (advanced)
		holomark_adv = TRUE
	holomark = TRUE
	return TRUE

/**
 * Stabilizes boulder
 */
/obj/structure/boulder/proc/get_stabilised()
	if (stabilised)
		return FALSE
	else
		stabilised = TRUE
		return TRUE

/**
 * Adds measurement holomark to the boulder
 */
/obj/structure/boulder/proc/get_measured()
	if (measured)
		return FALSE
	else
		measured = TRUE
		return TRUE

/**
 * Tries to dig boulder by certain amount
 *
 * Arguments:
 * * dig_amount - how much to dig
 */
/obj/structure/boulder/proc/try_dig(dig_amount)
	if(!dig_amount)
		return DIG_UNDEFINED
	excavation_level += dig_amount
	if(excavation_level > target_excavation_level)
		qdel(src)
		return DIG_DELETE
	return DIG_ROCK

/**
 * Trying to delete boulder and spawn artifact.
 * Fails if dug too deep and adds 1 cm
 */
/obj/structure/boulder/proc/try_uncover()
	if(excavation_level > target_excavation_level)
		qdel(src)
		return BRUSH_DELETE
	if(excavation_level == target_excavation_level)
		spawn_artifact()
		qdel(src)
		return BRUSH_UNCOVER
	try_dig(1)
	return BRUSH_NONE

/// Tag the debris, giving it a GPS identifier.
/obj/structure/boulder/proc/gps_tag(mob/user)
	var/datum/component/gps/our_gps = GetComponent(/datum/component/gps)
	if(our_gps)
		to_chat(user, span_warning(LANG("obj.d71d9076", list(src))))
		return
	to_chat(user, span_notice(LANG("obj.1fe95f8d", list(src))))
	playsound(src, 'sound/machines/beep/twobeep.ogg', 100)
	AddComponent(/datum/component/gps, "\[[artifact_id]\] Xenoarch Debris")

/obj/structure/boulder/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/mining_scanner) || istype(tool, /obj/item/t_scanner/adv_mining_scanner))
		gps_tag(user)
		return ITEM_INTERACT_SUCCESS
	if(istype(tool, /obj/item/pickaxe))
		user.visible_message(
			span_notice(LANG("obj.494c4505", list(user, src))),
			span_notice(LANG("obj.b8e9b3f0", list(src))),
		)
		if(!do_after(user, 2.5 SECONDS, target = src))
			user.visible_message(
				span_warning(LANG("obj.1a44b09b", list(user))),
				span_warning(LANG("obj.84b6068e", null)),
				blind_message = span_hear(LANG("obj.3ec752af", null)),
			)
			excavation_level += rand(10,50)
			return ITEM_INTERACT_BLOCKING
		switch(try_dig(25))
			if(DIG_DELETE)
				user.visible_message(
					span_warning(LANG("obj.6db9ab42", list(src))),
					blind_message = span_hear(LANG("obj.9c90ffa7", null)),
				)
				return ITEM_INTERACT_SUCCESS
			if(DIG_ROCK)
				user.visible_message(
					span_notice(LANG("obj.f37b4dcd", list(user, src))),
					span_notice(LANG("obj.b996ea2a", list(src))),
					blind_message = span_hear(LANG("obj.9c90ffa7", null)),
				)
		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/xenoarch/hammer))
		var/obj/item/xenoarch/hammer/hammer = tool
		user.visible_message(
			span_notice(LANG("obj.3f8240a0", list(user))),
			span_notice(LANG("obj.04bcd84c", null)),
			blind_message = span_hear(LANG("obj.2afa996e", null)),
		)
		if(!do_after(user, hammer.dig_speed, target = src))
			to_chat(user, span_warning(LANG("obj.9d6b236c", null)))
			excavation_level += rand(1,5)
			return ITEM_INTERACT_BLOCKING
		switch(try_dig(hammer.dig_amount))
			if(DIG_UNDEFINED)
				CRASH("[hammer] tried to call try_dig() with an invalid dig_amount! Must have a positive value.")
			if(DIG_DELETE)
				user.visible_message(
					span_warning(LANG("obj.b150c4e6", null)),
					blind_message = span_hear(LANG("obj.691e6a73", null)),
				)
				return ITEM_INTERACT_SUCCESS
			if(DIG_ROCK)
				to_chat(user, span_notice(LANG("obj.c2a25e9a", null)))
		return ITEM_INTERACT_SUCCESS

	if (istype(tool, /obj/item/xenoarch/handheld_scanner))
		var/obj/item/xenoarch/handheld_scanner/scanner = tool
		if (holomark_adv || (holomark && !istype(scanner, /obj/item/xenoarch/handheld_scanner/advanced)))
			to_chat(user, span_notice(LANG("obj.eb7905b5", null)))
			return ITEM_INTERACT_BLOCKING
		user.visible_message(
			span_notice(LANG("obj.f18b5d8d", list(user, src, scanner))),
			span_notice(LANG("obj.c849e69f", list(src, scanner))),
			blind_message = span_hear(LANG("obj.b2408de5", null)),
		)
		if(!do_after(user, scanner.scanning_speed, target = src))
			to_chat(user, span_warning(LANG("obj.3f48dec0", null)))
			excavation_level += rand(1,5)
			return ITEM_INTERACT_BLOCKING
		if(get_scanned(scanner.scan_advanced))
			to_chat(user, (span_notice(LANG("obj.96e6cb60", null))))
			if(scanner.scan_advanced)
				to_chat(user, span_notice(LANG("obj.e3c9597e", null)))
		return ITEM_INTERACT_SUCCESS

	if(tool.type == /obj/item/xenoarch)
		if (measured)
			to_chat(user, span_notice(LANG("obj.c8acb66e", null)))
			return ITEM_INTERACT_BLOCKING
		user.visible_message(
			span_notice(LANG("obj.caad5216", list(user, src))),
			span_notice(LANG("obj.cfbbc627", null)),
			blind_message = span_hear(LANG("obj.187faf2f", null)),
		)
		if(!do_after(user, 4 SECONDS, target = src))
			to_chat(user, span_warning(LANG("obj.9d6b236c", null)))
			excavation_level += rand(1,5)
			return ITEM_INTERACT_BLOCKING
		if(get_measured())
			to_chat(user, span_notice(LANG("obj.4a3432f4", null)))
		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/xenoarch/brush))
		var/obj/item/xenoarch/brush/brush = tool
		user.visible_message(
			span_notice(LANG("obj.f2fa9edc", list(user, src))),
			span_notice(LANG("obj.f49f7bc1", null)),
			blind_message = span_hear(LANG("obj.845a0660", null)),
		)
		if(!do_after(user, brush.dig_speed, target = src))
			to_chat(user, span_warning(LANG("obj.9d6b236c", null)))
			excavation_level += rand(1,5)
			return ITEM_INTERACT_BLOCKING
		switch(try_uncover())
			if(BRUSH_DELETE)
				user.visible_message(
					span_warning(LANG("obj.b150c4e6", null)),
					blind_message = span_hear(LANG("obj.691e6a73", null)),
				)
				return ITEM_INTERACT_SUCCESS
			if(BRUSH_UNCOVER)
				to_chat(user, span_notice(LANG("obj.63b96783", null)))
				return ITEM_INTERACT_SUCCESS
			if(BRUSH_NONE)
				to_chat(user, span_notice(LANG("obj.377f381a", null)))
		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/xenoarch/handheld_radar))
		to_chat(user, span_warning(LANG("obj.9a40e4e5", null)))
		return ITEM_INTERACT_BLOCKING

	if(istype(tool, /obj/item/xenoarch/core_sampler))
		var/obj/item/xenoarch/core_sampler/sampler = tool
		if(sampler.used)
			balloon_alert(user, LANG("obj.713d4ec0", null))
			return ITEM_INTERACT_BLOCKING
		sampler.sample = src
		sampler.used = TRUE
		sampler.icon_state = "sampler"
		user.visible_message(
			span_notice(LANG("obj.e0d4d8b3", list(user, src))),
			span_notice(LANG("obj.c2615fa0", list(src))),
			blind_message = span_hear(LANG("obj.19e74f40", null)),
		)
		return ITEM_INTERACT_SUCCESS

	return ..()

#undef BRUSH_DELETE
#undef BRUSH_UNCOVER
#undef BRUSH_NONE

#undef DIG_UNDEFINED
#undef DIG_DELETE
#undef DIG_ROCK
