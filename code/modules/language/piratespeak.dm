/datum/language/piratespeak
	name = "海盗语"
	desc = "太空海盗所用的语言。"
	key = "p"
	space_chance = 100
	sentence_chance = 10
	between_word_sentence_chance = 10
	between_word_space_chance = 75
	additional_syllable_low = -2
	additional_syllable_high = -1
	default_priority = 90
	syllables = list(
		"arr", "ahoy", "rum", "aye", "blimey", "booty", "bucko", "grog", "treasure",
		"me", "scallywag", "landlubber", "poopdeck", "ye", "avast",
		"shiver", "timbers", "matey", "swashbuckler"
	)
	icon_state = "pirate"
	always_use_default_namelist = TRUE
