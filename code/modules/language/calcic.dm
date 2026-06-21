/datum/language/calcic
	name = "骨语"
	desc = "等离子人那断断续续、断断续续的语言。就连骷髅也能听懂。"
	key = "b"
	space_chance = 10
	sentence_chance = 2
	between_word_sentence_chance = 10
	between_word_space_chance = 75
	additional_syllable_low = 0
	additional_syllable_high = 1
	syllables = list(
		"k", "ck", "ack", "ick", "cl", "tk", "sk", "isk", "tak",
		"kl", "hs", "ss", "ks", "lk", "dk", "gk", "ka", "ska", "la", "pk",
		"wk", "ak", "ik", "ip", "ski", "bk", "kb", "ta", "is", "it", "li", "di",
		"ds", "ya", "sck", "crk", "hs", "ws", "mk", "aaa", "skraa", "skee", "hss",
		"raa", "klk", "tk", "stk", "clk"
	)
	icon_state = "calcic"
	default_priority = 90

/datum/language/calcic/get_random_name(
	gender = NEUTER,
	name_count = default_name_count,
	syllable_min = default_name_syllable_min,
	syllable_max = default_name_syllable_max,
	force_use_syllables = FALSE,
)
	if(force_use_syllables)
		return ..()

	return "[pick(GLOB.plasmaman_names)] \Roman[rand(1, 99)]"

// Yeah, this goes to skeletons too, since it's basically just skeleton clacking.
