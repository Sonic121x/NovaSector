/// Possible states of player consent for using the machine.
#define NO_CONSENT 0
#define CONSENT_GRANTED 1
#define WAITING_PLAYER 2
/// How long does it take to break out of the machine?
#define BREAKOUT_TIME 5 SECONDS
/// The interval that advertisements are said by the machine's speaker.
#define ADVERT_TIME 18 SECONDS
/// The wattage consumed by the machine's laser. Some serious face-melting power here I tell you what.
#define LASER_POWER_USAGE 7.2 MEGA WATTS

/datum/design/board/self_actualization_device
	name = "Self-Actualization Device Board"
	desc = "The circuit board for a Self-Actualization Device by Vey-Medical."
	build_path = /obj/item/circuitboard/machine/self_actualization_device
	category = list(RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_MEDICAL)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/obj/item/circuitboard/machine/self_actualization_device
	name = "Self-Actualization Device"
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/self_actualization_device
	req_components = list(/datum/stock_part/micro_laser = 1)

/obj/machinery/self_actualization_device
	name = "Self-Actualization Device"
	desc = "A state of the art medical device that can restore someone's physical appearance to the last known DNA database backup."
	icon = 'modular_nova/modules/self_actualization_device/icons/self_actualization_device.dmi'
	icon_state = "sad_open"
	circuit = /obj/item/circuitboard/machine/self_actualization_device
	state_open = FALSE
	density = TRUE
	/// Is someone being processed inside of the machine?
	var/processing = FALSE
	/// How long does the machine take to work?
	var/processing_time = 1 MINUTES
	/// wzhzhzh
	var/datum/looping_sound/microwave/sound_loop
	/// Has the player consented to the DNA change
	var/player_consent = NO_CONSENT
	/// A list containing advertisements that the machine says while working.
	var/static/list/advertisements = list(\
	"Thank you for using the Self-Actualization Device, brought to you by the Vey-Medical Corporation, because you asked for it.", \
	"The Self-Actualization device is not to be used by the elderly without direct adult supervision. Vey-Medical is not liable for any and all injuries sustained under unsupervised usage of the Self-Actualization Device.", \
	"The Self-Actualization Device is not to be used un-cleaned. Thanks to its non-stick coating, cleaning up after a failed rejuvenation is easy as cleaning a microwave. Blood just doesn't stick!", \
	"Before using the Self-Actualization Device, remove any and all metal devices, or you might make the term 'ironman' a bit too literal!" , \
	"Remember, this is not cloning! Self-Actualization is a legally distinct, Vey-Medical patent pending procedure. Still have questions? Call your nearest Vey-Medical Representative to requisition more information about the Self-Actualization Device!" , \
	"Coming soon... Self-Actualization Device: Colony Fabricator Edition! Flat-packed and better in every way, with no medical expertise required! It's so easy, it's like cheating! Contact your nearest Vey-Medical Representative to find out more!" \
	)
	COOLDOWN_DECLARE(advert_time)
	COOLDOWN_DECLARE(sad_processing_time)

/obj/machinery/self_actualization_device/examine_more(mob/user)
	. = ..()

	. += LANG("obj.f8e857feac6a7884", null)

	return .

/obj/machinery/self_actualization_device/Initialize(mapload)
	. = ..()
	sound_loop = new(src, FALSE)
	register_context()
	update_appearance()

/obj/machinery/self_actualization_device/Destroy()
	QDEL_NULL(sound_loop)
	return ..()

/obj/machinery/self_actualization_device/update_appearance(updates)
	. = ..()
	if(isnull(occupant))
		icon_state = state_open ? "sad_open" : "sad_empty"
	else
		switch(player_consent)
			if(WAITING_PLAYER)
				icon_state = "sad_validating"
			if(CONSENT_GRANTED)
				icon_state = "sad_on"
			if(NO_CONSENT)
				icon_state = "sad_occupied"

/obj/machinery/self_actualization_device/close_machine(atom/movable/target, density_to_set = TRUE)
	..()
	playsound(src, 'sound/machines/click.ogg', 50)
	if(!occupant)
		return FALSE
	if(!ishuman(occupant))
		occupant.forceMove(drop_location())
		set_occupant(null)
		return FALSE
	to_chat(occupant, span_notice(LANG("obj.1d4849e619e6913a", list(src))))
	addtimer(CALLBACK(src, PROC_REF(get_consent)), 4 SECONDS, TIMER_OVERRIDE|TIMER_UNIQUE)
	update_appearance()

