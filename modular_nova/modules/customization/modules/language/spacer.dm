/datum/language/spacer
	name = "太空人语"
	desc = "一种粗糙、非正式的语言，当尝试使用更规范的语言建立对话失败且没有自动翻译器可用时，作为最后手段使用。它严重依赖语调、肢体语言、手势以及大量克里奥尔语借词。尽管其使用多年来已严重减少，但仍有一定数量的边疆船员在使用它，并受到自由贸易联盟的青睐。"
	key = "j"
	flags = TONGUELESS_SPEECH
	sentence_chance = 10
	between_word_sentence_chance = 10
	between_word_space_chance = 75
	additional_syllable_low = 0
	additional_syllable_high = 1
	syllables = list(
		"ada", "zir", "bian", "ach", "usk", "ado", "ich", "cuan", "iga", "qing", "le", "que", "ki", "qaf", "dei", "eta"
	)
	icon_state = "spacer"
	icon = 'modular_nova/master_files/icons/misc/language.dmi'
	default_priority = 50
