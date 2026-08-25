// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/mutation/antenna
	name = "Antenna"
	desc = "The subject sprouts an antenna, which is known to allow them to access common radio channels without any external devices."
	quality = POSITIVE
	text_gain_indication = span_notice("You feel an antenna sprout from your forehead.")
	text_lose_indication = span_notice("Your antenna shrinks back down.")
	instability = POSITIVE_INSTABILITY_MINOR
	difficulty = 8
	mutation_icon_state = "antenna"
	layer_used = FRONT_MUTATIONS_LAYER
	var/datum/weakref/radio_weakref

/obj/item/implant/radio/antenna
	name = "internal antenna organ"
	desc = "The internal organ part of the antenna. Science has not yet given it a good name."
	icon = 'icons/obj/devices/voice.dmi'//maybe make a unique sprite later. not important
	icon_state = "walkietalkie"

/obj/item/implant/radio/antenna/Initialize(mapload)
	. = ..()
	radio.name = "internal antenna"

/datum/mutation/antenna/on_acquiring(mob/living/carbon/human/owner)
	. = ..()
	if(!.)
		return
	var/obj/item/implant/radio/antenna/linked_radio = new(owner)
	linked_radio.implant(owner, null, TRUE, TRUE)
	radio_weakref = WEAKREF(linked_radio)

/datum/mutation/antenna/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	var/obj/item/implant/radio/antenna/linked_radio = radio_weakref.resolve()
	if(linked_radio)
		QDEL_NULL(linked_radio)

/datum/mutation/mindreader
	name = "Mind Reader"
	desc = "The subject can look into the recent memories of others."
	quality = POSITIVE
	text_gain_indication = span_notice("You hear distant voices at the corners of your mind.")
	text_lose_indication = span_notice("The distant voices fade.")
	power_path = /datum/action/cooldown/spell/pointed/mindread
	instability = POSITIVE_INSTABILITY_MINOR
	difficulty = 8
	locked = TRUE
	mutation_icon_state = "antenna"
	layer_used = FRONT_MUTATIONS_LAYER

/datum/action/cooldown/spell/pointed/mindread
	name = "Mindread"
	desc = "Read the target's mind."
	button_icon_state = "mindread"
	school = SCHOOL_PSYCHIC
	cooldown_time = 5 SECONDS
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC
	antimagic_flags = MAGIC_RESISTANCE_MIND

	ranged_mousepointer = 'icons/effects/mouse_pointers/mindswap_target.dmi'

/datum/action/cooldown/spell/pointed/mindread/Grant(mob/grant_to)
	. = ..()
	if (!owner)
		return
	ADD_TRAIT(grant_to, TRAIT_MIND_READER, GENETIC_MUTATION)
	RegisterSignal(grant_to, COMSIG_MOB_EXAMINATE, PROC_REF(on_examining))

/datum/action/cooldown/spell/pointed/mindread/Remove(mob/remove_from)
	. = ..()
	REMOVE_TRAIT(remove_from, TRAIT_MIND_READER, GENETIC_MUTATION)
	UnregisterSignal(remove_from, COMSIG_MOB_EXAMINATE)

/datum/action/cooldown/spell/pointed/mindread/is_valid_target(atom/cast_on)
	if(!isliving(cast_on))
		return FALSE
	var/mob/living/living_cast_on = cast_on
	if(!living_cast_on.mind)
		to_chat(owner, span_warning(LANG("datum.2187cad60a59dca5", list(cast_on))))
		return FALSE
	if(living_cast_on.stat == DEAD)
		to_chat(owner, span_warning(LANG("datum.01e50bcef3be90ac", list(cast_on))))
		return FALSE
	if(living_cast_on.mob_biotypes & MOB_ROBOTIC)
		to_chat(owner, span_warning(LANG("datum.9e7b9ce439b2f8fb", list(cast_on, cast_on.p_their()))))
		return FALSE

	return TRUE

