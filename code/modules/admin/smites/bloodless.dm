// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/// Slashes up the target
/datum/smite/bloodless
	name = ":B:loodless"

/datum/smite/bloodless/effect(client/user, mob/living/target)
	. = ..()
	if (!iscarbon(target))
		to_chat(user, span_warning(LANG("datum.0c41c4cfc5eec94d", null)), confidential = TRUE)
		return
	var/mob/living/carbon/carbon_target = target
	for(var/_limb in carbon_target.get_bodyparts())
		var/obj/item/bodypart/limb = _limb // fine to use this raw, its a meme smite
		var/type_wound = pick(list(/datum/wound/slash/flesh/severe, /datum/wound/slash/flesh/moderate))
		limb.force_wound_upwards(type_wound, smited = TRUE)
		type_wound = pick(list(/datum/wound/slash/flesh/critical, /datum/wound/slash/flesh/severe, /datum/wound/slash/flesh/moderate))
		limb.force_wound_upwards(type_wound, smited = TRUE)
		type_wound = pick(list(/datum/wound/slash/flesh/critical, /datum/wound/slash/flesh/severe))
		limb.force_wound_upwards(type_wound, smited = TRUE)
