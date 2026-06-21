/**********************Mining Scanners**********************/
/obj/item/mining_scanner
	desc = "一个用于探测周围岩石中有用矿物的手动式扫描仪；它也可以用来阻止爆裂闪矿的爆炸反应."
	name = "手动矿物扫描仪"
	icon = 'icons/obj/devices/scanner.dmi'
	icon_state = "manual_mining"
	inhand_icon_state = "analyzer"
	worn_icon_state = "analyzer"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	obj_flags = CONDUCTS_ELECTRICITY
	slot_flags = ITEM_SLOT_BELT
	/// The cooldown between scans.
	var/cooldown = 35
	/// Current time until the next scan can be performed.
	var/current_cooldown = 0

/obj/item/mining_scanner/attack_self(mob/user)
	if(!user.client)
		return
	if(current_cooldown <= world.time)
		current_cooldown = world.time + cooldown
		mineral_scan_pulse(get_turf(user), scanner = src)

//Debug item to identify all ore spread quickly
/obj/item/mining_scanner/admin

/obj/item/mining_scanner/admin/attack_self(mob/user)
	for(var/turf/closed/mineral/rock in world)
		if(rock.scan_state)
			var/mutable_appearance/rock_overlay = mutable_appearance(rock.scan_icon, rock.scan_state, FLASH_LAYER, rock, ABOVE_LIGHTING_PLANE, appearance_flags = RESET_TRANSFORM)
			rock.add_overlay(rock_overlay)
	qdel(src)

/obj/item/t_scanner/adv_mining_scanner
	desc = "一个用于探测周围岩石中有用矿物的自动扫描仪；它也可以用来阻止爆裂闪矿的爆炸反应.这个型号有更大的探测范围."
	name = "先进自动矿物扫描仪"
	icon_state = "advmining0"
	inhand_icon_state = "analyzer"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	obj_flags = CONDUCTS_ELECTRICITY
	slot_flags = ITEM_SLOT_BELT
	/// The cooldown between scans.
	var/cooldown = 35
	/// Current time until the next scan can be performed.
	var/current_cooldown = 0
	/// The range of the scanner in tiles.
	var/range = 7

//get no effects from the t-ray scanner, which auto-shuts off.
/obj/item/t_scanner/adv_mining_scanner/cyborg_unequip(mob/user)
	return

/obj/item/t_scanner/adv_mining_scanner/cyborg/Initialize(mapload)
	. = ..()
	toggle_on()

/obj/item/t_scanner/adv_mining_scanner/lesser
	name = "自动矿物扫描仪"
	desc = "一个用于探测周围岩石中有用矿物的自动扫描仪；它也可以用来阻止爆裂闪矿的爆炸反应."
	icon_state = "mining0"
	range = 4
	cooldown = 50

/obj/item/t_scanner/adv_mining_scanner/scan()
	if(current_cooldown <= world.time)
		current_cooldown = world.time + cooldown
		var/turf/t = get_turf(src)
		mineral_scan_pulse(t, range, src)

/proc/mineral_scan_pulse(turf/start_turf, range = world.view, obj/item/scanner)
	var/vents_nearby = FALSE
	var/undiscovered = FALSE
	var/radar_volume = 30

	for(var/obj/structure/ore_vent/vent in range(range, start_turf))
		if(!vents_nearby && (!vent.discovered || !vent.tapped))
			vents_nearby = TRUE
			if(vent.discovered)
				undiscovered = TRUE
		var/potential_volume = 80 - (get_dist(scanner, vent) * 10)
		radar_volume = max(potential_volume, radar_volume)
		vent.add_mineral_overlays()

	for(var/turf/closed/mineral/mineral in RANGE_TURFS(range, start_turf))
		if(mineral.scan_state)
			mineral.flash_scan()

	if(vents_nearby && scanner)
		if(undiscovered)
			playsound(scanner, 'sound/machines/radar-ping.ogg', radar_volume, FALSE)
			scanner.balloon_alert_to_viewers("ore vent nearby")
		else
			playsound(scanner, 'sound/machines/sonar-ping.ogg', radar_volume, FALSE)
		scanner.spasm_animation(1.5 SECONDS)

/obj/effect/temp_visual/mining_overlay
	plane = HIGH_GAME_PLANE
	layer = FLASH_LAYER
	icon = 'icons/blanks/480x480.dmi'
	icon_state = "nothing"
	appearance_flags = NONE // to avoid having TILE_BOUND in the flags, so that the 480x480 icon states let you see it no matter where you are
	duration = 3.5 SECONDS
	pixel_x = -224
	pixel_y = -224
	/// What animation easing to use when we create the ore overlay on rock walls/ore vents.
	var/easing_style = EASE_IN

/obj/effect/temp_visual/mining_overlay/Initialize(mapload)
	. = ..()
	animate(src, alpha = 0, time = duration, easing = easing_style)
