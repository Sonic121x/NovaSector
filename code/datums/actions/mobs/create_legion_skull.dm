/datum/action/cooldown/mob_cooldown/create_legion_skull
	name = "创造军团颅骨"
	button_icon = 'icons/mob/simple/lavaland/lavaland_monsters.dmi'
	button_icon_state = "legion_head"
	desc = "创造一个军团颅骨来追击指定的敌人"
	cooldown_time = 2 SECONDS

/datum/action/cooldown/mob_cooldown/create_legion_skull/Activate(atom/target_atom)
	disable_cooldown_actions()
	create(target_atom)
	StartCooldown()
	enable_cooldown_actions()
	return TRUE

/// Creates a new skull assigned to the owner of this action
/datum/action/cooldown/mob_cooldown/create_legion_skull/proc/create(atom/target)
	var/mob/living/basic/mining/legion_brood/minion = new(owner.loc)
	minion.assign_creator(owner)
	minion.ai_controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET] = target
