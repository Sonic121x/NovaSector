//These are all minor mutations that affect your speech somehow.
//Individual ones aren't commented since their functions should be evident at a glance
// no they arent bro


/datum/mutation/nervousness
	name = "紧张"
	desc = "导致持有者口吃。"
	instability = NEGATIVE_STABILITY_MINI
	quality = MINOR_NEGATIVE
	text_gain_indication = span_danger("你感到紧张。")

/datum/mutation/nervousness/on_life(seconds_per_tick)
	if(SPT_PROB(5, seconds_per_tick))
		owner.set_stutter_if_lower(20 SECONDS)

/datum/mutation/wacky
	name = "滑稽"
	desc = "你不是小丑。你是整个马戏团。"
	instability = NEGATIVE_STABILITY_MINI
	quality = MINOR_NEGATIVE
	text_gain_indication = span_sans(span_notice("你感到声带里有一种异样的感觉。"))
	text_lose_indication = span_notice("异样的感觉过去了。")

/datum/mutation/wacky/on_acquiring(mob/living/carbon/human/owner)
	. = ..()
	if(!.)
		return
	RegisterSignal(owner, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/mutation/wacky/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	UnregisterSignal(owner, COMSIG_MOB_SAY)

/datum/mutation/wacky/proc/handle_speech(datum/source, list/speech_args)
	SIGNAL_HANDLER

	speech_args[SPEECH_SPANS] |= SPAN_SANS

/datum/mutation/heckacious
	name = "赫卡修斯·拉林克斯"
	desc = "伙计，你的话到底在WISH什么啊..........."
	quality = MINOR_NEGATIVE
	text_gain_indication = span_sans("啊，操蛋。你的喉咙感觉像他妈的一坨屎。")
	text_lose_indication = span_notice("占据你喉部的恶魔实体终于松开了它的掌控。")
	locked = TRUE

/datum/mutation/heckacious/on_acquiring(mob/living/carbon/human/owner)
	. = ..()
	if(!.)
		return
	RegisterSignal(owner, COMSIG_LIVING_TREAT_MESSAGE, PROC_REF(handle_caps))
	RegisterSignal(owner, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/mutation/heckacious/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	UnregisterSignal(owner, list(COMSIG_LIVING_TREAT_MESSAGE, COMSIG_MOB_SAY))

/datum/mutation/heckacious/proc/handle_caps(atom/movable/source, list/message_args)
	SIGNAL_HANDLER
	message_args[TREAT_CAPITALIZE_MESSAGE] = FALSE

/datum/mutation/heckacious/proc/handle_speech(datum/source, list/speech_args)

	var/message = speech_args[SPEECH_MESSAGE]
	if(!message)
		return
	// Split for swapping purposes
	message = " [message] "

	// Splitting up each word in the text to manually apply our intended changes
	var/list/message_words = splittext(message, " ")
	// What we use in the end
	var/list/edited_message_words

	for(var/editing_word in message_words)
		if(editing_word == " " || editing_word == "" )
			continue
		// Used to replace the original later
		var/og_word = editing_word
		// Iterating through each replaceable-string in the .json
		var/static/list/super_wacky_words = strings("heckacious.json", "heckacious")

		// If the word doesn't get replaced we might do something with it later
		var/word_edited
		for(var/key in super_wacky_words)
			var/value = super_wacky_words[key]
			// If list, pick one value from said list
			if(islist(value))
				value = pick(value)
			editing_word = replacetextEx(editing_word, "[uppertext(key)]", "[uppertext(value)]")
			editing_word = replacetextEx(editing_word, "[capitalize(key)]", "[capitalize(value)]")
			editing_word = replacetextEx(editing_word, "[key]", "[value]")
			// Enable if we actually found something to change
			if(editing_word != og_word)
				word_edited = TRUE

		// Random caps
		if(prob(10))
			editing_word = prob(85) ? uppertext(editing_word) : LOWER_TEXT(editing_word)
		// some times....... we add DOTS...
		if(prob(10))
			for(var/dotnum in 1 to rand(2, 8))
				editing_word += "."
		// change for bold/italics/underline as well!
		if(prob(10))
			var/extra_emphasis = pick("+", "_", "|")
			editing_word = extra_emphasis + editing_word + extra_emphasis

		// If no replacement we do it manually
		if(!word_edited)
			if(prob(65))
				editing_word = replacetext(editing_word, pick(VOWELS), pick(VOWELS))
			// Many more consonants, double it!
			for(var/i in 1 to rand(1, 2))
				editing_word = replacetext(editing_word, pick(CONSONANTS), pick(CONSONANTS))
			// rarely, lettter is DOUBBLED...
			var/patchword = ""
			for(var/letter in 1 to length(editing_word))
				if(prob(92))
					patchword += editing_word[letter]
					continue
				patchword += replacetext(editing_word[letter], "", editing_word[letter] + editing_word[letter])
			editing_word = patchword

		LAZYADD(edited_message_words, editing_word)

	var/edited_message = jointext(edited_message_words, " ")

	message = trim(edited_message)

	speech_args[SPEECH_MESSAGE] = message

/datum/mutation/mute
	name = "失语"
	desc = "完全抑制大脑的语言中枢。"
	instability = NEGATIVE_STABILITY_MAJOR
	quality = NEGATIVE
	text_gain_indication = span_danger("你感到完全无法表达自己。")
	text_lose_indication = span_danger("你感到又能自由说话了。")

/datum/mutation/mute/on_acquiring(mob/living/carbon/human/owner)
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_MUTE, GENETIC_MUTATION)

/datum/mutation/mute/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	REMOVE_TRAIT(owner, TRAIT_MUTE, GENETIC_MUTATION)

/datum/mutation/unintelligible
	name = "语无伦次"
	desc = "部分抑制大脑的语言中枢，严重扭曲言语。"
	instability = NEGATIVE_STABILITY_MODERATE
	quality = NEGATIVE
	text_gain_indication = span_danger("你似乎无法形成任何连贯的思绪！")
	text_lose_indication = span_danger("你的思维感觉更清晰了。")

/datum/mutation/unintelligible/on_acquiring(mob/living/carbon/human/owner)
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_UNINTELLIGIBLE_SPEECH, GENETIC_MUTATION)

