/datum/religion_rites/holy_violin
	name = "思弦礼赞"
	desc = "创造一把能够分析其演奏乐曲的圣洁小提琴。"
	ritual_length = 6 SECONDS
	ritual_invocations = list("A servant of jubilee is needed ...")
	invoke_msg = "... A great mind for musical matters!"
	favor_cost = 20 //you only need one

/datum/religion_rites/holy_violin/invoke_effect(mob/living/user, atom/religious_tool)
	. = ..()
	var/turf/tool_turf = get_turf(religious_tool)
	var/obj/item/instrument/violin/fidis = new /obj/item/instrument/violin/festival(get_turf(religious_tool))
	fidis.visible_message(span_notice("[fidis] 出现了！"))
	playsound(tool_turf, 'sound/effects/pray.ogg', 50, TRUE)

/datum/religion_rites/portable_song_tuning
	name = "便携式乐曲调谐"
	desc = "强化祭坛上的乐器，使其可作为便携式祭坛用于调谐乐曲。在5次仪式后需要重新充能。"
	ritual_length = 6 SECONDS
	ritual_invocations = list("Allow me to bring your holy inspirations ...")
	invoke_msg = "... And send them with the winds my tunes ride with!"
	favor_cost = 10
	///instrument to empower
	var/obj/item/instrument/instrument_target

/datum/religion_rites/portable_song_tuning/perform_rite(mob/living/user, atom/religious_tool)
	for(var/obj/item/instrument/could_empower in get_turf(religious_tool))
		instrument_target = could_empower
		return ..()
	to_chat(user, span_warning("你需要将一件乐器放在 [religious_tool] 上才能进行此仪式！"))
	return FALSE

/datum/religion_rites/portable_song_tuning/invoke_effect(mob/living/user, atom/movable/religious_tool)
	..()
	var/obj/item/instrument/empower_target = instrument_target
	var/turf/tool_turf = get_turf(religious_tool)
	instrument_target = null
	if(QDELETED(empower_target) || !(tool_turf == empower_target.loc)) //check if the instrument is still there
		to_chat(user, span_warning("你的目标离开了祭坛！"))
		return FALSE
	empower_target.visible_message(span_notice("[empower_target] 闪烁了片刻。"))
	playsound(tool_turf, 'sound/effects/pray.ogg', 50, TRUE)
	var/list/allowed_rites_from_bible = subtypesof(/datum/religion_rites/song_tuner)
	empower_target.AddComponent( \
		/datum/component/religious_tool, \
		operation_flags = RELIGION_TOOL_INVOKE, \
		force_catalyst_afterattack = FALSE, \
		after_sect_select_cb = null, \
		catalyst_type = /obj/item/book/bible, \
		charges = 5, \
		rite_types_allowlist = allowed_rites_from_bible, \
	)
	return TRUE

///prototype for rites that tune a song.
/datum/religion_rites/song_tuner
	name = "调声曲"
	desc = "这是一个雏形。"
	ritual_length = 10 SECONDS
	favor_cost = 10
	rite_flags = NONE
	///if repeats count as continuations instead of a song's end, TRUE
	var/repeats_okay = TRUE
	///personal message sent to the chaplain as feedback for their chosen song
	var/song_invocation_message = "beep borp you forgot to fill in a variable report to git hub"
	///visible message sent to indicate a song will have special properties
	var/song_start_message
	///particle effect of playing this tune
	var/particles_path = /particles/musical_notes
	///what the instrument will glow when playing
	var/glow_color = COLOR_BLACK

/datum/religion_rites/song_tuner/invoke_effect(mob/living/user, obj/structure/altar/of_gods/altar)
	. = ..()
	to_chat(user, span_notice(song_invocation_message))
	user.AddComponent(/datum/component/smooth_tunes, src, repeats_okay, particles_path, glow_color)

/**
 * Song effect applied when the performer starts playing.
 *
 * Arguments:
 * * performer - A human starting the song
 * * song_source - parent of the smooth_tunes component. This is limited to the compatible items of said component, which currently includes mobs and objects so we'll have to type appropriately.
 */
/datum/religion_rites/song_tuner/proc/performer_start_effect(mob/living/carbon/human/performer, atom/song_source)
	return

/**
 * Perform the song effect.
 *
 * Arguments:
 * * listener - A mob, listening to the song
 * * song_source - parent of the smooth_tunes component. This is limited to the compatible items of said component, which currently includes mobs and objects so we'll have to type appropriately.
 */
/datum/religion_rites/song_tuner/proc/song_effect(mob/living/carbon/human/listener, atom/song_source)
	return

/**
 * When the song is long enough, it will have a special effect when it ends.
 *
 * If you want something that ALWAYS goes off regardless of song length, affix it to the Destroy proc. The rite is destroyed when smooth tunes is done.
 *
 * Arguments:
 * * listener - A mob, listening to the song
 * * song_source - parent of the smooth_tunes component. This is limited to the compatible items of said component, which currently includes mobs and objects so we'll have to type appropriately.
 */
/datum/religion_rites/song_tuner/proc/finish_effect(mob/living/carbon/human/listener, atom/song_source)
	return

