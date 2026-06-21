#define SOUND_EMITTER_LOCAL "local" //Plays the sound like a normal heard sound
#define SOUND_EMITTER_DIRECT "direct" //Plays the sound directly to hearers regardless of pressure/proximity/et cetera

#define SOUND_EMITTER_RADIUS "radius" //Plays the sound to everyone in a radius
#define SOUND_EMITTER_ZLEVEL "zlevel" //Plays the sound to everyone on the z-level
#define SOUND_EMITTER_GLOBAL "global" //Plays the sound to everyone in the game world

//Admin sound emitters with highly customizable functions!
/obj/effect/sound_emitter
	name = "发声器"
	desc = "发出声音，大概。"
	icon = 'icons/effects/effects.dmi'
	icon_state = "shield2"
	invisibility = INVISIBILITY_OBSERVER
	anchored = TRUE
	density = FALSE
	opacity = FALSE
	alpha = 175
	var/sound_file //The sound file the emitter plays
	var/sound_volume = 50 //The volume the sound file is played at
	var/play_radius = 3 //Any mobs within this many tiles will hear the sounds played if it's using the appropriate mode
	var/motus_operandi = SOUND_EMITTER_LOCAL //The mode this sound emitter is using
	var/emitter_range = SOUND_EMITTER_ZLEVEL //The range this emitter's sound is heard at; this isn't a number, but a string (see the defines above)

/obj/effect/sound_emitter/Destroy(force)
	if(!force)
		return QDEL_HINT_LETMELIVE
	. = ..()

/obj/effect/sound_emitter/singularity_act()
	return

/obj/effect/sound_emitter/singularity_pull(atom/singularity, current_size)
	return

/obj/effect/sound_emitter/examine(mob/user)
	. = ..()
	if(!isobserver(user))
		return
	. += "[span_boldnotice("Sound File:")] [sound_file ? sound_file : "None chosen"]"
	. += span_boldnotice("模式：</span> [motus_operandi]")
	. += span_boldnotice("范围：</span> [emitter_range]")
	. += "<b>Sound is playing at [sound_volume]% volume.</b>"
	if(user.client.holder)
		. += "<b>Alt-click it to quickly activate it!</b>"

//ATTACK GHOST IGNORING PARENT RETURN VALUE
/obj/effect/sound_emitter/attack_ghost(mob/user)
	if(!check_rights_for(user.client, R_SOUND))
		user.examinate(src)
		return
	edit_emitter(user)

/obj/effect/sound_emitter/click_alt(mob/user)
	if(!check_rights_for(user.client, R_SOUND))
		return CLICK_ACTION_BLOCKING

	activate(user)
	to_chat(user, span_notice("声音发射器已激活。"), confidential = TRUE)
	return CLICK_ACTION_SUCCESS

/obj/effect/sound_emitter/proc/edit_emitter(mob/user)
	var/dat = ""
	dat += "<b>Label:</b> <a href='byond://?src=[text_ref(src)];edit_label=1'>[maptext ? maptext : "No label set!"]</a><br>"
	dat += "<br>"
	dat += "<b>Sound File:</b> <a href='byond://?src=[text_ref(src)];edit_sound_file=1'>[sound_file ? sound_file : "No file chosen!"]</a><br>"
	dat += "<b>Volume:</b> <a href='byond://?src=[text_ref(src)];edit_volume=1'>[sound_volume]%</a><br>"
	dat += "<br>"
	dat += "<b>Mode:</b> <a href='byond://?src=[text_ref(src)];edit_mode=1'>[motus_operandi]</a><br>"
	if(motus_operandi != SOUND_EMITTER_LOCAL)
		dat += "<b>Range:</b> <a href='byond://?src=[text_ref(src)];edit_range=1'>[emitter_range]</a>[emitter_range == SOUND_EMITTER_RADIUS ? "<a href='byond://?src=[text_ref(src)];edit_radius=1'>[play_radius]-tile radius</a>" : ""]<br>"
	dat += "<br>"
	dat += "<a href='byond://?src=[text_ref(src)];play=1'>Play Sound</a> (interrupts other sound emitter sounds)"
	var/datum/browser/popup = new(user, "emitter", "", 500, 600)
	popup.set_content(dat)
	popup.open()

