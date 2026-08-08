// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/religion_rites/deaconize/dreamers
	desc = "Converts someone to your sect. They must be willing, so the first invocation will only prompt them to join. \
		They will gain the same holy abilities as you. You can deaconize up to three followers, so choose wisely!"
	rite_flags = parent_type::rite_flags & ~RITE_ONE_TIME_USE

/datum/religion_rites/deaconize/dreamers/invoke_effect(mob/living/carbon/human/user, atom/movable/religious_tool)
	if(HAS_TRAIT(potential_deacon, TRAIT_NIGHTMARISH))
		to_chat(user, span_warning(LANG("datum.bb5ebc92", list(potential_deacon, GLOB.deity))))
		return FALSE
	return ..()

/datum/religion_rites/deaconize/dreamers/post_invoke_effects(mob/living/user, atom/religious_tool)
	. = ..()
	if(!istype(GLOB.religious_sect, /datum/religion_sect/dreams))
		return

	var/datum/religion_sect/dreams/sect = GLOB.religious_sect
	sect.deacon_count += 1
	if(sect.deacon_count >= sect.max_deacons)
		sect.rites_list -= type
