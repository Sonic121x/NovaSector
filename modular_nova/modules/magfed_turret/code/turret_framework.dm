//////// Mag-fed Turret Framework.

////// Define copying //////

#define TURRET_STUN 0
#define TURRET_LETHAL 1

#define TURRET_FLAG_SHOOT_ALL_REACT (1<<0) // The turret gets pissed off and shoots at people nearby (unless they have sec access!)
#define TURRET_FLAG_AUTH_WEAPONS (1<<1) // Checks if it can shoot people that have a weapon they aren't authorized to have
#define TURRET_FLAG_SHOOT_CRIMINALS (1<<2) // Checks if it can shoot people that are wanted
#define TURRET_FLAG_SHOOT_ALL (1<<3)  // The turret gets pissed off and shoots at people nearby (unless they have sec access!)
#define TURRET_FLAG_SHOOT_ANOMALOUS (1<<4)  // Checks if it can shoot at unidentified lifeforms (ie xenos)
#define TURRET_FLAG_SHOOT_UNSHIELDED (1<<5) // Checks if it can shoot people that aren't mindshielded and who arent heads
#define TURRET_FLAG_SHOOT_BORGS (1<<6) // checks if it can shoot cyborgs
#define TURRET_FLAG_SHOOT_HEADS (1<<7) // checks if it can shoot at heads of staff

#define TURRET_FLAG_OBEY_FLAGS 2 // Turrets will behave with turret flags.
#define TURRET_FLAG_SHOOT_NOONE 3 // Turrets will not fire at any player-type mob.
#define TURRET_FLAG_SHOOT_EVERYONE 4 // Turrets will shoot at all player-type mobs.

#define TURRET_THREAT_PASSIVE 0
#define TURRET_THREAT_LOW 2
#define TURRET_THREAT_MEDIUM 4
#define TURRET_THREAT_HIGH 6
#define TURRET_THREAT_SEVERE 8
#define TURRET_THREAT_PRIORITY 10

////// Toolbox Handling //////
/obj/item/storage/toolbox/emergency/turret/mag_fed
	name = "弹匣供弹炮台套件"
	desc = "一套隐蔽的弹匣供弹炮台套件。"
	has_latches = FALSE
	////// Whether the turret's settings can be adjusted.
	var/setting_change = TRUE //we'll default this to true because... well- You'll mostly get these AFTER destroying or constructing them, and should be able to. Exceptions will be made per-item.
	////// Whether the turret will ignore humans when deployed.
	var/turret_safety = FALSE
	////// Whether the turret will deploy obeying flags.
	var/flags_on = FALSE
	////// Whether the turret needs a wrench to deploy. Still needs a wrench to pack up.
	var/easy_deploy = FALSE
	////// If easy deployable, how quick will it be?
	var/easy_deploy_timer = 2 SECONDS
	////// Whether the turret can deploy by being thrown
	var/quick_deployable = FALSE
	////// How long the turret takes to deploy when quick_deploying
	var/quick_deploy_timer = 1 SECONDS
	////// The type of turret deployed
	var/turret_type = /obj/machinery/porta_turret/syndicate/toolbox/mag_fed
	////// Number of mags that can be put in.
	var/mag_slots = 2
	////// Types of magazines that can be allowed.
	var/mag_types_allowed = list(
		/obj/item/ammo_box/magazine/c35sol_pistol,
	)

/obj/item/storage/toolbox/emergency/turret/mag_fed/Initialize(mapload)
	. = ..()
	atom_storage.max_specific_storage = WEIGHT_CLASS_NORMAL
	atom_storage.max_slots = mag_slots
	atom_storage.can_hold = typecacheof(mag_types_allowed)
	if(greyscale_config)
		AddElement(/datum/element/gags_recolorable)
	update_appearance()

/obj/item/storage/toolbox/emergency/turret/mag_fed/examine(mob/user)
	. = ..()
	. += span_notice("The targeting safety is [turret_safety ? "<font color='#00ff15'>ON</font>" : "<font color='#ff0000'>OFF</font>"].")
	. += span_notice("The turret is [flags_on ? "<font color='#00ff15'>OBEYING LAWS</font>" : "<font color='#ff0000'>FREE TARGETING</font>"].")
	if(!easy_deploy)
		. += span_notice("你可以在<b>战斗模式</b>下使用<b>扳手工具</b>点击来部署它。")
	else
		. += span_notice("你可以通过<b>使用它</b>或在<b>战斗模式</b>下使用<b>扳手工具</b>来部署它。")
	if(setting_change)
		. += span_notice("你可以用<b>螺丝刀头</b>切换目标锁定安全模式。")
		. += span_notice("你可以用<b>多功能工具</b>更改炮塔是否遵守标记规则。")

/obj/item/storage/toolbox/emergency/turret/mag_fed/PopulateContents()

/obj/item/storage/toolbox/emergency/turret/mag_fed/pre_filled/PopulateContents()
	new /obj/item/ammo_box/magazine/c35sol_pistol(src)
	new /obj/item/ammo_box/magazine/c35sol_pistol(src)


///Grabs a mag to load into the turret
/obj/item/storage/toolbox/emergency/turret/mag_fed/proc/get_mag(keep = FALSE)
	var/mag_len = length(contents)
	if (!mag_len)
		return
	var/yoink = contents[mag_len]
	if (keep)
		atom_storage?.attempt_insert(yoink, override = TRUE)
	return yoink

/obj/item/storage/toolbox/emergency/turret/mag_fed/set_faction(obj/machinery/porta_turret/syndicate/toolbox/mag_fed/turret, mob/user)
	if(!turret.faction_check_atom(user))
		APPLY_FACTION_AND_ALLIES_FROM(turret, user)

