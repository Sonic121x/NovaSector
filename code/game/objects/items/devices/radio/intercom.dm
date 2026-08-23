// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/item/radio/intercom
	name = "station intercom"
	desc = "A trusty station intercom, ready to spring into action even when the headsets go silent."
	icon = 'icons/obj/machines/wallmounts.dmi' //NOVA EDIT - ICON OVERRIDDEN IN AESTHETICS MODULE
	icon_state = "intercom"
	anchored = TRUE
	w_class = WEIGHT_CLASS_BULKY
	canhear_range = 2
	dog_fashion = null
	unscrewed = FALSE
	item_flags = NO_BLOOD_ON_ITEM

	overlay_speaker_idle = "intercom_s"


	overlay_mic_idle = "intercom_m"
	overlay_mic_active = null

	///The icon of intercom while its turned off
	var/icon_off = "intercom-p"

/obj/item/radio/intercom/unscrewed
	unscrewed = TRUE

/obj/item/radio/intercom/prison
	name = "receive-only intercom"
	desc = "A station intercom. It looks like it has been modified to not broadcast."
	icon_state = "intercom_prison"
	icon_off = "intercom_prison-p"

/obj/item/radio/intercom/prison/Initialize(mapload)
	. = ..()
	wires?.cut(WIRE_TX)

/obj/item/radio/intercom/Initialize(mapload)
	. = ..()
	var/area/current_area = get_area(src)
	if(!current_area)
		return
	RegisterSignal(current_area, COMSIG_AREA_POWER_CHANGE, PROC_REF(AreaPowerCheck))
	if(mapload)
		find_and_mount_on_atom()
	GLOB.intercoms_list += src

/obj/item/radio/intercom/Destroy()
	GLOB.intercoms_list -= src
	return ..()

/obj/item/radio/intercom/examine(mob/user)
	. = ..()
	. += span_notice(LANG("obj.24e4bcd8daac331f", list(MODE_TOKEN_INTERCOM)))
	if(!unscrewed)
		. += span_notice(LANG("obj.2fc65237fe53e006", null))
	else
		. += span_notice(LANG("obj.43888722b99cffc3", null))

	if(anonymize)
		. += span_notice(LANG("obj.b67864687f6801c2", null))

	if(freqlock == RADIO_FREQENCY_UNLOCKED)
		if((obj_flags & EMAGGED) && initial(freqlock) == RADIO_FREQENCY_EMAGGABLE_LOCK)
			. += span_warning(LANG("obj.da1b7679c863e297", null))
	else
		. += span_notice(LANG("obj.5027c3ceec38dcc3", list(frequency/10)))

	if(keylock == RADIO_KEYSLOT_UNLOCKED)
		if((obj_flags & EMAGGED) && initial(keylock) == RADIO_KEYSLOT_EMAGGABLE_LOCK)
			. += span_warning(LANG("obj.50431995b26963da", null))
	else
		. += span_notice(LANG("obj.d32d45328d811bd3", list(keylock == RADIO_KEYSLOT_LOCKED ? "stripped" : "fastened tight", keylock == RADIO_KEYSLOT_LOCKED ? "" : " without some kind of magnet")))

/obj/item/radio/intercom/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()
	if(held_item?.tool_behaviour == TOOL_SCREWDRIVER)
		context[SCREENTIP_CONTEXT_RMB] = unscrewed ? "Secure to wall" : "Unscrew from wall"
		context[SCREENTIP_CONTEXT_LMB] = isnull(keyslot) ? context[SCREENTIP_CONTEXT_RMB] : "Remove encryption key" // sometimes same behavior
		. = CONTEXTUAL_SCREENTIP_SET

	if(held_item?.tool_behaviour == TOOL_WRENCH && unscrewed)
		context[SCREENTIP_CONTEXT_RMB] = "Detach from wall"
		context[SCREENTIP_CONTEXT_LMB] = context[SCREENTIP_CONTEXT_LMB] // same behavior
		. = CONTEXTUAL_SCREENTIP_SET

