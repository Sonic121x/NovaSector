// The language of the podpeople. Yes, it's a shameless ripoff of elvish.
/datum/language/sylvan
	name = "植物语"
	desc = "一种复杂而古老的语言，由有感知能力的植物所使用。"
	key = "h"
	space_chance = 10
	sentence_chance = 0
	between_word_sentence_chance = 10
	between_word_space_chance = 50
	additional_syllable_low = 1
	additional_syllable_high = 2
	syllables = list(
		"fii", "sii", "rii", "rel", "maa", "ala", "san", "tol", "tok", "dia", "eres",
		"fal", "tis", "bis", "qel", "aras", "losk", "rasa", "eob", "hil", "tanl", "aere",
		"fer", "bal", "pii", "dala", "ban", "foe", "doa", "cii", "uis", "mel", "wex",
		"incas", "int", "elc", "ent", "aws", "qip", "nas", "vil", "jens", "dila", "fa",
		"la", "re", "do", "ji", "ae", "so", "qe", "ce", "na", "mo", "ha", "yu"
	)
	icon_state = "plant"
	default_priority = 90
	default_name_syllable_min = 2
	default_name_syllable_max = 3
