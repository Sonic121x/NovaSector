/obj/item/pinpointer/nuke
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	var/mode = TRACK_NUKE_DISK

/obj/item/pinpointer/nuke/examine(mob/user)
	. = ..()
	var/msg = "Its tracking indicator reads "
	switch(mode)
		if(TRACK_NUKE_DISK)
			msg += "\"nuclear_disk\"."
		if(TRACK_MALF_AI)
			msg += "\"01000001 01001001\"."
		if(TRACK_INFILTRATOR)
			msg += "\"vasvygengbefuvc\"."
		/// NOVA EDIT BEGIN
		if(TRACK_GOLDENEYE)
			msg += "\"goldeneye_key\"."
		/// NOVA EDIT END
		else
			msg = "Its tracking indicator is blank."
	. += msg
	for(var/obj/machinery/nuclearbomb/bomb as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/nuclearbomb))
		if(bomb.timing)
			. += "Extreme danger. Arming signal detected. Time remaining: [bomb.get_time_left()]."

/obj/item/pinpointer/nuke/process(seconds_per_tick)
	..()
	if(!active || alert)
		return
	for(var/obj/machinery/nuclearbomb/bomb as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/nuclearbomb))
		if(!bomb.timing)
			continue
		alert = TRUE
		playsound(src, 'sound/items/nuke_toy_lowpower.ogg', 50, FALSE)
		if(isliving(loc))
			var/mob/living/alerted_holder = loc
			to_chat(alerted_holder, span_userdanger("你的[name]振动并发出不祥的警报。哦，不妙。"))
		return

/obj/item/pinpointer/nuke/scan_for_target()
	target = null
	switch(mode)
		if(TRACK_NUKE_DISK)
			var/obj/item/disk/nuclear/N = locate() in SSpoints_of_interest.real_nuclear_disks
			target = N
		if(TRACK_MALF_AI)
			for(var/V in GLOB.ai_list)
				var/mob/living/silicon/ai/A = V
				if(A.nuking)
					if(A.linked_core)
						target = A.linked_core
					else
						target = A
			for(var/obj/machinery/power/apc/apc as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/power/apc))
				if(apc.malfhack && apc.occupier)
					target = apc
		if(TRACK_INFILTRATOR)
			target = SSshuttle.getShuttle("syndicate")
	..()

/obj/item/pinpointer/nuke/proc/switch_mode_to(new_mode)
	if(isliving(loc))
		var/mob/living/L = loc
		to_chat(L, span_userdanger("你的[name]在重新配置其追踪算法时发出哔哔声。"))
		playsound(L, 'sound/machines/beep/triple_beep.ogg', 50, TRUE)
	mode = new_mode
	scan_for_target()

/obj/item/pinpointer/nuke/syndicate // Syndicate pinpointers automatically point towards the infiltrator once the nuke is active.
	name = "辛迪加追踪器"
	desc = "一种手持追踪设备，可锁定特定信号。一旦检测到核装置的启动信号，它会自动切换追踪模式。"
	icon_state = "pinpointer_syndicate"
	worn_icon_state = "pinpointer_black"

/obj/item/pinpointer/syndicate_cyborg // Cyborg pinpointers just look for a random operative.
	name = "赛博辛迪加追踪器"
	desc = "一个集成的追踪装置，经过临时改造，用于搜寻活着的辛迪加成员。"
	flags_1 = NONE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF

/obj/item/pinpointer/syndicate_cyborg/cyborg_unequip(mob/user)
	if(!active)
		return
	toggle_on()

/obj/item/pinpointer/syndicate_cyborg/scan_for_target()
	target = null
	var/list/possible_targets = list()
	var/turf/here = get_turf(src)
	for(var/V in get_antag_minds(/datum/antagonist/nukeop))
		var/datum/mind/M = V
		if(ishuman(M.current) && M.current.stat != DEAD)
			possible_targets |= M.current
	var/mob/living/closest_operative = get_closest_atom(/mob/living/carbon/human, possible_targets, here)
	if(closest_operative)
		target = closest_operative
	..()
