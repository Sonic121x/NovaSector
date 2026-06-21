/datum/language/codespeak
	name = "密语"
	desc = "辛迪加操作员可以使用一系列暗语来传递复杂的信息，而对于任何监听者来说，这些暗语听起来就像是随机的概念和饮料。"
	key = "t"
	default_priority = 0
	flags = TONGUELESS_SPEECH | LANGUAGE_HIDE_ICON_IF_NOT_UNDERSTOOD
	icon_state = "codespeak"
	always_use_default_namelist = TRUE // No syllables anyways

/datum/language/codespeak/scramble_sentence(input, list/mutual_languages)
	var/sentence = read_word_cache(input)
	if(sentence)
		return sentence

	sentence = ""
	var/list/words = list()
	while(length_char(sentence) < length_char(input))
		words += generate_code_phrase(return_list=TRUE)
		sentence = jointext(words, ", ")

	sentence = capitalize(sentence)

	sentence += find_last_punctuation(input)

	write_word_cache(input, sentence)

	return sentence