/obj/item/storage/toolbox/emergency/turret/mag_fed/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!is_type_in_list(tool, list(/obj/item/wrench, /obj/item/screwdriver, /obj/item/multitool, /obj/item/toy/crayon/spraycan)))
		return ITEM_INTERACT_BLOCKING
	if(!tool.toolspeed)
		return ITEM_INTERACT_BLOCKING

	return NONE

/obj/item/storage/toolbox/emergency/turret/mag_fed/item_interaction(mob/living/user, obj/item/tool, list/modifiers) // This was changed but not updated???? I guess no one uses the tarkon ones gawd DAHM
	if(istype(tool, /obj/item/toy/crayon/spraycan))
		return attackby(tool, user) //This is entirely just so people can use the gagsification for the toy turret.

	if(setting_change && tool.tool_behaviour == TOOL_SCREWDRIVER)
		if(!tool.use_tool(src, user, 2 SECONDS, volume = 20))
			return ITEM_INTERACT_BLOCKING
		turret_safety = !turret_safety
		return ITEM_INTERACT_SUCCESS

	if(setting_change && tool.tool_behaviour == TOOL_MULTITOOL)
		if(!tool.use_tool(src, user, 2 SECONDS, volume = 20))
			return ITEM_INTERACT_BLOCKING
		flags_on = !flags_on
		return ITEM_INTERACT_SUCCESS

	if(tool.tool_behaviour == TOOL_WRENCH)
		if(!user.combat_mode)
			return NONE
		if(!tool.toolspeed)
			return ITEM_INTERACT_BLOCKING
		balloon_alert(user, "正在组装...")
		if(!tool.use_tool(src, user, 2 SECONDS, volume = 20))
			return ITEM_INTERACT_BLOCKING

		balloon_alert(user, "组装完成！")
		user.visible_message(
			span_danger("[user]用[tool]猛击[src]！"),
			span_danger("你用[tool]猛击[src]！"),
			null,
			COMBAT_MESSAGE_RANGE,
		)

		playsound(src, 'sound/items/tools/drill_use.ogg', 80, TRUE, -1)
		deploy_turret(user, loc)
		return ITEM_INTERACT_SUCCESS
	return ..()

/obj/item/storage/toolbox/emergency/turret/mag_fed/attack_self(mob/user, modifiers)
	if(!easy_deploy)
		return
	var/turf/chosen_spot = get_step(user, user.dir) //find spot infront of person and places it there
	if(chosen_spot.is_blocked_turf(TRUE, src))
		balloon_alert(user, "区域不适合部署。")
		return
	balloon_alert(user, "正在部署...")
	playsound(src, 'sound/items/tools/ratchet.ogg', 50, TRUE)
	if(!do_after(user, easy_deploy_timer))
		return
	deploy_turret(user, chosen_spot)

/obj/item/storage/toolbox/emergency/turret/mag_fed/proc/deploy_turret(mob/living/user, turf/chosen_spot)
	var/turf/target_area = chosen_spot
	if(!chosen_spot)
		target_area = loc
	if(target_area.is_blocked_turf(TRUE, src))
		balloon_alert(user, "部署区域不适合部署。")
		return
	playsound(src, 'sound/items/tools/drill_use.ogg', 80, TRUE, -1)
	var/obj/machinery/porta_turret/syndicate/toolbox/mag_fed/turret = new turret_type(target_area)
	if(user) //We do this so those deployed via disposal throws dont runtime.
		set_faction(turret, user)
	turret.mag_box = WEAKREF(src)
	if(turret_safety == TRUE)
		turret.target_assessment = TURRET_FLAG_SHOOT_NOONE
	if(flags_on == TRUE)
		turret.target_assessment = TURRET_FLAG_OBEY_FLAGS
	forceMove(turret)
	turret.setState(TRUE)
	if(greyscale_colors)
		turret.set_greyscale(greyscale_colors)
		turret.update_greyscale()

/obj/item/storage/toolbox/emergency/turret/mag_fed/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(quick_deployable)
		balloon_alert_to_viewers("deploying...")
		addtimer(CALLBACK(src, PROC_REF(deploy_turret), throwingdatum.thrower?.resolve()), quick_deploy_timer, TIMER_STOPPABLE)

////// Targeting Device handling //////

/obj/item/target_designator
	name = "\improper 炮塔目标指示器"
	desc = "一种简单的目标指示系统，用于让某人覆盖炮塔的瞄准软件并专注于一个实体，或将某人指定为“友方”。"
	icon = 'modular_nova/modules/magfed_turret/icons/designator.dmi'
	icon_state = "designator"
	inhand_icon_state = "designator"
	righthand_file = 'modular_nova/modules/magfed_turret/icons/inhands/righthand.dmi'
	lefthand_file = 'modular_nova/modules/magfed_turret/icons/inhands/righthand.dmi'
	worn_icon_state = "designator"
	worn_icon = 'modular_nova/modules/magfed_turret/icons/mob/belt.dmi'
	w_class = WEIGHT_CLASS_SMALL
	obj_flags = CONDUCTS_ELECTRICITY
	item_flags = NOBLUDGEON
	slot_flags = ITEM_SLOT_BELT
	throwforce = 0
	throw_speed = 3
	throw_range = 7
	////// the range it can scan at.
	var/scan_range = 10
	////// how many turrets it can have. changable incase of better ones wanted.
	var/turret_limit = 3
	////// the currently linked turrets.
	var/linked_turrets = list()
	////// the target currently being targeted.
	var/datum/weakref/acquired_target
	////// how long the target can be focused. changable incase of better ones wanted.
	var/acquisition_duration = 5 SECONDS
	////// whether or not turrets should shoot player-mobs.
	var/target_all = TRUE
	////// whether or not turrets should obey turret flags. over-writes other modes if active.
	var/follow_flags = FALSE