/obj/item/radio/intercom/screwdriver_act_secondary(mob/living/user, obj/item/tool)
	if(unscrewed)
		user.visible_message(span_notice(LANG("obj.d065917f814b1cc2", list(user, src))), span_notice(LANG("obj.3f00c4f61fbbb768", list(src))))
		if(tool.use_tool(src, user, 30, volume=50))
			user.visible_message(span_notice(LANG("obj.3065a8ec946ae90e", list(user, src))), span_notice(LANG("obj.023abbe21f5f66e2", list(src))))
			unscrewed = FALSE
			update_appearance(UPDATE_OVERLAYS)
	else
		user.visible_message(span_notice(LANG("obj.eff9ca5b18cc1588", list(user, src))), span_notice(LANG("obj.f4529b06f210d08d", list(src))))
		if(tool.use_tool(src, user, 40, volume=50))
			user.visible_message(span_notice(LANG("obj.b3c7a951f59ab0fe", list(user, src))), span_notice(LANG("obj.bb7969d37c266e78", list(src))))
			unscrewed = TRUE
			update_appearance(UPDATE_OVERLAYS)
	return ITEM_INTERACT_SUCCESS

/obj/item/radio/intercom/screwdriver_act(mob/living/user, obj/item/tool)
	if(isnull(keyslot))
		return screwdriver_act_secondary(user, tool)
	return ..()

/obj/item/radio/intercom/wrench_act(mob/living/user, obj/item/tool)
	if(!unscrewed)
		to_chat(user, span_warning(LANG("obj.9269e98a40f5a702", list(src))))
		return ITEM_INTERACT_BLOCKING
	user.visible_message(span_notice(LANG("obj.096bdf2beb6b1130", list(user, src))), span_notice(LANG("obj.08ee33726ba03b76", list(src))))
	tool.play_tool_sound(src)
	if(tool.use_tool(src, user, 80))
		user.visible_message(span_notice(LANG("obj.21675bf488693e22", list(user, src))), span_notice(LANG("obj.aa18b3fe3f2cb677", list(src))))
		playsound(src, 'sound/items/deconstruct.ogg', 50, TRUE)
		deconstruct(TRUE)
	return ITEM_INTERACT_SUCCESS

/obj/item/radio/intercom/wrench_act_secondary(mob/living/user, obj/item/tool)
	return wrench_act(user, tool)

/**
 * Override attack_tk_grab instead of attack_tk because we actually want attack_tk's
 * functionality. What we DON'T want is attack_tk_grab attempting to pick up the
 * intercom as if it was an ordinary item.
 */
/obj/item/radio/intercom/attack_tk_grab(mob/user)
	interact(user)
	return COMPONENT_CANCEL_ATTACK_CHAIN


/obj/item/radio/intercom/attack_ai(mob/user)
	interact(user)

/obj/item/radio/intercom/attack_robot(mob/user)
	interact(user)

/obj/item/radio/intercom/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	interact(user)

/obj/item/radio/intercom/ui_state(mob/user)
	return GLOB.default_state

/obj/item/radio/intercom/can_receive(freq, list/levels)
	if(levels != RADIO_NO_Z_LEVEL_RESTRICTION)
		var/turf/position = get_turf(src)
		if(isnull(position) || !(position.z in levels))
			return FALSE

	if(freq == FREQ_SYNDICATE)
		if(!(special_channels &= RADIO_SPECIAL_SYNDIE))
			return FALSE//Prevents broadcast of messages over devices lacking the encryption

	return TRUE

/obj/item/radio/intercom/Hear(atom/movable/speaker, message_langs, raw_message, radio_freq, radio_freq_name, radio_freq_color, list/spans, list/message_mods = list(), message_range)
	if(message_mods[RADIO_EXTENSION] == MODE_INTERCOM)
		return  // Avoid hearing the same thing twice
	return ..()