/datum/mutation/unintelligible/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	REMOVE_TRAIT(owner, TRAIT_UNINTELLIGIBLE_SPEECH, GENETIC_MUTATION)

/datum/mutation/swedish
	name = "瑞典语"
	desc = "一种源自遥远过去的可怕突变。在2037年事件后被认为已根除。"
	instability = NEGATIVE_STABILITY_MINI
	quality = MINOR_NEGATIVE
	text_gain_indication = span_notice("你感觉自己很瑞典，不管这是怎么实现的。")
	text_lose_indication = span_notice("瑞典的感觉消退了。")
	var/static/list/language_mutilation = list("w" = "v", "j" = "y", "bo" = "bjo", "a" = list("å","ä","æ","a"), "o" = list("ö","ø","o"))

/datum/mutation/swedish/New(datum/mutation/copymut)
	. = ..()
	AddComponent(/datum/component/speechmod, replacements = language_mutilation, end_string = list("",", bork",", bork, bork"), end_string_chance = 30)

/datum/mutation/chav
	name = "小混混"
	desc = "未知"
	instability = NEGATIVE_STABILITY_MINI
	quality = MINOR_NEGATIVE
	text_gain_indication = span_notice("你感觉自己像个十足的傻瓜，对吧？")
	text_lose_indication = span_notice("你不再想表现得粗鲁和刻薄了。")

/datum/mutation/chav/New(datum/mutation/copymut)
	. = ..()
	AddComponent(/datum/component/speechmod, replacements = strings("chav_replacement.json", "chav"), end_string = ", mate", end_string_chance = 30)

/datum/mutation/elvis
	name = "猫王"
	desc = "一种以其'零号病人'命名的可怕突变。"
	instability = NEGATIVE_STABILITY_MINI
	quality = MINOR_NEGATIVE
	text_gain_indication = span_notice("你感觉相当不错，亲爱的。")
	text_lose_indication = span_notice("你觉得少说点话会更好。")

/datum/mutation/elvis/New(datum/mutation/copymut)
	. = ..()
	AddComponent(/datum/component/speechmod, replacements = strings("elvis_replacement.json", "elvis"))

