// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/item/taperecorder
	name = "universal recorder"
	desc = "A device that can record to cassette tapes, and play them. It automatically translates the content in playback."
	icon = 'icons/obj/devices/voice.dmi'
	icon_state = "taperecorder_empty"
	inhand_icon_state = "analyzer"
	worn_icon_state = "analyzer"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_BELT
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT * 0.6, /datum/material/glass=SMALL_MATERIAL_AMOUNT * 0.3)
	force = 2
	throwforce = 2
	speech_span = SPAN_TAPE_RECORDER
	drop_sound = 'sound/items/handling/taperecorder_drop.ogg'
	pickup_sound = 'sound/items/handling/taperecorder_pickup.ogg'
	var/recording = FALSE
	var/playing = FALSE
	var/playsleepseconds = 0
	var/obj/item/tape/mytape
	var/starting_tape_type = /obj/item/tape/random
	var/canprint = TRUE
	var/list/icons_available = list()
	var/radial_icon_file = 'icons/hud/radial_taperecorder.dmi'
	///Whether we've warned during this recording session that the tape is almost up.
	var/time_warned = FALSE
	///Seconds under which to warn that the tape is almost up.
	var/time_left_warning = 60 SECONDS
	///Sound loop that plays when recording or playing back.
	var/datum/looping_sound/tape_recorder_hiss/soundloop

/obj/item/taperecorder/Initialize(mapload)
	. = ..()
	if(starting_tape_type)
		mytape = new starting_tape_type(src)
	soundloop = new(src)
	update_appearance()

/obj/item/taperecorder/Destroy()
	QDEL_NULL(soundloop)
	QDEL_NULL(mytape)
	return ..()

/obj/item/taperecorder/proc/readout()
	if(mytape)
		if(playing)
			return span_notice("<b>PLAYING</b>")
		else
			var/time = mytape.used_capacity / 10 //deciseconds / 10 = seconds
			var/mins = round(time / 60)
			var/secs = time - mins * 60
			return span_notice("<b>[mins]</b>m <b>[secs]</b>s")
	return span_notice("<b>NO TAPE INSERTED</b>")

/obj/item/taperecorder/examine(mob/user)
	. = ..()
	if(in_range(src, user) || isobserver(user))
		. += span_notice(LANG("obj.0562892569c9324e", null))
		. += "[readout()]"

/obj/item/taperecorder/click_alt(mob/user)
	play()
	return CLICK_ACTION_SUCCESS

/obj/item/taperecorder/proc/update_available_icons()
	icons_available = list()

	if(!playing && !recording)
		icons_available += list("Record" = image(radial_icon_file,"record"))
		icons_available += list("Play" = image(radial_icon_file,"play"))
		if(canprint && mytape?.storedinfo.len)
			icons_available += list("Print Transcript" = image(radial_icon_file,"print"))

	if(playing || recording)
		icons_available += list("Stop" = image(radial_icon_file,"stop"))

	if(mytape)
		icons_available += list("Eject" = image(radial_icon_file,"eject"))

/obj/item/taperecorder/proc/update_sound()
	if(!playing && !recording)
		soundloop.stop()
	else
		soundloop.start()

/obj/item/taperecorder/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(mytape || !istype(tool, /obj/item/tape))
		return NONE
	if(!user.transferItemToLoc(tool,src))
		return ITEM_INTERACT_BLOCKING
	mytape = tool
	balloon_alert(user, LANG("obj.94d2a5ff4fc6b8fa", list(mytape)))
	playsound(src, 'sound/items/taperecorder/taperecorder_close.ogg', 50, FALSE)
	update_appearance()
	return ITEM_INTERACT_SUCCESS

/obj/item/taperecorder/proc/eject(mob/user)
	if(!mytape)
		balloon_alert(user, LANG("obj.d4c59c85c56aa6e9", null))
		return
	if(playing)
		balloon_alert(user, LANG("obj.8b5e941a2f9e9183", null))
		return
	playsound(src, 'sound/items/taperecorder/taperecorder_open.ogg', 50, FALSE)
	balloon_alert(user, LANG("obj.404ac9b2c4b42666", list(mytape)))
	stop()
	user.put_in_hands(mytape)
	mytape = null
	update_appearance()

/obj/item/taperecorder/fire_act(exposed_temperature, exposed_volume)
	mytape?.unspool() //Fires unspool the tape, which makes sense if you don't think about it
	return ..()

//ATTACK HAND IGNORING PARENT RETURN VALUE
/obj/item/taperecorder/attack_hand(mob/user, list/modifiers)
	if(loc != user || !mytape || !user.is_holding(src))
		return ..()
	eject(user)

/obj/item/taperecorder/proc/can_use(mob/user)
	if(user && ismob(user))
		if(!user.incapacitated)
			return TRUE
	return FALSE