/obj/item/radio/intercom/emp_act(severity)
	. = ..() // Parent call here will set `on` to FALSE.
	update_appearance()

/obj/item/radio/intercom/end_emp_effect(curremp)
	. = ..()
	AreaPowerCheck() // Make sure the area/local APC is powered first before we actually turn back on.

/obj/item/radio/intercom/emag_act(mob/user, obj/item/card/emag/emag_card)
	. = ..()

	if(obj_flags & EMAGGED)
		return .

	if(!freqlock && !keylock)
		balloon_alert(user, LANG("obj.15a752b90ed3bc48", null))
		return .

	var/message = ""
	if(freqlock == RADIO_FREQENCY_EMAGGABLE_LOCK && keylock == RADIO_KEYSLOT_EMAGGABLE_LOCK)
		message = "frequency and key lock"
	else if(freqlock == RADIO_FREQENCY_EMAGGABLE_LOCK)
		message = "frequency lock"
	else if(keylock == RADIO_KEYSLOT_EMAGGABLE_LOCK)
		message = "key lock"

	if(!message)
		balloon_alert(user, LANG("obj.b92dd0dfd5b291e4", list((freqlock && keylock) ? "s" : "")))
		playsound(src, 'sound/machines/buzz/buzz-two.ogg', 50, FALSE, SILENCED_SOUND_EXTRARANGE)
		return .

	balloon_alert(user, LANG("obj.d0a046565f092a57", list(message)))
	playsound(src, SFX_SPARKS, 75, TRUE, SILENCED_SOUND_EXTRARANGE)
	if(freqlock == RADIO_FREQENCY_EMAGGABLE_LOCK)
		freqlock = RADIO_FREQENCY_UNLOCKED
	if(keylock == RADIO_KEYSLOT_EMAGGABLE_LOCK)
		keylock = RADIO_KEYSLOT_UNLOCKED
	obj_flags |= EMAGGED
	return TRUE

/obj/item/radio/intercom/update_icon_state()
	icon_state = on ? initial(icon_state) : icon_off
	return ..()

/**
 * Proc called whenever the intercom's area loses or gains power. Responsible for setting the `on` variable and calling `update_icon()`.
 *
 * Normally called after the intercom's area receives the `COMSIG_AREA_POWER_CHANGE` signal, but it can also be called directly.
 * Arguments:
 * * source - the area that just had a power change.
 */
/obj/item/radio/intercom/proc/AreaPowerCheck(datum/source)
	SIGNAL_HANDLER
	var/area/current_area = get_area(src)
	if(!current_area)
		set_on(FALSE)
	else
		set_on(current_area.powered(AREA_USAGE_EQUIP)) // set "on" to the equipment power status of our area.
	update_appearance()

/**
 * Called by the wall mount component and reused during the tool deconstruction proc.
 */
/obj/item/radio/intercom/atom_deconstruct(disassembled)
	new/obj/item/wallframe/intercom(get_turf(src))

//Created through the autolathe or through deconstructing intercoms. Can be applied to wall to make a new intercom on it!
/obj/item/wallframe/intercom
	name = "intercom frame"
	desc = "A ready-to-go intercom. Just slap it on a wall and screw it in!"
	icon = 'icons/obj/machines/wallmounts.dmi'
	icon_state = "intercom"
	result_path = /obj/item/radio/intercom/unscrewed
	pixel_shift = 26
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2)

// Used in the confessional booth in the chapel, locked to the confessional frequency and hides voices
/obj/item/radio/intercom/chapel
	name = "Confessional intercom"
	desc = "Talk through this... to confess your many sins. Conceals your voice, to keep them secret."
	anonymize = TRUE
	freqlock = RADIO_FREQENCY_EMAGGABLE_LOCK