/obj/machinery/self_actualization_device/examine(mob/user)
	. = ..()
	. += span_info(LANG("obj.6b9564d4e0dddf8a", list(display_power(active_power_usage), DisplayTimeText(processing_time))))

	if(processing)
		. += span_notice(LANG("obj.5510129cab92578c", list(DisplayTimeText(COOLDOWN_TIMELEFT(src, sad_processing_time), 2))))
	else
		. += span_notice(LANG("obj.97f46bd188c4d6c8", list(state_open ? "close" : "open")))
		if(!isnull(occupant) && !state_open)
			. += span_notice(LANG("obj.ff1221b3467849ff", null))

/obj/machinery/self_actualization_device/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	if(!processing)
		context[SCREENTIP_CONTEXT_LMB] = "[state_open ? "Close" : "Open"] machine"
	if(!isnull(occupant) && !state_open && !processing)
		context[SCREENTIP_CONTEXT_ALT_LMB] = "Start machine"

	return CONTEXTUAL_SCREENTIP_SET

/obj/machinery/self_actualization_device/interact(mob/user)
	if(state_open)
		close_machine()
		return

	if(!processing)
		open_machine()
		return

/obj/machinery/self_actualization_device/click_alt(mob/user)
	if(!powered() || !occupant || state_open || processing)
		return CLICK_ACTION_BLOCKING

	user.visible_message(span_notice(LANG("obj.c6842664dc0d26dc", list(user, src))), span_notice(LANG("obj.85e7cc687a81a65b", list(src))))
	get_consent()
	return CLICK_ACTION_SUCCESS

/obj/machinery/self_actualization_device/process(seconds_per_tick)
	if(!processing)
		return

	if(!powered() && occupant && processing)
		eject_old_you(damaged_goods = TRUE)
		return

	if(!powered() || !occupant || !iscarbon(occupant))
		open_machine()
		return

	if(player_consent != CONSENT_GRANTED) // breakout
		processing = FALSE
		return

	if(COOLDOWN_FINISHED(src, sad_processing_time))
		eject_new_you()
		return

	if(COOLDOWN_FINISHED(src, advert_time))
		COOLDOWN_START(src, advert_time, rand(ADVERT_TIME, ADVERT_TIME * 2))
		say(pick(advertisements))
		playsound(loc, 'sound/machines/chime.ogg', 30, FALSE)

	use_energy(active_power_usage)

/// Asks the player if they want to consent to the rejuvenation procedure (replacing their DNA with what they currently have selected in character preferences.)
/obj/machinery/self_actualization_device/proc/get_consent()
	if(state_open || !occupant || !powered())
		return

	if(!ishuman(occupant))
		return

	if(player_consent != NO_CONSENT)
		return

	playsound(loc, 'sound/machines/chime.ogg', 30, FALSE)
	say(LANG("obj.c197023035b9be8c", null))
	var/mob/living/carbon/human/human_occupant = occupant
	if(!isnull(human_occupant.ckey) && isnull(human_occupant.client)) // player mob, currently disconnected
		playsound(src, 'sound/machines/buzz/buzz-sigh.ogg', 50, FALSE)
		say(LANG("obj.290ba6cf33b04801", null))
		return

	player_consent = WAITING_PLAYER
	update_appearance()

	// defaults to rejecting it unless specified otherwise
	if(tgui_alert(occupant, LANG("obj.849efc777f2c2ba8", null), LANG("obj.b77e9c6037c3333e", null), list("Yes", "No"), timeout = 10 SECONDS) == "Yes")
		player_consent = CONSENT_GRANTED
		say(LANG("obj.d44835f5666f8fc8", list(DisplayTimeText(processing_time), display_power(active_power_usage))))
		to_chat(occupant, span_warning(LANG("obj.233cda98b945e47a", list(DisplayTimeText(processing_time)))))
		set_light(l_range = 1.5, l_power = 1.2, l_on = TRUE)
		sound_loop.start()
		COOLDOWN_START(src, sad_processing_time, processing_time)
		COOLDOWN_START(src, advert_time, rand(ADVERT_TIME * 0.75, ADVERT_TIME * 1.25))
		processing = TRUE
		update_appearance()
	else
		player_consent = NO_CONSENT
		playsound(src, 'sound/machines/buzz/buzz-sigh.ogg', 50, FALSE)
		say(LANG("obj.5618fe74191b092d", null))
		update_appearance()

