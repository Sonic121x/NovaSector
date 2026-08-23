// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/action/cooldown/mob_cooldown/shell_retreat
	name = "Shell Retreat"
	desc = "Retreat to your shell!"
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
		span_danger(LANG("datum.45de441bc42e7acd", list(owner))),
		span_userdanger(LANG("datum.f7bbb70233ea3900", null)),
	)
	REMOVE_TRAIT(owner, TRAIT_SHELL_RETREATED, REF(src))
	UnregisterSignal(owner, list(COMSIG_MOVABLE_ATTEMPTED_MOVE, COMSIG_LIVING_DEATH))
	owner.update_appearance(UPDATE_ICON_STATE)

/datum/action/cooldown/mob_cooldown/shell_retreat/proc/retreat_into_shell()
	owner.visible_message(
		span_danger(LANG("datum.d0aa95a31e8b8d1f", list(owner))),
		span_userdanger(LANG("datum.98bc13bef6148e97", null)),
	)
	RegisterSignals(owner, list(COMSIG_LIVING_DEATH, COMSIG_MOVABLE_ATTEMPTED_MOVE), PROC_REF(unretreat_from_shell))
	ADD_TRAIT(owner, TRAIT_SHELL_RETREATED, REF(src))
	owner.update_appearance(UPDATE_ICON_STATE)
