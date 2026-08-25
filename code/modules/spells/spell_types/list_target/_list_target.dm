// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/**
 * ## List Target spells
 *
 * These spells will prompt the user with a tgui list
 * of all nearby targets that they select on to cast.
 *
 * To add effects on cast, override "cast(atom/cast_on)".
 * The cast_on atom is the atom that was selected by the list.
 */
/datum/action/cooldown/spell/list_target
	/// The message displayed as the title of the tgui target input list.
	var/choose_target_message = "Choose a target."
	/// Radius around the caster that living targets are picked to choose from
	var/target_radius = 7

/datum/action/cooldown/spell/list_target/PreActivate(atom/caster)
	var/list/list_targets = get_list_targets(caster, target_radius)
	if(!length(list_targets))
		caster.balloon_alert(caster, LANG("datum.41e497a406158c8b", null))
		return FALSE

	var/atom/chosen = tgui_input_list(caster, choose_target_message, name, sort_names(list_targets))
	if(QDELETED(src) || QDELETED(caster) || QDELETED(chosen) || !can_cast_spell())
		return FALSE

	if(get_dist(chosen, caster) > target_radius)
		caster.balloon_alert(caster, LANG("datum.d000a673ca4d930e", null))
		return FALSE

	return Activate(chosen)

/// Get a list of living targets in radius of the center to put in the target list.
/datum/action/cooldown/spell/list_target/proc/get_list_targets(atom/center, target_radius = 7)
	var/list/things = list()
	for(var/mob/living/nearby_living in view(target_radius, center))
		if(nearby_living == owner || nearby_living == center)
			continue

		things += nearby_living

	return things