/obj/item/target_designator/examine(mob/user)
	. = ..()
	. += span_notice("已链接<b>[length(linked_turrets)]/[turret_limit]</b>个炮塔。")
	. += span_notice("<b>右键点击</b>一个实体可将其指定为盟友。")
	. += span_notice("<b>左键点击</b>一个位置或实体可将其指定为目标。")
	. += span_notice("<b>使用</b>此物品以切换对人类目标的锁定。")
	. += span_notice("Targeting of non-authorized personnel is [target_all ? "<font color='#ff0000'>ENABLED</font>" : "<font color='#00ff15'>DISABLED</font>"].")
	. += span_notice("<b>Shift-点击</b>此物品以切换旗帜跟随模式。")
	. += span_notice("Turrets are [follow_flags ? "<font color='#00ff15'>OBEYING LAWS</font>" : "<font color='#ff0000'>FREE TARGETING</font>"].")

/obj/item/target_designator/attack_self(mob/user, modifiers)
	. = ..()
	target_all = !target_all
	sync_turrets()

/obj/item/target_designator/ShiftClick(mob/user)
	. = ..()
	follow_flags = !follow_flags
	sync_turrets()
	return

/obj/item/target_designator/ranged_interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!can_see(user, interacting_with, scan_range)) //if outside range, dont bother.
		return NONE

	if(interacting_with in linked_turrets) //to stop issues with linking turrets.
		return NONE

	if(acquired_target) //if there's a target already, cant designate one.
		return ITEM_INTERACT_BLOCKING

	designate_enemy(interacting_with, user)
	addtimer(CALLBACK(src, PROC_REF(clear_target), user), acquisition_duration) //clears after 5 seconds. to avoid issues.
	return ITEM_INTERACT_SUCCESS

/obj/item/target_designator/ranged_interact_with_atom_secondary(atom/interacting_with, mob/living/user, list/modifiers)
	if(!can_see(user, interacting_with, scan_range)) //if outside range, dont bother.
		return ITEM_INTERACT_BLOCKING

	if(istype(interacting_with, /mob/living))
		for(var/obj/machinery/porta_turret/syndicate/toolbox/mag_fed/turret in linked_turrets)
			turret.toggle_ally(interacting_with)
		return ITEM_INTERACT_SUCCESS
	return NONE

/// designates a manual target to turrets
/obj/item/target_designator/proc/designate_enemy(atom/movable/target, mob/user)
	if(!target)
		return
	acquired_target = WEAKREF(target)
	for(var/obj/machinery/porta_turret/syndicate/toolbox/mag_fed/turret in linked_turrets)
		for(var/turret_to_control in 1 to length(linked_turrets))
			turret.override_target(acquired_target?.resolve())
		balloon_alert(user, "目标已指定！")

/// clears manual target acquisition
/obj/item/target_designator/proc/clear_target(user)
	acquired_target = null
	for(var/obj/machinery/porta_turret/syndicate/toolbox/mag_fed/turret in linked_turrets)
		for(var/turret_to_control in 1 to length(linked_turrets))
			turret.clear_override()
		balloon_alert(user, "指定已清除！")

/// Sets all turrets to the same state as the controller.
/obj/item/target_designator/proc/sync_turrets()
	for(var/obj/machinery/porta_turret/syndicate/toolbox/mag_fed/turret in linked_turrets)
		if(target_all == TRUE && follow_flags == FALSE)
			if(!(turret.target_assessment == TURRET_FLAG_SHOOT_EVERYONE))
				turret.target_assessment = TURRET_FLAG_SHOOT_EVERYONE
				turret.balloon_alert_to_viewers("unrestricting targeting!")
		if(follow_flags == TRUE)
			if(!(turret.target_assessment == TURRET_FLAG_OBEY_FLAGS))
				turret.target_assessment = TURRET_FLAG_OBEY_FLAGS
				turret.balloon_alert_to_viewers("obeying laws!")
		if(follow_flags == FALSE && target_all == FALSE)
			if(!(turret.target_assessment == TURRET_FLAG_SHOOT_NOONE))
				turret.target_assessment = TURRET_FLAG_SHOOT_NOONE
				turret.balloon_alert_to_viewers("restricting targeting!")
		turret.setState(TRUE) //So they'll update properly

////// Turret handling //////

