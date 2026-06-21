#define CANCEL_FAKE_ALERT -1

/datum/hallucination/station_message
	abstract_hallucination_parent = /datum/hallucination/station_message
	random_hallucination_weight = 1
	hallucination_tier = HALLUCINATION_TIER_RARE
	/// if TRUE, skip on deaf hallucinators
	var/require_hearing = TRUE

/datum/hallucination/station_message/start()
	if(require_hearing && HAS_TRAIT(hallucinator, TRAIT_DEAF))
		return FALSE
	if(do_fake_alert() == CANCEL_FAKE_ALERT)
		return FALSE

	qdel(src) // To be implemented by subtypes, call parent for easy cleanup
	return TRUE

/datum/hallucination/station_message/proc/do_fake_alert()
	return CANCEL_FAKE_ALERT

/datum/hallucination/station_message/blob_alert
	require_hearing = TRUE

/datum/hallucination/station_message/blob_alert/do_fake_alert()
	priority_announce("已确认在[station_name()]上爆发5级生物危害。所有人员必须控制疫情。", \
		"生物危害警报", ANNOUNCER_OUTBREAK5, players = list(hallucinator))

/datum/hallucination/station_message/shuttle_dock

/datum/hallucination/station_message/shuttle_dock/do_fake_alert()
	priority_announce(
		text = "[SSshuttle.emergency]已与空间站对接。你有[DisplayTimeText(SSshuttle.emergency_dock_time)]时间登上紧急穿梭机。",
		title = "紧急穿梭机抵达",
		sound = ANNOUNCER_SHUTTLEDOCK,
		sender_override = "紧急穿梭机上行链路警报",
		players = list(hallucinator),
		color_override = "orange",
	)

/datum/hallucination/station_message/malf_ai
	require_hearing = TRUE

/datum/hallucination/station_message/malf_ai/do_fake_alert()
	if(!(locate(/mob/living/silicon/ai) in GLOB.silicon_mobs))
		return CANCEL_FAKE_ALERT

	priority_announce("在所有空间站系统中检测到敌对运行时，请停用您的人工智能以防止其道德核心可能受损。", \
		"异常警报", ANNOUNCER_AIMALF, players = list(hallucinator))

/datum/hallucination/station_message/heretic
	require_hearing = TRUE
	/// This is gross and will probably easily be outdated in some time but c'est la vie.
	/// Maybe if someone datumizes heretic paths or something this can be improved
	var/static/list/ascension_bodies = list(
		list(
			"text" = "Fear the blaze, for the Ashlord, %FAKENAME% has ascended! The flames shall consume all!",
			"sound" = 'sound/music/antag/heretic/ascend_blade.ogg',
		),
		list(
			"text" = "Master of blades, the Torn Champion's disciple, %FAKENAME% has ascended! Their steel is that which will cut reality in a maelstom of silver!",
			"sound" = 'sound/music/antag/heretic/ascend_blade.ogg',
		),
		list(
			"text" = "Ever coiling vortex. Reality unfolded. ARMS OUTREACHED, THE LORD OF THE NIGHT, %FAKENAME% has ascended! Fear the ever twisting hand!",
			"sound" = 'sound/music/antag/heretic/ascend_flesh.ogg',
		),
		list(
			"text" = "Fear the decay, for the Rustbringer, %FAKENAME% has ascended! None shall escape the corrosion!",
			"sound" = 'sound/music/antag/heretic/ascend_rust.ogg',
		),
		list(
			"text" = "The nobleman of void %FAKENAME% has arrived, stepping along the Waltz that ends worlds!",
			"sound" = 'sound/music/antag/heretic/ascend_void.ogg',
		)
	)

/datum/hallucination/station_message/heretic/do_fake_alert()
	// Unfortunately, this will not be synced if mass hallucinated
	var/mob/living/carbon/human/totally_real_heretic = random_non_sec_crewmember()
	if(!totally_real_heretic)
		return CANCEL_FAKE_ALERT

	var/list/fake_ascension = pick(ascension_bodies)
	var/announcement_text = replacetext(fake_ascension["text"], "%FAKENAME%", totally_real_heretic.real_name)
	priority_announce(
		text = "[generate_heretic_text()] [announcement_text] [generate_heretic_text()]",
		title = "[generate_heretic_text()]",
		sound = fake_ascension["sound"],
		players = list(hallucinator),
		color_override = "pink",
	)

/datum/hallucination/station_message/cult_summon
	require_hearing = TRUE

/datum/hallucination/station_message/cult_summon/do_fake_alert()
	// Same, will not be synced if mass hallucinated
	var/mob/living/carbon/human/totally_real_cult_leader = random_non_sec_crewmember()
	if(!totally_real_cult_leader)
		return CANCEL_FAKE_ALERT

	// Get a fake area that the summoning is happening in
	var/area/hallucinator_area = get_area(hallucinator)
	var/area/fake_summon_area_type = pick(GLOB.the_station_areas - hallucinator_area.type)
	var/area/fake_summon_area = GLOB.areas_by_type[fake_summon_area_type]

	priority_announce(
		text = "来自远古邪神的幻影正被 [totally_real_cult_leader.real_name] 从未知维度召唤至 [fake_summon_area]。不惜一切代价阻止仪式！",
		title = "[command_name()] 高维事务部",
		sound = 'sound/music/antag/bloodcult/bloodcult_scribe.ogg',
		has_important_message = TRUE,
		players = list(hallucinator),
	)

/datum/hallucination/station_message/meteors
	random_hallucination_weight = 2
	require_hearing = TRUE

/datum/hallucination/station_message/meteors/do_fake_alert()
	priority_announce("检测到陨石正与空间站发生碰撞。", "陨石警报", ANNOUNCER_METEORS, players = list(hallucinator))

/datum/hallucination/station_message/supermatter_delam

/datum/hallucination/station_message/supermatter_delam/do_fake_alert()
	SEND_SOUND(hallucinator, 'sound/effects/magic/charge.ogg')
	to_chat(hallucinator, span_bolddanger("你感到现实扭曲了一瞬间……"))

/datum/hallucination/station_message/clock_cult_ark
	// Clock cult's long gone, but this stays for posterity.
	random_hallucination_weight = 0

/datum/hallucination/station_message/clock_cult_ark/start()
	hallucinator.playsound_local(hallucinator, 'sound/machines/clockcult/ark_deathrattle.ogg', 50, FALSE, pressure_affected = FALSE)
	hallucinator.playsound_local(hallucinator, 'sound/effects/clockcult_gateway_disrupted.ogg', 50, FALSE, pressure_affected = FALSE)
	addtimer(CALLBACK(src, PROC_REF(play_distant_explosion_sound)), 2.7 SECONDS)
	return TRUE // does not call parent to finish up the sound in a few seconds

/datum/hallucination/station_message/clock_cult_ark/proc/play_distant_explosion_sound()
	if(QDELETED(src))
		return

	hallucinator.playsound_local(get_turf(hallucinator), 'sound/effects/explosion/explosion_distant.ogg', 50, FALSE, pressure_affected = FALSE)
	qdel(src)

#undef CANCEL_FAKE_ALERT