GAME_VERB(/obj/item/taperecorder, ejectverb, "弹出磁带", null)

	if(!can_use(usr))
		balloon_alert(usr, LANG("obj.3d241116a24a25d2", null))
		return
	if(!mytape)
		balloon_alert(usr, LANG("obj.d4c59c85c56aa6e9", null))
		return
	eject(usr)


/obj/item/taperecorder/update_icon_state()
	if(!mytape)
		icon_state = "taperecorder_empty"
		return ..()
	if(recording)
		icon_state = "taperecorder_recording"
		return ..()
	if(playing)
		icon_state = "taperecorder_playing"
		return ..()
	icon_state = "taperecorder_idle"
	return ..()


/obj/item/taperecorder/Hear(atom/movable/speaker, message_langs, raw_message, radio_freq, radio_freq_name, radio_freq_color, spans, list/message_mods = list(), message_range)
	. = ..()
	if(message_mods[MODE_RELAY] || !mytape || istype(speaker, /obj/item/taperecorder))
		return

	mytape.timestamp += mytape.used_capacity
	mytape.storedinfo += "\[[time2text(mytape.used_capacity,"mm:ss", NO_TIMEZONE)]\] [speaker.get_voice()]: [raw_message]"


GAME_VERB(/obj/item/taperecorder, record, "开始录制", null)

	if(!can_use(usr))
		balloon_alert(usr, LANG("obj.3d241116a24a25d2", null))
		return
	if(!mytape || mytape.unspooled)
		balloon_alert(usr, LANG("obj.58df68bd36eef456", null))
		return
	if(recording)
		balloon_alert(usr, LANG("obj.b22e34af582ef324", null))
		return
	if(playing)
		balloon_alert(usr, LANG("obj.b4a2ae00c2f8b466", null))
		return

	playsound(src, 'sound/items/taperecorder/taperecorder_play.ogg', 50, FALSE)

	if(mytape.used_capacity < mytape.max_capacity)
		recording = TRUE
		become_hearing_sensitive()
		balloon_alert(usr, LANG("obj.d9efdbea374a6fd1", null))
		update_sound()
		update_appearance()
		var/used = mytape.used_capacity //to stop runtimes when you eject the tape
		var/max = mytape.max_capacity
		while(recording && used < max)
			mytape.used_capacity += 1 SECONDS
			used += 1 SECONDS
			if(max - used < time_left_warning && !time_warned)
				time_warned = TRUE
				balloon_alert(usr, LANG("obj.b3ce223c47004c3a", list((max - used) / 10)))
			sleep(1 SECONDS)
		if(used >= max)
			balloon_alert(usr, LANG("obj.a8f20a522c9f71af", null))
			sleep(1 SECONDS) //prevent balloon alerts layering over the top of each other
		stop()
	else
		balloon_alert(usr, LANG("obj.a8f20a522c9f71af", null))
		playsound(src, 'sound/items/taperecorder/taperecorder_stop.ogg', 50, FALSE)


GAME_VERB(/obj/item/taperecorder, stop, "停止", null)

	if(!can_use(usr))
		balloon_alert(usr, LANG("obj.3d241116a24a25d2", null))
		return

	if(recording)
		playsound(src, 'sound/items/taperecorder/taperecorder_stop.ogg', 50, FALSE)
		balloon_alert(usr, LANG("obj.c17a1f1932dc0659", null))
		recording = FALSE
		lose_hearing_sensitivity()
	else if(playing)
		playsound(src, 'sound/items/taperecorder/taperecorder_stop.ogg', 50, FALSE)
		balloon_alert(usr, LANG("obj.36c52e648afb19a9", null))
		playing = FALSE
	time_warned = FALSE
	update_appearance()
	update_sound()

GAME_VERB(/obj/item/taperecorder, play, "播放磁带", null)

	if(!can_use(usr))
		balloon_alert(usr, LANG("obj.3d241116a24a25d2", null))
		return
	if(!mytape || mytape.unspooled)
		balloon_alert(usr, LANG("obj.58df68bd36eef456", null))
		return
	if(recording)
		balloon_alert(usr, LANG("obj.b22e34af582ef324", null))
		return
	if(playing)
		balloon_alert(usr, LANG("obj.b4a2ae00c2f8b466", null))
		return
	if(mytape.storedinfo?.len <= 0)
		balloon_alert(usr, LANG("obj.02d482cc1aef0cef", list(mytape)))
		return

	playing = TRUE
	update_appearance()
	update_sound()
	balloon_alert(usr, LANG("obj.b7274291aaacfb99", null))
	playsound(src, 'sound/items/taperecorder/taperecorder_play.ogg', 50, FALSE)
	var/used = mytape.used_capacity //to stop runtimes when you eject the tape
	var/max = mytape.max_capacity
	for(var/i = 1, used <= max, sleep(playsleepseconds))
		if(!mytape)
			break
		if(playing == FALSE)
			break
		if(mytape.storedinfo.len < i)
			balloon_alert(usr, LANG("obj.1a8a7f3f058df9d5", null))
			stoplag(1 SECONDS) //prevents multiple balloon alerts covering each other
			break
		say("[mytape.storedinfo[i]]", sanitize=FALSE, message_mods = list(MODE_SEQUENTIAL = TRUE))//We want to display this properly, don't double encode
		if(mytape.storedinfo.len < i + 1)
			playsleepseconds = 1
			sleep(1 SECONDS)
		else
			playsleepseconds = max(mytape.timestamp[i + 1] - mytape.timestamp[i], 1 SECONDS)
		if(playsleepseconds > 14 SECONDS)
			sleep(1 SECONDS)
			say(LANG("obj.1052817509180ce6", list(playsleepseconds/10)), message_mods = list(MODE_SEQUENTIAL = TRUE))
			playsleepseconds = 1 SECONDS
		i++

	stop()


