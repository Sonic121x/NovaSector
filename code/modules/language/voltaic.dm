// One of these languages will actually work, I'm certain of it.
/datum/language/voltaic
	name = "电流语"
	desc = "一种通过控制电火花来实现的灵活语言。"
	key = "v"
	space_chance = 20
	sentence_chance = 0
	between_word_sentence_chance = 10
	between_word_space_chance = 75
	additional_syllable_low = 0
	additional_syllable_high = 1
	syllables = list(
		"bzzt", "skrrt", "zzp", "mmm", "hzz", "tk", "shz", "k", "z",
		"bzt", "zzt", "skzt", "skzz", "hmmt", "zrrt", "hzzt", "hz",
		"vzt", "zt", "vz", "zip", "tzp", "lzzt", "dzzt", "zdt", "kzt",
		"zzzz", "mzz"
	)
	icon_state = "volt"
	default_priority = 90
	default_name_syllable_min = 2
	default_name_syllable_max = 3


/datum/language/voltaic/get_random_name(
	gender = NEUTER,
	name_count = default_name_count,
	syllable_min = default_name_syllable_min,
	syllable_max = default_name_syllable_max,
	force_use_syllables = FALSE,
)
	if(force_use_syllables)
		return ..()

	var/picked = "[pick(GLOB.ethereal_names)] [random_capital_letter()]"
	if(prob(65))
		picked += random_capital_letter()
	return picked