/datum/religion_rites/song_tuner/evangelism
	name = "福音赞美诗"
	desc = "传播你神明的教义，会让每一位非宗教信徒对你心生好感。在歌曲结束时，你会为所有听众祈福，从而改善他们的心情。"
	particles_path = /particles/musical_notes/holy
	song_invocation_message = "You've prepared a holy song!"
	song_start_message = span_notice("这音乐听起来受到了祝福！")
	glow_color = "#FEFFE0"
	favor_cost = 0

/datum/religion_rites/song_tuner/evangelism/song_effect(mob/living/carbon/human/listener, atom/song_source)
	// A ckey requirement is good to have for gaining favor, to stop monkey farms and such.
	if(!GLOB.religious_sect || listener.mind?.holy_role || !listener.ckey)
		return
	GLOB.religious_sect.adjust_favor(0.2)

/datum/religion_rites/song_tuner/evangelism/finish_effect(mob/living/carbon/human/listener, atom/song_source)
	listener.add_mood_event("blessing", /datum/mood_event/blessing)

/datum/religion_rites/song_tuner/light
	name = "辉光独奏"
	desc = "吟唱一首明亮的歌曲，照亮你周围的区域。在歌曲结束时，你将给予听众一些光照。"
	particles_path = /particles/musical_notes/light
	song_invocation_message = "You've prepared a bright song!"
	song_start_message = span_notice("这音乐简直在发光！")
	glow_color = "#fcff44"
	repeats_okay = FALSE
	favor_cost = 0
	/// lighting object that makes chaplain glow
	var/obj/effect/dummy/lighting_obj/moblight/performer_light_obj

/datum/religion_rites/song_tuner/light/performer_start_effect(mob/living/carbon/human/performer, atom/song_source)
	performer_light_obj = performer.mob_light(8, 1.5, color = LIGHT_COLOR_DIM_YELLOW)

/datum/religion_rites/song_tuner/light/Destroy()
	QDEL_NULL(performer_light_obj)
	return ..()

/datum/religion_rites/song_tuner/light/finish_effect(mob/living/carbon/human/listener, atom/song_source)
	listener.apply_status_effect(/datum/status_effect/song/light)

/datum/religion_rites/song_tuner/nullwave
	name = "零波颤音"
	desc = "唱一首单调的歌，保护那些聆听者免受魔法的侵扰。"
	particles_path = /particles/musical_notes/nullwave
	song_invocation_message = "You've prepared an antimagic song!"
	song_start_message = span_nicegreen("这音乐让你感到被保护！")
	glow_color = "#a9a9b8"
	repeats_okay = FALSE

/datum/religion_rites/song_tuner/nullwave/song_effect(mob/living/carbon/human/listener, atom/song_source)
	listener.apply_status_effect(/datum/status_effect/song/antimagic)

/datum/religion_rites/song_tuner/pain
	name = "凶残的和弦"
	desc = "唱出刺耳的歌，刺痛周围的人。对其他牧师效果不佳。在歌曲结束时，你会让所有听众的伤口裂开。"
	particles_path = /particles/musical_notes/harm
	song_invocation_message = "You've prepared a painful song!"
	song_start_message = span_danger("这音乐像刀子一样锋利！")
	glow_color = "#FF4460"
	repeats_okay = FALSE

/datum/religion_rites/song_tuner/pain/song_effect(mob/living/carbon/human/listener, atom/song_source)
	var/damage_dealt = 1
	if(listener.mind?.holy_role)
		damage_dealt *= 0.5

	listener.adjust_brute_loss(damage_dealt)

/datum/religion_rites/song_tuner/pain/finish_effect(mob/living/carbon/human/listener, atom/song_source)
	var/obj/item/bodypart/sliced_limb = pick(listener.get_bodyparts())
	sliced_limb.force_wound_upwards(/datum/wound/slash/flesh/moderate/many_cuts)

/datum/religion_rites/song_tuner/lullaby
	name = "心灵摇篮曲"
	desc = "唱一首摇篮曲，让周围的人感到疲惫，使他们变得安静下来。在歌曲结束时，你就能让那些疲惫到足以入睡的人进入梦乡。"
	particles_path = /particles/musical_notes/sleepy
	song_invocation_message = "You've prepared a sleepy song!"
	song_start_message = span_warning("这音乐让你感到昏昏欲睡...")
	favor_cost = 40 //actually really strong
	glow_color = "#83F6FF"
	repeats_okay = FALSE
	///assoc list of weakrefs to who heard the song, for the finishing effect to look at.
	var/list/listener_counter = list()

/datum/religion_rites/song_tuner/lullaby/Destroy()
	listener_counter.Cut()
	return ..()

/datum/religion_rites/song_tuner/lullaby/song_effect(mob/living/carbon/human/listener, atom/song_source)
	if(listener.mind?.holy_role)
		return

	var/static/list/sleepy_messages = list(
		"The music is putting you to sleep...",
		"The music makes you nod off for a moment.",
		"You try to focus on staying awake through the song.",
	)

	if(prob(20))
		to_chat(listener, span_warning(pick(sleepy_messages)))
		listener.emote("yawn")
	listener.set_eye_blur_if_lower(4 SECONDS)

/datum/religion_rites/song_tuner/lullaby/finish_effect(mob/living/carbon/human/listener, atom/song_source)
	to_chat(listener, span_danger("哇，那首歌的结尾真是...太美了..."))
	listener.AdjustSleeping(5 SECONDS)
