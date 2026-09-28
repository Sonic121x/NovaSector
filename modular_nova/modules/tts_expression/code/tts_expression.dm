/atom/movable
	/// Natural-language description of how this atom's TTS voice sounds, e.g. an accent or age.
	var/tts_instruction
	/// TTS speaking rate multiplier, from 0.5 to 2.
	var/tts_rate = 1

/datum/controller/subsystem/tts
	/// Voice ID -> readable label shown in the preferences menu.
	var/list/voice_labels = list()
	/// Voice IDs suitable for random assignment: adult voices that speak the server's language.
	var/list/random_voices = list()
	/// Retired voice ID -> the voice that replaced it, so saved characters keep a voice.
	var/list/voice_aliases = list()
	/// Control tags the TTS server accepts as `style`.
	var/list/supported_styles = list()
	/// Nonverbal tags the TTS server accepts as `sound`.
	var/list/supported_sounds = list()
	/// Whether the TTS server accepts natural-language voice instructions.
	var/instruction_enabled = FALSE
	/// Whether the TTS server accepts a speaking rate.
	var/rate_enabled = FALSE
	/// Whether voice metadata has been loaded from the server or the cache.
	var/voice_info_loaded = FALSE

/// Fetches the optional voice metadata. Servers without it only lose the extras.
/// This is blocking, so be careful when calling.
/datum/controller/subsystem/tts/proc/load_voice_info()
	var/datum/http_request/request = new()
	var/list/headers = list()
	headers["Authorization"] = CONFIG_GET(string/tts_http_token)
	request.prepare(RUSTG_HTTP_METHOD_GET, "[CONFIG_GET(string/tts_http_url)]/tts-voice-info", "", headers, timeout_seconds = CONFIG_GET(number/tts_http_timeout_seconds))
	request.begin_async()
	UNTIL(request.is_complete())
	var/datum/http_response/response = request.into_response()
	if(response.errored || response.status_code != 200)
		apply_voice_info(null)
		return FALSE
	if(!apply_voice_info(safe_json_decode(response.body)))
		return FALSE
	rustg_file_write(response.body, TTS_VOICE_INFO_CACHE)
	refresh_custom_voices()
	return TRUE

/// Loads cached voice metadata, for preferences built before the server answers.
/datum/controller/subsystem/tts/proc/ensure_voice_info()
	if(voice_info_loaded || !fexists(TTS_VOICE_INFO_CACHE))
		return
	apply_voice_info(safe_json_decode(rustg_file_read(TTS_VOICE_INFO_CACHE)))

/// Replaces the voice metadata. Returns FALSE and clears it if `info` is malformed.
/datum/controller/subsystem/tts/proc/apply_voice_info(list/info)
	voice_labels = list()
	random_voices = list()
	voice_aliases = list()
	supported_styles = list()
	supported_sounds = list()
	instruction_enabled = FALSE
	rate_enabled = FALSE
	custom_voices_enabled = FALSE
	voice_info_loaded = TRUE
	if(!islist(info) || !islist(info["voices"]))
		return FALSE

	for(var/list/voice in info["voices"])
		var/voice_id = voice["id"]
		if(!istext(voice_id))
			continue
		var/gender_label = voice["gender"] == "female" ? "女" : "男"
		var/description = voice["description"]
		voice_labels[voice_id] = length(description) ? "[voice["label"]]（[gender_label]·[description]）" : "[voice["label"]]（[gender_label]）"
		if(voice["random"])
			random_voices += voice_id
	var/list/aliases = info["aliases"]
	if(islist(aliases))
		for(var/old_voice in aliases)
			if(istext(old_voice) && istext(aliases[old_voice]))
				voice_aliases[old_voice] = aliases[old_voice]
	if(islist(info["styles"]))
		supported_styles = info["styles"]
	if(islist(info["sounds"]))
		supported_sounds = info["sounds"]
	instruction_enabled = !!info["instruction"]
	rate_enabled = !!info["rate"]
	custom_voices_enabled = !!info["custom_voices"]
	return TRUE

/// Maps a voice ID saved before a voice list change onto the voice that replaced it.
/datum/controller/subsystem/tts/proc/resolve_voice(voice)
	if(!istext(voice))
		return voice
	ensure_voice_info()
	return voice_aliases[voice] || voice

