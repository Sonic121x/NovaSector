/// Gibs the target
/datum/smite/gib
	name = "Gib-分尸"

/datum/smite/gib/effect(client/user, mob/living/target)
	. = ..()
	target.gib(DROP_ORGANS|DROP_BODYPARTS)

/datum/smite/gib/divine
	name = "粉碎（神圣）"
	smite_flags = SMITE_DIVINE|SMITE_DELAY|SMITE_STUN
