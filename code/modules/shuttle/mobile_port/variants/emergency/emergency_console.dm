#define ENGINES_STARTED (SSshuttle.emergency.mode == SHUTTLE_IGNITING)
#define IS_DOCKED (SSshuttle.emergency.mode == SHUTTLE_DOCKED || (ENGINES_STARTED))
#define SHUTTLE_CONSOLE_ACTION_DELAY (5 SECONDS)
#define TIME_LEFT (SSshuttle.emergency.timeLeft())

/obj/machinery/computer/emergency_shuttle
	name = "紧急穿梭机控制台"
	desc = "用于穿梭机控制。"
	icon_screen = "shuttle"
	icon_keyboard = "tech_key"
	resistance_flags = INDESTRUCTIBLE
	var/auth_need = 3
	var/list/authorized = list()
	var/list/acted_recently = list()
	var/hijack_last_stage_increase = 0 SECONDS
	var/hijack_stage_time = 5 SECONDS
	var/hijack_stage_cooldown = 5 SECONDS
	var/hijack_flight_time_increase = 30 SECONDS
	var/hijack_completion_flight_time_set = 10 SECONDS //How long in deciseconds to set shuttle's timer after hijack is done.
	var/hijack_hacking = FALSE
	var/hijack_announce = TRUE

/obj/machinery/computer/emergency_shuttle/Destroy()
	// Our fake IDs that the emag generated are just there for colour
	// They're not supposed to be accessible

	for(var/obj/item/card/id/ID in src)
		qdel(ID)
	if(authorized?.len)
		authorized.Cut()
	authorized = null

	. = ..()

/obj/machinery/computer/emergency_shuttle/examine(mob/user)
	. = ..()
	if(hijack_announce)
		. += span_danger("控制台上存在安保系统。任何未经授权的篡改都将触发紧急通告。")
	if(user?.mind?.get_hijack_speed())
		. += span_danger("按住Alt键点击此控制台以尝试劫持穿梭机。这需要多次尝试（当前进度：阶段 [SSshuttle.emergency.hijack_status]/[HIJACK_COMPLETED]）。")
		. += span_notice("重新编程穿梭机导航固件的一个阶段将花费你 [(hijack_stage_time * user.mind.get_hijack_speed()) / 10] 秒，并且每个阶段完成后控制台将自动锁定 [hijack_stage_cooldown/10] 秒。")
		if(hijack_announce)
			. += span_warning("考虑到自动通告，最好在尝试期间巩固你的位置以避免被打断。")

/obj/machinery/computer/emergency_shuttle/attackby(obj/item/I, mob/user,list/modifiers)
	if(isidcard(I))
		say("Please equip your ID card into your ID slot to authenticate.")
	. = ..()

/obj/machinery/computer/emergency_shuttle/ui_state(mob/user)
	return GLOB.human_adjacent_state

/obj/machinery/computer/emergency_shuttle/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "EmergencyShuttleConsole", name)
		ui.open()

/obj/machinery/computer/emergency_shuttle/ui_data(user)
	var/list/data = list()

	data["timer_str"] = SSshuttle.emergency.getTimerStr()
	data["engines_started"] = ENGINES_STARTED
	data["authorizations_remaining"] = max((auth_need - authorized.len), 0)
	var/list/A = list()
	for(var/i in authorized)
		var/obj/item/card/id/ID = i
		var/name = ID.registered_name
		var/job = ID.assignment

		if(obj_flags & EMAGGED)
			name = Gibberish(name)
			job = Gibberish(job)
		A += list(list("name" = name, "job" = job))
	data["authorizations"] = A

	data["enabled"] = (IS_DOCKED && !ENGINES_STARTED) && !(user in acted_recently)
	data["emagged"] = obj_flags & EMAGGED ? 1 : 0
	return data

