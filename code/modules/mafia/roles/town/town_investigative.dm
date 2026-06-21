/datum/mafia_role/detective
	name = "侦探"
	desc = "你可以在每个夜晚调查一个人来了解他们的阵营。"
	revealed_outfit = /datum/outfit/mafia/detective
	role_type = TOWN_INVEST
	winner_award = /datum/award/achievement/mafia/detective

	hud_icon = SECHUD_DETECTIVE
	revealed_icon = "detective"

	role_unique_actions = list(/datum/mafia_ability/investigate)

/datum/mafia_role/psychologist
	name = "心理学家"
	desc = "你可以在整场游戏中拜访某人一次，于次日早晨揭示其真实角色！"
	revealed_outfit = /datum/outfit/mafia/psychologist
	role_type = TOWN_INVEST
	winner_award = /datum/award/achievement/mafia/psychologist

	hud_icon = SECHUD_PSYCHOLOGIST
	revealed_icon = "psychologist"

	role_unique_actions = list(/datum/mafia_ability/reveal_role)

/datum/mafia_role/coroner
	name = "验尸官"
	desc = "你可以在每晚对死者进行尸检，以发现其角色。"
	revealed_outfit = /datum/outfit/mafia/coroner
	role_type = TOWN_INVEST
	hud_icon = SECHUD_CORONER
	revealed_icon = "coroner"
	winner_award = /datum/award/achievement/mafia/coroner

	role_unique_actions = list(/datum/mafia_ability/autopsy)