/obj/machinery/porta_turret/syndicate/toolbox/mag_fed
	name = "弹匣供弹炮塔"
	desc = "一种设计为从连接的弹匣系统供弹的炮塔。"
	integrity_failure = 0
	max_integrity = 200
	////// delay between shots. Affects burst fire.
	shot_delay = 2 SECONDS
	uses_stored = FALSE
	stored_gun = null
	stun_projectile = null
	stun_projectile_sound = 'sound/items/weapons/gun/pistol/shot.ogg'
	lethal_projectile = null
	lethal_projectile_sound = 'sound/items/weapons/gun/pistol/shot.ogg'
	subsystem_type = /datum/controller/subsystem/processing/projectiles
	turret_flags = TURRET_FLAG_SHOOT_ALL | TURRET_FLAG_SHOOT_ANOMALOUS
	ignore_faction = TRUE
	armor_type = /datum/armor/mobile_turret
	req_access = list() //We use faction and ally system for access. Also so people can change turret flags as needed, though useless bc of syndicate subtyping.
	faction = list(FACTION_TURRET)
	////// Whether or not the turret takes faction into account. If not, only works off user.
	var/faction_targeting = TRUE
	////// Simple damage multiplier for bullets. 1 = normal bullet damage. 0.5 = half damage. 1.5 = 50% more damage. You get the gist.
	var/turret_damage_multiplier = 1
	////// Simple wound bonus for bullets. 0 = no bonus. 10 = more likely to wound. I dont know if we support negative bonuses.
	var/turret_wound_bonus = 0
	////// Does the gun fire in bursts?
	var/burst_fire = FALSE
	////// If burst fire, count of volley?
	var/burst_volley = 3
	////// Where in the burst are we?
	var/volley_count = 0
	////// delay between burst if burst fire
	var/burst_delay = 2 SECONDS
	////// Target of a burst. We need this to seperate it from a target override.
	var/datum/weakref/burst_target
	////// time of last burst.
	var/last_burst = null
	////// Can this turret be retracted without tools?
	var/quick_retract = FALSE
	///// Does quick_retract require faction tags?
	var/smart_retract = TRUE
	///// How long is the timer to retract?
	var/retract_timer = 1 SECONDS
	////// Can this turret load more than one ammunition type. Mostly for sound handling. Might be more important if used in a rework.
	var/adjustable_magwell = TRUE
	////// Does this turret auto-eject its magazines? Will be used later.
	var/mag_drop_collect = FALSE
	//////This is for manual target acquisition stuff. If present, should immediately over-ride as a target.
	var/datum/weakref/target_override
	//////Target Assessment System. Whether or not it's targeting according to flags or even ignoring everyone.
	var/target_assessment = TURRET_FLAG_SHOOT_EVERYONE
	//////Do we want this to shut up? Mostly for testing and debugging purposes purposes.
	var/claptrap_moment = TRUE
	////// Do we want it to eject casings?
	var/casing_ejector = TRUE
	//////what box should this spawn with if it's map_spawned?
	var/mag_box_type = /obj/item/storage/toolbox/emergency/turret/mag_fed/pre_filled
	//////To stop runtimes x1
	var/staminaloss = 0
	//////To stop runtimes x2 + resting firing capabilities. Might be smart to turn off for shotgun?
	var/combat_mode = TRUE
	//////to stop runtimes x3
	var/timer_id
	//////Container of the turret. Needs expanded ref.
	var/datum/weakref/mag_box
	////// Magazine inside the turret.
	var/datum/weakref/magazine_ref
	////// currently loaded bullet
	var/datum/weakref/chambered
	////// linked target designator
	var/datum/weakref/linkage
	////// will the turret destruct into a frame?
	var/fragile = FALSE
	////// whats the chance of the turret dropping a receiver?
	var/receiver_check = 70
	////// whats the chance of the turret dropping a prox sensor?
	var/sensor_check = 30
	////// what frame will it destruct into?
	var/obj/item/turret_assembly/turret_frame

/datum/armor/mobile_turret //weaker armor than syndicate turret.
	melee = 40
	bullet = 30
	laser = 40
	energy = 30
	bomb = 20
	fire = 80
	acid = 80

/obj/machinery/porta_turret/syndicate/toolbox/mag_fed/Initialize(mapload)
	. = ..()
	if(!mag_box) //If we want to make map-spawned turrets in turret form.
		var/auto_loader = new mag_box_type
		mag_box = WEAKREF(auto_loader)
	if(!raised)
		INVOKE_ASYNC(src, PROC_REF(popUp))
	register_context()

/obj/machinery/porta_turret/syndicate/toolbox/mag_fed/update_greyscale()
	. = ..()
	update_appearance()

/obj/machinery/porta_turret/syndicate/toolbox/mag_fed/update_appearance(updates)
	. = ..()
	underlays.Cut()
	underlays += image(icon = icon, icon_state = "[base_icon_state]_frame")

/obj/machinery/porta_turret/syndicate/toolbox/mag_fed/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()
	var/screentip_change = FALSE

	if(istype(held_item) && held_item.tool_behaviour == TOOL_WRENCH && in_faction(user))
		context[SCREENTIP_CONTEXT_LMB] = "Repair Turret"
		return screentip_change = TRUE
	if(istype(held_item) && held_item.tool_behaviour == TOOL_WRENCH && in_faction(user))
		context[SCREENTIP_CONTEXT_RMB] = "Retract Turret"
		return screentip_change = TRUE
	if(istype(held_item, /obj/item/ammo_box/magazine) && in_faction(user))
		context[SCREENTIP_CONTEXT_LMB] = "Feed Turret"
		return screentip_change = TRUE
	if(istype(held_item, /obj/item/target_designator) && in_faction(user))
		context[SCREENTIP_CONTEXT_LMB] = "Link Turret"
		return screentip_change = TRUE
	if(istype(held_item, /obj/item/target_designator) && in_faction(user))
		context[SCREENTIP_CONTEXT_RMB] = "Unlink Turret"
		return screentip_change = TRUE
	if(quick_retract)
		if(smart_retract && !in_faction(user))
			return
		context[SCREENTIP_CONTEXT_ALT_RMB] = "Retract Turret"
		return screentip_change = TRUE

/obj/machinery/porta_turret/syndicate/toolbox/mag_fed/examine(mob/user) //If this breaks i'm gonna have to go to further seperate its examination text to allow better editing.
	. = ..()
	. -= span_notice("你可以用战斗扳手<b>左键点击</b>来修复它。")
	. -= span_notice("你可以用战斗扳手<b>右键点击</b>来折叠它。")
	if(FAST_FACTION_CHECK(faction, user.get_faction(), null, null, FALSE) || has_ally(user))
		. += span_notice("Turret integrity is [atom_integrity]/[max_integrity]")
		. += span_notice("你可以用<b>ID卡</b><b>左键点击</b>来解锁它。")
		. += span_notice("你可以用<b>扳手</b><b>左键点击</b>来修复它。")
		. += span_notice("你可以用<b>扳手</b><b>右键点击</b>来折叠它。")
		. += span_notice("你可以用<b>弹匣</b><b>左键点击</b>来给它装填。")
		. += span_notice("你可以用<b>目标指示器</b><b>左键点击</b>来链接它。")
		. += span_notice("你可以用<b>目标指示器</b><b>右键点击</b>来解除链接。")
		. += span_notice("你可以<b>右键点击</b>空手来强制它装填弹药。")
		if(quick_retract)
			. += span_notice ("你可以用<b>Alt + 右键点击</b>手动收回它！")
		if(linkage)
			. += span_notice("<b><i>此炮塔当前已链接！</i></b>")

