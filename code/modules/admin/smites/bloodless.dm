/// Slashes up the target
/datum/smite/bloodless
	name = ":B:血洪水"

/datum/smite/bloodless/effect(client/user, mob/living/target)
	. = ..()
	if (!iscarbon(target))
		to_chat(user, span_warning("必须对碳基生物使用。"), confidential = TRUE)
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
