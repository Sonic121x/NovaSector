GLOBAL_LIST_EMPTY(total_extraction_beacons)

/obj/item/extraction_pack
	name = "富尔顿提取包"
	desc = "一个可以将设备或人员提取运送到富尔顿回收信标的气球。任何未固定在地板上的物品都可以移动。通过手持使用气球包来与信标连接."
	icon = 'icons/obj/fulton.dmi'
	icon_state = "extraction_pack"
	w_class = WEIGHT_CLASS_NORMAL
	/// Beacon weakref
	var/datum/weakref/beacon_ref
	/// List of networks
	var/list/beacon_networks = list("station")
	/// Number of uses left
	var/uses_left = 3
	/// Can be used indoors
	var/can_use_indoors
	/// Can be used on living creatures
	var/safe_for_living_creatures = TRUE
	/// Maximum force that can be used to extract
	var/max_force_fulton = MOVE_FORCE_STRONG

/obj/item/extraction_pack/examine()
	. = ..()
	. += span_infoplain("它还有[uses_left] use\s 剩余。")

	var/obj/structure/extraction_point/beacon = beacon_ref?.resolve()

	if(isnull(beacon))
		beacon_ref = null
		. += span_infoplain("它没有连接到信标。")
		return

	. += span_infoplain("它已链接到[beacon.name]。")

/obj/item/extraction_pack/attack_self(mob/user)
	var/list/possible_beacons = list()
	for(var/datum/weakref/point_ref as anything in GLOB.total_extraction_beacons)
		var/obj/structure/extraction_point/extraction_point = point_ref.resolve()
		if(isnull(extraction_point))
			GLOB.total_extraction_beacons.Remove(point_ref)
			continue
		if(extraction_point.beacon_network in beacon_networks)
			possible_beacons += extraction_point

	if(!length(possible_beacons))
		balloon_alert(user, "没有信标")
		return

	var/chosen_beacon = tgui_input_list(user, "要连接的信标", "气球提取包", sort_names(possible_beacons))
	if(isnull(chosen_beacon))
		return

	beacon_ref = WEAKREF(chosen_beacon)
	balloon_alert(user, "已链接！")

/obj/item/extraction_pack/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!ismovable(interacting_with))
		return NONE
	if(!isturf(interacting_with.loc)) // no extracting stuff inside other stuff
		return NONE
	var/atom/movable/thing = interacting_with
	if(thing.anchored)
		return NONE

	var/obj/structure/extraction_point/beacon = beacon_ref?.resolve()
	if(isnull(beacon))
		balloon_alert(user, "未链接！")
		beacon_ref = null
		return ITEM_INTERACT_BLOCKING
	var/area/area = get_area(thing)
	if(!can_use_indoors)
		if(!area.outdoors)
			balloon_alert(user, "不在户外！")
			return ITEM_INTERACT_BLOCKING
	if(area.area_flags & NOTELEPORT)
		balloon_alert(user, "无法激活！")
		return ITEM_INTERACT_BLOCKING
	var/area/target_area = get_area(beacon)
	if(area != target_area && ((area.area_flags & LOCAL_TELEPORT) || (target_area.area_flags & LOCAL_TELEPORT)))
		balloon_alert(user, "无法激活！")
		return ITEM_INTERACT_BLOCKING
	if(!safe_for_living_creatures && check_for_living_mobs(thing))
		to_chat(user, span_warning("[src] 对活体生物不安全，它们无法在返程中存活！"))
		balloon_alert(user, "不安全！")
		return ITEM_INTERACT_BLOCKING
	if(thing.move_resist > max_force_fulton)
		balloon_alert(user, "太重了！")
		return ITEM_INTERACT_BLOCKING
	balloon_alert_to_viewers("attaching...")
	playsound(thing, 'sound/items/zip/zip.ogg', vol = 50, vary = TRUE)
	if(isliving(thing))
		var/mob/living/creature = thing
		if(creature.mind)
			to_chat(thing, span_userdanger("你正在被提取！保持静止以继续。"))

	if(!do_after(user, 5 SECONDS, target = thing))
		return ITEM_INTERACT_BLOCKING

	if(QDELETED(beacon))
		balloon_alert(user, "beacon lost!")
		return ITEM_INTERACT_BLOCKING

	balloon_alert_to_viewers("extracting!")
	if(loc == user && ishuman(user))
		var/mob/living/carbon/human/human_user = user
		human_user.back?.atom_storage?.attempt_insert(src, user, force = STORAGE_SOFT_LOCKED)
	uses_left--

	if(uses_left <= 0)
		user.transferItemToLoc(src, thing, TRUE)

	if(isliving(thing))
		var/mob/living/creature = thing
		creature.Paralyze(32 SECONDS) // Keep them from moving during the duration of the extraction
		ADD_TRAIT(creature, TRAIT_FORCED_STANDING, FULTON_PACK_TRAIT) // Prevents animation jank from happening
		if(creature.buckled)
			creature.buckled.unbuckle_mob(creature, TRUE) // Unbuckle them to prevent anchoring problems
	else
		thing.set_anchored(TRUE)
		thing.set_density(FALSE)

	var/obj/effect/extraction_holder/holder_obj = new(get_turf(thing))
	holder_obj.appearance = thing.appearance
	thing.forceMove(holder_obj)
	var/mutable_appearance/balloon2 = mutable_appearance('icons/effects/fulton_balloon.dmi', "fulton_expand", layer = VEHICLE_LAYER, appearance_flags = RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM | KEEP_APART)
	balloon2.pixel_z = 10
	holder_obj.add_overlay(balloon2)
	addtimer(CALLBACK(src, PROC_REF(create_balloon), thing, user, holder_obj, balloon2), 0.4 SECONDS)
	return ITEM_INTERACT_SUCCESS