/obj/machinery/porta_turret/syndicate/toolbox/mag_fed/on_deconstruction(disassembled, mob/user) // Full re-write, to stop the toolbox var from being a runtimer
	var/obj/item/ammo_box/magazine/mag = magazine_ref?.resolve()
	if(isnull(mag))
		magazine_ref = null
	var/obj/item/storage/toolbox/emergency/turret/mag_fed/auto_loader = mag_box?.resolve()
	if(isnull(auto_loader))
		mag_box = null
	var/obj/item/ammo_casing/casing = chambered?.resolve()
	if(isnull(casing))
		chambered = null
	if(chambered)
		if(!casing.loaded_projectile || QDELETED(casing.loaded_projectile) || !casing.loaded_projectile) //to catch very edge-case stuff thats likely to happen if the turret breaks mid-firing.
			casing.forceMove(drop_location())
			casing.loaded_projectile = null
		if(!magazine_ref)
			casing.forceMove(drop_location())
		else if(mag)
			mag.give_round(casing) //put bullet back in magazine
		chambered = null

	if(magazine_ref)
		if(!disassembled) //This is to stop one specific runtime, and if it's being broken it's probably gonna malf eject
			mag.forceMove(drop_location())
		else if(auto_loader) //if the magazine is being kept this long, it might aswell be shoved back in.
			auto_loader.atom_storage?.attempt_insert(mag, override = TRUE)
		magazine_ref = null

	var/obj/item/target_designator/controller = linkage?.resolve()
	if(!isnull(controller))
		controller.linked_turrets -= src
		UnregisterSignal(controller, COMSIG_QDELETING)
	linkage = null

	if(fragile)
		if(!disassembled)
			for(var/obj/item/guts in auto_loader?.contents)
				guts.forceMove(drop_location())
			new turret_frame(drop_location())
			if(prob(receiver_check))
				new /obj/item/weaponcrafting/receiver(drop_location())
			if(prob(sensor_check))
				new /obj/item/assembly/prox_sensor(drop_location())
			qdel(auto_loader) //servo always break. I dont want to deal with people thinking the one they put in is important or is being tracked
			if(timer_id)
				deltimer(timer_id)
			qdel(src)
			new /obj/effect/gibspawner/robot(drop_location())
			return
	mag_box = null
	auto_loader?.forceMove(drop_location())
	if(timer_id)
		deltimer(timer_id)

	qdel(src)

/// main proc to handle loading magazines and bullets. might need improved?
/obj/machinery/porta_turret/syndicate/toolbox/mag_fed/proc/handle_chamber(chamber_next_round = TRUE)
	var/obj/item/ammo_box/magazine/mag = magazine_ref?.resolve()
	if(isnull(mag))
		magazine_ref = null
	if(isnull(magazine_ref))
		load_mag()

	else if(mag && !mag.ammo_count())
		handle_mag()

	if(chambered)
		eject_cartridge()

	if (chamber_next_round && (mag?.max_ammo > 1))
		chamber_round(FALSE)
		return

/// pulls a cartridge from the magazine and loads it into the chamber
/obj/machinery/porta_turret/syndicate/toolbox/mag_fed/proc/chamber_round(replace_new_round)
	var/obj/item/ammo_box/magazine/mag = magazine_ref?.resolve()
	if(isnull(mag))
		magazine_ref = null
	if (chambered || isnull(magazine_ref))
		return
	if (mag.ammo_count())
		if(!claptrap_moment)
			balloon_alert_to_viewers("loading cartridge...")
		chambered = WEAKREF(mag.get_round())
		var/obj/item/ammo_casing/casing = chambered?.resolve()
		if(isnull(casing))
			chambered = null
		casing.forceMove(src)
		playsound(src, 'sound/items/weapons/gun/general/bolt_rack.ogg', 10, TRUE)
		if(replace_new_round) //For edge-case additions later in the road.
			mag.give_round(new casing.type)

/// handles magazine ejecting and automatic load proccing
/obj/machinery/porta_turret/syndicate/toolbox/mag_fed/proc/handle_mag()
	if(magazine_ref)
		var/obj/item/ammo_box/magazine/mag = magazine_ref?.resolve()
		if(istype(mag))
			if(mag_drop_collect)
				var/obj/item/storage/toolbox/emergency/turret/mag_fed/auto_loader = mag_box?.resolve()
				auto_loader.atom_storage?.attempt_insert(mag, override = TRUE)
				UnregisterSignal(magazine_ref, COMSIG_MOVABLE_MOVED)
			else
				mag.forceMove(drop_location())
				UnregisterSignal(magazine_ref, COMSIG_MOVABLE_MOVED)
		magazine_ref = null
	load_mag()
	playsound(src, 'sound/items/weapons/gun/general/chunkyrack.ogg', 30, TRUE)
	return

/// loads a magazine from the base storage box
/obj/machinery/porta_turret/syndicate/toolbox/mag_fed/proc/load_mag()
	var/obj/item/storage/toolbox/emergency/turret/mag_fed/auto_loader = mag_box?.resolve()
	if(!auto_loader.get_mag())
		balloon_alert_to_viewers("magazine well empty!") // hey, this is actually important info to convey.
		toggle_on(FALSE) // I know i added the shupt-up toggle after adding this, This is just to prevent rapid proccing
		return
	magazine_ref = WEAKREF(auto_loader.get_mag(FALSE))
	var/obj/item/ammo_box/magazine/get_that_mag = magazine_ref?.resolve()
	if(isnull(get_that_mag))
		magazine_ref = null
	get_that_mag.forceMove(src)
	if(!claptrap_moment)
		balloon_alert_to_viewers("loading magazine...")
	return

