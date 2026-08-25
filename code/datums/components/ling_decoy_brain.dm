// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/// Component applied to ling brains to make them into decoy brains, as ling brains are vestigial and don't do anything
/datum/component/ling_decoy_brain
	/// The ling this brain is linked to
	VAR_FINAL/datum/antagonist/changeling/parent_ling
	/// A talk action that is granted to the ling when this decoy enters an MMI
	VAR_FINAL/datum/action/changeling/mmi_talk/talk_action

/datum/component/ling_decoy_brain/Initialize(datum/antagonist/changeling/ling)
	if(!istype(parent, /obj/item/organ/brain))
		return COMPONENT_INCOMPATIBLE
	if(isnull(ling))
		stack_trace("[type] instantiated without a changeling to link to.")
		return COMPONENT_INCOMPATIBLE

	parent_ling = ling
	RegisterSignal(parent_ling, COMSIG_QDELETING, PROC_REF(clear_decoy))

/datum/component/ling_decoy_brain/Destroy()
	UnregisterSignal(parent_ling, COMSIG_QDELETING)
	parent_ling = null
	QDEL_NULL(talk_action)
	return ..()

/datum/component/ling_decoy_brain/RegisterWithParent()
	var/obj/item/organ/brain/ling_brain = parent
	ling_brain.organ_flags &= ~ORGAN_VITAL
	ling_brain.decoy_override = TRUE
	RegisterSignal(ling_brain, COMSIG_ATOM_ENTERING, PROC_REF(entered_mmi))

/datum/component/ling_decoy_brain/UnregisterFromParent()
	var/obj/item/organ/brain/ling_brain = parent
	ling_brain.organ_flags |= ORGAN_VITAL
	ling_brain.decoy_override = FALSE
	UnregisterSignal(ling_brain, COMSIG_ATOM_ENTERING, PROC_REF(entered_mmi))

/**
 * Signal proc for [COMSIG_ATOM_ENTERING], when the brain enters an MMI grant the MMI talk action to the ling
 *
 * Unfortunately this is hooked on Entering rather than its own dedicated MMI signal becuase MMI code is a fuck
 */
/datum/component/ling_decoy_brain/proc/entered_mmi(obj/item/organ/brain/source, atom/entering, atom/old_loc, ...)
	SIGNAL_HANDLER

	var/mob/living/the_real_ling = parent_ling.owner.current
	if(!istype(the_real_ling))
		return

	if(istype(source.loc, /obj/item/mmi) && talk_action?.owner != the_real_ling)
		if(isnull(talk_action))
			talk_action = new() // Not linked to anything, we manage the reference (and don't want it disappearing on us)
			talk_action.brain_ref = source

		if(the_real_ling.key)
			to_chat(the_real_ling, span_ghostalert(LANG("datum.71cdfe0f0677b650", null)))
		else
			the_real_ling.notify_revival("Your decoy brain has been placed in an MMI, re-enter your body to talk via it!", source = the_real_ling, flashwindow = TRUE)
		talk_action.Grant(the_real_ling)

	else if(talk_action?.owner == the_real_ling)
		to_chat(the_real_ling, span_ghostalert(LANG("datum.be9ef7a86708f54d", null)))
		talk_action.Remove(the_real_ling)

/// Clear up the decoy if the ling is de-linged
/datum/component/ling_decoy_brain/proc/clear_decoy(datum/source)
	SIGNAL_HANDLER

	qdel(src)