/obj/item/radio/intercom/chapel/Initialize(mapload)
	. = ..()
	set_frequency(FREQ_CONFESSIONAL)
	set_broadcasting(TRUE)

// Special type of intercom for use in the bridge that can tune into any frequency and has loudmic (NOT FOR PUBLIC AREAS)
/obj/item/radio/intercom/command
	name = "command intercom"
	desc = "The command's special free-frequency intercom. It's a versatile tool that can be tuned to any frequency, granting you access to channels you're not supposed to be on. Plus, it comes equipped with a built-in voice amplifier for crystal-clear communication."
	icon_state = "intercom_command"
	freerange = TRUE
	command = TRUE
	icon_off = "intercom_command-p"

// Set of intercoms for use in interrogation. Interior one starts broadcasting, exterior one hides voices.
/obj/item/radio/intercom/interrogation
	name = "interrogation intercom"
	abstract_type = /obj/item/radio/intercom/interrogation
	freqlock = RADIO_FREQENCY_LOCKED

/obj/item/radio/intercom/interrogation/Initialize(mapload)
	. = ..()
	set_frequency(FREQ_INTERROGATION)

/obj/item/radio/intercom/interrogation/inside
	desc = "An intercom that broadcasts any ongoing interrogation to someone that's probably taking notes."

/obj/item/radio/intercom/interrogation/inside/Initialize(mapload)
	. = ..()
	set_broadcasting(TRUE)
	set_listening(FALSE)

/obj/item/radio/intercom/interrogation/outside
	desc = "An intercom that allows communication with the inside of the interrogation room, while scrambling voices for \"privacy\"."
	anonymize = TRUE

// Subtype that simply has freerange enabled
/obj/item/radio/intercom/freerange
	name = "free-range intercom"
	desc = "A special intercom that can be tuned to any frequency, bypassing encryption."
	freerange = TRUE

// For use in the AI core to allow the AI to tune into any encrypted frequency if comms are down
/obj/item/radio/intercom/freerange/ai_core
	name = "\improper AI free-range intercom"

/obj/item/radio/intercom/freerange/ai_core/Initialize(mapload)
	. = ..()
	set_listening(FALSE)

// Intercom with loudmic and innate syndicate channel access
/obj/item/radio/intercom/syndicate
	name = "syndicate intercom"
	desc = "Talk smack through this."
	icon_state = "intercom_syndicate"
	command = TRUE
	icon_off = "intercom_syndicate-p"
	special_channels = RADIO_SPECIAL_SYNDIE

// Syndicate intercom that also has freefrange on top of syndicate channel
/obj/item/radio/intercom/syndicate/freerange
	name = "syndicate wide-band intercom"
	desc = "A custom-made Syndicate-issue intercom used to transmit on all Nanotrasen frequencies. Particularly expensive."
	freerange = TRUE

/obj/item/radio/intercom/mi13
	name = "intercom"
	desc = "Talk through this to talk to whoever is in this facility with you."
	freerange = TRUE

/obj/item/radio/intercom/ai_private
	name = "\improper AI private intercom"
	desc = "An intercom primarily used for a private line directly to the station's AI."

/obj/item/radio/intercom/ai_private/Initialize(mapload)
	. = ..()
	set_frequency(FREQ_AI_PRIVATE)

// For use in AI uploads: Tuned to AI private, actively broadcasting and relaying
/obj/item/radio/intercom/ai_private/broadcasting

/obj/item/radio/intercom/ai_private/broadcasting/Initialize(mapload)
	. = ..()
	set_broadcasting(TRUE)

// For use in AI chambers: Tuned to AI private, free-range allowed, otherwise doesn't broadcast or relay
/obj/item/radio/intercom/ai_private/freerange
	desc = parent_type::desc + " This one can be tuned to any frequency, bypassing encryption."
	freerange = TRUE

/obj/item/radio/intercom/ai_private/freerange/Initialize(mapload)
	. = ..()
	set_listening(FALSE)

