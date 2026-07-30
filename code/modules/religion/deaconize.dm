// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/**
 * Deaconize
 * Makes a sentient, non-cult member of the station into a Holy person, able to use bibles & other chap gear.
 * Is a one-time use ability, given to all sects that don't have their own variation of it.
 */
/datum/religion_rites/deaconize
	name = "Deaconize"
	desc = "Converts someone to your sect. They must be willing, so the first invocation will only prompt them to join. \
		They will gain the same holy abilities as you. This is a one-time use rite, so make sure they are worthy!"
	ritual_length = 30 SECONDS
	ritual_invocations = list(
		"A good, honorable person has been brought here by faith ...",
		"With their hands ready to serve ...",
		"Heart ready to listen ...",
		"And soul ready to follow ...",
		"May we offer our own hand in return ..."
	)
	invoke_msg = "And use them to the best of our abilities."
	rite_flags = RITE_ALLOW_MULTIPLE_PERFORMS | RITE_ONE_TIME_USE

	///The person currently being deaconized.
	var/mob/living/carbon/human/potential_deacon

/datum/religion_rites/deaconize/Destroy()
	potential_deacon = null
	return ..()

/datum/religion_rites/deaconize/perform_rite(mob/living/user, atom/religious_tool)
	if(!ismovable(religious_tool))
		to_chat(user, span_warning(LANG("datum.3ebb81f1", null)))
		return FALSE
	var/atom/movable/movable_reltool = religious_tool
	if(!movable_reltool)
		return FALSE
	var/mob/living/carbon/human/possible_deacon = locate() in movable_reltool.buckled_mobs
	if(!possible_deacon)
		to_chat(user, span_warning(LANG("datum.a6a1bafe", list(movable_reltool))))
		return FALSE
	if(!is_valid_for_deacon(possible_deacon, user))
		return FALSE
	//no one invited or this is not the invited person
	if(!potential_deacon || (possible_deacon != potential_deacon))
		INVOKE_ASYNC(src, PROC_REF(invite_deacon), possible_deacon)
		to_chat(user, span_notice(LANG("datum.0f66cc40", null)))
		return FALSE
	return ..()

/datum/religion_rites/deaconize/invoke_effect(mob/living/carbon/human/user, atom/movable/religious_tool)
	. = ..()
	if(!(potential_deacon in religious_tool.buckled_mobs)) //checks one last time if the right corpse is still buckled
		to_chat(user, span_warning(LANG("datum.22df2f6f", list(potential_deacon))))
		return FALSE
	if(IS_UNCONSCIOUS_OR_CRIT(potential_deacon))
		to_chat(user, span_warning(LANG("datum.ac29acd6", list(potential_deacon))))
		return FALSE
	if(!potential_deacon.mind)
		to_chat(user, span_warning(LANG("datum.c2f1007d", list(potential_deacon))))
		return FALSE
	if(IS_CULTIST(potential_deacon))//what the fuck?!
		to_chat(user, span_warning(LANG("datum.fdd51c58", list(GLOB.deity, potential_deacon))))
		playsound(get_turf(religious_tool), 'sound/effects/pray.ogg', 50, TRUE)
		potential_deacon.gib(DROP_ORGANS|DROP_BODYPARTS)
		return FALSE
	var/datum/brain_trauma/special/honorbound/honor = user.has_trauma_type(/datum/brain_trauma/special/honorbound)
	if(honor && (potential_deacon in honor.guilty))
		honor.guilty -= potential_deacon
	to_chat(user, span_notice(LANG("datum.fe642873", list(GLOB.deity, potential_deacon))))
	potential_deacon.mind.set_holy_role(HOLY_ROLE_DEACON)
	GLOB.religious_sect.on_conversion(potential_deacon)
	playsound(get_turf(religious_tool), 'sound/effects/pray.ogg', 50, TRUE)
	return TRUE

///Helper if the passed possible_deacon is valid to become a deacon or not.
/datum/religion_rites/deaconize/proc/is_valid_for_deacon(mob/living/carbon/human/possible_deacon, mob/living/user)
	if(IS_UNCONSCIOUS_OR_CRIT(possible_deacon))
		to_chat(user, span_warning(LANG("datum.fb95a707", list(possible_deacon))))
		return FALSE
	if(possible_deacon.mind && possible_deacon.mind.holy_role)
		to_chat(user, span_warning(LANG("datum.87f5b616", list(possible_deacon))))
		return FALSE
	return TRUE

/**
 * Async proc that waits for a response on joining the sect.
 * If they accept, the deaconize rite can now recruit them instead of just offering more invites.
 */
/datum/religion_rites/deaconize/proc/invite_deacon(mob/living/carbon/human/invited)
	var/ask = tgui_alert(invited, LANG("datum.25f265b3", list(GLOB.deity)), LANG("datum.5d69f114", null), list("Yes", "No"), 60 SECONDS)
	if(ask != "Yes")
		return
	potential_deacon = invited