/// Maps each preference choice to a readable label, or returns null when the server provides none.
/// Choices without a label, such as "None", keep their own text.
/datum/controller/subsystem/tts/proc/voice_display_names(list/choices)
	ensure_voice_info()
	if(!length(voice_labels))
		return null
	var/list/display_names = list()
	for(var/choice in choices)
		display_names[choice] = voice_labels[choice] || choice
	return display_names

/// Reduces player-written voice instructions to plain text within the length limit.
/proc/tts_sanitize_instruction(instruction)
	if(!istext(instruction))
		return ""
	var/static/regex/unsafe_characters = regex(@"[\x00-\x1F\x7F\[\]<>]", "g")
	instruction = trim(unsafe_characters.Replace(instruction, " "))
	return copytext_char(instruction, 1, TTS_INSTRUCTION_MAX_LENGTH + 1)

/// Builds the natural-language voice instruction for one message.
/proc/tts_compose_instruction(base_instruction, list/message_mods)
	var/list/parts = list()
	base_instruction = tts_sanitize_instruction(base_instruction)
	if(length(base_instruction))
		parts += base_instruction
	if(message_mods?[MODE_SING])
		parts += TTS_SING_INSTRUCTION
	// A custom say verb no tag covers ("醉醺醺地说", "proudly declares") still says how
	// the line sounds: the model reads it as a direction.
	var/custom_verb = tts_sanitize_instruction(message_mods?[MODE_CUSTOM_SAY_EMOTE])
	if(length(custom_verb) && !tts_match_keyword(custom_verb, GLOB.tts_style_keywords) && !tts_match_keyword(custom_verb, GLOB.tts_sound_keywords))
		parts += "[TTS_VERB_INSTRUCTION][copytext_char(custom_verb, 1, TTS_VERB_INSTRUCTION_MAX_LENGTH + 1)]"
	// The TTS server caps instructions at 100 units, CJK counting double.
	return copytext_char(jointext(parts, "；"), 1, TTS_INSTRUCTION_TOTAL_MAX_LENGTH + 1)

/// Keyword -> control tag for custom say verbs ("sobs*...", "低声*..."). The first match wins,
/// so more specific entries come first. Keywords are specific phrases rather than single
/// characters: custom say verbs are free text, and a loose keyword tags unrelated speech.
GLOBAL_LIST_INIT(tts_style_keywords, list(
	"crying" = list("sob", "weep", "cries", "crying", "哭", "啜泣", "抽泣", "哽咽"),
	"deep and loud shouting" = list("bellow", "roar", "咆哮", "怒吼"),
	"shouting" = list("shout", "yell", "scream", "holler", "喊", "吼", "尖叫"),
	"angry" = list("angr", "furious", "snarl", "growl", "hiss", "生气", "愤怒", "恼火", "怒"),
	"panicked" = list("panic", "frantic", "惊慌", "慌张", "惊恐"),
	"trembling" = list("trembl", "shaki", "shaky", "shiver", "stammer", "stutter", "颤", "发抖", "哆嗦", "结巴"),
	"whispers" = list("whisper", "murmur", "mutter", "hush", "耳语", "低语", "低声", "悄声", "小声", "嘀咕"),
	"sad" = list("sad", "sorrow", "mourn", "glum", "悲", "难过", "伤心", "沮丧"),
	"excited" = list("excit", "cheer", "兴奋", "激动", "欢呼"),
	"amazed" = list("amaz", "marvel", "astonish", "惊叹", "赞叹", "惊讶"),
	"sarcastic" = list("sarcas", "mock", "讽", "阴阳怪气"),
	"scornful" = list("scorn", "sneer", "disdain", "contempt", "轻蔑", "鄙夷", "不屑"),
	"mischievously" = list("mischiev", "teas", "playful", "smirk", "调皮", "坏笑", "狡黠"),
	"curious" = list("curious", "wonder", "inquir", "好奇", "疑惑"),
	"bored" = list("bored", "无聊"),
	"tired" = list("tired", "weary", "wearily", "exhaust", "yawn", "sleepy", "疲惫", "疲倦", "累", "哈欠"),
	"reluctantly" = list("reluctant", "grudging", "不情愿", "勉强"),
	"empathetic" = list("comfort", "sooth", "consol", "sympath", "安慰", "温柔", "体贴"),
	"serious" = list("serious", "stern", "grave", "solemn", "严肃", "郑重", "严厉"),
	"like dracula" = list("ominous", "sinister", "menac", "阴森", "阴沉", "阴恻恻"),
	"asmr" = list("asmr"),
	"very slowly" = list("slowly", "drawl", "缓缓", "慢吞吞", "慢慢"),
	"very fast" = list("quickly", "rapid", "hurried", "飞快", "急促", "连珠炮"),
))