// For use in AI antechambers: Tuned to AI private, actively broadcasting, but not relaying
/obj/item/radio/intercom/ai_private/quiet

/obj/item/radio/intercom/ai_private/quiet/Initialize(mapload)
	. = ..()
	set_listening(FALSE)

// Subtype that spawns with an encryption key and has a key lock
/obj/item/radio/intercom/departmental
	desc = "A station intercom primarily intended for speaking with members of a department."
	keylock = RADIO_KEYSLOT_EMAGGABLE_LOCK
	abstract_type = /obj/item/radio/intercom/departmental
	var/stripe_color = null

/obj/item/radio/intercom/departmental/Initialize(mapload)
	. = ..()
	if(length(keyslot?.channels) >= 1)
		set_frequency(GLOB.default_radio_channels[keyslot.channels[1]])

/obj/item/radio/intercom/departmental/update_overlays()
	. = ..()
	if(!stripe_color)
		return
	var/mutable_appearance/stripe = mutable_appearance(icon, "intercom_stripe")
	stripe.color = stripe_color
	. += stripe

/obj/item/radio/intercom/departmental/cargo
	name = "cargo intercom"
	keyslot = /obj/item/encryptionkey/headset_cargo
	stripe_color = "#956929"

/obj/item/radio/intercom/departmental/command
	name = "command intercom"
	keyslot = /obj/item/encryptionkey/headset_com
	stripe_color = "#486091"

/obj/item/radio/intercom/departmental/engineering
	name = "engineering intercom"
	keyslot = /obj/item/encryptionkey/headset_eng
	stripe_color = "#EFB341"

/obj/item/radio/intercom/departmental/medical
	name = "medical intercom"
	keyslot = /obj/item/encryptionkey/headset_med
	stripe_color = "#52B4E9"

/obj/item/radio/intercom/departmental/science
	name = "science intercom"
	keyslot = /obj/item/encryptionkey/headset_sci
	stripe_color = "#D381C9"

/obj/item/radio/intercom/departmental/security
	name = "security intercom"
	keyslot = /obj/item/encryptionkey/headset_sec
	stripe_color = "#DE3A3A"

/obj/item/radio/intercom/departmental/service
	name = "service intercom"
	keyslot = /obj/item/encryptionkey/headset_service
	stripe_color = "#83ca41"

// Heads of staff variants
/obj/item/radio/intercom/departmental/head
	icon_state = "intercom_command"
	command = TRUE

/obj/item/radio/intercom/departmental/head/ce
	name = "\proper the chief engineer's intercom"
	keyslot = /obj/item/encryptionkey/heads/ce
	stripe_color = "#EFB341"

/obj/item/radio/intercom/departmental/head/cmo
	name = "\proper the chief medical officer's intercom"
	keyslot = /obj/item/encryptionkey/heads/cmo
	stripe_color = "#52B4E9"

/obj/item/radio/intercom/departmental/head/hop
	name = "\proper the head of personnel's intercom"
	keyslot = /obj/item/encryptionkey/heads/hop
	stripe_color = "#83ca41"

/obj/item/radio/intercom/departmental/head/hos
	name = "\proper the head of security's intercom"
	keyslot = /obj/item/encryptionkey/heads/hos
	stripe_color = "#DE3A3A"

/obj/item/radio/intercom/departmental/head/qm
	name = "\proper the quartermaster's intercom"
	keyslot = /obj/item/encryptionkey/heads/qm
	stripe_color = "#956929"

/obj/item/radio/intercom/departmental/head/rd
	name = "\proper the research director's intercom"
	keyslot = /obj/item/encryptionkey/heads/rd
	stripe_color = "#D381C9"

#define INTERCOM_OFFSET 27

