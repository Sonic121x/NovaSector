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
		examine_list += span_notice("这是你珍贵的[family_name]家族传家宝。务必保管好！")
		return

	var/datum/antagonist/obsessed/our_creeper = examiner_mind?.has_antag_datum(/datum/antagonist/obsessed)
	if(our_creeper?.trauma.obsession == owner)
		examine_list += span_nicegreen("这一定是[owner]的家族传家宝！闻起来就像他们本人……")
		return

	examine_list += span_notice("这是[family_name]家族的传家宝，属于[owner]。")
