// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
#define DREAMING_SOURCE "dreaming_source"

/**
 * Begins the dreaming process on a sleeping carbon.
 *
 * Checks a 10% chance and whether or not the carbon this is called on is already dreaming. If
 * the prob() passes and there are no dream images left to display, a new dream is constructed.
 */

/mob/living/carbon/proc/handle_dreams()
	if(!HAS_TRAIT(src, TRAIT_DREAMING) && prob(10))
		dream()

/**
 * Generates a dream sequence to be displayed to the sleeper.
 *
 * Generates the "dream" to display to the sleeper. A dream consists of a subject, a verb, and (most of the time) an object, displayed in sequence to the sleeper.
 * Dreams are generated as a list of strings stored inside dream_fragments, which is passed to and displayed in dream_sequence().
 * Bedsheets on the sleeper will provide a custom subject for the dream, pulled from the dream_messages on each bedsheet.
 */

/mob/living/carbon/proc/dream()
	set waitfor = FALSE

	var/list/dream_pool = list()

	SEND_SIGNAL(src, COMSIG_PRE_DREAMING, dream_pool)
	if(!length(dream_pool))
		dream_pool = GLOB.dreams

	var/datum/dream/chosen_dream = pick_weight(dream_pool)

	ADD_TRAIT(src, TRAIT_DREAMING, DREAMING_SOURCE)
	SEND_SIGNAL(src, COMSIG_START_DREAMING, chosen_dream)
	dream_sequence(chosen_dream.GenerateDream(src), chosen_dream)

/**
 * Displays the passed list of dream fragments to a sleeping carbon.
 *
 * Displays the first string of the passed dream fragments, then either ends the dream sequence
 * or performs a callback on itself depending on if there are any remaining dream fragments to display.
 *
 * Arguments:
 * * dream_fragments - A list of strings, in the order they will be displayed.
 * * current_dream - The dream datum used for the current dream
 */

/mob/living/carbon/proc/dream_sequence(list/dream_fragments, datum/dream/current_dream)
	if(!IS_UNCONSCIOUS(src) || stat >= HARD_CRIT)
		REMOVE_TRAIT(src, TRAIT_DREAMING, DREAMING_SOURCE)
		current_dream.OnDreamEnd(src)
		SEND_SIGNAL(src, COMSIG_END_DREAMING, current_dream)
		return
	var/next_message = dream_fragments[1]
	dream_fragments.Cut(1,2)

	if(istype(next_message, /datum/callback))
		var/datum/callback/something_happens = next_message
		next_message = something_happens.InvokeAsync(src)

	if(istext(next_message)) // NOVA EDIT - I18N - reverse the dream fragment (single-word adjective/verb/noun words skip the file2list multi-word threshold and AC; exact reverse catches the catalog entries)
		next_message = lang_localize_display_name(next_message)
	to_chat(src, span_notice("<i>... [next_message] ...</i>"))

	if(LAZYLEN(dream_fragments))
		var/next_wait = rand(10, 30)
		if(current_dream.sleep_until_finished)
			AdjustSleeping(next_wait)
		addtimer(CALLBACK(src, PROC_REF(dream_sequence), dream_fragments, current_dream), next_wait)
	else
		REMOVE_TRAIT(src, TRAIT_DREAMING, DREAMING_SOURCE)
		current_dream.OnDreamEnd(src)
		SEND_SIGNAL(src, COMSIG_END_DREAMING, current_dream)

//-------------------------
// DREAM DATUMS

GLOBAL_LIST_INIT(dreams, populate_dream_list())

/proc/populate_dream_list()
	var/list/output = list()
	for(var/datum/dream/dream_type as anything in subtypesof(/datum/dream))
		output[new dream_type] = initial(dream_type.weight)
	return output

/**
 * Contains all the behavior needed to play a kind of dream.
 * All dream types get randomly selected from based on weight when an appropriate mobs dreams.
 */
/datum/dream
	/// The relative chance this dream will be randomly selected
	var/weight = 0

	/// Causes the mob to sleep long enough for the dream to finish if begun
	var/sleep_until_finished = FALSE

/**
 * Called when beginning a new dream for the dreamer.
 * Gives back a list of dream events. Events can be text or callbacks that return text.
 */
/datum/dream/proc/GenerateDream(mob/living/carbon/dreamer)
	return list()

/**
 * Called when the dream ends or is interrupted.
 */
/datum/dream/proc/OnDreamEnd(mob/living/carbon/dreamer)
	return

/// The classic random dream of various words that might form a cohesive narrative, but usually wont
/datum/dream/random
	weight = 1000

