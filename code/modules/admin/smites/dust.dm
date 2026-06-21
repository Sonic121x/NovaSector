/datum/smite/dust
	name = "尘化"

/datum/smite/dust/effect(client/user, mob/living/target)
	. = ..()
	target.dust(just_ash = FALSE, drop_items = TRUE, force = TRUE)

/datum/smite/dust/divine
	name = "尘化（神圣）"
	smite_flags = SMITE_DIVINE|SMITE_DELAY|SMITE_STUN
