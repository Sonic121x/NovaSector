/datum/mafia_role/lawyer
	name = "律师"
	desc = "你可以选择一个人提供广泛的法律建议，阻止其夜间行动。"
	revealed_outfit = /datum/outfit/mafia/lawyer
	role_type = TOWN_SUPPORT
	hud_icon = SECHUD_LAWYER
	revealed_icon = "lawyer"
	winner_award = /datum/award/achievement/mafia/lawyer

	role_unique_actions = list(/datum/mafia_ability/roleblock)

/datum/mafia_role/hop
	name = "人事主管"
	desc = "你可以在整场游戏中揭示自己一次，使你的投票权变为三倍，但变得无法被保护！"
	role_type = TOWN_SUPPORT
	role_flags = ROLE_UNIQUE
	role_flags = ROLE_CAN_KILL
	hud_icon = SECHUD_HEAD_OF_PERSONNEL
	revealed_icon = "headofpersonnel"
	revealed_outfit = /datum/outfit/mafia/hop
	winner_award = /datum/award/achievement/mafia/hop

	role_unique_actions = list(/datum/mafia_ability/self_reveal)

/datum/mafia_role/chaplain
	name = "牧师"
	desc = "你可以在每晚与死者的灵魂沟通，以发现已死亡船员的角色。"
	role_type = TOWN_INVEST
	team = MAFIA_TEAM_TOWN | MAFIA_TEAM_DEAD
	hud_icon = SECHUD_CHAPLAIN
	revealed_icon = "chaplain"
	revealed_outfit = /datum/outfit/mafia/chaplain
	winner_award = /datum/award/achievement/mafia/chaplain

	role_unique_actions = list(/datum/mafia_ability/seance)
