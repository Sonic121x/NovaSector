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
	name = "岩石碎屑"
	desc = "挖掘后留下的岩石，它已经被部分挖出，但还有很多工作要做。"
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
		. += span_notice("物品深度为 [target_excavation_level] 厘米。")
	. += span_notice("[measured ? "This boulder has been measured. Dug Depth: [excavation_level]." : "This boulder has not been measured."]")
	var/datum/component/gps/our_gps = GetComponent(/datum/component/gps)
	if(our_gps)
		. += span_notice("A holotag's been attached, projecting \"<b>[artifact_id]</b>\".")
	else
		. += span_notice("It looks like you could probably scan and tag it with a <b>mining scanner</b> of some kind.")

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
			attackby(offered_item, human_mob)

	else if(iscyborg(who_moved))
		var/mob/living/silicon/robot/robot_mob = who_moved
		if(istype(robot_mob.module_active, /obj/item/xenoarch/hammer))
			attackby(robot_mob.module_active, robot_mob)

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
		to_chat(user, span_warning("[src] already has a holotag attached!"))
		return
	to_chat(user, span_notice("You affix a holotag to [src]."))
	playsound(src, 'sound/machines/beep/twobeep.ogg', 100)
	AddComponent(/datum/component/gps, "\[[artifact_id]\] Xenoarch Debris")

