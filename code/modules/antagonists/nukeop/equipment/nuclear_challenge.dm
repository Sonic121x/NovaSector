// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
#define CHALLENGE_TELECRYSTALS 280
#define CHALLENGE_TIME_LIMIT (5 MINUTES)
#define CHALLENGE_SHUTTLE_DELAY (25 MINUTES) // 25 minutes, so the ops have at least 5 minutes before the shuttle is callable.

GLOBAL_LIST_EMPTY(jam_on_wardec)

/obj/item/nuclear_challenge
	name = "Declaration of War (Challenge Mode)"
	icon = 'icons/obj/devices/voice.dmi'
	icon_state = "nukietalkie"
	inhand_icon_state = "nukietalkie"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	desc = "Use to send a declaration of hostilities to the target, delaying your shuttle departure for 20 minutes while they prepare for your assault.  \
			Such a brazen move will attract the attention of powerful benefactors within the Syndicate, who will supply your team with a massive amount of bonus telecrystals.  \
			Must be used within five minutes, or your benefactors will lose interest."
	var/declaring_war = FALSE
	var/uplink_type = /obj/item/uplink/nuclear
	var/announcement_sound = 'sound/announcer/alarm/nuke_alarm.ogg'

/obj/item/nuclear_challenge/attack_self(mob/living/user)
	if(!check_allowed(user))
		return

	declaring_war = TRUE
	var/are_you_sure = tgui_alert(user, LANG("obj.e39d604c9bbd668c", list(station_name(), DisplayTimeText(CHALLENGE_TIME_LIMIT - world.time - SSticker.round_start_time))), LANG("obj.5081c3eabe95a94b", null), list("Yes", "No"))
	declaring_war = FALSE

	if(!check_allowed(user))
		return

	if(are_you_sure != "Yes")
		to_chat(user, span_notice(LANG("obj.b52c50d0d4732e5d", null)))
		return

	var/war_declaration = "A syndicate fringe group has declared their intent to utterly destroy [station_name()] with a nuclear device, and dares the crew to try and stop them."

	declaring_war = TRUE
	var/custom_threat = tgui_alert(user, LANG("obj.2bf44c80e29a097b", null), LANG("obj.1633be84ed371b74", null), list("Yes", "No"))
	declaring_war = FALSE

	if(!check_allowed(user))
		return

	if(custom_threat == "Yes")
		declaring_war = TRUE
		war_declaration = tgui_input_text(user, LANG("obj.b810c0c16ec4c4f9", null), LANG("obj.08ddc85f17f0d9f0", null), max_length = MAX_MESSAGE_LEN, multiline = TRUE, encode = FALSE)
		declaring_war = FALSE

	if(!check_allowed(user) || !war_declaration)
		return

	war_was_declared(user, memo = war_declaration)

///Admin only proc to bypass checks and force a war declaration. Button on antag panel.
/obj/item/nuclear_challenge/proc/force_war()
	var/are_you_sure = tgui_alert(usr, LANG("obj.b0395880992a5ccf", list(GLOB.player_list.len < CHALLENGE_MIN_PLAYERS ? " Note, the player count is under the required limit." : "")), LANG("obj.5081c3eabe95a94b", null), list("Yes", "No"))

	if(are_you_sure != "Yes")
		return

	var/war_declaration = "A syndicate fringe group has declared their intent to utterly destroy [station_name()] with a nuclear device, and dares the crew to try and stop them."

	var/custom_threat = tgui_alert(usr, LANG("obj.bb058e93dff7363b", null), LANG("obj.1633be84ed371b74", null), list("Yes", "No"))

	if(custom_threat == "Yes")
		war_declaration = tgui_input_text(usr, LANG("obj.b810c0c16ec4c4f9", null), LANG("obj.08ddc85f17f0d9f0", null), max_length = MAX_MESSAGE_LEN, multiline = TRUE, encode = FALSE)

	if(!war_declaration)
		tgui_alert(usr, LANG("obj.295786f528ae738e", null), LANG("obj.edde0e71adba8c28", null))
		return

	for(var/obj/item/circuitboard/computer/syndicate_shuttle/board as anything in GLOB.syndicate_shuttle_boards)
		if(board.challenge_start_time)
			tgui_alert(usr, LANG("obj.28fee420fda57407", null), LANG("obj.2584dda68d57539f", null))
			return

	war_was_declared(memo = war_declaration)

/obj/item/nuclear_challenge/proc/war_was_declared(mob/living/user, memo)
	priority_announce(
		text = memo,
		title = "Declaration of War",
		sound = announcement_sound,
		has_important_message = TRUE,
		sender_override = "Nuclear Operative Outpost",
		color_override = "red",
	)
	if(user)
		to_chat(user, LANG("obj.1d46f75b5cd833e9", null))

	distribute_tc()
	CONFIG_SET(number/shuttle_refuel_delay, max(CONFIG_GET(number/shuttle_refuel_delay), CHALLENGE_SHUTTLE_DELAY))
	SSblackbox.record_feedback("amount", "nuclear_challenge_mode", 1)

	for(var/obj/item/circuitboard/computer/syndicate_shuttle/board as anything in GLOB.syndicate_shuttle_boards)
		board.challenge_start_time = world.time

	for(var/obj/machinery/computer/camera_advanced/shuttle_docker/dock as anything in GLOB.jam_on_wardec)
		dock.jammed = TRUE

	var/datum/techweb/station_techweb = locate(/datum/techweb/science) in SSresearch.techwebs
	if(station_techweb)
		var/obj/machinery/announcement_system/announcement_system = get_announcement_system(null, null, list(RADIO_CHANNEL_SCIENCE))
		if (!isnull(announcement_system))
			announcement_system.broadcast("Additional research data received from Nanotrasen R&D Division following the emergency protocol.", list(RADIO_CHANNEL_SCIENCE), TRUE)
		station_techweb.adjust_points(TECHWEB_POINT_TYPE_GENERIC, TECHWEB_TIER_5_POINTS * 3)

	qdel(src)

