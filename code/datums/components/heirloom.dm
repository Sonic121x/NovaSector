// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/// Heirloom component. For use with the family heirloom quirk, tracks that an item is someone's family heirloom.
/datum/component/heirloom
	/// The mind that actually owns our heirloom.
	var/datum/mind/owner
	/// Flavor. The family name of the owner of the heirloom.
	var/family_name

/datum/component/heirloom/Initialize(new_owner, new_family_name)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE

	owner = new_owner
	family_name = new_family_name

	RegisterSignal(parent, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))

/datum/component/heirloom/Destroy(force)
	owner = null
	return ..()

/**
 * Signal proc for [COMSIG_ATOM_EXAMINE].
 *
 * Shows who owns the heirloom on examine.
 */
/datum/component/heirloom/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	var/datum/mind/examiner_mind = user.mind

	if(examiner_mind == owner)
		examine_list += span_notice(LANG("datum.4b0a5416a1d50c7f", list(family_name)))
		return

	var/datum/antagonist/obsessed/our_creeper = examiner_mind?.has_antag_datum(/datum/antagonist/obsessed)
	if(our_creeper?.trauma.obsession == owner)
		examine_list += span_nicegreen(LANG("datum.0f41debb74a9f4a1", list(owner)))
		return

	examine_list += span_notice(LANG("datum.536b6eacee81ab04", list(family_name, owner)))
