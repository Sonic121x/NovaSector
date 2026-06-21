///Blocks the implantee from being teleported
/obj/item/implant/teleport_blocker
	name = "蓝空间接地植入体"
	desc = "将你的蓝空间特征锚定在基准现实中，管它到底是什么意思。"
	actions_types = null
	implant_flags = IMPLANT_TYPE_SECURITY
	hud_icon_state = "hud_imp_noteleport"

	implant_info = "Automatically activates upon implantation. \
		Grounds users' bluespace signatures, preventing jaunting and/or teleportation."

	implant_lore = "The Robust Corp BG-001-EXP is a subcutaneous, experimental bluespace counter-resonance \
		frequency generator, designed to firmly ground an implantee's bluespace signature in baseline reality. \
		In layman's terms, it counteracts attempts to slip into bluespace or similar gaps in reality, \
		generating a dissonant frequency that interferes with the attempt, resulting in temporary paralysis. \
		Test subjects report that the interference feels like slamming into a wall, with none of the \
		physical trauma of actually slamming into a wall. Preliminary reports indicate that this \
		would likely be useful for keeping especially slippery prisoners in place."

/obj/item/implant/teleport_blocker/implant(mob/living/target, mob/user, silent = FALSE, force = FALSE)
	. = ..()
	if(!. || !isliving(target))
		return FALSE
	RegisterSignal(target, COMSIG_MOVABLE_TELEPORTING, PROC_REF(on_teleport))
	RegisterSignal(target, COMSIG_MOB_PRE_JAUNT, PROC_REF(on_jaunt))
	return TRUE

/obj/item/implant/teleport_blocker/removed(mob/target, silent = FALSE, special = FALSE)
	. = ..()
	if(!. || !isliving(target))
		return FALSE
	UnregisterSignal(target, COMSIG_MOVABLE_TELEPORTING)
	UnregisterSignal(target, COMSIG_MOB_PRE_JAUNT)
	return TRUE

/// Signal for COMSIG_MOVABLE_TELEPORTING that blocks teleports and stuns the would-be-teleportee.
/obj/item/implant/teleport_blocker/proc/on_teleport(mob/living/teleportee, atom/destination, channel)
	SIGNAL_HANDLER

	to_chat(teleportee, span_holoparasite("你感觉自己正在传送，但突然被猛地拽回了原地！"))

	teleportee.apply_status_effect(/datum/status_effect/incapacitating/paralyzed, 5 SECONDS)
	do_sparks(5, TRUE, teleportee, spark_type = /datum/effect_system/basic/spark_spread/quantum)
	return TRUE

/// Signal for COMSIG_MOB_PRE_JAUNT that prevents a user from entering a jaunt.
/obj/item/implant/teleport_blocker/proc/on_jaunt(mob/living/jaunter)
	SIGNAL_HANDLER

	to_chat(jaunter, span_holoparasite("当你试图灵体穿梭时，你一头撞上了现实之间的屏障，被猛地抛回了物质世界！"))

	jaunter.apply_status_effect(/datum/status_effect/incapacitating/paralyzed, 5 SECONDS)
	do_sparks(5, TRUE, jaunter, spark_type = /datum/effect_system/basic/spark_spread/quantum)
	return COMPONENT_BLOCK_JAUNT

/obj/item/implantcase/teleport_blocker
	name = "植入体盒 - '蓝空间接地'"
	desc = "一个装有蓝空间接地植入体的玻璃盒。"
	imp_type = /obj/item/implant/teleport_blocker