/// Keyword -> nonverbal sound tag for custom say verbs, played before the line.
GLOBAL_LIST_INIT(tts_sound_keywords, list(
	"giggles" = list("giggl", "chuckl", "titter", "咯咯", "偷笑", "轻笑", "窃笑"),
	"laughing" = list("laugh", "cackl", "guffaw", "大笑", "哈哈", "狂笑", "笑出声"),
	"sighing" = list("sigh", "叹气", "叹息", "叹了口气", "长叹"),
	"cough" = list("cough", "咳"),
	"gasp" = list("gasp", "倒吸", "喘"),
	"clears throat" = list("throat", "清嗓", "清了清嗓"),
	"snorts" = list("snort", "scoff", "嗤之以鼻", "嗤笑", "冷哼", "哼了一声"),
))

/// Returns the first tag in `table` with a keyword found in `text`, or null.
/proc/tts_match_keyword(text, list/table)
	if(!length(text))
		return null
	for(var/tag_name in table)
		for(var/keyword in table[tag_name])
			if(findtext(text, keyword))
				return tag_name
	return null

/// Picks TTS tags matching how a message is said. Returns list(style, sound); either may be null.
/// Does not check what the TTS server supports; see tts_expression_body().
/proc/tts_detect_expression(message, list/message_mods)
	var/custom_verb = message_mods?[MODE_CUSTOM_SAY_EMOTE]
	var/style = tts_match_keyword(custom_verb, GLOB.tts_style_keywords)
	var/sound = tts_match_keyword(custom_verb, GLOB.tts_sound_keywords)
	if(!style)
		var/whisper_mode = message_mods?[WHISPER_MODE]
		if(whisper_mode == MODE_WHISPER_CRIT)
			style = "trembling"
		else if(whisper_mode)
			style = "whispers"
		else if(istext(message) && lang_yell_ending(message))
			style = "shouting"
	return list(style, sound)

/// Builds the optional expressive fields of a TTS request body, keeping only what the server supports.
/proc/tts_expression_body(style, sound, instruction, rate)
	. = list()
	if(!SStts)
		return
	if(style && (style in SStts.supported_styles))
		.["style"] = style
	if(sound && (sound in SStts.supported_sounds))
		.["sound"] = sound
	if(SStts.instruction_enabled && length(instruction))
		.["instruction"] = instruction
	if(SStts.rate_enabled && isnum(rate) && rate != 1)
		.["rate"] = clamp(rate, 0.5, 2)

/// Custom say verbs offered by the mood picker in the chat box. Picking one both reads in chat
/// and changes how the line is voiced: through a tag when a keyword above matches, otherwise
/// as a spoken direction (see tts_compose_instruction).
GLOBAL_LIST_INIT(tts_mood_verbs, list(
	"低声说",
	"大喊",
	"怒吼道",
	"生气地说",
	"哭着说",
	"伤心地说",
	"颤抖着说",
	"惊慌地说",
	"兴奋地说",
	"惊叹道",
	"好奇地问",
	"严肃地说",
	"温柔地说",
	"讽刺地说",
	"不屑地说",
	"调皮地说",
	"疲惫地说",
	"无聊地说",
	"不情愿地说",
	"阴森地说",
	"缓缓说道",
	"飞快地说",
	"大笑着说",
	"咯咯笑着说",
	"叹气道",
	"咳嗽着说",
	"倒吸一口气",
	"清了清嗓子说",
	"嗤笑道",
	"哽咽着说",
	"喘着气说",
	"结结巴巴地说",
	// No tag for these: they reach the model as a spoken direction.
	"轻声说",
	"冷冷地说",
	"骄傲地说",
	"得意地说",
	"害羞地说",
	"紧张地说",
	"焦急地说",
	"冷静地说",
	"委屈地说",
	"撒娇地说",
	"神秘地说",
	"慵懒地说",
	"醉醺醺地说",
	"含糊不清地说",
	"机械地说",
))