/obj/machinery/computer/emergency_shuttle/ui_act(action, params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	if(ENGINES_STARTED) // past the point of no return
		return
	if(!IS_DOCKED) // shuttle computer only has uses when onstation
		return
	if(SSshuttle.emergency.mode == SHUTTLE_DISABLED) // admins have disabled the shuttle.
		return
	if(!isliving(usr))
		return

	var/area/my_area = get_area(src)
	if(!istype(my_area, /area/shuttle/escape))
		say("Error - Network connectivity: Console has lost connection to the shuttle.")
		return

	var/mob/living/user = usr
	. = FALSE

	var/obj/item/card/id/ID = user.get_idcard(TRUE)

	if(!ID)
		to_chat(user, span_warning("你没有ID卡。"))
		return .

	if(!(ACCESS_COMMAND in ID.access))
		to_chat(user, span_warning("你的ID卡访问权限等级不够高。"))
		return .

	if(user in acted_recently)
		return .

	var/old_len = length(authorized)
	addtimer(CALLBACK(src, PROC_REF(clear_recent_action), user), SHUTTLE_CONSOLE_ACTION_DELAY)

	switch(action)
		if("authorize")
			. = authorize(user)

		if("repeal")
			authorized -= ID

		if("abort")
			if(length(authorized))
				// Abort. The action for when heads are fighting over whether to launch early.
				authorized.Cut()
				. = TRUE

	var/new_len = length(authorized)
	if((old_len != new_len) && !ENGINES_STARTED)
		var/repeal = (new_len < old_len)
		var/remaining = max(0, auth_need - new_len)
		if(new_len && remaining)
			priority_announce(
				"还需要 [remaining] authorization\s 个授权才能提前发射穿梭机。",
				"紧急穿梭机状态",
				sound = 'sound/announcer/notice/notice1.ogg',
				type = ANNOUNCEMENT_TYPE_PRIORITY,
				has_important_message = TRUE,
				color_override = "red",
			)
		if(repeal)
			priority_announce(
				"提前发射授权已撤销，需要 [remaining] authorization\s 。",
				"紧急穿梭机状态",
				sound = 'sound/announcer/notice/notice2.ogg',
				type = ANNOUNCEMENT_TYPE_PRIORITY,
				color_override = "blue",
			)

	acted_recently += user
	SStgui.update_user_uis(user, src)
	return .

/obj/machinery/computer/emergency_shuttle/proc/authorize(mob/living/user, source)
	var/obj/item/card/id/ID = user.get_idcard(TRUE)

	if(ID in authorized)
		return FALSE
	for(var/i in authorized)
		var/obj/item/card/id/other = i
		if(other.registered_name == ID.registered_name)
			return FALSE // No using IDs with the same name

	authorized += ID

	message_admins("[ADMIN_LOOKUPFLW(user)] has authorized early shuttle launch")
	log_shuttle("[key_name(user)] has authorized early shuttle launch in [COORD(src)]")
	// Now check if we're on our way
	. = TRUE
	process(SSMACHINES_DT)

/obj/machinery/computer/emergency_shuttle/proc/clear_recent_action(mob/user)
	acted_recently -= user
	if (!QDELETED(user))
		SStgui.update_user_uis(user, src)

/obj/machinery/computer/emergency_shuttle/process()
	// Launch check is in process in case auth_need changes for some reason
	// probably external.
	. = FALSE
	if(!SSshuttle.emergency)
		return

	if(SSshuttle.emergency.mode == SHUTTLE_STRANDED)
		authorized.Cut()
		obj_flags &= ~(EMAGGED)

	if(ENGINES_STARTED || (!IS_DOCKED))
		return .

	// Check to see if we've reached criteria for early launch
	if((authorized.len >= auth_need) || (obj_flags & EMAGGED))
		// shuttle timers use 1/10th seconds internally
		SSshuttle.emergency.setTimer(ENGINE_START_TIME)
		var/system_error = obj_flags & EMAGGED ? "SYSTEM ERROR:" : null
		minor_announce("The emergency shuttle will launch in \
			[TIME_LEFT] seconds", system_error, alert=TRUE)
		. = TRUE

/obj/machinery/computer/emergency_shuttle/proc/increase_hijack_stage()
	var/obj/docking_port/mobile/emergency/shuttle = SSshuttle.emergency
	// Begin loading this early, prevents a delay when the shuttle goes to land
	INVOKE_ASYNC(SSmapping, TYPE_PROC_REF(/datum/controller/subsystem/mapping, lazy_load_template), LAZY_TEMPLATE_KEY_NUKIEBASE)

	shuttle.hijack_status++
	if(hijack_announce)
		announce_hijack_stage()
	hijack_last_stage_increase = world.time
	say("Navigational protocol error! Rebooting systems.")
	if(shuttle.mode == SHUTTLE_ESCAPE)
		if(shuttle.hijack_status == HIJACK_COMPLETED)
			shuttle.setTimer(hijack_completion_flight_time_set)
		else
			shuttle.setTimer(shuttle.timeLeft(1) + hijack_flight_time_increase) //give the guy more time to hijack if it's already in flight.
	return shuttle.hijack_status

/obj/machinery/computer/emergency_shuttle/click_alt(mob/living/user)
	if(!isliving(user))
		return NONE
	attempt_hijack_stage(user)
	return CLICK_ACTION_SUCCESS

/obj/machinery/computer/emergency_shuttle/proc/attempt_hijack_stage(mob/living/user)
	if(!IsReachableBy(user))
		return
	if(HAS_TRAIT(user, TRAIT_HANDS_BLOCKED))
		to_chat(user, span_warning("你需要腾出双手才能操作 [src]。"))
		return
	var/area/my_area = get_area(src)
	if(!istype(my_area, /area/shuttle/escape))
		say("Error - Network connectivity: Console has lost connection to the shuttle.")
		return
	if(!user?.mind?.get_hijack_speed())
		to_chat(user, span_warning("你成功在 [src] 上打开了一个用户模式shell，数百行调试输出从你眼前闪过。最好还是别碰这个。"))
		return
	if(!EMERGENCY_AT_LEAST_DOCKED) // prevent advancing hijack stages on BYOS shuttles until the shuttle has "docked"
		to_chat(user, span_warning("穿梭机的飞行计划尚未加载，你现在无法入侵。"))
		return
	if(hijack_hacking == TRUE)
		return
	if(SSshuttle.emergency.hijack_status >= HIJACK_COMPLETED)
		to_chat(user, span_warning("紧急穿梭机已经加载了损坏的导航数据。你还想对它做什么？"))
		return
	if(hijack_last_stage_increase >= world.time - hijack_stage_cooldown)
		say("Error - Catastrophic software error detected. Input is currently on timeout.")
		return
	hijack_hacking = TRUE
	to_chat(user, span_boldwarning("你 [SSshuttle.emergency.hijack_status == HIJACK_NOT_BEGUN? "begin" : "continue"] 覆盖 [src] 的导航协议。"))
	say("Software override initiated.")
	var/turf/console_hijack_turf = get_turf(src)
	message_admins("[src] is being overriden for hijack by [ADMIN_LOOKUPFLW(user)] in [ADMIN_VERBOSEJMP(console_hijack_turf)]")
	user.log_message("is hijacking [src].", LOG_GAME)
	. = FALSE
	if(do_after(user, hijack_stage_time * (1 / user.mind.get_hijack_speed()), target = src))
		increase_hijack_stage()
		console_hijack_turf = get_turf(src)
		message_admins("[ADMIN_LOOKUPFLW(user)] has hijacked [src] in [ADMIN_VERBOSEJMP(console_hijack_turf)].  Hijack stage increased to stage [SSshuttle.emergency.hijack_status] out of [HIJACK_COMPLETED].")
		user.log_message("has hijacked [src]. Hijack stage increased to stage [SSshuttle.emergency.hijack_status] out of [HIJACK_COMPLETED].", LOG_GAME)
		. = TRUE
		to_chat(user, span_notice("你重新编程了[src]的部分程序，使其进入[hijack_stage_cooldown/10]秒的冷却时间。"))
		visible_message(
			span_warning("[user.name]似乎在篡改[src]。"),
			blind_message = span_hear("你听到有人在敲击电脑键盘。"),
			vision_distance = COMBAT_MESSAGE_RANGE,
			ignored_mobs = user
		)
	hijack_hacking = FALSE

/obj/machinery/computer/emergency_shuttle/proc/announce_hijack_stage()
	var/msg
	switch(SSshuttle.emergency.hijack_status)
		if(HIJACK_NOT_BEGUN)
			return
		if(HIJACK_STAGE_1)
			msg = "AUTHENTICATING - FAIL. AUTHENTICATING - FAIL. AUTHENTICATING - FAI###### Welcome, technician JOHN DOE."
		if(HIJACK_STAGE_2)
			msg = "Warning: Navigational route fails \"IS_AUTHORIZED\". Please try againNN[scramble_message_replace_chars("againagainagainagainagain", 70)]."
		if(HIJACK_STAGE_3)
			msg = "CRC mismatch at ~h~ in calculated route buffer. Full reset initiated of FTL_NAVIGATION_SERVICES. Memory decrypted for automatic repair."
		if(HIJACK_STAGE_4)
			msg = "~ACS_directive module_load(cyberdyne.exploit.nanotrasen.shuttlenav)... NT key mismatch. Confirm load? Y...###Reboot complete. $SET transponder_state = 0; System link initiated with connected engines..."
		if(HIJACK_COMPLETED)
			msg = "SYSTEM OVERRIDE - Resetting course to \[[scramble_message_replace_chars("###########", 100)]\] \
			([scramble_message_replace_chars("#######", 100)]/[scramble_message_replace_chars("#######", 100)]/[scramble_message_replace_chars("#######", 100)]) \
			{AUTH - ROOT (uid: 0)}.</font>\
			[SSshuttle.emergency.mode == SHUTTLE_ESCAPE ? "Diverting from existing route - Bluespace exit in \
			[hijack_completion_flight_time_set >= INFINITY ? "[scramble_message_replace_chars("\[ERROR\]")]" : hijack_completion_flight_time_set/10] seconds." : ""]"
	minor_announce(scramble_message_replace_chars(msg, replaceprob = 10), "紧急穿梭机", TRUE)

/obj/machinery/computer/emergency_shuttle/emag_act(mob/user, obj/item/card/emag/emag_card)
	// How did you even get on the shuttle before it go to the station?
	if(!IS_DOCKED)
		return FALSE

	if((obj_flags & EMAGGED) || ENGINES_STARTED) //SYSTEM ERROR: THE SHUTTLE WILL LA-SYSTEM ERROR: THE SHUTTLE WILL LA-SYSTEM ERROR: THE SHUTTLE WILL LAUNCH IN 10 SECONDS
		balloon_alert(user, "穿梭机即将发射！")
		return FALSE

	var/time = TIME_LEFT
	if (user)
		message_admins("[ADMIN_LOOKUPFLW(user)] has emagged the emergency shuttle [time] seconds before launch.")
		log_shuttle("[key_name(user)] has emagged the emergency shuttle in [COORD(src)] [time] seconds before launch.")
	else
		message_admins("The emergency shuttle was emagged [time] seconds before launch, with no emagger.")
		log_shuttle("The emergency shuttle was emagged in [COORD(src)] [time] seconds before launch, with no emagger.")

	obj_flags |= EMAGGED
	SSshuttle.emergency.movement_force = list("KNOCKDOWN" = 60, "THROW" = 20)//YOUR PUNY SEATBELTS can SAVE YOU NOW, MORTAL
	for(var/i in 1 to 10)
		// the shuttle system doesn't know who these people are, but they
		// must be important, surely
		var/obj/item/card/id/ID = new(src)
		var/datum/job/J = pick(SSjob.joinable_occupations)
		ID.registered_name = generate_random_name_species_based(species_type = /datum/species/human)
		ID.assignment = J.title

		authorized += ID

	process(SSMACHINES_DT)
	return TRUE

#undef TIME_LEFT
#undef ENGINES_STARTED
#undef IS_DOCKED
#undef SHUTTLE_CONSOLE_ACTION_DELAY
