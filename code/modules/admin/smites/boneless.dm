/// Gives the target critically bad wounds
/datum/smite/boneless
	name = ":B:碎骨"

/datum/smite/boneless/effect(client/user, mob/living/target)
	. = ..()

	if (!iscarbon(target))
		to_chat(user, span_warning("必须对碳基生物使用。"), confidential = TRUE)
		return

	var/mob/living/carbon/carbon_target = target
	for(var/obj/item/bodypart/limb as anything in carbon_target.get_bodyparts())
		var/severity = pick_weight(alist(
			WOUND_SEVERITY_MODERATE = 1,
			WOUND_SEVERITY_SEVERE = 2,
			WOUND_SEVERITY_CRITICAL = 2,
		))
		carbon_target.cause_wound_of_type_and_severity(WOUND_BLUNT, limb, severity)
