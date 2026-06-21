/datum/mutation/telepathy
	name = "心灵感应"
	desc = "一种罕见的突变，允许使用者与他人进行心灵感应交流。"
	quality = POSITIVE
	text_gain_indication = span_notice("你能听到自己的声音在脑海中回荡！")
	text_lose_indication = span_notice("你不再听到脑海中的回声了。")
	difficulty = 12
	power_path = /datum/action/cooldown/spell/list_target/telepathy
	instability = POSITIVE_INSTABILITY_MINOR // basically a mediocre PDA messager
	energy_coeff = 1