/// ejects cartridge and calls if issues arrive.
/obj/machinery/porta_turret/syndicate/toolbox/mag_fed/proc/eject_cartridge()
	var/obj/item/ammo_casing/casing = chambered?.resolve() //Find chambered round. i'd give this a funny var name but casing was already here.
	if(isnull(casing))
		chambered = null
	if(istype(casing)) //there's a chambered round
		if(casing_ejector) //To handle casing ejection (Previous version didn't account for caseless ammo and threw runtimes with new system)
			if(!claptrap_moment)
				balloon_alert_to_viewers("ejecting cartridge") // will proc even on caseless cartridges, but it's a debug message.
			casing.forceMove(drop_location()) //Eject casing onto ground.
			chambered = null
			casing.bounce_away(TRUE)
			SEND_SIGNAL(casing, COMSIG_CASING_EJECTED)

/// Allows you to insert magazines while the turret is deployed
/obj/machinery/porta_turret/syndicate/toolbox/mag_fed/proc/insert_mag(obj/item/ammo_box/magazine/magaroni, mob/living/guy_with_mag)
	var/obj/item/storage/toolbox/emergency/turret/mag_fed/auto_loader = mag_box?.resolve()
	if(isnull(auto_loader))
		mag_box = null
	if(!(magaroni.type in auto_loader.atom_storage.can_hold))
		balloon_alert(guy_with_mag, "装不进去！")
		return
	balloon_alert(guy_with_mag, "弹匣已插入！")
	auto_loader?.atom_storage.attempt_insert(magaroni, guy_with_mag, TRUE)
	toggle_on(TRUE)
	return

////// I rewrite/add to the entire proccess. //////

/obj/machinery/porta_turret/syndicate/toolbox/mag_fed/process()
	if(linkage)
		if(burst_target) //we put this before target_override to avoid issues.
			var/atom/movable/bursttarget = burst_target.resolve()
			if(isnull(bursttarget))
				burst_target = null
				volley_count = initial(volley_count)
				return
			trytoshootfucker(burst_target) //we send _this_ one because it's the weakref. Same with the one below. I've had several runtimes before figuring this out.
			return
		if(target_override) //Forces turret to shoot
			var/atom/movable/overridden_target = target_override.resolve()
			if(isnull(overridden_target))
				target_override = null
				return
			trytoshootfucker(target_override) //This is 1 thing. It does not need a list. This kills it because it'll never read a list as null.
			return

	return ..()

/// decides a threat level depending on factors.
/obj/machinery/porta_turret/syndicate/toolbox/mag_fed/assess_perp(mob/living/carbon/human/perp) //We copy the original so we can use target limiting above factions.
	var/threatcount = 0 //the integer returned

	if(obj_flags & EMAGGED)
		return TURRET_THREAT_PRIORITY //if emagged, always return 10.

	if(target_assessment == TURRET_FLAG_SHOOT_EVERYONE)
		return TURRET_THREAT_PRIORITY //will not assess anyone within the faction/ally system.

	if(target_assessment == TURRET_FLAG_SHOOT_NOONE)
		return TURRET_THREAT_PASSIVE //this wont stop you from getting shot if you're inbetween it and its target, but it wont specifically aim at you.

	if((turret_flags & (TURRET_FLAG_SHOOT_ALL | TURRET_FLAG_SHOOT_ALL_REACT)) && !allowed(perp))
		//if the turret has been attacked or is angry, target all non-sec people
		if(!allowed(perp))
			return TURRET_THREAT_PRIORITY

	// If we aren't shooting heads then return a threatcount of 0
	if (!(turret_flags & TURRET_FLAG_SHOOT_HEADS))
		var/datum/job/apparent_job = SSjob.get_job(perp.get_assignment())
		if(apparent_job?.job_flags & JOB_HEAD_OF_STAFF)
			return TURRET_THREAT_PASSIVE

	if(turret_flags & TURRET_FLAG_AUTH_WEAPONS) //check for weapon authorization
		if(!istype(perp.wear_id?.GetID(), /obj/item/card/id/advanced/chameleon))

			if(allowed(perp)) //if the perp has security access, return 0
				return TURRET_THREAT_PASSIVE
			if(perp.is_holding_item_of_type(/obj/item/gun) || perp.is_holding_item_of_type(/obj/item/melee/baton))
				threatcount += TURRET_THREAT_MEDIUM

			if(istype(perp.belt, /obj/item/gun) || istype(perp.belt, /obj/item/melee/baton))
				threatcount += TURRET_THREAT_LOW

	if(turret_flags & TURRET_FLAG_SHOOT_CRIMINALS) //if the turret can check the records, check if they are set to *Arrest* on records
		var/perpname = perp.get_face_name(perp.get_id_name())
		var/datum/record/crew/target = find_record(perpname)
		if(!target || (target.wanted_status == WANTED_ARREST))
			threatcount += TURRET_THREAT_MEDIUM

	if((turret_flags & TURRET_FLAG_SHOOT_UNSHIELDED) && (!HAS_TRAIT(perp, TRAIT_MINDSHIELD)))
		threatcount += TURRET_THREAT_MEDIUM

	return threatcount

/obj/machinery/porta_turret/syndicate/toolbox/mag_fed/in_faction(mob/target)
	if(!faction_targeting)
		return has_ally(target)

	return FAST_FACTION_CHECK(faction, target.get_faction(), allies, target.allies, FALSE)


/// toggles between whether things are inside the ally system
/obj/machinery/porta_turret/syndicate/toolbox/mag_fed/proc/toggle_ally(mob/living/target) //leave these since it's kinda important to know which is being done.
	if(remove_ally(target))
		balloon_alert_to_viewers("ally removed!")
		return
	else
		if(add_ally(target))
			balloon_alert_to_viewers("ally designated!")
		return

