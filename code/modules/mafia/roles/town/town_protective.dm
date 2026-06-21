/datum/mafia_role/medical_doctor
	name = "医疗医师"
	desc = "你可以在每晚保护一个人免受杀害。你可以治疗自己一次。"
	revealed_outfit = /datum/outfit/mafia/md
	role_type = TOWN_PROTECT
	hud_icon = SECHUD_MEDICAL_DOCTOR
	revealed_icon = "medicaldoctor"
	winner_award = /datum/award/achievement/mafia/md

	role_unique_actions = list(/datum/mafia_ability/heal)

/datum/mafia_role/security_officer
	name = "安保干员"
	desc = "你可以在每晚保护一个人。如果他们受到攻击，你将进行反击，杀死自己和攻击者。你可以保护自己一次。"
	revealed_outfit = /datum/outfit/mafia/security
	revealed_icon = "securityofficer"
	hud_icon = SECHUD_SECURITY_OFFICER
	role_type = TOWN_PROTECT
	role_flags = ROLE_CAN_KILL
	winner_award = /datum/award/achievement/mafia/officer

	role_unique_actions = list(/datum/mafia_ability/heal/defend)
