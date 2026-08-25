// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/// Gives the target critically bad wounds
/datum/smite/boneless
	name = ":B:oneless"

/datum/smite/boneless/effect(client/user, mob/living/target)
	. = ..()

	if (!iscarbon(target))
		to_chat(user, span_warning(LANG("datum.0c41c4cfc5eec94d", null)), confidential = TRUE)
		return

	var/mob/living/carbon/carbon_target = target
	for(var/obj/item/bodypart/limb as anything in carbon_target.get_bodyparts())
		var/severity = pick_weight(alist(
			WOUND_SEVERITY_MODERATE = 1,
			WOUND_SEVERITY_SEVERE = 2,
			WOUND_SEVERITY_CRITICAL = 2,
		))
		carbon_target.cause_wound_of_type_and_severity(WOUND_BLUNT, limb, severity)