/obj/item/taperecorder/attack_self(mob/user)
	if(!mytape)
		balloon_alert(user, LANG("obj.76a90f7c0f5ea424", null))
		return

	update_available_icons()
	if(icons_available)
		var/selection = show_radial_menu(user, src, icons_available, radius = 38, require_near = TRUE, tooltips = TRUE)
		if(!selection)
			return
		switch(selection)
			if("Stop")
				stop()
			if("Record")
				record()
			if("Play")
				play()
			if("Print Transcript")
				print_transcript()
			if("Eject")
				eject(user)

GAME_VERB(/obj/item/taperecorder, print_transcript, "打印录音文字稿", null)

	var/list/transcribed_info = mytape.storedinfo
	if(!length(transcribed_info))
		balloon_alert(usr, LANG("obj.a6ff3edd0c0698ad", null))
		return
	if(!canprint)
		balloon_alert(usr, LANG("obj.5732f68fe513d211", null))
		return
	if(!can_use(usr))
		balloon_alert(usr, LANG("obj.3d241116a24a25d2", null))
		return
	if(!mytape || mytape.unspooled)
		balloon_alert(usr, LANG("obj.58df68bd36eef456", null))
		return
	if(recording)
		balloon_alert(usr, LANG("obj.b22e34af582ef324", null))
		return
	if(playing)
		balloon_alert(usr, LANG("obj.b4a2ae00c2f8b466", null))
		return

	var/transcribed_text = "<b>Transcript:</b><br><br>"
	var/page_count = 1

	var/tape_name = mytape.name
	var/initial_tape_name = initial(mytape.name)
	var/paper_name = "paper- '[tape_name == initial_tape_name ? "Tape" : "[tape_name]"] Transcript'"

	for(var/transcript_excerpt in transcribed_info)
		var/excerpt_length = length(transcript_excerpt)

		// Very unexpected. Better abort non-gracefully.
		if(excerpt_length > MAX_PAPER_LENGTH)
			balloon_alert(usr, LANG("obj.41081a75c2505237", null))
			CRASH("Transcript entry has more than [MAX_PAPER_LENGTH] chars: [excerpt_length] chars")

		// If we're going to overflow the paper's length, print the current transcribed text out first and reset to prevent us
		// going over the paper char count.
		if((length(transcribed_text) + excerpt_length) > MAX_PAPER_LENGTH)
			var/obj/item/paper/transcript_paper = new /obj/item/paper(get_turf(src))
			transcript_paper.add_raw_text(transcribed_text)
			transcript_paper.name = "[paper_name] page [page_count]"
			transcript_paper.update_appearance()
			transcribed_text = ""
			page_count++

		transcribed_text += "[transcript_excerpt]<br>"

	var/obj/item/paper/transcript_paper = new /obj/item/paper(get_turf(src))
	transcript_paper.add_raw_text(transcribed_text)
	transcript_paper.name = "[paper_name] page [page_count]"
	transcript_paper.update_appearance()

	balloon_alert(usr, LANG("obj.9ec8d7ff80210295", list(page_count)))
	playsound(src, 'sound/items/taperecorder/taperecorder_print.ogg', 50, FALSE)

	// Can't put the entire stack into their hands if there's multple pages, but hey we can at least put one page in.
	usr.put_in_hands(transcript_paper)
	canprint = FALSE
	addtimer(VARSET_CALLBACK(src, canprint, TRUE), 30 SECONDS)

//empty tape recorders
/obj/item/taperecorder/empty
	starting_tape_type = null

