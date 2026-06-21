/datum/mafia_role/hos
	name = "安全主管"
	desc = "你可以在夜间决定处决某人，杀死并揭示其角色。如果他们是无辜的，你将在下一个夜晚开始时死亡。"
	role_type = TOWN_KILLING
	role_flags = ROLE_CAN_KILL | ROLE_UNIQUE
	revealed_outfit = /datum/outfit/mafia/hos
	revealed_icon = "headofsecurity"
	hud_icon = SECHUD_HEAD_OF_SECURITY
	winner_award = /datum/award/achievement/mafia/hos

	role_unique_actions = list(/datum/mafia_ability/attack_player/execution)

/datum/mafia_role/warden
	name = "典狱长"
	desc = "你可以在夜间进行一次封锁，杀死所有来访者，包括镇民成员。"

	role_type = TOWN_KILLING
	role_flags = ROLE_CAN_KILL
	revealed_outfit = /datum/outfit/mafia/warden
	revealed_icon = "warden"
	hud_icon = SECHUD_WARDEN
	winner_award = /datum/award/achievement/mafia/warden

	role_unique_actions = list(/datum/mafia_ability/attack_visitors)
