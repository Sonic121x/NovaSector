// DAT FUKKEN DISK.
/obj/item/disk/nuclear
	name = "核认证磁盘"
	desc = "最好确保这玩意的安全"
	icon_state = "nucleardisk"
	max_integrity = 250
	sticker_icon_state = null
	armor_type = /datum/armor/disk_nuclear
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	read_only = TRUE
	read_only_locked = TRUE
	/// Whether we're a real nuke disk or not.
	var/fake = FALSE

/datum/armor/disk_nuclear
	bomb = 30
	fire = 100
	acid = 100

/obj/item/disk/nuclear/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/bed_tuckable, mapload, 6, -6, 0)

	if(!fake)
		AddComponent(/datum/component/stationloving, !fake)
		AddComponent(/datum/component/keep_me_secure, CALLBACK(src, PROC_REF(secured_process)), CALLBACK(src, PROC_REF(unsecured_process)), 10)
		SSpoints_of_interest.make_point_of_interest(src)
		add_minimap_blip(src, MINIMAP_NUKEDISK_BLIP, "green_disk_off", 'icons/ui_icons/minimap/map_blips_large.dmi', TRUE)
	else
		// Ensure fake disks still have examine text, but dont actually do anything
		AddComponent(/datum/component/keep_me_secure)

/obj/item/disk/nuclear/setup_reskins()
	return

/obj/item/disk/nuclear/proc/secured_process(last_move)
	var/turf/new_turf = get_turf(src)
	var/datum/round_event_control/operative/loneop = locate(/datum/round_event_control/operative) in SSevents.control
	if(istype(loneop) && loneop.occurrences < loneop.max_occurrences && prob(loneop.weight))
		loneop.weight = max(loneop.weight - 1, 0)
		if(loneop.weight % 5 == 0 && SSticker.totalPlayers > 1)
			message_admins("[src] is secured (currently in [ADMIN_VERBOSEJMP(new_turf)]). The weight of Lone Operative is now [loneop.weight].")
		log_game("[src] being secured has reduced the weight of the Lone Operative event to [loneop.weight].")

/obj/item/disk/nuclear/proc/unsecured_process(last_move)
	var/turf/new_turf = get_turf(src)
	/// How comfy is our disk?
	var/disk_comfort_level = 0

	//Go through and check for items that make disk comfy
	for(var/obj/comfort_item in loc)
		if(istype(comfort_item, /obj/item/bedsheet) || istype(comfort_item, /obj/structure/bed))
			disk_comfort_level++

	if(last_move < world.time - 500 SECONDS && prob((world.time - 500 SECONDS - last_move)*0.0001))
		var/datum/round_event_control/operative/loneop = locate(/datum/round_event_control/operative) in SSevents.control
		if(istype(loneop) && loneop.occurrences < loneop.max_occurrences)
			loneop.weight += 1
			if(loneop.weight % 5 == 0 && SSticker.totalPlayers > 1)
				if(disk_comfort_level >= 2)
					visible_message(span_notice("[src]安详地睡着了。睡个好觉，小磁盘。"))
				message_admins("[src] is unsecured in [ADMIN_VERBOSEJMP(new_turf)]. The weight of Lone Operative is now [loneop.weight].")
			log_game("[src] was left unsecured in [loc_name(new_turf)]. Weight of the Lone Operative event increased to [loneop.weight].")

/obj/item/disk/nuclear/examine(mob/user)
	. = ..()
	if(!fake)
		return

	if(isobserver(user) || HAS_MIND_TRAIT(user, TRAIT_DISK_VERIFIER))
		. += span_warning("[src]上的序列号不正确。")

/*
 * You can't accidentally eat the nuke disk, bro
 */
/obj/item/disk/nuclear/on_accidental_consumption(mob/living/carbon/M, mob/living/carbon/user, obj/item/source_item, discover_after = TRUE)
	M.visible_message(span_warning("[M]看起来[M.p_theyve()]刚刚咬到了什么重要的东西。"), \
						span_warning("等等，这难道是核弹验证盘？"))

	return discover_after

/obj/item/disk/nuclear/attackby(obj/item/weapon, mob/living/user, list/modifiers, list/attack_modifiers)
	if(istype(weapon, /obj/item/claymore/highlander) && !fake)
		var/obj/item/claymore/highlander/claymore = weapon
		if(claymore.nuke_disk)
			to_chat(user, span_notice("等等……什么情况？"))
			qdel(claymore.nuke_disk)
			claymore.nuke_disk = null
			return

		user.visible_message(
			span_warning("[user]捕获了[src]！"),
			span_userdanger("你拿到了验证盘！拼死守护它！"),
		)
		forceMove(claymore)
		claymore.nuke_disk = src
		return TRUE

	return ..()

/obj/item/disk/nuclear/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user]正在进入德尔塔状态！看起来[user.p_theyre()]试图自杀！"))
	playsound(src, 'sound/announcer/alarm/nuke_alarm.ogg', 50, -1, TRUE)
	for(var/i in 1 to 100)
		addtimer(CALLBACK(user, TYPE_PROC_REF(/atom, add_atom_colour), (i % 2)? COLOR_VIBRANT_LIME : COLOR_RED, ADMIN_COLOUR_PRIORITY), i)
	addtimer(CALLBACK(src, PROC_REF(manual_suicide), user), 101)
	return MANUAL_SUICIDE

/obj/item/disk/nuclear/proc/manual_suicide(mob/living/user)
	user.remove_atom_colour(ADMIN_COLOUR_PRIORITY)
	user.visible_message(span_suicide("[user]被核爆摧毁了！"))
	user.adjust_oxy_loss(200)
	user.death(FALSE)

/obj/item/disk/nuclear/fake
	fake = TRUE

/obj/item/disk/nuclear/fake/obvious
	name = "核认证磁盘的粗劣仿制品"
	desc = "任何人怎么会把这个看作真的而搞错，真是让人无法理解。"