/obj/machinery/porta_turret/syndicate/toolbox/mag_fed/target(atom/movable/target)
	if(burst_fire) //if burstfire and not recovering
		if(!burst_target) //if no burst target, assigns one. otherwise goes straight to next area
			do_burst_fire(target, burst_volley)
			return TRUE

	if(target)
		setDir(get_dir(base, target))//even if you can't shoot, follow the target
		shootAt(target)
		return TRUE
	return

/// Burst fire everywhere is a fuck and wont transfer here. We're ESSENTIALLY doing an adjacent override_target proc.
/obj/machinery/porta_turret/syndicate/toolbox/mag_fed/proc/do_burst_fire(atom/movable/target)
	if(!target)
		return
	if(last_burst + burst_delay > world.time)
		return
	burst_target = WEAKREF(target)
	volley_count = burst_volley

/obj/machinery/porta_turret/syndicate/toolbox/mag_fed/proc/end_burst()
	burst_target = null
	last_burst = world.time

/// manual target acquisition from target designator, improves fire rate.
/obj/machinery/porta_turret/syndicate/toolbox/mag_fed/proc/override_target(atom/movable/target)
	if(!target)
		return
	target_override = WEAKREF(target)
	balloon_alert_to_viewers("target acquired!") // So you know whats causing it to fire
	shot_delay = (initial(shot_delay) / 2) //No need to scan for targets so faster work
	burst_delay = (initial(burst_delay) / 2)

/// clears the target and resets fire rate
/obj/machinery/porta_turret/syndicate/toolbox/mag_fed/proc/clear_override()
	target_override = null
	shot_delay = initial(shot_delay)
	burst_delay = initial(burst_delay)

/obj/machinery/porta_turret/syndicate/toolbox/mag_fed/tryToShootAt(list/atom/movable/things_in_my_lawn) //better target prioritization, shoots at closest simple mob
	var/turf/my_lawn = get_turf(src)
	while(things_in_my_lawn.len > 0)
		var/atom/movable/whipper_snapper = get_closest_atom(/mob/living, things_in_my_lawn, my_lawn)
		things_in_my_lawn -= whipper_snapper
		if(target(whipper_snapper))
			return TRUE

/// Shoots at one specific target. Only happens if target is overridden. modularized for burst?
/obj/machinery/porta_turret/syndicate/toolbox/mag_fed/proc/trytoshootfucker(datum/weakref/target_weakref)
	var/atom/movable/overridden_target = target_weakref?.resolve()
	if(isnull(overridden_target))
		target_override = null
		burst_target = null
		return
	while(overridden_target)
		if(target(overridden_target)) //ok. It's trying to shoot a weakref. Thats the issue.
			return TRUE

/obj/machinery/porta_turret/syndicate/toolbox/mag_fed/shootAt(atom/movable/target)
	if(!chambered) //Ok, We need to START the cycle
		handle_chamber(TRUE)
		return

	if(!raised) //the turret has to be raised in order to fire - makes sense, right?
		return

	if(!(obj_flags & EMAGGED)) //if it hasn't been emagged, cooldown before shooting again
		if(last_fired + shot_delay > world.time)
			return
		last_fired = world.time
		if(burst_target && volley_count >= 1) // we put this here so it's somewhat in-sync. i hope.
			volley_count -= 1
			if(volley_count == 0)
				end_burst()

	var/turf/my_lawn = get_turf(src)
	var/turf/targetturf = get_turf(target)
	if(!istype(my_lawn) || !istype(targetturf))
		return

	setDir(get_dir(base, target))
	update_appearance()

	var/obj/item/ammo_casing/casing = chambered?.resolve()
	if(casing.loaded_projectile && !QDELETED(casing.loaded_projectile))
		handle_firing(casing, target)
		return

	handle_chamber(TRUE)

/// Handles the firing process. Will need edited for special ammo types like 980.
/obj/machinery/porta_turret/syndicate/toolbox/mag_fed/proc/handle_firing(obj/item/ammo_casing/casing, atom/movable/target)
	var/obj/projectile/our_projectile = casing.loaded_projectile
	if(ignore_faction)
		APPLY_FACTION_AND_ALLIES_FROM(our_projectile, src)
	our_projectile.damage *= turret_damage_multiplier
	our_projectile.stamina *= turret_damage_multiplier

	our_projectile.wound_bonus += turret_wound_bonus
	our_projectile.exposed_wound_bonus += turret_wound_bonus
	casing.fire_casing(target, src, null, null, null, BODY_ZONE_CHEST, 0, src)
	play_fire_sound(casing)


/// So because the casing firing process calls it, Lets use this to handle the auto-reload.

/obj/machinery/porta_turret/syndicate/toolbox/mag_fed/proc/changeNext_move()
	handle_chamber(TRUE)

/// Handles which sound should play when the gun fires, as it does adjust between different ammo types.
/obj/machinery/porta_turret/syndicate/toolbox/mag_fed/proc/play_fire_sound(obj/item/ammo_casing/soundmaker) //Hella Iffy.
	var/fire_sound = lethal_projectile_sound
	if(!adjustable_magwell) //if it has 1 magazine type
		fire_sound = lethal_projectile_sound
	else if(istype(soundmaker, /obj/item/ammo_casing/c35sol))
		fire_sound = 'modular_nova/modules/modular_weapons/sounds/pistol_light.ogg'
	else if(istype(soundmaker, /obj/item/ammo_casing/c585trappiste))
		fire_sound = 'modular_nova/modules/modular_weapons/sounds/pistol_heavy.ogg'
	else if(istype(soundmaker, /obj/item/ammo_casing/c40sol))
		fire_sound = 'modular_nova/modules/modular_weapons/sounds/rifle_heavy.ogg'
	else if(istype(soundmaker, /obj/item/ammo_casing/strilka310))
		fire_sound = 'modular_nova/modules/modular_weapons/sounds/battle_rifle.ogg'
	else if(istype(soundmaker, /obj/item/ammo_casing/c27_54cesarzowa))
		fire_sound = 'modular_nova/modules/modular_weapons/sounds/smg_light.ogg'

	playsound(src, fire_sound, 60, TRUE)