/datum/action/cooldown/spell/pointed/mindread/cast(mob/living/cast_on)
	. = ..()
	if(cast_on.can_block_magic(antimagic_flags, charge_cost = 0))
		to_chat(owner, span_warning(LANG("datum.c9f0817e14353844", list(cast_on))))
		return

	if(cast_on == owner)
		to_chat(owner, span_warning(LANG("datum.5a5202d04ab02dc7", null)))
		return

	if(cast_on.has_status_effect(/datum/status_effect/heretic_passive/moon))
		to_chat(owner, span_hypnophrase(span_bolddanger(LANG("datum.4c0322721c54ead8", null))))
		if(isliving(owner))
			var/mob/living/reader = owner
			reader.apply_status_effect(/datum/status_effect/moon_converted)
		return

	if(HAS_TRAIT(cast_on, TRAIT_EVIL))
		to_chat(owner, span_warning(LANG("datum.0d80fa5adfff4f51", list(cast_on, HAS_TRAIT(owner, TRAIT_EVIL) ? "It's nice to find someone who is like-minded." : "What is wrong with this person?"))))

	var/list/log_info = list()
	var/list/discovered_info = list("<i>You plunge into [cast_on]'s mind and discover...</i>")
	if(prob(20))
		// chance to alert the read-ee
		to_chat(cast_on, span_danger(LANG("datum.33325e19167b16b7", null)))
		log_info += "Target alerted!"

	var/list/recent_speech = cast_on.copy_recent_speech(copy_amount = 3, line_chance = 50)
	if(length(recent_speech))
		discovered_info += "...Drifting memories of past conversations:"
		var/list/speech_block = list()
		for(var/spoken_memory in recent_speech)
			speech_block += "&emsp;\"[spoken_memory]\"..."
			log_info += "Recent speech: \"[spoken_memory]\""
		discovered_info += jointext(speech_block, "<br>")

	if(iscarbon(cast_on))
		var/mob/living/carbon/carbon_cast_on = cast_on
		discovered_info += "...Intent to <b>[carbon_cast_on.combat_mode ? "harm" : "help"]</b>."
		discovered_info += "...True identity of <b>[carbon_cast_on.mind.name]</b>."
		log_info += "Intent: \"[carbon_cast_on.combat_mode ? "harm" : "help"]\""
		log_info += "Identity: \"[carbon_cast_on.mind.name]\""

	to_chat(owner, boxed_message(span_notice(jointext(discovered_info, "<br>"))))
	log_combat(owner, cast_on, "mind read (cast intentionally)", null, "info: [english_list(log_info, and_text = ", ")]")

/datum/action/cooldown/spell/pointed/mindread/proc/on_examining(mob/examiner, atom/examining)
	SIGNAL_HANDLER
	if(!isliving(examining) || examiner == examining)
		return

	INVOKE_ASYNC(src, PROC_REF(read_mind), examiner, examining)

/datum/action/cooldown/spell/pointed/mindread/proc/read_mind(mob/living/examiner, mob/living/examined)
	if(IS_UNCONSCIOUS(examined) || isnull(examined.mind) || (examined.mob_biotypes & MOB_ROBOTIC))
		return

	var/antimagic = examined.can_block_magic(antimagic_flags, charge_cost = 0)
	var/read_text = ""
	if(!antimagic)
		read_text = examined.get_typing_text()
		if(!read_text)
			return

	sleep(0.5 SECONDS) // small pause so it comes after all examine text and effects
	if(QDELETED(examiner))
		return
	if(antimagic)
		to_chat(examiner, boxed_message(span_warning(LANG("datum.b4eedb0c48a72264", list(examined, examined.p_their())))))
		return

	var/list/log_info = list()
	if(prob(10))
		to_chat(examined, span_danger(LANG("datum.33325e19167b16b7", null)))
		log_info += "Target alerted!"

	to_chat(examiner, boxed_message(span_notice(LANG("datum.7ea00d190ddcb382", list(examined, read_text)))))
	log_info += "Current thought: \"[read_text]\""

	log_combat(examiner, examined, "mind read (triggered on examine)", null, "info: [english_list(log_info, and_text = ", ")]")
