
/// Allows the AI to interact somewhat with a door if the requester can be tracked by cameras and the AI can normally access it.
/mob/living/silicon/proc/fulfill_door_request(mob/living/requester, obj/machinery/door/airlock/door, action)
	if(!istype(requester))
		return
	if(QDELETED(door))
		to_chat(src, span_warning(LANG("mob.e2f038f58b39d636", null)))
		return
	if(!istype(door))
		return

	if(!COOLDOWN_FINISHED(door, answer_cd))
		to_chat(src, span_warning(LANG("mob.3bc179f87582d09f", null)))
		return

	if(!requester.can_track(src))
		to_chat(src, span_notice(LANG("mob.40687e4161505c3e", null)))
		return
	if(!door.hasPower())
		to_chat(src, span_warning(LANG("mob.556a36e2f57296ae", null)))
		return
	if(!door.canAIControl())
		to_chat(src, span_notice(LANG("mob.9fde653ae0e12cca", null)))
		return
	if(door.obj_flags & EMAGGED)
		to_chat(src, LANG("mob.302a03098d90c9e5", null))
		return

	COOLDOWN_START(door, answer_cd, 10 SECONDS)

	switch(action)
		if("open")
			if(door.locked)
				door.unbolt()
			door.open()
			playsound(door, 'sound/machines/ping.ogg', 50, FALSE, SILENCED_SOUND_EXTRARANGE, ignore_walls = FALSE)
			to_chat(src, LANG("mob.ba6e08b6b44de91f", list(door, requester)))
			// Clear the per-(player, door) AI-request cooldown since the ask succeeded — they may need to ask again later.
			door.requesters -= "[requester.ckey]_[REF(door)]"
		if("bolt")
			if(!door.locked)
				door.bolt()
				door.visible_message(span_danger(LANG("mob.28973015bf0bf1b5", list(src))), vision_distance = COMBAT_MESSAGE_RANGE)
		if("shock")
			door.set_electrified(MACHINE_DEFAULT_ELECTRIFY_TIME)
			playsound(door, 'sound/machines/buzz/buzz-sigh.ogg', 25, FALSE, SILENCED_SOUND_EXTRARANGE, ignore_walls = FALSE)
			door.visible_message(span_notice(LANG("mob.8a364009c390d3e4", list(src))), vision_distance = COMBAT_MESSAGE_RANGE)
		if("deny")
			playsound(door, 'sound/machines/buzz/buzz-sigh.ogg', 25, FALSE, SILENCED_SOUND_EXTRARANGE, ignore_walls = FALSE)
			door.visible_message(span_notice(LANG("mob.a529f7fcfe0cb58e", list(src))), vision_distance = COMBAT_MESSAGE_RANGE)
			to_chat(src, LANG("mob.dd7cb86aa3f53d42", list(requester)))