/obj/item/extraction_pack/proc/create_balloon(atom/movable/thing, mob/living/user, obj/effect/extraction_holder/holder_obj, mutable_appearance/balloon2)
	var/turf/beacon_turf = get_turf(beacon_ref.resolve())
	var/mutable_appearance/balloon = mutable_appearance('icons/effects/fulton_balloon.dmi', "fulton_balloon", layer = VEHICLE_LAYER, appearance_flags = RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM | KEEP_APART)
	balloon.pixel_z = 10
	holder_obj.cut_overlay(balloon2)
	holder_obj.add_overlay(balloon)
	playsound(holder_obj.loc, 'sound/items/fulton/fultext_deploy.ogg', vol = 50, vary = TRUE, extrarange = -3)

	animate(holder_obj, pixel_z = 10, time = 2 SECONDS, flags = ANIMATION_RELATIVE)
	animate(pixel_z = 5, time = 1 SECONDS, flags = ANIMATION_RELATIVE)
	animate(pixel_z = -5, time = 1 SECONDS, flags = ANIMATION_RELATIVE)
	animate(pixel_z = 5, time = 1 SECONDS, flags = ANIMATION_RELATIVE)
	animate(pixel_z = -5, time = 1 SECONDS, flags = ANIMATION_RELATIVE)

	sleep(6 SECONDS)

	playsound(holder_obj.loc, 'sound/items/fulton/fultext_launch.ogg', vol = 50, vary = TRUE, extrarange = -3)
	animate(holder_obj, pixel_z = 1000, time = 3 SECONDS, flags = ANIMATION_RELATIVE)

	if(ishuman(thing))
		var/mob/living/carbon/human/creature = thing
		creature.SetUnconscious(0)
		creature.remove_status_effect(/datum/status_effect/drowsiness)
		creature.SetSleeping(0)

	sleep(3 SECONDS)

	var/turf/flooring_near_beacon = list()
	for(var/turf/floor as anything in RANGE_TURFS(1, beacon_turf))
		if(!floor.is_blocked_turf())
			flooring_near_beacon += floor

	if(!length(flooring_near_beacon))
		flooring_near_beacon += beacon_turf

	holder_obj.forceMove(pick(flooring_near_beacon))

	animate(holder_obj, pixel_z = -990, time = 5 SECONDS, flags = ANIMATION_RELATIVE)
	animate(pixel_z = 5, time = 1 SECONDS, flags = ANIMATION_RELATIVE)
	animate(pixel_z = -5, time = 1 SECONDS, flags = ANIMATION_RELATIVE)

	sleep(7 SECONDS)

	var/mutable_appearance/balloon3 = mutable_appearance('icons/effects/fulton_balloon.dmi', "fulton_retract", layer = VEHICLE_LAYER, appearance_flags = RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM | KEEP_APART)
	balloon3.pixel_z = 10
	holder_obj.cut_overlay(balloon)
	holder_obj.add_overlay(balloon3)

	sleep(0.4 SECONDS)

	holder_obj.cut_overlay(balloon3)
	if (isliving(thing))
		REMOVE_TRAIT(thing, TRAIT_FORCED_STANDING, FULTON_PACK_TRAIT)
	thing.set_anchored(FALSE) // An item has to be unanchored to be extracted in the first place.
	thing.set_density(initial(thing.density))
	animate(holder_obj, pixel_z = -10, time = 0.5 SECONDS, flags = ANIMATION_RELATIVE)
	sleep(0.5 SECONDS)
	thing.forceMove(holder_obj.loc)
	qdel(holder_obj)
	if(uses_left <= 0)
		qdel(src)