/obj/item/tape
	name = "tape"
	desc = "A magnetic tape that can hold up to ten minutes of content on either side."
	icon_state = "tape_white"
	icon = 'icons/obj/devices/circuitry_n_data.dmi'
	inhand_icon_state = "analyzer"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 0.2, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 0.2)
	force = 1
	throwforce = 0
	obj_flags = UNIQUE_RENAME //my mixtape
	drop_sound = 'sound/items/handling/tape_drop.ogg'
	pickup_sound = 'sound/items/handling/tape_pickup.ogg'
	///Because we can't expect God to do all the work.
	var/initial_icon_state
	var/max_capacity = 10 MINUTES
	var/used_capacity = 0 SECONDS
	///Numbered list of chat messages the recorder has heard with spans and prepended timestamps. Used for playback and transcription.
	var/list/storedinfo = list()
	///Numbered list of seconds the messages in the previous list appear at on the tape. Used by playback to get the timing right.
	var/list/timestamp = list()
	var/used_capacity_otherside = 0 SECONDS //Separate my side
	var/list/storedinfo_otherside = list()
	var/list/timestamp_otherside = list()
	var/unspooled = FALSE
	var/list/icons_available = list()
	var/radial_icon_file = 'icons/hud/radial_tape.dmi'

/obj/item/tape/Initialize(mapload)
	. = ..()
	initial_icon_state = icon_state //random tapes will set this after choosing their icon

	var/mycolor = random_short_color()
	name += " ([mycolor])" //multiple tapes can get confusing fast
	if(icon_state == "tape_greyscale")
		add_atom_colour("#[mycolor]", FIXED_COLOUR_PRIORITY)

	if(prob(50))
		tapeflip()

/obj/item/tape/examine(mob/user)
	. = ..()
	if(unspooled)
		. += span_notice(LANG("obj.79df9bd0d67f7a63", null))

/obj/item/tape/fire_act(exposed_temperature, exposed_volume)
	unspool()
	..()

/obj/item/tape/proc/update_available_icons()
	icons_available = list()

	if(!unspooled)
		icons_available += list("Unwind tape" = image(radial_icon_file,"tape_unwind"))
	icons_available += list("Flip tape" = image(radial_icon_file,"tape_flip"))

/obj/item/tape/attack_self(mob/user)
	update_available_icons()
	if(icons_available)
		var/selection = show_radial_menu(user, src, icons_available, radius = 38, require_near = TRUE, tooltips = TRUE)
		if(!selection)
			return
		switch(selection)
			if("Flip tape")
				if(loc != user)
					return
				tapeflip()
				balloon_alert(user, LANG("obj.2cfdfd3af26f27e3", null))
				playsound(src, 'sound/items/taperecorder/tape_flip.ogg', 70, FALSE)
			if("Unwind tape")
				if(loc != user)
					return
				unspool()
				balloon_alert(user, LANG("obj.d8137fec66ec06a2", null))

/obj/item/tape/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(prob(50))
		tapeflip()
	. = ..()

/obj/item/tape/proc/unspool()
	//Let's not add infinite amounts of overlays when our fire_act is called repeatedly
	if(!unspooled)
		add_overlay("ribbonoverlay")
	unspooled = TRUE

/obj/item/tape/proc/respool()
	cut_overlay("ribbonoverlay")
	unspooled = FALSE

/obj/item/tape/proc/tapeflip()
	//first we save a copy of our current side
	var/list/storedinfo_currentside = storedinfo.Copy()
	var/list/timestamp_currentside = timestamp.Copy()
	var/used_capacity_currentside = used_capacity
	//then we overwite our current side with our other side
	storedinfo = storedinfo_otherside.Copy()
	timestamp = timestamp_otherside.Copy()
	used_capacity = used_capacity_otherside
	//then we overwrite our other side with the saved side
	storedinfo_otherside = storedinfo_currentside.Copy()
	timestamp_otherside = timestamp_currentside.Copy()
	used_capacity_otherside = used_capacity_currentside

	if(icon_state == initial_icon_state)
		icon_state = "[initial_icon_state]_reverse"
	else if(icon_state == "[initial_icon_state]_reverse") //so flipping doesn't overwrite an unexpected icon_state (e.g. an admin's)
		icon_state = initial_icon_state

/obj/item/tape/screwdriver_act(mob/living/user, obj/item/tool)
	if(!unspooled)
		return FALSE
	balloon_alert(user, LANG("obj.c42b150860cc4902", null))
	if(!tool.use_tool(src, user, 12 SECONDS))
		balloon_alert(user, LANG("obj.98f1dd3269268b9d", null))
		return FALSE
	balloon_alert(user, LANG("obj.ef706919bf74e153", null))
	respool()

//Random colour tapes
/obj/item/tape/random
	icon_state = "random_tape"

/obj/item/tape/random/Initialize(mapload)
	icon_state = "tape_[pick("white", "blue", "red", "yellow", "purple", "greyscale")]"
	. = ..()

/obj/item/tape/dyed
	icon_state = "tape_greyscale"
