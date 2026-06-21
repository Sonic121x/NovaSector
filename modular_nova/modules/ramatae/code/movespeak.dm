/datum/language/ramatae
	name = "动作语"
	desc = "一种主要由身体动作、手势和手语构成，仅偶尔夹杂鸣叫或其他发声的非语言。如果没有其肢体动作部分，几乎完全无法理解。"
	key = "M"
	flags = TONGUELESS_SPEECH
	space_chance = 30
	syllables = list(
		"wa", "wawa", "awa", "a"
	)
	icon = 'modular_nova/master_files/icons/misc/language.dmi'
	icon_state = "movespeak"
	default_priority = 80

	default_name_syllable_min = 5
	default_name_syllable_max = 10