/obj/item/fulton_core
	name = "提取信标组件套"
	desc = "在安装完成后，会发出一种信号，供富尔顿装置锁定接收。在手边激活后，会展开成一个信号灯。"
	icon = 'icons/obj/fulton.dmi'
	icon_state = "folded_extraction"

/obj/item/fulton_core/attack_self(mob/user)
	var/area/user_area = get_area(user)
	if(user_area.area_flags & NOTELEPORT)
		balloon_alert(user, "无法部署！")
		return

	if(!do_after(user, 1.5 SECONDS, target = user) || QDELETED(src))
		return

	new /obj/structure/extraction_point(get_turf(user))
	playsound(src, 'sound/items/deconstruct.ogg', vol = 50, vary = TRUE, extrarange = MEDIUM_RANGE_SOUND_EXTRARANGE)
	qdel(src)

/obj/structure/extraction_point
	name = "富尔顿回收信标"
	desc = "富尔顿回收系统的信标。激活你手中的背包，将它与一个信标连接起来。"
	icon = 'icons/obj/fulton.dmi'
	icon_state = "extraction_point"
	anchored = TRUE
	density = FALSE
	obj_flags = CAN_BE_HIT | UNIQUE_RENAME
	var/beacon_network = "station"

/obj/structure/extraction_point/Initialize(mapload)
	. = ..()
	name += " ([rand(100,999)]) ([get_area_name(src, TRUE)])"
	GLOB.total_extraction_beacons.Add(WEAKREF(src))
	update_appearance(UPDATE_OVERLAYS)

/obj/structure/extraction_point/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	balloon_alert_to_viewers("undeploying...")
	if(!do_after(user, 1.5 SECONDS, src))
		return
	new /obj/item/fulton_core(drop_location())
	playsound(src, 'sound/items/deconstruct.ogg', vol = 50, vary = TRUE, extrarange = MEDIUM_RANGE_SOUND_EXTRARANGE)
	qdel(src)

/obj/structure/extraction_point/update_overlays()
	. = ..()
	. += emissive_appearance(icon, "[icon_state]_light", src, alpha = src.alpha)

/obj/effect/extraction_holder
	name = "提取持有者"
	desc = "你不应该看到这个"
	var/atom/movable/stored_obj

/obj/item/extraction_pack/proc/check_for_living_mobs(atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(L.stat != DEAD)
			return TRUE
	for(var/thing in A.get_all_contents())
		if(isliving(A))
			var/mob/living/L = A
			if(L.stat != DEAD)
				return TRUE
	return FALSE

/obj/effect/extraction_holder/singularity_act()
	return

/obj/effect/extraction_holder/singularity_pull(atom/singularity, current_size)
	return

/obj/item/extraction_pack/syndicate
	name = "辛迪加富尔顿提取包"
	can_use_indoors = TRUE
