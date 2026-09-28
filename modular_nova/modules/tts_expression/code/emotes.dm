/mob/living
	/// Whether vocal emotes use this mob's TTS voice instead of stock sound effects.
	var/tts_voiced_emotes = TRUE

/// Emote key -> list(style, sound, text): how a humanoid's own TTS voice performs a vocal emote.
/// Only generic emotes are listed. Species emotes (meows, chitters, trills...) keep their sounds.
GLOBAL_LIST_INIT(tts_emote_voices, list(
	"laugh" = list(null, "laughing", ""),
	"giggle" = list(null, "giggles", ""),
	"chuckle" = list(null, "giggles", ""),
	"sigh" = list(null, "sighing", ""),
	"exhale" = list(null, "sighing", ""),
	"cough" = list(null, "cough", ""),
	"choke" = list(null, "cough", "呃……"),
	"gasp" = list(null, "gasp", ""),
	"gaspshock" = list(null, "gasp", ""),
	"inhale" = list(null, "gasp", ""),
	"clear" = list(null, "clears throat", ""),
	"cry" = list("crying", null, "呜呜呜……"),
	"whimper" = list("crying", null, "呜……"),
	"groan" = list("tired", null, "呃啊……"),
	"yawn" = list("tired", null, "哈啊——"),
	"wheeze" = list("tired", null, "呼……呼……"),
	"grumble" = list("bored", null, "哼……"),
	"scream" = list("panicked", null, "啊啊啊！"),
	"sneeze" = list(null, null, "阿嚏！"),
	"gag" = list(null, null, "呕——"),
))

/// Returns how `user` voices `emote_key` through TTS, or null if the emote keeps its sound effect.
/proc/tts_emote_voice(mob/living/carbon/human/user, emote_key)
	if(!ishuman(user) || !user.tts_voiced_emotes || !user.voice)
		return null
	if(!SStts?.is_runtime_enabled() || HAS_TRAIT(user, TRAIT_SIGN_LANG) || HAS_TRAIT(user, TRAIT_UNKNOWN_VOICE))
		return null
	var/list/voicing = GLOB.tts_emote_voices[emote_key]
	if(!voicing)
		return null
	var/style = voicing[1]
	var/sound = voicing[2]
	// Without the tag the emote would just be words, or nothing at all.
	if(style && !(style in SStts.supported_styles))
		return null
	if(sound && !(sound in SStts.supported_sounds))
		return null
	return voicing

/// Performs a vocal emote in the user's TTS voice. Listeners who turned speech off, or only
/// want blips, hear the stock sound effect instead.
/proc/tts_play_emote(mob/living/carbon/human/user, list/voicing, fallback_sound, volume, frequency)
	var/list/tts_listeners = list()
	var/turf/source_turf = get_turf(user)
	for(var/mob/hearer in get_hearers_in_view(DEFAULT_MESSAGE_RANGE, user))
		var/listening_mob = hearer.get_listening_mob()
		if(!ismob(listening_mob))
			continue
		var/mob/listener = listening_mob
		if(listener.client?.prefs.read_preference(/datum/preference/choiced/sound_tts) == TTS_SOUND_ENABLED)
			tts_listeners += listener
		else if(fallback_sound && listener.client)
			listener.playsound_local(source_turf, fallback_sound, volume, frequency = frequency)

	var/list/filter = list()
	if(length(user.voice_filter))
		filter += user.voice_filter
	var/list/special_filter = list()
	var/speaker = user.get_tts_voice(filter, special_filter)
	var/identifier = "[sha1("[speaker]|[voicing[3]]|[world.time]")].[world.time]"
	INVOKE_ASYNC(SStts, TYPE_PROC_REF(/datum/controller/subsystem/tts, queue_tts_message), user, voicing[3], null, speaker, filter.Join(","), tts_listeners, message_range = DEFAULT_MESSAGE_RANGE, pitch = user.pitch, special_filters = special_filter.Join("|"), identifier = identifier, style = voicing[1], sound = voicing[2], instruction = tts_compose_instruction(user.tts_instruction), rate = user.tts_rate, ignore_language = TRUE)

/// Whether vocal emotes use the character's TTS voice.
/datum/preference/toggle/tts_voiced_emotes
	category = PREFERENCE_CATEGORY_VOCALS
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "tts_voiced_emotes"
	default_value = TRUE
	can_randomize = FALSE

/datum/preference/toggle/tts_voiced_emotes/is_accessible(datum/preferences/preferences)
	if(!..(preferences))
		return FALSE
	if(!SStts.tts_enabled || !length(SStts.supported_sounds))
		return FALSE
	return preferences.read_preference(/datum/preference/choiced/vocals/voice_type) == VOICE_TYPE_TTS

/datum/preference/toggle/tts_voiced_emotes/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.tts_voiced_emotes = value