/obj/item/nuclear_challenge/proc/distribute_tc()
	var/list/orphans = list()
	var/list/uplinks = list()

	for (var/datum/mind/M in get_antag_minds(/datum/antagonist/nukeop))
		if (iscyborg(M.current))
			continue
		var/datum/component/uplink/uplink = M.find_syndicate_uplink()
		if (!uplink)
			orphans += M.current
			continue
		uplinks += uplink

	var/tc_to_distribute = CHALLENGE_TELECRYSTALS
	var/tc_per_nukie = round(tc_to_distribute / (length(orphans)+length(uplinks)))

	for (var/datum/component/uplink/uplink in uplinks)
		uplink.uplink_handler.add_telecrystals(tc_per_nukie)
		tc_to_distribute -= tc_per_nukie

	for (var/mob/living/L in orphans)
		var/TC = new /obj/item/stack/telecrystal(L.drop_location(), tc_per_nukie)
		to_chat(L, span_warning(LANG("obj.8594b184e069e934", list(L.put_in_hands(TC) ? "hands" : "feet"))))
		tc_to_distribute -= tc_per_nukie

	if (tc_to_distribute > 0) // What shall we do with the remainder...
		for (var/mob/living/basic/carp/pet/cayenne/C in GLOB.mob_living_list)
			if (C.stat != DEAD)
				var/obj/item/stack/telecrystal/TC = new(C.drop_location(), tc_to_distribute)
				TC.throw_at(get_step(C, C.dir), 3, 3)
				C.visible_message(span_notice(LANG("obj.82db1b3a12e2b575", list(C))),span_notice(LANG("obj.5423e3ac017c8f94", null)))
				break


/obj/item/nuclear_challenge/proc/check_allowed(mob/living/user)
	if(declaring_war)
		to_chat(user, span_boldwarning(LANG("obj.53c7d9f09743b618", null)))
		return FALSE
	if(GLOB.player_list.len < CHALLENGE_MIN_PLAYERS)
		to_chat(user, span_boldwarning(LANG("obj.44bcf291454c6d31", null)))
		return FALSE
	if(!user.onSyndieBase())
		to_chat(user, span_boldwarning(LANG("obj.5e4cc21758638d58", null)))
		return FALSE
	if(world.time - SSticker.round_start_time > CHALLENGE_TIME_LIMIT)
		to_chat(user, span_boldwarning(LANG("obj.87733400f3daa157", null)))
		return FALSE
	for(var/obj/item/circuitboard/computer/syndicate_shuttle/board as anything in GLOB.syndicate_shuttle_boards)
		if(board.moved)
			to_chat(user, span_boldwarning(LANG("obj.a331c45a770fcdd4", null)))
			return FALSE
		if(board.challenge_start_time)
			to_chat(user, span_boldwarning(LANG("obj.28fee420fda57407", null)))
			return FALSE
	return TRUE

/obj/item/nuclear_challenge/clownops
	uplink_type = /obj/item/uplink/clownop
	announcement_sound = 'sound/announcer/alarm/clownops.ogg'

/// Subtype that does nothing but plays the war op message. Intended for debugging
/obj/item/nuclear_challenge/literally_just_does_the_message
	name = "\"Declaration of War\""
	desc = "It's a Syndicate Declaration of War thing-a-majig, but it only plays the loud sound and message. Nothing else."
	var/admin_only = TRUE

/obj/item/nuclear_challenge/literally_just_does_the_message/check_allowed(mob/living/user)
	if(admin_only && !check_rights_for(user.client, R_SPAWN|R_FUN|R_DEBUG))
		to_chat(user, span_hypnophrase(LANG("obj.714551c3e87ce9ef", null)))
		return FALSE

	return TRUE

/obj/item/nuclear_challenge/literally_just_does_the_message/war_was_declared(mob/living/user, memo)
#ifndef TESTING
	// Reminder for our friends the admins
	var/are_you_sure = tgui_alert(user, LANG("obj.177bb8fdc102869f", null), LANG("obj.38bd13eca3dcc0b8", null), list("I'm sure", "You're right"))
	if(are_you_sure != "I'm sure")
		return
#endif

	priority_announce(
		text = memo,
		title = "Declaration of War",
		sound = announcement_sound,
		has_important_message = TRUE,
		sender_override = "Nuclear Operative Outpost",
		color_override = "red",
	)

/obj/item/nuclear_challenge/literally_just_does_the_message/distribute_tc()
	return

#undef CHALLENGE_TELECRYSTALS
#undef CHALLENGE_TIME_LIMIT
#undef CHALLENGE_SHUTTLE_DELAY
