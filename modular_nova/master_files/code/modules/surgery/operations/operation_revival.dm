// DNR TRAIT - need this so that people don't just keep spamming the revival surgery; it runs success just bc the surgery steps are done
/datum/surgery_operation/basic/revival/on_failure(mob/living/patient, mob/living/surgeon, obj/item/tool, list/operation_args)
	if(HAS_TRAIT(patient, TRAIT_DNR))
		patient.visible_message(span_warning("...[patient.p_they()] 一动不动[patient.p_s()]，毫无反应。进一步的尝试是徒劳的，patient.p_theyre() 已经走了。"))
		patient.adjust_organ_loss(ORGAN_SLOT_BRAIN, 50, 199) // MAD SCIENCE
	else
		return ..()
