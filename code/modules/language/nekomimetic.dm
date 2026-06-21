/datum/language/nekomimetic
	name = "猫语"
	desc = "在普通观察者看来，这种语言是一团难以理解的破碎日语。但对猫人族来说，它却莫名其妙地可以理解。"
	key = "f"
	space_chance = 15
	sentence_chance = 0
	between_word_sentence_chance = 10
	between_word_space_chance = 75
	additional_syllable_low = -1
	additional_syllable_high = 1
	syllables = list(
		"neko", "nyan", "mimi", "moe", "mofu", "fuwa", "kyaa", "kawaii", "poka", "munya",
		"puni", "munyu", "ufufu", "uhuhu", "icha", "doki", "kyun", "kusu", "nya", "nyaa",
		"desu", "kis", "ama", "chuu", "baka", "hewo", "boop", "gatto", "kit", "sune", "yori", //NOVA EDIT gatto
		"sou", "baka", "chan", "san", "kun", "mahou", "yatta", "suki", "usagi", "domo", "ori",
		"uwa", "zaazaa", "shiku", "puru", "ira", "heto", "etto"
	)
	icon_state = "neko"
	default_priority = 90
	default_name_syllable_min = 2
	default_name_syllable_max = 2

/datum/language/nekomimetic/get_random_name(
	gender = NEUTER,
	name_count = default_name_count,
	syllable_min = default_name_syllable_min,
	syllable_max = default_name_syllable_max,
	force_use_syllables = FALSE,
)
	if(prob(33))
		return default_name(gender)
	return ..()
