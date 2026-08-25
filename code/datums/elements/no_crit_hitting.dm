// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/// Stops a mob from hitting someone in crit. doesn't account for projectiles or spells
/datum/element/no_crit_hitting

/datum/element/no_crit_hitting/Attach(datum/target)
	. = ..()

	if(!isliving(target))
		return ELEMENT_INCOMPATIBLE

	RegisterSignals(target, list(COMSIG_MOB_ITEM_ATTACK), PROC_REF(check_attack))

/datum/element/no_crit_hitting/proc/check_attack(mob/living/attacker, atom/attacked)
	SIGNAL_HANDLER

	if(!isliving(attacked))
		return

	var/mob/living/liver = attacked
	if(liver.stat == HARD_CRIT)
		liver.balloon_alert(attacker, LANG("datum.90d16b60c5bd6333", null))
		return COMPONENT_CANCEL_ATTACK_CHAIN
