/datum/action/cooldown/mob_cooldown/shell_retreat
	name = "缩回壳中"
	desc = "缩回你的壳里！"
	cooldown_time = 5 SECONDS
	click_to_activate = FALSE
	button_icon = 'icons/mob/simple/pets.dmi'
	button_icon_state = "snail_shell"

/datum/action/cooldown/mob_cooldown/shell_retreat/Activate(atom/target)
	. = ..()
	HAS_TRAIT(owner, TRAIT_SHELL_RETREATED) ? unretreat_from_shell() : retreat_into_shell()

/datum/action/cooldown/mob_cooldown/shell_retreat/proc/unretreat_from_shell()
	SIGNAL_HANDLER

	owner.visible_message(
		span_danger("[owner] 缓缓从壳中探出头来！"),
		span_userdanger("你从壳中探出头来。"),
	)
	REMOVE_TRAIT(owner, TRAIT_SHELL_RETREATED, REF(src))
	UnregisterSignal(owner, list(COMSIG_MOVABLE_ATTEMPTED_MOVE, COMSIG_LIVING_DEATH))
	owner.update_appearance(UPDATE_ICON_STATE)

/datum/action/cooldown/mob_cooldown/shell_retreat/proc/retreat_into_shell()
	owner.visible_message(
		span_danger("[owner] 迅速缩回了壳里！"),
		span_userdanger("你躲进了壳里.."),
	)
	RegisterSignals(owner, list(COMSIG_LIVING_DEATH, COMSIG_MOVABLE_ATTEMPTED_MOVE), PROC_REF(unretreat_from_shell))
	ADD_TRAIT(owner, TRAIT_SHELL_RETREATED, REF(src))
	owner.update_appearance(UPDATE_ICON_STATE)