MAPPING_DIRECTIONAL_HELPERS(/obj/item/radio/intercom, INTERCOM_OFFSET)
MAPPING_DIRECTIONAL_HELPERS(/obj/item/radio/intercom/prison, INTERCOM_OFFSET)
MAPPING_DIRECTIONAL_HELPERS(/obj/item/radio/intercom/chapel, INTERCOM_OFFSET)
MAPPING_DIRECTIONAL_HELPERS(/obj/item/radio/intercom/ai_private, INTERCOM_OFFSET)
MAPPING_DIRECTIONAL_HELPERS(/obj/item/radio/intercom/ai_private/broadcasting, INTERCOM_OFFSET)
MAPPING_DIRECTIONAL_HELPERS(/obj/item/radio/intercom/ai_private/freerange, INTERCOM_OFFSET)
MAPPING_DIRECTIONAL_HELPERS(/obj/item/radio/intercom/ai_private/quiet, INTERCOM_OFFSET)
MAPPING_DIRECTIONAL_HELPERS(/obj/item/radio/intercom/command, INTERCOM_OFFSET)
MAPPING_DIRECTIONAL_HELPERS(/obj/item/radio/intercom/interrogation/inside, INTERCOM_OFFSET)
MAPPING_DIRECTIONAL_HELPERS(/obj/item/radio/intercom/interrogation/outside, INTERCOM_OFFSET)
MAPPING_DIRECTIONAL_HELPERS(/obj/item/radio/intercom/freerange, INTERCOM_OFFSET)
MAPPING_DIRECTIONAL_HELPERS(/obj/item/radio/intercom/freerange/ai_core, INTERCOM_OFFSET)
MAPPING_DIRECTIONAL_HELPERS(/obj/item/radio/intercom/syndicate, INTERCOM_OFFSET)
MAPPING_DIRECTIONAL_HELPERS(/obj/item/radio/intercom/syndicate/freerange, INTERCOM_OFFSET)
MAPPING_DIRECTIONAL_HELPERS(/obj/item/radio/intercom/mi13, INTERCOM_OFFSET)
MAPPING_DIRECTIONAL_HELPERS(/obj/item/radio/intercom/departmental/cargo, INTERCOM_OFFSET)
MAPPING_DIRECTIONAL_HELPERS(/obj/item/radio/intercom/departmental/command, INTERCOM_OFFSET)
MAPPING_DIRECTIONAL_HELPERS(/obj/item/radio/intercom/departmental/engineering, INTERCOM_OFFSET)
MAPPING_DIRECTIONAL_HELPERS(/obj/item/radio/intercom/departmental/medical, INTERCOM_OFFSET)
MAPPING_DIRECTIONAL_HELPERS(/obj/item/radio/intercom/departmental/science, INTERCOM_OFFSET)
MAPPING_DIRECTIONAL_HELPERS(/obj/item/radio/intercom/departmental/security, INTERCOM_OFFSET)
MAPPING_DIRECTIONAL_HELPERS(/obj/item/radio/intercom/departmental/service, INTERCOM_OFFSET)
MAPPING_DIRECTIONAL_HELPERS(/obj/item/radio/intercom/departmental/head/ce, INTERCOM_OFFSET)
MAPPING_DIRECTIONAL_HELPERS(/obj/item/radio/intercom/departmental/head/cmo, INTERCOM_OFFSET)
MAPPING_DIRECTIONAL_HELPERS(/obj/item/radio/intercom/departmental/head/hop, INTERCOM_OFFSET)
MAPPING_DIRECTIONAL_HELPERS(/obj/item/radio/intercom/departmental/head/hos, INTERCOM_OFFSET)
MAPPING_DIRECTIONAL_HELPERS(/obj/item/radio/intercom/departmental/head/qm, INTERCOM_OFFSET)
MAPPING_DIRECTIONAL_HELPERS(/obj/item/radio/intercom/departmental/head/rd, INTERCOM_OFFSET)

#undef INTERCOM_OFFSET
