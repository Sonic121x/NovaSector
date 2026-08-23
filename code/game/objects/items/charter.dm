// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/item/station_charter
	name = "station charter"
	icon = 'icons/obj/scrolls.dmi'
	icon_state = "charter"
	desc = "An official document entrusting the governance of the station \
		and surrounding space to the Captain."
	var/used = FALSE
	var/name_type = "station"

	var/unlimited_uses = FALSE
	var/ignores_timeout = FALSE
	var/response_timer_id = null
	var/approval_time = 600

	var/static/regex/standard_station_regex

/obj/item/station_charter/Initialize(mapload)
	. = ..()
	if(!standard_station_regex)
		var/prefixes = jointext(GLOB.station_prefixes, "|")
		var/names = jointext(GLOB.station_names, "|")
		var/suffixes = jointext(GLOB.station_suffixes, "|")
		var/numerals = jointext(GLOB.station_numerals, "|")
		var/regexstr = "^(([prefixes]) )?(([names]) ?)([suffixes]) ([numerals])$"
		standard_station_regex = new(regexstr)

/obj/item/station_charter/attack_self(mob/living/user)
	if(used)
		to_chat(user, span_warning(LANG("obj.bcec3a875f3f0303", list(name_type))))
		return
	if(!ignores_timeout && (world.time-SSticker.round_start_time > STATION_RENAME_TIME_LIMIT)) //5 minutes
		to_chat(user, span_warning(LANG("obj.8a911e3fac3414e1", list(name_type))))
		return
	if(response_timer_id)
		to_chat(user, span_warning(LANG("obj.fce0590bf59dee5c", null)))
		return

	var/new_name = tgui_input_text(user, LANG("obj.698844488711cb11", list(station_name())), LANG("obj.5cf4ddebecbe3cde", null), max_length = MAX_CHARTER_LEN)

	if(response_timer_id)
		to_chat(user, span_warning(LANG("obj.fce0590bf59dee5c", null)))
		return

	if(!new_name)
		return
	user.log_message("has proposed to name the station as \
		[new_name]", LOG_GAME)

	if(standard_station_regex.Find(new_name))
		to_chat(user, span_notice(LANG("obj.bfdb4f7184b38b62", null)))
		rename_station(new_name, user.name, user.real_name, key_name(user))
		return

	to_chat(user, span_notice(LANG("obj.b25fd49cc25b039b", null)))
	// Autoapproves after a certain time
	response_timer_id = addtimer(CALLBACK(src, PROC_REF(rename_station), new_name, user.name, user.real_name, key_name(user)), approval_time, TIMER_STOPPABLE)
	to_chat(GLOB.admins,
		span_adminnotice(LANG("obj.15e6993076b61f37", list(ADMIN_LOOKUPFLW(user), name_type, new_name, DisplayTimeText(approval_time), ADMIN_SMITE(user), HrefToken(forceGlobal = TRUE), REF(src), ADMIN_CENTCOM_REPLY(user)))),
		type = MESSAGE_TYPE_PRAYER)
	for(var/client/admin_client in GLOB.admins)
		if(admin_client.prefs.toggles & SOUND_ADMINHELP)
			window_flash(admin_client, ignorepref = TRUE)
			SEND_SOUND(admin_client, sound('sound/effects/gong.ogg'))

/obj/item/station_charter/proc/reject_proposed(user)
	if(!user)
		return
	if(!response_timer_id)
		return
	var/turf/T = get_turf(src)
	T.visible_message(span_warning(LANG("obj.dd664e95d4dc4ca9", list(src))))
	var/m = "[key_name(user)] has rejected the proposed station name."

	message_admins(m)
	log_admin(m)

	deltimer(response_timer_id)
	response_timer_id = null

/obj/item/station_charter/proc/rename_station(designation, uname, ureal_name, ukey)
	set_station_name(designation)
	minor_announce(LANG("obj.c187b5eee2c52a48", list(ureal_name, html_decode(station_name()))), "Captain's Charter") //decode station_name to avoid minor_announce double encode
	log_game("[ukey] has renamed the station as [station_name()].")

	name = "station charter for [station_name()]"
	desc = LANG("obj.518d60ac966c526b", list(station_name(), uname))
	SSblackbox.record_feedback("text", "station_renames", 1, "[station_name()]")
	if(!unlimited_uses)
		used = TRUE

/obj/item/station_charter/admin
	unlimited_uses = TRUE
	ignores_timeout = TRUE


/obj/item/station_charter/banner
	name = "\improper Nanotrasen banner"
	icon = 'icons/obj/banner.dmi'
	name_type = "planet"
	icon_state = "banner"
	inhand_icon_state = "banner"
	lefthand_file = 'icons/mob/inhands/equipment/banners_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/banners_righthand.dmi'
	desc = "A cunning device used to claim ownership of celestial bodies."
	w_class = WEIGHT_CLASS_HUGE
	force = 15

/obj/item/station_charter/banner/rename_station(designation, uname, ureal_name, ukey)
	set_station_name(designation)
	minor_announce(LANG("obj.5802b2ea544d19b9", list(ureal_name, name_type, html_decode(station_name()))), "Captain's Banner") //decode station_name to avoid minor_announce double encode
	log_game("[ukey] has renamed the [name_type] as [station_name()].")
	name = "banner of [station_name()]"
	desc = LANG("obj.319f1819bf0e826f", list(station_name(), uname))
	SSblackbox.record_feedback("text", "station_renames", 1, "[station_name()]")
	if(!unlimited_uses)
		used = TRUE
