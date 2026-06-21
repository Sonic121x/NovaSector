/datum/language/drone
	name = "无人机"
	desc = "一个经过高度加密的损害控制协调信息流，其中包含了用于帽子的特殊标识。"
	spans = list(SPAN_ROBOT)
	key = "d"
	flags = NO_STUTTER
	syllables = list(".", "|")
	// ...|..||.||||.|.||.|.|.|||.|||
	space_chance = 0
	sentence_chance = 0
	between_word_sentence_chance = 0
	between_word_space_chance = 0
	additional_syllable_low = 0
	additional_syllable_high = 0
	default_priority = 20

	icon_state = "drone"
	always_use_default_namelist = TRUE // Nonsense language
