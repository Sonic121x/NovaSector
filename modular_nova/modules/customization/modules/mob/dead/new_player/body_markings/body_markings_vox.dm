/datum/body_marking/secondary/vox
	icon = 'modular_nova/master_files/icons/mob/body_markings/vox_secondary.dmi'
	recommended_species = list(SPECIES_VOX = 1)

/datum/body_marking/secondary/vox/vox
	name = "沃克斯爪痕"
	icon_state = "vox"
	affected_bodyparts = ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT | LEG_RIGHT | LEG_LEFT

/datum/body_marking/tertiary/vox
	recommended_species = list(SPECIES_VOX = 1)
	icon = 'modular_nova/master_files/icons/mob/body_markings/vox_tertiary.dmi'

/datum/body_marking/tertiary/vox/tiger
	name = "沃克斯虎纹刺青"
	icon_state = "voxtiger"
	affected_bodyparts = CHEST | LEG_RIGHT | LEG_LEFT | ARM_LEFT | ARM_RIGHT

/datum/body_marking/tertiary/vox/hive
	name = "沃克斯蜂巢刺青"
	icon_state = "voxhive"
	affected_bodyparts = CHEST

/datum/body_marking/tertiary/vox/nightling
	name = "沃克斯夜灵刺青"
	icon_state = "voxnightling"
	affected_bodyparts = CHEST | ARM_LEFT | ARM_RIGHT

/datum/body_marking/tertiary/vox/heart
	name = "沃克斯心形刺青"
	icon_state = "voxheart"
	affected_bodyparts = ARM_RIGHT