/datum/mutation/elvis/on_life(seconds_per_tick)
	switch(pick(1,2))
		if(1)
			if(SPT_PROB(7.5, seconds_per_tick))
				var/list/dancetypes = list("swinging", "fancy", "stylish", "20'th century", "jivin'", "rock and roller", "cool", "salacious", "bashing", "smashing")
				var/dancemoves = pick(dancetypes)
				owner.visible_message("<b>[owner]</b> 秀出了几个[dancemoves]动作！")
		if(2)
			if(SPT_PROB(7.5, seconds_per_tick))
				owner.visible_message("<b>[owner]</b> [pick("jiggles their hips", "rotates their hips", "gyrates their hips", "taps their foot", "dances to an imaginary song", "jiggles their legs", "snaps their fingers")]!")

/datum/mutation/stoner
	name = "Stoner"
	desc = "一种常见的突变，会严重降低智力。"
	quality = NEGATIVE
	text_gain_indication = span_notice("你感觉……完全放松了，伙计！")
	text_lose_indication = span_notice("你感觉对时间的感知更清晰了。")

/datum/mutation/stoner/on_acquiring(mob/living/carbon/human/owner)
	. = ..()
	if(!.)
		return
	owner.grant_language(/datum/language/beachbum, source = LANGUAGE_STONER)
	owner.add_blocked_language(subtypesof(/datum/language) - /datum/language/beachbum, source = LANGUAGE_STONER)

/datum/mutation/stoner/on_losing(mob/living/carbon/human/owner)
	..()
	owner.remove_language(/datum/language/beachbum, source = LANGUAGE_STONER)
	owner.remove_blocked_language(subtypesof(/datum/language) - /datum/language/beachbum, source = LANGUAGE_STONER)

/datum/mutation/medieval
	name = "中世纪"
	desc = "一种源自遥远过去的可怕突变，据信曾是旧世界欧洲所有地区的一种常见基因。"
	instability = NEGATIVE_STABILITY_MINI
	quality = MINOR_NEGATIVE
	text_gain_indication = span_notice("你感觉想要寻找圣杯！")
	text_lose_indication = span_notice("你不再有寻求任何事物的欲望了。")

/datum/mutation/medieval/on_acquiring(mob/living/carbon/human/owner)
	. = ..()
	if(!.)
		return
	RegisterSignal(owner, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/mutation/medieval/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	UnregisterSignal(owner, COMSIG_MOB_SAY)

/datum/mutation/medieval/proc/handle_speech(datum/source, list/speech_args)
	SIGNAL_HANDLER

	var/message = speech_args[SPEECH_MESSAGE]
	if(message)
		message = " [message] "
		var/list/medieval_words = strings("medieval_replacement.json", "medieval")
		var/list/startings = strings("medieval_replacement.json", "startings")
		for(var/key in medieval_words)
			var/value = medieval_words[key]
			if(islist(value))
				value = pick(value)
			if(uppertext(key) == key)
				value = uppertext(value)
			if(capitalize(key) == key)
				value = capitalize(value)
			message = replacetextEx(message,regex("\b[REGEX_QUOTE(key)]\b","ig"), value)
		message = trim(message)
		var/chosen_starting = pick(startings)
		message = "[chosen_starting] [message]"

		speech_args[SPEECH_MESSAGE] = message

/datum/mutation/piglatin
	name = "猪拉丁语"
	desc = "历史学家说，在2020年代，人类完全使用这种神秘的语言交流。"
	instability = NEGATIVE_STABILITY_MINI
	quality = MINOR_NEGATIVE
	text_gain_indication = span_notice("感觉有点不对劲。")
	text_lose_indication = span_notice("那种关闭的感觉消退了。")

/datum/mutation/piglatin/on_acquiring(mob/living/carbon/human/owner)
	. = ..()
	if(!.)
		return
	RegisterSignal(owner, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/mutation/piglatin/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	UnregisterSignal(owner, COMSIG_MOB_SAY)

/datum/mutation/piglatin/proc/handle_speech(datum/source, list/speech_args)
	SIGNAL_HANDLER

	var/spoken_message = speech_args[SPEECH_MESSAGE]
	spoken_message = piglatin_sentence(spoken_message)
	speech_args[SPEECH_MESSAGE] = spoken_message
