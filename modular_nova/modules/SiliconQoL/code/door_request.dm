
/// Allows the AI to interact somewhat with a door if the requester can be tracked by cameras and the AI can normally access it.
/mob/living/silicon/proc/fulfill_door_request(mob/living/requester, obj/machinery/door/airlock/door, action)
	if(!istype(requester))
		return
	if(QDELETED(door))
		to_chat(src, span_warning("连接丢失！无法在网络中定位气闸门。"))
		return
	if(!istype(door))
		return

	if(!COOLDOWN_FINISHED(door, answer_cd))
		to_chat(src, span_warning("你的处理器仍在冷却中。"))
		return

	if(!requester.can_track(src))
		to_chat(src, span_notice("无法追踪请求者。"))
		return
	if(!door.hasPower())
		to_chat(src, span_warning("这个气闸门没有通电。"))
		return
	if(!door.canAIControl())
		to_chat(src, span_notice("无法访问气闸门。"))
		return
	if(door.obj_flags & EMAGGED)
		to_chat(src, "气闸门无响应。")
		return

	COOLDOWN_START(door, answer_cd, 10 SECONDS)

	switch(action)
		if("open")
			if(door.locked)
				door.unbolt()
			door.open()
			playsound(door, 'sound/machines/ping.ogg', 50, FALSE, SILENCED_SOUND_EXTRARANGE, ignore_walls = FALSE)
			to_chat(src, "<span class='notice'>You open the [door] for [requester].</span>")
			// Clear the per-(player, door) AI-request cooldown since the ask succeeded — they may need to ask again later.
			door.requesters -= "[requester.ckey]_[REF(door)]"
		if("bolt")
			if(!door.locked)
				door.bolt()
				door.visible_message(span_danger("哇，你真的把[src]惹毛了，他们当着你的面把门闩上了！"), vision_distance = COMBAT_MESSAGE_RANGE)
		if("shock")
			door.set_electrified(MACHINE_DEFAULT_ELECTRIFY_TIME)
			playsound(door, 'sound/machines/buzz/buzz-sigh.ogg', 25, FALSE, SILENCED_SOUND_EXTRARANGE, ignore_walls = FALSE)
			door.visible_message(span_notice("门发出嗡嗡的电流声，[src]已拒绝了你的请求！"), vision_distance = COMBAT_MESSAGE_RANGE)
		if("deny")
			playsound(door, 'sound/machines/buzz/buzz-sigh.ogg', 25, FALSE, SILENCED_SOUND_EXTRARANGE, ignore_walls = FALSE)
			door.visible_message(span_notice("门嗡嗡作响，[src]已拒绝了你的请求。"), vision_distance = COMBAT_MESSAGE_RANGE)
			to_chat(src, "你拒绝了[requester]的请求。")
