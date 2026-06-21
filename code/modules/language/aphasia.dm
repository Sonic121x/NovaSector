/datum/language/aphasia
	name = "语无伦次"
	desc = "有一种理论认为，任何大脑受损程度足够严重的人都能够使用这种语言进行交流。"
	flags = LANGUAGE_HIDE_ICON_IF_NOT_UNDERSTOOD
	key = "i"
	syllables = list("m","n","gh","h","l","s","r","a","e","i","o","u")
	space_chance = 0
	sentence_chance = 0
	between_word_sentence_chance = 10
	between_word_space_chance = 75
	additional_syllable_low = 0
	additional_syllable_high = 0
	default_priority = 10
	icon_state = "aphasia"
	always_use_default_namelist = TRUE // Shouldn't generate names for this anyways