////// Operation Handling //////

/obj/machinery/porta_turret/syndicate/toolbox/mag_fed/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers) // This hasn't been changed upstream yet.
	var/obj/item/storage/toolbox/emergency/turret/mag_fed/auto_loader = mag_box?.resolve()
	if(isnull(auto_loader))
		mag_box = null
	if(attacking_item.type in auto_loader.atom_storage.can_hold)
		balloon_alert(user, "正在尝试加载...")
		if(!do_after(user, 1 SECONDS, src))
			balloon_alert(user, "加载失败！")
		insert_mag(attacking_item, user)
		return

	if(istype(attacking_item, /obj/item/card/id))
		if(!in_faction(user))
			balloon_alert(user, "访问被拒绝！")
			return

	if(in_faction(user))
		if(istype(attacking_item, /obj/item/target_designator))
			var/obj/item/target_designator/controller = attacking_item
			if(length(controller.linked_turrets) >= controller.turret_limit)
				balloon_alert(user, "炮塔数量已达上限！")
				return
			if(linkage) //should help both preventing dual-controlling AND double-linking causing odd issues with ally system
				balloon_alert(user, "炮塔已链接！")
				return
			linkage = WEAKREF(controller)
			controller.linked_turrets += src
			RegisterSignal(controller, COMSIG_QDELETING, PROC_REF(on_qdeleted), TRUE) //True otherwise it causes a runtime for overwriting parent qdeling. Dont know where to go elsewise.
			balloon_alert(user, "炮塔已链接！")
			return

/obj/machinery/porta_turret/syndicate/toolbox/mag_fed/wrench_act(mob/living/user, obj/item/attacking_item)
	if(atom_integrity == max_integrity)
		if(!claptrap_moment)
			balloon_alert(user, "已修复完毕！")
		return ITEM_INTERACT_SUCCESS

	if(!claptrap_moment)
		balloon_alert(user, "正在修复...")
	while(atom_integrity != max_integrity)
		if(!attacking_item.use_tool(src, user, 2 SECONDS, volume = 20))
			return ITEM_INTERACT_FAILURE

		repair_damage(25)

	if(!claptrap_moment)
		balloon_alert(user, "已修复！")
	return ITEM_INTERACT_SUCCESS

/obj/machinery/porta_turret/syndicate/toolbox/mag_fed/attackby_secondary(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers) //IM TIRED OF MISMATCHED VAR NAMES. IT'S ATTACK_ITEM ON MAIN, WHY WEAPON HERE?
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(in_faction(user))
		if(istype(attacking_item, /obj/item/target_designator))
			var/obj/item/target_designator/owner_check = linkage?.resolve()
			if(attacking_item != owner_check) //cant unlink if not the same one
				balloon_alert(user, "炮塔未链接！")
				return
			var/obj/item/target_designator/controller = attacking_item
			linkage = null
			controller.linked_turrets -= src
			balloon_alert(user, "炮塔已解除链接！")
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	if(attacking_item.tool_behaviour != TOOL_WRENCH)
		return SECONDARY_ATTACK_CALL_NORMAL

	if(!attacking_item.toolspeed)
		return SECONDARY_ATTACK_CALL_NORMAL

	if(!claptrap_moment)
		balloon_alert(user, "正在解构...")
	if(!attacking_item.use_tool(src, user, 5 SECONDS, volume = 20))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	attacking_item.play_tool_sound(src, 50)
	deconstruct(TRUE)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/machinery/porta_turret/syndicate/toolbox/mag_fed/click_alt_secondary(mob/user)
	. = ..()
	if(quick_retract)
		if(smart_retract && !in_faction(user))
			return
		playsound(src, 'sound/items/tools/ratchet.ogg', 50, TRUE)
		if(!do_after(user, retract_timer))
			return
		deconstruct(TRUE)

/obj/machinery/porta_turret/syndicate/toolbox/mag_fed/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(!chambered)
		handle_chamber(TRUE)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/machinery/porta_turret/syndicate/toolbox/mag_fed/proc/on_qdeleted(datum/source) //I hope this is what you ment.
	SIGNAL_HANDLER

	var/obj/item/target_designator/controller = linkage?.resolve()
	controller.linked_turrets -= source

////// Define Killing.

#undef TURRET_STUN
#undef TURRET_LETHAL

#undef TURRET_FLAG_SHOOT_ALL_REACT
#undef TURRET_FLAG_AUTH_WEAPONS
#undef TURRET_FLAG_SHOOT_CRIMINALS
#undef TURRET_FLAG_SHOOT_ALL
#undef TURRET_FLAG_SHOOT_ANOMALOUS
#undef TURRET_FLAG_SHOOT_UNSHIELDED
#undef TURRET_FLAG_SHOOT_BORGS
#undef TURRET_FLAG_SHOOT_HEADS

#undef TURRET_FLAG_OBEY_FLAGS
#undef TURRET_FLAG_SHOOT_NOONE
#undef TURRET_FLAG_SHOOT_EVERYONE

#undef TURRET_THREAT_PASSIVE
#undef TURRET_THREAT_LOW
#undef TURRET_THREAT_MEDIUM
#undef TURRET_THREAT_HIGH
#undef TURRET_THREAT_SEVERE
#undef TURRET_THREAT_PRIORITY