/obj/structure/boulder/attackby(obj/item/attacking_item, mob/living/user, list/modifiers, list/attack_modifiers)
	. = ..()
	if(istype(attacking_item, /obj/item/mining_scanner) || istype(attacking_item, /obj/item/t_scanner/adv_mining_scanner))
		gps_tag(user)
		return TRUE
	if(istype(attacking_item, /obj/item/pickaxe))
		user.visible_message(
			span_notice("[user] 开始砸碎 [src]..."),
			span_notice("你开始砸碎 [src]...."),
		)
		if(!do_after(user, 2.5 SECONDS, target = src))
			user.visible_message(
				span_warning("[user] 滑了一下，用额外的力量砸中了巨石！"),
				span_warning("你滑了一下，用额外的力量砸中了巨石！"),
				blind_message = span_hear("你听到一声砸击！"),
			)
			excavation_level += rand(10,50)
			return
		switch(try_dig(25))
			if(DIG_DELETE)
				user.visible_message(
					span_warning("[src] 碎裂了，什么也没留下。"),
					blind_message = span_hear("你听到岩石碎裂的声音。"),
				)
				return
			if(DIG_ROCK)
				user.visible_message(
					span_notice("[user] 成功挖掘了 [src]。里面的物品似乎仍然完好无损。"),
					span_notice("你成功挖掘了 [src]。里面的物品似乎仍然完好无损。"),
					blind_message = span_hear("你听到岩石碎裂的声音。"),
				)

	if(istype(attacking_item, /obj/item/xenoarch/hammer))
		var/obj/item/xenoarch/hammer/hammer = attacking_item
		user.visible_message(
			span_notice("[user] 开始小心地使用他们的锤子..."),
			span_notice("你开始小心地使用你的锤子..."),
			blind_message = span_hear("你听到有节奏的敲击声。"),
		)
		if(!do_after(user, hammer.dig_speed, target = src))
			to_chat(user, span_warning("你中断了精心规划，在此过程中损坏了巨石！"))
			excavation_level += rand(1,5)
			return
		switch(try_dig(hammer.dig_amount))
			if(DIG_UNDEFINED)
				CRASH("[hammer] tried to call try_dig() with an invalid dig_amount! Must have a positive value.")
			if(DIG_DELETE)
				user.visible_message(
					span_warning("巨石碎裂，什么也没留下。"),
					blind_message = span_hear("你听到岩石碎裂的声音。"),
				)
				return
			if(DIG_ROCK)
				to_chat(user, span_notice("你成功在物品周围挖掘。"))

	if (istype(attacking_item, /obj/item/xenoarch/handheld_scanner))
		var/obj/item/xenoarch/handheld_scanner/scanner = attacking_item
		if (holomark_adv || (holomark && !istype(scanner, /obj/item/xenoarch/handheld_scanner/advanced)))
			to_chat(user, span_notice("这块巨石已经被扫描过了。你甚至能看到附着在上面的全息标记。"))
			return
		user.visible_message(
			span_notice("[user]开始使用[scanner]扫描[src]。"),
			span_notice("你开始使用[scanner]扫描[src]。"),
			blind_message = span_hear("你听到某种机器无声地启动。"),
		)
		if(!do_after(user, scanner.scanning_speed, target = src))
			to_chat(user, span_warning("你中断了扫描，在此过程中损坏了巨石！"))
			excavation_level += rand(1,5)
			return
		if(get_scanned(scanner.scan_advanced))
			to_chat(user, (span_notice("你成功扫描了巨石，将带有信息的全息标记附着在上面！")))
			if(scanner.scan_advanced)
				to_chat(user, span_notice("得益于高级扫描仪，全息标记现在还能显示所需的确切深度！"))
			return

	if(attacking_item.type == /obj/item/xenoarch)
		if (measured)
			to_chat(user, span_notice("这块巨石已经被测量过了。"))
			return
		user.visible_message(
			span_notice("[user]开始测量[src]。"),
			span_notice("你开始小心地使用卷尺。"),
			blind_message = span_hear("你听到卷尺展开的声音。"),
		)
		if(!do_after(user, 4 SECONDS, target = src))
			to_chat(user, span_warning("你中断了精心规划，在此过程中损坏了巨石！"))
			excavation_level += rand(1,5)
			return
		if(get_measured())
			to_chat(user, span_notice("你成功将全息卷尺附着在巨石上。巨石现在将始终报告其挖掘深度！"))
			return

	if(istype(attacking_item, /obj/item/xenoarch/brush))
		var/obj/item/xenoarch/brush/brush = attacking_item
		user.visible_message(
			span_notice("[user]小心地刷拭[src]。"),
			span_notice("你开始小心地使用刷子。"),
			blind_message = span_hear("你听到沙沙声。"),
		)
		if(!do_after(user, brush.dig_speed, target = src))
			to_chat(user, span_warning("你中断了精心规划，在此过程中损坏了巨石！"))
			excavation_level += rand(1,5)
			return
		switch(try_uncover())
			if(BRUSH_DELETE)
				user.visible_message(
					span_warning("巨石碎裂，什么也没留下。"),
					blind_message = span_hear("你听到岩石碎裂的声音。"),
				)
				return
			if(BRUSH_UNCOVER)
				to_chat(user, span_notice("你成功刷开了物品周围的尘土，完全露出了这件物品！"))
				return
			if(BRUSH_NONE)
				to_chat(user, span_notice("你刷了刷物品周围，但它并没有显露出来……再多敲几下。"))

	if(istype(attacking_item, /obj/item/xenoarch/handheld_radar))
		to_chat(user, span_warning("这块巨石必须使用其他工具来稳定。"))

	if(istype(attacking_item, /obj/item/xenoarch/core_sampler))
		var/obj/item/xenoarch/core_sampler/sampler = attacking_item
		if(sampler.used)
			balloon_alert(user, "采样器已使用过！")
			return
		sampler.sample = src
		sampler.used = TRUE
		sampler.icon_state = "sampler"
		user.visible_message(
			span_notice("[user] 从 [src] 上采集了样本。"),
			span_notice("你成功采集了[src]的样本。现在把它带到放射性碳光谱仪那里。"),
			blind_message = span_hear("你听到一声脆响。"),
		)

#undef BRUSH_DELETE
#undef BRUSH_UNCOVER
#undef BRUSH_NONE

#undef DIG_UNDEFINED
#undef DIG_DELETE
#undef DIG_ROCK