/// Ejects the occupant after asking them if they want to accept the rejuvenation. If yes, they exit as their preferences character.
/obj/machinery/self_actualization_device/proc/eject_new_you()
	player_consent = NO_CONSENT
	set_light(l_on = FALSE)
	sound_loop.stop()
	processing = FALSE
	if(state_open || !occupant || !powered())
		return

	var/mob/living/carbon/human/patient = occupant
	var/original_name = patient.dna.real_name

	// Check for AI-brain upload. If it was the brain before, then we should replace "new me"s brain with cybernetic one.
	var/obj/item/organ/brain/cybernetic/ai/old_ai_brain = patient.get_organ_by_type(/obj/item/organ/brain/cybernetic/ai)
	var/mob/living/silicon/ai/real_ai_player
	if(istype(old_ai_brain) && old_ai_brain.mainframe)
		real_ai_player = old_ai_brain.mainframe
		var/datum/preferences/check_prefs = patient.client?.prefs
		if(!istype(check_prefs))
			say(LANG("obj.934ec61f5cd59c26", null))
			playsound(src, 'sound/machines/microwave/microwave-end.ogg', 100, FALSE)
			open_machine()
			return
		if(!is_augmented_enough(check_prefs))
			say(LANG("obj.736dad9888c06fdd", null))
			playsound(src, 'sound/machines/microwave/microwave-end.ogg', 100, FALSE)
			open_machine()
			return
		old_ai_brain.undeploy()
		real_ai_player.client?.prefs?.safe_transfer_prefs_to_with_damage(patient)
		attempt_appendix_removal(patient, check_prefs)
	else
		patient.client?.prefs?.safe_transfer_prefs_to_with_damage(patient)

	patient.dna.update_dna_identity()

	if(istype(old_ai_brain))
		var/obj/item/organ/brain/cybernetic/ai/new_ai_brain = new
		if(!new_ai_brain.Insert(patient, movement_flags = DELETE_IF_REPLACED))
			qdel(new_ai_brain) // You get no brain, whoops. Something really bad happened here

	log_game("[key_name(patient)] used a Self-Actualization Device at [loc_name(src)].")

	if(patient.dna.real_name != original_name)
		message_admins("[key_name_admin(patient)] has used the Self-Actualization Device, and changed the name of their character. \
		Original Name: [original_name], New Name: [patient.dna.real_name]. \
		This may be a false positive from changing from a humanized monkey into a character, so be careful.")
	playsound(src, 'sound/machines/microwave/microwave-end.ogg', 100, FALSE)
	say(LANG("obj.1b818e47021a5f69", null))

	open_machine()

/// Ejection and shut down of the machine, used before the preferences have been applied to the player. Damage optional.
/obj/machinery/self_actualization_device/proc/eject_old_you(damaged_goods = FALSE)
	player_consent = NO_CONSENT
	set_light(l_on = FALSE)
	sound_loop.stop()
	processing = FALSE

	if(damaged_goods)
		var/mob/living/carbon/human/victim_living = occupant
		var/damage = (rand(75, 150))
		victim_living.emote("scream")
		victim_living.apply_damage(0.2 * damage, BURN, BODY_ZONE_HEAD, wound_bonus = 7)
		victim_living.apply_damage(0.4 * damage, BURN, BODY_ZONE_CHEST, wound_bonus = 21)
		victim_living.apply_damage(0.10 * damage, BURN, BODY_ZONE_L_LEG, wound_bonus = 14)
		victim_living.apply_damage(0.10 * damage, BURN, BODY_ZONE_R_LEG, wound_bonus = 14)
		victim_living.apply_damage(0.10 * damage, BURN, BODY_ZONE_L_ARM, wound_bonus = 14)
		victim_living.apply_damage(0.10 * damage, BURN, BODY_ZONE_R_ARM, wound_bonus = 14)
		victim_living.visible_message(span_warning(LANG("obj.403793f7807ec14a", list(src, victim_living))), span_danger(LANG("obj.35d55ceee0db8d79", list(src))))

	open_machine()

