/**
 *  Returns a list of lines containing silicon flavourtext, temporary flavourtext, ERP preferences and a link to "look closer" and open the examine panel.
 *  Intended to be appended at the end of examine() result.
 */
/mob/living/silicon/proc/get_silicon_flavortext(mob/user)
	. = list()
	var/flavor_text_link
	/// The first 1-FLAVOR_PREVIEW_LIMIT characters in the mob's client's silicon_flavor_text preference datum. FLAVOR_PREVIEW_LIMIT is defined in flavor_defines.dm.
	var/silicon_preview_text = copytext_char((client?.prefs.read_preference(/datum/preference/text/silicon_flavor_text)), 1, FLAVOR_PREVIEW_LIMIT)

	flavor_text_link = span_notice("[silicon_preview_text]... <a href='byond://?src=[REF(src)];lookup_info=open_examine_panel'>Look closer?</a>")

	if (flavor_text_link)
		. += flavor_text_link

	if (client?.prefs.read_preference(/datum/preference/text/character_ad))
		. += span_notice(LANG("mob.d28e157aeae8e88b", list(p_They(), p_have(), REF(src))))

	if(client)
		var/erp_status_pref = client.prefs.read_preference(/datum/preference/choiced/erp_status)
		if(erp_status_pref && !CONFIG_GET(flag/disable_erp_preferences) && user.client.prefs.read_preference(/datum/preference/toggle/master_erp_preferences))
			. += span_notice(LANG("mob.fcbd7345954a8713", list(span_revenboldnotice(erp_status_pref))))

/*	if (!CONFIG_GET(flag/disable_antag_opt_in_preferences))
		var/antag_opt_in_status = mind?.get_effective_antag_opt_in_level()
		if (!isnull(antag_opt_in_status))
			var/stringified_optin = GLOB.antag_opt_in_strings["[antag_opt_in_status]"]
			. += span_notice("Dynamic Opt-In: <b><font color='[GLOB.antag_opt_in_colors[stringified_optin]]'>[stringified_optin]</font></b>")
*/
	if (!CONFIG_GET(flag/disable_conflict_opt_in_preferences))
		var/conflict_opt_in_status = mind?.get_effective_conflict_opt_in_level()
		if (!isnull(conflict_opt_in_status))
			var/stringified_optin = GLOB.conflict_opt_in_strings["[conflict_opt_in_status]"]
			. += span_notice(LANG("mob.8ecdd7825ae7706b", list(GLOB.conflict_opt_in_colors[stringified_optin], stringified_optin)))

	if(temporary_flavor_text)
		if(length_char(temporary_flavor_text) <= 40)
			. += span_notice(LANG("mob.1f5220b9de12e14e", list(p_They(), p_s(), temporary_flavor_text)))
		else
			. += span_notice(LANG("mob.164e0c69763100e4", list(p_They(), p_s(), copytext_char(temporary_flavor_text, 1, 37), REF(src))))
