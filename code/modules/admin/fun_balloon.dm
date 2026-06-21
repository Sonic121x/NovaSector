/obj/effect/fun_balloon
	name = "趣味气球"
	desc = "这将会是一场爆笑狂欢。"
	icon = 'icons/obj/toys/balloons.dmi'
	icon_state = "syndballoon"
	anchored = TRUE
	var/popped = FALSE
	var/pop_sound_effect = 'sound/items/party_horn.ogg'

/obj/effect/fun_balloon/Initialize(mapload)
	. = ..()
	SSobj.processing |= src

/obj/effect/fun_balloon/Destroy()
	SSobj.processing -= src
	. = ..()

/obj/effect/fun_balloon/process()
	if(!popped && check() && !QDELETED(src))
		popped = TRUE
		effect()
		pop()

/obj/effect/fun_balloon/proc/check()
	return FALSE

/obj/effect/fun_balloon/proc/effect()
	return

/obj/effect/fun_balloon/proc/pop()
	visible_message(span_notice("[src] 爆了！"))
	playsound(get_turf(src), pop_sound_effect, 50, TRUE, -1)
	qdel(src)

// ----------- Sentience Balloon
/obj/effect/fun_balloon/sentience
	name = "sentience fun balloon-自感知召唤气球"
	desc = "当这个气球爆开时，周围的东西会变得更有意识。"
	var/group_name = "a bunch of giant spiders"
	var/effect_range = 3
	var/antag_type = null
	var/make_antag = FALSE

/obj/effect/fun_balloon/sentience/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SentienceFunBalloon", name)
		ui.open()

/obj/effect/fun_balloon/sentience/ui_data(mob/user)
	var/list/data = list()
	data["group_name"] = group_name
	data["range"] = effect_range
	data["antag"] = make_antag
	return data

/obj/effect/fun_balloon/sentience/ui_state(mob/user)
	return ADMIN_STATE(R_ADMIN)

/obj/effect/fun_balloon/sentience/ui_status(mob/user, datum/ui_state/state)
	if(popped)
		return UI_CLOSE
	if(isAdminObserver(user)) // ignore proximity if we're an admin
		return UI_INTERACTIVE
	return ..()

/obj/effect/fun_balloon/sentience/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("group_name")
			group_name = params["updated_name"]

		if("effect_range")
			effect_range = params["updated_range"]

		if("select_antag")
			var/list/paths = subtypesof(/datum/antagonist)
			antag_type = input(usr,"选择反派", "反派选择") as null|anything in sort_list(paths)
			make_antag = TRUE

		if("pop")
			if(!popped)
				popped = TRUE
				effect()
				pop()

	return TRUE

/obj/effect/fun_balloon/sentience/effect()
	var/list/bodies = list()
	for(var/mob/living/possessable in range(effect_range, get_turf(src)))
		if (!possessable.ckey && possessable.stat == CONSCIOUS) // Only assign ghosts to living, non-occupied mobs!
			bodies += possessable

	var/list/candidates = SSpolling.poll_ghosts_for_targets(
		question = "你愿意成为[span_notice(group_name)]吗？",
		role = ROLE_SENTIENCE,
		check_jobban = ROLE_SENTIENCE,
		poll_time = 10 SECONDS,
		checked_targets = bodies,
		ignore_category = POLL_IGNORE_SHUTTLE_DENIZENS,
		alert_pic = src,
		role_name_text = "sentience fun balloon",
	)

	while(LAZYLEN(candidates) && LAZYLEN(bodies))
		var/mob/dead/observer/C = pick_n_take(candidates)
		var/mob/living/body = pick_n_take(bodies)

		message_admins("[key_name_admin(C)] has taken control of ([key_name_admin(body)])")
		body.ghostize(FALSE)
		body.PossessByPlayer(C.key)
		if (make_antag)
			body.mind.add_antag_datum(antag_type)
			continue
		new /obj/effect/temp_visual/gravpush(get_turf(body))

// ----------- Emergency Shuttle Balloon
/obj/effect/fun_balloon/sentience/emergency_shuttle
	name = "穿梭机意识趣味气球"
	var/trigger_time = 60

/obj/effect/fun_balloon/sentience/emergency_shuttle/check()
	. = FALSE
	if(SSshuttle.emergency && (SSshuttle.emergency.timeLeft() <= trigger_time) && (SSshuttle.emergency.mode == SHUTTLE_CALL))
		. = TRUE

// ----------- Scatter Balloon
/obj/effect/fun_balloon/scatter
	name = "散射趣味气球"
	desc = "当这个气球爆开时，你就不会待在这里了。"
	var/effect_range = 5

/obj/effect/fun_balloon/scatter/effect()
	for(var/mob/living/dispersed_mob in range(effect_range, get_turf(src)))
		var/turf/drop_off = find_safe_turf(z)
		new /obj/effect/temp_visual/gravpush(get_turf(dispersed_mob))
		dispersed_mob.forceMove(drop_off)
		dispersed_mob.balloon_alert(dispersed_mob, "砰！")

// ----------- Station Crash
// Can't think of anywhere better to put it right now
/obj/effect/station_crash
	name = "空间站事故"
	desc = "没有幸存者！"
	icon = 'icons/obj/toys/balloons.dmi'
	icon_state = "syndballoon"
	anchored = TRUE
	var/min_crash_strength = 3
	var/max_crash_strength = 15

/obj/effect/station_crash/Initialize(mapload)
	..()
	shuttle_crash()
	return INITIALIZE_HINT_QDEL

/obj/effect/station_crash/proc/shuttle_crash()
	var/crash_strength = rand(min_crash_strength,max_crash_strength)
	for (var/S in SSshuttle.stationary_docking_ports)
		var/obj/docking_port/stationary/SM = S
		if (SM.shuttle_id == "emergency_home")
			var/new_dir = REVERSE_DIR(SM.dir)
			SM.forceMove(get_ranged_target_turf(SM, new_dir, crash_strength))
			break

/obj/effect/station_crash/devastating
	name = "毁灭性空间站事故"
	desc = "绝对毁灭，将把穿梭机撞到空间站深处"
	min_crash_strength = 15
	max_crash_strength = 25