/obj/effect/sound_emitter/Topic(href, href_list)
	..()
	if(!ismob(usr) || !usr.client || !check_rights_for(usr.client, R_SOUND))
		return
	var/mob/user = usr
	if(href_list["edit_label"])
		var/new_label = tgui_input_text(user, "选择新标签", "发声器", max_length = MAX_NAME_LEN)
		if(!new_label)
			return
		maptext = MAPTEXT(new_label)
		to_chat(user, span_notice("标签已设置为[maptext]。"), confidential = TRUE)
	if(href_list["edit_sound_file"])
		var/new_file = input(user, "选择声音文件。", "发声器") as null|sound
		if(!new_file)
			return
		sound_file = new_file
		to_chat(user, span_notice("新声音文件已设置为[sound_file]。"), confidential = TRUE)
	if(href_list["edit_volume"])
		var/new_volume = tgui_input_number(user, "选择音量", "发声器", sound_volume, 100)
		if(!new_volume)
			return
		sound_volume = new_volume
		to_chat(user, span_notice("音量已设置为[sound_volume]%。"), confidential = TRUE)
	if(href_list["edit_mode"])
		var/new_mode
		var/mode_list = list("Local (normal sound)" = SOUND_EMITTER_LOCAL, "Direct (not affected by environment/location)" = SOUND_EMITTER_DIRECT)
		new_mode = tgui_input_list(user, "选择新模式", "发声器", mode_list)
		if(!new_mode)
			return
		motus_operandi = mode_list[new_mode]
		to_chat(user, span_notice("模式已设置为[motus_operandi]。"), confidential = TRUE)
	if(href_list["edit_range"])
		var/new_range
		var/range_list = list("Radius (all mobs within a radius)" = SOUND_EMITTER_RADIUS, "Z-Level (all mobs on the same z)" = SOUND_EMITTER_ZLEVEL, "Global (all players)" = SOUND_EMITTER_GLOBAL)
		new_range = tgui_input_list(user, "选择新范围", "发声器", range_list)
		if(!new_range)
			return
		emitter_range = range_list[new_range]
		to_chat(user, span_notice("范围已设置为 [emitter_range]。"), confidential = TRUE)
	if(href_list["edit_radius"])
		var/new_radius = tgui_input_number(user, "选择一个半径", "发声器", sound_volume, 127)
		if(!new_radius)
			return
		play_radius = new_radius
		to_chat(user, span_notice("可听半径已设置为 [play_radius]。"), confidential = TRUE)
	if(href_list["play"])
		activate(user)
	edit_emitter(user) //Refresh the UI to see our changes

/obj/effect/sound_emitter/proc/activate(mob/user)
	var/list/hearing_mobs = list()
	if(motus_operandi == SOUND_EMITTER_LOCAL)
		playsound(src, sound_file, sound_volume, FALSE)
		return
	switch(emitter_range)
		if(SOUND_EMITTER_RADIUS)
			for(var/mob/M in GLOB.player_list)
				if(get_dist(src, M) <= play_radius)
					hearing_mobs += M
		if(SOUND_EMITTER_ZLEVEL)
			for(var/mob/M in GLOB.player_list)
				if(M.z == z)
					hearing_mobs += M
		if(SOUND_EMITTER_GLOBAL)
			hearing_mobs = GLOB.player_list.Copy()
	for(var/mob/M in hearing_mobs)
		var/pref_volume = M.client.prefs.read_preference(/datum/preference/numeric/volume/sound_midi)
		if(pref_volume > 0)
			M.playsound_local(M, sound_file, (sound_volume * (pref_volume/100)), FALSE, channel = CHANNEL_ADMIN, pressure_affected = FALSE)
	if(user)
		log_admin("[ADMIN_LOOKUPFLW(user)] activated a sound emitter with file \"[sound_file]\" at [AREACOORD(src)]")
	flick("shield1", src)

#undef SOUND_EMITTER_LOCAL
#undef SOUND_EMITTER_DIRECT
#undef SOUND_EMITTER_RADIUS
#undef SOUND_EMITTER_ZLEVEL
#undef SOUND_EMITTER_GLOBAL