// NOVA EDIT CHANGE START - I18N - 梦境整句由五张词池拼出，整串永远不是目录键；按 locale 换整张表
// （见 lang_word_pool）。**五张必须一起换**：只译形容词会产出「a 迷人的 admiral」，比全英文更难看。
/datum/dream/random/GenerateDream(mob/living/carbon/dreamer)
	var/list/custom_dream_nouns = get_dream_nouns(dreamer) || list()
	var/fragment = ""
	var/list/dream_strings = lang_word_pool("strings/dreamstrings.txt", GLOB.dream_strings)
	var/list/adjectives = lang_word_pool("strings/names/adjectives.txt", GLOB.adjectives)

	. = list()
	. += LANG("datum.efaeefa517476935", null)

	//Subject
	if(custom_dream_nouns.len && prob(90))
		fragment += pick(custom_dream_nouns)
	else
		fragment += pick(dream_strings)

	fragment = dream_fill_adjective(fragment, adjectives)
	. += fragment

	//Verb
	fragment = ""
	if(prob(50))
		if(prob(35))
			fragment += "[pick(lang_word_pool("strings/names/adverbs.txt", GLOB.adverbs))] "
		fragment += pick(lang_word_pool("strings/names/ing_verbs.txt", GLOB.ing_verbs))
	else
		fragment += LANG("datum.8356b3e0d54e153c", null)
		fragment += pick(lang_word_pool("strings/names/verbs.txt", GLOB.verbs))
	. += fragment

	if(prob(25))
		return

	//Object
	fragment = ""
	fragment += pick(dream_strings)
	fragment = dream_fill_adjective(fragment, adjectives)
	. += fragment

/// 填 `%ADJECTIVE%` / `%A%` 两个占位符。原来这段在 GenerateDream 里出现两次、逐字重复。
///
/// **中文词表里 `%ADJECTIVE%` 后面没有空格**（「%ADJECTIVE%海军上将」），而英文表有
/// （「%A% %ADJECTIVE% admiral」）——所以「不要形容词」那一支必须**先试带空格、再试不带**，
/// 只写带空格的那条会让中文梦境里漏出字面 `%ADJECTIVE%`。
/// `%A%`（冠词位）中文表里直接没有，findtext 落空 → 不加 `\a`，正是想要的。
/datum/dream/random/proc/dream_fill_adjective(fragment, list/adjectives)
	if(prob(50))
		fragment = replacetext(fragment, "%ADJECTIVE%", pick(adjectives))
	else
		fragment = replacetext(fragment, "%ADJECTIVE% ", "")
		fragment = replacetext(fragment, "%ADJECTIVE%", "")
	if(findtext(fragment, "%A% "))
		fragment = "\a [replacetext(fragment, "%A% ", "")]"
	return fragment
// NOVA EDIT CHANGE END

/datum/dream/random/proc/get_dream_nouns(mob/living/carbon/dreamer)
	var/list/custom_dream_nouns = list()
	for(var/obj/item/bedsheet/sheet in dreamer.loc)
		custom_dream_nouns += sheet.dream_messages
	return custom_dream_nouns

/// Dream plays a random sound at you, chosen from all sounds in the folder
/datum/dream/hear_something
	weight = 500

	var/reserved_sound_channel

/datum/dream/hear_something/New()
	. = ..()
	RegisterSignal(SSsounds, COMSIG_SUBSYSTEM_POST_INITIALIZE, PROC_REF(ReserveSoundChannel))

/datum/dream/hear_something/GenerateDream(mob/living/carbon/dreamer)
	. = ..()
	. += pick("you wind up a toy", "you hear something strange", "you pick out a record to play", "you hit shuffle on your music player")
	. += CALLBACK(src, PROC_REF(PlayRandomSound))
	. += LANG("datum.5e68fd6d41fdde9a", null)

/datum/dream/hear_something/OnDreamEnd(mob/living/carbon/dreamer)
	. = ..()
	// In case we play some long ass music track
	addtimer(CALLBACK(src, PROC_REF(StopSound), dreamer), 5 SECONDS)

/datum/dream/hear_something/proc/ReserveSoundChannel()
	reserved_sound_channel = SSsounds.reserve_sound_channel_for_datum(src)
	UnregisterSignal(SSsounds, COMSIG_SUBSYSTEM_POST_INITIALIZE)

/datum/dream/hear_something/proc/PlayRandomSound(mob/living/carbon/dreamer)
	var/sound/random_sound = sound(pick(SSsounds.all_sounds), channel=reserved_sound_channel)
	random_sound.status = SOUND_STREAM
	SEND_SOUND(dreamer, random_sound)
	return "you hear something you weren't expecting!"

/datum/dream/hear_something/proc/StopSound(mob/living/carbon/dreamer)
	SEND_SOUND(dreamer, sound(channel=reserved_sound_channel))

#undef DREAMING_SOURCE