/// The player can break out of the SAD if they've changed their mind about using it.
/obj/machinery/self_actualization_device/container_resist_act(mob/living/user)
	if(state_open)
		return

	if(COOLDOWN_TIMELEFT(src, sad_processing_time) < BREAKOUT_TIME)
		to_chat(user, span_warning(LANG("obj.493da65abe3fa762", null)))
		return

	to_chat(user, span_notice(LANG("obj.58177e73a518ae0f", null)))
	user.changeNext_move(CLICK_CD_BREAKOUT)
	user.last_special = world.time + CLICK_CD_BREAKOUT
	user.visible_message(span_notice(LANG("obj.485787b2b8d67ec7", list(user, src))), \
		span_notice(LANG("obj.43ad33b141e25411", list(src, DisplayTimeText(BREAKOUT_TIME)))), \
		span_hear(LANG("obj.a1d9c5733c600b1c", list(src))))
	user.emote("scream")

	if(do_after(user, BREAKOUT_TIME, target = src))
		if(!user || IS_UNCONSCIOUS_OR_CRIT(user) || user.loc != src || state_open)
			return
		user.visible_message(span_warning(LANG("obj.37696909131e91b5", list(user, src))), \
			span_notice(LANG("obj.81c31f6b9b00625a", list(src))))
		eject_old_you(damaged_goods = TRUE)

/obj/machinery/self_actualization_device/screwdriver_act(mob/living/user, obj/item/tool)
	if(occupant)
		to_chat(user, span_warning(LANG("obj.297417466fc8e075", list(src))))
		return NONE

	return default_deconstruction_screwdriver(user, tool)

/obj/machinery/self_actualization_device/crowbar_act(mob/living/user, obj/item/tool)
	if(occupant)
		to_chat(user, span_warning(LANG("obj.297417466fc8e075", list(src))))
		return NONE

	return default_deconstruction_crowbar(user, tool)

/obj/machinery/self_actualization_device/RefreshParts()
	. = ..()
	processing_time = 70 SECONDS
	for(var/datum/stock_part/micro_laser/laser in component_parts) // Laser tier increases speed, at the expense of power.
		processing_time -= laser.tier * 10 SECONDS
		active_power_usage = LASER_POWER_USAGE / processing_time
		idle_power_usage = active_power_usage / 4

/// Creates new dummy in the nullspace, applies prefs, inserts ai-brain and checks if it's compatible.
/obj/machinery/self_actualization_device/proc/is_augmented_enough(datum/preferences/player_prefs)
	var/mob/living/carbon/human/nullspace_dummy = new(null)
	player_prefs?.apply_prefs_to(nullspace_dummy, icon_updates = FALSE)
	attempt_appendix_removal(nullspace_dummy, player_prefs)
	var/obj/item/organ/brain/cybernetic/ai/dummy_ai_brain = new
	if(!dummy_ai_brain.Insert(nullspace_dummy, movement_flags = DELETE_IF_REPLACED))
		QDEL_NULL(dummy_ai_brain)
		QDEL_NULL(nullspace_dummy)
		return FALSE

	var/result = dummy_ai_brain.is_sufficiently_augmented()
	QDEL_NULL(dummy_ai_brain)
	QDEL_NULL(nullspace_dummy)
	return result

/*
 * Helper function for the removal of appendices from a mob.
 * Shamelessly stolen from /datum/quirk/no_appendix/post_add().
 * If you have a better idea on how to handle this, i'd like to hear it,
 * because add_quirk() isn't working.
 */
/obj/machinery/self_actualization_device/proc/attempt_appendix_removal(mob/living/carbon/human/shell, datum/preferences/player_prefs)
	if (!(/datum/quirk/no_appendix::name in player_prefs?.all_quirks))
		return FALSE // don't bother

	var/obj/item/organ/appendix/old_appendix = shell.get_organ_slot(ORGAN_SLOT_APPENDIX)
	if(isnull(old_appendix))
		return FALSE // no appendix, no worries

	old_appendix.Remove(shell, special = TRUE)
	QDEL_NULL(old_appendix)

#undef NO_CONSENT
#undef CONSENT_GRANTED
#undef WAITING_PLAYER
#undef BREAKOUT_TIME
#undef ADVERT_TIME
#undef LASER_POWER_USAGE
